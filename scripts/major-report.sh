#!/usr/bin/env bash
# major-report.sh – verfügbare Major-Updates aller App-Repos als Markdown.
#
# Gegenstück zur Dependabot-Regel „keine Majors über Dependabot“
# (automation-templates/README.md): Majors werden hier sichtbar gemacht und
# dann als geplantes Upgrade-Issue im jeweiligen Repo angegangen.
#
# Je Repo (Branch testing, sonst main):
#   - direkte Abhängigkeiten aus package.json, installierte Version aus
#     package-lock.json, neueste Version (dist-tag latest) aus der npm-Registry
#   - gemeldet wird, wenn die Major-Version abweicht; bei 0.x zählt die
#     Minor-Version als Major (0.13 → 0.22 ist i. d. R. breaking)
#   - Expo-Repos: SDK-gebundene Pakete (Muster wie in dependabot.expo.yml)
#     erscheinen nicht einzeln, sondern als eine Zeile „Expo-SDK“ mit
#     neuestem Patch im eigenen SDK und neuestem SDK
#
# Aufruf: scripts/major-report.sh [repo1,repo2,…] > report.md
# Braucht: gh (authentifiziert), jq, curl, npm. Liest nur, schreibt nichts.
set -euo pipefail

REPOS="${1:-${MAJOR_REPORT_REPOS:-Energy_Price_Germany,CD-to-Spotify-PWA,1x1_Trainer,DrawFromMemory,Eisenhauer,Pflanzkalender,safe-my-plants,Epic_Calendar,CalibrateMyTelescope}}"
OWNER="${OWNER:-S540d}"

SDK_RE='^(expo|expo-.*|@expo/.*|babel-preset-expo|jest-expo|eslint-config-expo|react|react-dom|react-test-renderer|@types/react|react-native|@react-native/.*|react-native-.*|@react-native-async-storage/.*|@react-native-community/.*|@react-native-picker/.*|@shopify/react-native-skia|lottie-react-native)$'

# Cache als Dateien (kein declare -A → läuft auch mit Bash 3.2 auf macOS)
CACHE="$(mktemp -d)"
trap 'rm -rf "$CACHE"' EXIT

latest_of() {  # neueste Version laut dist-tag latest, gecacht
  local name="$1" f
  f="$CACHE/$(printf '%s' "$name" | tr '/@' '__')"
  if [ ! -f "$f" ]; then
    curl -fsS "https://registry.npmjs.org/$(printf '%s' "$name" | sed 's#/#%2f#')/latest" 2>/dev/null \
      | jq -r '.version // empty' > "$f" 2>/dev/null || : > "$f"
  fi
  cat "$f"
}

major_key() {  # 1.4.3 → 1 ; 0.13.5 → 0.13
  local v="${1#v}"
  case "$v" in
    0.*) echo "$v" | cut -d. -f1,2 ;;
    *)   echo "$v" | cut -d. -f1 ;;
  esac
}

raw() {  # Datei aus dem Repo (raw, auch > 1 MB)
  gh api -H "Accept: application/vnd.github.raw" "repos/$OWNER/$1/contents/$2?ref=$3" 2>/dev/null
}

total=0
IFS=',' read -r -a repos <<< "$REPOS"
for raw_repo in "${repos[@]}"; do
  repo="$(echo "$raw_repo" | xargs)"
  [ -n "$repo" ] || continue

  ref=testing
  gh api "repos/$OWNER/$repo/branches/testing" >/dev/null 2>&1 || ref=main
  if ! pkg="$(raw "$repo" package.json "$ref")"; then
    echo "::warning title=Nicht lesbar::$OWNER/$repo@$ref (package.json)" >&2
    continue
  fi
  lock="$(raw "$repo" package-lock.json "$ref" || echo '{}')"

  is_expo=false
  jq -e '.dependencies.expo // .devDependencies.expo' >/dev/null <<< "$pkg" && is_expo=true

  rows=""
  while IFS=$'\t' read -r name range; do
    [ -n "$name" ] || continue
    if $is_expo && [[ "$name" =~ $SDK_RE ]]; then continue; fi
    installed="$(jq -r --arg k "node_modules/$name" '.packages[$k].version // empty' <<< "$lock")"
    [ -n "$installed" ] || installed="$(echo "$range" | sed -E 's/^[^0-9]*//')"
    latest="$(latest_of "$name")"
    [ -n "$latest" ] && [ -n "$installed" ] || continue
    if [ "$(major_key "$installed")" != "$(major_key "$latest")" ]; then
      rows+="| \`$name\` | $installed | $latest |"$'\n'
      total=$((total + 1))
    fi
  done < <(jq -r '(.dependencies // {}) + (.devDependencies // {}) | to_entries[] | "\(.key)\t\(.value)"' <<< "$pkg")

  sdk_line=""
  if $is_expo; then
    cur="$(jq -r '.packages["node_modules/expo"].version // empty' <<< "$lock")"
    [ -n "$cur" ] || cur="$(jq -r '.dependencies.expo' <<< "$pkg" | sed -E 's/^[^0-9]*//')"
    sdk="${cur%%.*}"
    patch="$(npm view "expo@~$sdk" version --json 2>/dev/null | jq -r 'if type=="array" then .[-1] else . end' || true)"
    newest="$(latest_of expo)"
    sdk_line="**Expo-SDK:** installiert \`expo\` $cur · neuester Patch SDK $sdk: ${patch:-?} · neuestes SDK: ${newest%%.*} (${newest:-?})"
    [ "${patch:-$cur}" != "$cur" ] && sdk_line+=" → \`npx expo install --check\`"
  fi

  if [ -n "$rows" ] || [ -n "$sdk_line" ]; then
    echo "### $repo (\`$ref\`)"
    echo
    [ -n "$sdk_line" ] && { echo "$sdk_line"; echo; }
    if [ -n "$rows" ]; then
      echo "| Paket | installiert | neueste |"
      echo "|---|---|---|"
      printf '%s' "$rows"
    else
      echo "Keine Majors außerhalb des SDK."
    fi
    echo
  fi
done

echo "MAJOR_TOTAL=$total" >&2
