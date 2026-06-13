# Migration auf v2 – kostenloses Merge-Gate + abo-basierter KI-Review

Ablösung des metered API-Reviews (lief pro PR-Push) durch ein Drei-Schichten-Modell.
Tracking: Issue #62.

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

## Reihenfolge (Rollout)
1. **Pilot:** `safe-my-plants` – 2–3 echte PRs beobachten.
2. **Kern-Batch:** `1x1_Trainer` → `DrawFromMemory` → `Pflanzkalender` → `Epic_Calendar` → `Eisenhauer`.
3. Danach `@v1` als deprecated markieren.

## Verifikation pro Repo
- [ ] Mergeability-Sticky-Kommentar erscheint am PR und aktualisiert sich bei Push
- [ ] `review-gate` grün bei konfliktfreiem PR, rot bei Konflikt
- [ ] kein automatischer API-Call (kein `pr-review`-Lauf ohne Label `ai-review`)
- [ ] Label `ai-review` triggert beratenden Review, ohne das Gate zu verändern
- [ ] `/review` aus Claude Code postet Findings (Abo, ohne API-Kosten)
