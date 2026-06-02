#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# sync-standards.sh – Verteilt Standards aus project-templates in Projekte.
#
# Synchronisiert:
#   • Claude Commands  → .claude/commands/   (überschreibt – gewollt, Issue #7)
#   • .prettierrc.json + .editorconfig → Projekt-Root (Basis)
#   • GLOBAL POLICY    → CLAUDE.md   (idempotenter Marker-Block, NIE Überschreiben)
#
# CLAUDE.md-Schutz (Issue #7, Entscheidung Maintainer):
#   Lokale CLAUDE.md darf NICHT überschrieben werden. Nur der Bereich zwischen
#   <!-- GLOBAL POLICY:START --> und <!-- GLOBAL POLICY:END --> wird ersetzt.
#   Existiert kein Marker, wird der Block EINMALIG ans Ende angehängt.
#   Mehrfaches Ausführen ist idempotent (keine Duplikate, Updates greifen).
#
# Usage:
#   ./sync-standards.sh [--dry-run] /abs/path/projectA [/abs/path/projectB ...]
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

DRY_RUN=0
PROJECTS=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) PROJECTS+=("$arg") ;;
  esac
done

if [ "${#PROJECTS[@]}" -eq 0 ]; then
  echo "Usage: $0 [--dry-run] /abs/path/project [/abs/path/project2 ...]"
  exit 1
fi

MARKER_START="<!-- GLOBAL POLICY:START -->"
MARKER_END="<!-- GLOBAL POLICY:END -->"

# Policy-Text liegt als eigene Datei vor (Single Source of Truth).
POLICY_FILE="$ROOT_DIR/dev-standards/base/global-policy.md"
[ -f "$POLICY_FILE" ] || { echo "❌ Policy-Datei fehlt: $POLICY_FILE"; exit 1; }
POLICY_BODY="$(cat "$POLICY_FILE")"

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "   [dry-run] $*"
  else
    eval "$@"
  fi
}

# Ersetzt den GLOBAL-POLICY-Marker-Block in einer CLAUDE.md idempotent.
sync_policy_block() {
  local claude_file="$1"
  local block
  block="${MARKER_START}"$'\n'"${POLICY_BODY}"$'\n'"${MARKER_END}"

  if [ ! -f "$claude_file" ]; then
    echo "   ⚠️  Keine CLAUDE.md – lege Minimal-Datei mit Policy-Block an: $claude_file"
    if [ "$DRY_RUN" -eq 0 ]; then
      printf '%s\n' "$block" > "$claude_file"
    fi
    return
  fi

  if grep -Fq "$MARKER_START" "$claude_file"; then
    echo "   ↻ Aktualisiere bestehenden GLOBAL-POLICY-Block (Rest unberührt)"
    if [ "$DRY_RUN" -eq 0 ]; then
      local tmp
      tmp="$(mktemp)"
      # Alles ohne den alten Block + ohne nachlaufende Leerzeilen (kein Aufstauen
      # von Leerzeilen über mehrere Läufe), dann genau eine Leerzeile + Block.
      awk -v s="$MARKER_START" -v e="$MARKER_END" '
        $0 ~ s {skip=1; next}
        $0 ~ e {skip=0; next}
        skip==1 {next}
        # Leerzeilen puffern und erst vor echtem Inhalt ausgeben → trimmt das Ende
        /^[[:space:]]*$/ {blank++; next}
        { while (blank-- > 0) print ""; blank=0; print }
      ' "$claude_file" > "$tmp"
      {
        cat "$tmp"
        printf '\n%s\n' "$block"
      } > "$claude_file"
      rm -f "$tmp"
    fi
  else
    echo "   + Hänge GLOBAL-POLICY-Block einmalig an (CLAUDE.md sonst unberührt)"
    if [ "$DRY_RUN" -eq 0 ]; then
      printf '\n\n%s\n' "$block" >> "$claude_file"
    fi
  fi
}

copy_to_project() {
  local project_dir="$1"

  if [ ! -d "$project_dir" ]; then
    echo "⚠️  Überspringe (kein Verzeichnis): $project_dir"
    return
  fi

  echo "→ Sync: $project_dir"

  # 1. Claude Commands – überschreiben ist gewollt (Issue #7)
  # (Verzeichnis kommt mit PR B; glob-sicher, falls leer/abwesend.)
  if compgen -G "$ROOT_DIR/claude-commands/*.md" > /dev/null; then
    run "mkdir -p '$project_dir/.claude/commands'"
    run "cp '$ROOT_DIR'/claude-commands/*.md '$project_dir/.claude/commands/'"
    echo "   ✓ Claude Commands synchronisiert"
  else
    echo "   • Keine claude-commands/*.md vorhanden – übersprungen"
  fi

  # 2. Basis-Konfig – Prettier + EditorConfig
  run "cp '$ROOT_DIR/dev-standards/base/.prettierrc.json' '$project_dir/.prettierrc.json'"
  run "cp '$ROOT_DIR/dev-standards/base/.editorconfig' '$project_dir/.editorconfig'"
  echo "   ✓ .prettierrc.json + .editorconfig synchronisiert"

  # 3. GLOBAL POLICY – idempotenter Marker-Block, CLAUDE.md bleibt sonst unberührt
  sync_policy_block "$project_dir/CLAUDE.md"
}

for project in "${PROJECTS[@]}"; do
  copy_to_project "$project"
done

cat <<'NOTE'

✅ Sync abgeschlossen.

⚠️  Prettier-Baseline (Issue #7, Punkt 5):
   Der erste Prettier-Lauf erzeugt große Reformat-Diffs. Pro Projekt EINMALIG
   isoliert committen, NICHT mit Feature-Arbeit mischen:

     npx prettier --write .
     git add -A && git commit -m "style: prettier baseline (project-templates)"
     git rev-parse HEAD >> .git-blame-ignore-revs
     git add .git-blame-ignore-revs && git commit -m "chore: ignore prettier baseline in git blame"
     git config blame.ignoreRevsFile .git-blame-ignore-revs
NOTE
