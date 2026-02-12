# BondConnect — Text-Only Wireframes (v0.1)
*Scope: screens we know we need from the current User Journey Map + identified gaps (habits, Social Bar logic, post-event reflection, guardrails). Text-only. No visuals, no colors.*

---

## Global Navigation (Bottom Tabs)
- **Home**
- **Contacts**
- **Calendar**
- **Chat**
- **Events**
- *(Optional)* **Inbox** (if not merged into Home/Chat)

> **Note:** The **Calendar** and **Events** tabs both open the same calendar view (month + upcoming). **[+ Add]** from either tab opens the Event Type Picker (Quick Call, Deep Talk, Event). Inbox is accessible from Home (bell icon) and optionally as a dedicated tab.

---

## Screen Index
1. Splash / App Store Deep Link Landing
2. Sign Up / Log In
3. Onboarding Tutorial (Optional) + Skip
4. Permissions (Notifications, Calendar)
5. Home Dashboard (Social Bar + Weekly Capacity + Nudges)
6. Inbox / Requests (Invites + Contact Requests)
7. Contacts List
8. Add Contact
9. Contact Detail (Relationship CRM View)
10. Calendar
11. Event Type Picker (3 options)
12. Create 1:1 Quick Call
13. Create 1:1 Deep Talk
14. Create Group Event
15. Review & Send (Confirmation)
16. Pending Status / Sent
17. Event Detail (Invitee view)
18. Respond to Invite (Accept / Reschedule / Decline)
19. Reschedule Flow
20. Chat / Messenger
21. Post-Event Check-in (Micro-Reflection)
22. Settings
23. Support / Tutorials Library

---

# 1) Splash / Deep Link Landing
**Purpose:** Handle referral links from SMS/email/social, route to app store or open app.

```
+--------------------------------------------------+
| BondConnect                                      |
|--------------------------------------------------|
| [Logo]                                           |
|                                                  |
| "You're invited to connect."                     |
|                                                  |
| If app installed: [Open BondConnect]             |
| If not installed: [Download in App Store]        |
|                                                  |
| Fine print: "By continuing you agree to Terms."  |
+--------------------------------------------------+
```

---

# 2) Sign Up / Log In
**Purpose:** Account creation for new users; login for existing.

```
+--------------------------------------------------+
| Create your account                              |
|--------------------------------------------------|
| Email / Phone: [_________________________]       |
| Password:      [_________________________]       |
|                                                  |
| [Create Account]                                 |
|--------------------------------------------------|
| Already have an account? [Log In]                |
|--------------------------------------------------|
| SSO (optional): [Continue with Apple] [Google]   |
+--------------------------------------------------+
```

---

# 3) Onboarding Tutorial (Optional) + Skip
**Purpose:** Journey 6 — short tutorial video(s) or skip; educate on contacts/events/calendar/chat/home.

```
+--------------------------------------------------+
| Welcome to BondConnect                           |
|--------------------------------------------------|
| "A simple way to protect your time               |
|  and stay close to the people you care about."   |
|                                                  |
| [▶ 60s: How the Social Bar works]                |
| [▶ 60s: Scheduling calls & events]               |
| [▶ 60s: Contacts & relationship statuses]        |
| [▶ 60s: Inbox & requests]                        |
|                                                  |
| [Continue]                         [Skip]        |
+--------------------------------------------------+
```

---

# 4) Permissions (Notifications, Calendar)
**Purpose:** Enable reminders + optional calendar sync.

```
+--------------------------------------------------+
| Enable Notifications                             |
|--------------------------------------------------|
| Get reminders and invitations instantly.         |
| [Allow Notifications]                            |
| [Not Now]                                        |
+--------------------------------------------------+

+--------------------------------------------------+
| Calendar Access (Optional)                       |
|--------------------------------------------------|
| "See your availability and avoid conflicts."     |
| [Connect Calendar]                               |
| [Skip]                                           |
+--------------------------------------------------+
```

---

# 5) Home Dashboard (Social Bar + Weekly Capacity + Nudges)
**Purpose:** Daily/weekly reason to open; show Social Bar, capacity, and prompts.

