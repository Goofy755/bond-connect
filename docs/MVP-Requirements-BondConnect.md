# BondConnect — Minimum Viable Product (MVP) Requirements

**Version:** 1.0  
**Status:** Draft  
**Source:** BondConnect Wireframes v0.1, User Journey Map, Gap Analysis  
**Last updated:** 2026-02-10  

This document defines the minimum set of features, user flows, and technical requirements to deliver a testable MVP aligned with the design. It follows industry-standard practices: scope reduction, clear acceptance criteria, phased implementation, and explicit out-of-scope.

---

## 1. Product Overview & MVP Scope

### 1.1 Product vision (summary)

BondConnect helps users protect their time and stay close to people that matter by:
- **Social Bar:** A simple representation of social energy (today / week) with stages (Min / Balance / Max).
- **Scheduling:** Create 1:1 calls (Quick Call, Deep-Connection) or events; send invites by text/email; track Pending/Accepted/Declined.
- **Inbox:** Single place for event invites and contact requests; Accept / Reschedule / Decline with context (social bar impact, when sender checks inbox).
- **Reflection:** Post-event check-in (Energizing / Neutral / Draining / Deep) to close the loop and inform the Social Bar.

### 1.2 MVP scope statement

**In scope for MVP:**
- Account creation, login, and optional onboarding (tutorial skip, permissions).
- Home dashboard with Social Bar (today + week, stages), basic monthly breakdown, and entry points to Calendar and Inbox.
- Contacts list with relationship status; Add Contact (name, phone, email, status, city, cadence; send invite by text/email/both).
- Single Calendar/Events view with [+ Add] → Event Type Picker → Create 1:1 **Quick Call** or **Deep-Connection** (no Group Event in MVP).
- Review & Send flow; Pending/Sent confirmation; invite delivery by SMS/email (or in-app only for MVP if needed).
- Inbox: list of pending event invites and new contact requests; per-request social bar impact; Accept / Reschedule / Decline; new contact: Accept / Let's schedule or Decline; user stays in Inbox after action.
- Event Detail (invitee view); Respond (Confirm Accept, Send Decline with optional note); Reschedule flow (both parties’ social bar, suggested times or pick new time, send proposal).
- Post-Event Check-in: feeling (Energizing, Neutral, Draining, Deep), reconnect preference (Soon/Later/Pause), optional reminder and note, Track.
- **Wheel selector (quick-selection UI):** Circular wheel picker for high-frequency choices so users can pick an option in **under 3 seconds**. Used in: reflection (feeling, reconnect), invite response (Accept/Reschedule/Decline; new contact Accept/Decline), and event creation (event type, duration, send channel). Reduces taps and speeds up reflection, invite, and create flows.
- Settings: Profile (name, photo, timezone, location), Appearance (light/dark), Account (email, password, phone), basic notification preferences (optional: quiet hours, reminder lead time). Social bar categories and scale can be simplified (e.g. fixed weights).
- Support: minimal (e.g. Help/Tutorials entry point and static or linked content; no in-app video required for MVP if costly).

**Out of scope for MVP (post-MVP):**
- Group Event creation and RSVP/group chat behavior.
- Full in-app Chat/Messenger (or deliver as read-only or placeholder with “Add Event” only).
- QR add contact (scan / show my QR).
- Contact Detail: person goals, capacity this/next week, who engages most, full history (MVP can show basic contact info + event history only).
- Create group / filter by group (Contacts).
- Calendar sync (Apple/Google/Calendly).
- Settings: social bar sliders per category, scale/sensitivity, weekly capacity target, other social links, privacy (block/report, data export/delete) — can be phased.
- Reconnect/suggested contacts (auto request).
- Deep linking from SMS/email to app or app store (can be MVP if low effort; otherwise phase 2).

---

## 2. Core Features & Acceptance Criteria

### 2.1 Authentication & onboarding

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| A1 | Splash / deep link | Landing for invite links; if app installed open app, else link to app store. | User can open app from invite link; if not installed, redirect to store. MVP may defer deep link. |
| A2 | Sign up / Log in | Create account (email or phone + password); log in. | User can register and log in; session persists. |
| A3 | SSO (optional) | Continue with Apple / Google. | Optional for MVP; include if low effort. |
| A4 | Onboarding tutorial | Short intro; skip option. | User can skip or complete; tutorial covers Social Bar, scheduling, Contacts, Inbox (content as per wireframe). |
| A5 | Permissions | Notifications (allow/not now); optional “when to notify” (preferred time, quiet hours, remind before event: 15 min / 1 hr / 1 day); optional calendar access. | User can grant/deny notifications; if granted, optional preference screen; calendar connect optional. |

