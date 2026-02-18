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

| Function | Trigger | Responsibility |
|:---|:---|:---|
| `calculateSocialImpact` | HTTPS callable | Computes SSH drain for a proposed event before it is saved |
| `onEventCreated` | Firestore `onCreate` | Dispatches FCM invite notification to contacts |
| `onReflectionSubmitted` | Firestore `onCreate` | Updates the `Personality Multiplier` delta if feedback diverges from prediction |
| `onIsolationCheck` | Pub/Sub scheduled (hourly) | Detects prolonged offline/no-event windows and applies homeostatic drain |
| `onSoloRechargeToggled` | Firestore `onUpdate` | Reverses isolation drain and begins restorative accumulation |

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
| **Data Access** | Firestore Security Rules — users can only read/write their own documents and shared event documents |
| **Invite Integrity** | Deep links are signed tokens generated by Cloud Functions; expire after 72 hours |
| **Contact Sync Privacy** | Contacts API data is never stored on server; used only client-side to populate the address book picker |
| **Notifications** | FCM tokens stored per-device; refreshed on each login |

---

## 6. Scalability Notes (Prototype → Production)
- **Firestore** scales horizontally by default; no changes needed for growth.
- **Cloud Functions** can be moved to a custom Node.js/Go server behind Cloud Run if we need custom WebSocket connections (e.g., live typing indicators in Chat).
- **Google Maps API** has per-request costs; cache location classification results in Firestore to reduce calls.
