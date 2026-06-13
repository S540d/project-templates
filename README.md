# Project Templates

Zentrale Vorlagen und Standards für alle Projekte von [DevSven](https://github.com/S540d).

---

## Inhalt

| Datei / Verzeichnis | Zweck |
|---|---|
| `dev-standards/` | Kanonische Basis-Configs (Prettier, EditorConfig, ESLint, TSConfig, Pre-Commit) |
| `dev-standards/global-policy.md` | Verbindliche Branch-Strategie, Merge-Regeln, CI-Policy |
| `.github/workflows/` | Reusable Workflows (PR-Review, Security-Scan, Standards-Audit, Weekly-Audit) |
| `scripts/` | `sync-standards.sh`, `apply-rulesets.sh`, `setup-labels.sh` |
| `automation-templates/` | CI/CD Workflow-Templates, Pre-Commit Hooks, Validation Scripts |
| `technische_vorgaben.md` | Code-Qualität, Testing, TypeScript, Build, CI/CD, Android, PWA |
| `ux-vorgaben.md` | Design-System, Farben, Typography, Accessibility (WCAG 2.1 AA), i18n |

---

## Schnellstart – neues Projekt einrichten

```bash
# Standards ausrollen (Prettier, EditorConfig, Commands)
./scripts/sync-standards.sh /pfad/zum/projekt

# Branch-Protection setzen
./scripts/apply-rulesets.sh S540d/RepoName

# Labels anlegen
./scripts/setup-labels.sh S540d/RepoName
```

---

## Reusable Workflows

Immer mit festem Tag aufrufen (`@v2`, nie `@main`):

```yaml
uses: S540d/project-templates/.github/workflows/reusable-mergeability.yml@v2
```

| Workflow | Verhalten |
|---|---|
| `reusable-mergeability.yml` | **Kostenloses** Merge-Gate: Sticky-Report (Konflikt/Zielbranch/CI) + setzt `review-gate`. Keine API-Kosten |
| `reusable-pr-review.yml` | **Optionaler** KI-Review (Anthropic API, ⚠️ metered); on-demand via Label `ai-review`; rein beratend, kein Gate |
| `reusable-security-scan.yml` | fail-closed (Funde + Scanner-Fehler brechen ab) |
| `reusable-ci-quality.yml` | lint / type-check / test – konfigurierbar |
| `reusable-gitignore-audit.yml` | blocking; Pflicht-Ignores + keine getrackten Secrets |
| `reusable-dev-standards-audit.yml` | non-blocking Hinweis-Audit |
| `weekly-audit.yml` | Cron Mo 08:00 – braucht `ORG_AUTOMATION_TOKEN` |

> Tiefer KI-Review ohne API-Kosten: `/review` aus Claude Code (Pro/Max-Abo) — lokal
> oder als Web-Session. Die metered `reusable-pr-review.yml` ist nur der Fallback.

---

## Branch-Strategie (global-policy)

```
feature/issue-XXX → testing → main
```

- PRs immer gegen `testing` (nie direkt `main`)
- Merge feature→testing: `gh pr merge --squash --delete-branch`
- Merge testing→main: `gh pr merge --squash` (kein `--delete-branch`!)
- main braucht `--admin`

Vollständig dokumentiert in `dev-standards/global-policy.md`.

---

## Lizenz

[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) – Namensnennung, nicht-kommerziell.
