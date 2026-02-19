# BOND-11: Invite Tokens + Deep Linking + QR Code Flow
*Card ID: BOND-11 | Estimated effort: 2 days | Priority: P1 | Role: Backend*

---

## Overview

Implement the JWT-based invite token system: generate tokens when events are created, store them at `/inviteTokens/{token}`, and validate them via the `validateInviteToken` Cloud Function. Also implement the `bondconnect://` deep link handler and the QR code contact flow (generate + scan).

---

## Dependencies

- **Requires**: BOND-06 (`onEventCreated` embeds token in FCM payload)
- **Blocks**: BOND-07 (Inbox RSVP detail uses token to validate invite)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Invite token schema | [system-design.md](../../design/system-design.md) | §10 |
| `validateInviteToken` spec | [system-architecture.md](../../design/system-architecture.md) | §3.2 (Cloud Functions table) |
| Token error codes | [system-design.md](../../design/system-design.md) | §3.5 |
| Deep link format | [system-design.md](../../design/system-design.md) | §3.6 |
| QR code flow | [system-design.md](../../design/system-design.md) | §9 |
| Service Account Key setup | [deployment.md](../deployment.md) | §3.2 |
| Security rules (inviteTokens) | [firestore-security-rules.md](../../design/firestore-security-rules.md) | `/inviteTokens` rules |

---

## Implementation Tasks

### Token Generation (extend `onEventCreated` from BOND-06)
- [ ] On event creation, generate a JWT signed with the Firebase service account key (`FIREBASE_SERVICE_ACCOUNT_KEY` secret)
- [ ] JWT payload: `{ eventId, invitedByUserId, targetUserId (or null) }`
- [ ] Write token document to `/inviteTokens/{token}` with all fields from `system-design.md §10`
- [ ] Set `expiresAt = createdAt + 72 hours`
- [ ] Embed token in FCM deep link: `bondconnect://inbox?token={token}` (update BOND-06 payload)

### `validateInviteToken` Cloud Function
- [ ] HTTPS callable
- [ ] Input: `{ token: string }`
- [ ] Verify JWT signature using Firebase service account public key
- [ ] Look up `/inviteTokens/{token}` in Firestore
- [ ] If `expiresAt < now` → return `{ error: "EXPIRED" }`
- [ ] If `status != "pending"` → return `{ error: "INVALID" }`
- [ ] If valid → return `{ eventId, invitedByUserId, targetUserId, eventData: {...} }`
- [ ] Do NOT update token status here — only mark as `accepted`/`declined` when RSVP is submitted

### Deep Link Handler (client-side)
- [ ] Register `bondconnect://` URL scheme in `app.json`
- [ ] Use `expo-linking` to listen for incoming deep links
- [ ] On `bondconnect://inbox?token={token}`: call `validateInviteToken` and navigate to RSVP detail
- [ ] Handle `EXPIRED` → show "This invite has expired. Ask them to send a new one."
- [ ] Handle `INVALID` → show "This invite is no longer valid."

### QR Code Contact Flow
- [ ] "Show My QR" screen: generate QR payload `{ type: "contact_invite", userId, displayName, expiresAt: now + 7 days }`
- [ ] Encode payload as URL-safe base64 string and render as QR code (use `react-native-qrcode-svg`)
- [ ] "Scan QR" screen: use device camera via `expo-barcode-scanner` to decode QR
- [ ] Validate `expiresAt` locally — if expired, show error message
- [ ] If User B is registered: create relationship document for User B → send `contact_request` FCM to User A
- [ ] If User B is not registered: store a pending relationship keyed by phone/email → resolve on User B's first login

---

## Tests

### Unit Tests
- [ ] JWT generation: decoded payload matches input `{ eventId, invitedByUserId }`
- [ ] `expiresAt` is exactly 72 hours after `createdAt`
- [ ] QR code expiry: payload with `expiresAt` in the past → local validation rejects immediately
- [ ] QR code payload with future `expiresAt` → validation passes

### Integration Tests (Firestore Emulator)
- [ ] Generate token → `/inviteTokens/{token}` document created with `status: "pending"`
- [ ] `validateInviteToken` with valid token → returns event context
- [ ] `validateInviteToken` with expired token → returns `EXPIRED`
- [ ] `validateInviteToken` with accepted token (`status: "accepted"`) → returns `INVALID`

### Manual Verification
- [ ] Tap FCM notification → app handles `bondconnect://inbox?token=...` deep link correctly
- [ ] QR code is scannable from another device
- [ ] Expired QR code shows correct error message

---

## Acceptance Criteria

- [ ] Invite tokens are generated on event creation and stored at `/inviteTokens/{token}`
- [ ] `validateInviteToken` correctly validates, returns event context, and handles `EXPIRED`/`INVALID`
- [ ] Deep link opens the correct screen with the correct event/invite context
- [ ] QR code flow allows two users to connect without manually finding each other
- [ ] Expired QR codes (> 7 days) are rejected client-side

---

## Out of Scope

- Token revocation endpoint (tokens expire naturally at 72h; revocation is by status update)
- Firebase App Check (BOND-12 / Phase 3)
