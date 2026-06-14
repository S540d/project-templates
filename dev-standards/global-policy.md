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

### Test-Ebenen (Issue #69)

Tests laufen auf zwei Ebenen. **Leitprinzip:** Was als kostenloser Workflow ohne
Claude-API in CI laufen kann, ist **verbindlich auf GitHub** (required Gate) — denn
nur das greift auch in Web-/Telefon-Sessions und ist nicht per `--no-verify`
umgehbar. Alles Weitere läuft **lokal „in der Regel"** (Komfort, kein Gate).

#### Ebene A — verbindlich auf GitHub (required, kostenlos, kein API)

| Check (Status-Context) | Prüft | Node nötig? | Gilt für |
|---|---|:---:|---|
| `review-gate` | Merge-Gate (Konfliktfreiheit) | nein | **alle Repos** |
| `mergeability / mergeability` | Mergeability-Report | nein | **alle Repos** |
| `security-scan / security-scan` | Hardcoded Keys/Tokens + getrackte Secrets | nein | **alle Repos** |
| `gitignore-audit / gitignore-audit` | `.gitignore`-Pflichteinträge + keine Secrets getrackt | nein | **alle Repos** |
| `quality / quality` | lint + type-check + test | **ja** | **nur Node-Repos** (Ausnahme: project-templates) |

> **Begründete Abweichung:** `quality / quality` braucht `package.json`/Lockfile.
> In reinen Doku-/Template-Repos (project-templates) würde `npm ci` immer scheitern
> → dort **nicht** eintragen. Alle anderen Gates gelten ausnahmslos überall.

**Node-Repos:** EPG, Eisenhauer, 1x1_Trainer, DrawFromMemory, Pflanzkalender,
safe_my_plants, CD-to-Spotify, epic_Calendar.

#### Ebene B — lokal „in der Regel" (optional, kein Gate)

| Check | Wo | Hinweis |
|---|---|---|
| `pre-push`: lint + type-check + prettier | Node-Repos | `dev-standards/base/pre-push.base`; umgehbar via `--no-verify` (nur auf explizite Bitte) |
| dev-standards-audit | alle | lokal/wöchentlicher Cron-Audit; **kein** Merge-Gate (würde Repos bei Standards-Drift koppeln) |
| E2E-/Device-Tests | wo nicht CI-machbar | echte Geräte/Secrets/flaky → Release-Checklist, nie Merge-Gate |

**Einrichtung eines neuen Gates pro Repo:**
1. Caller kopieren aus `automation-templates/`:
   - `security-scan.yml`, `gitignore-audit.yml` → `.github/workflows/` (alle Repos)
   - `ci-cd-{web,react-native}.yml` → `.github/workflows/ci-quality.yml` (nur Node-Repos)
2. **Erst nach dem ersten erfolgreichen Lauf** den Status-Check ins Ruleset eintragen
   (sonst wartet GitHub auf einen nie laufenden Check).
