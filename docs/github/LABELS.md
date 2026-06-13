---
# Standardisierte Labels

Einfaches, einheitliches Label-System für alle Projekte.

---

## Übersicht

Insgesamt **12 Labels** in 4 Kategorien (inkl. PR-Review-/Gate-Labels):

### Type Labels (Was ist das Issue?)

| Label | Farbe | Beschreibung |
|-------|-------|-------------|
| `bug` | 🔴 #d73a4a | Fehler / Bug |
| `feature` | 🟦 #a2eeef | Neues Feature |
| `enhancement` | 🟪 #7057ff | Verbesserung / Erweiterung |
| `docs` | 🔵 #0075ca | Dokumentation |

### Priority Labels (Wie wichtig?)

| Label | Farbe | Beschreibung |
|-------|-------|-------------|
| `priority: high` | 🟠 #d4873e | Wichtig - sollte bald bearbeitet werden |
| `priority: low` | 🟢 #5fde5d | Kann warten |

### Status Labels (Wo steht's?)

| Label | Farbe | Beschreibung |
|-------|-------|-------------|
| `blocked` | ⚫ #3d3d3d | Blockiert - wartet auf etwas |
| `ready-for-implementation` | ✅ #34b13e | Ready - kann angefangen werden |

### PR-Review-/Gate Labels

`ready to merge` / `needs human review` markieren den Review-Stand (manuell oder
durch Tooling). `ai-review` ist ein **Trigger**: an einen PR vergeben, stößt es den
optionalen, metered KI-Review (`pr-review.yml`) an.

| Label | Farbe | Beschreibung |
|-------|-------|-------------|
| `ready to merge` | 🟢 #0e8a16 | Review sauber/aufgelöst — Merge kann manuell erfolgen |
| `needs human review` | 🔴 #d93f0b | Findings brauchen menschliche Entscheidung — bitte prüfen |
| `ai-review` | 🟣 #5319e7 | Optionalen KI-Review (Anthropic API) anstoßen — ⚠️ kostet metered API |

---

## Verwendung

### Für Bug Reports
- Füge `bug` hinzu
- Füge ggf. `priority: high` oder `priority: low` hinzu
- Verwende `blocked` wenn Bug blockiert ist

### Für Feature Requests
- Füge `feature` hinzu
- Füge ggf. `priority: high` oder `priority: low` hinzu
- Füge `ready-for-implementation` hinzu wenn ready

### Für Enhancements
- Füge `enhancement` hinzu
- Füge ggf. `priority: high` oder `priority: low` hinzu
- Füge `ready-for-implementation` hinzu wenn ready

### Für Documentation
- Füge `docs` hinzu
- Füge ggf. `priority: high` oder `priority: low` hinzu

---

## GitHub Default Labels

Diese Standard-Labels werden **gelöscht**, da wir die oben definierten nutzen:

- ❌ `duplicate`
- ❌ `good first issue`
- ❌ `help wanted`
- ❌ `invalid`
- ❌ `question`
- ❌ `wontfix`

---

## Setup Script

Zum Automatisieren der Label-Verwaltung siehe [scripts/setup-labels.sh](scripts/setup-labels.sh)

```bash
# Labels in allen Repos setzen
./scripts/setup-labels.sh S540d/Eisenhauer
./scripts/setup-labels.sh S540d/Energy_Price_Germany
./scripts/setup-labels.sh S540d/1x1_Trainer
```

---

## Beispiele

### Bug mit Priority
```
Labels: bug, priority: high
```

### Feature bereit zur Umsetzung
```
Labels: feature, priority: medium, ready-for-implementation
```

### Dokumentation mit niedriger Priorität
```
Labels: docs, priority: low
```

### Feature blockiert
```
Labels: feature, priority: high, blocked
```

---

## Erweiterung

Falls später mehr Labels nötig sind, immer diesem Format folgen:
- **Type**: `type: [name]` oder nur `[name]` (z.B. `bug`, `feature`)
- **Priority**: `priority: [level]`
- **Status**: `status: [state]` oder nur `[state]` (z.B. `blocked`, `ready-for-implementation`)

---
