#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# migrate-to-v2.sh – Migriert ein Downstream-Repo auf das v2-Review-Modell:
#   • kostenloses Merge-Gate via mergeability.yml (setzt review-gate, keine API-Kosten)
#   • optionaler, beratender KI-Review via pr-review.yml (on-demand, Label "ai-review")
#
# Arbeitet auf einem LOKALEN Klon des Ziel-Repos (wie sync-standards.sh). Die
# Workflow-Dateien werden hineinkopiert; Commit/PR machst du anschließend selbst
# (gegen `testing`, nie direkt `main`).
#
# Usage:
#   ./migrate-to-v2.sh [--dry-run] <owner/repo> </abs/pfad/zum/klon>
#
# Beispiel:
#   ./migrate-to-v2.sh S540d/safe-my-plants ~/code/safe-my-plants
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TPL_DIR="$ROOT_DIR/automation-templates"

DRY_RUN=0
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) ARGS+=("$arg") ;;
  esac
done

REPO="${ARGS[0]:?owner/repo erforderlich, z.B. S540d/safe-my-plants}"
CLONE="${ARGS[1]:?Pfad zum lokalen Klon erforderlich}"

[ -d "$CLONE/.git" ] || { echo "❌ Kein Git-Klon: $CLONE"; exit 1; }
[ -f "$TPL_DIR/mergeability.yml" ] || { echo "❌ Template fehlt: $TPL_DIR/mergeability.yml"; exit 1; }
[ -f "$TPL_DIR/pr-review.yml" ]    || { echo "❌ Template fehlt: $TPL_DIR/pr-review.yml"; exit 1; }

run() { if [ "$DRY_RUN" -eq 1 ]; then echo "   [dry-run] $*"; else "$@"; fi; }

echo "→ Migration $REPO  (Klon: $CLONE)"

# 1) Workflows einspielen.
run mkdir -p "$CLONE/.github/workflows"
run cp "$TPL_DIR/mergeability.yml" "$CLONE/.github/workflows/mergeability.yml"
echo "   ✓ mergeability.yml (kostenloses Gate, @v2)"
run cp "$TPL_DIR/pr-review.yml" "$CLONE/.github/workflows/pr-review.yml"
echo "   ✓ pr-review.yml (optional, on-demand Label 'ai-review', @v2)"

# 2) Labels setzen (idempotent; ergänzt 'ai-review').
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  run "$SCRIPT_DIR/setup-labels.sh" "$REPO"
  echo "   ✓ Labels gesetzt (inkl. 'ai-review')"
else
  echo "   ⚠️  gh nicht verfügbar/authentifiziert – Labels manuell: ./setup-labels.sh $REPO"
fi

cat <<NOTE

✅ Dateien eingespielt$([ "$DRY_RUN" -eq 1 ] && echo " (dry-run – nichts geschrieben)").

Nächste Schritte (im Klon $CLONE):
  1. Feature-Branch + Commit + PR gegen 'testing':
       git checkout -b chore/review-v2
       git add .github/workflows/mergeability.yml .github/workflows/pr-review.yml
       git commit -m "chore: kostenloses Merge-Gate + on-demand KI-Review (v2)"
       git push -u origin chore/review-v2
       gh pr create --base testing --title "chore: Review-Modell v2" --body "Kostenloses Gate + on-demand KI-Review"
  2. Im PR prüfen: Mergeability-Kommentar erscheint, Status 'review-gate' wird gesetzt.
  3. ANTHROPIC_API_KEY ist NUR noch für den optionalen 'ai-review'-Lauf nötig – sonst
     entfernbar (Gate & /review-Abo brauchen ihn nicht).
  4. Branch-Protection: sicherstellen, dass 'review-gate' als required Status-Check
     gelistet ist (Context unverändert) – siehe scripts/apply-rulesets.sh.

⚠️ Erst nachdem 'mergeability' im Repo einmal lief, 'review-gate' als required
   aktiviert lassen – sonst wartet GitHub auf einen nie laufenden Check.
NOTE
