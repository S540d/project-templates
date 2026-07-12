# Migration auf v2 – kostenloses Merge-Gate + abo-basierter KI-Review

Ablösung des metered API-Reviews (lief pro PR-Push) durch ein Drei-Schichten-Modell.
Tracking: Issue #62.

> **Status (2026-07-05): Rollout abgeschlossen.** Alle Repos (safe-my-plants,
> 1x1_Trainer, DrawFromMemory, Pflanzkalender, Epic_Calendar, Eisenhauer,
> EnergyPriceGermany, CD-to-Spotify-PWA) laufen auf `@v2`. Das **v1-Review-Modell
> ist deprecated** – der alte automatische API-Review
> (`reusable-pr-review.yml@v1` bei jedem Push) und das Ack-Label-Gate
> (`reusable-review-gate-resolve.yml@v1`) werden nicht mehr verwendet. Neue Repos
> direkt mit `@v2` aufsetzen. Der Tag `@v1` bleibt eingefroren (nur für etwaige
> Alt-Stände), wird aber nicht weiter gepflegt.

## Was sich ändert
| | vorher (v1) | nachher (v2) |
|---|---|---|
| Gate | Claude-API setzt `review-gate` (metered, jeder Push) | `mergeability.yml` setzt `review-gate` (kostenlos, GitHub-API) |
| Tiefer Review | automatisch via API | `/review` aus Claude Code (Pro/Max-Abo, ohne Pay-per-Token) |
| API-Review | immer | optional, on-demand via Label `ai-review` (Haiku, beratend) |
| `ANTHROPIC_API_KEY` | Pflicht | nur für optionalen Fallback |

Der Status-Context bleibt **`review-gate`** → bestehende Rulesets greifen unverändert.

## Pro Repo migrieren

Schnellweg mit dem Kit (aus dem project-templates-Klon):

```bash
./scripts/migrate-to-v2.sh S540d/<RepoName> /abs/pfad/zum/<RepoName>-klon
# danach im Klon: Branch + Commit + PR gegen testing (siehe Skript-Ausgabe)
```

Das Kit kopiert `mergeability.yml` + `pr-review.yml` in `.github/workflows/`,
setzt die Labels (inkl. `ai-review`) und druckt die nächsten Git-Schritte.

## Reihenfolge (Rollout) — ✅ abgeschlossen
1. ✅ **Pilot:** `safe-my-plants` (PR #65, live verifiziert).
2. ✅ **Kern-Batch:** `1x1_Trainer` (#239) → `DrawFromMemory` (#249) → `Pflanzkalender` (#178) → `Epic_Calendar` (#63) → `Eisenhauer` (#312).
3. ✅ **Nachzügler:** `EnergyPriceGermany` (#344) → `CD-to-Spotify-PWA` (#51, Issue #64).
4. ✅ `@v1`-Review-Modell als deprecated markiert (siehe Status-Hinweis oben).

## Branch-Protection (einheitlich)
Das `protect-main`-Ruleset jedes Repos (gilt für `main` **und** `testing`) verlangt
einheitlich genau die zwei Status-Checks, die in allen Repos identisch existieren:
`review-gate` + `mergeability / mergeability` (beide aus dem v2-Modell). Repo-spezifische
Emoji-Checks (`🔍 Code Quality & Linting` etc.) sind **nicht** als Required-Context
gelistet, da GitHub Contexts exakt per Name matcht und die Namen je Repo abweichen –
sie laufen weiter als CI, blockieren den Merge aber nicht. Strenge `Main`-Rulesets
(Approvals/Signaturen) zielen auf `~DEFAULT_BRANCH` (nur `main`), nicht auf `~ALL`.

## Verifikation pro Repo
- [ ] Mergeability-Sticky-Kommentar erscheint am PR und aktualisiert sich bei Push
- [ ] `review-gate` grün bei konfliktfreiem PR, rot bei Konflikt
- [ ] kein automatischer API-Call (kein `pr-review`-Lauf ohne Label `ai-review`)
- [ ] Label `ai-review` triggert beratenden Review, ohne das Gate zu verändern
- [ ] `/review` aus Claude Code postet Findings (Abo, ohne API-Kosten)
