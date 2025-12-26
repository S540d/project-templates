---
# UX-Vorgaben für Projekte

Allgemeine UX/UI Standards für konsistente, benutzerfreundliche Interfaces über alle Projekte hinweg.

> **Zuletzt aktualisiert:** 2025-12-22
> **Wichtige Updates:** Settings Menu Struktur mit Feedback/Support/About in einer Zeile und About Modal wurden standardisiert
> Siehe Abschnitt **"Settings Menu Content"** für Details

---

## Design Fundamentals

### Design Philosophy
- **Mobile First:** Entwickle zunächst für Mobilgeräte (320px+), dann Tablet (768px+), dann Desktop (1024px+)
- **Progressive Enhancement:** Funktionalität sollte auch mit JavaScript-Errors noch funktionieren
- **Einfachheit:** Minimalist Design, entferne unnötige Elemente
- **Konsistenz:** Ein einheitliches Design-System über alle Screens hinweg
- **Feedback:** Jede Benutzeraktion sollte sichtbares Feedback bekommen

---

## 🎨 Moderne Design-Systeme (2024/2025)

> **Neu hinzugefügt:** Drei moderne Design-Ansätze für zeitgemäße Apps

### Option 1: "Soft & Modern" ⭐ **EMPFOHLEN**

**Philosophie**: Warme, sanfte Ästhetik mit subtiler Tiefe und Eleganz

#### Farbpalette
- **Backgrounds**:
  - Light: `#FAFAFA` (cremeweiß, nicht pures Weiß)
  - Dark: `#0A0A0A` (dunkelgrau, nicht pures Schwarz)
- **Surfaces**:
  - Light: `#F5F5F5` → `#EFEFEF` (weicherer Kontrast)
  - Dark: `#1A1A1A` → `#252525` (wärmere Töne)
- **Schatten**: Weiche, mehrschichtige Elevation
  - Small: `shadowOpacity: 0.08, shadowRadius: 8, elevation: 2`
  - Medium: `shadowOpacity: 0.12, shadowRadius: 16, elevation: 4`
  - Large: `shadowOpacity: 0.18, shadowRadius: 24, elevation: 8`

#### Border & Spacing
- **Border-Radius**:
  - Cards: `16-20px` (statt 12px)
  - Buttons: `12-16px`
  - Small Elements: `8-10px`
- **Margins**: 8px Grid-System beibehalten
- **Padding**: Großzügiger (min. 16px für Cards)

#### Visuelle Effekte
- **Glassmorphism-Tooltips**:
  ```tsx
  backgroundColor: Platform.select({
    web: 'rgba(255, 255, 255, 0.85)',
    default: colors.surface
  }),
  backdropFilter: 'blur(10px)', // nur Web
  shadowColor: '#000',
  shadowOpacity: 0.15,
  shadowRadius: 20,
  ```

- **Gradient-Accents** für wichtige Elemente:
  ```tsx
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
  // oder React Native: react-native-linear-gradient
  ```

- **Grid-Lines**:
  - Gestrichelt statt solid: `strokeDasharray="4,8"`
  - Opacity: `0.15` (statt 0.3)
  - Weichere Farbe: `#D0D0D0` (Light), `#404040` (Dark)

#### Interaktive Elemente
- **Hover-States** (Web):
  - Smooth Transition: `transition: all 0.2s ease`
  - Subtle Scale: `transform: scale(1.02)`
  - Brightness Shift: `filter: brightness(1.05)`

- **Buttons**:
  - Primary: Gradient oder Solid mit Schatten
  - Secondary: Border mit Hover-Fill
  - Ghost: Transparent mit Hover-Background

#### Typography
- **Font-Weights**:
  - Headings: `600-700` (semibold-bold)
  - Body: `400-500` (regular-medium)
  - Labels: `500-600` (medium-semibold)
- **Größen**: Skalierbar, min. 14px für Body Text

---

### Option 2: "Minimal & Clean"

**Philosophie**: Reduktion auf das Wesentliche, maximale Klarheit

#### Farbpalette
- **Monochrome Base**: Grauskala mit einem Akzent
  - Background: `#FFFFFF` / `#0D0D0D`
  - Surface: Nur 2-3 Graustufen
  - Accent: Eine kräftige Farbe (z.B. `#0066FF`)

#### Layout-Prinzipien
- **Mehr Whitespace**: Mindestens 24px zwischen Sections
- **Dünne Linien**: `1px` statt `2px`, Opacity `0.1-0.2`
- **Flache Hierarchie**: Maximal 2-3 Ebenen
- **Card-Based**: Jeder Inhalt in separaten, leicht abgesetzten Cards

#### Besonderheiten
- **Floating Action Buttons**: Primäre Aktionen als FAB
- **Icon-First**: Icons für schnelle Erkennung
- **Minimale Schatten**: Nur `elevation: 1-2`

**⚠️ Einschränkung**: Weniger geeignet für komplexe Datenvisualisierungen mit vielen Kategorien/Farben

---

### Option 3: "Glassmorphism & Modern"

**Philosophie**: Transluzenz und Tiefe durch Blur-Effekte

#### Visuelle Charakteristik
- **Transluzente Cards**:
  ```tsx
  backgroundColor: 'rgba(255, 255, 255, 0.1)',
  backdropFilter: 'blur(20px)',
  borderWidth: 1,
  borderColor: 'rgba(255, 255, 255, 0.2)'
  ```

- **Frosted Glass**: Hintergründe scheinen durch
- **Leuchtende Akzente**: Neon-ähnliche Highlights
- **Gradient-Overlays**: Farbverläufe überall

#### Animationen
- **Smooth Transitions**: `0.3-0.5s cubic-bezier`
- **Micro-Interactions**: Subtile Reaktionen auf Inputs
- **Parallax-Effekte**: Leichte Bewegung bei Scroll

**⚠️ Einschränkung**:
- Performance-intensiv auf älteren Geräten
- Nur teilweise auf React Native umsetzbar (Web bevorzugt)
- Kann von Inhalten ablenken

---

### 🎯 Empfehlungen nach Anwendungsfall

| Anwendungsfall | Empfohlene Option | Begründung |
|----------------|-------------------|------------|
| **Daten-Apps** (Charts, Analytics) | **Option 1** | Balanciert Ästhetik und Funktionalität |
| **Content-Apps** (News, Blogs) | Option 2 | Fokus auf Lesbarkeit |
| **Portfolio/Showcase** | Option 3 | Wow-Effekt, visuell beeindruckend |
| **Business/Professional** | Option 1 oder 2 | Seriös und modern |
| **Creative/Artistic** | Option 3 | Experimentell und einzigartig |

---

### 🚀 Implementierungs-Checkliste

- [ ] Theme-Farben aktualisieren (sanftere Palette)
- [ ] Border-Radius erhöhen (16-20px für Cards)
- [ ] Schatten hinzufügen (multi-layer elevation)
- [ ] Grid-Lines modernisieren (gestrichelt, niedrigere opacity)
- [ ] Tooltips mit Glassmorphism-Effekt
- [ ] Hover-States für Web hinzufügen
- [ ] Gradient-Accents für wichtige Elemente
- [ ] Typography-Scale überprüfen
- [ ] Spacing konsistent anwenden (8px Grid)
- [ ] Transitions für Interaktionen (0.2s ease)

---

## Farbpalette (Color System)

### Grundprinzipien
- Definiere eine primäre Farbpalette mit max. 5 Hauptfarben
- Nutze nur HSL/RGB, keine willkürlichen Hex-Werte
- Dokumentiere alle Farben in `design-tokens.json` oder CSS Variables

### Semantische Farben
```css
/* Statusfarben */
--color-success: #10b981;  /* Grün: Erfolg, Bestätigung */
--color-warning: #f59e0b;  /* Gelb/Orange: Warnung, Achtung */
--color-danger: #ef4444;   /* Rot: Fehler, Löschung */
--color-info: #3b82f6;     /* Blau: Informationen, Links */

/* Neutral */
--color-bg-primary: #ffffff;     /* Light Mode Background */
--color-bg-secondary: #f9fafb;   /* Light Mode Secondary BG */
--color-text-primary: #111827;   /* Light Mode Text */
--color-text-secondary: #6b7280; /* Light Mode Secondary Text */
```

