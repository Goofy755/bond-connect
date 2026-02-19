# BondConnect: Software Requirements Specification (SRS v1.0)
*Last Updated: February 2026*

---

## 1. Introduction

### 1.1 Purpose
This document defines the functional requirements, non-functional requirements, and user stories for the BondConnect prototype. It is intended as the primary reference for engineering and design teams.

### 1.2 Scope
BondConnect is a mobile application (iOS-first via React Native/Expo) that helps users manage their **social energy** through a homeostatic model ("Social Bar"), a relationship CRM, and a smart event scheduling system.

### 1.3 Definitions

| Term | Definition |
|:---|:---|
| **Social Bar** | A battery metaphor representing a user's current social energy capacity (0–100%) |
| **SSH** | Standard Social Hour — the baseline cost unit; 1 SSH = 20% drain for Pm=1.0 |
| **SLU** | Social Load Unit — accumulated event cost per day/week |
| **Ghost Bar** | A semi-transparent UI overlay projecting the Social Bar **4 hours** into the future (lagged fatigue) |
| **Pm** | Personality Multiplier — scales event drain based on introvert/extrovert/ambivert profile |
| **Isolation Drain** | Automatic homeostatic drain applied when a user has had no social contact for 6+ hours |
| **Solo Recharge** | User-toggled mode indicating intentional solitude; halts Isolation Drain and begins restoration |

---

## 2. User Personas

### Persona 1: Mike (Primary)
- 38-year-old commercial real estate professional
- Married, 3 kids, active social circle
- **Goal**: Protect his limited evening time; stay meaningfully connected without burning out
- **Pain Point**: Over-schedules, then cancels — or under-connects and feels guilt

---

## 3. Functional Requirements

### 3.1 Authentication & Onboarding

| ID | Requirement |
|:---|:---|
| FR-01 | The system shall allow users to create accounts via Email/Password, Apple Sign-In, or Google Sign-In |
| FR-02 | The system shall display an optional tutorial covering the Social Bar, Scheduling, Contacts, Inbox, and Home |
| FR-03 | The system shall allow users to skip the onboarding tutorial |
| FR-04 | The system shall prompt for Notification and Calendar permissions during onboarding |
| FR-05 | Users shall set Quiet Hours, a preferred reminder time, and reminder lead time during onboarding |
| FR-06 | Users shall select their personality type (Introvert / Extrovert / Ambivert) during onboarding, which seeds the initial Personality Multiplier (Pm) |

---

### 3.2 Social Bar

| ID | Requirement |
|:---|:---|
| FR-10 | The app shall compute a real-time Social Bar % for both the current day and the current week |
| FR-11 | The Social Bar shall display three threshold stages: `Min`, `Balance`, and `Max` |
| FR-12 | The app shall display a **Ghost Bar** (semi-transparent overlay) projecting the Social Bar **4 hours** into the future based on confirmed and pending upcoming events |
| FR-13 | When the weekly bar exceeds 80% (configurable), the app shall display a Guardrail message |
| FR-14 | The Home Dashboard shall show a monthly breakdown of Social Bar usage by relationship category (Friend, Family, Partner, Colleague, Self) |

---

### 3.3 Isolation & Recharge

| ID | Requirement |
|:---|:---|
| FR-20 | If a user has had no social event or active Solo Recharge session for 6+ hours, the app shall begin applying **Isolation Drain** to the Social Bar |
| FR-21 | The app shall provide a **Solo Recharge Mode** toggle accessible from the Home Dashboard |
| FR-22 | When Solo Recharge Mode is active, Isolation Drain shall cease and a restorative recovery rate shall be applied |

---

### 3.4 Event Scheduling

| ID | Requirement |
|:---|:---|
| FR-30 | Users shall create three event types: Quick Call (15m or 30m), Deep-Connection (1hr or 2hr+), and Group Event (custom duration) |
| FR-31 | The system shall call `calculateSocialImpact` after a client-side debounce (~500ms) on event form changes and display the projected drain (%) in real-time before saving |
| FR-32 | When a date is set, the system shall show "Impact that day: X% → Day total: Y%" on the creation form |
| FR-33 | The system shall auto-classify the event location using the Google Maps Places API into `restorative`, `neutral`, or `stressful`, applying the Environment Weight (Ew) to the drain calculation |
| FR-34 | Users shall be able to manually override the location classification (e.g., tag as "Nature" or "Quiet Space") |
| FR-35 | The Review & Send screen shall allow sending invites via Text, Email, or Both |
| FR-36 | Events shall be placed in `Pending` status until the invitee responds |

---

### 3.5 Inbox & Invite Management

| ID | Requirement |
|:---|:---|
| FR-40 | The Inbox shall display the user's weekly Social Bar alongside each pending request |
| FR-41 | Each pending request shall display: sender name/status/city, event duration, Social Bar impact %, and when the sender typically responds |
| FR-42 | The user shall be able to Accept, Reschedule, or Decline event invites from the Inbox |
| FR-43 | The Reschedule flow shall display both parties' Social Bars and the impact of each suggested new time slot |
| FR-44 | New contact requests shall show an "Accept / Let's Schedule" or "Decline" option |
| FR-45 | After Accepting or Declining, the user shall be returned to the Contacts tab (open product decision: or remain in Inbox) |

