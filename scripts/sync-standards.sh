#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# sync-standards.sh – Verteilt Standards aus project-templates in Projekte.
#
# Synchronisiert:
#   • Claude Commands  → .claude/commands/   (überschreibt – gewollt, Issue #7)
#   • .editorconfig    → Projekt-Root (Basis)
#   • GLOBAL POLICY    → CLAUDE.md   (idempotenter Marker-Block, NIE Überschreiben)
#
# NICHT synchronisiert:
#   • .prettierrc.json – bleibt repo-lokal (Issue #93). Wird nur angelegt, wenn
#     im Zielprojekt noch keine existiert.
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
  # Führt Kommando + Argumente direkt aus (kein eval → kein Injection-/Quoting-Risiko).
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "   [dry-run] $*"
  else
    "$@"
  fi
}

# Ersetzt den GLOBAL-POLICY-Marker-Block in einer CLAUDE.md idempotent.
# Schreibt atomar (mktemp + mv) und ersetzt den Block AN ORT UND STELLE.
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

  local has_start=0 has_end=0
  grep -Fq "$MARKER_START" "$claude_file" && has_start=1
  grep -Fq "$MARKER_END"   "$claude_file" && has_end=1

  # Beschädigt: nur START ohne END → NICHT bis EOF löschen (würde lokale Inhalte
  # fressen). Sicher überspringen und melden, statt Datenverlust zu riskieren.
  if [ "$has_start" -eq 1 ] && [ "$has_end" -eq 0 ]; then
    echo "   ⚠️  START-Marker ohne END in $claude_file – manuell reparieren. Übersprungen (kein Datenverlust)."
    return
  fi

  if [ "$has_start" -eq 1 ] && [ "$has_end" -eq 1 ]; then
    echo "   ↻ Ersetze GLOBAL-POLICY-Block an Ort und Stelle (Rest unberührt)"
    [ "$DRY_RUN" -eq 0 ] || return 0
    local tmp blockfile
    tmp="$(mktemp "${claude_file}.XXXXXX")"
    # Mehrzeiligen Block über eine Datei einspeisen – awk -v verträgt keine
    # Newlines (BSD awk bricht mit "newline in string" ab). Ersetzung an Ort
    # und Stelle: an Startposition Block-Datei ausgeben, alten Block bis END verwerfen.
    blockfile="$(mktemp)"
    printf '%s\n' "$block" > "$blockfile"
    awk -v s="$MARKER_START" -v e="$MARKER_END" -v bf="$blockfile" '
      $0 ~ s { while ((getline line < bf) > 0) print line; close(bf); skip=1; next }
      $0 ~ e { skip=0; next }
      skip!=1 { print }
    ' "$claude_file" > "$tmp" && mv "$tmp" "$claude_file" || { rm -f "$tmp" "$blockfile"; return 1; }
    rm -f "$blockfile"
  else
    echo "   + Hänge GLOBAL-POLICY-Block einmalig an (CLAUDE.md sonst unberührt)"
    [ "$DRY_RUN" -eq 0 ] || return 0
    local tmp
    tmp="$(mktemp "${claude_file}.XXXXXX")"
    {
      cat "$claude_file"
      printf '\n%s\n' "$block"
    } > "$tmp" && mv "$tmp" "$claude_file" || { rm -f "$tmp"; return 1; }
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
    run mkdir -p "$project_dir/.claude/commands"
    # Glob wird hier (nicht in run) expandiert → cp erhält echte Dateiargumente.
    run cp "$ROOT_DIR"/claude-commands/*.md "$project_dir/.claude/commands/"
    echo "   ✓ Claude Commands synchronisiert"
  else
    echo "   • Keine claude-commands/*.md vorhanden – übersprungen"
  fi

  # 2. Basis-Konfig – EditorConfig
  #
  # .prettierrc.json wird BEWUSST NICHT synchronisiert (Issue #93):
  # Jedes Repo hat eine historisch gewachsene, in sich stimmige Config. Ein
  # Überschreiben würde einen repoweiten Reformat-Diff erzeugen, dessen Nutzen
  # bei einem Solo-Entwickler gegen null geht (kein Merge-Konflikt-Risiko durch
  # fremde Configs, keine Style-Reviews). Nur angelegt, wenn noch gar keine
  # Config existiert – dann als sinnvoller Startwert.
  if [ -f "$project_dir/.prettierrc.json" ]; then
    echo "   • .prettierrc.json vorhanden – bewusst unangetastet (Issue #93)"
  else
    run cp "$ROOT_DIR/dev-standards/base/.prettierrc.json" "$project_dir/.prettierrc.json"
    echo "   ✓ .prettierrc.json neu angelegt (kein Bestand vorhanden)"
  fi
  run cp "$ROOT_DIR/dev-standards/base/.editorconfig" "$project_dir/.editorconfig"
  echo "   ✓ .editorconfig synchronisiert"

  # 3. GLOBAL POLICY – idempotenter Marker-Block, CLAUDE.md bleibt sonst unberührt
  sync_policy_block "$project_dir/CLAUDE.md"

  # 4. Security-Scanning – Dependabot + CodeQL (Issue #109)
  #
  # Die Vorlagen lagen seit Issue #60 in automation-templates/, wurden aber nur
  # "zum Kopieren" bereitgestellt und landeten dadurch in 21 von 23 Repos nie.
  # Hier NUR anlegen, wenn nichts vorhanden ist – analog zur Prettier-Logik:
  # bestehende, repo-spezifisch angepasste Fassungen (z. B. paths-ignore für
  # Daten-Commits) dürfen nicht überschrieben werden.
  #
  # Hinweis: dependabot.yml steuert nur Update-PRs. Die Security-*Alerts* sind
  # ein serverseitiger Repo-Schalter und werden hier NICHT gesetzt:
  #   gh api -X PUT repos/<slug>/vulnerability-alerts
  #   gh api -X PUT repos/<slug>/automated-security-fixes
  if [ -f "$project_dir/.github/dependabot.yml" ]; then
    echo "   • .github/dependabot.yml vorhanden – unangetastet"
  else
    run mkdir -p "$project_dir/.github"
    run cp "$ROOT_DIR/automation-templates/dependabot.yml" "$project_dir/.github/dependabot.yml"
    echo "   ✓ .github/dependabot.yml neu angelegt (npm-Block ggf. entfernen)"
  fi

  # CodeQL nur für Repos mit JS/TS-Code – die Vorlage deklariert
  # javascript-typescript; für reine Python-/Arduino-Repos wäre sie wirkungslos.
  if [ -f "$project_dir/package.json" ]; then
    if [ -f "$project_dir/.github/workflows/codeql.yml" ]; then
      echo "   • codeql.yml vorhanden – unangetastet"
    else
      run mkdir -p "$project_dir/.github/workflows"
      run cp "$ROOT_DIR/automation-templates/codeql.yml" "$project_dir/.github/workflows/codeql.yml"
      echo "   ✓ .github/workflows/codeql.yml neu angelegt"
    fi
  else
    echo "   • Kein package.json – CodeQL (javascript-typescript) übersprungen"
  fi
}

for project in "${PROJECTS[@]}"; do
  copy_to_project "$project"
done

cat <<'NOTE'

✅ Sync abgeschlossen.

ℹ️  .prettierrc.json wurde in bestehenden Projekten NICHT angefasst (Issue #93).
   Jedes Repo behält seine eigene, in sich stimmige Formatierung. Kein
   repoweiter `prettier --write`-Lauf nötig – und ausdrücklich nicht erwünscht,
   weil er die git-blame-Historie praktisch jeder Zeile überschreiben würde.
NOTE
