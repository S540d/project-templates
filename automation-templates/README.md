# 🤖 Automation Templates

Diese Templates richten automatische Quality Assurance für neue Projekte ein.

## 📁 Struktur

```
automation-templates/
├── README.md                           # Diese Datei
├── .eslintrc.js                        # ESLint Konfiguration
├── platform.ts                         # React Native Platform Utilities
├── AUTOMATION_SETUP.md                 # Setup-Anleitung für Entwickler
├── RELEASE_CHECKLIST.md                # Release Checklist
├── PULL_REQUEST_TEMPLATE.md            # PR Template mit Checkliste
├── pre-commit-react-native             # Pre-commit Hook (React Native)
├── pre-commit-generic                  # Pre-commit Hook (Generic)
├── validate-release-react-native.sh    # Validation Script (React Native)
├── validate-release-web.sh             # Validation Script (Web)
├── validate-release-generic.sh         # Validation Script (Generic)
├── ci-cd-react-native.yml              # GitHub Actions (React Native)
├── ci-cd-web.yml                       # GitHub Actions (Web)
├── ci-cd-generic.yml                   # GitHub Actions (Generic)
├── security-scan.yml                   # Secret-/Token-Scan (Caller → reusable @v1)
├── dependabot.yml                      # Dependency-Updates, gedrosselt (Issue #60, #144)
└── codeql.yml                          # Statische Code-Analyse / SAST (Issue #60)
```

## 🔒 Security-Stack (kostenlos, ohne API)

