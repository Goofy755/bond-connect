# BOND-06: `onEventCreated` Cloud Function + FCM Notifications
*Card ID: BOND-06 | Estimated effort: 2 days | Priority: P0 | Role: Backend*

---

## Overview

Implement the `onEventCreated` Firestore trigger Cloud Function. When a new `/events/{eventId}` document is created, query the RSVP sub-collection to get all invitees, look up their FCM tokens, and send push notifications. Retry up to 3× with exponential backoff on FCM failures. Respect each invitee's quiet hours before dispatching.

---

## Dependencies

- **Requires**: BOND-02 (users have FCM tokens), BOND-05 (events are created with RSVP sub-collection)
- **Blocks**: BOND-07 (Inbox depends on notifications), BOND-11 (invite tokens embedded in deep links)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| `onEventCreated` spec | [system-design.md](../../design/system-design.md) | §3.2 |
| FCM notification payloads | [system-design.md](../../design/system-design.md) | §3.6 |
| Error handling (FCM retry) | [system-design.md](../../design/system-design.md) | §3.5 |
| RSVP sub-collection schema | [system-design.md](../../design/system-design.md) | §2.6 |
| User profile (fcmTokens, notificationPreferences) | [system-design.md](../../design/system-design.md) | §2.2 |
| Failure behavior | [system-architecture.md](../../design/system-architecture.md) | §3.2 (Cloud Functions table) |

---

## Implementation Tasks

### Core Function
- [ ] Trigger: Firestore `onCreate` on `/events/{eventId}`
- [ ] Query `/events/{eventId}/rsvps` sub-collection to get all invitee `userId` values
- [ ] For each invitee, read `/users/{userId}` to get `fcmTokens` and `notificationPreferences`

### Quiet Hours Check
- [ ] Before sending, check if current time (in invitee's `timezone`) falls within `quietHoursStart`–`quietHoursEnd`
- [ ] **MVP simplification**: If in quiet hours, send immediately but mark as a silent notification (user sees it when they open the app, but no sound/vibration). Use FCM `apns.payload.aps.contentAvailable = true` or equivalent.
- [ ] Log the quiet-hour delivery status in the function logs.

### FCM Dispatch
- [ ] Build the "Event Invite" FCM payload per `system-design.md §3.6`
- [ ] Include `inviteToken` in the `data` payload.
  > [!NOTE]
  > For MVP, use `eventId` as the token placeholder. BOND-11 will replace this with JWT tokens.
- [ ] Set deep link: `bondconnect://inbox?token={inviteToken}` (where token is currently the `eventId`)
- [ ] Send to all `fcmTokens` for each invitee using `admin.messaging().sendEachForMulticast()`
- [ ] Remove invalid/stale FCM tokens from `/users/{userId}.fcmTokens` if FCM returns `UNREGISTERED`

### Retry Logic
- [ ] Retry failed sends up to 3× with exponential backoff (100ms, 400ms, 1600ms)
- [ ] After 3 failures, log to Firestore `/errors` collection with `eventId`, `inviteeUserId`, and `timestamp`
- [ ] Do NOT throw — function should not retry the entire trigger on partial FCM failure

### FCM Token Registration (client-side)
- [ ] Ensure `expo-notifications` setup from **BOND-02** is working.
- [ ] Verify that FCM tokens are being correctly appended to `/users/{uid}.fcmTokens` in Firestore.
- [ ] Refresh token logic should be handled as part of the app's core auth/init flow (BOND-02).

---

## Tests

### Unit Tests
- [ ] Quiet hours: `quietHoursStart = "21:00"`, `quietHoursEnd = "07:00"`, current time `22:00` → notification sent as silent (no sound/vibration)
- [ ] Quiet hours: current time `10:00` → notification sent
- [ ] Invalid FCM token returned → token removed from user's `fcmTokens` array
- [ ] Retry logic: mock FCM to fail twice, succeed on third → function completes without error

### Integration Tests (Firestore Emulator)
- [ ] Create `/events/{eventId}` with 2 RSVPs → FCM is called once per invitee (mock FCM in test)
- [ ] One invitee has empty `fcmTokens` → no error thrown, other invitees still notified
- [ ] FCM fails 3× → error logged to `/errors/{autoId}` with correct fields

### Manual Verification
- [ ] Create event on device → invited user receives push notification
- [ ] Tapping notification navigates to `bondconnect://inbox`
- [ ] Notification is received silently (no alert/sound) if device is in quiet hours

---

## Acceptance Criteria

- [ ] `onEventCreated` fires when a new event is created and sends FCM to all RSVP sub-collection members
- [ ] FCM payload matches the spec in `system-design.md §3.6`
- [ ] Failed sends are retried up to 3× and logged if all retries fail
- [ ] Stale FCM tokens are removed from user profiles automatically
- [ ] Quiet hours are respected (delivered as silent notification during quiet window)

---

## Out of Scope

- Invite token generation (BOND-11 — use `eventId` as placeholder for now)
- Contact request notifications (BOND-08)
- Pm nudge notifications (BOND-09)
