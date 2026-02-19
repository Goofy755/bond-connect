# BOND-12: Firestore Security Rules + Indexes
*Card ID: BOND-12 | Estimated effort: 1 day | Priority: P0 | Role: Backend*

---

## Overview

Harden and deploy the Firestore Security Rules and all required indexes to both Firebase projects. This card closes the open rules from BOND-01 and ensures least-privilege access across all collections before any external testers receive access (Phase 2 distribution).

> [!IMPORTANT]
> This card must be completed **before** distributing any build to external testers. Do not advance to Phase 2 (TestFlight) without confirmed security rules deployed to `bondconnect-staging`.

---

## Dependencies

- **Requires**: BOND-01 (Firebase projects initialized, emulator running)
- **Blocks**: External tester distribution (Phase 2)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Full security rules | [firestore-security-rules.md](../../design/firestore-security-rules.md) | All |
| Required indexes | [system-design.md](../../design/system-design.md) | §8 |
| Deployment order | [deployment.md](../deployment.md) | §4.1, §4.2, §4.6 |
| Known production gaps | [firestore-security-rules.md](../../design/firestore-security-rules.md) | Known Gaps section |

---

## Implementation Tasks

### Firestore Security Rules
- [ ] Copy rules from `firestore-security-rules.md` into `firestore.rules`
- [ ] Implement helper functions: `isAuthenticated()`, `isOwner(userId)`, `isEventParticipant(eventId)`
- [ ] `/users/{userId}`: owner read/write only; `fcmTokens` array not readable by other users
- [ ] `/users/{userId}/relationships/{contactId}`: owner read/write only
- [ ] `/users/{userId}/socialState/current`: owner read only; Cloud Functions write via Admin SDK (bypasses rules)
- [ ] `/users/{userId}/sentimentLog/{reflectionId}`: owner write on create; no update or delete
- [ ] `/events/{eventId}`: creator read/write; participants (RSVP members) read only
- [ ] `/events/{eventId}/rsvps/{userId}`: owner read/write their own RSVP; creator read all
- [ ] `/messages/{threadId}` + `/messages/{threadId}/messages/{messageId}`: participants only
- [ ] `/inviteTokens/{token}`: no client read or write; Cloud Functions only (Admin SDK)

### Firestore Indexes
- [ ] Update `firestore.indexes.json` with all 5 indexes from `system-design.md §8`
- [ ] Deploy indexes: `firebase deploy --only firestore:indexes`
- [ ] Verify each index builds successfully in Firebase Console (status: "Enabled")

### Deployment
- [ ] Deploy rules to `bondconnect-dev`: `firebase deploy --only firestore:rules --project bondconnect-dev`
- [ ] Deploy rules to `bondconnect-staging`: `firebase deploy --only firestore:rules --project bondconnect-staging`
- [ ] Deploy indexes to both projects

---

## Tests

### Emulator Security Rules Tests (using `@firebase/rules-unit-testing`)
- [ ] `/users/{userId}`: authenticated owner can read and write
- [ ] `/users/{userId}`: authenticated non-owner cannot read
- [ ] `/users/{userId}`: unauthenticated user cannot read or write
- [ ] `/events/{eventId}`: creator can read/write
- [ ] `/events/{eventId}`: non-participant authenticated user cannot read
- [ ] `/events/{eventId}/rsvps/{userId}`: invitee can read/write their own RSVP
- [ ] `/events/{eventId}/rsvps/{otherUserId}`: invitee cannot write another user's RSVP
- [ ] `/inviteTokens/{token}`: any authenticated client read → denied
- [ ] `/inviteTokens/{token}`: any authenticated client write → denied

### Index Verification
- [ ] All 5 indexes in Firebase Console show status "Enabled" (not "Building")
- [ ] Run a query that uses each index and confirm no "index required" error in logs

### Manual Verification
- [ ] Deploy rules to staging → a non-authenticated request to Firestore is rejected with PERMISSION_DENIED
- [ ] A user attempting to read another user's profile is rejected

---

## Acceptance Criteria

- [ ] All rules from `firestore-security-rules.md` are deployed to both `bondconnect-dev` and `bondconnect-staging`
- [ ] All 5 required indexes from `system-design.md §8` are deployed and active
- [ ] Emulator rules tests pass for all positive (allowed) and negative (denied) test cases
- [ ] No client can directly read or write `/inviteTokens`
- [ ] Rules are committed to the repo in `firestore.rules`

---

## Out of Scope

- Firebase App Check enforcement (Phase 3 — noted as known gap in `firestore-security-rules.md`)
- Chat message encryption (noted as known gap — plaintext in prototype)
- Data migration rules (no existing data to migrate)
