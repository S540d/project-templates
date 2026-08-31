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

## README Standard (Issue #80)

Gilt für alle Web-/PWA-/App-Projekte:

- **Kein `## Setup`-Abschnitt** — Entwickler-Einrichtung gehört in `CLAUDE.md`, nicht in README.
- **Kein Verweis auf Play Store oder App Store** — der README ist neutral; er impliziert nicht, dass es eine App gibt.
- **Web-Link angeben** — der Leser darf die Web-Version nutzen; der Link ist der primäre Einstieg.
- **Features aktuell halten** — bei neuen Features/Commits die Features-Liste im README mitpflegen.
- **Struktur:** Titel + Kurzbeschreibung → Live-Link → Tech Stack → Features → License.

Hardware-/Tool-Projekte ohne Web-Version sind ausgenommen.

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

## Memory vs. CLAUDE.md (Issue #94)

Faustregel, wann eine Erkenntnis in die auto-memory gehört und wann ins
projekteigene `CLAUDE.md`:

| | **CLAUDE.md** | **Memory** |
|---|---|---|
| Inhalt | Bewusst verfasste, stabile Projekt-Doku: Architektur, Konventionen, Deploy-Prozess, Setup | Informelle, aus Konversationen abgeleitete Lektionen/Fallstricke/Entscheidungen |
| Pflege | Von Hand geschrieben und aktualisiert | Automatisch von Claude während der Arbeit geschrieben |
| Geltung | Für alle Menschen im Projekt lesbar, versioniert, Teil des Repos | Nur für Claude selbst, sessionübergreifend, gitignored |
| Lebensdauer | Dauerhaft, solange die Doku stimmt | Kann veralten, wird bei Bedarf korrigiert/gelöscht |