### 2.2 Home dashboard

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| H1 | Social Bar today | Meter + % + stage (Min / Balance / Max). | Displayed; value derived from simple model (e.g. event count + check-ins). |
| H2 | Weekly capacity | Weekly social bar % and stage. | Displayed; consistent with Social Bar model. |
| H3 | Monthly breakdown | % by category (Colleagues, Family, Partner, Friends, Self). | Displayed; categories from contact relationship status. |
| H4 | Quick check-in | Optional “How full is your social energy today?” (Low/Medium/High). | Optional for MVP; can update today’s bar. |
| H5 | Suggested actions | At least one entry point to create (Quick Call / Event) and to Inbox. | [Create] and bell → Inbox; “Reconnect” or similar optional. |
| H6 | This month summary | Connected / Pending / Overdue counts. | Counts displayed. |
| H7 | Navigation | Tabs: Home, Inbox, Contacts, Calendar, Events (Calendar and Events same view). | All tabs accessible; Inbox has badge for pending count. |

### 2.3 Contacts & Add Contact

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| C1 | Contacts list | List of contacts with name, location, relationship status (Friend, Family, Partner, Colleagues), social bar stage, basic % (e.g. with you), connection counts. | Sort by status; optional sort by “Most %” / “Less %”; search. |
| C2 | Add Contact | Dedicated screen: name, phone, email (separate), status, city, cadence (Weekly/Bi-weekly/Monthly), notes (optional). | All fields save; validation for required fields. |
| C3 | Send invite | Send by text, email, or both (when both provided); editable pre-written prompt. | User selects channel(s); invite sent via SMS/email or in-app; contact in Pending. |
| C4 | Contact detail (MVP) | View one contact: status, basic social bar, connection counts, event history (list). | Tap contact opens detail; edit status; view history. Person goals, capacity, “who engages most” deferred. |

### 2.4 Calendar & event creation (1:1 only)

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| E1 | Calendar view | Month view; upcoming events with social bar % per event; weekly social bar % visible. | User sees month and upcoming list; each event shows impact %. |
| E2 | Event Type Picker | Choose Quick Call (15m or 30m) or Deep-Connection (1 hr or 2 hr); show current social bar and % added per type; optional Customize. **Wheel selector:** circular picker for event type (and duration) so user can select in &lt; 3 sec. | Two types mandatory; wheel available for fast selection; customize optional for MVP. |
| E3 | Create Quick Call | Duration (15/30 min), date, time, contact, notes; show social bar impact and “impact that day” when date set. | Saves draft; shows impact; capacity check optional (e.g. “Within limits”). |
| E4 | Create Deep-Connection | Duration (1 hr or 2 hr), date, time, contact, topic/notes; same impact display. | Same as E3. |
| E5 | Review & Send | Summary (type, contact, when, notes); send by Text / Email / Both; [Send Invite] [Edit]. **Wheel selector:** circular picker for send channel (Text / Email / Both) for &lt; 3 sec selection. | Invite sent; status Pending; confirmation screen; channel selectable via wheel. |
| E6 | Pending / Sent | Confirmation with date/time, duration; optional “when contact checks inbox”; [View Details] [Done]. | User sees sent state; can open event details. |