---

### 3.6 Contacts & Relationship CRM

| ID | Requirement |
|:---|:---|
| FR-50 | Users shall be able to add contacts with: Name, Phone, Email (separate fields), Status (Friend/Partner/Family/Colleague), City, Cadence, and Notes |
| FR-51 | Users shall be able to send a contact invite via Text, Email, or Both, using an editable pre-written prompt |
| FR-52 | Users shall be able to add contacts via QR code (scan theirs or show mine) |
| FR-53 | The Contacts list shall be sortable by: All, Friend, Family, Partner, Colleague, Most %, Less %, My Groups |
| FR-54 | Each contact card shall show: Social Bar meter & stage, % you invest vs. % they invest, Overall %, top activities, and connection counts |
| FR-55 | Contact detail shall show: Person Goals for BondConnect, Capacity they can receive this week/next, who initiates most, and event history |
| FR-56 | Users shall be able to create custom contact groups and filter the contacts list by group |

---

### 3.7 Calendar

| ID | Requirement |
|:---|:---|
| FR-60 | The Calendar shall display monthly and weekly Social Bar % used |
| FR-61 | Each upcoming event in the calendar view shall display its % impact on the Social Bar |
| FR-62 | The Calendar shall show a "Most Active Time" breakdown by time-of-day category |
| FR-63 | Users shall be able to link Apple Calendar, Google Calendar, and Calendly from Settings |

---

### 3.8 Chat / Messenger

| ID | Requirement |
|:---|:---|
| FR-70 | The Chat tab shall display the user's current Social Bar and number of contacts reached today |
| FR-71 | Each conversation view shall show: Social % exchanged, when the contact usually chats, total chars/words exchanged, and top topic |
| FR-72 | The Chat list shall support filtering by Most Chat/Message and Least Chat/Message |
| FR-73 | The Chat interface shall include an [Add Event] shortcut to create a new event with that contact |

---

### 3.9 Post-Event Reflection

| ID | Requirement |
|:---|:---|
| FR-80 | After an event is marked complete, the app shall prompt a Post-Event Check-in |
| FR-81 | The Check-in shall ask: How did the connection feel? (Energizing / Neutral / Draining / Deep) and whether to reconnect Soon / Later / Pause |
| FR-82 | The Check-in shall offer an optional text or **voice-to-text** note field |
| FR-83 | Submitted reflections shall feed back into the Social Bar algorithm and the contact's Sentiment Trend |

---

### 3.10 Dynamic Personality Learning

| ID | Requirement |
|:---|:---|
| FR-90 | If a user's reported sentiment consistently deviates from the predicted impact (2+ consecutive events), the app shall display a nudge: "It seems you're draining faster than expected. Adjust sensitivity?" |
| FR-91 | If the user confirms the nudge, the system shall adjust the Personality Multiplier (Pm) by ±0.05. Pm is seeded by personality type (Introvert: 1.4, Ambivert: 1.0, Extrovert: 0.7) and clamped to the range [0.5, 2.0] |

---

### 3.11 Settings

| ID | Requirement |
|:---|:---|
| FR-100 | Users shall be able to set: Profile (name, photo, timezone, location), Appearance (Light/Dark), Account & Security (email/password/phone), Social Bar categories & scale, Calendar links, Social links, Privacy (block/report, data export/delete) |

---

## 4. Non-Functional Requirements

| ID | Category | Requirement |
|:---|:---|:---|
| NFR-01 | **Performance** | `calculateSocialImpact` shall respond in < 500ms at the 95th percentile |
| NFR-02 | **Reliability** | The app shall function offline using Firestore offline persistence; events created offline sync on reconnect |
| NFR-03 | **Security** | All Firestore access controlled via Security Rules; users can only access their own data and shared events |
| NFR-04 | **Privacy** | Native device contacts are never sent to or stored on the server |
| NFR-05 | **UX / Well-Being** | Notifications must respect Quiet Hours. No notifications shall be sent outside user-defined windows |
| NFR-06 | **Aesthetics** | The palette shall use calming tones (deep greens, soft blues). UX copy shall be empathetic and supportive |
| NFR-07 | **Scalability** | The Firestore + Cloud Functions stack shall support growth without re-architecture for the prototype phase |
| NFR-08 | **Accessibility** | Text sizes shall follow OS dynamic type; minimum tappable target size 44×44pt |

---

## 5. Open Product Decisions

| # | Decision | Options | Status |
|:---|:---|:---|:---|
| OPD-01 | Post-Accept/Decline destination | Return to Contacts vs. Remain in Inbox | **Unresolved** |
| OPD-02 | Inbox access pattern | Dedicated bottom tab vs. Home bell icon only | **Unresolved** |
| OPD-03 | Add Contact "Both" | Send to both channels at once vs. one per field | **Unresolved** |
| OPD-04 | "Deep" tooltip in Post-Event | Add helper text vs. assumed contextual clarity | **Recommend: Add tooltip** |

---

## 6. Out of Scope (Prototype v1)

- Multi-language / localization
- Admin / roles management
- Relationship analytics (monthly pattern charts)
- Smart cadence setup wizard
- Android-specific native integrations
