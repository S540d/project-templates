# Ausführungs-Anleitung: Rollout v2 (am PC ausführen)

Schritt-für-Schritt zum Abschluss der Umstellung auf das v2-Review-Modell
(kostenloses Merge-Gate + abo-basierter KI-Review). Hintergrund & Status: Issue #62.

> Diese Schritte brauchen Schreibzugriff (gh-Login als Repo-Admin) und gehen daher
> **nicht** aus einer Sandbox-Session, sondern lokal am PC.

## Voraussetzungen
```bash
gh auth status                       # eingeloggt als S540d (Admin)
git clone https://github.com/S540d/project-templates   # falls noch kein Klon
cd project-templates
```

## Schritt 1 — PR #61 mergen
`main` ist per Ruleset geschützt (0 Approvals, aber PR-Pflicht) → Solo-Merge via `--admin`.
```bash
gh pr merge 61 --repo S540d/project-templates --squash --admin
```
Erwartung: PR #61 ist „Merged", `main` enthält die 3 Commits (Mergeability-Workflow,
Self-Filter-Fix, Migrations-Kit).

## Schritt 2 — Tag `v2` setzen
`v1` bleibt unverändert (zeigt auf den alten Stand → Downstream-`@v1` friert ein).
Neuer Tag `v2` für die umgestellten Reusables:
```bash
git fetch origin main
git tag -a v2 origin/main -m "v2: kostenloses Merge-Gate (mergeability) + on-demand KI-Review"
git push origin v2
```
Prüfen: `git ls-remote --tags origin v2` zeigt den Tag.

## Schritt 3 — Pilot: safe-my-plants
Aus dem **project-templates-Klon** (enthält das Kit `scripts/migrate-to-v2.sh`):
```bash
# lokalen Klon des Ziel-Repos bereitstellen
git clone https://github.com/S540d/safe-my-plants ~/code/safe-my-plants

# Workflows + Labels einspielen (dry-run zum Anschauen, dann echt)
./scripts/migrate-to-v2.sh --dry-run S540d/safe-my-plants ~/code/safe-my-plants
./scripts/migrate-to-v2.sh         S540d/safe-my-plants ~/code/safe-my-plants

# im Ziel-Klon: Branch, Commit, PR gegen testing
cd ~/code/safe-my-plants
git checkout -b chore/review-v2
git add .github/workflows/mergeability.yml .github/workflows/pr-review.yml
git commit -m "chore: kostenloses Merge-Gate + on-demand KI-Review (v2)"
git push -u origin chore/review-v2
gh pr create --base testing --title "chore: Review-Modell v2" \
  --body "Kostenloses Gate + on-demand KI-Review (siehe project-templates Issue #62)"
```

### Verifikation am Pilot-PR (2–3 echte PRs)
- [ ] Mergeability-Sticky-Kommentar erscheint und aktualisiert sich bei Push
- [ ] Status `review-gate` grün (konfliktfrei) / rot (Konflikt)
- [ ] **Kein** automatischer API-Call (kein `pr-review`-Lauf ohne Label)
- [ ] Label `ai-review` setzen → beratender Haiku-Review erscheint, Gate unverändert
- [ ] `/review` aus Claude Code (Pro/Max-Abo) postet Findings — ohne API-Kosten

### Branch-Protection (falls nötig)
`review-gate` muss als required Status-Check gelistet bleiben (Context-Name
unverändert). Bei Web/React-Native-Repos ist er bereits in den Rulesets:
```bash
./scripts/apply-rulesets.sh --dry-run safe-my-plants   # prüfen
```

## Schritt 4 — Kern-Batch (nach erfolgreichem Piloten)
Gleiches Muster, je eigener PR, klein → groß:
```bash
for r in 1x1_Trainer DrawFromMemory Pflanzkalender Epic_Calendar Eisenhauer; do
  git clone "https://github.com/S540d/$r" ~/code/$r
  ./scripts/migrate-to-v2.sh "S540d/$r" ~/code/$r
  # dann pro Repo: Branch + Commit + PR gegen testing (siehe Schritt 3)
done
```
Nach jedem Merge kurz einen realen PR gegenprüfen, bevor das nächste Repo folgt.

## Schritt 5 — Abschluss
- In jedem migrierten Repo: `ANTHROPIC_API_KEY` ist nur noch für den optionalen
  `ai-review`-Fallback nötig — sonst entfernbar.
- `@v1` in der Doku als deprecated markieren (README/AUTOMATION_SETUP nennen bereits `@v2`).
- Issue #62 abhaken.

## Rollback (falls etwas klemmt)
- Pro Repo: PR schließen / Workflows entfernen → alter Zustand (`@v1`) bleibt nutzbar.
- `v2`-Tag verschieben/löschen: `git push --delete origin v2`.
- `main` wird nicht angefasst außer durch den bewussten PR-#61-Merge.
