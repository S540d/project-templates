# Code-Health-Audit gegen ein Ziel-Repo fahren

Führt einen Code-Health-Audit-Durchlauf (project-templates#136,
`dev-standards/code-health-audit.md`) gegen ein einzelnes Ziel-Repo aus und
erstellt/aktualisiert dort das Ergebnis-Issue.

**Dieser Command lebt bewusst nur hier in `project-templates/.claude/commands/`**,
NICHT im `claude-commands/`-Sync-Ordner — dieser wird von `scripts/sync-standards.sh`
komplett und überschreibend in alle Projekt-Repos kopiert, und genau diese
Duplikation soll der Code-Health-Audit-Standard vermeiden (siehe #136). Der
Command ist deshalb nur verfügbar, wenn `project-templates` selbst in der
Session angehängt ist.

## Ziel

Ein GitHub-Issue mit priorisierten, konkret umsetzbaren Befunden im Ziel-Repo —
nichts wird im Ziel-Repo committet, nichts landet in `project-templates`.

## Argument

Name des Ziel-Repos, z. B. `/code-audit Eisenhauer` (unter `S540d/` angenommen,
sonst `owner/repo` explizit angeben).

## Workflow

### 1. Ziel-Repo verfügbar machen

Falls das Ziel-Repo noch nicht in dieser Session angehängt ist: `add_repo`
aufrufen. Falls lokal bereits geklont (z. B. unter `/home/user/<Repo>`), diesen
Checkout verwenden.

### 2. Checkliste laden

`dev-standards/code-health-audit.md` aus dem lokalen `project-templates`-
Checkout lesen — liegt im selben Repo wie dieser Command, kein Netzwerk-Fetch
nötig.

### 3. Ziel-Repo vorbereiten

```bash
git fetch origin testing && git checkout testing && git pull origin testing
```

Sauberer, aktueller Stand. **Keine Codeänderungen.** Kein `npm install`/`ci`,
wenn `node_modules` fehlt und der Netzwerkzustand unsicher ist — Bundle-Größe
dann als „nicht messbar" vermerken statt zu erzwingen (siehe Methodik-Regeln in
`dev-standards/code-health-audit.md`). Falls doch gemessen wird: alle
generierten Artefakte danach zurücksetzen, `git status` muss am Ende clean
sein.

### 4. Dedup-Check — per GitHub-API, nicht per CLAUDE.md-Vertrauen

Mit `mcp__github__issue_read` (`method: get` auf bekannte Nummern) bzw. Suche
im Ziel-Repo nach bestehenden Audit-Issues (Titel-Muster „Code-Health-Audit"
oder Verweis auf project-templates#136) prüfen. **Den tatsächlichen
`state`-Wert der API vertrauen, nicht einer CLAUDE.md-Aussage** — ein
Meta-Issue kann geschlossen sein, während das zugehörige Befund-Issue offen
bleibt (siehe 1x1_Trainer#357 vs. #359).

- Offenes Tracking-Issue aus früherem Audit existiert → **Kommentar** darauf
  mit dem neuen Stand, kein neues Issue.
- Sonst → neues Issue.

### 5. Checkliste abarbeiten

Alle Punkte aus `dev-standards/code-health-audit.md` durchgehen, inkl. der
**CI-Gate-Integrität** (eigener Checklistenpunkt — in Runde 1 der mit Abstand
ergiebigste Einzelcheck, 5 von 7 Projekten betroffen). Für Repos mit
unklarer Größe/Komplexität einen Explore-Agenten mit Checkliste + Repo-Kontext
beauftragen; bei kleinen, überschaubaren Repos ggf. direkt selbst prüfen.

### 6. Befund-Format erzwingen

Pro Punkt: **Datei:Zeile**, ein **konkretes Beispiel**, ein **Vorschlag**, ein
**geschätztes Risiko**. Keine vagen „könnte man aufräumen"-Punkte. Vor dem
Erstellen des Issues die 1-2 gewichtigsten Befunde selbst per direktem
`grep`/`Read` gegenverifizieren — Pflichtschritt, kein optionaler Zusatz.

### 7. Issue erstellen/aktualisieren

Format wie in `dev-standards/code-health-audit.md`/Vorlage
[1x1_Trainer#357](https://github.com/S540d/1x1_Trainer/issues/357): pro Befund
eine Checkbox, „Kein nennenswerter Befund"-Punkte explizit benennen (nicht
weglassen — zeigt, dass die Checkliste tatsächlich durchgegangen wurde),
Prioritäts-Hinweis am Ende. Immer auf project-templates#136 bzw.
`dev-standards/code-health-audit.md` verweisen.

## Nicht-Ziel

- Keine Codeänderungen im Ziel-Repo
- Keine Rewrites vorschlagen — nur gezielte, kleine Refactoring-Punkte
- Kein Issue in `project-templates` selbst

## Checkliste (Ende des Durchlaufs)

- [ ] Ziel-Repo verfügbar und auf aktuellem `testing`-Stand
- [ ] Bestehende Audit-Issues per API geprüft (nicht per Doku-Vertrauen)
- [ ] Alle Punkte aus `dev-standards/code-health-audit.md` durchgegangen, inkl. CI-Gate-Integrität
- [ ] Top-Befunde selbst gegenverifiziert
- [ ] Issue erstellt oder bestehendes kommentiert, mit Verweis auf #136
- [ ] `git status` im Ziel-Repo clean (keine Artefakte hinterlassen)