Drei kostenlose GitHub-native Bausteine ersetzen den früheren metered
Anthropic-API-Scan (Issue #60). Der Anthropic-`pr-review` bleibt nur noch als
optionaler, rein beratender On-demand-Review (Label `ai-review`) bestehen.

| Baustein | Datei (Ziel im Repo) | Deckt ab |
|----------|----------------------|----------|
| Secret-Scan | `.github/workflows/security-scan.yml` | Hardcoded Keys, getrackte Keystores |
| Dependabot | `.github/dependabot.yml` | Verwundbare Dependencies + Actions-Versionen |
| CodeQL | `.github/workflows/codeql.yml` | Code-Schwachstellen (SAST) |

**Ausrollen pro Repo:**
1. `dependabot.yml` → `.github/dependabot.yml` (Ecosystem anpassen, siehe Vorprüfung unten).
2. `codeql.yml` → `.github/workflows/codeql.yml` (nur JS/TS-Repos; `languages` anpassen).
3. In den Repo-Settings unter *Security* die *Dependabot alerts* aktivieren.
4. `ANTHROPIC_API_KEY` bleibt optional — nur nötig, wer den `ai-review`-Fallback nutzt.

### Dependabot: Vorprüfung vor dem Kopieren (Issue #144)

Die Vorlage passt **nicht** uniform auf jedes Repo. Drei Dinge vorher prüfen —
alle drei erzeugen keinen Fehler, sondern still eine falsche oder wirkungslose
Config:

| Prüfen | Womit | Konsequenz |
|--------|-------|------------|
| Ökosystem | `package.json` / `requirements*.txt` / `pyproject.toml` | `pip` statt `npm` (z. B. Boersenspiel); Repos ohne Paketmanager (Shell/Docker) behalten **nur** den `github-actions`-Block |
| Existiert `testing`? | `git show-ref --verify refs/remotes/origin/testing` | **Ohne `testing`-Branch den `target-branch` weglassen.** Ein `target-branch` auf einen nicht existierenden Branch legt Dependabot komplett still — es entstehen gar keine PRs mehr |
| Echter Remote-Name | `git -C <dir> remote get-url origin` | Verzeichnisname ≠ Repo-Name (`EnergyPriceGermany` → `Energy_Price_Germany`, `epic_Calendar/Epic_Calendar`) |

### Drosselung der PR-Flut (Issue #144)

Die Vorlage ist bewusst gedrosselt:

- **`interval: "monthly"`** statt `weekly`.
- **Ein Sammel-Gruppenblock mit `patterns: ["*"]`** statt eines
  `update-types`-Filters. Ein Filter auf `minor`+`patch` lässt Major-Updates
  per Definition aus der Gruppe fallen — genau die lauten Bumps
  (vitest 4→5, vite 7→8) öffnen dann je einen eigenen PR.
- **`target-branch: "testing"`**, weil PRs gegen `main` wegen der
  Ruleset-Pflicht (PR-Review + Status-Checks) nicht direkt mergebar sind.

**Was die Config nicht leistet:**

- `target-branch` wirkt nur auf **neue** PRs. Bereits offene PRs gegen `main`
  bleiben stehen und müssen separat abgeräumt werden.
- GitHubs **Default-Security-Updates ignorieren `target-branch`** und laufen
  weiterhin gegen den Default-Branch. Sie werden von dieser Datei nicht
  gedämpft. Wer sie loswerden will (z. B. bei gestoppten Projekten), schaltet
  sie serverseitig ab — die *Alerts* bleiben davon unberührt:
  ```bash
  gh api -X DELETE repos/<owner>/<repo>/automated-security-fixes   # aus
  gh api -X PUT    repos/<owner>/<repo>/automated-security-fixes   # wieder an
  ```

### Bestehende Configs nachziehen

`sync-standards.sh` legt `dependabot.yml` nur an, wenn **keine** existiert, und
lässt vorhandene bewusst unangetastet (Schutz repo-spezifischer Anpassungen).
Eine geänderte Vorlage erreicht bestehende Repos dadurch **nicht**. Dafür gibt
es ein eigenes Skript, das nur die Drosselungs-Felder patcht:

```bash
./scripts/patch-dependabot-throttle.sh --dry-run /abs/path/repoA /abs/path/repoB
./scripts/patch-dependabot-throttle.sh          /abs/path/repoA /abs/path/repoB
```

Es ist idempotent, validiert das Ergebnis vor dem Schreiben als YAML und
übernimmt den Quote-Stil der Zieldatei (Repos mit Prettier `singleQuote`
lassen sonst den pre-push-Hook scheitern).

## 🚀 Schnellstart

### Für ein neues Projekt:

```bash
cd /path/to/your/new/project

# Automatisches Setup
/path/to/project-templates/scripts/init-automation.sh .
```

### Für ein bestehendes Projekt:

```bash
cd /path/to/your/existing/project

# Automatisches Setup (erkennt Projekttyp automatisch)
/path/to/project-templates/scripts/init-automation.sh .
```

## 🎯 Was wird eingerichtet?

### 1. GitHub Actions CI/CD

**Datei:** `.github/workflows/ci-cd.yml`

**Jobs:**
- Code Quality (console.log, Web APIs, TypeScript)
- Build Tests (Web/Android je nach Projekttyp)
- Platform Checks (Version Consistency, UX Guidelines)
- Security Audit

**Blockiert PRs** bei Fehlern!

### 2. Pre-Commit Hooks

**Datei:** `.husky/pre-commit`

**Prüft automatisch** bei jedem `git commit`:
- Keine console.log
- Web APIs mit Platform Checks (React Native)
- Version Consistency

**Verhindert** fehlerhafte Commits!

### 3. Release Validation

**Datei:** `scripts/validate-release.sh`

**Läuft manuell** vor Release:
```bash
npm run validate
```

**Prüft:**
- Version Consistency
- Code Quality
- Build Success
- UX Guidelines
- Security

### 4. Dokumentation

**Dateien:**
- `AUTOMATION_SETUP.md` - Setup-Guide
- `RELEASE_CHECKLIST.md` - Checklist für Releases

### 5. Platform Utilities (React Native)

**Datei:** `utils/platform.ts`

Sichere Wrappers für Web APIs:
```typescript
import { Storage, getSystemDarkModePreference } from './utils/platform';

// Statt localStorage direkt:
await Storage.setItem('key', 'value'); // ✅ Works on Web + Mobile

// Statt window.matchMedia direkt:
const isDark = getSystemDarkModePreference(); // ✅ Safe
```

## 📋 Projekttypen

Das Init-Script erkennt automatisch:

### React Native / Expo
- Prüft auf `react-native` oder `expo` in package.json
- Richtet Platform-Checks ein
- Kopiert `platform.ts` Utilities
- Konfiguriert Android + Web Builds

### Web / React
- Prüft auf `react` in package.json
- Keine Platform-Checks nötig
- Web-only Build Tests

### Generic Node.js
- Fallback für andere Projekte
- Basis ESLint + Validation

## 🔧 Anpassung

### Eigene Checks hinzufügen

**Pre-Commit Hook** (`.husky/pre-commit`):
```bash
# Eigener Check
echo "Checking custom rule..."
if grep -r "CUSTOM_PATTERN" src/; then
  echo "❌ ERROR: Custom pattern found!"
  exit 1
fi
```

**Validation Script** (`scripts/validate-release.sh`):
```bash
# Eigene Validierung
echo "Running custom validation..."
./my-custom-check.sh
```

**GitHub Actions** (`.github/workflows/ci-cd.yml`):
```yaml
- name: Custom Check
  run: |
    echo "Running custom check..."
    npm run custom-check
```

### Template aktualisieren

Wenn du Verbesserungen machst:

1. **Teste** im 1x1_Trainer Projekt
2. **Kopiere** erfolgreiche Änderungen nach `automation-templates/`
3. **Commite** zu project-templates Repo
4. **Andere Projekte** können mit `init-automation.sh` updaten

## 📊 Automatisierungsgrad

| Kategorie | Auto | Manuell |
|-----------|------|---------|
| Code Quality | 90% | 10% |
| Platform Safety | 100% | - |
| Build Tests | 100% | - |
| Version Consistency | 100% | - |
| UX Guidelines | 60% | 40% |
| Security | 80% | 20% |

## 🎯 Best Practices

### Do's ✅
- **Verwende** `// platform-safe` Kommentar für sichere Web API Calls
- **Teste** Automation Setup in Testprojekt bevor du es überall ausbringst
- **Aktualisiere** Templates regelmäßig
- **Dokumentiere** projekt-spezifische Anpassungen

### Don'ts ❌
- **Keine** Web APIs ohne Platform Check (React Native)
- **Keine** console.log in Production Code
- **Keine** Hardcoded Credentials
- **Nicht** Husky Hooks mit `--no-verify` umgehen

## 🚀 Workflow Beispiel

### Neues Feature entwickeln

```bash
# 1. Feature entwickeln
vim src/feature.ts

# 2. Committen (Pre-commit läuft automatisch)
git add .
git commit -m "feat: new feature"
# ✅ Pre-commit checks passed!

# 3. Push (GitHub Actions läuft automatisch)
git push origin feature-branch
# ✅ CI/CD pipeline running...

# 4. PR erstellen
# → PR Template mit Checklist erscheint automatisch
# → CI/CD muss grün sein bevor merge möglich
```

### Release durchführen

```bash
# 1. Validation laufen lassen
npm run validate
# ✅ All checks passed!

# 2. Manuelle Tests
# ... teste auf Devices ...

# 3. Release
git tag v1.0.0
git push origin v1.0.0
npm run deploy
```

## 📚 Weitere Ressourcen

- [AUTOMATED_QUALITY_CHECKLIST.md](../AUTOMATED_QUALITY_CHECKLIST.md) - Umfassende Checklist
- [ux-vorgaben.md](../ux-vorgaben.md) - UX Guidelines
- [technische_vorgaben.md](../technische_vorgaben.md) - Technische Standards
- [PUBLISHING_CHECKLIST.md](../PUBLISHING_CHECKLIST.md) - Publishing Guide

## 💡 Fragen?

Siehe:
- `AUTOMATION_SETUP.md` (wird in jedes Projekt kopiert)
- `AUTOMATED_QUALITY_CHECKLIST.md` (Master-Dokumentation)
- 1x1_Trainer Projekt (Referenz-Implementierung)

---

**Maintained by:** Development Team
**Last Updated:** 2025-12-13
**Version:** 1.0
