# 🤖 Automation Setup Guide

Dieser Guide erklärt die automatisierte Quality Assurance für dieses Projekt.

---

## 📦 Was wurde automatisiert?

### 1. **GitHub Actions CI/CD** (`.github/workflows/ci-cd.yml`)

Läuft automatisch bei jedem:
- Push zu `main` oder `develop`
- Pull Request

**5 Jobs:**
1. **Code Quality** - ESLint, TypeScript, Web API Checks
2. **Build Web** - Web Build Test
3. **Build Android** - Android Build Test
4. **Platform Checks** - Version Consistency, UX Guidelines
5. **Security** - npm audit, Secret Scanning

**Ergebnis:** Pull Requests werden blockiert bei Fehlern ❌

### 2. **Pre-Commit Hooks** (`.husky/pre-commit`)

Läuft automatisch **vor jedem Git Commit**.

**Prüft:**
- ❌ console.log in staged files
- ❌ window.* ohne Platform.OS Check
- ❌ localStorage ohne Platform.OS Check
- ❌ Version inconsistencies

**Ergebnis:** Commit wird abgebrochen bei Fehlern ❌

### 3. **Release Validation Script** (`scripts/validate-release.sh`)

Läuft **manuell** vor jedem Release.

**Prüft alles:**
- Version Consistency (5 Dateien)
- Code Quality
- Build Tests (Web + Android)
- UX Guidelines
- Security Audit
- Git Status

**Ergebnis:** Detaillierter Report mit Next Steps ✅

---

## 🚀 Schnellstart

### Installation

Husky Pre-Commit Hooks installieren:

```bash
npm install --save-dev husky
npx husky install
```

### Pre-Commit Hook aktivieren

```bash
chmod +x .husky/pre-commit
git add .husky/pre-commit
git commit -m "Add pre-commit hooks"
```

### Validation Script testen

```bash
./scripts/validate-release.sh
```

---

## 🎯 Workflow für Entwickler

### Bei jeder Code-Änderung

1. **Entwickle** dein Feature
2. **Git Add:** `git add .`
3. **Git Commit:** `git commit -m "feat: my feature"`
   - ✅ Pre-Commit Hook läuft automatisch
   - ❌ Falls Fehler → Fix und retry
4. **Git Push:** `git push origin feature-branch`
   - ✅ GitHub Actions läuft automatisch
   - ❌ Falls Fehler → Fix und force-push

### Vor jedem Release

1. **Validate:** `./scripts/validate-release.sh`
   - ✅ Alle Checks passed → Weiter zu Schritt 2
   - ❌ Fehler → Fix und retry

2. **Manuelle Tests:**
   - [ ] App auf Android-Gerät testen
   - [ ] App im Browser testen
   - [ ] Dark Mode testen
   - [ ] Settings testen

3. **Release:**
   ```bash
   git tag v1.0.9
   git push origin v1.0.9
   npm run deploy  # für Web
   # Upload AAB zu Play Store
   ```

---

## 🔍 Troubleshooting

### "Pre-commit hook failed"

**Problem:** Commit wurde abgebrochen.

**Lösung:**
1. Lies Fehlermeldung
2. Fixe Fehler (z.B. entferne console.log)
3. `git add .` erneut
4. `git commit` erneut

**Bypass (NOT RECOMMENDED):**
```bash
git commit --no-verify -m "message"
```

### "GitHub Actions failed"

**Problem:** PR Check ist rot ❌

**Lösung:**
1. Klicke auf "Details" bei GitHub
2. Lies Job Logs
3. Fixe Fehler lokal
4. Push erneut

**Häufige Fehler:**
- `window.matchMedia` ohne Platform Check → Füge `Platform.OS === 'web'` hinzu
- Version Mismatch → Update alle 5 Version-Dateien
- Build Failed → Teste lokal `npm run build:web`

### "Validation script shows warnings"

**Problem:** `./scripts/validate-release.sh` zeigt Warnungen ⚠️

**Lösung:**
- **Warnings sind OK** (review needed)
- **Errors sind NICHT OK** (must fix)

Warnings z.B.:
- Missing documentation file
- Light theme found (consider System/Dark only)
- npm audit findings

---

## 📊 Status Checks Übersicht

| Check | Tool | Wann | Blockiert |
|-------|------|------|-----------|
| console.log | Pre-commit | Bei Commit | ✅ Ja |
| Web APIs | Pre-commit + CI | Bei Commit + Push | ✅ Ja |
| Version Consistency | CI + Script | Bei Push + Release | ✅ Ja |
| Build Tests | CI | Bei Push | ✅ Ja |
| UX Guidelines | CI + Script | Bei Push + Release | ⚠️ Warning |
| Security Audit | CI + Script | Bei Push + Release | ⚠️ Warning |
| Manual Tests | - | Vor Release | ❌ Nein |

