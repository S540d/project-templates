#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# clean-local-cache.sh – Löscht lokale Build-/Dependency-Caches in den
# bekannten Projektverzeichnissen, um Festplattenplatz freizugeben.
#
# Ergänzt cache-cleanup.yml (GitHub-Actions-Cache) um den lokalen Anteil:
# node_modules, dist, build, .expo, android/.gradle, android/app/build.
# Optional: globale Caches (~/.gradle/caches, ~/.npm) via --global.
#
# Sicherheit:
#   - Standard (kein Flag): nur Größenreport (du -sh), NICHTS wird gelöscht
#   - Löschen NUR mit --yes (ohne Rückfrage) oder nach y/N-Bestätigung je Projekt
#   - --dry-run zeigt exakt die geplanten rm-Befehle, ohne sie auszuführen
#   - Löscht ausschließlich fest definierte Unterverzeichnis-Namen relativ zu
#     bekannten Projekt-Roots – NIE einen beliebigen/berechneten Pfad
#   - Prüft vor jedem rm: Pfad existiert, ist ein Verzeichnis, Basename matcht
#     Whitelist – sonst wird der Pfad übersprungen statt gelöscht
#
# Usage:
#   ./clean-local-cache.sh                  # nur Report (kein Löschen)
#   ./clean-local-cache.sh --dry-run        # zeigt geplante Löschungen
#   ./clean-local-cache.sh --yes            # löscht ohne Rückfrage je Projekt
#   ./clean-local-cache.sh --global         # zusätzlich ~/.gradle/caches, ~/.npm
#   ./clean-local-cache.sh --yes --global   # alles, ohne Rückfrage
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_ROOT="$(dirname "$SCRIPT_DIR")/.."
PROJECTS_ROOT="$(cd "$PROJECTS_ROOT" && pwd)"

# Single Source of Truth für Projektpfade (analog aufräumen.md Abschnitt 0).
# Relative Pfade ab $PROJECTS_ROOT — Sonderfälle mit verschachtelten Ordnern
# werden explizit mit vollem Relativpfad eingetragen.
PROJECT_PATHS=(
  "1x1_Trainer"
  "EnergyPriceGermany"
  "Pflanzkalender"
  "DrawFromMemory"
  "safe_my_plants"
  "Eisenhauer"
  "CD-to-Spotify-PWA"
  "CalibrateMyTelescope/CalibrateMyTelescope"
  "epic_Calendar/Epic_Calendar"
  "project-templates"
)

# Whitelist der löschbaren Unterverzeichnisse relativ zu jedem Projekt-Root.
CACHE_SUBDIRS=(
  "node_modules"
  "dist"
  "build"
  ".expo"
  "android/.gradle"
  "android/app/build"
  "android/build"
)

DRY_RUN=0
CONFIRM_YES=0
DO_GLOBAL=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes) CONFIRM_YES=1 ;;
    --global) DO_GLOBAL=1 ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) echo "Unbekanntes Argument: $arg"; exit 1 ;;
  esac
done

# Löscht NUR, wenn Pfad existiert, ein Verzeichnis ist, UND der Basename
# in der Whitelist auftaucht (Schutz gegen Pfad-/Konfigurationsfehler).
safe_remove() {
  local target="$1"
  local base
  base="$(basename "$target")"

  [ -d "$target" ] || return 0

  local allowed=0
  for allowed_name in node_modules dist build .expo .gradle; do
    if [ "$base" = "$allowed_name" ]; then
      allowed=1
      break
    fi
  done
  if [ "$allowed" -ne 1 ]; then
    echo "   ⚠️  Überspringe unerwarteten Pfad (nicht in Whitelist): $target"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "   [dry-run] rm -rf $target"
    return 0
  fi
  rm -rf "$target"
  echo "   ✓ gelöscht: $target"
}

report_and_clean_project() {
  local rel="$1"
  local project_dir="$PROJECTS_ROOT/$rel"

  if [ ! -d "$project_dir" ]; then
    echo "⚠️  Übersprungen (kein Verzeichnis): $rel"
    return
  fi

  echo ""
  echo "→ $rel"
  local found_any=0
  local targets=()

  for sub in "${CACHE_SUBDIRS[@]}"; do
    local t="$project_dir/$sub"
    if [ -d "$t" ]; then
      found_any=1
      local size
      size="$(du -sh "$t" 2>/dev/null | cut -f1)"
      echo "   $sub: $size"
      targets+=("$t")
    fi
  done

  if [ "$found_any" -eq 0 ]; then
    echo "   (keine Caches gefunden)"
    return
  fi

  if [ "$REPORT_ONLY" -eq 1 ]; then
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    for t in "${targets[@]}"; do safe_remove "$t"; done
    return
  fi

  if [ "$CONFIRM_YES" -eq 0 ]; then
    read -r -p "   Löschen? [y/N] " reply
    case "$reply" in
      y|Y|yes|Yes) ;;
      *) echo "   übersprungen"; return ;;
    esac
  fi

  for t in "${targets[@]}"; do safe_remove "$t"; done
}

REPORT_ONLY=0
if [ "$DRY_RUN" -eq 1 ]; then
  mode="dry-run"
elif [ "$CONFIRM_YES" -eq 1 ]; then
  mode="aktiv (--yes)"
else
  mode="nur Report"
  REPORT_ONLY=1
fi
echo "Lokaler Cache-Report/Cleanup ($mode)"

for rel in "${PROJECT_PATHS[@]}"; do
  report_and_clean_project "$rel"
done

if [ "$DO_GLOBAL" -eq 1 ]; then
  echo ""
  echo "→ Globale Caches"
  for g in "$HOME/.gradle/caches" "$HOME/.npm"; do
    [ -d "$g" ] || continue
    size="$(du -sh "$g" 2>/dev/null | cut -f1)"
    echo "   $g: $size"
  done

  if [ "$REPORT_ONLY" -eq 1 ]; then
    :
  elif [ "$DRY_RUN" -eq 1 ]; then
    echo "   [dry-run] würde: gradle --stop, rm -rf ~/.gradle/caches/*, npm cache clean --force"
  else
    if [ "$CONFIRM_YES" -eq 0 ]; then
      read -r -p "   Globale Caches löschen (~/.gradle/caches, npm cache)? [y/N] " reply
    else
      reply=y
    fi
    case "$reply" in
      y|Y|yes|Yes)
        command -v gradle >/dev/null 2>&1 && gradle --stop || true
        if [ -d "$HOME/.gradle/caches" ]; then
          rm -rf "${HOME:?}/.gradle/caches"/*
          echo "   ✓ ~/.gradle/caches geleert"
        fi
        if command -v npm >/dev/null 2>&1; then
          npm cache clean --force
          echo "   ✓ npm-Cache geleert"
        fi
        ;;
      *) echo "   übersprungen" ;;
    esac
  fi
fi

echo ""
echo "✅ Fertig."
