# Pull Request Review & Merge

Automatisierter PR-Review-Workflow: Prüfen, Suggestions umsetzen, Mergen

> **[GLOBAL POLICY] – verbindlich (Issue #7):**
> - PRs immer gegen `testing`, nie direkt gegen `staging` oder `main`
> - **Merge auf `main` nur mit expliziter schriftlicher Freigabe** – niemals eigenständig
> - `--delete-branch` nur für Feature-Branches (nie `staging`/`testing`)
> - `--no-verify` nur auf explizite Bitte
> - Vor Merge immer Copilot-Suggestions abwarten und prüfen

## Ziel
Einen Pull Request gründlich prüfen, Code-Review-Suggestions umsetzen und für Merge vorbereiten.

## Workflow

### 1. PR Status prüfen
- Zeige PR-Details (Titel, Beschreibung, Files Changed)
- Prüfe ob PR-Ziel-Branch aktuell ist mit main/staging
- Falls outdated: Frage ob Target-Branch in PR-Branch gemergt werden soll
- Prüfe CI/CD Status (Tests, Linting, Build)
- Zeige offene Review-Comments

### 2. Code Review durchführen
- Zeige alle Changed Files
- Prüfe auf häufige Probleme:
  - Hardcodierte Strings (sollten i18n nutzen)
  - Console.log Statements
  - Fehlende Error Handling
  - Code-Duplikation
  - Fehlende Tests für neue Features
  - Breaking Changes ohne CHANGELOG Update
  - Versions-Inkonsistenz (package.json vs app.json)

### 3. Review-Suggestions umsetzen
- Liste alle offenen Review-Comments
- Für jeden Comment:
  - Zeige Context (File, Line, Comment)
  - Frage ob Suggestion umgesetzt werden soll
  - Setze Änderung um
  - Markiere Comment als "Resolved"

### 4. Tests & Validierung
- Führe Tests aus: `npm run test`
- Führe Linting aus: `npm run lint`
- Führe Type-Check aus: `npm run type-check` (falls TypeScript)
- Prüfe Build: `npm run build`
- Falls Fehler: Zeige Fehler und biete Fixes an

### 5. CHANGELOG & Dokumentation
- Prüfe ob CHANGELOG.md aktualisiert wurde
- Falls neue Features/Breaking Changes: Schlage CHANGELOG-Eintrag vor
- Prüfe ob README/Docs aktualisiert werden müssen

### 6. Merge vorbereiten
- Prüfe ob alle Checks grün sind
- Prüfe ob mindestens 1 Approval vorhanden (falls erforderlich)
- Zeige Merge-Status (Ready to merge? Conflicts?)
- Falls Konflikte: Zeige betroffene Files

### 7. Merge durchführen (nur wenn bestätigt)
**WICHTIG:** Vor Merge nochmal bestätigen lassen!

- Merge-Strategie wählen:
  - **Squash Merge** (empfohlen für Feature-Branches)
  - **Merge Commit** (für Release-Branches)
  - **Rebase Merge** (für saubere Historie)
- PR mergen via `gh pr merge [PR-Number] --[strategy]`
- Feature-Branch löschen (lokal und remote)
- Ausgabe: "✅ PR #XX successfully merged and branch deleted"

### 8. Post-Merge Cleanup
- Checkout zurück zu main/staging/testing
- Pull neueste Änderungen
- Zeige nächste offene PRs (falls vorhanden)

## Fehlerbehandlung

### CI/CD Fails
- Zeige Fehler-Log
- Biete Fixes für häufige Probleme:
  - Test Failures → Zeige failed Tests, biete Fixes
  - Linting Errors → Auto-fix via `npm run lint -- --fix`
  - Build Errors → Zeige Fehler, analysiere Ursache

### Merge Conflicts
- Zeige betroffene Files
- Biete manuelle Resolution an:
  ```bash
  git checkout [pr-branch]
  git merge [target-branch]
  # Resolve conflicts manually
  git add .
  git commit -m "Resolve merge conflicts"
  git push
  ```

### Outdated Target Branch
- Empfehlung: Target-Branch in PR-Branch mergen
  ```bash
  git checkout [pr-branch]
  git merge origin/[target-branch]
  git push
  ```

## Sicherheitschecks

**KRITISCH - NIEMALS automatisch mergen wenn:**
- ❌ CI/CD Tests fehlgeschlagen
- ❌ Merge Conflicts vorhanden
- ❌ Keine Approvals (falls erforderlich)
- ❌ Target-Branch ist `main` oder `production` (extra Vorsicht!)

**Immer fragen vor:**
- Breaking Changes
- Dependency Updates (major versions)
- Konfigurationsänderungen (.github/, .env, etc.)

## Best Practices

✅ **Do:**
- Gründlich prüfen vor Merge
- Alle Review-Suggestions durchgehen
- Tests lokal laufen lassen
- CHANGELOG aktualisieren

❌ **Don't:**
- Nicht blind auto-mergen
- Nicht ohne Tests mergen
- Nicht direkt zu `main` mergen (außer Hotfixes)
- Nicht alte PRs mergen ohne Re-Review
