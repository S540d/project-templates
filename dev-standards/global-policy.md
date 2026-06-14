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
- **CI erzwingt lint/type-check/test bei jedem PR** (`ci-quality.yml`, required in Node-Repos — siehe Tabelle „Required Status Checks pro Repo-Typ"). Optionaler lokaler `pre-push` als schnelles Vorab-Feedback — kein Gate (umgehbar via `--no-verify`, nur auf explizite Bitte).
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

## PR-Review & Merge-Gate (kostenlos + abo-basiert)
Die früher metered, pro PR laufende Anthropic-API ist abgelöst. Neues Modell:

1. **Kostenloses Gate (automatisch):** `mergeability.yml`
   (`reusable-mergeability.yml@v2`) läuft bei jedem PR, postet einen
   Sticky-Mergeability-Kommentar und setzt `review-gate`
   (grün ohne Konflikt, rot bei Konflikt). Reine GitHub-API, keine API-Kosten.
   CI-Quality + Security-Scan bleiben eigene required Checks.
2. **Tiefer KI-Review (primär, abo-basiert):** `/review` aus Claude Code (Pro/Max)
   — lokal am PC oder per Web-Session vom Telefon, ohne Pay-per-Token.
3. **Optionaler API-Fallback:** Label `ai-review` triggert `pr-review.yml`
   (`reusable-pr-review.yml@v2`, Haiku) — rein beratend, ⚠️ metered.

Du merged manuell, sobald CI grün und `review-gate` grün sind.
`ANTHROPIC_API_KEY` ist nur noch für den optionalen Fallback nötig (kein Pflicht-Secret).

## Branch Protection (Rulesets)
`main` und `testing` sind in allen Repos per Ruleset geschützt:
- Deletion blockiert
- Non-fast-forward blockiert
- Required Status Checks (siehe Tabelle unten)

### Required Status Checks pro Repo-Typ (Issue #69)

Der `quality / quality`-Check (lint + type-check + test via `reusable-ci-quality.yml`)
ist **nur in Repos mit Node-Projekt** (`package.json`) verpflichtend. Reine
Doku-/Template-Repos ohne `package.json` haben nichts zu linten/testen — dort
würde der Check mangels Lockfile (`npm ci`) immer scheitern.

| Repo-Typ | Beispiel | `review-gate` | `mergeability / mergeability` | `quality / quality` |
|---|---|:---:|:---:|:---:|
| **Node-App** (hat `package.json`) | EPG, Eisenhauer, 1x1_Trainer, DrawFromMemory, Pflanzkalender, safe_my_plants, CD-to-Spotify, epic_Calendar | ✅ required | ✅ required | ✅ **required** |
| **Doku-/Template-Repo** (kein `package.json`) | project-templates | ✅ required | ✅ required | ❌ **nicht eintragen** |

**Einrichtung in einem Node-Repo:**
1. Caller kopieren: `automation-templates/ci-cd-{web,react-native}.yml` → `.github/workflows/ci-quality.yml`
2. **Erst nach dem ersten erfolgreichen Lauf** `quality / quality` als required Status-Check ins Ruleset eintragen (sonst wartet GitHub auf einen nie laufenden Check).
