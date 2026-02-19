# BondConnect: System Architecture Document (v1.0)
*Last Updated: February 2026*

---

## 1. Overview

BondConnect is a mobile-first, relationship management application built around **Social Energy Homeostasis** — the idea that both too much *and* too little social contact is draining. This document defines the high-level system architecture for the prototype.

---

## 2. Architectural Style

BondConnect uses a **Client-Serverless** architecture, leveraging Firebase as a managed real-time backend. This eliminates the need to manage infrastructure during the prototype phase while providing production-grade scalability.

```
 ┌─────────────────────────────────────────────────┐
 │              React Native (Expo)                │
 │   Home · Contacts · Calendar · Chat · Events   │
 └────────────────────┬────────────────────────────┘
                      │  HTTPS / WebSocket (Firestore SDK)
 ┌────────────────────▼────────────────────────────┐
 │              Firebase Platform                  │
 │  ┌──────────────┐  ┌──────────────────────────┐ │
 │  │  Firestore   │  │   Cloud Functions (Node) │ │
 │  │  (Realtime   │  │  - Social Bar Calculator │ │
 │  │   Database)  │  │  - Invite Trigger        │ │
 │  │              │  │  - Notification Dispatch │ │
 │  └──────────────┘  └──────────────────────────┘ │
 │  ┌──────────────┐  ┌──────────────────────────┐ │
 │  │  Auth        │  │  Cloud Messaging (FCM)   │ │
 │  │  (Email/SSO) │  │  (Push Notifications)    │ │
 │  └──────────────┘  └──────────────────────────┘ │
 └────────────────────┬────────────────────────────┘
                      │
 ┌────────────────────▼────────────────────────────┐
 │              External Services                  │
 │  ┌──────────────────────────────────────────┐   │
 │  │  Google Maps Places API                  │   │
 │  │  (Environment Weight auto-detection)     │   │
 │  └──────────────────────────────────────────┘   │
 └─────────────────────────────────────────────────┘
```

---

## 3. Component Breakdown

### 3.1 Frontend — React Native (Expo)

| Module | Screens | Key Dependencies |
|:---|:---|:---|
| **Auth** | Splash, Sign Up, Log In | `expo-auth-session`, Firebase Auth SDK |
| **Onboarding** | Tutorial, Permissions, Personality setup | `expo-notifications`, `expo-calendar` |
| **Home / Dashboard** | Social Bar, Ghost Bar, Nudges | Custom `SocialBarWidget` component |
| **Contacts** | Contacts list, Contact detail (CRM) | `expo-contacts` |
| **Calendar / Events** | Month view, Event creation flows | `expo-calendar` |
| **Inbox** | Invite management, Accept/Reschedule/Decline | Firestore real-time listener |
| **Chat** | Messaging with social metrics | Firestore message collections |
| **Settings** | Profile, Preferences, Social Bar scale | Firebase Auth + Firestore |

### 3.2 Backend — Firebase Cloud Functions

| Function | Trigger | Responsibility | Failure Behavior |
|:---|:---|:---|:---|
| `calculateSocialImpact` | HTTPS callable (client debounces ~500ms) | Computes SSH drain for a proposed event before it is saved | Returns error payload; client shows "Unable to preview impact" and blocks save |
| `onEventCreated` | Firestore `onCreate` | Dispatches FCM invite notification to contacts | FCM retry up to 3×; falls back to in-app Inbox badge |
| `onReflectionSubmitted` | Firestore `onCreate` | Updates the `Personality Multiplier` delta if feedback diverges from prediction | Logs failure; does not retry to prevent double Pm adjustment |
| `onIsolationCheck` | Pub/Sub scheduled (hourly) | Detects prolonged offline/no-event windows and applies homeostatic drain | Missed runs are non-critical; next scheduled run catches up via `nextIsolationCheckAt` |
| `onSoloRechargeToggled` | Firestore `onUpdate` | Reverses isolation drain and begins restorative accumulation | Retries on failure; write is idempotent |
| `validateInviteToken` | HTTPS callable | Validates signed deep-link invite tokens; returns event + sender context | Returns `EXPIRED` or `INVALID` error code; client shows appropriate message |

