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

**Gruppen (npm):** `npm-minor-patch` (Minor/Patch) und `npm-major` (alle Majors). Früher gab es einen einzigen Block inkl. Major (#144). Ein einziger inkompatibler Major machte den PR dann jeden Monat unmergebar, die gefahrlosen Updates blieben mit liegen (Energy_Price_Germany#543, DrawFromMemory#389). Jetzt sind es höchstens zwei PRs pro Monat, der Minor/Patch-PR ist in der Regel direkt mergebar.

**Expo-Variante:** zusätzlich `ignore` für SDK-gebundene Pakete. Für `expo`, `expo-*`, `@expo/*` werden Majors ignoriert, für `react`, `react-native`, `react-native-*` und weitere native Module auch Minors. Patches laufen weiter. Diese Pakete werden nur bei einem geplanten SDK-Upgrade angehoben (`npx expo install --fix`, Gerätetest, eigenes Issue). Security-Updates sind vom `ignore` nicht betroffen: `update-types` wirkt laut GitHub-Doku nur auf Version-Updates.

**Prüfen vor dem Merge:** `gh pr checkout <N> && npm ci && npm test`. Blockiert ein Major dauerhaft die `npm-major`-Gruppe (z. B. `typescript` 7 vs. `typescript-eslint`-peer → ERESOLVE, Issue #173), ihn repo-lokal per `ignore` + `update-types: ["version-update:semver-major"]` aussetzen, mit Begründung und Issue-Verweis kommentieren und nach dem Toolchain-Update wieder entfernen.

**Bestehende Configs nachziehen:** `scripts/patch-dependabot-throttle.sh [--dry-run] <repo>` stellt die Gruppen um und lässt einen vorhandenen `ignore`-Block stehen. Den Expo-`ignore`-Block ergänzt das Skript nicht.