### 2.5 Inbox & responding to invites

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| I1 | Inbox list | Weekly social bar; list of pending event invites and new contact requests; per-request impact %. | Separate sections or tags for event vs contact requests. |
| I2 | Event request row | From, type, date/time, duration, brief; impact %; [Accept] [Reschedule] [Decline]. **Wheel selector:** circular picker for response (Accept / Reschedule / Decline) for &lt; 3 sec. | Tapping opens Event Detail (invitee view); wheel available for quick response. |
| I3 | New contact request row | "X wants to connect"; [Accept / Let's schedule] [Decline]. **Wheel selector:** circular picker for Accept / Let's schedule / Decline. | Accept adds contact and optionally opens schedule; Decline removes; wheel for quick pick. |
| I4 | Event Detail (invitee) | Full event info; invitee's social bar this week and "if you accept, impact that day"; sender's "usually checks inbox" (optional MVP). **Wheel selector:** circular picker for [Accept] [Reschedule] [Decline]. | User can choose via wheel in &lt; 3 sec or use buttons. |
| I5 | Confirm Accept | Summary of acceptance; user’s social bar and impact; [Confirm] [Back]. | On Confirm, event marked Accepted; user returns to Inbox. |
| I6 | Decline | Optional note to sender; [Send Decline]. | Sender notified; user returns to Inbox. |
| I7 | Reschedule | Both parties’ social bar and impact; suggested times with impact that day; or pick date/time; [Send New Time Proposal]. | Proposal sent to sender; event stays Pending until sender accepts new time. |

### 2.6 Post-event check-in

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| P1 | Check-in prompt | After an event/call, prompt for reflection. | Trigger: manual or after event end time (simplified). |
| P2 | Feeling | Energizing, Neutral, Draining, Deep (with helper: "Deep = meaningful/fulfilling connection"). **Wheel selector:** circular picker with four segments; user selects feeling in &lt; 3 sec. | One selection; stored with event; wheel is primary quick-select control. |
| P3 | Reconnect | Soon / Later / Pause; optional reminder and note (text or voice-to-text). **Wheel selector:** circular picker for Soon / Later / Pause. | Stored; reminder optional for MVP; wheel for fast reconnect choice. |
| P4 | Track | Submit; updates history and feeds Social Bar. | Reflection saved; Social Bar logic can use it (simplified model ok). |

### 2.7 Settings & support

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| S1 | Profile | Name, photo, timezone, location. | Editable; persisted. |
| S2 | Appearance | Light / Dark mode. | Applied app-wide. |
| S3 | Account | Email, password, phone (change/add). | Secure update flows. |
| S4 | Notifications | Preferred time, quiet hours, reminder lead time (e.g. 15 min / 1 hr / 1 day). | Optional screen; used for reminder scheduling. |
| S5 | Social bar (MVP) | Fixed or simple category weights (Friend, Family, Partner, Colleagues); scale (Low/Medium/High) optional. | Basic tuning if any; full sliders post-MVP. |
| S6 | Support | Entry to Help/Tutorials (links or static content). | User can open help; videos or FAQ as available. |

### 2.8 Quick-selection: Wheel selector (circular picker)

| ID | Feature | Description | Acceptance criteria |
|----|---------|-------------|---------------------|
| W1 | Wheel selector — design | **Circular wheel UI** with distinct segments (or spokes) for each option. User rotates or taps a segment to select. Designed for **&lt; 3 second** selection time. | Wheel is the primary or prominent control where applied; options visible at a glance; single gesture or tap to confirm. |
| W2 | Placement — reflection | Post-event check-in: **Feeling** (Energizing, Neutral, Draining, Deep) and **Reconnect** (Soon, Later, Pause) as circular wheels. | User can complete feeling and reconnect choices via wheel in under 3 sec; fallback to list/buttons if needed (e.g. accessibility). |
| W3 | Placement — invite response | Event Detail / Inbox: **Accept / Reschedule / Decline** (events); **Accept / Let's schedule / Decline** (new contacts). One wheel per context. | User can pick response via wheel in &lt; 3 sec; selection advances to confirm or next step. |
| W4 | Placement — create event | Event Type Picker: **Event type** (Quick Call, Deep-Connection; optional Customize). Review & Send: **Send channel** (Text, Email, Both). Optional: duration (15m/30m, 1 hr/2 hr) as wheel. | User can pick type and send channel via wheel in &lt; 3 sec; labels and icons clear. |
| W5 | Accessibility & fallback | Wheel must support accessibility (e.g. labels, focus order, screen reader). Fallback: same options available as buttons or list for users who prefer or require them. | WCAG 2.1 Level A; wheel not sole means of selection where fallback is feasible. |

**Design intent:** The wheel reduces taps and cognitive load for repeated tasks (reflection, responding to invites, choosing event type/channel). Target: **user can complete a single choice in under 3 seconds** from when the wheel is shown.

---

## 3. Essential User Flows

### 3.1 New user: sign up → first 1:1 invite (Journey 1)

1. Open app → Splash (or direct to Sign up if no deep link).
2. Sign up (email/phone + password).
3. Optional: Onboarding tutorial (Continue or Skip).
4. Permissions: Notifications (Allow / Not Now); optional “when to notify” and calendar.
5. Home: see Social Bar (today + week), monthly breakdown, CTAs.
6. Calendar or Events tab → [+ Add] → Event Type Picker → choose Deep-Connection (or Quick Call).
7. Create 1:1: duration, date, time, select contact (must exist), notes.
8. Review & Send: confirm details, choose Text / Email / Both → Send Invite.
9. Pending/Sent: confirmation; optional “when contact checks inbox.”

**Success:** Invitation created and sent; status Pending; sender sees confirmation.

### 3.2 Invitee: receive invite → accept (Journey 4, 5)

1. User has pending invite (notification or Inbox).
2. Open Inbox → see event request (from, type, when, impact %).
3. Tap → Event Detail: full details, own social bar, “if you accept” impact.
4. Accept → Confirm Accept screen → Confirm.
5. Return to Inbox (list updated).

**Success:** Event marked Accepted; invitee sees updated list; sender can be notified.

### 3.3 Invitee: reschedule (Journey 5)

1. From Inbox → event request → Reschedule.
2. Reschedule screen: both parties’ social bar, impact; suggested times with impact that day, or pick date/time.
3. Send New Time Proposal.
4. Return to Inbox; event remains Pending until sender accepts.

**Success:** Proposal sent; sender receives and can accept new time (flow not detailed here for brevity).

### 3.4 Add contact & send invite (Journey 3)

1. Contacts tab → [+ Add] → Add Contact screen.
2. Enter name, phone and/or email, status, city, cadence, notes.
3. Send invite: Text / Email / Both; edit prompt if needed → Review → Send.
4. Contact in Pending; new contact receives invite (SMS/email or in-app).

**Success:** Contact created in Pending; invite delivered.

### 3.5 Post-event check-in (Journey 8)

1. After event (or manual trigger): Check-in screen.
2. Select feeling: Energizing / Neutral / Draining / Deep.
3. Optionally: Soon / Later / Pause; reminder; note.
4. Track → saved; Social Bar updated per model.

**Success:** Reflection stored; visible in history; Social Bar reflects it (simplified logic ok for MVP).

---

## 4. Technical Requirements

### 4.1 Platform & stack

- **Platform:** Mobile-first (iOS and/or Android); responsive web optional for MVP.
- **Stack:** To be chosen (e.g. React Native / Flutter for mobile; Node/Go + PostgreSQL or similar for backend). Document decisions in a separate technical design.

### 4.2 Functional requirements

| Area | Requirement |
|------|-------------|
| **Auth** | Secure sign up / login; session/token management; password reset flow. |
| **Data** | Users, contacts (with status, city, cadence), events (type, duration, date/time, status: Pending/Accepted/Declined/Cancelled), invitations (channel sent, delivery status), post-event reflections (feeling, reconnect, note). |
| **Social Bar** | Computed from events and check-ins (formula TBD; MVP can use simple rules: event count + reflection type). Today, week, and optional monthly breakdown by relationship category. |
| **Notifications** | Push for new invite, accepted/declined/reschedule; optional reminder before event (15 min / 1 hr / 1 day). Respect quiet hours if configured. |
| **Invites** | Send via SMS and/or email (provider TBD) or in-app only for MVP; deep link in message to open app (optional for MVP). |
| **Offline** | Optional; MVP may require network for core flows. |

### 4.3 Non-functional requirements

| Area | Requirement |
|------|-------------|
| **Security** | HTTPS; secure storage of credentials; no sensitive data in logs. |
| **Performance** | List and calendar load &lt; 2s on typical device; form submit feedback &lt; 1s. **Wheel selector:** selection completable in **&lt; 3 seconds** (design target; validate in usability). |
| **Accessibility** | Basic: labels, focus order, contrast (WCAG 2.1 Level A target). Wheel selector: accessible labels and fallback (buttons/list) where applicable. |
| **Compliance** | Privacy policy; terms; data handling per jurisdiction (document assumptions). |

### 4.4 Integrations (MVP)

- **Optional:** Calendar (Apple/Google) for read-only availability or conflict check — can be post-MVP.
- **Optional:** SMS/email provider for invite delivery — or in-app only for MVP.
- **Optional:** SSO (Apple, Google) — include if low effort.

---

## 5. Implementation Priorities

### 5.1 Phase 1 — Foundation (weeks 1–3)

1. **Auth & onboarding:** Splash, Sign up / Log in, optional Tutorial skip, Permissions (notifications, optional “when to notify”).
2. **Home:** Dashboard with Social Bar (today + week, stages), monthly breakdown (simplified), tab nav (Home, Inbox, Contacts, Calendar/Events).
3. **Contacts:** List with status, search, basic sort; Add Contact form and send invite (text/email/both); contact in Pending; Contact Detail (MVP: view + edit status + event list).
4. **Social Bar model:** Define minimal formula (e.g. event count + check-in type); persist and display.

**Exit criteria:** User can sign up, add a contact, send invite; see Home and Contacts; Social Bar visible.

### 5.2 Phase 2 — Scheduling & Inbox (weeks 4–6)

5. **Calendar/Events:** Single view; [+ Add] → Event Type Picker → Create Quick Call and Deep-Connection; Review & Send; Pending/Sent.
6. **Inbox:** List (event invites + contact requests); Event Detail (invitee); Respond: Confirm Accept, Decline (with optional note), Reschedule (both parties’ bar, suggested times or pick time, send proposal).
7. **Invite delivery:** SMS/email or in-app; Pending status and notifications.
8. **Stay in Inbox:** After Accept/Decline/Reschedule, return to Inbox; list updates.

**Exit criteria:** User can create 1:1 invite, receive it in Inbox, Accept/Reschedule/Decline; sender sees updates.

### 5.3 Phase 3 — Reflection & polish (weeks 7–8)

9. **Post-Event Check-in:** Trigger (manual or time-based); **wheel selector** for feeling (Energizing/Neutral/Draining/Deep) and reconnect (Soon/Later/Pause); optional reminder and note; Track; feed Social Bar.
10. **Settings:** Profile, Appearance, Account, notification preferences; basic Social Bar settings if any.
11. **Support:** Help/Tutorials entry; static or linked content.
12. **Bug fixes, performance, accessibility:** Per definition of done.

**Exit criteria:** Full MVP flows end-to-end; check-in and Settings usable; ready for internal or beta test.

### 5.4 Dependency order

- Social Bar (minimal model) needed before Home and Inbox impact display.
- Contacts and Add Contact before event creation (select contact).
- Event creation and Review & Send before Inbox (invitee flow).
- Reschedule depends on Event Detail and Accept/Decline.
- **Wheel selector:** implement once per context (reflection, invite response, event type, send channel); reuse component across screens.

---

## 6. Definitions & Success Criteria

### 6.1 Definition of done (per feature)

- Implemented per acceptance criteria in §2.
- Tested (manual or automated) for happy path.
- No critical or high-severity bugs open.
- Documented in release notes or changelog.

### 6.2 MVP success criteria (release)

- A new user can complete sign up, onboarding (skip ok), and permissions.
- User can add a contact and send an invite (text/email/both or in-app).
- User can create a Quick Call or Deep-Connection, send invite, and see Pending/Sent.
- Invitee can open Inbox, see event and impact, and Accept, Decline, or Reschedule (via **wheel selector** or buttons); sender sees outcome.
- User can complete a post-event check-in (feeling + reconnect via **wheel selector**, then Track); Social Bar reflects it.
- **Wheel selector** available in reflection, invite response, and event-creation flows; user can complete a single selection in **under 3 seconds** (design target; validate in usability testing).
- Settings: profile, appearance, account, and notification preferences editable.
- App stable under normal use (no crashes on primary flows).

### 6.3 Out-of-scope summary (post-MVP)

- Group Event; full Chat/Messenger; QR add contact; full Contact Detail (goals, capacity, who engages most); Create group; Calendar sync; full Settings (sliders, calendar links, social links, privacy); reconnect suggestions; deep link from SMS/email (if not in MVP).

---

## 7. References

- **BondConnect_Wireframes_v0.1.md** — Screen-by-screen wireframes.
- **User-Journey-Map-BondConnect.md** — Persona, principles, Journeys 1–9.
- **Gap-Analysis-Wireframes-vs-Journey.md** — Alignment and recommendations.

---

*This MVP requirements document should be updated when scope, priorities, or design change. Technical design (API, data model, security) to be maintained separately.*