```
+--------------------------------------------------+
| Home                                  [🔔] [⚙]  |
|--------------------------------------------------|
| Good evening, Mike.                              |
|                                                  |
| Social Bar (Today): [■■■■■■■■□□] 80%             |
| Weekly Capacity:     [■■■■■■□□□] 70% used        |
|                                                  |
| Quick Check-in (10 sec):                         |
| "How full is your social energy today?"          |
| [Low] [Medium] [High]                            |
|                                                  |
| Suggested Actions:                               |
| • Reconnect: Tom (last: 180 days) [Plan]         |
| • You’re near capacity this week  [Review Week]  |
|                                                  |
| This Month:                                      |
| • Connected: 6  • Pending: 2  • Overdue: 3       |
|                                                  |
| [Create] Quick Call   [Create] Event             |
+--------------------------------------------------+
```

**Components**
- Social Bar meter + tooltip: “What changes this?”
- Weekly Capacity + guardrail messaging
- Reconnect suggestions (light CRM)
- CTA shortcuts to create flows

---

# 6) Inbox / Requests (Invites + Contact Requests)
**Purpose:** Notification → Inbox tab; accept / reschedule / decline. After Accept (confirm) or Decline, user returns to **Contacts** tab (or stays in Inbox, depending on product choice).

```
+--------------------------------------------------+
| Inbox / Requests                                 |
|--------------------------------------------------|
| Social Bar (This Week): [■■■■■■□□□] 70%          |
| (Shows your weekly social energy used)           |
|--------------------------------------------------|
| Pending Requests (3)                             |
|--------------------------------------------------|
| [Tom]  Deep Talk • 30 min • Fri 7:30 PM          |
| From: Tom (Friend) • SLC                         |
| Social Bar impact (this event): +12%             |
| Brief: "Catch up + talk through what's new."     |
| [Accept] [Reschedule] [Decline]                  |
|--------------------------------------------------|
| [Ashley] Event • "Dinner" • Sat 6:00 PM          |
| Location: TBD • RSVP required                    |
| Social Bar impact (this event): +18%             |
| Brief: "Small dinner to reconnect and unwind."   |
| [Accept] [Reschedule] [Decline]                  |
|--------------------------------------------------|
| Contact Requests (1)                             |
| [Jamie] wants to connect                         |
| New contact: [Accept / Let's schedule] [Decline] |
+--------------------------------------------------+
```

---

# 7) Contacts List
**Purpose:** Show all contacts, location, social bar per contact, add contact.

```
+--------------------------------------------------+
| Contacts                               [+ Add]   |
|--------------------------------------------------|
| Search: [_________________________]              |
| Filters: [All] [Friends] [Family] [Work]         |
|--------------------------------------------------|
| Tom (Friend) • SLC                Bar: [■■■□□]    |
| Last: 180d • Cadence: Monthly                    |
|--------------------------------------------------|
| Ashley (Work) • Provo             Bar: [■■■■□]    |
| Last: 14d • Cadence: Bi-weekly                   |
|--------------------------------------------------|
| Jamie (Family) • Ogden            Bar: [■■□□□]    |
| Last: 40d • Cadence: Monthly                     |
+--------------------------------------------------+
```

---

# 8) Add Contact
**Purpose:** Journey 3 — input phone + name + status + city; send invite.

```
+--------------------------------------------------+
| Add Contact                                      |
|--------------------------------------------------|
| Name:       [_________________________]          |
| Phone/Email:[_________________________]          |
| Status:     [Friend ▾] (Friend/Partner/Family/Work)|
| City:       [_________________________]          |
| Cadence:    [Monthly ▾] (Weekly/Bi-weekly/Monthly)|
| Notes:      [_________________________]          |
|--------------------------------------------------|
| [Review]                                         |
+--------------------------------------------------+
```

---

# 9) Contact Detail (Relationship CRM View)
**Purpose:** Relationship profile with history, cadence, planned next touch, notes.

```
+--------------------------------------------------+
| Tom (Friend)                           [⋯]       |
|--------------------------------------------------|
| Social Bar (with Tom): [■■■□□] "Energizing"       |
| Cadence: Monthly  • City: SLC                     |
| Last Connection: 180 days                         |
|--------------------------------------------------|
| Next Suggested Touch: This week                   |
| [Plan Quick Call] [Plan Deep Talk] [Invite Event] |
|--------------------------------------------------|
| Notes                                             |
| - High school friend, catch up on life            |
| - Prefers evenings                                |
|--------------------------------------------------|
| History                                           |
| • Jan 12 — Quick Call (15m) — Neutral             |
| • Oct 01 — Deep Talk (30m) — Energizing           |
+--------------------------------------------------+
```

---

# 10) Calendar
**Purpose:** View month, upcoming events, add event.

