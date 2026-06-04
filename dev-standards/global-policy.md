# Global Policy — Workflow-Regeln für alle Projekte

> Zentrale Quelle für projektübergreifende Regeln (Issue #16).
> Änderungen hier → in alle Repo-CLAUDE.md-Dateien übertragen.

## Branch-Strategie

```
main (production) ← testing ← feature/issue-XXX
```

`staging` wurde in allen Repos entfernt (2026-06-03, Issue #7).

### Workflow

```bash
git checkout testing
git pull origin testing
git merge origin/main  # falls nötig

git checkout -b feature/issue-XXX

# ... Änderungen ...

git push -u origin feature/issue-XXX
gh pr create --base testing --title "Fix #XXX: ..." --body "..."
```

### PR-Regeln
- PRs immer gegen `testing`, nie direkt gegen `main`
- Titel: Issue-Nummer referenzieren
- CI/CD: Alle Checks müssen grün sein — **kein Merge bei CI-Fail**
- **Vor Push:** lokale Tests ausführen (`npm test` oder projektspezifisch)
- Merge Feature → Testing: `gh pr merge <nr> --squash --delete-branch`
- Merge Testing → Main: `gh pr merge <nr> --squash` (kein `--delete-branch`!)
- Merge auf main braucht `--admin` (Branch Protection)
- `--no-verify` und `--admin` nur auf explizite Bitte

## CLAUDE.md Standard

Alle Repos folgen diesem einheitlichen Schema:

| Datei | Status | Zweck |
|---|---|---|
| `CLAUDE.md` (Root) | **committet** | Projektinstruktionen für Claude — öffentlich, versioniert |
| `.claude/` | **gitignored** | Lokale Commands, Settings, Daten — nie committen |

### `.gitignore`-Pflichtzeile
Jedes Repo muss in `.gitignore` enthalten:
```
# Claude Code local files (commands, settings – never commit)
.claude/
```

### Warum
- `CLAUDE.md` im Root wird von Claude Code automatisch gelesen und ist für alle Entwickler sichtbar
- `.claude/` enthält lokale Commands und Settings, die gerätespezifisch sind und nicht ins Repo gehören

## Automatischer PR-Review
Alle Repos haben `pr-review.yml` — Claude postet automatisch einen Review-Kommentar.
Voraussetzung: `ANTHROPIC_API_KEY` als Repository-Secret.

## Branch Protection (Rulesets)
`main` und `testing` sind in allen Repos per Ruleset geschützt:
- Deletion blockiert
- Non-fast-forward blockiert
- Required Status Checks (CI muss grün sein)
