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

### Lokales Branch-Cleanup
- Verwaiste Feature-Branches (Upstream `[gone]`, PR gemergt+remote gelöscht) dürfen pauschal lokal gelöscht werden (`git branch -D`).
- **Ausnahme: `main` und `testing` NIE löschen** — auch nicht, wenn ihr Upstream `[gone]` ist. Ein fehlender `origin/main`/`origin/testing` ist ein **wiederherzustellender Defekt**: lokalen Branch behalten und nach origin zurückpushen (testing dabei sinnvoll mit main aktualisieren, sodass testing ≥ main).

## CLAUDE.md Standard

Alle Repos folgen diesem einheitlichen Schema:

| Datei | Status | Zweck |
|---|---|---|
| `CLAUDE.md` (Root) | **committet** | Projektinstruktionen für Claude — öffentlich, versioniert |
| `.claude/commands/` | **committet** | Geteilte Slash-Commands — versioniert (Issue #31) |
| `.claude/settings.local.json`, `.claude/cache/`, `.claude/memory/` | **gitignored** | Maschinenspezifisch, lokal |

### `.gitignore`-Pflichtzeilen für Claude Code
Jedes Repo muss in `.gitignore` enthalten:
```
# Claude Code – nur maschinenspezifische Artefakte ignorieren.
# .claude/commands/ wird bewusst getrackt (Issue #31) → NICHT ignorieren.
.claude/settings.local.json
.claude/cache/
.claude/memory/
```

### Warum
- `CLAUDE.md` im Root wird von Claude Code automatisch gelesen und ist für alle Entwickler sichtbar
- `.claude/commands/` enthält geteilte Slash-Commands, die für alle Entwickler im Repo gelten → versioniert (Issue #31)
- Maschinenspezifische Artefakte (Settings, Cache, Memory) gehören nicht ins Repo

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

### Soll-Struktur Rulesets (Issue #74)

Jedes Repo hat genau **ein** aktives Ruleset `protect-main`, das beide Branches abdeckt.
Weitere Rulesets nur bei bewusstem Bedarf:

| Ruleset | Branches | Rules | Wer hat es |
|---|---|---|---|
| `protect-main` | `main` + `testing` | deletion, non_fast_forward, pull_request, required_status_checks | **alle Repos** |
| `Main` (legacy) | `~DEFAULT_BRANCH` | pull_request approvals=1 + Admin-Bypass | EPG, Eisenhauer, 1x1_Trainer — **deaktiviert** (Issue #74); Approvals werden über protect-main geregelt wenn nötig |

**Bewusst nicht vereinheitlicht / nicht vorhanden:**
- Kein separates `protect-testing`-Ruleset — `protect-main` deckt `testing` bereits ab
- Kein `Copilot review`-Ruleset — Copilot-Review wird nicht mehr genutzt (Issue #74)

**Schutzgrad main vs. testing:**
- `main`: `pull_request` ohne `dismiss_stale_reviews` + `review_gate` required → kein Merge bei Konflikt
- `testing`: gleiche required checks, aber kein Approval nötig — bewusst weniger streng (Feature-Branches landen hier zuerst)

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
| `🔍 Code Quality & Linting` (EPG, Eisenhauer, 1x1_Trainer, DrawFromMemory, Pflanzkalender, CD-to-Spotify, epic_Calendar) oder `lint-and-typecheck` (safe-my-plants) | lint + type-check + test | **ja** | **nur Node-Repos** (Ausnahme: project-templates) |

> **Begründete Abweichung:** Der Quality-Check braucht `package.json`/Lockfile.
> In reinen Doku-/Template-Repos (project-templates) würde `npm ci` immer scheitern
> → dort **nicht** eintragen. Alle anderen Gates gelten ausnahmslos überall.
> Der Check-Context-Name entspricht dem tatsächlichen Job-Namen im jeweiligen `ci-cd.yml`
> (nicht `quality / quality` aus `reusable-ci-quality.yml` — wird nicht genutzt).

**Node-Repos:** EPG, Eisenhauer, 1x1_Trainer, DrawFromMemory, Pflanzkalender,
safe-my-plants, CD-to-Spotify-PWA, epic_Calendar.

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
