# Einheitlicher „Über"-Abschnitt — Standard für alle Web-Projekte

> Zentrale Quelle für den „Über"-Standard (Issue #150).
> Kurzverweis darauf steht in `dev-standards/base/global-policy.md` (wird per
> `sync-standards.sh` in jede Projekt-`CLAUDE.md` synchronisiert). Diese Datei
> selbst wird **nicht** in Projekt-Repos kopiert — sie bleibt einzige Quelle
> hier in `project-templates`.

## Motivation

Issue [#150](https://github.com/S540d/project-templates/issues/150) stellte
fest, dass kein Projekt ein zentrales Impressum verlinkt und die vorhandenen
„Über"/Rechtliches-Abschnitte (soweit überhaupt vorhanden) uneinheitlich
aufgebaut sind — manche verlinken nur die Datenschutzerklärung, manche nur
aus der README statt aus der App-UI selbst, die meisten gar nichts. Ergebnis
eines Audits über alle Web-Auftritte (2026-09-16): kein Projekt verlinkt ein
Impressum aus der App-UI heraus, weil es bislang schlicht keins gibt.

Dieser Standard legt fest, **wo** (Struktur) und **was** (Inhalt) ein
„Über"-Abschnitt in jedem Web-Projekt zeigt — unabhängig vom Tech-Stack
(Expo/React Native Web, statische HTML-Seite, Eleventy, Jinja-generiertes
Dashboard).

## Grundprinzip: immer über ein Settingsmenü, nie über einen Footer

Ein Footer kostet auf mobilen Bildschirmen Platz und ist inkonsistent mit
Projekten, die bereits ein Einstellungsmenü haben. Stattdessen bekommt
**jedes** Web-Projekt ein Menü, erreichbar über ein `⋮`-Icon (U+22EE, bereits
Konvention in Pflanzkalender), mit „Über" als einem Menüpunkt.

**Das gilt auch für Projekte ohne jede Settings-Infrastruktur** (aktuell:
griechische-Götterwelt, philosophen, grundlagen_linguistik) — dort wird das
Menü neu geschaffen, auch wenn „Über" vorerst der einzige Eintrag ist. Der
Grund: früher oder später kommt ohnehin ein weiterer Menüpunkt dazu (z. B.
Dark Mode) — ein Footer-Link wäre dann nur ein Wegwerf-Provisorium, das beim
späteren Menü-Bau wieder verworfen werden müsste.

**Bereits vorhandene ⋮/Drei-Punkt-Menüs sind der Andockpunkt**, kein neues
Muster nötig:
- Pflanzkalender: `⋮`-Tab-Icon öffnet das Settings-Menü
- Boersenspiel: `<details class="menu">` in `templates/base.html.j2`, auf
  jeder generierten Seite verfügbar

## „Über" — Vollausbau (feste Reihenfolge, verbindlich)

```
⋮-Menü → „Über"
1. [App-Icon] App-Name
2. Version X.Y.Z
   ──────────────
3. Impressum         → https://s540d.github.io/impressum.html
4. Datenschutz        → <projekteigene Datenschutz-Seite>
5. Quellcode (GitHub)  → Repo-Link
6. Play Store          → Store-Link
7. Feedback / Kontakt  → GitHub-Issues-Link
```

| # | Feld | Pflicht? | Hinweis |
|---|------|----------|---------|
| 1 | App-/Projektname | immer | |
| 2 | Version | immer | **Dynamisch aus `package.json`/`app.json`/Manifest lesen, nie hartkodieren** — Vorbild: Pflanzkalenders `SettingsScreen` seit PR #124 |
| 3 | Impressum | immer | Link auf die zentrale Seite `https://s540d.github.io/impressum.html` — **nie** projektlokal duplizieren |
| 4 | Datenschutz | nur wenn das Projekt personenbezogene Daten verarbeitet oder eine Android-App mit Play-Store-Pflichtangabe hat | Rechtlich getrennt vom Impressum (§5 TMG vs. DSGVO) — **niemals zu einem gemeinsamen Link zusammenlegen** |
| 5 | Quellcode (GitHub) | optional, empfohlen bei jedem Open-Source-Projekt | |
| 6 | Play Store | optional, nur wenn eine Android-App zum Projekt existiert | |
| 7 | Feedback/Kontakt | optional | In der Regel reicht ein Link auf die GitHub-Issues des Repos |

**Regel für den Vollausbau:** Diese Reihenfolge ist die maximale
Ausbaustufe. Ein Projekt ohne Android-App lässt Punkt 6 weg, eines ohne
Datenverarbeitung Punkt 4 usw. — **die Reihenfolge der verbleibenden Felder
bleibt dabei immer wie oben**, es wird nie umsortiert und kein Feld an
anderer Stelle eingefügt. Punkt 1–3 (Name, Version, Impressum) sind der
eigentliche Kern von Issue #150 und praktisch nie weglassbar.

## Voraussetzung: zentrales Impressum

Punkt 3 setzt voraus, dass unter `https://s540d.github.io/impressum.html`
tatsächlich eine Impressum-Seite existiert. Root-Repo `S540d.github.io`
hostet aktuell nur `.well-known/assetlinks.json` für die Android-App-Link-
Verifizierung — die Impressum-Seite muss dort zuerst angelegt werden, bevor
irgendein Projekt sinnvoll darauf verlinken kann. Das ist eine eigene,
blockierende Vorbedingung, kein Teil der Pro-Projekt-Umsetzung.

## Ablauf

Analog zum [Code-Health-Audit](code-health-audit.md): Die Umsetzung pro
Projekt läuft als **ein Issue im jeweiligen Projekt-Repo**, nie als
Sammel-PR gegen mehrere Repos. Jedes Issue verlinkt zurück auf
[project-templates#150](https://github.com/S540d/project-templates/issues/150)
als Ursprung des Standards. In `project-templates` selbst wird dabei nichts
verändert außer dieser Datei und dem Kurzverweis in
`dev-standards/base/global-policy.md`.

Je Projekt-Issue gehört:
- Bestandsaufnahme (existiert schon ein Menü? existiert schon eine
  Datenschutzseite, die verlinkt werden kann?)
- Konkrete Felderliste nach obigem Vollausbau-Schema, abzüglich nicht
  zutreffender Felder
- Verweis auf diese Spezifikation

## Nicht-Ziel

Dieser Standard schreibt nur den „Über"-Abschnitt fest, nicht das gesamte
Settingsmenü-Design (Dark Mode, Sprache, sonstige Einstellungen bleiben
projektspezifisch). Er ersetzt auch nicht die rechtliche Prüfung des
Impressum-/Datenschutz-Texts selbst — nur dessen Verlinkung.
