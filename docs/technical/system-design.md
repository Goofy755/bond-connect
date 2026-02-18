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
/events/{eventId}/rsvps/{userId}
/messages/{threadId}
/messages/{threadId}/messages/{messageId}
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
    "apple": "boolean",
    "google": "string | null",     // OAuth token ref
    "calendly": "string | null"
  },
  "socialLinks": ["string"],
  "fcmTokens": ["string"],
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
  "projectedDailyPct": 85,       // Ghost Bar: projected in 2-4 hours
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
  "status": "pending | confirmed | cancelled | completed",
  "invitees": ["userId"],
  "impact": {
    "sluCost": 3.0,
    "drainPct": 18,
    "environmentWeight": -15,      // Ew
    "intensityWeight": 10,         // Ii
    "connectionBonus": -5          // Cb
  },
  "mode": "phone | in-person | video",
  "sendMethod": "text | email | both",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 2.6 `/users/{userId}/sentimentLog/{reflectionId}` — Post-Event Reflections

```json
{
  "eventId": "string",
  "contactId": "string",
  "sentiment": "energizing | neutral | draining | deep",
  "reconnectIntent": "soon | later | pause",
  "reminderNote": "string | null",
  "predictedDrainPct": 18,    // what the algorithm forecast
  "reportedSentiment": "draining",
  "divergence": 1,            // -1 less draining than predicted, +1 more draining
  "pmAdjusted": false,        // whether this triggered a Pm nudge
  "createdAt": "timestamp"
}
```

---

### 2.7 `/messages/{threadId}` — Chat Threads

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

Computes the projected drain for a proposed event **before** it is saved.

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

**Response:**
```json
{
  "sluCost": 3.0,
  "drainPct": 18,
  "projectedDailyPctAfter": 90,
  "projectedGhostPct": 95,      // Ghost Bar — peak lag in 2-4 hrs
  "guardrailTriggered": true,
  "guardrailMessage": "Near weekly limit ⚠ — consider shortening or rescheduling."
}
```

---

### 3.2 `onEventCreated` — Firestore `events/{eventId}` onCreate

- Sends FCM push notifications to all `invitees`.
- On each invitee's notification tap → deep link to `/inbox`.

---

### 3.3 `onReflectionSubmitted` — Firestore `sentimentLog/{reflectionId}` onCreate

- Compares `predictedDrainPct` vs `sentiment`.
- If `divergence` exceeds threshold (±2 events in a row) → writes a nudge to the user's `notifications` sub-collection.
- If user confirms nudge → adjusts `personalityMultiplier` in `/users/{userId}`.

---

### 3.4 `onIsolationCheck` — Pub/Sub (runs every hour)

- Reads users with `soloRechargeActive: false`.
- If `lastEventEndTime` > 6 hours ago AND no upcoming event in next 2 hours → increments `isolationDrainActive` counter.
- Writes updated `socialState/current` with `isolationDrainActive: true`.

---

## 4. State Machine: Event Lifecycle

```
[Draft] → calculateSocialImpact (preview)
        → User confirms
        → [Pending] → invitees notified
        → Invitee Accepts  → [Confirmed]
        → Invitee Reschedules → [Rescheduled] → back to Pending for original creator
        → Invitee Declines → [Declined] → creator notified
        → Event time passes → [Completed] → Post-Event Reflection prompt fired
```

---

## 5. Real-Time Listeners (Client-Side)

| Listener | Collection | Purpose |
|:---|:---|:---|
| Social Bar | `/users/{uid}/socialState/current` | Live-update Home Dashboard |
| Inbox | `/events` where `invitees` contains `uid` and `status == pending` | Live invite count badge |
| Chat | `/messages/{threadId}/messages` | Real-time message delivery |
| Nudges | `/users/{uid}/notifications` | In-app prompt for Pm adjustment |

---

## 6. Caching Strategy

| Data | Cache Location | TTL |
|:---|:---|:---|
| Location category (Maps API) | Firestore event + local cache | Forever (immutable per place) |
| User `socialState/current` | Firestore (real-time) + Expo state | No TTL — stream |
| Contact stats | Firestore + local Zustand store | 5 min |