**Hochstufen:** Tritt ein Memory-Fallstrick wiederholt auf (≥ 2× in
unterschiedlichen Sessions relevant) oder betrifft er eine Struktur-
entscheidung, die jeder Mitentwickler kennen müsste (z. B. „`docs/private/`
ist der falsche Ort, echte Doku liegt in `docs/`"), gehört er nach
`CLAUDE.md` hochgestuft — und der Memory-Eintrag wird danach entfernt
(kein Duplikat an zwei Orten).

**Beispiel:** Ein einmalig aufgetretener Verwechslungs-Fallstrick
(„Play-Store-Listing existierte doppelt") bleibt Memory, solange er nicht
strukturell ist. Eine dauerhafte Konvention („Doku für Menschen liegt in
`docs/`, nicht in `docs/private/`") gehört in `CLAUDE.md`.

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

## Merge-Methode zentral erzwingen (Squash-only)

**Problem (wiederkehrend, u.a. Issue #101):** Die Squash-Merge-Policy stand bisher
nur als Konvention in diesem Dokument (`gh pr merge <nr> --squash`). Nichts
verhinderte einen versehentlichen Merge-Commit oder Rebase-Merge über die
GitHub-Web-UI — und genau diese Abweichung bricht Annahmen, auf denen andere
Tools aufbauen (z.B. die Branch-Erkennung im `aufräumen`-Skill, die bei
Squash-Merges bewusst auf PR-Historie statt `git branch --merged` ausweicht).

**Lösung:** Die Merge-Methode ist eine Repo-Einstellung, kein Ruleset-Feature
(GitHub-Rulesets können sie nicht einschränken). `scripts/apply-rulesets.sh`
setzt sie deshalb zusätzlich zum Ruleset per PATCH auf `repos/{owner}/{repo}`:

```bash
gh api repos/S540d/<repo> --method PATCH \
  -f allow_squash_merge=true \
  -f allow_merge_commit=false \
  -f allow_rebase_merge=false \
  -f delete_branch_on_merge=true \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY
```

- `allow_merge_commit=false`, `allow_rebase_merge=false` → in der Web-UI steht
  nur noch „Squash and merge" zur Auswahl, ein versehentlicher Nicht-Squash-Merge
  ist strukturell ausgeschlossen.
- `delete_branch_on_merge=true` → ersetzt die bisherige manuelle Empfehlung
  („Settings → General → Automatically delete head branches") durch eine
  zentral erzwungene Einstellung.
- Gilt für **alle Repos**, unabhängig vom Ruleset-Typ (base/web/react-native).

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

### Kein Admin-Bypass in `bypass_actors` (Issue: EnergyPriceGermany PR #404, Audit 2026-08-31)

`bypass_actors` in **allen** Ruleset-Vorlagen (`github-ruleset-protect-main-*.json`) ist
**leer** (`[]`) — **kein** `RepositoryRole`-Eintrag mit `bypass_mode: "always"` mehr, auch
nicht für Admins/Owner.

**Warum:** Bei EnergyPriceGermany hat genau dieser Bypass PR #404 den `testing`-Branch
versehentlich löschen lassen (Release-PR `testing → main` mit „Automatically delete head
branches" aktiv — der Bypass machte die `deletion`-Regel im Ruleset wirkungslos, weil die
mergende Admin-Rolle sie ohnehin umgehen durfte). Ein Audit am 2026-08-31 fand dasselbe
Muster (`actor_id: 5, actor_type: "RepositoryRole", bypass_mode: "always"`) identisch in
**allen** `protect-main`- und `protect-testing`-Rulesets von Eisenhauer, 1x1_Trainer,
safe-my-plants, Pflanzkalender, CalibrateMyTelescope und project-templates selbst — die
Lücke kam offenbar direkt aus dieser zentralen Vorlage und wurde beim Rollout auf alle
Repos übertragen. Am 2026-08-31 in allen sechs Repos sowie in den vier
`github-ruleset-protect-main-*.json`-Vorlagen behoben (`bypass_actors: []`), verifiziert
via `git push origin --delete testing` → `GH013: Cannot delete this branch`.

**Konsequenz für den Release-Workflow:** `gh pr merge <nr> --admin` beim `testing → main`-PR
(Zeile „Merge auf main braucht `--admin`" oben) hebelt jetzt **nichts** mehr aus — die
`pull_request`-Regel verlangt ohnehin nur `required_approving_review_count: 0`, das war
nie der Blocker. Der `--admin`-Flag bleibt als Vorsichtsmaßnahme dokumentiert, ist aber
kein Bypass eines aktiven Schutzes mehr. Falls ein Repo künftig einen echten Admin-Bypass
braucht (z. B. Hotfix an tot geglaubtem CI), das bewusst und projektlokal entscheiden —
nicht wieder pauschal in die zentrale Vorlage aufnehmen.

**Verantwortung bei neuen/geänderten Rulesets:** Beim Anlegen oder Ändern eines Rulesets
mit `deletion`-Regel immer `bypass_actors: []` setzen und mit `current_user_can_bypass`
in der API-Antwort verifizieren (`"never"` erwartet), nicht nur prüfen, ob die Regel
`deletion` überhaupt existiert — ein vorhandener `always`-Bypass macht sie wirkungslos.

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

## Code-Formatierung: Prettier bleibt repo-lokal (Issue #93)

**Entscheidung (2026-08-29): `.prettierrc.json` wird bewusst NICHT vereinheitlicht.**

Jedes aktive Repo hat eine historisch gewachsene, in sich stimmige Prettier-Config
(Unterschiede v. a. bei `arrowParens`, `trailingComma`, bei safe-my-plants zusätzlich
`semi: false` und `printWidth: 120`). Diese Unterschiede bleiben bestehen.

**Begründung:** Die üblichen Argumente für eine einheitliche Formatierung greifen bei
einem Solo-Entwickler nicht — es gibt keine fremden Configs, die in derselben Datei
kollidieren, und keine Style-Diskussionen im Review. Prettier formatiert beim Speichern
ohnehin auf die jeweils lokale Config, Copy-Paste zwischen Projekten kostet also nichts.
Dem stünde ein repoweiter Reformat-Commit pro Projekt gegenüber, der die
`git blame`-Historie praktisch jeder Zeile überschreibt.

**Konsequenzen:**

- `sync-standards.sh` überschreibt eine vorhandene `.prettierrc.json` **nicht**. Sie wird
  nur angelegt, wenn im Zielprojekt noch gar keine existiert (dann als Startwert aus
  `dev-standards/base/.prettierrc.json`).
- `dev-standards/base/.prettierrc.json` ist damit **Startwert für neue Projekte**, nicht
  Quelle der Wahrheit für bestehende.
- Kein projektweiter `prettier --write`-Lauf auf Bestandsrepos. Formatierung ändert sich
  nur dort, wo ohnehin am Code gearbeitet wird.
- `.editorconfig` wird weiterhin synchronisiert — es beschreibt Editor-Verhalten
  (Zeilenenden, Einrückung) und erzeugt keine Reformat-Diffs.

Wenn ein Repo seine Config ändern will, ist das eine lokale Entscheidung dieses Repos
und braucht keinen Abgleich mit project-templates.

## Lokaler Cache-Cleanup

Neben dem GitHub-Actions-Cache (`cache-cleanup.yml`, wöchentlich) gibt es einen
lokalen Cache-Cleanup-Mechanismus für `node_modules`/`dist`/`build`/`.expo`/
Gradle-Caches: `scripts/clean-local-cache.sh` + Claude-Command `/cache-clean`.
Bewusst **manuell**, kein automatischer Cron/launchd-Job — der Cleanup wird bei
Bedarf selbst ausgelöst (z. B. im Rahmen des Tagesabschlusses).
