#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# apply-rulesets.sh – Branch-Protection (Repository Ruleset) auf Repos anwenden.
#
# Zwei getrennte Rulesets pro Repo (Issue #122, seit 2026-09-03 – löst die
# Vorgänger-Entscheidung aus Issue #74 "ein gemeinsames protect-main für
# main+testing" ab):
#   • github-ruleset-protect-main.json    → nur refs/heads/main
#   • github-ruleset-protect-testing.json → nur refs/heads/testing
#   Grund: Ein gemeinsames Ruleset macht bypass_actors unteilbar — man kann
#   einer Automation (z.B. fetch.yml) nicht auf testing etwas erlauben, ohne
#   main mitzuöffnen. Genau das war die strukturelle Ursache von
#   EnergyPriceGermany #446 (13h Datenausfall, weil bypass_actors:[] pauschal
#   auch den Daten-Push blockierte). Getrennte Rulesets erlauben künftig einen
#   Automations-Bypass gezielt nur auf testing (Korrektur 2, noch offen).
#
# Basis-Regel, Open-Source mit Vandalismusschutz (Issue #7, Maintainer-
# Entscheidung):
#   • PR erforderlich (kein Direct-Push auf main/testing)
#   • non_fast_forward + deletion → kein Force-Push, kein Löschen
#   • required_approving_review_count: 0 → Solo-Maintainer kann selbst mergen
#   • bypass_actors: [] – KEIN Admin-Bypass (seit 2026-08-31, s. global-policy.md
#     "Kein Admin-Bypass in bypass_actors" – ein always-Bypass machte die
#     deletion-Regel wirkungslos und führte zum ungewollten Löschen von `testing`
#     bei EnergyPriceGermany PR #404). Nicht wieder hinzufügen.
#
# Merge-Methode (Squash-Default, Merge-Commit erlaubt für Sync-/Release-PRs;
# siehe global-policy.md "Merge-Methode zentral erzwingen"): Rulesets können
# die Merge-Methode selbst nicht einschränken — das ist eine separate
# Repo-Einstellung. Dieses Skript setzt sie deshalb zusätzlich per PATCH auf
# repos/{owner}/{repo}:
#   • allow_squash_merge=true, allow_merge_commit=true, allow_rebase_merge=false
#     → Squash bleibt die Standardauswahl in der Web-UI; „Create a merge
#       commit" bleibt für Sync-/Release-PRs (testing → main) bewusst wählbar,
#       damit die Ancestry zwischen den Branches erhalten bleibt. Rebase bleibt
#       deaktiviert (erzeugt dieselben Ancestry-Probleme wie ein versehentlicher
#       Merge-Commit). Nicht wieder auf allow_merge_commit=false zurückstellen —
#       das hatte den Release-Workflow (testing → main) strukturell blockiert.
#   • delete_branch_on_merge=true → ersetzt die bisher manuelle Empfehlung
#     in aufräumen.md ("Settings → General → Automatically delete head
#     branches") durch eine zentral erzwungene Einstellung
#
# Sicherheit (Issue #7):
#   • --dry-run zeigt nur, was passieren würde
#   • Vor jedem Apply wird das bestehende Ruleset gleichen Namens als Backup
#     nach ./ruleset-backups/<repo>-<id>-<ts>.json gesichert
#   • Existiert bereits ein Ruleset gleichen Namens → PUT (Update) statt POST
#
# Usage:
#   ./apply-rulesets.sh [--dry-run] [repo1 repo2 ...]   # default: alle bekannten
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OWNER="S540d"
MAIN_RULESET_FILE="$ROOT_DIR/github-ruleset-protect-main.json"
TESTING_RULESET_FILE="$ROOT_DIR/github-ruleset-protect-testing.json"
BACKUP_DIR="$ROOT_DIR/ruleset-backups"

DRY_RUN=0
REPOS=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) REPOS+=("$arg") ;;
  esac
done

if [ "${#REPOS[@]}" -eq 0 ]; then
  REPOS=(
    "Energy_Price_Germany"
    "CD-to-Spotify-PWA"
    "1x1_Trainer"
    "DrawFromMemory"
    "Eisenhauer"
    "Pflanzkalender"
    "safe-my-plants"
  )
fi