> [!NOTE]
> **Timezone & DST handling for `onIsolationCheck`**: All Firestore timestamps are stored as UTC. Timezone conversion uses the **`luxon`** library (`DateTime.fromISO(utcTime, { zone: user.timezone })`). DST transitions are handled automatically by `luxon` — no manual offset adjustment needed. If a user changes their `timezone` setting, `nextIsolationCheckAt` is recalculated on next login.

### 3.3 Database — Cloud Firestore

See [system-design.md](system-design.md) for the full schema.

### 3.4 External Services

| Service | Purpose | Fallback |
|:---|:---|:---|
| **Google Maps Places API** | Auto-classify event location into `Restorative` or `Stressful` environment bucket | Manual tag by user during event creation |
| **Firebase Cloud Messaging** | Push notifications for invites, reminders, nudges | In-app Inbox |

---

## 4. Data Flow: Key Scenarios

### 4.1 Creating an Event (Real-Time Impact Preview)
```
User fills event form
        │
        ▼
App calls `calculateSocialImpact` (Cloud Function)
        │
        ▼
Function fetches user's Pm, current SLU level, Ew (Maps API or manual), Ii
        │
        ▼
Returns projected drain % + Ghost Bar projection (next 4 hours)
        │
        ▼
User sees live impact on Social Bar BEFORE saving
        │
        ▼
User confirms → Event saved to Firestore → `onEventCreated` fires → FCM invite sent
```

### 4.2 Post-Event Reflection (Algorithm Update)
```
Event time passes → App prompts user (Post-Event Check-in)
        │
        ▼
User submits: Energizing / Neutral / Draining / Deep
        │
        ▼
`onReflectionSubmitted` Cloud Function fires
        │
        ▼
Compares predicted drain vs reported feeling
        │
        ▼
If divergence threshold exceeded → nudges Pm adjustment
        │
        ▼
Updated Pm stored in user profile → Future calculations use new value
```

---

## 5. Security Model

| Concern | Solution |
|:---|:---|
| **Auth** | Firebase Auth (Email + Apple/Google SSO) |
| **Data Access** | Firestore Security Rules — users can only read/write their own documents and shared event documents (see `firestore-security-rules.md`) |
| **Invite Integrity** | Deep links are JWT tokens signed by a Firebase service account key. Stored at `/inviteTokens/{token}` with a TTL field. Expire after 72 hours; invalidated on accept/decline. Validated by `validateInviteToken` Cloud Function. |
| **Contact Sync Privacy** | Contacts API data is never stored on server; used only client-side to populate the address book picker |
| **Notifications** | FCM tokens stored per-device; refreshed on each login |
| **Apple Calendar** | Integrated natively via `expo-calendar` on-device; no OAuth token is stored server-side |
| **Chat Messages** | Stored as plaintext in Firestore for the prototype. Known gap — encrypt at rest and add moderation pipeline before production launch. |

---

## 7. Testing Strategy

| Layer | Approach | Key Scenarios |
|:---|:---|:---|
| **Algorithm (Unit)** | Jest unit tests with known inputs/outputs | Drain formula (all Pm/Ew/Ii/Cb combinations), Ghost Bar projection, isolation drain accumulation, Pm nudge boundary conditions |
| **Cloud Functions (Integration)** | Firebase Emulator Suite (`firebase emulators:start`) | `calculateSocialImpact` with valid/invalid inputs, `onEventCreated` FCM dispatch, `onReflectionSubmitted` Pm update, `onIsolationCheck` scan and write |
| **E2E (Critical Flows)** | Detox or manual on device | (1) Create event → accept invite → verify Social Bar updates; (2) submit post-event reflection → verify nudge appears; (3) scan QR code → verify contact created |

> [!NOTE]
> Integration tests must run against the Firestore Emulator — never against the production project. Set `FIRESTORE_EMULATOR_HOST` in the test environment.

---

## 6. Scalability Notes (Prototype → Production)
- **Firestore** scales horizontally by default; no changes needed for growth.
- **Cloud Functions** can be moved to a custom Node.js/Go server behind Cloud Run if we need custom WebSocket connections (e.g., live typing indicators in Chat).
- **Google Maps API** has per-request costs; cache location classification results in Firestore to reduce calls.