### Kontrast-Anforderungen (WCAG 2.1)
- **Normal Text:** Mindestens 4.5:1 Kontrast
- **Large Text:** Mindestens 3:1 Kontrast
- **UI Components:** Mindestens 3:1 für aktive Elemente
- **Tools zur Überprüfung:** [Accessible Colors](https://accessible-colors.com/), [Contrast Ratio](https://contrast-ratio.com/)

---

## Theme-Aware Colors Architecture ⭐

> **Pattern entdeckt und erfolgreich implementiert:** EnergyPriceGermany
> **Anwendbar auf:** React Native / Expo Apps mit Tooltip-/Modal-Overlays

### Problem (Anti-Pattern)

❌ **Nicht empfohlen:** Komponenten mit einzelnen Farb-Strings
```typescript
// ❌ VERMEIDEN: Hardcoded Colors oder limitierte Props
interface ChartProps {
  backgroundColor: string;
  textColor: string;
  gridColor: string;
}

// Tooltip mit hardcoded Werten
<View style={{
  backgroundColor: Platform.OS === 'web'
    ? (textColor === '#E8E8E8' ? 'rgba(26, 26, 26, 0.95)' : 'rgba(250, 250, 250, 0.95)')
    : backgroundColor,
  borderColor: textColor,
}}>
  <Text style={{ color: textColor }}>...</Text>
</View>
```

**Probleme:**
- Tooltips/Overlays haben unzureichenden Kontrast in Licht/Dunkel-Modus-Kombinationen
- Keine Zugriff auf das vollständige Theme System
- Farben-Logik muss in jeder Komponente dupliziert werden
- Änderungen am Theme-System erfordern Updates in vielen Dateien
- Dark/Light Detection mit `textColor === '#E8E8E8'` ist fehleranfällig

### Lösung: Theme-Aware Colors Pattern ✅

**Empfohlen:** Komponenten erhalten das komplette `ThemeColors` Objekt

#### 1. Theme Colors Typ definieren

```typescript
// utils/theme.ts
export interface ThemeColors {
  background: string;      // Main background color
  surface: string;         // Card/Surface background
  text: string;           // Primary text color
  textSecondary: string;  // Secondary/dimmed text
  primary: string;        // Primary accent color
  gridLine: string;       // Grid lines, borders
}
```

#### 2. Komponenten-Interface erweitern

```typescript
// components/MyChart.tsx
import { ThemeColors } from '../../utils/theme';

interface MyChartProps {
  // ... existing props ...
  backgroundColor: string;
  textColor: string;
  gridColor: string;

  colors: ThemeColors;  // ← ADD THIS
}

export function MyChart({
  // ... existing params ...
  colors,  // ← ADD THIS
}: MyChartProps) {
```

#### 3. Tooltips mit Theme-Aware Farben

```typescript
// Intelligente Tooltip-Hintergrund-Auswahl
const tooltipBgColor = backgroundColor === colors.surface
  ? colors.background
  : colors.surface;

return (
  <View style={{
    paddingVertical: 10,
    paddingHorizontal: 12,
    backgroundColor: tooltipBgColor,  // ← Uses theme
    borderWidth: 1,
    borderColor: colors.gridLine,     // ← Uses theme
    borderRadius: 10,
  }}>
    {/* Market Price */}
    <View style={{ flexDirection: 'row', marginBottom: 4 }}>
      <Text style={{ color: colors.text, fontSize: 11 }}>
        Börsenpreis:
      </Text>
      <Text style={{ color: colors.text, fontSize: 11, fontWeight: '600' }}>
        45,50 ¢
      </Text>
    </View>

    {/* Grid Fees */}
    <View style={{ flexDirection: 'row', marginBottom: 6 }}>
      <Text style={{ color: colors.textSecondary, fontSize: 11 }}>
        + Netzentgelte:
      </Text>
      <Text style={{ color: colors.text, fontSize: 11, fontWeight: '600' }}>
        20,00 ¢
      </Text>
    </View>

    {/* Divider */}
    <View style={{
      height: 1,
      backgroundColor: colors.gridLine,
      marginVertical: 6,
      opacity: 0.5
    }} />

    {/* Total Price */}
    <View style={{ flexDirection: 'row' }}>
      <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>
        Endkunde:
      </Text>
      <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '700' }}>
        65,50 ¢
      </Text>
    </View>
  </View>
);
```

#### 4. Parent-Komponente aktualisieren

```typescript
// App.tsx
<MyChart
  title="Preise"
  backgroundColor={colors.surface}
  textColor={colors.text}
  gridColor={colors.gridLine}
  colors={colors}  // ← Pass complete theme object
/>
```

### Vorteile

✅ **Single Source of Truth**
- Alle Farben werden zentral im Theme System verwaltet
- Änderungen betreffen automatisch alle Komponenten

✅ **WCAG AA Compliance**
- Automatische Light/Dark Mode Unterstützung
- Tooltips haben immer korrekten Kontrast
- Keine hardcoded Farb-Logik nötig

✅ **Wartbarkeit**
- Neues Theme? Nur Theme-Datei ändern
- Keine Duplizierung von Farb-Logik
- Konsistent über alle Komponenten

✅ **Skalierbar**
- Einfach neue Farben zum ThemeColors Interface hinzufügen
- Automatisch in allen Komponenten verfügbar

### Verwendete Semantic Colors

**Für normale Inhalte:**
- `colors.text` - Primärtext (sichtbar, hoher Kontrast)
- `colors.textSecondary` - Sekundärtext (gedimmt, für Labels)
- `colors.primary` - Akzent (Highlights, wichtige Werte)

**Für Overlays (Tooltips, Modals):**
- `colors.background` - Inverser Hintergrund zu Surface
- `colors.surface` - Inverser Hintergrund zu Background
- `colors.gridLine` - Borders, Divider

**Intelligente Invertierung:**
```typescript
const tooltipBgColor = backgroundColor === colors.surface
  ? colors.background
  : colors.surface;
```

Dieser Ansatz sorgt dafür, dass der Tooltip-Hintergrund immer dem Kontrast des Hauptinhalts widerspricht, während der Text immer sichtbar bleibt.

### Implementierungs-Checkliste

- [ ] Theme Colors Interface definieren
- [ ] Komponenten-Props mit `colors: ThemeColors` erweitern
- [ ] Tooltip-Rendering mit Theme Colors aktualisieren
- [ ] Parent-Komponente: `colors={colors}` prop hinzufügen
- [ ] Light Mode testen
- [ ] Dark Mode testen
- [ ] Kontrast mit Accessibility-Tool überprüfen
- [ ] Änderungen dokumentieren

### Referenz-Implementierung

Siehe EnergyPriceGermany Project:
- **GitHub Commit:** [Apply theme-aware colors pattern](https://github.com/S540d/Energy_Price_Germany/commit/4f6e51c)
- **Dateien:**
  - `components/charts/PriceBarChart.tsx` - Reference tooltip implementation
  - `components/charts/RenewableBarChart.tsx` - Theme colors example
  - `components/charts/CorrelationScatterChart.tsx` - Tooltip using theme colors
  - `App.tsx` - How to pass colors prop
  - `utils/theme.ts` - ThemeColors interface definition

---

## Typography (Schrift)

### Font Selection
- **Maximal 2 Schriftarten:** Eine für Headings, eine für Body Text
- **Web Safe Fonts:** Nutze System Fonts oder Google Fonts mit Fallback
  - Headings: `system-ui, -apple-system, sans-serif`
  - Body: `system-ui, -apple-system, sans-serif`
- **Font Size Scale:** Basierend auf 16px Base Size:
  ```css
  --font-xs: 0.75rem;   /* 12px - kleine Labels */
  --font-sm: 0.875rem;  /* 14px - small text */
  --font-base: 1rem;    /* 16px - body text */
  --font-lg: 1.125rem;  /* 18px - emphasis */
  --font-xl: 1.25rem;   /* 20px - subheadings */
  --font-2xl: 1.5rem;   /* 24px - section titles */
  --font-3xl: 1.875rem; /* 30px - page titles */
  ```

### Line Height & Spacing
- **Body Text:** 1.5 - 1.6 line-height (lesbar)
- **Headings:** 1.2 - 1.3 line-height
- **Letter Spacing:** Normal (0) für Body, 0.02em für Headings
- **Paragraph Spacing:** 1.5x Font Size (z.B. 24px bei 16px Font)

---

## Spacing System (Whitespace)

### 8px Base Grid
Basiere alle Abstände auf 8px Inkremente für Konsistenz:

```css
--space-0: 0;      /* 0px */
--space-1: 0.25rem; /* 4px */
--space-2: 0.5rem;  /* 8px */
--space-3: 0.75rem; /* 12px */
--space-4: 1rem;    /* 16px */
--space-6: 1.5rem;  /* 24px */
--space-8: 2rem;    /* 32px */
--space-12: 3rem;   /* 48px */
--space-16: 4rem;   /* 64px */
```

### Anwendung
- **Button Padding:** 8px (vertical) × 16px (horizontal) mindestens
- **Card Padding:** 16px - 24px
- **Container Margin:** 16px (mobile), 32px (desktop)
- **Gap zwischen Items:** 8px - 16px
- **Section Spacing:** 32px - 64px

---

## Responsive Design Breakpoints

```css
/* Mobile-First Breakpoints */
--bp-sm: 320px;   /* Mobile */
--bp-md: 768px;   /* Tablet Portrait */
--bp-lg: 1024px;  /* Tablet Landscape / Small Desktop */
--bp-xl: 1280px;  /* Desktop */
--bp-2xl: 1536px; /* Large Desktop */
```

### Layout-Richtlinien
- **Mobile (< 768px):** Single Column, Full Width, 16px Margins
- **Tablet (768px - 1024px):** 2-3 Columns, Flexible Layout
- **Desktop (> 1024px):** Multi-Column, Max Width 1200px

---

## Komponenten Standards

### Buttons
- **Größe:** Minimum 44px × 44px (Apple HIG, WCAG Touch Target)
- **Padding:** 8px - 12px (vertical), 16px - 24px (horizontal)
- **Zustand:** Default, Hover, Active, Disabled, Loading
- **Label:** Kurz, actionsorientiert (z.B. "Save", "Delete", "Cancel")
- **Icon + Text:** Icon links, Text rechts mit 8px Gap

### Form Elements (Input, Textarea, Select)
- **Größe:** 40px - 44px Height (Touch-friendly)
- **Padding:** 8px - 12px
- **Border:** 1px solid, 4px border-radius
- **Focus State:** Visible Focus Ring (min. 2px, 2px offset)
- **Label:** Immer vorhanden, über Input, `for` Attribut
- **Placeholder:** Grau (nicht für Label-Ersatz)
- **Error State:** Rote Border + Error Message unter Input

### Cards
- **Padding:** 16px - 24px
- **Border:** 1px solid (#e5e7eb) oder Box-Shadow (0 1px 3px rgba(0,0,0,0.1))
- **Border-Radius:** 8px - 12px
- **Spacing:** 16px - 24px zwischen Cards

### Modals / Dialogs
- **Width:** 90vw max 512px (mobile), 600px (desktop)
- **Padding:** 24px - 32px
- **Header:** Bold, 18px - 20px Font
- **Close Button:** X Icon, top-right, 40px × 40px
- **Backdrop:** Dunkelgrau mit 70% Opacity
- **Animation:** Fade-in (200ms), Slide-up (optional)

### Navigation
- **Height:** 56px - 64px auf Mobile, 60px - 80px auf Desktop
- **Links:** Clear, Underline on Hover
- **Active State:** Farbe oder Underline
- **Mobile Menu:** Hamburger Icon, Slide-out oder Modal

---

## Dark Mode / Theme Support

### Implementation
- **CSS Variables:** Nutze CSS Custom Properties für Farbwechsel
- **Klasse-basiert:** `.dark` Klasse auf `<html>` oder `<body>`
- **localStorage:** Speichere Theme-Präferenz mit Key `theme`
- **OS Preference:** Nutze `prefers-color-scheme` Media Query als Fallback

### Dark Mode Farben
```css
:root {
  --color-bg: #ffffff;
  --color-text: #111827;
}

[data-theme="dark"] {
  --color-bg: #1f2937;
  --color-text: #f3f4f6;
}
```

### Dark Mode Rules
- **Nicht einfach invertieren:** Nutze Farbgestaltung statt Inversion
- **Contrast:** Stelle sicher, dass Kontrast in beiden Modes 4.5:1+ ist
- **Icons:** Können gleich bleiben, aber Farbe anpassen
- **Bilder:** Optional: Dunklere Bilder in Dark Mode

---

## Barrierefreiheit (Accessibility / WCAG 2.1 AA)

### Keyboard Navigation
- **Alle Features:** Müssen mit Tastatur bedienbar sein
- **Tab Order:** Logische Reihenfolge (von oben nach unten)
- **Focus Ring:** Sichtbar, mindestens 2px, Kontrast mindestens 3:1
- **Escape:** Schließt Modals, Dropdowns
- **Enter/Space:** Aktiviert Buttons, Checkboxes

### Screen Reader Support
- **Semantic HTML:** Nutze `<button>`, `<nav>`, `<main>`, `<article>` statt `<div>`
- **ARIA Labels:** `aria-label` für Icons, `aria-labelledby` für Gruppen
- **ARIA Live:** `aria-live="polite"` für dynamische Updates
- **Headings:** `<h1>` (1x pro Seite), dann `<h2>`, `<h3>`, keine Lücken
- **Lists:** Nutze `<ul>`, `<ol>` für Listen

### Color & Contrast
- **Kontrast:** Text 4.5:1 (normal), 3:1 (large, UI components)
- **Color Only:** Informationen nicht nur durch Farbe vermitteln (z.B. auch Icon)
- **Focus Ring:** Muss sichtbar sein
- **Disabled State:** Mindestens 3:1 Kontrast auch disabled

### Links & Buttons
- **Unterscheidbar:** Links sollten durch Farbe, Underline, oder Icon unterscheidbar sein
- **Aussagekräftig:** Link-Text sollte aussagekräftig sein ("Details lesen" statt "Mehr")
- **Focus Visible:** `:focus-visible` für Tastaturnavigation
- **Touch Target:** Mindestens 44px × 44px

### Settings Menu Placement & Support Link

**Settings Menu:**
- Platzierung: Auf Höhe der Seitentitel (Überschrift), oben rechts
- Symbol: Drei vertikale Punkte (⋮) - Android-Standard
- Keine separate Header-Zeile, integriert in die Überschrifts-Zeile
- Aria-Label: `aria-label="Settings"`

**Beispiel (Web/PWA):**
```html
<header>
  <h1>Tasks</h1>
  <button class="settings-btn" aria-label="Settings">⋮</button>
</header>
```

```css
header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
}

.settings-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  padding: 8px;
  color: var(--color-text-primary);
}
```

**Settings Menu Content - Standardized Structure:**

Das Settings-Menü muss folgende Struktur haben, in dieser Reihenfolge:

1. **Appearance Settings**
   - so schmal und kompakt wie möglich
   - Theme Toggle: **Light, Dark, System** (3 Optionen)
   - Language Toggle: English, Deutsch
   - jeweils: Buttons: Plain Text, kein Emoji; Active Button: Visuell deutlich markiert (z.B. andere Farbe)

2. **App-spezifische Settings** (Optional, nur wenn sinnvoll)
   - z.B. Operation (Addition/Multiplication), Difficulty Mode (Simple/Creative)
   - Separate Sections mit Separators
   - Gleiche Styling-Regeln wie Appearance

3. **User Account Management** (nur wenn Benutzer-Anmeldung vorhanden)
   - Wenn eine Benutzeranmeldung implementiert ist (z.B. Google Sign-In, Apple Sign-In, etc.), **MUSS** ein "Sign Out" / "Abmelden"-Button in den Einstellungen vorhanden sein
   - Button-Text: "Sign Out" (EN) / "Abmelden" (DE)
   - Style: Primary color link oder destructive button style (rot/orange) je nach Design
   - Platzierung: Oberhalb von "Export" section oder als separate Section
   - Action: Führt Abmeldung durch und zeigt Login-Screen
   - Sichtbarkeit: Nur sichtbar wenn Benutzer authentifiziert ist (nicht im Gastmodus)

4. **Export / Data Management** (Optional)
   - Speichern in localStorage/AsyncStorage
   - Taste zum Export der Daten als Json-Daten (optional)

5. **Feedback, Support & About - Unified Row**
   - **KRITISCH:** Alle drei MÜSSEN in einer Zeile (flexbox row) stehen
   - Gleich breite Buttons (flex: 1)
   - **Feedback Link:** `mailto:devsven@posteo.de?subject=AppName Feedback`
   - **Support Link:** `https://ko-fi.com/devsven`
   - **About Button:** Öffnet Modal-Popup (nicht inline text!)
   - Plain Text, kein Emoji
   - Separator davor und danach

6. **About Modal Popup**
   - **Trigger:** "About" Button im Settings-Menü
   - **Header:** "About" Title mit Close Button (✕)
   - **Content:**
     - Version: "Version X.Y.Z"
     - wenn externe Daten: "Data Source: ..."
     - License: "App License: MIT", "Keine kommerzielle Nutzung ohne Genehmigung"
   - **Close:** Button oder ✕ Icon im Header
   - **Modal-Style:** Centered, Max 512px width, semi-transparent backdrop
   - **Animations:** Fade-in 200ms


**Spezifikationen:**
- Nur Plain Text Labels, KEINE Emojis (⋮ ist OK für Settings Button selbst, aber nicht im Menu)
- Separatoren zwischen Sections
- Section Titles: Kleinbuchstaben, UPPERCASE, 12px, grau
- Links: Primary Color (z.B. #667eea), Hover-State, Touch Target 44px+
- Modal: Max 512px Width, Padding 16-24px, Close Button (✕)
- **Settings Button (⋮):** Text-Farbe für Kontrast zum Hintergrund (nicht Primary Color)
- **Feedback/Support/About Row:** flex: 1 für gleich breite Buttons, borderTop zwischen Buttons

**Beispiel (Web/PWA - HTML):**
```html
<div class="settings-menu">
  <!-- Appearance -->
  <div class="settings-section">
    <h4 class="section-title">APPEARANCE</h4>
    <div class="theme-toggle">
      <button class="theme-btn active" data-theme="light">Light</button>
      <button class="theme-btn" data-theme="dark">Dark</button>
      <button class="theme-btn" data-theme="system">System</button>
    </div>
  </div>

  <hr class="settings-separator">

  <!-- Language -->
  <div class="settings-section">
    <h4 class="section-title">LANGUAGE</h4>
    <div class="language-toggle">
      <button class="lang-btn active" data-lang="en">English</button>
      <button class="lang-btn" data-lang="de">Deutsch</button>
    </div>
  </div>

  <hr class="settings-separator">

  <!-- Feedback, Support & About in One Row -->
  <div class="settings-section settings-section-row">
    <a href="mailto:feedback@example.com" class="settings-link flex">Send Feedback</a>
    <a href="https://ko-fi.com/devsven" target="_blank" class="settings-link flex">support me</a>
    <button onclick="openAboutModal()" class="settings-link flex">About</button>
  </div>
</div>

<!-- About Modal -->
<div id="aboutModal" class="modal hidden">
  <div class="modal-backdrop" onclick="closeAboutModal()"></div>
  <div class="modal-content">
    <div class="modal-header">
      <h3>About</h3>
      <button class="modal-close" onclick="closeAboutModal()">✕</button>
    </div>
    <p class="modal-text">Version 1.0.0</p>
    <p class="modal-info-text">App License: MIT | Keine kommerzielle Nutzung ohne Genehmigung</p>
    <button class="modal-button" onclick="closeAboutModal()">OK</button>
  </div>
</div>
```

**Beispiel (React Native - TypeScript):**
```typescript
import { useState } from 'react';
import { View, Text, TouchableOpacity, Modal, Linking } from 'react-native';

const [themeMode, setThemeMode] = useState<'light' | 'dark' | 'system'>('system');
const [aboutVisible, setAboutVisible] = useState(false);
const APP_VERSION = '1.0.0';

// Appearance Section
const renderAppearanceSection = () => (
  <View style={styles.section}>
    <Text style={styles.sectionTitle}>APPEARANCE</Text>
    <View style={styles.themeToggle}>
      {(['light', 'dark', 'system'] as const).map((mode) => (
        <TouchableOpacity
          key={mode}
          style={[
            styles.themeButton,
            themeMode === mode && styles.themeButtonActive
          ]}
          onPress={() => setThemeMode(mode)}
        >
          <Text style={[styles.themeButtonText, themeMode === mode && styles.themeButtonTextActive]}>
            {mode.charAt(0).toUpperCase() + mode.slice(1)}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  </View>
);

// Feedback, Support & About - Unified Row
const renderFeedbackRow = () => (
  <View style={styles.feedbackRow}>
    <TouchableOpacity
      style={styles.feedbackButton}
      onPress={() => Linking.openURL('mailto:feedback@example.com')}
    >
      <Text style={styles.feedbackButtonText}>Send Feedback</Text>
    </TouchableOpacity>
    <TouchableOpacity
      style={styles.feedbackButton}
      onPress={() => Linking.openURL('https://ko-fi.com/devsven')}
    >
      <Text style={styles.feedbackButtonText}>support me</Text>
    </TouchableOpacity>
    <TouchableOpacity
      style={styles.feedbackButton}
      onPress={() => setAboutVisible(true)}
    >
      <Text style={styles.feedbackButtonText}>About</Text>
    </TouchableOpacity>
  </View>
);

// About Modal
const renderAboutModal = () => (
  <Modal visible={aboutVisible} transparent animationType="fade">
    <View style={styles.modalOverlay}>
      <View style={styles.modalContent}>
        <View style={styles.modalHeader}>
          <Text style={styles.modalTitle}>About</Text>
          <TouchableOpacity
            style={styles.modalCloseButton}
            onPress={() => setAboutVisible(false)}
          >
            <Text style={styles.modalCloseText}>✕</Text>
          </TouchableOpacity>
        </View>
        <Text style={styles.modalText}>Version {APP_VERSION}</Text>
        <Text style={styles.modalInfoText}>App License: MIT | Keine kommerzielle Nutzung ohne Genehmigung</Text>
        <TouchableOpacity
          style={styles.modalButton}
          onPress={() => setAboutVisible(false)}
        >
          <Text style={styles.modalButtonText}>OK</Text>
        </TouchableOpacity>
      </View>
    </View>
  </Modal>
);

// Styles
const styles = StyleSheet.create({
  feedbackRow: {
    flexDirection: 'row',
    marginVertical: 8,
  },
  feedbackButton: {
    flex: 1,
    paddingHorizontal: 8,
    paddingVertical: 12,
    alignItems: 'center',
    borderTopWidth: 1,
    borderTopColor: 'rgba(0,0,0,0.1)',
  },
  feedbackButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#667eea',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    maxWidth: 512,
    width: '90%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  modalTitle: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  modalCloseButton: {
    padding: 8,
  },
  modalCloseText: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  modalText: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 8,
  },
  modalInfoText: {
    fontSize: 13,
    color: '#666',
    textAlign: 'center',
    marginBottom: 16,
  },
  modalButton: {
    backgroundColor: '#667eea',
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: 'center',
  },
  modalButtonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
});
```

**Store Compliance:**
Support-Links im Settings-Menü sind Standard-Praxis und gelten NICHT als "In-App-Werbung"
- "Contains Ads": ❌ NO
- "In-App Purchases": ❌ NO
- Settings Menu ist Teil der App-Funktion, nicht Werbung

**Betroffene Projekte:** Energy Price Germany, 1x1 Trainer, Eisenhauer, Pflanzkalender

**Design Token Spezifikation - Settings Menu:**

Die folgenden Design-Token MÜSSEN in jedem Projekt verwendet werden für einheitliches Aussehen:

```css
/* Colors */
--settings-bg: #ffffff (light) / #1f2937 (dark)
--settings-text: #111827 (light) / #f3f4f6 (dark)
--settings-text-secondary: #6b7280 (light) / #9ca3af (dark)
--settings-border: #e5e7eb (light) / #374151 (dark)
--settings-primary: #667eea (primary color)
--settings-button-bg: #f5f5f5 (light) / #374151 (dark)
--settings-button-active: #667eea
--settings-button-active-text: #ffffff

/* Typography */
--settings-title-size: 18px
--settings-title-weight: 600
--settings-section-title-size: 12px
--settings-section-title-weight: 600
--settings-section-title-case: uppercase
--settings-section-title-letter-spacing: 0.5px
--settings-link-size: 14px
--settings-link-weight: 500

/* Spacing */
--settings-modal-padding: 16px
--settings-section-padding: 12px vertical, 16px horizontal
--settings-gap: 8px
--settings-separator-margin: 0

/* Sizing */
--settings-button-padding: 10px vertical, 12px horizontal
--settings-button-height: 40px
--settings-button-border-radius: 6px
--settings-modal-width: max 512px
--settings-modal-border-radius: 12px
--settings-separator-height: 1px

/* Interactions */
--settings-button-hover-opacity: 0.8
--settings-link-hover-opacity: 0.8
--settings-transition-duration: 200ms
--settings-touch-target-min: 44px
```

**Visuelle Struktur (Mobile & Desktop):**

```
┌─────────────────────────────────┐
│ Settings                    ×   │  <- Header (18px title, close button 44x44px min)
├─────────────────────────────────┤
│                                 │
│ APPEARANCE                      │  <- Section Title (12px uppercase)
│ [Light] [Dark] [System]        │  <- Theme Buttons (3x flex, 40px height)
│                                 │  <- Padding: 12px v, 16px h
├─────────────────────────────────┤  <- Separator (1px)
│                                 │
│ Send Feedback          →        │  <- Link (14px, primary color)
│                                 │  <- Touch target: 44px+
├─────────────────────────────────┤
│                                 │
│ ABOUT                           │
│ Version 1.0.0                   │
│                                 │
├─────────────────────────────────┤
│                                 │
│ Buy Me a Coffee        →        │
│                                 │
└─────────────────────────────────┘
```

**Detaillierte Spezifikation pro Element:**

1. **Modal Container:**
   - Width: 90vw, max 512px (mobile), max 600px (desktop)
   - Padding: 16px (mobile), 24px (desktop)
   - Border Radius: 12px
   - Background: --settings-bg
   - Box Shadow: 0 4px 12px rgba(0, 0, 0, 0.15)
   - Position: Centered, above content layer (z-index: 1000+)

2. **Header:**
   - Display: flex, space-between, center
   - Height: auto (min 44px for close button)
   - Border-bottom: 1px solid --settings-border
   - Padding-bottom: 12px
   - Title: 18px, 600 weight, --settings-text
   - Close Button (×):
     - Size: 24px font
     - Min touch: 44x44px
     - Background: transparent
     - Hover: opacity 0.7
     - Cursor: pointer

3. **Section Container:**
   - Padding: 12px vertical, 16px horizontal
   - Margin: 0
   - Display: block

4. **Section Title (APPEARANCE, ABOUT):**
   - Font Size: 12px
   - Font Weight: 600
   - Text Transform: uppercase
   - Letter Spacing: 0.5px
   - Color: --settings-text-secondary
   - Margin-bottom: 12px
   - Margin: 0
   - Text alignment: left

5. **Theme Toggle Container:**
   - Display: flex
   - Gap: 8px
   - Height: 40px

6. **Theme Buttons (Light, Dark, System):**
   - Flex: 1 (equal width)
   - Height: 40px
   - Padding: 10px vertical, 12px horizontal
   - Border: none
   - Border Radius: 6px
   - Font Size: 12-13px
   - Font Weight: 600
   - Cursor: pointer
   - Transition: all 200ms ease
   - Default State:
     - Background: --settings-button-bg
     - Color: --settings-text
   - Active State:
     - Background: --settings-button-active
     - Color: --settings-button-active-text
   - Hover State:
     - Opacity: 0.8
   - Focus State:
     - Outline: 2px solid --settings-primary
     - Outline-offset: 2px

7. **Separator (hr):**
   - Height: 1px
   - Background: --settings-border
   - Margin: 0
   - Border: none
   - Padding: 0

8. **Links (Send Feedback, Buy Me a Coffee):**
   - Display: block
   - Font Size: 14px
   - Font Weight: 500
   - Color: --settings-primary
   - Text Decoration: none
   - Padding: 12px vertical, 0 horizontal
   - Cursor: pointer
   - Transition: opacity 200ms ease
   - Hover State:
     - Opacity: 0.8
     - Text-decoration: optional (underline)
   - Focus State:
     - Outline: 2px solid --settings-primary
     - Outline-offset: 2px

9. **Info Text (Version, Data Source):**
   - Font Size: 13px
   - Font Weight: 400
   - Color: --settings-text-secondary
   - Margin-top: 4px
   - Line-height: 1.5

10. **Backdrop (wenn Modal):**
    - Position: fixed, full screen
    - Background: rgba(0, 0, 0, 0.5)
    - Z-index: 999
    - Dismiss: on click

**Responsive Behavior:**

Mobile (< 768px):
- Modal: 90vw width, no max width initially
- Padding: 16px
- Font sizes: as specified

Tablet/Desktop (>= 768px):
- Modal: max 512px width
- Padding: 24px
- Font sizes: same

**Animation/Transition (Optional):**
- Modal appear: fade-in 200ms ease-out
- Button hover: background-color 200ms ease
- Link hover: opacity 200ms ease

**Accessibility (WCAG 2.1 AA):**
- Close Button: min 44x44px touch target ✓
- Links: min 44px height (padding provides this) ✓
- Color Contrast:
  - Text: 4.5:1 minimum ✓
  - Links: 4.5:1 minimum ✓
  - Active Button: white on primary ✓
- Keyboard Navigation:
  - Tab order: Header → Buttons/Links → Close Button
  - Focus visible: 2px outline, 2px offset ✓
  - Escape key: close modal (optional, but recommended) ✓
- Screen Reader:
  - Header: semantic `<h3>` or role="heading" ✓
  - Buttons: `<button>` elements ✓
  - Links: `<a>` elements with href ✓
  - Sections: semantic grouping or `<fieldset>` for theme toggle ✓
  - Close button: `aria-label="Close"` ✓

**CSS Implementation Template (Web/PWA):**

```css
/* Design Tokens */
:root {
  /* Colors */
  --settings-bg: #ffffff;
  --settings-text: #111827;
  --settings-text-secondary: #6b7280;
  --settings-border: #e5e7eb;
  --settings-primary: #667eea;
  --settings-button-bg: #f5f5f5;
  --settings-button-active: #667eea;
  --settings-button-active-text: #ffffff;

  /* Typography */
  --settings-title-size: 18px;
  --settings-title-weight: 600;
  --settings-section-title-size: 12px;
  --settings-section-title-weight: 600;
  --settings-link-size: 14px;
  --settings-link-weight: 500;

  /* Spacing */
  --settings-modal-padding: 16px;
  --settings-section-padding: 12px;
  --settings-section-padding-h: 16px;
  --settings-gap: 8px;

  /* Sizing */
  --settings-button-padding-v: 10px;
  --settings-button-padding-h: 12px;
  --settings-button-height: 40px;
  --settings-button-border-radius: 6px;
  --settings-modal-width: 512px;
  --settings-modal-border-radius: 12px;
  --settings-separator-height: 1px;
}

@media (prefers-color-scheme: dark) {
  :root {
    --settings-bg: #1f2937;
    --settings-text: #f3f4f6;
    --settings-text-secondary: #9ca3af;
    --settings-border: #374151;
    --settings-button-bg: #374151;
  }
}

/* Modal Container */
.settings-modal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 90vw;
  max-width: var(--settings-modal-width);
  max-height: 90vh;
  padding: var(--settings-modal-padding);
  background: var(--settings-bg);
  border-radius: var(--settings-modal-border-radius);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  overflow-y: auto;
}

/* Backdrop */
.settings-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 999;
}

/* Modal Header */
.settings-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--settings-border);
}

.settings-header h3 {
  font-size: var(--settings-title-size);
  font-weight: var(--settings-title-weight);
  color: var(--settings-text);
  margin: 0;
}

.settings-close-btn {
  background: transparent;
  border: none;
  font-size: 24px;
  color: var(--settings-text);
  cursor: pointer;
  padding: 8px;
  min-width: 44px;
  min-height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: opacity 200ms ease;
}

.settings-close-btn:hover {
  opacity: 0.7;
}

.settings-close-btn:focus-visible {
  outline: 2px solid var(--settings-primary);
  outline-offset: 2px;
}

/* Section Container */
.settings-section {
  padding: var(--settings-section-padding) var(--settings-section-padding-h);
}

/* Section Title */
.settings-section-title {
  font-size: var(--settings-section-title-size);
  font-weight: var(--settings-section-title-weight);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--settings-text-secondary);
  margin: 0 0 var(--settings-gap) 0;
}

/* Separator */
.settings-separator {
  height: var(--settings-separator-height);
  background: var(--settings-border);
  border: none;
  margin: 0;
  padding: 0;
}

/* Theme Toggle Container */
.settings-theme-toggle {
  display: flex;
  gap: var(--settings-gap);
  height: var(--settings-button-height);
}

/* Theme Buttons */
.settings-theme-btn {
  flex: 1;
  padding: var(--settings-button-padding-v) var(--settings-button-padding-h);
  background: var(--settings-button-bg);
  color: var(--settings-text);
  border: none;
  border-radius: var(--settings-button-border-radius);
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 200ms ease;
  min-height: var(--settings-button-height);
}

.settings-theme-btn:hover {
  opacity: 0.8;
}

.settings-theme-btn:focus-visible {
  outline: 2px solid var(--settings-primary);
  outline-offset: 2px;
}

.settings-theme-btn.active {
  background: var(--settings-button-active);
  color: var(--settings-button-active-text);
}

/* Links */
.settings-link {
  display: block;
  padding: var(--settings-section-padding) 0;
  font-size: var(--settings-link-size);
  font-weight: var(--settings-link-weight);
  color: var(--settings-primary);
  text-decoration: none;
  cursor: pointer;
  transition: opacity 200ms ease;
  min-height: 44px;
  display: flex;
  align-items: center;
}

.settings-link:hover {
  opacity: 0.8;
  text-decoration: underline;
}

.settings-link:focus-visible {
  outline: 2px solid var(--settings-primary);
  outline-offset: 2px;
}

/* Info Text */
.settings-info-text {
  font-size: 13px;
  font-weight: 400;
  color: var(--settings-text-secondary);
  margin-top: 4px;
  line-height: 1.5;
}

/* Responsive */
@media (min-width: 768px) {
  .settings-modal {
    padding: 24px;
  }
}
```

**Verifikationscheckliste - Settings Menu Aussehen:**

- [ ] Header: 18px, 600 weight, "Settings" text
- [ ] Close button: 24px, 44x44px touch target, transparent bg
- [ ] Section titles: 12px, uppercase, 0.5px letter-spacing, grau
- [ ] Theme buttons: 3x flex width, 40px height, 8px gap
- [ ] Active button: primary color (#667eea), white text
- [ ] Separators: 1px, border color, no margin
- [ ] Links: 14px, 500 weight, primary color
- [ ] Touch targets: all interactive elements >= 44px
- [ ] Dark mode: all colors inverted correctly
- [ ] Hover states: opacity 0.8 or color change
- [ ] Focus indicators: 2px outline, 2px offset
- [ ] Backdrop: semi-transparent (rgba(0,0,0,0.5))
- [ ] Modal centered: 90vw width, max 512px
- [ ] Spacing: consistent padding/margins per spec
- [ ] Transitions: 200ms ease

**Status (Stand Nov 2025):**
- ✅ EnergyPriceGermany - Refactored
- ✅ 1x1 Trainer - Refactored
- ✅ Eisenhauer - Refactored
- ✅ Pflanzkalender - Refactored
- ⏳ CD-to-Spotify-PWA - Pending (in development)

### Emoji-Richtlinien

**Wo emojis OK sind:**
- ✅ Settings Button selbst (⋮ für Menü-Icon)
- ✅ Dekoration/Branding in Dokumentation
- ✅ Fehlerberichte & Commit-Messages (für Entwickler)
- ✅ Loading/Success Messages (als Icon, nicht als Text)

**Wo emojis NICHT verwendet werden:**
- ❌ Navigations-Labels (statt 📅 "Calendar", statt 📋 "Agenda")
- ❌ Button-Labels (statt "🔁 Refresh" → "Refresh")
- ❌ Settings Menu Items (statt "📧 Feedback" → "Send Feedback")
- ❌ Menü-Einträge und Links
- ❌ Überschriften und Titel
- ❌ Durchschnittliche UI-Labels

**Rationale:**
- Emojis sind inkonsistent über Plattformen (unterschiedliche Rendering)
- Schlechter Support auf älteren Geräten/Browsern
- Accessibility: Screen Reader lesen Emoji-Namen, nicht Labels
- Professionelleres Erscheinungsbild
- Bessere Lesbarkeit für Non-Native Speaker

**Ausnahmen für spezifische Projekte:**
- Richter Matrix (Eisenhauer): Keine Emojis im UI
- Energie (Energy Price Germany): Keine Emojis im UI
- 1x1 Trainer: Keine Emojis im UI
- Pflanzen (Pflanzkalender): Keine Emojis im UI

### Images & Multimedia
- **Alt Text:** Jedes `<img>` braucht `alt` Attribut (kann leer sein wenn dekorativ)
- **Meaningful Alt:** Beschreibe den Inhalt, nicht "image of..."
- **Videos:** Subtitles/Captions (CC)
- **Decorative Images:** `alt=""` oder `aria-hidden="true"`

### Forms
- **Labels:** Jedes Input braucht `<label>` mit `for` Attribut
- **Error Messages:** Mit `aria-describedby`, verknüpft mit Input
- **Required:** Nutze `required` Attribut, zeige visuell an (z.B. Asterisk)
- **Fieldset:** Nutze `<fieldset>` + `<legend>` für Gruppen (Radio, Checkbox)

---

## Interaktion & Feedback

### Loading States
- **Spinner:** Rotierendes Icon oder Skeleton-Screen
- **Duration:** Max. 3 Sekunden ohne Feedback (dann Nachrichten zeigen)
- **Text:** "Loading...", "Saving...", etc.
- **Disable:** Buttons/Inputs während Loading disablen

### Success/Error Messages
- **Toast Notifications:** Kurz, 3-5 Sekunden sichtbar
- **Types:** Success (grün), Error (rot), Warning (gelb), Info (blau)
- **Position:** Oben rechts (Desktop), Oben Mitte (Mobile)
- **Message:** Klar, actionorientiert
- **Icon:** Visual Indicator (✓, ✕, ⚠, ℹ)

### Animations
- **Duration:** 200-300ms für Hover/Focus, 300-500ms für Page Transitions
- **Easing:** `ease-out` für Erscheinen, `ease-in` für Verschwinden
- **Reduzieren:** `prefers-reduced-motion: reduce` respektieren
- **Keine flashing:** Nichts sollte schneller als 3x pro Sekunde blinken

### Hover & Focus States
- **Hover:** Farb-Change, Schatten, oder Scale (max 1.05)
- **Focus:** Visible Focus Ring (nicht outline: none!)
- **Active:** Gedrückter Effekt oder Farb-Change
- **Feedback Time:** < 100ms (sollte sofort responsive wirken)

---

## Android-Spezifische Vorgaben

### Edge-to-Edge Display (Android 15+)

**KRITISCH:** Ab Android 15 (SDK 35+) sind Apps **standardmäßig randlos**. Alle Android-Apps MÜSSEN Edge-to-Edge kompatibel sein.

#### Anforderungen

**Build Configuration:**
```kotlin
// app/build.gradle.kts
android {
    compileSdk = 36  // Android 15+

    defaultConfig {
        targetSdk = 36  // WICHTIG: Android 15+
        minSdk = 21
    }
}

dependencies {
    // Material Components - Mindestens v1.13.0
    implementation("com.google.android.material:material:1.13.0")

    // AndroidX Core - für WindowCompat
    implementation("androidx.core:core-ktx:1.17.0")
}
```

**Version Catalog (gradle/libs.versions.toml):**
```toml
[versions]
agp = "8.13.0"
kotlin = "2.2.21"  # Neueste stabile Version
material = "1.13.0"  # MINDESTENS 1.13.0!
coreKtx = "1.17.0"

[libraries]
material = { group = "com.google.android.material", name = "material", version.ref = "material" }
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version.ref = "coreKtx" }
```

#### MainActivity Implementation

**WICHTIG:** Edge-to-Edge MUSS explizit aktiviert werden:

```kotlin
// MainActivity.kt
import androidx.core.view.WindowCompat

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable Edge-to-Edge for Android 15+ compatibility
        enableEdgeToEdge()

        // ... rest of your code
    }

    private fun enableEdgeToEdge() {
        // Enable edge-to-edge display for Android 15+ compatibility
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
```

**✅ VERWENDEN:**
- `WindowCompat.setDecorFitsSystemWindows(window, false)`

**❌ NICHT VERWENDEN (Deprecated):**
- `FLAG_LAYOUT_NO_LIMITS` (deprecated)
- `window.setStatusBarColor()` (deprecated in Android 15)
- `window.setNavigationBarColor()` (deprecated in Android 15)

#### Theme Configuration

**values/themes.xml (Light Mode):**
```xml
<resources xmlns:tools="http://schemas.android.com/tools">
    <style name="Base.Theme.YourApp" parent="Theme.Material3.DayNight.NoActionBar">

        <!-- Edge-to-Edge configuration for Android 15+ -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
        <item name="android:windowLightStatusBar">true</item>
        <item name="android:windowLightNavigationBar">true</item>
        <item name="android:enforceNavigationBarContrast" tools:targetApi="q">false</item>
        <item name="android:enforceStatusBarContrast" tools:targetApi="q">false</item>
    </style>

    <style name="Theme.YourApp" parent="Base.Theme.YourApp" />
</resources>
```

**values-night/themes.xml (Dark Mode):**
```xml
<resources xmlns:tools="http://schemas.android.com/tools">
    <style name="Base.Theme.YourApp" parent="Theme.Material3.DayNight.NoActionBar">

        <!-- Edge-to-Edge configuration for Android 15+ (Dark Mode) -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
        <item name="android:windowLightStatusBar">false</item>
        <item name="android:windowLightNavigationBar">false</item>
        <item name="android:enforceNavigationBarContrast" tools:targetApi="q">false</item>
        <item name="android:enforceStatusBarContrast" tools:targetApi="q">false</item>
    </style>
</resources>
```

**Theme-Eigenschaften Erklärung:**
- `statusBarColor`: Transparent für Edge-to-Edge
- `navigationBarColor`: Transparent für Edge-to-Edge
- `windowLightStatusBar`: `true` (Light Mode), `false` (Dark Mode) - Steuert Icon-Farbe
- `windowLightNavigationBar`: `true` (Light Mode), `false` (Dark Mode) - Steuert Button-Farbe
- `enforceNavigationBarContrast`: `false` - Bessere Kontrolle über Appearance
- `enforceStatusBarContrast`: `false` - Bessere Kontrolle über Appearance

**WICHTIG:** Verwende **Theme.Material3** als Parent, nicht Theme.MaterialComponents (veraltet)

#### Window Insets Handling (Optional)

**Nur notwendig bei eigenen UI-Elementen** (nicht bei TWA/WebView-Apps):

```kotlin
ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
    val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
    v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
    insets
}
```

**Bei TWA/WebView Apps:** Nicht notwendig, da automatisch gehandhabt.

#### Java Toolchain Konfiguration

**Problem:** Kotlin 2.2.21 unterstützt Java 25 noch nicht.

**Lösung (gradle.properties):**
```properties
# Verwende Java 23 oder niedriger
org.gradle.java.home=/path/to/java-23
```

**Kompatibilität:**
- Kotlin 2.2.21: Java 24 oder niedriger
- Kotlin 2.3.0+: Java 25 Support

#### Checkliste - Edge-to-Edge Implementation

**Build Configuration:**
- [ ] `compileSdk = 36`
- [ ] `targetSdk = 36`
- [ ] Material Components >= 1.13.0
- [ ] AndroidX Core >= 1.17.0
- [ ] Kotlin >= 2.2.21

**MainActivity:**
- [ ] `WindowCompat.setDecorFitsSystemWindows(window, false)` implementiert
- [ ] Keine deprecated `FLAG_LAYOUT_NO_LIMITS` Verwendung
- [ ] Import: `androidx.core.view.WindowCompat`

**Themes:**
- [ ] `android:statusBarColor` = transparent
- [ ] `android:navigationBarColor` = transparent
- [ ] `android:windowLightStatusBar` konfiguriert (Light/Dark Mode)
- [ ] `android:windowLightNavigationBar` konfiguriert (Light/Dark Mode)
- [ ] `enforceNavigationBarContrast` = false
- [ ] `enforceStatusBarContrast` = false
- [ ] Separate themes.xml für `-night` (Dark Mode)

**Testing:**
- [ ] Build erfolgreich ohne Warnungen
- [ ] Keine "Edge-to-Edge" Warnungen in Play Console
- [ ] Keine "deprecated API" Warnungen
- [ ] Test auf Android 15+ Gerät/Emulator

#### Google Play Console Warnungen

**Diese Warnungen werden durch korrekte Implementation behoben:**

✅ "Die randlose Anzeige funktioniert möglicherweise nicht für alle Nutzer"
→ **Gelöst durch:** Explizite Edge-to-Edge Aktivierung

✅ "Verwendung von deprecated APIs (setStatusBarColor, setNavigationBarColor)"
→ **Gelöst durch:** Material Components 1.13.0 + Theme-basierte Konfiguration

#### Troubleshooting

**Problem: Kotlin Compiler Error mit Java 25**
```
IllegalArgumentException: 25
```
**Lösung:** Kotlin 2.2.21 unterstützt Java 25 noch nicht
```properties
# gradle.properties
org.gradle.java.home=/path/to/java-23
```

**Problem: Material Components deprecated API Warnung**
```
setStatusBarColor is deprecated
```
**Lösung:** Material Components auf 1.13.0+ aktualisieren

**Problem: Status Bar Icons nicht sichtbar**
```
Status bar icons are the same color as background
```
**Lösung:** `windowLightStatusBar` korrekt setzen
```xml
<!-- Light Mode -->
<item name="android:windowLightStatusBar">true</item>

<!-- Dark Mode -->
<item name="android:windowLightStatusBar">false</item>
```

#### Referenzen

- [Android Edge-to-Edge Guide](https://developer.android.com/develop/ui/views/layout/edge-to-edge)
- [WindowCompat API](https://developer.android.com/reference/androidx/core/view/WindowCompat)
- [Material Design 3](https://m3.material.io/)
- [Android 15 Behavior Changes](https://developer.android.com/about/versions/15/behavior-changes-15)

**Status (Stand Nov 2025):**
- ✅ 1x1 Trainer v1.0.2 - Implementiert & verifiziert

---

### Android App Links (Deep Linking)

**WICHTIG:** Apps sollten Android App Links implementieren, damit Website-URLs automatisch die App öffnen (statt des Browsers).

#### Warum Android App Links?

Wenn ein Nutzer auf einen Link zu deiner Website klickt (z.B. in einer E-Mail oder einem anderen Browser), öffnet sich normalerweise der Browser. Mit Android App Links wird **automatisch die App geöffnet** (falls installiert).

**Beispiel:**
- **Ohne App Links:** `https://s540d.github.io/1x1_Trainer/` → Browser öffnet sich
- **Mit App Links:** `https://s540d.github.io/1x1_Trainer/` → App öffnet sich direkt

#### Anforderungen

Für funktionierende Android App Links benötigst du **zwei Dinge**:

1. **Digital Asset Links** auf der Website (`.well-known/assetlinks.json`)
2. **Intent-Filter** in der App (`app.json` oder `AndroidManifest.xml`)

#### Setup für Expo/React Native Apps

**1. Digital Asset Links erstellen:**

```bash
mkdir -p public/.well-known
```

**public/.well-known/assetlinks.json:**
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.yourcompany.yourapp",
      "sha256_cert_fingerprints": [
        "SHA256_FINGERPRINT_FROM_PLAY_CONSOLE"
      ]
    }
  }
]
```

**2. Intent-Filter in app.json:**

```json
{
  "expo": {
    "android": {
      "package": "com.yourcompany.yourapp",
      "versionCode": 2,
      "intentFilters": [
        {
          "action": "VIEW",
          "autoVerify": true,
          "data": [
            {
              "scheme": "https",
              "host": "yourdomain.github.io",
              "pathPrefix": "/YourApp"
            }
          ],
          "category": ["BROWSABLE", "DEFAULT"]
        }
      ]
    }
  }
}
```

**3. Build-Skript anpassen:**

```javascript
// scripts/post-build.js
const filesToCopy = [
  { src: 'public/.nojekyll', dest: 'dist/.nojekyll' },  // WICHTIG!
  { src: 'public/.well-known/assetlinks.json', dest: 'dist/.well-known/assetlinks.json' }
];

filesToCopy.forEach(({ src, dest }) => {
  const srcPath = path.join(__dirname, '..', src);
  const destPath = path.join(__dirname, '..', dest);

  if (fs.existsSync(srcPath)) {
    const destDir = path.dirname(destPath);
    if (!fs.existsSync(destDir)) {
      fs.mkdirSync(destDir, { recursive: true });
    }
    fs.copyFileSync(srcPath, destPath);
    console.log(`✓ Copied ${src} to ${dest}`);
  }
});
```

**4. .nojekyll erstellen:**

```bash
touch public/.nojekyll
```

**WICHTIG:** Ohne `.nojekyll` ignoriert GitHub Pages versteckte Verzeichnisse wie `.well-known`!

**5. Deployen:**

```bash
npm run deploy
```

Stelle sicher, dass dein deploy-Skript das `--dotfiles` Flag verwendet:

```json
{
  "scripts": {
    "deploy:gh-pages": "gh-pages -d dist -t --dotfiles"
  }
}
```

**6. SHA-256 Fingerabdruck holen:**

1. Gehe zur [Google Play Console](https://play.google.com/console/)
2. Wähle deine App
3. **Setup → App-Integrität → App signing key certificate**
4. Kopiere den **SHA-256 Zertifikatfingerabdruck**
5. **Entferne die Doppelpunkte:** `AA:BB:CC:DD` → `AABBCCDD`
6. Trage ihn in `assetlinks.json` ein
7. Deploye erneut: `npm run deploy`

**7. Neue App-Version bauen:**

```bash
# Version hochzählen in app.json
{
  "version": "1.0.1",
  "android": {
    "versionCode": 2
  }
}

# Build erstellen
npx eas-cli build --platform android

# Im Play Store hochladen
```

#### Setup für TWA (Android Studio) Apps

**AndroidManifest.xml:**

```xml
<activity
    android:name="com.google.androidbrowserhelper.trusted.LauncherActivity"
    android:exported="true">

    <!-- Deep Link Intent Filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="https"
            android:host="yourdomain.github.io"
            android:pathPrefix="/YourApp" />
    </intent-filter>
</activity>
```

Alle anderen Schritte (Digital Asset Links, .nojekyll, Deployment, SHA-256) sind identisch mit Expo Apps.

#### Testen

**Vor dem Upload (lokal):**

```bash
# assetlinks.json validieren
curl -I https://yourdomain.github.io/.well-known/assetlinks.json

# Erwartetes Ergebnis:
# HTTP/2 200
# content-type: application/json
```

**Nach dem Upload (Play Store):**

1. **Play Console öffnen**
2. **Setup → Deep Links**
3. Prüfe den Status:
   - ✅ **Verifiziert** - Alles okay!
   - ⚠️ **Ausstehend** - Warte 24h
   - ❌ **Fehlgeschlagen** - Prüfe assetlinks.json und SHA-256

**Auf dem Gerät testen:**

```bash
# Deep Link über adb testen
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://yourdomain.github.io/YourApp" \
  com.yourcompany.yourapp
```

**Erwartetes Verhalten:** App öffnet sich direkt (kein Browser-Auswahl-Dialog)

#### Häufige Fehler

**❌ "Prüfung auf JSON-Inhaltstyp fehlgeschlagen"**
- **Problem:** GitHub Pages liefert falschen Content-Type
- **Lösung:** `.nojekyll` Datei erstellen

**❌ "assetlinks.json nicht gefunden"**
- **Problem:** `.well-known` Verzeichnis wurde nicht deployed
- **Lösung:** `--dotfiles` Flag beim gh-pages Deploy verwenden

**❌ "SHA-256 Fingerabdruck stimmt nicht überein"**
- **Problem:** Falscher oder alter Fingerabdruck
- **Lösung:** Aktuellen Fingerabdruck aus Play Console holen, **ohne Doppelpunkte** eintragen

**❌ "Intent-Filter werden ignoriert"**
- **Problem:** App wurde nicht neu gebaut
- **Lösung:** `versionCode` erhöhen, neu bauen, im Play Store hochladen

#### Checkliste - Android App Links

- [ ] `.well-known/assetlinks.json` erstellt
- [ ] `public/.nojekyll` erstellt
- [ ] Build-Skript kopiert `.well-known/` nach `dist/`
- [ ] `--dotfiles` Flag in deploy-Skript
- [ ] SHA-256 Fingerabdruck aus Play Console geholt (ohne Doppelpunkte!)
- [ ] Intent-Filter in `app.json` oder `AndroidManifest.xml`
- [ ] `autoVerify: true` gesetzt
- [ ] Website deployed
- [ ] assetlinks.json erreichbar und liefert `application/json`
- [ ] `versionCode` erhöht
- [ ] Neue App-Version gebaut und hochgeladen
- [ ] Deep Links im Play Console verifiziert

#### Referenzen

- [Android App Links Guide](https://developer.android.com/training/app-links)
- [Digital Asset Links](https://developer.android.com/training/app-links/verify-android-applinks)
- [Expo Intent Filters](https://docs.expo.dev/guides/linking/#android-app-links)
- [TWA Deep Links](https://developer.chrome.com/docs/android/trusted-web-activity/)

**Beispiel-Projekte:**
- ✅ EnergyPriceGermany v1.2.1 - [assetlinks.json](https://s540d.github.io/Energy_Price_Germany/.well-known/assetlinks.json)
- ✅ 1x1_Trainer v1.0.1 - [assetlinks.json](https://s540d.github.io/1x1_Trainer/.well-known/assetlinks.json)
- ✅ Eisenhauer - [assetlinks.json](https://s540d.github.io/Eisenhauer/.well-known/assetlinks.json)

**Status (Stand Nov 2025):**
- ✅ EnergyPriceGermany v1.2.1 - Implementiert
- ✅ 1x1_Trainer v1.0.1 - Implementiert & deployed
- ✅ Eisenhauer - Implementiert

---

## PWA & React Native Vorgaben

### Expo OTA Updates (Critical)

**KRITISCH:** Alle PWA/React Native Apps mit Expo MÜSSEN die OTA (Over-The-Air) Updates Konfiguration **bereits im ersten Play Store Build** enthalten.

#### Problem

Wenn eine App ohne OTA-Konfiguration im Play Store veröffentlicht wird, können **keine Code-Updates** an Benutzer ausgeliefert werden, ohne einen neuen Play Store Build zu erstellen. Dies betrifft besonders Apps im öffentlichen Test, da Benutzer auf einen neuen Store-Build warten müssen.

**Real-World Beispiel (Energy Price Germany v1.2.1):**
- App wurde mit Version 1.2.1 im Play Store veröffentlicht
- OTA-Konfiguration wurde **nach** dem Build zu app.json hinzugefügt
- Benutzer im öffentlichen Test konnten keine Updates erhalten
- Bugfixes und UI-Verbesserungen konnten nicht ausgeliefert werden
- Lösung: Neuer Play Store Build erforderlich

#### Anforderungen

**app.json - MUSS von Anfang an enthalten sein:**

```json
{
  "expo": {
    "name": "Your App Name",
    "slug": "your-app-slug",
    "version": "1.0.0",

    // OTA Updates Configuration - KRITISCH!
    "updates": {
      "enabled": true,
      "checkAutomatically": "ON_LOAD",
      "fallbackToCacheTimeout": 0,
      "url": "https://u.expo.dev/YOUR-PROJECT-ID"
    },
    "runtimeVersion": {
      "policy": "appVersion"
    },

    "extra": {
      "eas": {
        "projectId": "YOUR-PROJECT-ID"
      }
    }
  }
}
```

**Wichtige Eigenschaften:**

- **`updates.enabled: true`** - Aktiviert OTA Updates
- **`updates.checkAutomatically: "ON_LOAD"`** - Prüft bei jedem App-Start
- **`updates.fallbackToCacheTimeout: 0`** - Nutzt neue Updates sofort (kein Fallback auf Cache)
- **`updates.url`** - Expo Updates Server URL (von EAS Console)
- **`runtimeVersion.policy: "appVersion"`** - Verknüpft Updates mit App-Version
- **`extra.eas.projectId`** - Expo Project ID (von EAS Console)

#### RuntimeVersion Matching

**Kritisch:** OTA Updates funktionieren nur, wenn die `runtimeVersion` der App und des Updates übereinstimmen.

**Mit `policy: "appVersion"`:**
- RuntimeVersion = app.json `version` Feld
- Beispiel: App v1.2.1 kann nur Updates für runtimeVersion "1.2.1" empfangen
- Bei Version-Increment (1.2.1 → 1.2.2) ist neuer Play Store Build erforderlich

**Vorteile:**
- Einfach zu verstehen
- Verhindert Inkompatibilitäten zwischen Updates und nativen Modulen
- Sichere Update-Strategie

**Alternative: Custom RuntimeVersion (nicht empfohlen für Anfang):**
```json
"runtimeVersion": "1.0.0"
```

#### Workflow - OTA Updates nutzen

**1. Ersten Play Store Build erstellen:**
```bash
# Mit OTA-Konfiguration in app.json!
eas build --platform android --profile production
```

**2. Code-Änderungen ausliefern (ohne Store-Build):**
```bash
# Publish OTA Update
eas update --branch production --message "Fix: Improve chart label positioning"
```

**3. Benutzer erhalten Update:**
- Beim nächsten App-Start wird Update geprüft
- Update wird heruntergeladen und installiert
- Beim übernächsten Start ist neuer Code aktiv
- **Keine Play Store Genehmigung erforderlich**

**4. Wann neuer Store-Build erforderlich:**
- Änderungen an nativen Modulen (dependencies in package.json)
- Änderungen an app.json Konfiguration (Permissions, etc.)
- Version-Increment (1.2.1 → 1.2.2) bei policy: "appVersion"
- Änderungen an Android/iOS nativen Dateien

#### Platform-Detection für Data Loading

**Problem:** React Native und Web benötigen unterschiedliche URLs für externe Daten.

**Falsch - Window Detection funktioniert nicht:**
```typescript
// ❌ NICHT VERWENDEN - React Native hat auch window!
const isWeb = typeof window !== 'undefined';
```

**Richtig - Platform.OS verwenden:**
```typescript
import { Platform } from 'react-native';

// ✅ KORREKT
const dataUrl = Platform.OS === 'web'
  ? './data/marketdata.json?v=${Date.now()}'
  : 'https://yourdomain.github.io/YourApp/data/marketdata.json?v=${Date.now()}';

const response = await fetch(dataUrl);
```

**Rationale:**
- Native Apps haben keine relativen Dateipfade im Bundle
- Web-Apps können relative Pfade nutzen
- `Platform.OS` ist die zuverlässige Methode zur Platform-Detection

#### Checkliste - OTA Updates Setup

**Vor erstem Play Store Build:**
- [ ] Expo Account erstellt
- [ ] EAS CLI installiert (`npm install -g eas-cli`)
- [ ] Project mit EAS verbunden (`eas init`)
- [ ] Project ID in app.json eingetragen
- [ ] `updates` Konfiguration in app.json vorhanden
- [ ] `runtimeVersion` policy definiert
- [ ] EAS Build erfolgreich (`eas build --platform android`)

**Nach erstem Play Store Build:**
- [ ] OTA Update Test: `eas update --branch production --message "Test"`
- [ ] Update wird in EAS Console angezeigt
- [ ] App lädt Update beim Start (prüfen mit Expo DevTools)
- [ ] Platform-spezifische Data Loading implementiert (falls externe Daten)
- [ ] Dokumentation für Team: Wie OTA Updates deployed werden

**Bei jedem Code-Update:**
- [ ] Entscheiden: OTA Update oder neuer Store-Build?
- [ ] Wenn OTA: `eas update` nutzen
- [ ] Wenn Store-Build: Version incrementieren, neu builden

#### Troubleshooting

**Problem: "No updates available"**
```bash
# Check: RuntimeVersion matching
eas update:list --branch production
# RuntimeVersion muss mit App-Version übereinstimmen
```

**Problem: Update wird nicht geladen**
```bash
# Check: Updates URL in app.json korrekt?
# Check: Internet-Verbindung auf Gerät?
# Check: Branch name korrekt? (production vs preview)
```

**Problem: App zeigt alte Version nach Update**
```bash
# Solution: App komplett schließen (nicht nur minimieren)
# Dann neu starten - Update wird beim zweiten Start aktiv
```

#### Referenzen

- [Expo OTA Updates Guide](https://docs.expo.dev/eas-update/introduction/)
- [RuntimeVersion Policy](https://docs.expo.dev/eas-update/runtime-versions/)
- [Platform-specific Code](https://reactnative.dev/docs/platform-specific-code)

**Status (Stand Nov 2025):**
- ✅ Requirement dokumentiert nach Energy Price Germany Incident
- ⏳ Alle zukünftigen PWA-Projekte MÜSSEN diese Vorgabe beachten

---

## Internationalisierung (i18n)

### Mehrsprachigkeit
- **Struktur:** Übersetze nur User-facing Text, nicht technische Labels
- **Format:** JSON oder YAML mit Namespace (z.B. `common.greeting`)
- **Default Language:** Dokumentiere Standardsprache
- **RTL Support:** Bedenke RTL Languages (z.B. Arabisch) für zukünftige Unterstützung

### Text Handling
- **Keying:** Nutze prägnante Keys, z.B. `button.save` statt `text1`
- **Variablen:** Nutze Placeholders für dynamische Werte: `Hello, {name}!`
- **Plural Forms:** Handle Singular/Plural (z.B. "1 message" vs "5 messages")
- **Dates/Numbers:** Nutze Locale-aware Formatierung

---

## Offline Indicators (für PWAs)

### Connection Status
- **Indicator:** Kleine Icon/Badge mit Status (online/offline)
- **Position:** Top-right oder Top-bar
- **Farben:** Grün (online), Grau (offline)
- **Message:** "You are offline - some features may be limited"
- **Auto-sync:** Zeige Status wenn Daten synched werden

---

## Empty States

- **Icon:** Relevantes Icon (z.B. leerer Ordner, keine Daten)
- **Title:** Kurz, z.B. "No tasks yet"
- **Description:** Eine Zeile, was der User tun kann
- **CTA:** Ein Primary Button für nächste Aktion (z.B. "Create first task")

---

## Performance Indicators

### Lighthouse Audit Targets
- **Performance:** 80+ (PWA), 90+ (andere Projekte)
- **Accessibility:** 90+
- **Best Practices:** 90+
- **SEO:** 90+

---

## Checkliste für neues Projekt

### Allgemein (Web & Mobile)
- [ ] Color Palette definiert (min. 5 Farben)
- [ ] Typography definiert (max. 2 Fonts)
- [ ] Spacing System definiert (8px Grid)
- [ ] Responsive Breakpoints definiert
- [ ] Dark Mode unterstützt (CSS Variables)
- [ ] Accessibility Checklist durchgegangen
- [ ] Keyboard Navigation getestet
- [ ] Screen Reader kompatibel
- [ ] Focus Rings sichtbar
- [ ] Touch Targets >= 44px × 44px
- [ ] Loading States implementiert
- [ ] Error States implementiert
- [ ] Empty States implementiert
- [ ] Lighthouse Audit >= 80 Points

### Android-Spezifisch (zusätzlich)
- [ ] Edge-to-Edge implementiert (WindowCompat.setDecorFitsSystemWindows)
- [ ] Material Components >= 1.13.0
- [ ] targetSdk = 36 (Android 15+)
- [ ] Themes konfiguriert (Light & Dark Mode)
- [ ] Status Bar transparent
- [ ] Navigation Bar transparent
- [ ] Keine deprecated APIs verwendet
- [ ] Build ohne Warnungen
- [ ] Play Console Pre-Launch Report ohne Fehler

### PWA/React Native (Expo) - Spezifisch (zusätzlich)
- [ ] Expo Account erstellt und EAS CLI installiert
- [ ] OTA Updates Konfiguration in app.json vorhanden (VOR erstem Build!)
- [ ] `updates.enabled: true` gesetzt
- [ ] `runtimeVersion.policy` definiert (empfohlen: "appVersion")
- [ ] Expo Project ID in app.json eingetragen
- [ ] Platform-spezifische Data Loading implementiert (Platform.OS === 'web')
- [ ] Erste OTA Update Test erfolgreich nach Play Store Build
- [ ] Team-Dokumentation: OTA Update Workflow

---

## Deployment-Strategie mit EAS Channels

> **Ziel:** Klare Trennung zwischen Testing und Production für sichere, kontrollierte App-Releases

### Problem ohne EAS Channels

❌ **Unsicherer Workflow:**
- Code auf `main` branch → sofort in Production sichtbar
- Nur localhost-Tests vor Production Release
- Keine echte Device-Tests auf Staging Umgebung
- Keine Möglichkeit, User Testing vor Release durchzuführen
- Überraschungen im App Store möglich

### Lösung: EAS Channels + Staging App

✅ **Sichere Trennung:**

```
Two separate apps in app stores:

1. Production App
   └─ Name: "App Name"
   └─ Bundle ID: com.example.app
   └─ Audience: End Users
   └─ EAS Channel: production
   └─ Distribution: App Store / Play Store

2. Staging App (Beta)
   └─ Name: "App Name - Beta"
   └─ Bundle ID: com.example.app.beta
   └─ Audience: Internal Testers
   └─ EAS Channel: staging
   └─ Distribution: TestFlight (iOS) / Internal Testing (Android)
```

### Development Workflow

```
1. Feature Branch
   └─ npm run dev (localhost + emulator)

2. Testing Branch
   └─ Local testing on real devices

3. Build & Test on Staging
   └─ npm run build:staging
   └─ Deploy to TestFlight/Internal Testing
   └─ Real device testing (iOS/Android)
   └─ User acceptance testing
   └─ [Feedback? → zurück zu Feature Branch]

4. Staging Validated ✅
   └─ Merge to main branch

5. Production Release
   └─ npm run build:production
   └─ App Store / Play Store Review
   └─ Live for Users
```

### Configuration Files

**eas.json:**
```json
{
  "cli": {
    "version": ">= 2.0.0"
  },
  "build": {
    "production": {
      "channel": "production",
      "distribution": "store"
    },
    "staging": {
      "channel": "staging",
      "distribution": "internal"
    }
  },
  "channels": {
    "production": {
      "publish": true
    },
    "staging": {
      "publish": true
    }
  }
}
```

**app.json (zusätzlich):**
```json
{
  "expo": {
    "updates": {
      "enabled": true,
      "checkAutomatically": "ON_LOAD",
      "fallbackToCacheTimeout": 0,
      "url": "https://u.expo.dev/YOUR-PROJECT-ID"
    },
    "extra": {
      "eas": {
        "projectId": "YOUR-PROJECT-ID"
      }
    }
  }
}
```

**package.json Scripts:**
```json
{
  "scripts": {
    "build:staging": "eas build --platform all --channel staging",
    "build:production": "eas build --platform all --channel production",
    "publish:staging": "expo publish --channel staging",
    "publish:production": "expo publish --channel production"
  }
}
```

### Vorteile

✅ **Testing vor Release**
- Echte Device-Tests auf Staging App
- User Acceptance Testing möglich
- Bugs vor Production Release entdecken

✅ **Kontrolle & Sicherheit**
- Main branch = nur validierte Features
- Staging = separate App von Production
- Rollback möglich ohne neue App Store Version

✅ **Automatisierung**
- OTA Updates für Code-Änderungen
- EAS Channels für automatische Bereitstellung
- Keine manuellen Build-Prozesse

✅ **Transparenz**
- Klar wann Features live gehen
- Dokumentierbare Release-Notes
- Audit-Trail aller Deployments

### Implementierungs-Schritte

1. **EAS Configuration** (1-2 Stunden)
   - `eas.json` erstellen
   - `app.json` konfigurieren
   - Build Scripts hinzufügen

2. **Staging App Setup** (2-3 Stunden)
   - Neue Bundle ID registrieren
   - TestFlight (iOS) / Internal Testing (Android) konfigurieren
   - Tester-Gruppen erstellen
   - Invites verschicken

3. **First Staging Build** (1 Stunde)
   - `npm run build:staging` ausführen
   - Auf TestFlight/Internal Testing deployen
   - Auf echtem Device testen

4. **Workflow Integration** (1-2 Stunden)
   - Branch Protection Rules aktualisieren
   - Release Checklist dokumentieren
   - Team trainieren

**Gesamtaufwand:** 5-8 Stunden (verteilt über mehrere Tage)

### Best Practices

✅ **Testing Protocol**
- Alle Features auf Staging testen vor Main Merge
- Mindestens 2 verschiedene Devices testen (iOS/Android)
- User Testing auf Staging durchführen

✅ **Release Management**
- Version Nummern in app.json inkrementieren
- CHANGELOG.md mit neuen Features aktualisieren
- Neue Features dokumentieren vor Production

✅ **Rollback Procedure**
- Alte Channel Version kann schnell aktiviert werden
- OTA Updates ermöglichen schnelle Fixes
- Dokumentieren was bei Rollback zu tun ist

---
