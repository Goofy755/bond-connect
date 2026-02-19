# BondConnect: System Design Document (v1.0)
*Last Updated: February 2026*

---

## 1. Overview

This document defines the detailed system design for BondConnect, including the **Firestore database schema**, **API contracts** (Cloud Functions), and **key data models**. It is a companion to [system-architecture.md](system-architecture.md).

---

## 2. Firestore Database Schema

Firestore is a document/collection NoSQL database. All documents use server timestamps (`createdAt`, `updatedAt`).

### 2.1 Collections Overview

```
/users/{userId}
/users/{userId}/relationships/{contactId}
/users/{userId}/sentimentLog/{reflectionId}
/users/{userId}/socialState/current          ← single document
/events/{eventId}
/events/{eventId}/rsvps/{userId}             ← see §2.6 for RSVP document schema
/messages/{threadId}
/messages/{threadId}/messages/{messageId}
/inviteTokens/{token}                        ← see §10 for schema
```

---

### 2.2 `/users/{userId}` — User Profile

```json
{
  "uid": "string",
  "displayName": "string",
  "email": "string",
  "phone": "string | null",
  "city": "string",
  "timezone": "string",            // e.g. "America/Denver"
  "photoUrl": "string | null",
  "appearance": "light | dark",
  "personalityType": "introvert | extrovert | ambivert",
  "personalityMultiplier": 1.3,   // Pm — starts from onboarding, adjusted dynamically
  "weeklyCapacityTarget": 80,     // % (user-defined max before guardrail triggers)
  "socialBarScale": "low | medium | high",
  "soloRechargeActive": false,
  "notificationPreferences": {
    "preferredReminderTime": "17:00",
    "reminderLeadMinutes": 60,
    "quietHoursStart": "21:00",
    "quietHoursEnd": "07:00"
  },
  "calendarLinks": {
    "apple": "boolean",            // native on-device via expo-calendar; no OAuth token stored
    "google": "string | null",     // OAuth token ref
    "calendly": "string | null"
  },
  "socialLinks": ["string"],
  "fcmTokens": ["string"],
  "nextIsolationCheckAt": "timestamp",       // set by onIsolationCheck; enables indexed queries instead of full scans
  "consecutiveDivergenceCount": 0,           // running Pm divergence counter; resets when sentiment matches prediction
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 2.3 `/users/{userId}/relationships/{contactId}` — Relationship CRM

```json
{
  "contactUserId": "string | null",   // populated if contact has BondConnect account
  "name": "string",
  "phone": "string | null",
  "email": "string | null",
  "status": "friend | family | partner | colleague",
  "city": "string",
  "cadence": "weekly | biweekly | monthly",
  "notes": "string",
  "groups": ["string"],
  "goals": {
    "primary": "string",
    "secondary": "string | null"
  },
  "stats": {
    "totalCalls": 0,
    "totalTexts": 0,
    "totalMeetups": 0,
    "totalInvitesSent": 0,
    "totalInvitesReceived": 0,
    "initiationRatioSelf": 0.58,    // % of interactions initiated by this user
    "overallPctOfSocialTime": 0.0,  // share of their social time spent with this user
    "lastContactDate": "timestamp | null"
  },
  "socialBarWithContact": {
    "youToThem": 65,   // % you invest in them
    "themToYou": 58,   // % they invest in you
    "stage": "min | balance | max"
  },
  "sentimentTrend": "energizing | neutral | draining | mixed",
  "topActivities": ["calls", "dinner", "working out"],
  "inviteStatus": "connected | pending | declined",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 2.4 `/users/{userId}/socialState/current` — Live Social Bar State

```json
{
  "dailySluUsed": 4.5,           // Standard Social Load Units consumed today
  "dailyCapacityPct": 72,        // % of daily bar consumed
  "weeklySluUsed": 9.0,
  "weeklyCapacityPct": 70,
  "projectedDailyPct": 85,       // Ghost Bar: projected 4 hours into the future
  "stage": "min | balance | max",
  "isolationDrainActive": false,
  "soloRechargeActive": false,
  "categoryBreakdown": {
    "friend": 30,
    "family": 20,
    "partner": 15,
    "colleague": 25,
    "self": 10
  },
  "lastUpdated": "timestamp"
}
```

---

### 2.5 `/events/{eventId}` — Events

```json
{
  "creatorId": "string",
  "type": "quick_call | deep_connection | group_event | custom",
  "title": "string",
  "description": "string | null",
  "durationMinutes": 60,
  "scheduledAt": "timestamp",
  "location": "string | null",
  "locationCategory": "restorative | neutral | stressful",  // from Maps API or manual
  "rsvpRequired": true,
  "status": "pending | confirmed | rescheduled | cancelled | completed",
  "rescheduleProposal": {
    "proposedBy": "string | null",            // userId of proposer; null when no active proposal
    "proposedAt": "timestamp | null",
    "newScheduledAt": "timestamp | null"
  },
  "impact": {
    "sluCost": 3.0,
    "drainPct": 18,
    "environmentWeight": 1.00,     // Ew multiplier (restorative=0.85, neutral=1.00, stressful=1.15)
    "intensityWeight": 1.20,       // Ii multiplier (quick_call=0.80, deep_connection=1.20, group_event=1.30)
    "connectionBonus": 5           // Cb points subtracted from final drainPct (0 for new/neutral contacts)
  },
  "mode": "phone | in-person | video",
  "sendMethod": "text | email | both",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 2.6 `/events/{eventId}/rsvps/{userId}` — RSVP Records

```json
{
  "userId": "string",
  "status": "pending | accepted | declined | rescheduled",
  "respondedAt": "timestamp | null",
  "createdAt": "timestamp"
}
```

---

### 2.7 `/users/{userId}/sentimentLog/{reflectionId}` — Post-Event Reflections

```json
{
  "eventId": "string",
  "contactId": "string",
  "sentiment": "energizing | neutral | draining | deep",
  "reconnectIntent": "soon | later | pause",
  "reminderNote": "string | null",
  "predictedDrainPct": 18,    // what the algorithm forecast
  "reportedSentiment": "draining",
  "divergence": 1,            // -1 less draining than predicted, 0 as expected, +1 more draining; see user.consecutiveDivergenceCount for running total
  "pmAdjusted": false,        // whether this triggered a Pm nudge
  "createdAt": "timestamp"
}
```

---

### 2.8 `/messages/{threadId}` — Chat Threads

```json
{
  "participantIds": ["userId1", "userId2"],
  "stats": {
    "totalChars": 1240,
    "totalWords": 198,
    "topTopic": "Scheduling / meetups",
    "socialPctExchanged": 8
  },
  "lastMessageAt": "timestamp",
  "createdAt": "timestamp"
}
```

`/messages/{threadId}/messages/{messageId}`:
```json
{
  "senderId": "string",
  "body": "string",
  "sentAt": "timestamp"
}
```

---

## 3. API Contracts (Cloud Functions)

### 3.1 `calculateSocialImpact` — HTTPS Callable

Computes the projected drain for a proposed event **before** it is saved. The client must debounce calls by ~500ms on form change to avoid excessive invocations and race conditions.

**Request:**
```json
{
  "durationMinutes": 60,
  "contactId": "string",
  "scheduledAt": "ISO 8601 timestamp",
  "locationCategory": "restorative | neutral | stressful | null",
  "eventType": "quick_call | deep_connection | group_event"
}
```

**Validation Rules:**
- `durationMinutes`: Required; must be > 0 and ≤ 480 (8 hours)
- `scheduledAt`: Must be in the future; returns `PAST_DATE_ERROR` otherwise
- `contactId`: Required for `quick_call` and `deep_connection`; optional for `group_event`
- `locationCategory`: Must be one of the enum values or `null`

**Response (success):**
```json
{
  "sluCost": 3.0,
  "drainPct": 18,
  "projectedDailyPctAfter": 90,
  "projectedGhostPct": 95,      // Ghost Bar — peak at 4 hours from now
  "guardrailTriggered": true,
  "guardrailMessage": "Near weekly limit ⚠ — consider shortening or rescheduling."
}
```

**Response (error):**
```json
{
  "error": "CALCULATION_FAILED",
  "message": "Unable to compute social impact. Try again."
}
```
Client behavior on error: display "Unable to preview impact" and block the save action.

**Additional error codes:**

| Code | Trigger | Client Behavior |
|:---|:---|:---|
| `CALCULATION_TIMEOUT` | Function exceeds 5s | Show "Preview unavailable — proceed anyway?" (save not blocked) |
| `USER_NOT_FOUND` | User doc missing | Block save; prompt re-login |
| `PAST_DATE_ERROR` | `scheduledAt` in the past | Block save; highlight date field |
| `INVALID_DURATION` | `durationMinutes` ≤ 0 or > 480 | Block save; show validation message |

---

### 3.2 `onEventCreated` — Firestore `events/{eventId}` onCreate

- Queries `/events/{eventId}/rsvps` sub-collection to retrieve all invitee `userId` values.
- Looks up each invitee's `fcmTokens` from their user profile.
- Sends FCM push notification to each invitee (see §3.6 for payload).
- On notification tap → deep link to `bondconnect://inbox?token={inviteToken}`.

---

### 3.3 `onReflectionSubmitted` — Firestore `sentimentLog/{reflectionId}` onCreate

- Compares `predictedDrainPct` vs `sentiment`.
- If `divergence` exceeds threshold (±2 events in a row) → writes a nudge to the user's `notifications` sub-collection.
- If user confirms nudge → adjusts `personalityMultiplier` in `/users/{userId}`.

---

### 3.4 `onIsolationCheck` — Pub/Sub (runs every hour)

- Queries users where `nextIsolationCheckAt ≤ now` (requires a Firestore index on `nextIsolationCheckAt`). This avoids full-collection scans.
- Evaluates the 6-hour threshold in the user's local timezone (`user.timezone`), not UTC.
- If elapsed time since last social event > 6 hours AND no upcoming event in next 2 hours → sets `isolationDrainActive: true` in `socialState/current`.
- Updates `nextIsolationCheckAt` to `now + 1 hour` on the user document after each run.
- Missed runs are non-critical; the next scheduled run catches up.

---

### 3.5 Error Handling

| Function | Error Scenario | Behavior |
|:---|:---|:---|
| `calculateSocialImpact` | Timeout (> 5s) | Return `CALCULATION_TIMEOUT`; client shows "Preview unavailable — proceed anyway?" |
| `calculateSocialImpact` | User not found | Return `USER_NOT_FOUND`; block save |
| `onEventCreated` | FCM delivery fails | Retry 3× with exponential backoff; log failure to Firestore `/errors` collection |
| `onReflectionSubmitted` | Concurrent Pm adjustment | Use Firestore transaction; last write wins; log conflict |
| `onIsolationCheck` | Pub/Sub missed run | Non-critical; next run catches up via `nextIsolationCheckAt` |
| `validateInviteToken` | Token expired | Return `EXPIRED`; client shows expiry message with "Request new invite" CTA |

---

### 3.6 FCM Notification Payloads

**Event Invite** (sent by `onEventCreated`):
```json
{
  "notification": {
    "title": "{senderName} invited you",
    "body": "{eventTitle} — {durationMinutes}min"
  },
  "data": {
    "type": "event_invite",
    "eventId": "string",
    "inviteToken": "string",
    "deepLink": "bondconnect://inbox?token={token}"
  }
}
```

**Contact Request** (sent when a new relationship is created):
```json
{
  "notification": {
    "title": "{senderName} wants to connect",
    "body": "Tap to accept or schedule"
  },
  "data": {
    "type": "contact_request",
    "contactId": "string",
    "deepLink": "bondconnect://contacts?request={contactId}"
  }
}
```

**Pm Nudge** (sent by `onReflectionSubmitted`):
```json
{
  "notification": {
    "title": "Adjust your sensitivity?",
    "body": "It seems you're draining faster than expected."
  },
  "data": {
    "type": "pm_nudge",
    "deepLink": "bondconnect://home?nudge=pm"
  }
}
```

> [!NOTE]
> All notifications respect `user.notificationPreferences.quietHoursStart` / `quietHoursEnd`. Cloud Functions must check the user's local time before dispatching.

---

## 4. State Machine: Event Lifecycle

```
[Draft] → calculateSocialImpact (preview)
        → Error/timeout → show "Unable to preview impact"; save is blocked
        → User confirms
        → [Pending] → all RSVPs notified via FCM
        → RSVP Accepts     → [Confirmed]
        → RSVP Reschedules → [Rescheduled] → rescheduleProposal written to event
                           → Creator accepts new time → [Confirmed]
                           → Creator declines         → [Cancelled]
        → RSVP Declines    → [Cancelled] → creator notified
        → Event time passes → [Completed] → Post-Event Reflection prompt fired
        → Creator cancels (from any state) → [Cancelled] → all RSVPs notified
```

---

## 5. Real-Time Listeners (Client-Side)

| Listener | Collection | Purpose |
|:---|:---|:---|
| Social Bar | `/users/{uid}/socialState/current` | Live-update Home Dashboard |
| Inbox | `/events/{eventId}/rsvps/{uid}` where `status == pending` | Live invite count badge |
| Chat | `/messages/{threadId}/messages` | Real-time message delivery |
| Nudges | `/users/{uid}/notifications` | In-app prompt for Pm adjustment |

---

## 6. Caching Strategy

| Data | Cache Location | TTL |
|:---|:---|:---|
| Location category (Maps API) | Firestore event + local cache | Forever (immutable per place) |
| User `socialState/current` | Firestore (real-time) + Expo state | No TTL — stream |
| Contact stats | Firestore + local Zustand store | 5 min |

---

## 8. Required Firestore Indexes

| Collection | Fields Indexed | Query Purpose |
|:---|:---|:---|
| `/users` | `nextIsolationCheckAt` ASC | `onIsolationCheck` scheduled function |
| `/events` | `status` ASC, `scheduledAt` ASC | Fetch upcoming confirmed events |
| `/events/{eventId}/rsvps` | `userId` ASC, `status` ASC | Find a user's pending RSVPs across events |
| `/users/{userId}/relationships` | `status` ASC, `lastContactDate` DESC | Contact list filtering and sorting |
| `/inviteTokens` | `expiresAt` ASC, `status` ASC | Batch expiry cleanup job |

> [!IMPORTANT]
> Firestore indexes must be created **before** deploying Cloud Functions that use the above queries. Use the `firebase.indexes.json` file to define and deploy indexes via the Firebase CLI.

---

## 9. QR Code Contact Flow

### QR Code Payload (JSON, encoded as a URL-safe string)

```json
{
  "type": "contact_invite",
  "userId": "string",
  "displayName": "string",
  "expiresAt": "ISO 8601 timestamp"  // 7 days from generation
}
```

### Flow

1. **Generate**: User A taps "Show My QR" → app encodes payload → displays QR on screen. Code expires after 7 days.
2. **Scan**: User B scans → app decodes payload → validates `expiresAt` locally.
   - If expired → show "This code has expired. Ask them to generate a new one."
3. **Connect (User B is registered)**: App creates a `relationships` document for User B → sends a `contact_request` FCM notification to User A.
4. **Connect (User B is not registered)**: App stores a pending invite keyed by User B's phone/email → on User B's first login, pending invite is resolved automatically.

---

## 10. Invite Token Schema

### `/inviteTokens/{token}`

Tokens are JWTs signed by a Firebase service account key. Clients have no direct access (see `firestore-security-rules.md`).

```json
{
  "token": "string",             // JWT — also used as the document ID
  "invitedByUserId": "string",
  "targetUserId": "string | null",  // null if contact not yet a BondConnect user
  "eventId": "string",
  "status": "pending | accepted | declined | expired",
  "expiresAt": "timestamp",      // createdAt + 72 hours
  "createdAt": "timestamp"
}
```

Token lifecycle:
- Generated by `onEventCreated` and embedded in the deep link.
- Validated by `validateInviteToken`; returns `EXPIRED` if `expiresAt < now`.
- Set to `accepted` or `declined` when RSVP is submitted; subsequent taps return `INVALID`.
