# GitHub Branch Protection Rulesets

Einheitliche Branch Protection Rules für alle Projekte.

> **Merge-Methode (Squash-Default, Merge-Commit für Sync-/Release-PRs erlaubt)
> ist kein Ruleset-Feature.** GitHub-Rulesets können die erlaubte Merge-Methode
> nicht einschränken — das ist eine separate Repo-Einstellung
> (`allow_squash_merge`/`allow_merge_commit`/`allow_rebase_merge`/
> `delete_branch_on_merge`). `scripts/apply-rulesets.sh` setzt sie zusätzlich zum
> Ruleset. Details: `dev-standards/global-policy.md`, Abschnitt „Merge-Methode
> zentral erzwingen".

> **Getrennte Rulesets pro Branch (Issue #122, seit 2026-09-03).** Bis dahin
> deckte ein gemeinsames `protect-main`-Ruleset sowohl `main` als auch `testing`
> ab. Das machte `bypass_actors` unteilbar zwischen den Branches und war die
> strukturelle Ursache eines 13h-Datenausfalls bei EnergyPriceGermany (#446):
> `bypass_actors: []` blockierte dort auch den Push einer Automation auf
> `testing`, weil sich das nicht branchspezifisch öffnen ließ. Seitdem hat
> jedes Repo zwei Rulesets — `protect-main` (nur `refs/heads/main`) und
> `protect-testing` (nur `refs/heads/testing`) — mit identischen Regeln, aber
> unabhängig konfigurierbaren `bypass_actors`. Details:
> `dev-standards/global-policy.md`, Abschnitt „Soll-Struktur Rulesets".

## Verfügbare Rulesets

### Basis (von `scripts/apply-rulesets.sh` verwendet)

- `github-ruleset-protect-main.json` — nur `refs/heads/main`
- `github-ruleset-protect-testing.json` — nur `refs/heads/testing`

Rules: `deletion`, `non_fast_forward`, `pull_request` (0 required approvals).
Kein `required_status_checks` — die konkreten Checks unterscheiden sich je
CI-Setup und werden projektlokal ergänzt oder über die Web-/React-Native-
Varianten unten abgedeckt.

### 1. `github-ruleset-protect-main-react-native.json` / `github-ruleset-protect-testing-react-native.json`
Für React Native Projekte (1x1_Trainer, EnergyPriceGermany, Pflanzkalender, DrawFromMemory)

**Required Status Checks:**
- `code-quality` - Code Quality & Linting
- `build-web` - Web Build
- `review-gate` - Merge-Gate

### 2. `github-ruleset-protect-main-web.json` / `github-ruleset-protect-testing-web.json`
Für Web/PWA Projekte (Eisenhauer)

**Required Status Checks:**
- `code-quality` - Code Quality & Linting
- `build-web` - Web Build
- `review-gate` - Merge-Gate

## Was die Rulesets schützen

### ✅ Aktivierte Regeln:

1. **Pull Request Rule** (optional)
   - `required_approving_review_count: 0` - Keine Review erforderlich (für Solo-Development)
   - Kann auf `1` gesetzt werden, wenn du Reviews möchtest

2. **Required Status Checks**
   - CI/CD Workflows müssen erfolgreich sein
   - Code-Quality Checks müssen passieren
   - Build muss erfolgreich sein
   - `strict_required_status_checks_policy: false` - Branch muss nicht aktuell sein

3. **Non-Fast-Forward**
   - ⛔ Verhindert Force Pushes (`git push --force`)
   - Schützt vor versehentlichem Überschreiben der Historie

4. **Bypass Actors — bewusst leer**
   - Kein `RepositoryRole`-Bypass mehr (siehe `dev-standards/global-policy.md` →
     „Kein Admin-Bypass in `bypass_actors`"). Ein `always`-Admin-Bypass macht die
     `deletion`-Regel wirkungslos und hat bei EnergyPriceGermany (PR #404) zum
     versehentlichen Löschen von `testing` geführt (Release-PR `testing → main`
     mit „Automatically delete head branches" aktiv).
   - `gh pr merge --admin` funktioniert trotzdem weiter, solange die `pull_request`-
     Regel `required_approving_review_count: 0` hat — der Flag hebelt dann nichts
     Aktives mehr aus, ist also risikolos beizubehalten.

## Installation

Am einfachsten über `scripts/apply-rulesets.sh` (bestehende Repos, beide
Rulesets) bzw. `scripts/setup-branch-protection.sh PROJEKT_NAME [react-native|web]`
(neue Repos). Manuell:

### Option 1: Via GitHub CLI (Empfohlen)

```bash
# Für React Native Projekt — beide Rulesets anlegen
cd /path/to/projekt
gh api repos/S540d/PROJEKT_NAME/rulesets \
  --method POST \
  --input /path/to/project-templates/github-ruleset-protect-main-react-native.json
gh api repos/S540d/PROJEKT_NAME/rulesets \
  --method POST \
  --input /path/to/project-templates/github-ruleset-protect-testing-react-native.json

# Für Web Projekt — beide Rulesets anlegen
gh api repos/S540d/Eisenhauer/rulesets \
  --method POST \
  --input /path/to/project-templates/github-ruleset-protect-main-web.json
gh api repos/S540d/Eisenhauer/rulesets \
  --method POST \
  --input /path/to/project-templates/github-ruleset-protect-testing-web.json
```

### Option 2: Via GitHub Web UI

Zwei separate Rulesets anlegen (nicht eins mit beiden Branches — macht
`bypass_actors` unteilbar, siehe Hinweis oben):

1. Gehe zu **Settings** → **Rules** → **Rulesets**
2. Klicke **New ruleset** → **New branch ruleset**
3. Für `main`: Name `protect-main`, Target branch `main`
4. Für `testing`: Name `protect-testing`, Target branch `testing`
5. Rules (identisch für beide):
   - ☑️ Require a pull request before merging (optional: 0 approvals)
   - ☑️ Require status checks to pass
     - Add checks: `code-quality`, `build-web`
   - ☑️ Block force pushes
   - ☑️ Restrict deletions
   - Bypass list: **leer lassen** — kein `always`-Admin-Bypass (siehe
     „Bypass Actors — bewusst leer" oben; Ursache von EnergyPriceGermany #404)

## Anpassungen

### Wenn du Reviews verlangen möchtest:

Ändere in der JSON:
```json
"required_approving_review_count": 1
```

### Wenn du Android Builds auch prüfen möchtest:

Füge zu `required_status_checks` hinzu:
```json
{
  "context": "build-android"
}
```

### Wenn du einen weiteren Branch (z.B. `develop`) schützen möchtest:

**Nicht** den bestehenden `ref_name.include` um den weiteren Branch ergänzen
— das koppelt `bypass_actors` zwischen den Branches (Ursache von
EnergyPriceGermany #446, siehe Hinweis oben). Stattdessen ein **eigenes**
Ruleset mit eigenem Namen anlegen:

```json
{
  "name": "protect-develop",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/develop"]
    }
  }
}
```

## Status Checks Namen

Diese Namen müssen mit den Job-Namen in [.github/workflows/ci-cd.yml](.github/workflows/ci-cd.yml) übereinstimmen:

| Job Name in Workflow | Status Check Context |
|---------------------|---------------------|
| `code-quality` | `code-quality` |
| `build-web` | `build-web` |
| `build-android` | `build-android` |
| `platform-checks` | `platform-checks` |
| `version-checks` | `version-checks` |
| `security` | `security` |

## Troubleshooting

### "Required status check has not been run"

**Problem**: Du hast einen Status Check in den Rules, aber der Workflow läuft nicht.

**Lösung**:
1. Pushe einen Commit, um den Workflow zu triggern
2. Oder entferne temporär den Status Check aus dem Ruleset
3. Stelle sicher, dass der Job-Name im Workflow mit dem Context übereinstimmt

### "Cannot push to protected branch"

**Problem**: Force Push wird blockiert.

**Lösung**:
```bash
# Nutze reguläres Push statt Force Push
git pull --rebase origin main
git push origin main
```

### Push/Löschen wird trotz Admin-Rechten blockiert

**Das ist gewollt** (seit 2026-08-31, siehe „Bypass Actors — bewusst leer" oben):
`bypass_actors` ist absichtlich leer, damit `deletion`/`non_fast_forward` auch für
Admins wirksam bleiben. Kein Workaround über die Rules — stattdessen den eigentlichen
Weg nehmen:
1. Force-Push nötig? → `git pull --rebase` + regulärer Push statt `--force`.
2. Branch löschen nötig? → erst per PR/Review-Prozess klären, ob der Branch wirklich
   weg soll; ein `deletion`-Ruleset zu bypassen ist kein legitimer Zeitdruck-Workaround.
3. Tatsächlich mal ein bewusster Bypass nötig? → projektlokal einen befristeten
   `bypass_actors`-Eintrag setzen, direkt danach wieder auf `[]` zurücksetzen — nicht
   dauerhaft in der zentralen Vorlage verankern.

## Best Practices

1. **Status Checks**: Nur kritische Checks als required markieren
2. **Reviews**: Für Solo-Projects `0`, für Teams `1+`
3. **Bypass**: `bypass_actors: []` — kein dauerhafter Admin-Bypass (Issue: EnergyPriceGermany PR #404)
4. **Testing**: Teste das Ruleset mit einem Feature Branch
5. **Updates**: Halte die Required Checks synchron mit deinen Workflows

## Automatisierung

Erstelle ein Setup-Script für neue Projekte:

```bash
#!/bin/bash
# scripts/setup-branch-protection.sh

PROJECT_NAME=$1
PROJECT_TYPE=$2  # "react-native" oder "web"

if [ "$PROJECT_TYPE" = "react-native" ]; then
  RULESET_FILE="github-ruleset-protect-main-react-native.json"
else
  RULESET_FILE="github-ruleset-protect-main-web.json"
fi

gh api repos/S540d/$PROJECT_NAME/rulesets \
  --method POST \
  --input $(dirname "$0")/../$RULESET_FILE

echo "✅ Branch protection rules set up for $PROJECT_NAME"
```

Verwendung:
```bash
./scripts/setup-branch-protection.sh 1x1_Trainer react-native
./scripts/setup-branch-protection.sh Eisenhauer web
```

## Weitere Ressourcen

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Status Checks Documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)
- [Automation Documentation](AUTOMATION_SUMMARY.md)
