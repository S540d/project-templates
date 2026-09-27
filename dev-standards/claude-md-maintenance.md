# CLAUDE.md-Wartung — wiederkehrender Standardprozess

> Zentrale Quelle für den CLAUDE.md-Wartungsprozess (Issue #160).
> Kurzverweis darauf steht in `dev-standards/base/global-policy.md` (Abschnitt
> `[CLAUDE.MD-WARTUNG]`, wird per `sync-standards.sh` in jede Projekt-`CLAUDE.md`
> synchronisiert). Diese Datei selbst wird **nicht** in Projekt-Repos kopiert —
> sie bleibt einzige Quelle hier in `project-templates`.

## Motivation

`EnergyPriceGermany/CLAUDE.md` wuchs bis 2026-09-27 auf 1055 Zeilen / ~64 KB.
Sie wird bei **jeder Session** vollständig in den Kontext geladen, bevor
überhaupt gearbeitet wird — jede überflüssige Zeile ist wiederkehrender
Token-Verbrauch, nicht nur ein einmaliger Lesekomfort-Verlust. Ursache war
nicht Regelwildwuchs, sondern dass volle Vorfalls-Erzählungen (Zeitstempel,
PR-Nummern, Diagnose-Verlauf) und ausführliche, aber nicht-vorfallsbezogene
Architektur-/Prozessbeschreibungen direkt im Fließtext standen, statt in
Detail-Dokumente ausgelagert zu sein.

Nach zwei Kürzungsrunden (PR EnergyPriceGermany#504) landete die Datei bei
346 Zeilen (~19 KB) — ein Rückgang um ~67 %, ohne dass eine einzige
Kernregel verloren ging.

## Zielgröße

**CLAUDE.md bleibt bei maximal 300 Zeilen.** Das ist die endgültige Vorgabe,
nicht die ursprünglich diskutierte Zwischenstufe von 500 Zeilen/30 KB.

## Wohin Inhalte gehören

| Inhaltstyp | Zielort | Sichtbarkeit |
|---|---|---|
| Kernregel, die jede Session sofort kennen muss | `CLAUDE.md` | versioniert |
| Vorfalls-Erzählung (Datum, PR-Nummer, Diagnose-Schritte, Beispielwerte) | `docs/private/INCIDENTS.md` | **gitignored**, nur lokal |
| Aktuell gültige Architektur-/Verhaltensbeschreibung (kein Vorfall, aber zu ausführlich für CLAUDE.md) | `docs/ARCHITECTURE.md` (oder themenspezifische `docs/*.md`, z. B. `docs/GIT-WORKFLOW.md`) | versioniert |

**Warum `docs/private/` und nicht `docs/INCIDENTS.md` versioniert:**
Vorfalls-Chroniken sind eine reine Gedächtnisstütze für Claude — vergleichbar
mit dem Memory-System, nicht mit projekteigener Dokumentation. Sie enthalten
oft interne Diagnose-Details, die für menschliche Leser oder andere
Mitarbeiter keinen Mehrwert haben und beim Lesen der Doku nur ablenken.
Architektur- und Prozesswissen dagegen **muss** für andere
Mitarbeiter/Maschinen sichtbar bleiben — das gehört in versionierte
`docs/*.md`-Dateien, nicht nach `docs/private/`.

**Voraussetzung pro Projekt:** `.gitignore` muss einen Eintrag `docs/private/`
enthalten, *bevor* die erste Datei dort abgelegt wird. Existiert bereits eine
versionierte `docs/INCIDENTS.md`, wird sie verschoben (`git mv
docs/INCIDENTS.md docs/private/INCIDENTS.md`) und per `git rm --cached`
aus dem Tracking genommen — die Git-Historie bleibt dabei unangetastet,
nur der aktuelle Tracked-Zustand ändert sich.

## Ablauf eines Wartungs-Durchlaufs

1. **`/simplify` auf CLAUDE.md ausführen** (oder gleichwertig manuell): Datei
   komplett lesen, Abschnitte identifizieren, die (a) einen konkreten Vorfall
   erzählen oder (b) Architektur-/Prozesswissen sind, das nicht in jeder
   Session gebraucht wird.
2. **Für jeden Vorfalls-Abschnitt:** prüfen, ob der Vorfall schon in
   `docs/private/INCIDENTS.md` dokumentiert ist. Wenn nein, dort **zuerst**
   einen vollständigen Eintrag anlegen (nichts geht verloren), dann erst in
   `CLAUDE.md` auf Kernregel + kurzen Auslöser-Kontext (max. 2-3 Zeilen) +
   Link kürzen.
3. **Für jeden Architektur-/Prozess-Abschnitt:** prüfen, ob das Wissen schon
   in `docs/ARCHITECTURE.md` oder einer passenden Detail-Datei steht. Wenn
   nein, dort ergänzen (als neuer Abschnitt, mit Anker für den Rückverweis),
   dann in `CLAUDE.md` auf 1-3 Zeilen + Link kürzen.
4. **Größencheck:** `wc -l CLAUDE.md`. Über 300 Zeilen → Schritt 2/3
   wiederholen, ggf. auch scheinbar kurze Abschnitte zusammenfassen oder in
   Aufzählungen verdichten.
5. **Links verifizieren:** jeder erzeugte `docs/...#anchor`-Link muss auf eine
   tatsächlich existierende Überschrift zeigen (GitHub-Anker-Slug-Regeln:
   Kleinschreibung, Leerzeichen → Bindestrich, Sonderzeichen/Umlaute entfernt).
6. **PR gegen `testing`**, normale PR-Regeln (Titel mit Issue-Referenz,
   Body erklärt was/warum). `docs/private/INCIDENTS.md` selbst taucht im Diff
   nicht auf (gitignored) — nur `git rm --cached` einer vorher versionierten
   Datei zeigt sich als Löschung.

## Methodik-Regeln (aus EnergyPriceGermany-Durchlauf gelernt)

- **Nicht mit „Vorfälle auslagern" aufhören, wenn die Zielgröße noch nicht
  erreicht ist.** Bei EnergyPriceGermany reichte reines Vorfälle-Auslagern nur
  für 1055 → 924 Zeilen. Der große Rest (924 → 346) kam erst durch Auslagern
  von aktuell gültigem Architektur-/Prozesswissen, das kein Vorfall war.
- **Den `[GLOBAL POLICY]`-Marker-Block nicht mitzählen-wollen, aber auch nicht
  anfassen.** Er wird von `sync-standards.sh` verwaltet und zählt als fixe
  Zeilenlast (aktuell ca. 30 Zeilen) — bei der 300-Zeilen-Vorgabe realistisch
  einplanen, nicht versuchen ihn zu kürzen.
- **Beim Verschieben von Inhalten nach `docs/ARCHITECTURE.md` auf
  Aktualität der Zieldatei prüfen.** Bestehende Abschnitte dort können
  veraltet sein (z. B. ein altes Architektur-Diagramm) — neuen Inhalt als
  aktuellen Stand kennzeichnen (`⚠️ Das Diagramm oben ist der ursprüngliche
  Entwurf...`) statt stillschweigend zu duplizieren oder den alten Stand als
  aktuell erscheinen zu lassen.
- **Relative Pfade beim Verschieben prüfen.** Eine Datei, die von
  `docs/INCIDENTS.md` nach `docs/private/INCIDENTS.md` wandert, braucht einen
  zusätzlichen `../` in Rückverweisen auf `CLAUDE.md` (eine Ebene tiefer).
- **Kaputte Alt-Links beim Durchgehen mitkorrigieren.** Vorgefundene falsche
  relative Pfade (z. B. `../docs/ARCHITECTURE.md` in einer `CLAUDE.md`, die
  selbst im Repo-Root liegt) gehören repariert, nicht unverändert übernommen.

## Kadenz

**Regelmäßig `/simplify` auf CLAUDE.md ausführen** — ergänzend zum
Code-Health-Audit-Rhythmus (alle ~3 Monate oder ~15 gemergte Feature-PRs),
nicht nur einmalig beim Erreichen der Schwelle. Ziel ist, dass CLAUDE.md
dauerhaft unter 300 Zeilen bleibt statt zyklisch wieder anzuwachsen und dann
in großen Sprüngen zurückgekürzt zu werden.

## Nicht-Ziel

Dies ist kein Freifahrtschein, Regeln ganz zu streichen oder so stark zu
verdichten, dass sie ihre Warnwirkung verlieren. Ziel ist Verschiebung an den
richtigen Ort, nicht Kürzung von Inhalt — jede verschobene Information muss
in der Zieldatei vollständig wiederzufinden sein.

**Die Regel adressiert nur Vorfalls-/Bugfix-Narrative, nicht die
Gesamtlänge als Kürzungsziel.** Bei Boersenspiel zeigte sich, dass ein
Großteil der Länge keine Vorfälle sind, sondern laufende
Architektur-/Modellierungsentscheidungen, die laut Projektkonvention bewusst
direkt in CLAUDE.md stehen sollen. Die 300-Zeilen-Schwelle bleibt der
Auslöser, um eine Datei zu prüfen — sie verlangt aber nicht, jede Datei
zwanghaft unter 300 Zeilen zu drücken, wenn der Überhang aus bewusst dort
gehaltenem, aktuellem Architekturwissen besteht statt aus Vorfällen oder
ausgliederbarem Prozesswissen.

## Stand nach Ausrollen (Stand 2026-09-27, siehe Issue #160 für Kommentar-Historie)

| Projekt | CLAUDE.md-Zeilen | Status |
|---|---|---|
| EnergyPriceGermany | 346 (vorher 1055) | 🔶 PR #504 gemergt, liegt real aber wieder über der 300-Schwelle — erneuter Kürzungsdurchlauf nötig |
| Eisenhauer | 363 (38 KB, vorher 44 KB) | 🔶 PR #466 gemergt, seither wieder über 300 Zeilen gewachsen — erneut prüfen |
| ELEGOO-Smart-Robot-Car-Kit-V4.0 | 302 (bereits unter Schwelle) | ✅ Vorfalls-Erzählung ausgelagert (PR #32) |
| Grundlagen_Linguistik | — (hatte keine CLAUDE.md) | ✅ von Anfang an regelkonform angelegt (PR #8, gemergt) |
| epic_Calendar | 324 (54 KB) | 🔶 Cleanup-PR offen (Epic_Calendar#264) |
| Boersenspiel | 1458 | 🔶 erster Pass umgesetzt (PR #116) — Vorfälle ausgelagert, bleibt bewusst über 500 Zeilen wegen Architektur-Doku (siehe Klarstellung oben) |
| Pflanzkalender | 224 (vorher 615) | ✅ umgesetzt (PR #296) |
| history_line | 713 | ⏳ offen — noch kein Wartungs-Durchlauf gemacht |
| DrawFromMemory | 542 | ⏳ offen |
| 1x1_Trainer | 235 (vorher 389) | ✅ umgesetzt (PR #388, gemergt) |
| safe_my_plants | 377 | ⏳ offen |
| CD-to-Spotify-PWA | 212 | ✅ unter 300 |
| myNotes | 213 | ✅ unter 300 |
| document_sorter_app | 182 | ✅ unter 300 |
| Smart_Home_Multi-Display_ESP32 | 152 | ✅ unter 300 |
| backup-my-Garmin-Fenix | 125 | ✅ unter 300 |
| Apple_Notizen_Export_Skript | 115 | ✅ unter 300 |
| influxDB_cleaning_programm | 50 | ✅ unter 300 |

Zeilenzahlen sind der jeweils zuletzt bekannte Stand vor bzw. nach dem
Wartungs-Durchlauf (siehe Status-Spalte). Nach jedem Durchlauf diese Tabelle
aktualisieren (nicht als separates Issue pflegen — sie gehört hierher, an die
Prozessbeschreibung).

### docs/private/-Check (Stand 2026-09-27, Issue #160)

Cross-Projekt-Prüfung, ob `ARCHITECTURE.md` fälschlich unter `docs/private/`
statt versioniert unter `docs/` liegt: **kein Treffer.** `ARCHITECTURE.md`
liegt in allen betroffenen Projekten (1x1_Trainer, CD-to-Spotify-PWA,
DrawFromMemory, Eisenhauer, EnergyPriceGermany, Pflanzkalender,
safe_my_plants) korrekt versioniert unter `docs/`.

`INCIDENTS.md` liegt korrekt unter `docs/private/` (gitignored) nur in
EnergyPriceGermany (~33 KB) und Pflanzkalender (~13 KB); beide `.gitignore`
enthalten den nötigen `docs/private/`-Eintrag. `docs/private/` wird in
1x1_Trainer, DrawFromMemory und Eisenhauer zusätzlich als Ablageort für
sonstige lokale Doku (Play-Store-Metadaten, Release-Checklisten,
Deployment-Guides) genutzt — zulässig, aber kein Incidents-Fall.

Nebenbefund: Boersenspiel fehlte der `docs/private/`-Eintrag in `.gitignore`
(dort ist pauschal `docs/` ignoriert) — ergänzt, bestehende Policy sonst
unverändert gelassen.