---

## 🎨 UX Guidelines Checks

### Automatisch geprüft ✅

- **Settings Icon:** Muss ⋮ sein (kein ⚙ Emoji)
- **Theme Toggle:** System/Dark (nicht Light/Dark/System)

### Manuell prüfen ⚠️

- Minimalistisches Design (weiß/schwarz Hintergrund)
- Responsives Design (kleine Displays)
- Settings-Modal Layout (Reihenfolge, Abstände)
- App-Name nur in Settings (nicht im Header)
- Buttons mit abgerundeten Ecken
- Emojis sparsam verwenden

**Siehe:** `project-templates/ux-vorgaben.md`

---

## 🔧 Platform Safety Regeln

### ✅ RICHTIG

```typescript
// Web API mit Platform Check
if (Platform.OS === 'web' && window.matchMedia) {
  const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
}

// Storage Adapter verwenden
import { Storage } from './utils/platform';
await Storage.setItem('key', 'value');

// Platform-safe Kommentar
const width = window.innerWidth; // platform-safe: read-only
```

### ❌ FALSCH

```typescript
// Direct window access ohne Check
const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

// localStorage ohne Check
localStorage.setItem('key', 'value');

// typeof window !== 'undefined' reicht NICHT!
if (typeof window !== 'undefined') {
  window.matchMedia(...); // ❌ Crashes on Android!
}
```

**Grund:** React Native hat `window` Object, aber nicht alle Web APIs!

---

## 📚 Weitere Ressourcen

- **Postmortem:** [POSTMORTEM_ANDROID_CRASH.md](POSTMORTEM_ANDROID_CRASH.md)
- **Release Checklist:** [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)
- **PR Template:** [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md)
- **Platform Utils:** [utils/platform.ts](utils/platform.ts)
- **Project Templates:** `/project-templates/AUTOMATED_QUALITY_CHECKLIST.md`

---

## ✅ Cheat Sheet

```bash
# Lokale Validierung vor Commit
./scripts/validate-release.sh

# Pre-Commit Hook neu installieren
npx husky install

# Commit mit allen Checks
git add .
git commit -m "feat: my feature"  # Pre-commit läuft automatisch

# CI/CD Status anschauen
# → GitHub Actions Tab in Repository

# Build lokal testen
npm run build:web
./gradlew assembleRelease

# Release Tag erstellen
git tag v1.0.9
git push origin v1.0.9
```

---

## 🤖 Claude PR-Review

Jeder PR durchläuft automatisch einen deterministischen Review (`reusable-pr-review.yml@v1`):

- Claude reviewt den PR-Diff und postet einen Kommentar (+ Inline-Findings)
- Setzt den required Status-Check **`review-gate`** und vergibt das Status-Label

### Funktionsweise

| Situation | `review-gate` | Label | Merge |
|---|---|---|---|
| Keine Findings | 🟢 grün | `ready to merge` | manuell durch dich |
| Findings vorhanden | 🔴 rot | `needs human review` | erst nach Klärung |
| API-Ausfall / kein Findings-Marker | 🔴 rot | — | gesperrt (fail-closed) |
| Kein `ANTHROPIC_API_KEY` gesetzt | 🟢 grün (übersprungen) | — | frei |

- **Den roten Gate öffnet nur ein sauberer Re-Run** — Findings fixen, pushen, neuer Lauf.
- **Sicherheit:** Bei API-Ausfall / fehlendem Findings-Marker bleibt der Check **rot** (fail-closed).

### Einrichtung pro Repo

1. Secret `ANTHROPIC_API_KEY` (Repo oder Org).
2. Workflow `.github/workflows/pr-review.yml` (ruft `reusable-pr-review.yml@v1`,
   braucht `permissions: pull-requests: write, contents: read, statuses: write`).
3. Labels `ready to merge` + `needs human review` anlegen (via `scripts/setup-labels.sh`).
4. `review-gate` als required status check ins `protect-main`-Ruleset (siehe
   `github-ruleset-protect-main-*.json`).

> ⚠️ Den Ruleset-Check `review-gate` **erst** aktivieren, wenn die Workflows im Repo liegen
> und der Check einmal gelaufen ist — sonst wartet GitHub auf einen nie laufenden Check und
> blockiert jeden PR.

---

**Fragen?** Siehe Dokumentation oder lauf `./scripts/validate-release.sh` für Details.
