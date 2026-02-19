# BondConnect: Social Bar Algorithm Specification (v1.0)
*Last Updated: February 2026*

---

## 1. Overview

The Social Bar is a homeostatic energy model representing a user's current social capacity (0–100%). It drains when events occur and recovers during rest or intentional solitude. This document defines the complete mathematical specification for all Social Bar calculations.

---

## 2. Components

| Symbol | Name | Description |
|:---|:---|:---|
| **SSH** | Standard Social Hour | Baseline drain unit; 1 SSH = 20% drain for a 1-hour event at Pm=1.0 |
| **SLU** | Social Load Unit | Accumulated raw event cost (in SSH) for a day or week |
| **Pm** | Personality Multiplier | Scales overall drain based on introvert/extrovert profile |
| **Ew** | Environment Weight | Modifier based on event location type |
| **Ii** | Intensity Index | Modifier based on event type |
| **Cb** | Connection Bonus | Drain reduction for close, positive-sentiment relationships |

---

## 3. Drain Formula

### 3.1 Per-Event Drain

```
drainPct = (SSH_base × durationFactor × Pm × Ew × Ii) − Cb
```

Where:
- `SSH_base = 20` (% drain per Standard Social Hour at Pm=1.0)
- `durationFactor = durationMinutes / 60`
- `Pm` — see §4
- `Ew` — see §5
- `Ii` — see §6
- `Cb` — see §7

### 3.2 Social Load Units (SLU)

SLU represents the raw, unweighted cost of events (before personality scaling):

```
sluCost = SSH_base × durationFactor
```

SLU is accumulated across events in a day/week and stored in `socialState/current`.

---

## 4. Personality Multiplier (Pm)

### 4.1 Seed Values (set during onboarding)

| Personality Type | Initial Pm |
|:---|:---|
| Introvert | 1.4 |
| Ambivert | 1.0 |
| Extrovert | 0.7 |

### 4.2 Dynamic Adjustment

- Triggered when `user.consecutiveDivergenceCount ≥ 2` (two consecutive events where reported sentiment diverges from predicted drain).
- Adjustment step: **±0.05** per user-confirmed nudge.
  - If draining faster than predicted → Pm increases by 0.05.
  - If draining slower than predicted → Pm decreases by 0.05.
- Clamped range: **[0.5, 2.0]**
- `consecutiveDivergenceCount` resets to 0 after each adjustment or when a sentiment matches the prediction.

---

## 5. Environment Weight (Ew)

Determined by the Google Maps Places API auto-classification, or by manual user tag override.

| Location Category | Ew |
|:---|:---|
| `restorative` (nature, quiet space, home) | 0.85 |
| `neutral` (office, restaurant, generic) | 1.00 |
| `stressful` (crowded venue, commute, unfamiliar) | 1.15 |

> [!NOTE]
> Ew is stored in the event document as a multiplier (e.g., `0.85`), not as a percentage offset. See `system-design.md` §2.5 `impact.environmentWeight`.

---

## 6. Intensity Index (Ii)

Determined by the event type selected during creation.

| Event Type | Ii |
|:---|:---|
| `quick_call` (15–30 min) | 0.80 |
| `deep_connection` (1–2 hr) | 1.20 |
| `group_event` (custom) | 1.30 |

---

## 7. Connection Bonus (Cb)

A drain reduction applied when the relationship context is positive and close. Prevents high-drain calculations from penalizing strong relationships.

**Default for new or unknown contacts**: If `sentimentTrend` is `null` or missing, treat as `neutral` (Cb = 0). New relationship documents are initialized with `sentimentTrend: "neutral"`.

| Condition | Cb |
|:---|:---|
| `sentimentTrend == "energizing"` AND `socialBarWithContact.stage == "balance"` | 5 |
| `sentimentTrend == "energizing"` only | 3 |
| `sentimentTrend == "neutral"` | 0 |
| `sentimentTrend == "draining"` | 0 (no bonus) |

Cb is subtracted after all other factors are applied. `drainPct` is floored at 0.

---

## 8. Isolation Drain

Applied automatically when the user has had no social event for 6+ consecutive hours and `soloRechargeActive = false`.

- **Rate**: 2% per hour (at Pm=1.0; scaled by Pm for introverts/extroverts, but capped to avoid runaway drain)
- **Onset**: `lastEventEndTime > 6 hours ago` in the user's local timezone
- **Stops when**: a new event is logged OR `soloRechargeActive` is toggled ON

---

## 9. Solo Recharge Recovery

Applied when `soloRechargeActive = true`.

- **Rate**: +3% per hour
- **Cap**: Will not push `weeklyCapacityPct` above the user's `weeklyCapacityTarget`
- **Stops when**: `soloRechargeActive` is toggled OFF or a new event is created

---

### 10. Ghost Bar Projection

The Ghost Bar projects the Social Bar **4 hours** into the future and is displayed as a semi-transparent overlay.

**Projection logic:**
1. Start from `socialState/current.dailyCapacityPct`.
2. Sum the drain from **all** `confirmed` or `pending` events with `scheduledAt` within the next **4 hours** (use the per-event `drainPct` stored in `impact.drainPct`).
3. Add any isolation drain that would accumulate in the same window, if `soloRechargeActive = false` (2% × hours elapsed without social contact).
4. **Do not** account for Solo Recharge recovery in the projection — Ghost Bar is a drain-only projection.
5. The result is `projectedGhostPct`, returned by `calculateSocialImpact` and stored in `socialState/current.projectedDailyPct`.

> [!NOTE]
> If two events overlap within the 4-hour window, sum their drain percentages. There is no overlap deduplication in the prototype.

---

## 11. Worked Example

**Scenario:** Mike (Ambivert, Pm=1.0) schedules a 1-hour dinner at a restaurant with a close friend (sentimentTrend=energizing, stage=balance).

```
durationFactor  = 60 / 60 = 1.0
SSH_base        = 20
Ew              = 1.00  (restaurant → neutral)
Ii              = 1.20  (deep_connection)
Cb              = 5     (energizing + balance)

drainPct = (20 × 1.0 × 1.0 × 1.00 × 1.20) − 5
         = 24 − 5
         = 19%
```
