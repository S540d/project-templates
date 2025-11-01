---
# UX-Vorgaben für Projekte

Allgemeine UX/UI Standards für konsistente, benutzerfreundliche Interfaces über alle Projekte hinweg.

---

## Design Fundamentals

### Design Philosophy
- **Mobile First:** Entwickle zunächst für Mobilgeräte (320px+), dann Tablet (768px+), dann Desktop (1024px+)
- **Progressive Enhancement:** Funktionalität sollte auch mit JavaScript-Errors noch funktionieren
- **Einfachheit:** Minimalist Design, entferne unnötige Elemente
- **Konsistenz:** Ein einheitliches Design-System über alle Screens hinweg
- **Feedback:** Jede Benutzeraktion sollte sichtbares Feedback bekommen

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
   - Theme Toggle (Light / Dark / System)
   - Buttons: Plain Text, kein Emoji
   - Active Button: Visuell deutlich markiert (z.B. andere Farbe)
   - Speichern in localStorage/AsyncStorage

2. **Feedback**
   - Single Link: "Send Feedback"
   - Action: `mailto:feedback@example.com`
   - Plain Text, kein Emoji

3. **About**
   - "ABOUT" als Section Title (Uppercase)
   - Version Info: "Version X.Y.Z"
   - Optional: Data Source Info (für Daten-Apps)

4. **Support**
   - Link: "Buy Me a Coffee"
   - URL: `https://buymeacoffee.com/sven4321`
   - Plain Text, kein Emoji

**Spezifikationen:**
- Nur Plain Text Labels, KEINE Emojis (⋮ ist OK für Settings Button selbst, aber nicht im Menu)
- Separatoren zwischen Sections
- Section Titles: Kleinbuchstaben, UPPERCASE, 12px, grau
- Links: Primary Color (z.B. #667eea), Hover-State, Touch Target 44px+
- Modal: Max 512px Width, Padding 16-24px, Close Button (×)

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

  <!-- Feedback -->
  <div class="settings-section">
    <a href="mailto:feedback@example.com" class="settings-link">Send Feedback</a>
  </div>

  <hr class="settings-separator">

  <!-- About -->
  <div class="settings-section">
    <h4 class="section-title">ABOUT</h4>
    <p>Version 1.0.0</p>
  </div>

  <hr class="settings-separator">

  <!-- Support -->
  <div class="settings-section">
    <a href="https://buymeacoffee.com/sven4321" target="_blank" class="settings-link">
      Buy Me a Coffee
    </a>
  </div>
</div>
```

**Beispiel (React Native - TypeScript):**
```typescript
const [themeMode, setThemeMode] = useState<'light' | 'dark' | 'system'>('system');

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
          <Text style={styles.themeButtonText}>
            {mode.charAt(0).toUpperCase() + mode.slice(1)}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  </View>
);
```

**Store Compliance:**
Support-Links im Settings-Menü sind Standard-Praxis und gelten NICHT als "In-App-Werbung"
- "Contains Ads": ❌ NO
- "In-App Purchases": ❌ NO
- Settings Menu ist Teil der App-Funktion, nicht Werbung

**Betroffene Projekte:** Energy Price Germany, 1x1 Trainer, Eisenhauer, Pflanzkalender

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

---
