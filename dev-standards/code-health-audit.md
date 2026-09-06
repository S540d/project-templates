# Code-Health-Audit — wiederkehrender Standardprozess

> Zentrale Quelle für den Code-Health-Audit-Prozess (Issue #136).
> Kurzverweis darauf steht in `dev-standards/base/global-policy.md` (wird per
> `sync-standards.sh` in jede Projekt-`CLAUDE.md` synchronisiert). Diese Datei
> selbst wird **nicht** in Projekt-Repos kopiert — sie bleibt einzige Quelle
> hier in `project-templates`.

## Motivation

Ein Ad-hoc-Audit von `1x1_Trainer` (2026-09-05) lieferte innerhalb kurzer Zeit
konkrete, umsetzbare Befunde: einen God Component (`App.tsx`), eine
Boilerplate-Duplikationsklasse in `utils/storage.ts` (inkl. totem Code) und
eine wiederholte Codesequenz in `useGameLogic.ts` (siehe
[1x1_Trainer#357](https://github.com/S540d/1x1_Trainer/issues/357)). Solche
Befunde häufen sich zwangsläufig zwischen schnell aufeinanderfolgenden
Feature-PRs, werden aber ohne dedizierten Anlass nie gebündelt angegangen,
weil jeder einzelne PR für sich genommen klein und gerechtfertigt aussieht.

Das betrifft jedes Projekt mit vergleichbarer PR-Taktung (z. B. auch
`Eisenhauer`), nicht nur `1x1_Trainer`. Deshalb liegt der Prozess hier statt in
einem Einzelprojekt.

## Ablauf

Ein Audit-Durchlauf prüft **ausschließlich Bestandscode**, keine neuen
Features. Er wird von einer Session aus gefahren, die Zugriff auf das
Ziel-Repo hat (lokal geklont oder per `add_repo` angehängt) — **nicht**
zwingend `project-templates` selbst, solange diese Datei erreichbar ist (z. B.
per `WebFetch` der Raw-URL, siehe Kurzverweis in `[GLOBAL POLICY]`). Ergebnis
ist **ein GitHub-Issue im Ziel-Repo** (Vorlage:
[1x1_Trainer#357](https://github.com/S540d/1x1_Trainer/issues/357)) mit
priorisierten, einzeln umsetzbaren Punkten. **In das Ziel-Repo wird dabei
nichts committet** — der Audit selbst verändert keinen Code, nur das Issue
entsteht dort.

### Checkliste

- [ ] **God Components / God Modules:** Dateien mit ungewöhnlich vielen
      `useState`/`useEffect` bzw. Exporten aufspüren; insbesondere Anhäufung
      von `eslint-disable react-hooks/exhaustive-deps` als Signal für
      verteilten State, der eigentlich zusammengehört
- [ ] **Boilerplate-Duplikation:** wiederkehrende Get/Save- oder Reset-Muster,
      die sich zu einer Factory/Hilfsfunktion zusammenfassen lassen
- [ ] **Toter Code:** Exporte ohne Aufrufer außerhalb der eigenen Tests
- [ ] **Dependency-Bloat:** `package.json`/Lockfile gegen tatsächliche Nutzung
      prüfen, `npm audit` auf offene Findings, ungenutzte/duplizierte
      Libraries für denselben Zweck
- [ ] **Test-Integrität:** Testet CI wirklich alles, was lokal getestet wird
      (keine stillen Test-Ausschlüsse)? Coverage-Schwellen noch realistisch?
- [ ] **Design-/Style-Konsistenz:** neue hartkodierte Werte außerhalb
      zentraler Token-Definitionen
- [ ] **Bundle-Größe (falls Web-Build vorhanden):** Größenvergleich zum
      letzten Audit

### Befund-Format (Pflicht pro Punkt)

Jeder Befund bekommt: **Datei:Zeile**, ein **konkretes Beispiel**, einen
**Vorschlag** und ein **geschätztes Risiko**. Keine vagen „könnte man mal
aufräumen"-Punkte — jeder Punkt muss so formuliert sein, dass er direkt als
eigenständiges kleines Refactoring-Ticket umsetzbar ist.

## Kadenz

Alle **~3 Monate** oder nach **~15 gemergten Feature-PRs** pro Projekt (je
nachdem, was zuerst eintritt) — orientiert an der tatsächlichen Änderungsrate,
nicht an einem starren Kalenderdatum.

## Nicht-Ziel

Dies ersetzt keine Reviews einzelner PRs und ist kein Freifahrtschein für
große Rewrites. Der Output pro Projekt sind gezielte, kleine
Refactoring-Issues, keine Neuarchitektur.
