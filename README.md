# Project Templates

Zentrale Vorlagen und Standards für alle Projekte. Diese Templates definieren Best Practices für Code-Qualität, UX/Design, Testing und Accessibility.

---

## Inhalt

### Kernstandards

1. **technische_vorgaben.md**
   - Code-Qualität (Prettier, ESLint, TypeScript)
   - Testing Standards (Vitest, Jest, Playwright)
   - TypeScript Best Practices
   - Package Management
   - Build & Performance
   - Sicherheit (Secrets, Input Validation, HTTPS)
   - CI/CD & GitHub Actions
   - Pre-Production Checklist

2. **ux-vorgaben.md**
   - Design Fundamentals (Mobile First, Progressive Enhancement)
   - Farbpalette & Semantische Farben
   - Typography & Font Selection
   - Spacing System (8px Grid)
   - Responsive Design Breakpoints
   - Komponenten Standards
   - Dark Mode / Theme Support
   - Barrierefreiheit (WCAG 2.1 AA)
   - Interaktion & Feedback
   - UX Checklist

### Spezialrichtlinien

3. **design-system.md**
   - Komponenten-Katalog mit Code-Beispielen
   - Button (Typen, Größen, States)
   - Form Elements (Input, Textarea, Select, Checkbox, Radio)
   - Cards, Modals, Tabs, Alerts
   - Spinner / Loading States
   - Badges
   - Komponenten-Checkliste

4. **accessibility-guidelines.md**
   - WCAG 2.1 Level AA Compliance
   - Keyboard Navigation (Tab Order, Focus Indicators)
   - Color Contrast (4.5:1 minimum)
   - Semantic HTML
   - ARIA Labels & Descriptions
   - Alt Text Richtlinien
   - Form Labels & Error Handling
   - Color Not Only (nicht nur Farbe)
   - Text Resizing & Zoom
   - Motion & Animation
   - Testing & Audit Tools
   - Quick Checklist

5. **testing-standards.md**
   - Testing Pyramid (Unit, Integration, E2E)
   - Unit Tests (Vitest/Jest)
   - Integration Tests
   - E2E Tests (Playwright)
   - Performance Tests (Lighthouse)
   - Accessibility Tests (axe)
   - Test Naming Conventions
   - Pre-Commit Testing (Husky)
   - CI/CD Integration
   - Coverage Reports

### Automation & CI/CD

