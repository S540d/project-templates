# /simplify-Audit — wiederkehrender Standardprozess

> Zentrale Quelle für den `/simplify`-Durchlauf auf Projekt-Quellcode (Issue #159).
> Kurzverweis steht in `dev-standards/base/global-policy.md` (wird per
> `sync-standards.sh` in jede Projekt-`CLAUDE.md` synchronisiert). Diese Datei
> selbst wird **nicht** in Projekt-Repos kopiert.
>
> Nicht zu verwechseln mit `/simplify` auf die `CLAUDE.md` selbst — das ist ein
> eigener Prozess, siehe [`claude-md-maintenance.md`](claude-md-maintenance.md).

## Abgrenzung zum Code-Health-Audit

| | [Code-Health-Audit](code-health-audit.md) | `/simplify`-Audit |
|---|---|---|
| Zweck | Ballast und Architektur aufspüren | Kleine, verhaltensneutrale Refactorings umsetzen |
| Ergebnis | **Findings-Issue**, kein Code | **PR** mit angewendeten Fixes |
| Umfang | Auch größere Befunde (God Components, CI-Gates) | Nur gezielte, kleine Änderungen |

Beide laufen in derselben Kadenz und können kombiniert werden: Audit zuerst,
dann die kleinen Befunde per `/simplify` als PR umsetzen.

## Ablauf

1. **Review gegen den kompletten Quellcode-Stand** (nicht nur den letzten Diff)
   mit den vier Blickwinkeln **Reuse, Simplification, Efficiency, Altitude**.
2. **Findings bewerten** mit geschätzter Zeilenersparnis bzw. Laufzeit-Impact.
   Nur Punkte mit klar benennbarem Nutzen behalten. Bei Unsicherheit über eine
   Verhaltensänderung: Finding auslassen, nicht raten.
3. **Rücksprache**, dann Fixes umsetzen. Lokal Lint, volle Testsuite und Build
   verifizieren.
4. **Feature-Branch, Commit, PR** gegen den projektüblichen Ziel-Branch
   (in der Regel `testing`).

Bewusst nicht umgesetzte Findings mit Begründung im PR oder im Findings-Issue
festhalten, damit der nächste Turnus sie nicht erneut vorschlägt.

## Kadenz

Alle **~3 Monate** oder nach **~15 gemergten Feature-PRs** pro Projekt (je
nachdem, was zuerst eintritt), gleiche Taktung wie das Code-Health-Audit.
Archivierte Projekte sind ausgenommen.

## Nicht-Ziel

Kein Freifahrtschein für große Rewrites oder Architekturänderungen — nur
gezielte, kleine, verhaltensneutrale Refactorings mit klar benennbarem Nutzen
(Zeilenersparnis oder Laufzeit).

## Referenz-Durchläufe

- **Eisenhauer:** PR [#465](https://github.com/S540d/Eisenhauer/pull/465) — toter Code, Theme-Logik-Duplikat, `getLocale()`-Helper, Batch- statt Einzel-Firestore-Writes.
- **EnergyPriceGermany:** Findings-Issue #503, Umsetzung in PRs #508–#511, Release 1.11.3 (#512) — u. a. `Storage`-Adapter statt direktem `AsyncStorage`, gemeinsames post-build-Modul, zentraler EUR/MWh→ct/kWh-Helper.
- **Boersenspiel**, **Epic_Calendar:** durchlaufen, Details in den jeweiligen Repos.
