# Play Store Listing Standards

Verbindliche Regeln für alle `PLAY_STORE_METADATA_*.md`-Dateien.

---

## Datei-Ablageort

Jedes App-Projekt legt seine Metadaten unter:

```
/docs/private/PLAY_STORE_METADATA_EN.md   ← englischer Eintrag (Standard)
/docs/private/PLAY_STORE_METADATA_DE.md   ← deutsche Lokalisierung (falls vorhanden)
```

---

## Zeichenlimits — Translation-Safe

Play Store-Limits gelten auch für automatisch übersetzte Varianten. Deutsch und andere europäische Sprachen expandieren EN-Text um typisch 20–35 %. Als Sicherheitspuffer gilt **Faktor 1,35**.

| Feld | Play-Store-Limit | Translation-safe (÷ 1,35) |
|---|---|---|
| Title | 30 Zeichen | **22 Zeichen** |
| Short Description | 80 Zeichen | **59 Zeichen** |
| Full Description | 4000 Zeichen | **2960 Zeichen** |

Die Limits sind in jeder Metadaten-Datei als HTML-Kommentar zu dokumentieren:

```markdown
### Title (max. 30 characters)
<!-- Translation-safe limit: 22 chars × 1.35 = 29.7 ≤ 30 -->
<!-- Current: XX chars -->
```

---

## Play Store Policy — Verbotene Formulierungen

Google Play lehnt folgende Formulierungen in Title, Short Description und Full Description ab:

| Verboten | Erlaubte Alternative |
|---|---|
| `free`, `100% free`, `completely free` | — (Preis steht im Store; nicht wiederholen) |
| `no ads`, `zero ads`, `ad-free and free` | `ad-free` (als Feature-Deskriptor) |
| `no hidden costs` | weglassen |
| `best`, `#1`, `top` | weglassen oder belegen |

**Faustregel:** Was der Store bereits anzeigt (Preis, Kategorie), nicht in den Texten wiederholen. Feature-Eigenschaften ("ad-free", "offline-capable", "GDPR compliant") sind erlaubt.

---

## Conversion-Optimierung

### Reihenfolge: Eltern / Nutzer-Hook zuerst

Den wichtigsten Kaufgrund **in der ersten sichtbaren Zeile** platzieren — Nutzer scrollen selten die volle Beschreibung.

- **Kinder-Apps:** Privacy-Block zuerst (kein Ad, kein Tracking, kein Internet) → dann Features
- **Produktivitäts-Apps:** Problem-Lösung-Hook zuerst ("Too many tasks, not enough time?") → dann Features
- **Daten-Apps:** Nutzen zuerst ("See live electricity prices") → dann Quellen

### Struktur der Full Description

```
[Hook: 1–2 Sätze, Problem → Lösung]

[Sektion 1: Kern-Features mit Emojis]
[Sektion 2: USP / Privacy / Vertrauen]
[Sektion 3: Weitere Features, wenn relevant]

[Abschluss: 1 ruhige Zeile ohne Preis-Claim]
```

### Short Description

- Enthält den stärksten Nutzen **und** das wichtigste Keyword
- Keine Preis-Claims
- Ziel: unter 45 Zeichen für maximale Übersetzungssicherheit

---

## Title-Optimierung

- Der Titel ist das wichtigste SEO-Feld
- App-internen Namen beibehalten wenn er ein Keyword ist (z. B. "Eisenhauer")
- Ergänzend ein beschreibendes Keyword hinzufügen (z. B. "Eisenhauer: Priorities")
- Kein "App" oder "Free" im Titel — verschwendet Zeichen

---

## Keywords / Tags

Long-Tail-Phrasen statt Einzelwörter:

```
✅  "memory game kids", "times tables trainer", "offline task manager"
❌  "kids", "games", "offline"
```

---

## Conversion-Rate Baselines (Stand 2026-06-26)

| App | Conversion vorher | Listing-Stand |
|---|---|---|
| DrawFromMemory | 7 % | optimiert |
| EnergyPriceGermany | 50 % | nicht anfassen |
| 1x1 Trainer | 16 % | optimiert |
| Eisenhauer | 3 % | optimiert |

> EnergyPriceGermany hat mit 50 % einen sehr guten Wert. Das Listing wird **nicht** geändert — Optimierungen würden das Risiko einer Verschlechterung tragen.

---

## Data Safety (Google Play Console)

Apps **ohne** Netzwerkzugriff:

```
☑️ No, this app doesn't collect or share any user data
☑️ Data is encrypted in transit (N/A - no network transmission)
☑️ Users can request that data be deleted (uninstall removes all data)
```

Apps **mit** Login / Cloud-Sync (z. B. Eisenhauer mit Firebase):

```
☑️ Yes — only when signed in
  - Account info (email, name via Firebase Auth)
  - App activity (user-generated content in Firestore)
  - Guest mode: no data collected
☑️ Data is encrypted in transit (HTTPS / Firebase TLS)
☑️ Users can request deletion (account deletion removes Firestore data)
```
