#!/usr/bin/env node
/**
 * Workflow-Guard gegen die Fehlerklasse aus Issue #445 (EnergyPriceGermany).
 *
 * Hintergrund: Ein `node -e '…'`-Inline-Block enthielt im Fehlertext ein
 * Apostroph. Das schloss den Shell-String vorzeitig, `node` bekam die
 * Folgewörter als Optionen und brach mit Exit 9 ab — bevor eine einzige
 * Prüfung lief. Der Step färbte damit jeden Run rot, unabhängig vom
 * eigentlichen Ergebnis, über Stunden unbemerkt.
 *
 * Warum ein eigener Check und nicht actionlint/shellcheck: Der Fehler ist
 * für die Shell syntaktisch korrekt (aus einem String werden mehrere
 * Wörter, keine Quote bleibt offen). shellcheck meldet dort nur SC2016
 * (info), das bei jedem `node -e` normal ist — verifiziert gegen den
 * ursprünglichen Bug: kein Finding traf ihn.
 *
 * Der Check meldet:
 *   1. Apostrophe im Body eines mehrzeiligen `node -e '…'`-Blocks → Fehler
 *   2. Mehrzeilige `node -e '…'`-Blöcke überhaupt → Warnung
 *      (Logik gehört nach scripts/, nicht in Workflow-Inline-Blöcke)
 *
 * Aufruf: node scripts/lint-workflows.cjs [workflow-verzeichnis]
 */

const fs = require('fs');
const path = require('path');

const DIR = process.argv[2] || '.github/workflows';
const OPEN = /node -e '\s*$/;
// Schliessende Zeile: beginnt (nach Whitespace) mit dem Quote. Bewusst tolerant,
// weil danach beliebiges folgen kann — `'`, `'; then`, `' "$PROBE_DIR")`.
// JS-Body-Zeilen beginnen praktisch nie mit einem Apostroph.
const CLOSE = /^\s*'/;
// Erlaubt: Einzeiler wie  node -e 'console.log(...)'  (oeffnet und schliesst in einer Zeile)
const SINGLE_LINE = /node -e '[^']*'/;

let errors = 0;
let warnings = 0;

const report = (level, file, line, msg) => {
  const prefix = level === 'error' ? '::error' : '::warning';
  console.log(`${prefix} file=${file},line=${line}::${msg}`);
  if (level === 'error') errors++;
  else warnings++;
};

if (!fs.existsSync(DIR)) {
  console.log(`Workflow-Guard: Verzeichnis ${DIR} existiert nicht, übersprungen.`);
  process.exit(0);
}

const files = fs
  .readdirSync(DIR)
  .filter((f) => f.endsWith('.yml') || f.endsWith('.yaml'))
  .sort();

for (const name of files) {
  const file = path.join(DIR, name);
  const lines = fs.readFileSync(file, 'utf8').split('\n');

  let openLine = null;
  let apostropheLines = [];

  lines.forEach((line, idx) => {
    const lineNo = idx + 1;

    if (openLine === null) {
      if (OPEN.test(line) && !SINGLE_LINE.test(line)) {
        openLine = lineNo;
        apostropheLines = [];
      }
      return;
    }

    if (CLOSE.test(line)) {
      if (apostropheLines.length > 0) {
        report(
          'error',
          file,
          openLine,
          `Apostroph im Body eines mehrzeiligen "node -e '...'"-Blocks ` +
            `(Zeile ${apostropheLines.join(', ')}). Das schliesst den Shell-String ` +
            `vorzeitig — node bekommt die Folgewoerter als Optionen und bricht ab ` +
            `(Issue #445). Logik nach scripts/ auslagern.`
        );
      } else {
        report(
          'warning',
          file,
          openLine,
          `Mehrzeiliger "node -e '...'"-Block. Konvention: nennenswerte Logik ` +
            `gehoert in eine Datei unter scripts/ (Issue #445).`
        );
      }
      openLine = null;
      return;
    }

    if (line.includes("'")) apostropheLines.push(lineNo);
  });

  if (openLine !== null) {
    report(
      'error',
      file,
      openLine,
      `Nicht geschlossener "node -e '...'"-Block — der Workflow ist vermutlich kaputt.`
    );
  }
}

console.log(
  `\nWorkflow-Guard: ${files.length} Datei(en) geprueft, ` +
    `${errors} Fehler, ${warnings} Warnung(en).`
);

if (errors > 0) process.exit(1);
