#!/bin/bash
# Wendet Branch-Protection Rulesets für alle Standard-Repositories an

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OWNER="S540d"

REPOS=(
  "EnergyPriceGermany"
  "CD-to-Spotify-PWA"
  "1x1_Trainer"
  "DrawFromMemory"
  "Eisenhauer"
  "Pflanzkalender"
  "safe_my_plants"
)

for repo in "${REPOS[@]}"; do
  if gh api "repos/$OWNER/$repo/contents/app.json" >/dev/null 2>&1; then
    ruleset_file="$ROOT_DIR/github-ruleset-protect-main-react-native.json"
    project_type="react-native"
  else
    ruleset_file="$ROOT_DIR/github-ruleset-protect-main-web.json"
    project_type="web"
  fi

  echo "→ Applying ruleset for $OWNER/$repo ($project_type)"

  if gh api "repos/$OWNER/$repo/rulesets" --method POST --input "$ruleset_file" >/dev/null 2>&1; then
    echo "  ✅ ruleset created"
  else
    echo "  ⚠️ ruleset not created (already exists or insufficient permission)"
  fi

done

echo "✅ Ruleset rollout abgeschlossen"