```
+--------------------------------------------------+
| Calendar                              [+ Add]    |
|--------------------------------------------------|
| Month View (Feb 2026)                             |
| Su Mo Tu We Th Fr Sa                              |
|  1  2  3  4  5  6  7                              |
|  8  9 10 11 12 13 14                              |
| 15 16 17 18 19 20 21                              |
| 22 23 24 25 26 27 28                              |
|--------------------------------------------------|
| Upcoming                                          |
| • Fri 7:30 PM — Deep Talk with Tom (Pending)      |
| • Sat 6:00 PM — Dinner Event (Pending)            |
+--------------------------------------------------+
```

---

# 11) Event Type Picker (3 options)
**Purpose:** Journey 1 mentions “list of three options”; clarify.

```
+--------------------------------------------------+
| Create                                            |
|--------------------------------------------------|
| Choose a type:                                    |
| [1] Quick Phone Call (15m)                        |
| [2] Deep Talk (30m)                               |
| [3] Event (Group / Any length)                    |
+--------------------------------------------------+
```

---

# 12) Create 1:1 Quick Call
```
+--------------------------------------------------+
| Quick Phone Call                                 |
|--------------------------------------------------|
| Duration: [15 min ▾]                             |
| Date:     [____/____/____]                       |
| Time:     [__:__ AM/PM]                          |
| Contact:  [Select Contact ▾]                     |
| Notes:    [_________________________]            |
|--------------------------------------------------|
| Capacity Check: "Within limits ✅"               |
| [Review]                                         |
+--------------------------------------------------+
```

---

# 13) Create 1:1 Deep Talk
```
+--------------------------------------------------+
| Deep Talk                                        |
|--------------------------------------------------|
| Duration: [30 min ▾]                             |
| Date:     [____/____/____]                       |
| Time:     [__:__ AM/PM]                          |
| Contact:  [Select Contact ▾]                     |
| Topic (optional): [____________________]         |
|--------------------------------------------------|
| Capacity Check: "Near weekly limit ⚠"            |
| Suggestion: [Shorten] [Reschedule] [Proceed]     |
| [Review]                                         |
+--------------------------------------------------+
```

---

# 14) Create Group Event
**Purpose:** Journey 2 — length 1 hour to “infinity,” description, date/time, location, RSVP optional, invite many.

```
+--------------------------------------------------+
| Create Event                                      |
|--------------------------------------------------|
| Title:        [_________________________]         |
| Description:  [_________________________]         |
| Duration:     [1 hour ▾] (custom allowed)         |
| Date:         [____/____/____]                    |
| Start Time:   [__:__ AM/PM]                       |
| Location:     [_________________________]         |
| RSVP:         [On ▾] (On/Off)                     |
|--------------------------------------------------|
| Invite People:                                    |
| [Search contacts...]                              |
| [ ] Tom   [ ] Ashley  [ ] Jamie  [ ] Adam ...     |
|--------------------------------------------------|
| Capacity Check: "This adds +15% load"             |
| [Review]                                          |
+--------------------------------------------------+
```

---

# 15) Review & Send (Confirmation)
**Purpose:** Journey steps include review screen then accept.

```
+--------------------------------------------------+
| Review                                            |
|--------------------------------------------------|
| Type: Deep Talk (30 min)                          |
| With: Tom                                         |
| When: Fri, Feb 13 • 7:30 PM                       |
| Mode: Phone call                                  |
| Notes: "Catch up"                                 |
|--------------------------------------------------|
| Status after send: Pending                        |
| [Send Invite]                                     |
| [Edit]                                            |
+--------------------------------------------------+
```

---

# 16) Pending Status / Sent
```
+--------------------------------------------------+
| Sent ✅                                           |
|--------------------------------------------------|
| Invitation sent to Tom.                           |
| Status: Pending response                          |
|--------------------------------------------------|
| [View Details]   [Invite Another]   [Done]        |
+--------------------------------------------------+
```

---

# 17) Event Detail (Invitee View)
**Purpose:** For invitee reviewing details from Inbox.

```
+--------------------------------------------------+
| Event Details                                     |
|--------------------------------------------------|
| Deep Talk with Mike                               |
| Duration: 30 min                                  |
| When: Fri, Feb 13 • 7:30 PM                       |
| Mode: Phone call                                  |
| Notes: "Catch up"                                 |
|--------------------------------------------------|
| [Accept] [Reschedule] [Decline]                   |
+--------------------------------------------------+
```

---

