# BondConnect: Architecture Review
*Reviewed: February 2026*

---

## Overview

This document captures a pre-implementation architecture review of the three technical documents in this folder (`requirements.md`, `system-architecture.md`, `system-design.md`). Issues are organized by severity, followed by recommendations for missing documentation.

---

## 🔴 Critical Issues

### 1. `calculateSocialImpact` called on every form change — performance & cost risk
- **References**: SRS FR-31, Architecture §3.2, Design §3.1
- **Problem**: Invoking an HTTPS Cloud Function on every keystroke will cause significant Firebase costs, latency spikes that violate NFR-01 (< 500ms), and race conditions from out-of-order responses.
- **Recommendation**: Debounce client-side calls (400–600ms). Evaluate whether the calculation can live client-side, with Cloud Functions only called on final save for authoritative storage.

### 2. No error or failure handling defined
- **References**: All three documents
- **Problem**: All data flows and API contracts cover only the happy path. No specification exists for: `calculateSocialImpact` timeouts, missed `onIsolationCheck` runs, or failed FCM deliveries.
- **Recommendation**: Add error states to the Event State Machine (Design §4) and document retry/fallback behavior for each Cloud Function.

### 3. `[Rescheduled]` state in the state machine has no schema support
- **References**: Design §4 (State Machine), Design §2.5
- **Problem**: The event `status` enum (`pending | confirmed | cancelled | completed`) does not include `rescheduled`. There is also no field to store the proposed new time or the proposing party.
- **Recommendation**: Add `"rescheduled"` to the status enum. Add a `rescheduleProposal: { proposedAt, proposedBy, newScheduledAt }` sub-object to the event document, or use a `/events/{eventId}/rescheduleProposals` sub-collection.

---

## 🟡 Significant Issues

### 4. `onIsolationCheck` will not scale and lacks timezone awareness
- **References**: Design §3.4
- **Problem**: Reading all users where `soloRechargeActive: false` hourly is a full Firestore collection scan. Additionally, "6 hours ago" must be evaluated relative to the user's timezone, not UTC.
- **Recommendation**: Use a composite Firestore index on `(soloRechargeActive, lastEventEndTime)`. Store a `nextIsolationCheckAt` timestamp per user to avoid scanning all users. Apply timezone offset from the user profile when evaluating the threshold.

### 5. `Pm` (Personality Multiplier) algorithm is underdefined
- **References**: SRS FR-90/91, Architecture §3.2, Design §3.3
- **Problem**: The documents state Pm is adjusted "accordingly" on nudge confirmation, but no starting values, step size, or min/max bounds are specified. This will cause implementation ambiguity.
- **Recommendation**: Define the formula explicitly — e.g., starting values (Introvert=1.4, Ambivert=1.0, Extrovert=0.7), adjustment step (±0.05 per confirmed nudge), and clamped range (0.5–2.0).

### 6. `divergence` tracking has no persistent counter
- **References**: Design §2.6, Design §3.3
- **Problem**: The logic requires detecting "2+ consecutive divergent events," but no field tracks a running consecutive count. The function would need to query the last N reflections on every submission — expensive and race-condition-prone.
- **Recommendation**: Add a `consecutiveDivergenceCount` field to the user profile or `socialState/current` document, updated atomically by the Cloud Function.

### 7. Deep link signing mechanism is mentioned but not designed
- **References**: Architecture §5
- **Problem**: "Signed tokens; expire after 72 hours" — no token structure, signing algorithm, storage location, or revocation mechanism is defined. The validation flow for expired tokens is also missing.
- **Recommendation**: Define the token structure (e.g., JWT signed with a Firebase service account key), storage at `/inviteTokens/{token}` with a TTL field, and a validation Cloud Function.

---

## 🟠 Minor Issues

### 8. `calendarLinks.apple` typed as `boolean` — intent unclear
- **References**: Design §2.2
- **Problem**: Google and Calendly store OAuth token refs (strings), but Apple is a `boolean`. Apple Calendar is a native on-device integration via `expo-calendar` — no OAuth token exists — but this is not documented, risking implementers building an unnecessary OAuth flow.
- **Recommendation**: Add an inline comment: `// native on-device via expo-calendar; no OAuth token stored`.

### 9. `rsvps` sub-collection and `invitees` array are redundant and can go out of sync
- **References**: Design §2.1, Design §2.5
- **Problem**: The schema overview lists `/events/{eventId}/rsvps/{userId}` but the event document also has `invitees: [userId]`. These can diverge, and the `rsvps` sub-collection has no defined document schema.
- **Recommendation**: Choose one pattern. The `rsvps` sub-collection is more scalable for group events — if chosen, define its document schema and remove the `invitees` array.

### 10. Chat messages stored as plaintext with no content moderation mention
- **References**: Architecture §5, SRS §3.8
- **Problem**: No mention of encryption at rest, moderation, or abuse reporting — even for a prototype with real users.
- **Recommendation**: Add a note to the security model: *"Messages are plaintext for prototype; encrypt at rest and add moderation pipeline before production launch."*

---

## 📄 Missing Documentation

| Document | Why It's Needed |
|:---|:---|
| **Social Bar Algorithm Spec** | The formula components (`SSH`, `SLU`, `Pm`, `Ew`, `Ii`, `Cb`) are referenced throughout all docs but never defined mathematically. Implementers will invent their own formula. |
| **Firestore Security Rules** | Mentioned in architecture but never drafted. This is the most common source of Firebase data breaches and must be written before any backend work begins. |
| **Push Notification Payload Spec** | FCM is triggered by multiple functions but no payload schemas, categories, or UX timing rules are defined beyond "respect Quiet Hours." |
| **UI/Screen Flow Doc** | OPD-01 through OPD-04 are unresolved and block frontend implementation. A screen flow diagram or annotated wireframe set would resolve these decisions. |
| **Offline Conflict Resolution Strategy** | NFR-02 requires offline support, but no conflict resolution protocol is defined for events created on multiple devices before sync. |
| **QR Code Contact Flow** | FR-52 mentions QR code contact adding but no design exists for what data is encoded, how codes are generated, or how they are consumed on the receiving side. |

---

## Pre-Implementation Priorities

Before any implementation begins, the following must be resolved:

1. **Define the Social Bar algorithm** in a dedicated spec — every Cloud Function depends on it.
2. **Fix the `rescheduled` state gap** in the event schema before the event model is built.
3. **Draft Firestore Security Rules** — building on Firebase without them is a day-one security liability.
4. **Decide on `calculateSocialImpact` placement** (client-side vs. server-side with debounce) — this decision affects the entire event creation architecture.
