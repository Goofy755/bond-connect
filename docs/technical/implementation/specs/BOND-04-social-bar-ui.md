# BOND-04: Social Bar UI — Home Dashboard
*Card ID: BOND-04 | Estimated effort: 2 days | Priority: P0 | Role: Frontend*

---

## Overview

Build the Home Dashboard screen showing the user's live Social Bar (daily and weekly), Ghost Bar projection overlay, stage indicators (Min / Balance / Max), and the category breakdown chart. The Social Bar updates in real time via a Firestore listener on `/users/{uid}/socialState/current`.

---

## Dependencies

- **Requires**: BOND-03 (socialState/current must be writable by the Cloud Function)
- **Blocks**: BOND-05 (event creation screen is launched from Home)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Live Social Bar State schema | [system-design.md](../../design/system-design.md) | §2.4 |
| Real-time listener | [system-design.md](../../design/system-design.md) | §5 |
| Ghost Bar definition | [requirements.md](../../design/requirements.md) | FR-12 |
| Stage thresholds | [requirements.md](../../design/requirements.md) | FR-11 |
| Guardrail threshold | [requirements.md](../../design/requirements.md) | FR-13 |
| Ghost Bar projection logic | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §10 |

---

## Implementation Tasks

### Real-Time Data
- [ ] Subscribe to Firestore listener on `/users/{uid}/socialState/current` using `onSnapshot`
- [ ] Unsubscribe on component unmount to prevent memory leaks
- [ ] Update Zustand store with live `socialState` data

### Social Bar Component
- [ ] Daily bar: horizontal progress bar showing `dailyCapacityPct` (0–100%)
- [ ] Weekly bar: horizontal progress bar showing `weeklyCapacityPct`
- [ ] Ghost Bar: semi-transparent overlay on the daily bar showing `projectedDailyPct` (4 hours ahead)
- [ ] Stage label: display `stage` value as text ("Min" / "Balance" / "Max") with matching color
- [ ] Guardrail banner: show warning banner if `weeklyCapacityPct` exceeds `user.weeklyCapacityTarget`

### Category Breakdown
- [ ] Pie or horizontal bar chart showing `categoryBreakdown` (Friend, Family, Partner, Colleague, Self)
- [ ] Values displayed as percentages

### Isolation Drain Indicator
- [ ] If `isolationDrainActive: true`, show a subtle indicator on the bar (e.g., animated pulse or icon)

### Solo Recharge Toggle
- [ ] Toggle button: "Solo Recharge" — on tap, writes `soloRechargeActive: !current` to `socialState/current`

---

## Tests

### Unit Tests
- [ ] Given `dailyCapacityPct = 75`, Social Bar renders at 75% width
- [ ] Given `stage = "max"`, correct color and label are shown
- [ ] Given `projectedDailyPct = 95`, Ghost Bar overlay renders at 95%
- [ ] Ghost Bar is never shown below `dailyCapacityPct` (projection is always ≥ current)
- [ ] Guardrail banner renders when `weeklyCapacityPct > weeklyCapacityTarget`

### Integration Tests (Firestore Emulator)
- [ ] Write to `socialState/current` → screen updates within 500ms via `onSnapshot`
- [ ] Unsubscribe on unmount — write to Firestore after unmount does NOT update component state

### Manual Verification
- [ ] Social Bar visually animates smoothly when value changes
- [ ] Ghost Bar overlay is visually distinct from the main bar (opacity/color difference)
- [ ] Category breakdown is readable at all screen sizes

---

## Acceptance Criteria

- [ ] Home Dashboard shows live Social Bar (daily + weekly) from Firestore
- [ ] Ghost Bar overlay is displayed and clearly distinct from the main bar
- [ ] Stage label correctly reflects the current stage from `socialState/current`
- [ ] Guardrail banner appears when weekly capacity exceeds the user's target
- [ ] Category breakdown chart is displayed and updates in real time
- [ ] Solo Recharge toggle writes to Firestore correctly

---

## Out of Scope

- Monthly breakdown chart (Phase 2)
- Notifications badge (BOND-06, BOND-07)
- Navigation to other tabs (included in the tab shell, not this card)
