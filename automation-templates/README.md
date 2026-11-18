# Automation Templates

Vorlagen für automatisierte Quality Assurance in neuen/bestehenden Projekten. Ausrollen per:

```bash
/path/to/project-templates/scripts/init-automation.sh /path/to/project
```

Kopiert CI/CD-Workflow, Pre-Commit-Hook, Release-Validation-Script, PR-Template und (bei React Native) Platform-Utilities passend zum erkannten Projekttyp. Details siehe `AUTOMATION_SETUP.md` (wird mitkopiert) und die Kommentare in den einzelnen Template-Dateien.

## Dependabot: Gruppen und Expo-Variante

Zwei Vorlagen:

| Vorlage | Für |
|---|---|
| `dependabot.yml` | alle Repos ohne Expo |
| `dependabot.expo.yml` | Expo-/React-Native-Projekte (`sync-standards.sh` wählt sie automatisch, wenn `package.json` `expo` enthält) |

**Gruppe (npm):** nur noch `npm-minor-patch`, ein PR pro Monat, in der Regel direkt mergebar. **Majors kommen nicht mehr über Dependabot** (`ignore` für `*` mit `semver-major`).

Geschichte: Erst gab es einen Block inklusive Majors (#144). Ein einziger inkompatibler Major machte ihn jeden Monat unmergebar (Energy_Price_Germany#543, DrawFromMemory#389). Dann kamen zwei Gruppen, Minor/Patch und Major (#187). Die Major-Gruppe war aber genauso nie mergebar, weil sie Breaking Changes aus unabhängigen Toolchains bündelt (Sentry, ESLint, Jest, TypeScript, Babel …): DrawFromMemory#400. Majors brauchen eine geplante Migration. Deshalb listet der **monatliche Major-Report** (`.github/workflows/monthly-major-report.yml`) die verfügbaren Majors aller App-Repos in einem Sammel-Issue. Daraus entstehen gezielte Upgrade-Issues je Repo.

**Expo-Variante:** Zusätzlich bekommen SDK-gebundene Pakete **gar keine** Dependabot-Updates (`expo`, `expo-*`, `@expo/*`, `react`, `react-dom`, `react-test-renderer`, `@types/react`, `react-native`, `react-native-*` und weitere native Module). Auch Patches sind nicht harmlos: Expo pinnt in `bundledNativeModules.json` exakt. `react` 19.2.0 → 19.2.9 ohne `react-test-renderer` ließ in DrawFromMemory#399 alle Testsuites scheitern. Diese Pakete bewegt nur Expo selbst:
- innerhalb des SDK: `npx expo install --check`, dann gezielt `npx expo install <pakete>` (kein pauschales `--fix`, das schlägt auch Tooling-Majors vor)
- SDK-Upgrade: `npx expo install expo@^<N> && npx expo install --fix`, mit Gerätetest, als eigenes Issue

Der Major-Report zeigt dazu je Repo den SDK-Stand.

**Security-Updates** sind vom `ignore` nicht betroffen: Mit gesetztem `target-branch` gilt die Konfiguration laut GitHub-Doku nicht für Security-PRs. Sie landen deshalb weiter gegen `main` und werden per Mini-PR nach `testing` ersetzt (#185).

**Prüfen vor dem Merge:** `gh pr checkout <N> && npm ci && npm test`. Bei 0.x-Paketen zählt Dependabot 0.13 → 0.22 als „minor“, das ist oft breaking.

**Bestehende Configs nachziehen:** Die Datei wird je Repo aus der passenden Vorlage neu übernommen, repo-spezifische `ignore`-Einträge werden von Hand mitgenommen. (Das frühere Patch-Skript aus #144 ist entfernt, es erzeugte Major-Gruppen, die die neue Regel nicht mehr vorsieht.)