# 18) Respond to Invite (Accept / Reschedule / Decline)
**Purpose:** From Inbox, user confirms Accept or sends Decline. After **Confirm** or **Send Decline**, user returns to **Contacts** tab (aligned with Journey).

**Accept**
```
+--------------------------------------------------+
| Confirm Accept                                    |
|--------------------------------------------------|
| You’re accepting: Deep Talk (30m)                 |
| Fri Feb 13 • 7:30 PM                              |
| [Confirm]   [Back]                                |
+--------------------------------------------------+
```

**Decline**
```
+--------------------------------------------------+
| Decline                                           |
|--------------------------------------------------|
| Optional note to sender:                          |
| [_________________________]                       |
| [Send Decline]                                    |
+--------------------------------------------------+
```

---

# 19) Reschedule Flow
**Purpose:** Journey 5 — reschedule sends user into calendar/event picker.

```
+--------------------------------------------------+
| Reschedule                                        |
|--------------------------------------------------|
| Suggested times (based on availability):          |
| [Sat 3:00 PM]  [Sun 5:30 PM]  [Mon 7:00 PM]       |
|--------------------------------------------------|
| Or pick a new time:                               |
| Date: [____/____/____]  Time: [__:__]             |
|--------------------------------------------------|
| [Send New Time Proposal]                          |
+--------------------------------------------------+
```

---

# 20) Chat / Messenger
**Purpose:** Basic messaging + quick “Add Event” CTA.

```
+--------------------------------------------------+
| Chat                                              |
|--------------------------------------------------|
| Contacts today: 3                                 |
|--------------------------------------------------|
| Conversations                                     |
| • Tom (2) — "Friday works."                       |
| • Ashley — "Where should we meet?"                |
|--------------------------------------------------|
| Open Chat: Tom                                    |
|--------------------------------------------------|
| Tom: Friday works.                                |
| You: Perfect — see you then.                      |
|--------------------------------------------------|
| [Message…____________________] [Send]             |
| [Add Event]                                       |
+--------------------------------------------------+
```

---

# 21) Post-Event Check-in (Micro-Reflection)
**Purpose:** Close the feedback loop after event/call.

```
+--------------------------------------------------+
| Quick Check-in                                    |
|--------------------------------------------------|
| How did that connection feel?                     |
| (Deep Talk with Tom • 30 min)                     |
|--------------------------------------------------|
| [Energizing 😊]  [Neutral 🙂]  [Draining 😮‍💨]     |
|--------------------------------------------------|
| Want to reconnect again?                          |
| [Soon] [Later] [Pause]                            |
|--------------------------------------------------|
| Optional note:                                    |
| [_________________________]                       |
| [Save]                                            |
+--------------------------------------------------+
```

---

# 22) Settings
```
+--------------------------------------------------+
| Settings                                          |
|--------------------------------------------------|
| Profile                                           |
| • Name, photo, timezone                           |
|--------------------------------------------------|
| Preferences                                       |
| • Weekly capacity target                          |
| • Default cadence suggestions                     |
| • Notification settings                           |
|--------------------------------------------------|
| Integrations                                      |
| • Calendar connection (on/off)                    |
|--------------------------------------------------|
| Privacy                                           |
| • Block/report user                               |
| • Data export / delete                            |
+--------------------------------------------------+
```

---

# 23) Support / Tutorials Library
**Purpose:** If user skips onboarding, they can access support tab with videos.

```
+--------------------------------------------------+
| Help & Tutorials                                  |
|--------------------------------------------------|
| Getting Started                                   |
| [▶ Social Bar & Weekly Capacity]                  |
| [▶ Scheduling calls & events]                     |
| [▶ Managing contacts]                             |
| [▶ Inbox & requests]                              |
|--------------------------------------------------|
| Troubleshooting                                   |
| [▶ Notifications not working]                     |
| [▶ Calendar sync issues]                          |
|--------------------------------------------------|
| Contact Support                                   |
| [Email Support]  [FAQ]                            |
+--------------------------------------------------+
```

---

## Open Questions (Captured for Later)
- Define the “three options” in Event Type Picker (assumed: Quick Call, Deep Talk, Event).
- Decide whether Inbox is its own tab or accessed via Home bell icon.
- Define Social Bar math and weekly capacity model (needed for guardrail copy).
- Determine RSVP behavior and group chat behavior for Events.

---

## Next Wireframe Pack (When Ready)
- “Reconnect Suggestions” explainer screen (why this person now)
- Relationship analytics (Monthly patterns)
- Smart cadence setup wizard
- Admin tools / roles (later if needed)
