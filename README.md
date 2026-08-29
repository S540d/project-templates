# Project Templates

Vorlagen und Standards für alle Projekte von [DevSven](https://github.com/S540d). Nur aus technischen Gründen public.

- `dev-standards/` – Basis-Configs, `global-policy.md` (Branch-Strategie, CI-Policy, Merge-Regeln)
- `.github/workflows/` – Reusable Workflows (immer mit `@v2`, nie `@main`)
- `automation-templates/` – Caller-Workflows, Pre-Commit-Hooks, Release-Skripte zum Kopieren
- `claude-commands/` – Slash-Commands, via `sync-standards.sh` in die Projekte verteilt
- `scripts/` – `sync-standards.sh`, `apply-rulesets.sh`, `setup-labels.sh`, `clean-local-cache.sh`
- `docs/guidelines/` – `technische_vorgaben.md`, `ux-vorgaben.md`

Branch-Strategie: `feature/issue-XXX → testing → main`, PRs nie direkt gegen `main`.

Details siehe `dev-standards/global-policy.md`.

## Lizenz

[PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0/)
