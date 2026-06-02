#!/bin/bash
# Synchronisiert Claude Commands und Basis-Standards in Projekt-Repositories

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

GLOBAL_POLICY=$(cat <<'POLICY'
## [GLOBAL POLICY]
- PRs immer gegen `testing`, nie direkt gegen `staging` oder `main`
- Merge auf `main` nur mit expliziter schriftlicher Freigabe
- --delete-branch nur für Feature-Branches
- --no-verify nur auf explizite Bitte
POLICY
)

copy_to_project() {
  local project_dir="$1"

  echo "→ Sync: $project_dir"
  mkdir -p "$project_dir/.claude/commands"

  cp "$ROOT_DIR"/claude-commands/*.md "$project_dir/.claude/commands/"
  cp "$ROOT_DIR/dev-standards/base/.prettierrc.json" "$project_dir/.prettierrc.json"
  cp "$ROOT_DIR/dev-standards/base/.editorconfig" "$project_dir/.editorconfig"

  local claude_file="$project_dir/CLAUDE.md"
  if [ -f "$claude_file" ]; then
    if ! grep -Fq '## [GLOBAL POLICY]' "$claude_file"; then
      printf "\n\n%s\n" "$GLOBAL_POLICY" >> "$claude_file"
    fi
  else
    printf "%s\n" "$GLOBAL_POLICY" > "$claude_file"
  fi
}

if [ "$#" -gt 0 ]; then
  for project in "$@"; do
    copy_to_project "$project"
  done
else
  echo "Usage: $0 /absolute/path/to/project [/absolute/path/to/project2 ...]"
  exit 1
fi

echo "✅ Sync abgeschlossen"