command -v gh >/dev/null 2>&1 || { echo "❌ gh CLI nicht installiert"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "❌ jq nicht installiert (brew install jq)"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "❌ gh nicht authentifiziert (gh auth login)"; exit 1; }
[ -f "$MAIN_RULESET_FILE" ] || { echo "❌ Ruleset-Datei fehlt: $MAIN_RULESET_FILE"; exit 1; }
[ -f "$TESTING_RULESET_FILE" ] || { echo "❌ Ruleset-Datei fehlt: $TESTING_RULESET_FILE"; exit 1; }

[ "$DRY_RUN" -eq 1 ] && echo "🔎 DRY-RUN: keine Änderungen werden geschrieben."

# Wendet ein Ruleset ($2, benannt $3) auf Repo $1 an (Update via PUT, sonst POST).
apply_ruleset() {
  local repo="$1" ruleset_file="$2" ruleset_name="$3"

  # API kann bei 404/fehlender Berechtigung ein Objekt statt Array liefern →
  # defensiv parsen (nur Arrays durchsuchen), sonst leeres Ergebnis.
  local existing_id
  existing_id="$(gh api "repos/$OWNER/$repo/rulesets" 2>/dev/null \
    | jq -r --arg n "$ruleset_name" \
        'if type=="array" then (.[] | select(.name == $n) | .id) else empty end' \
        2>/dev/null | head -n1 || true)"

  if [ -n "${existing_id:-}" ] && [ "$existing_id" != "null" ]; then
    mkdir -p "$BACKUP_DIR"
    local backup="$BACKUP_DIR/${repo}-${existing_id}-$(date +%Y%m%d-%H%M%S).json"
    if [ "$DRY_RUN" -eq 0 ]; then
      gh api "repos/$OWNER/$repo/rulesets/$existing_id" > "$backup" 2>/dev/null \
        && echo "  💾 Backup: $backup"
    else
      echo "  [dry-run] Backup würde nach $backup geschrieben"
    fi

    echo "  ↻ Update bestehendes Ruleset '$ruleset_name' (id=$existing_id) via PUT"
    if [ "$DRY_RUN" -eq 0 ]; then
      if gh api "repos/$OWNER/$repo/rulesets/$existing_id" --method PUT --input "$ruleset_file" >/dev/null 2>&1; then
        echo "  ✅ aktualisiert"
      else
        echo "  ⚠️  Update fehlgeschlagen (Berechtigung?)"
      fi
    fi
  else
    echo "  + Neues Ruleset '$ruleset_name' via POST"
    if [ "$DRY_RUN" -eq 0 ]; then
      if gh api "repos/$OWNER/$repo/rulesets" --method POST --input "$ruleset_file" >/dev/null 2>&1; then
        echo "  ✅ erstellt"
      else
        echo "  ⚠️  Erstellung fehlgeschlagen (Berechtigung? bereits vorhanden?)"
      fi
    fi
  fi
}

for repo in "${REPOS[@]}"; do
  echo "→ $OWNER/$repo"

  apply_ruleset "$repo" "$MAIN_RULESET_FILE" "protect-main"

  if gh api "repos/$OWNER/$repo/branches/testing" >/dev/null 2>&1; then
    apply_ruleset "$repo" "$TESTING_RULESET_FILE" "protect-testing"
  else
    echo "  ⏭  kein testing-Branch — protect-testing übersprungen"
  fi

  echo "  ↻ Merge-Methode setzen (Squash Default, Merge-Commit für Sync-/Release-PRs erlaubt, Rebase aus, delete_branch_on_merge=true)"
  if [ "$DRY_RUN" -eq 0 ]; then
    if gh api "repos/$OWNER/$repo" --method PATCH \
        -f allow_squash_merge=true \
        -f allow_merge_commit=true \
        -f allow_rebase_merge=false \
        -f delete_branch_on_merge=true \
        -f squash_merge_commit_title=PR_TITLE \
        -f squash_merge_commit_message=PR_BODY >/dev/null 2>&1; then
      echo "  ✅ Merge-Methode gesetzt"
    else
      echo "  ⚠️  Merge-Methode-Update fehlgeschlagen (Berechtigung?)"
    fi
  else
    echo "  [dry-run] würde allow_squash_merge=true, allow_merge_commit=true, allow_rebase_merge=false, delete_branch_on_merge=true setzen"
  fi
done

echo "✅ Ruleset-Rollout abgeschlossen."
