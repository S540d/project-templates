# Automation Templates

Vorlagen für automatisierte Quality Assurance in neuen/bestehenden Projekten. Ausrollen per:

```bash
/path/to/project-templates/scripts/init-automation.sh /path/to/project
```

Kopiert CI/CD-Workflow, Pre-Commit-Hook, Release-Validation-Script, PR-Template und (bei React Native) Platform-Utilities passend zum erkannten Projekttyp. Details siehe `AUTOMATION_SETUP.md` (wird mitkopiert) und die Kommentare in den einzelnen Template-Dateien.

## Dependabot-Sammel-PRs prüfen (Issue #173)

`dependabot.yml` bündelt bewusst alle Updates inkl. Major in einem Block (#144). Ein einzelner inkompatibler Major macht den ganzen Sammel-PR unmergebar (z. B. `typescript` 7 vs. `typescript-eslint`/`ts-jest`-peer → `npm ci` scheitert mit ERESOLVE).

- Vor dem Merge lokal prüfen: `gh pr checkout <N> && npm ci && npm test`.
- Betrifft es nur einen Major gekoppelter Toolchains (TypeScript, ESLint-Kette, Vite/Vitest, Expo): repo-lokal per `ignore` + `update-types: ["version-update:semver-major"]` aussetzen — Beispiel (auskommentiert) steht in der Vorlage.
- Den Ignore mit Begründung kommentieren und nach dem Toolchain-Update wieder entfernen.
