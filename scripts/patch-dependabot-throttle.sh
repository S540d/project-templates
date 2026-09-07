#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────
# patch-dependabot-throttle.sh – Drosselt bestehende dependabot.yml (Issue #144).
#
# Warum ein eigenes Skript?
#   sync-standards.sh legt dependabot.yml nur an, wenn KEINE existiert, und
#   lässt vorhandene bewusst unangetastet (repo-spezifische paths-ignore etc.).
#   Genau die vorhandenen brauchen aber die Drosselung. Dieses Skript patcht
#   deshalb gezielt drei Felder und fasst den Rest der Datei nicht an:
#
#     1. target-branch: "testing"  – ergänzt, falls fehlend. Ohne das Feld
#        gehen PRs gegen den Default-Branch main und sind wegen der
#        Ruleset-Pflicht nicht direkt mergebar.
#     2. interval: weekly → monthly
#     3. groups: EIN Sammel-Block mit patterns ["*"] statt eines
#        update-types-Filters, damit auch Major-Updates gebündelt werden.
#
# Der Parser arbeitet blockweise über die "- package-ecosystem"-Einträge und
# ist idempotent: mehrfaches Ausführen ändert nichts mehr.
#
# ACHTUNG: target-branch wirkt nur auf NEUE PRs. Bereits offene PRs gegen main
# bleiben stehen. GitHubs Default-Security-Updates ignorieren target-branch
# generell — dort hilft nur, dass die Datei überhaupt existiert.
#
# Usage:
#   ./patch-dependabot-throttle.sh [--dry-run] /abs/path/projectA [projectB ...]
# ─────────────────────────────────────────────────────────────────────────

set -euo pipefail

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

if [ ${#PROJECTS[@]} -eq 0 ]; then
  echo "Fehler: kein Projektpfad angegeben. --help für Usage." >&2
  exit 1
fi

# Python macht die eigentliche Arbeit: zeilenbasiert, damit Kommentare und
# Formatierung der Datei erhalten bleiben (ein yaml.dump würde beides platt machen).
patch_file() {
  local file="$1"
  DRY_RUN="$DRY_RUN" python3 - "$file" <<'PY'
import os, re, sys

path = sys.argv[1]
dry = os.environ.get("DRY_RUN") == "1"
lines = open(path, encoding="utf-8").read().splitlines()

out, changes = [], []
i = 0
n = len(lines)

def indent_of(s):
    return len(s) - len(s.lstrip())

while i < n:
    line = lines[i]
    m = re.match(r'^(\s*)-\s+package-ecosystem:\s*["\']?([\w-]+)["\']?', line)
    if not m:
        out.append(line)
        i += 1
        continue

    dash_indent, eco = m.group(1), m.group(2)
    # Feld-Einrückung = Dash-Einrückung + 2 ("- " ist zwei Zeichen breit).
    field_indent = dash_indent + "  "

    # Den kompletten Block dieses Eintrags einsammeln: bis zum nächsten Dash
    # auf gleicher Ebene oder einer Zeile mit geringerer Einrückung.
    block = [line]
    i += 1
    while i < n:
        nxt = lines[i]
        if nxt.strip() and indent_of(nxt) <= len(dash_indent) and not nxt.startswith(field_indent):
            break
        if re.match(r'^' + re.escape(dash_indent) + r'-\s+package-ecosystem:', nxt):
            break
        block.append(nxt)
        i += 1

    text = "\n".join(block)

    # 1. interval weekly → monthly
    new_block = []
    for b in block:
        if re.search(r'\binterval:\s*["\']?weekly["\']?', b):
            new_block.append(re.sub(r'(interval:\s*)["\']?weekly["\']?', r'\1"monthly"', b))
            changes.append(f"{eco}: interval weekly → monthly")
        else:
            new_block.append(b)
    block = new_block
    text = "\n".join(block)

    # 2. target-branch ergänzen, falls nicht vorhanden — direkt nach "directory:".
    if not re.search(r'^\s*target-branch:', text, re.M):
        tmp = []
        for b in block:
            tmp.append(b)
            if re.match(r'^\s*directory:', b):
                tmp.append(f'{field_indent}target-branch: "testing"')
        block = tmp
        changes.append(f"{eco}: target-branch: testing ergänzt")

    # 3. groups durch einen Sammel-Block ersetzen (bzw. anlegen).
    #    Alles ab "groups:" bis zum Blockende gehört zur alten Gruppendefinition.
    gidx = next((k for k, b in enumerate(block) if re.match(r'^\s*groups:', b)), None)
    group_name = "actions-all" if eco == "github-actions" else f"{eco}-all"
    desired = [
        f"{field_indent}groups:",
        f"{field_indent}  # Kein update-types-Filter → Major landet mit im Sammel-PR.",
        f"{field_indent}  {group_name}:",
        f"{field_indent}    patterns:",
        f'{field_indent}      - "*"',
    ]
    if gidx is None:
        while block and not block[-1].strip():
            block.pop()
        block.extend(desired)
        changes.append(f"{eco}: groups-Sammelblock angelegt")
    else:
        def strip_comments(ls):
            return [x.rstrip() for x in ls
                    if x.strip() and not x.strip().startswith("#")]
        if strip_comments(block[gidx:]) != strip_comments(desired):
            # Direkt vorstehende Kommentarzeilen beschreiben die alte
            # Gruppierung ("Patch-/Minor-Updates gebündelt") und wären nach
            # dem Ersetzen falsch — mit abräumen.
            start = gidx
            while start > 0 and block[start - 1].strip().startswith("#"):
                start -= 1
            block = block[:start] + desired
            changes.append(f"{eco}: groups → Sammelblock inkl. Major")
        # sonst: bereits ein patterns-Block ohne update-types → idempotent, nichts tun

    out.extend(block)
    # Leerzeile zwischen den Ecosystem-Blöcken erhalten (das Einsammeln oben
    # zieht trailing blanks in den Block, die desired-Liste ersetzt sie).
    if i < n and any(x.strip() for x in lines[i:]):
        out.append("")

if not changes:
    print("   • bereits gedrosselt – unverändert")
    sys.exit(0)

result = "\n".join(out).rstrip() + "\n"

# Vor dem Schreiben validieren – eine kaputte dependabot.yml wird von GitHub
# still ignoriert, das würde die Updates komplett abschalten.
try:
    import yaml
    yaml.safe_load(result)
except ImportError:
    pass
except Exception as e:
    print(f"   ✗ ABBRUCH: Ergebnis wäre kein valides YAML ({e})")
    sys.exit(1)

for c in changes:
    print(f"   ✓ {c}")

if dry:
    print("   [dry-run] nicht geschrieben")
else:
    open(path, "w", encoding="utf-8").write(result)
PY
}

for project_dir in "${PROJECTS[@]}"; do
  name="$(basename "$project_dir")"
  file="$project_dir/.github/dependabot.yml"
  echo "▶ $name"
  if [ ! -f "$file" ]; then
    echo "   • keine .github/dependabot.yml – übersprungen (sync-standards.sh legt sie an)"
    continue
  fi
  patch_file "$file"
done
