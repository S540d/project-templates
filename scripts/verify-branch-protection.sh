#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# verify-branch-protection.sh – Aktiv verifizieren statt im UI ablesen.
#
# Lehre aus Issue #122 / EnergyPriceGermany #428, #446: "Eine aktive Regel
# beweist nichts" — ein Bypass macht sie zur Dekoration. Ein Ruleset kann in
# der API als "enforcement: active" mit "deletion"-Regel erscheinen und
# trotzdem wirkungslos sein, wenn ein bypass_actors-Eintrag alles umgeht
# (genau das war die Ursache von EnergyPriceGermany PR #404).
#
# Zwei Hälften, BEIDE geprüft — nur eine Hälfte zu prüfen war genau der
# Fehler, der zu #446 führte (bypass_actors: [] blockierte nicht nur den
# gefürchteten Admin-Bypass, sondern auch den legitimen Daten-Push von
# fetch.yml, unbemerkt für 13 Stunden):
#
#   1. Deletion-Schutz ECHT getestet: ein DELETE-Request gegen den
#      Branch-Ref muss vom Server abgelehnt werden (HTTP 422/GH013) —
#      BEVOR irgendetwas gelöscht wird. Kein git push --delete (das würde
#      bei falsch konfiguriertem Schutz den Branch tatsächlich löschen);
#      stattdessen der GitHub Git-Ref-DELETE-Endpoint direkt per API, der
#      serverseitig gegen das Ruleset prüft und ablehnt, bevor die
#      Operation ausgeführt wird.
#   2. Bypass-Konfiguration dokumentiert statt vorgetäuscht: bypass_actors
#      wird gelesen und bewertet — ein RepositoryRole-Eintrag mit
#      bypass_mode "always" ist ein Fund (verboten, s. global-policy.md
#      "Bypass-Policy"), ein einzelner Deploy-Key-Actor ist zulässig
#      (Issue #122 Korrektur 2). Ein ECHTER Automations-Push (z.B. mit
#      einem Deploy-Key-Token) wird hier NICHT simuliert, solange kein
#      solcher Actor projektlokal eingerichtet ist — das wäre sonst ein
#      falsches Grün. Stattdessen wird explizit gemeldet, ob ein
#      Automations-Actor konfiguriert ist oder nicht.
#
# Usage:
#   ./verify-branch-protection.sh [repo1 repo2 ...]   # default: alle bekannten
# ─────────────────────────────────────────────────────────────────────────

set -uo pipefail

OWNER="S540d"

REPOS=("$@")
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

FAIL=0

# Prüft Hälfte 1: DELETE gegen refs/heads/$branch muss abgelehnt werden.
check_deletion_blocked() {
  local repo="$1" branch="$2"
  local resp status
  resp="$(gh api -X DELETE "repos/$OWNER/$repo/git/refs/heads/$branch" 2>&1)"
  if echo "$resp" | grep -q '"status":"422"\|GH013\|Repository rule violations'; then
    echo "  ✅ deletion($branch): blockiert (422/Ruleset-Violation)"
  elif echo "$resp" | grep -qi "404\|Not Found"; then
    echo "  ⏭  deletion($branch): Branch nicht vorhanden — übersprungen"
  else
    echo "  🔴 deletion($branch): NICHT blockiert — Antwort: $resp"
    FAIL=1
  fi
}

# Prüft Hälfte 2: bypass_actors bewerten (kein echter Push-Test ohne Actor).
check_bypass_config() {
  local repo="$1" ruleset_name="$2"
  local id
  id="$(gh api "repos/$OWNER/$repo/rulesets" 2>/dev/null \
    | jq -r --arg n "$ruleset_name" \
        'if type=="array" then (.[] | select(.name == $n) | .id) else empty end' \
        2>/dev/null | head -n1)"

  if [ -z "${id:-}" ] || [ "$id" = "null" ]; then
    echo "  ⏭  $ruleset_name: kein Ruleset dieses Namens — übersprungen"
    return
  fi

  local detail
  detail="$(gh api "repos/$OWNER/$repo/rulesets/$id" 2>/dev/null)"
  local can_bypass
  can_bypass="$(echo "$detail" | jq -r '.current_user_can_bypass // "unknown"')"

  local role_bypass
  role_bypass="$(echo "$detail" | jq -r \
    '[.bypass_actors[]? | select(.actor_type == "RepositoryRole" and .bypass_mode == "always")] | length')"

  local other_actors
  other_actors="$(echo "$detail" | jq -c '.bypass_actors // []')"

  if [ "$role_bypass" -gt 0 ]; then
    echo "  🔴 $ruleset_name: RepositoryRole-Bypass mit bypass_mode=always gefunden — verboten (s. global-policy.md \"Bypass-Policy\")"
    FAIL=1
  elif [ "$other_actors" = "[]" ]; then
    echo "  ✅ $ruleset_name: bypass_actors leer — kein Automations-Actor konfiguriert (current_user_can_bypass=$can_bypass)"
  else
    echo "  ℹ️  $ruleset_name: Automations-Actor(en) konfiguriert: $other_actors (current_user_can_bypass=$can_bypass) — echter Push-Test hier nicht durchgeführt, manuell mit dem jeweiligen Actor-Token verifizieren"
  fi
}

for repo in "${REPOS[@]}"; do
  echo "→ $OWNER/$repo"

  check_deletion_blocked "$repo" "main"
  if gh api "repos/$OWNER/$repo/branches/testing" >/dev/null 2>&1; then
    check_deletion_blocked "$repo" "testing"
  else
    echo "  ⏭  deletion(testing): kein testing-Branch — übersprungen"
  fi

  check_bypass_config "$repo" "protect-main"
  if gh api "repos/$OWNER/$repo/branches/testing" >/dev/null 2>&1; then
    check_bypass_config "$repo" "protect-testing"
  fi
done

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Alle geprüften Repos: Deletion blockiert, kein verbotener Rollen-Bypass."
else
  echo "🔴 Mindestens ein Repo hat eine Lücke — siehe Ausgabe oben."
fi
exit "$FAIL"