5.1 **automation-templates/** (NEU - Automatische Quality Checks)
   - **scripts/init-automation.sh** - One-Command Setup für jedes Projekt
   - **CI/CD Workflows** (GitHub Actions):
     - ci-cd-react-native.yml - React Native + Web + Android
     - ci-cd-web.yml - Web/PWA Projekte
     - ci-cd-generic.yml - Generic Node.js Projekte
   - **Pre-Commit Hooks** (Husky):
     - Verhindert console.log in Production Code
     - Validiert Platform.OS bei Web APIs
     - Prüft Version-Konsistenz
   - **Validation Scripts**:
     - validate-release-react-native.sh
     - validate-release-web.sh
     - validate-release-generic.sh
   - **Platform Utilities** (platform.ts)
   - **Dokumentation**: AUTOMATION_SETUP.md, RELEASE_CHECKLIST.md

5.2 **AUTOMATED_QUALITY_CHECKLIST.md**
   - Komplette Checkliste aller automatisierten Quality Checks
   - 90%+ Automatisierung für Code-Qualität
   - Setup-Guide für Automatisierung
   - Best Practices

5.3 **QUICK_START.md**
   - One-Command Setup: `cd Projekt && /path/to/init-automation.sh . && npm install`
   - Schnelleinstieg für neue Projekte

### Deployment & Publishing

6. **PUBLISHING_CHECKLIST.md**
   - Checkliste für das Veröffentlichen von GitHub Pages PWAs
   - Optische Vorgaben (Design, Theme, Components)
   - Technische Konfiguration (GitHub Actions, PWA, Service Worker)
   - Code-Qualität Checkliste
   - Repository Setup
   - Sicherheit & Rechtliches
   - Dokumentation

7. **PLAYSTORE_STATUS_OVERVIEW.md** (NEW)
   - Zentrale Statusübersicht für alle 5 Projekte
   - Quick Status Dashboard (Tabelle)
   - Detaillierte Status & Timeline für jedes Projekt
   - Week-by-week Implementation Plans
   - Konsolidierter Timeline Overview
   - Links zu projekt-spezifischen Checklisten
   - Weekly Sync Template & Key Metrics

8. **GOOGLE_PLAY_STORE_ROADMAP.md**
   - Komplette Roadmap für Google Play Store Veröffentlichung aller Projekte
   - Phase-by-Phase Implementation Guides mit Checklisten
   - Technische Anforderungen (Android SDK, Build, Signing)
   - Store Listing Requirements (Text, Graphics, Assets)
   - Privacy & Security Requirements
   - Pre-Launch und Post-Launch Checklisten
   - Projekt-spezifische Setup-Anforderungen

### GitHub Integration

9. **.github/ISSUE_TEMPLATE/** (Zentrale Issue Templates)
   - `bug.md` - Bug Reports
   - `feature.md` - Feature Requests
   - `documentation.md` - Documentation Requests
   - `question.md` - Questions / Discussions

10. **.github/PULL_REQUEST_TEMPLATE/** (Zentrale PR Templates)
   - `default.md` - Standard PR Template mit Checklisten

11. **.github/README.md**
   - Dokumentation der GitHub Templates
   - Best Practices für Issues und PRs
   - Verwendung und Anpassung

---

## Verwendung in Projekten

Diese Templates werden als Git-Submodul in Projekte eingebunden:

```bash
git submodule add <repo-url> .templates
```

Dann sind alle Templates verfügbar unter `.templates/`:

```
.templates/
├── README.md                           # Diese Datei
├── technische_vorgaben.md              # Technische Standards
├── ux-vorgaben.md                      # UX/Design Standards
├── design-system.md                    # Komponenten-Katalog
├── accessibility-guidelines.md         # WCAG 2.1 AA Guidelines
├── testing-standards.md                # Testing Best Practices
├── PUBLISHING_CHECKLIST.md             # Publishing Checklist
│
└── .github/
    ├── README.md                       # GitHub Templates Dokumentation
    ├── ISSUE_TEMPLATE/
    │   ├── bug.md                      # Bug Report Template
    │   ├── feature.md                  # Feature Request Template
    │   ├── documentation.md            # Documentation Request Template
    │   └── question.md                 # Question / Discussion Template
    │
    └── PULL_REQUEST_TEMPLATE/
        └── default.md                  # Standard PR Template
```

## Verwendung der GitHub Templates

Die `.github` Templates können auf verschiedene Weisen in dein Projekt übernommen werden:

### Option 1: Kopieren (Einfach)
```bash
# Kopiere die .github Verzeichnisse ins Projekt
cp -r .templates/.github .
```

### Option 2: Symlink (Aktualisierbar, nur macOS/Linux)
```bash
# Erstelle Symlinks zu den Templates
ln -s .templates/.github/ISSUE_TEMPLATE .github/ISSUE_TEMPLATE
ln -s .templates/.github/PULL_REQUEST_TEMPLATE .github/PULL_REQUEST_TEMPLATE
```

### Option 3: Anpassung (Empfohlen)
```bash
# Kopiere Templates als Basis
cp -r .templates/.github .

# Bearbeite für dein Projekt (z.B. projekt-spezifische Checklisten)
vim .github/PULL_REQUEST_TEMPLATE/default.md
```

**Siehe auch:** [.github/README.md](.github/README.md) für Dokumentation und Best Practices

---

## Quick Start für neues Projekt

### ⚡ Automatisches Setup (Empfohlen)

**One-Command Setup** für sofortige Automatisierung:

```bash
# Wechsle ins Projektverzeichnis
cd MeinProjekt

# Führe das Automation-Setup aus
/pfad/zu/project-templates/scripts/init-automation.sh .

# Installiere Dependencies (inklusive Husky)
npm install

# Teste die Automatisierung
npm run validate
```

Das Setup-Script erkennt automatisch deinen Projekttyp (React Native, Web, oder Generic) und richtet ein:
- ✅ GitHub Actions CI/CD Pipeline
- ✅ Pre-Commit Hooks (Husky)
- ✅ Validation Script
- ✅ Platform Utilities (bei React Native)
- ✅ Dokumentation (AUTOMATION_SETUP.md, RELEASE_CHECKLIST.md)

**Siehe auch:** [QUICK_START.md](QUICK_START.md) und [AUTOMATION_SUMMARY.md](AUTOMATION_SUMMARY.md)

---

### 📋 Manuelles Setup (wenn du mehr Kontrolle brauchst)

1. **Technische Setup** - Lese `technische_vorgaben.md` für:
   - ESLint & Prettier Konfiguration
   - Vitest Setup
   - GitHub Actions Workflows

2. **Automation Setup** - Nutze `automation-templates/` für:
   - CI/CD Pipeline (GitHub Actions)
   - Pre-Commit Hooks (Husky)
   - Validation Scripts
   - Platform-Safe Utilities

3. **UX/Design Setup** - Nutze `ux-vorgaben.md` für:
   - Color Palette definieren (CSS Variables)
   - Typography konfigurieren
   - Responsive Breakpoints setzen
   - Dark Mode implementieren

4. **Komponenten** - Referenziere `design-system.md` für:
   - Button Komponenten
   - Form Elements
   - Modals und andere häufige Komponenten

5. **Accessibility** - Checke `accessibility-guidelines.md` für:
   - WCAG 2.1 AA Compliance
   - Keyboard Navigation
   - Screen Reader Support
   - Color Contrast

6. **Testing** - Implementiere Tests nach `testing-standards.md`:
   - Unit Tests (Vitest)
   - E2E Tests (Playwright)
   - 60%+ Coverage Ziel

7. **Publishing** - Vor Release `PUBLISHING_CHECKLIST.md`:
   - Alle Checklisten durchgehen
   - Lighthouse Audit (80+)
   - Production Checks

---

## Allgemeinheit der Templates

Diese Templates sind absichtlich **projektübergreifend generalisiert**:

✅ **Anwendbar auf:**
- Web Apps (React, Vue, Vanilla JS)
- Progressive Web Apps (PWA)
- Node.js Backend Projekte
- TypeScript & JavaScript Projekte
- GitHub Pages Deployments

✅ **Flexible Standards:**
- Keine Framework-spezifischen Vorgaben
- Best Practices für verschiedene Projekttypen
- Modular: Nimm, was du brauchst

✅ **Living Document:**
- Templates sind zu aktualisieren, wenn Best Practices sich ändern
- Feedback willkommen über Issues/PRs

---

## Labels

Siehe [LABELS.md](LABELS.md) für standardisiertes, einfaches Label-System:

**9 Labels in 3 Kategorien:**
- **Type:** `bug`, `feature`, `enhancement`, `docs`
- **Priority:** `priority: high`, `priority: low`
- **Status:** `blocked`, `ready-for-implementation`

**Automatisiertes Setup** mit Script:
```bash
./scripts/setup-labels.sh S540d/Eisenhauer
```

---

## Aktualisierungshistorie

### Version 3.0 (Automation System) - Dezember 2025
- ✅ **Komplettes Automation System** (90%+ automatisierte Quality Checks)
- ✅ **automation-templates/** Verzeichnis mit:
  - 3 CI/CD Workflows (React Native, Web, Generic)
  - 3 Pre-Commit Hook Varianten
  - 3 Validation Script Varianten
  - Platform Utilities (platform.ts)
  - ESLint Konfiguration
- ✅ **scripts/init-automation.sh** - One-Command Setup für alle Projekttypen
- ✅ **Neue Dokumentation:**
  - AUTOMATION_SETUP.md - Setup-Guide
  - RELEASE_CHECKLIST.md - Release-Checkliste
  - AUTOMATED_QUALITY_CHECKLIST.md - Komplette Checkliste
  - QUICK_START.md - Schnelleinstieg
  - AUTOMATION_SUMMARY.md - Komplette Übersicht
- ✅ **Automatische Erkennung** von React Native, Web und Generic Projekten
- ✅ **Angewendet auf alle Projekte:**
  - 1x1_Trainer (React Native)
  - EnergyPriceGermany (React Native)
  - Pflanzkalender (React Native)
  - DrawFromMemory (React Native)
  - Eisenhauer (Web/PWA)

**Impact:**
- Verhindert Platform-spezifische Bugs (window.matchMedia, localStorage)
- Automatische Version-Konsistenz Checks
- Pre-Commit Hooks für sofortiges Feedback
- CI/CD Pipeline für jeden Push/PR
- Security Audits automatisiert

### Version 2.2 (Labels)
- ✅ Standardisiertes Label-System (9 Labels)
- ✅ LABELS.md mit Dokumentation
- ✅ scripts/setup-labels.sh für Automatisierung
- ✅ Labels in allen 3 Projekten eingerichtet

### Version 2.1 (GitHub Integration)
- ✅ `.github/ISSUE_TEMPLATE/` mit 4 Template-Typen
  - bug.md - Bug Reports
  - feature.md - Feature Requests
  - documentation.md - Documentation Requests
  - question.md - Questions / Discussions
- ✅ `.github/PULL_REQUEST_TEMPLATE/` mit Standard PR Template
- ✅ `.github/README.md` - Dokumentation der GitHub Templates
- ✅ Hauptquellen-README aktualisiert

### Version 2.0 (Überarbeitet)
- ✅ technische_vorgaben.md komplett überarbeitet
- ✅ ux-vorgaben.md massiv erweitert
- ✅ design-system.md neu
- ✅ accessibility-guidelines.md neu
- ✅ testing-standards.md neu
- ✅ PUBLISHING_CHECKLIST.md aktuell

### Version 1.0 (Alte Version)
- Zu minimalistisch und projekt-spezifisch
- Jest statt Vitest
- Unvollständige Accessibility Richtlinien
- Fehlende Design System & GitHub Templates Dokumentation

