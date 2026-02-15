# BondConnect — Text-Only Wireframes (v0.1)
*Scope: screens we know we need from the current User Journey Map + identified gaps (habits, Social Bar logic, post-event reflection, guardrails). Text-only. No visuals, no colors.*

> **Copy consistency:** Social bar is shown in context where decisions affect it. Use **"current social bar"** and **"impact that day"** where relevant.

---

## Global Navigation (Bottom Tabs)
- **Home**
- **Contacts**
- **Calendar**
- **Chat**
- **Events**
- *(Optional)* **Inbox** (if not merged into Home/Chat)

> **Note:** The **Calendar** and **Events** tabs both open the same calendar view (month + upcoming). **[+ Add]** from either tab opens the Event Type Picker (Quick Call, Deep-Connection, Event). Inbox is accessible from Home (bell icon) and optionally as a dedicated tab.

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
13. Create 1:1 Deep-Connection
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
**Purpose:** Enable reminders + optional calendar sync. Let user choose when to receive notifications: preferred time, quiet hours, and reminder lead time (e.g. 15 min / 1 hr / 1 day before events).

```
+--------------------------------------------------+
| Enable Notifications                             |
|--------------------------------------------------|
| Get reminders and invitations instantly.         |
| [Allow Notifications]                            |
| [Not Now]                                        |
+--------------------------------------------------+

+--------------------------------------------------+
| When to notify (optional)                         |
|--------------------------------------------------|
| Preferred reminder time:  [__:__ AM/PM ▾]        |
| Remind me for events:     [1 hour ▾] before     |
|                          (15 min / 1 hr / 1 day) |
| Quiet hours (no pings):   [9:00 PM] to [7:00 AM] |
|--------------------------------------------------|
| [Save]                                            |
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
**Purpose:** Daily/weekly reason to open; show Social Bar and Weekly Capacity with level stage (Min / Balance / Max); show monthly % by category (Colleagues, Family, Partner, Friends, Self).

```
+--------------------------------------------------+
| Home                                  [🔔] [⚙]  |
|--------------------------------------------------|
| Good evening, Mike.                              |
|                                                  |
| Social Bar (Today)                               |
| [■■■■■■■■□□] 80%   Stage: Balance               |
| (Min / Balance / Max)                            |
|--------------------------------------------------|
| Weekly Capacity                                  |
| [■■■■■■□□□] 70% used   Stage: Balance           |
| (Min / Balance / Max)                            |
|--------------------------------------------------|
| This Month — Social bar by category              |
| Colleagues: 25%  Family: 20%  Partner: 15%        |
| Friends: 30%  Self:   10%                         |
|--------------------------------------------------|
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
- Social Bar (Today): meter, %, and stage (Min / Balance / Max) + tooltip: “What changes this?”
- Weekly Capacity: meter, % used, and stage (Min / Balance / Max) + guardrail messaging
- Monthly: % of social bar per category (Colleagues, Family, Partner, Friends, Self)
- Reconnect suggestions (light CRM)
- CTA shortcuts to create flows

---

# 6) Inbox / Requests (Invites + Contact Requests)
**Purpose:** Notification → Inbox tab; shows **weekly social bar** and **per-request impact**; event requests: accept / reschedule / decline; **new contact: Accept / Let's schedule or Decline**. After Accept (confirm) or Decline, user returns to **Contacts** tab (or stays in Inbox, depending on product choice).

```
+--------------------------------------------------+
| Inbox / Requests                                 |
|--------------------------------------------------|
| Social Bar (This Week): [■■■■■■□□□] 70%          |
| (Shows your weekly social energy used)           |
|--------------------------------------------------|
| Pending Requests (3)                             |
|--------------------------------------------------|
| [Tom]  Deep-Connection • 1 hr • Fri 7:30 PM      |
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
**Purpose:** Show all contacts with relationship status (Friend, Family, Partner, Colleagues), sort by Most % / Less % / groups, social bar stage (Min/Balance/Max) and % invested each way, top activities, overall % social with you, and connection counts (calls, text, meetup, invites). Add contact and create group.

```
+--------------------------------------------------+
| Contacts                    [+ Add] [Create group] |
|--------------------------------------------------|
| Search: [_________________________]              |
|--------------------------------------------------|
| Sort: [All] [Friends] [Family] [Partner]        |
|       [Colleagues] [Most %] [Less %] [My groups] |
|--------------------------------------------------|
| Tom (Friend) • SLC                               |
| Social bar: [■■■□□] Stage: Balance               |
| With you: 65% (you→them) / 58% (them→you)        |
| Overall: 18.2% of social time with you           |
| Top: Calls · Dinner · Working out                |
| Connections: 12 calls · 24 texts · 3 meetups · 2 invites |
|--------------------------------------------------|
| Ashley (Colleagues) • Provo                       |
| Social bar: [■■■■□] Stage: Balance               |
| With you: 42% (you→them) / 38% (them→you)       |
| Overall: 21.7% of social time with you            |
| Top: Work related · Calls · Dinner                |
| Connections: 8 calls · 41 texts · 5 meetups · 4 invites |
|--------------------------------------------------|
| Jamie (Family) • Ogden                           |
| Social bar: [■■□□□] Stage: Min                   |
| With you: 22% (you→them) / 25% (them→you)        |
| Overall: 8.1% of social time with you             |
| Top: Calls · Dinner                              |
| Connections: 5 calls · 12 texts · 1 meetup · 0 invites |
+--------------------------------------------------+
```

**Components**
- **Relationship status:** Friend, Family, Partner, Colleagues (per contact).
- **Sort tabs:** All, by status (Friends / Family / Partner / Colleagues), Most % (highest overall % with you), Less % (lowest), My groups (custom groups).
- **Social bar per contact:** Meter + stage (Min / Balance / Max); % you invest in them, % they invest in you.
- **Overall %:** Share of social time they spend with you since you connected (e.g. 21.7% with you).
- **Most common:** Top activities — e.g. Calls, Working out, Dinner, Work related.
- **Connections:** Counts for calls, text, meetups, invites.
- **[Create group]:** Let user define groups and filter by them.

---

# 8) Add Contact
**Purpose:** Journey 3 — input name, phone, email (separate), status, city; send invite by **text, email, or both** (with editable prompt); or add via **QR** (scan theirs or show mine for them to scan).

```
+--------------------------------------------------+
| Add Contact                         [Scan QR]    |
|--------------------------------------------------|
| Name:       [_________________________]          |
| Phone:      [_________________________]          |
| Email:      [_________________________]          |
| Status:     [Friend ▾] (Friend/Partner/Family/Colleagues)|
| City:       [_________________________]          |
| Cadence:    [Monthly ▾] (Weekly/Bi-weekly/Monthly)|
| Notes:      [_________________________]          |
|--------------------------------------------------|
| Send invite                                      |
| [Send text message]  [Send email]                |
| Pre-written prompt:                              |
| "Hi, I'd like to connect with you on BondConnect  |
|  so we can stay in touch and plan time together." |
| [Edit prompt]                                     |
|--------------------------------------------------|
| Or: [Show my QR code] — they scan to connect     |
|--------------------------------------------------|
| [Review]                                         |
+--------------------------------------------------+
```

**Components**
- **Phone** and **Email** as separate inputs.
- **Send invite:** Choose **Send text message** or **Send email**; app uses pre-written prompt (user can edit before sending).
- **Scan QR:** Add contact by scanning their BondConnect QR code.
- **Show my QR code:** User shares their QR so the other person can scan to connect.

---

# 9) Contact Detail (Relationship CRM View)
**Purpose:** Full profile for one contact: status, add to group, sort by group, **person goals for BondConnect** (e.g. primary: romantic relationship, secondary: strong high school friends), social bar, capacity, top activities, connections, who engages most, and event history.

```
+--------------------------------------------------+
| Tom (Friend) • SLC                    [⋯] [Add to group] |
|--------------------------------------------------|
| Status: [Friend ▾] (Friend/Family/Partner/Colleagues)   |
| Sort by group: [All] [Family] [Close friends] [Colleagues] …  |
|--------------------------------------------------|
| Person goals for BondConnect                      |
| Primary:   Focus more on romantic relationship    |
| Secondary: Strong relationship with high school   |
|            friends                                 |
|--------------------------------------------------|
| Social Bar (with Tom)  [■■■□□]  Stage: Balance  |
| You→Tom: 65%   Tom→you: 58%                       |
| Overall: 21.67% of Tom's social time with you     |
|--------------------------------------------------|
| Capacity Tom can receive                          |
| This week:  ~12% more  Next week: ~25% more       |
|--------------------------------------------------|
| Most common together: Calls · Dinner · Working out|
|--------------------------------------------------|
| Connections: 12 calls · 24 texts · 3 meetups · 2 invites |
| Who engages more: You (you initiate 58% of the time)    |
|--------------------------------------------------|
| Next Suggested Touch: This week                   |
| [Plan Quick Call] [Plan Deep-Connection] [Invite Event] |
|--------------------------------------------------|
| Notes                                             |
| - High school friend, catch up on life             |
| - Prefers evenings                                |
|--------------------------------------------------|
| History of events                                 |
| • Jan 12 — Quick Call (15m) — Neutral             |
| • Oct 01 — Deep-Connection (1 hr) — Energizing    |
| • Sep 15 — Dinner — Energizing                    |
| • Aug 03 — Quick Call (15m) — Neutral             |
+--------------------------------------------------+
```

**Components**
- **Status:** Friend, Family, Partner, Colleagues (editable); **Add to group** to create or add to a group.
- **Sort by group:** Tabs to filter/view by group (All, or named groups) when needed.
- **Person goals for BondConnect:** This contact’s stated goals (e.g. primary: focus more on romantic relationship; secondary: strong relationship with high school friends). Helps you see what they’re optimizing for.
- **Social bar:** Meter + stage (Min / Balance / Max); % you invest in them, % they invest in you; **overall %** of their social time with you (e.g. 21.67% with you).
- **Capacity:** % level they can receive this week and next week (how much more connection they have room for).
- **Most common:** Top activities — Calls, Working out, Dinner, Work related.
- **Connections:** Counts for calls, text, meetups, invites.
- **Who engages the most:** Who initiates more (e.g. you 58%, them 42%).
- **History of events:** Chronological list of past calls, meetups, events with this contact.

---

# 10) Calendar
**Purpose:** View month; social bar % for month, week, and per upcoming event; weekly % beside calendar; and when the user is most active (time-of-day categories).

```
+--------------------------------------------------+
| Calendar                              [+ Add]    |
|--------------------------------------------------|
| Social bar — Month: 68%  |  This week: 70% done  |
|--------------------------------------------------|
| Month View (Feb 2026)     |  This week social %  |
| Su Mo Tu We Th Fr Sa      |  [■■■■■■■□□] 70%     |
|  1  2  3  4  5  6  7      |                      |
|  8  9 10 11 12 13 14      |  (Weekly social bar  |
| 15 16 17 18 19 20 21      |   completed so far)  |
| 22 23 24 25 26 27 28      |                      |
|--------------------------------------------------|
| Upcoming (social % each event)                    |
| • Fri 7:30 PM — Deep-Connection w/ Tom +12% [Pending]|
| • Sat 6:00 PM — Dinner Event       +18% [Pending]|
| • Tue 12:00 PM — Quick Call Ashley  +8% [Pending]|
|--------------------------------------------------|
| Most active time (when you schedule / connect)    |
| Early Morning  4–5:59 AM   [■□□□□□□]  5%         |
| Morning        6–11:59 AM  [■■■□□□□] 18%         |
| Afternoon     12–4:59 PM  [■■■■□□□] 22%         |
| Evening        5–7:59 PM  [■■■■■■□] 28%         |
| Late Evening   8–9:59 PM  [■■■■■□□] 15%         |
| Night         10–11:59 PM [■■□□□□□]  8%         |
| Late Night    12–3:59 AM  [■□□□□□□]  4%         |
+--------------------------------------------------+
```

**Components**
- **Social bar %:** Whole month (e.g. 68%); this week (e.g. 70% done).
- **Beside calendar:** Weekly social bar meter showing % done that week so far.
- **Upcoming events:** Each event shows **% social** it takes (e.g. +12%, +18%); helps user see load at a glance.
- **Most active time:** How often the user is active (scheduling/connecting) by time range: Early Morning (4–5:59 AM), Morning (6–11:59 AM), Afternoon (12–4:59 PM), Evening (5–7:59 PM), Late Evening (8–9:59 PM), Night (10–11:59 PM), Late Night (12–3:59 AM). Shown as bar + % per category.

---

# 11) Event Type Picker (3 options + customize)
**Purpose:** Choose event type; see current Social Bar % and how much each type adds to it. Option to customize event (Quick Call, Deep-Connection, Event).

```
+--------------------------------------------------+
| Create                                            |
|--------------------------------------------------|
| Social Bar (now): [■■■■■■■■□□] 80%               |
|--------------------------------------------------|
| Choose a type:          Adds to social bar        |
| [1] Quick Phone Call    +8% (15m)  or  +12% (30m)|
| [2] Deep-Connection     +18% (1 hr) or +28% (2hr+)|
| [3] Event (Group)       varies by length          |
|--------------------------------------------------|
| [Customize event] — set your own length & type   |
|--------------------------------------------------|
| [Continue]                                       |
+--------------------------------------------------+
```

**Components**
- **Social Bar (now):** Current social bar % so user sees capacity before choosing.
- **% per type:** Quick Phone Call +8% (15m) or +12% (30m); Deep-Connection +18% (1 hr) or +28% (2 hr+); Event varies by length.
- **[Customize event]:** User can set custom length and type.

---

# 12) Create 1:1 Quick Call
```
+--------------------------------------------------+
| Quick Phone Call                                 |
|--------------------------------------------------|
| Social bar (now): [■■■■■■■■□□] 80%              |
|--------------------------------------------------|
| Duration: [15 min ▾] (15m or 30m)               |
| Date:     [____/____/____]                       |
| Time:     [__:__ AM/PM]                          |
| Contact:  [Select Contact ▾]                     |
| Notes:    [_________________________]            |
|--------------------------------------------------|
| Social bar impact: +8% (15m) or +12% (30m)      |
| If date set: Impact that day: +12% → Fri 14th: 92% |
|--------------------------------------------------|
| Capacity Check: "Within limits ✅"               |
| [Review]                                         |
+--------------------------------------------------+
```

---

# 13) Create 1:1 Deep-Connection
```
+--------------------------------------------------+
| Deep-Connection                                   |
|--------------------------------------------------|
| Social bar (now): [■■■■■■■■□□] 80%              |
|--------------------------------------------------|
| Duration: [1 hour ▾] (1 hr or 2 hr+)             |
| Date:     [____/____/____]                       |
| Time:     [__:__ AM/PM]                          |
| Contact:  [Select Contact ▾]                     |
| Topic (optional): [____________________]         |
|--------------------------------------------------|
| Social bar impact: +18% (1 hr) or +28% (2 hr+)   |
| If date set: Impact that day: +18% → Sat 15th: 98% |
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
| Social bar (now): [■■■■■■■■□□] 80%              |
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
| Social bar impact: varies (e.g. +15% for 1 hr)   |
| If date set: Impact that day: +15% → Sun 16th: 95% |
|--------------------------------------------------|
| Capacity Check: "This adds +15% load"             |
| [Review]                                          |
+--------------------------------------------------+
```

---

# 15) Review & Send (Confirmation)
**Purpose:** Journey steps include review screen then accept. User chooses how to send: text, email, or both.

```
+--------------------------------------------------+
| Review                                            |
|--------------------------------------------------|
| Type: Deep-Connection (1 hr or 2 hr)              |
| With: Tom                                         |
| When: Fri, Feb 13 • 7:30 PM                       |
| Mode: Phone call                                  |
| Notes: "Catch up"                                 |
|--------------------------------------------------|
| Send invite by:                                   |
| [Text]  [Email]  [Both]                           |
|--------------------------------------------------|
| Status after send: Pending                        |
| [Send Invite]                                     |
| [Edit]                                            |
+--------------------------------------------------+
```

---

# 16) Pending Status / Sent
**Purpose:** Confirm send; show date/time and duration of what was sent; show when this contact typically checks inbox or responds.

```
+--------------------------------------------------+
| Sent ✅                                           |
|--------------------------------------------------|
| Invitation sent to Tom.                           |
| Date/Time: Fri, Feb 13 • 7:30 PM                  |
| Duration: 1 hr (Deep-Connection)                 |
| Status: Pending response                          |
|--------------------------------------------------|
| Tom usually checks inbox / responds:              |
| Often: Morning, Late evening                     |
| Rarely: Late morning, Afternoon                  |
|--------------------------------------------------|
| [View Details]   [Invite Another]   [Done]       |
+--------------------------------------------------+
```

---

# 17) Event Detail (Invitee View)
**Purpose:** For invitee reviewing event details from Inbox. Shows Deep-Connection (1 hr or 2 hr), social bar impact, and when the sender typically checks inbox or responds.

```
+--------------------------------------------------+
| Event Details                                     |
|--------------------------------------------------|
| Deep-Connection with Mike                         |
| Duration: 1 hr (or 2 hr — per request)            |
| When: Fri, Feb 13 • 7:30 PM                       |
| Mode: Phone call                                  |
| Notes: "Catch up"                                 |
|--------------------------------------------------|
| Your social bar — This week: [■■■■■■■□□] 70%      |
| If you accept, Fri Feb 13: ~88% that day         |
|--------------------------------------------------|
| Social bar impact: +18% (1 hr) or +28% (2 hr)    |
|--------------------------------------------------|
| Mike usually checks inbox / responds:             |
| Often: Morning, Late evening                     |
| Rarely: Late morning, Afternoon                  |
|--------------------------------------------------|
| [Accept] [Reschedule] [Decline]                   |
+--------------------------------------------------+
```

---

# 18) Respond to Invite (Accept / Reschedule / Decline)
**Purpose:** From Inbox, user confirms Accept or sends Decline; sees Deep-Connection (1 hr or 2 hr), current social bar, and impact. After **Confirm** or **Send Decline**, user returns to **Contacts** tab (aligned with Journey).

**Accept**
```
+--------------------------------------------------+
| Confirm Accept                                    |
|--------------------------------------------------|
| You’re accepting: Deep-Connection (1 hr or 2 hr)                 |
| Fri Feb 13 • 7:30 PM                              |
|--------------------------------------------------|
| Your social bar (now): [■■■■■■■□□] 70%            |
| Impact: +18% (1 hr) or +28% (2 hr) → that day ~88%|
|--------------------------------------------------|
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
**Purpose:** Journey 5 — reschedule sends user into calendar/event picker. Show current social bar for both parties, impact for this event, and when the other party typically checks inbox or responds. (Sender and receiver both see current social bar in their flows.)

```
+--------------------------------------------------+
| Reschedule                                        |
|--------------------------------------------------|
| Current social bar (both parties)                 |
| You (sender):  [■■■■■■■□□] 70%   Impact: +18%    |
| Mike (receiver): [■■■■■■□□□] 65%  Impact: +18%   |
|--------------------------------------------------|
| Mike usually checks inbox / responds:             |
| Often: Morning, Late evening                     |
| Rarely: Late morning, Afternoon                  |
|--------------------------------------------------|
| Suggested times (based on availability):          |
| [Sat 3:00 PM +18% → 88%] [Sun 5:30 PM +18% → 75%] |
| [Mon 7:00 PM +18% → 82%]                          |
| (Impact on your social bar that day)              |
|--------------------------------------------------|
| Or pick a new time:                               |
| Date: [____/____/____]  Time: [__:__]             |
|--------------------------------------------------|
| [Send New Time Proposal]                          |
+--------------------------------------------------+
```

---

# 20) Chat / Messenger
**Purpose:** Basic messaging + quick “Add Event” CTA. Show social % exchanged, when contact chats back, current social bar (sender & receiver), chars/words exchanged, top topic.

```
+--------------------------------------------------+
| Chat                                              |
|--------------------------------------------------|
| Your social bar (now): [■■■■■■■□□] 70%           |
| Contacts today: 3                                 |
|--------------------------------------------------|
| Tab: [Search contacts] [Most chat/message] [Least chat/message] |
| Search: [_________________________] 🔍            |
|--------------------------------------------------|
| Conversations                                     |
| • Tom (2) — "Friday works."                       |
| • Ashley — "Where should we meet?"                |
|--------------------------------------------------|
| Open Chat: Ashley                                 |
|--------------------------------------------------|
| Ashley's social bar (now): [■■■■□□□] 65%          |
| Social % exchanged (this convo): 8%               |
| Ashley usually chats: Morning, Late evening       |
| Rarely: Late morning, Afternoon                  |
| Exchanged: 1,240 chars · 198 words               |
| Top topic: Scheduling / meetups                   |
|--------------------------------------------------|
| Ashley: Where should we meet?                     |
| You: How about the usual spot?                    |
| Ashley: Perfect — see you then.                   |
|--------------------------------------------------|
| [Message…____________________] [Send]             |
| [Add Event]                                       |
+--------------------------------------------------+
```

**Components**
- **Current social bar:** You and the contact (e.g. Ashley) both see your own current social bar; sender and receiver see it in their view.
- **Social % exchanged:** How much social % this whole conversation represents (e.g. 8%).
- **When they chat:** Contact usually chats Morning, Late evening; rarely Late morning, Afternoon.
- **Characters & words:** Total exchanged in this thread (e.g. 1,240 chars · 198 words).
- **Top topic:** Most discussed topic in the conversation (e.g. Scheduling / meetups).
- **Tab:** [Search contacts] [Most chat/message] [Least chat/message] — search contacts or filter by who chats/messages the most vs the least.

---

# 21) Post-Event Check-in (Micro-Reflection)
**Purpose:** Close the feedback loop after event/call.

```
+--------------------------------------------------+
| Quick Check-in                                    |
|--------------------------------------------------|
| Deep-Connection with Tom                          |
|--------------------------------------------------|
| How did that connection feel?                     |
| [Energizing 😊] [Neutral 🙂] [Draining 😮‍💨] [Deep] |
|--------------------------------------------------|
| Want to reconnect again?                          |
| [Soon] [Later] [Pause]                            |
|--------------------------------------------------|
| Remind me: [_________________________]            |
| (e.g. to reach out again, follow up)              |
|--------------------------------------------------|
| Optional note (or voice to text):                  |
| [_________________________]  [🎤 Voice]           |
|--------------------------------------------------|
| [Track]                                           |
+--------------------------------------------------+
```

---

# 22) Settings
**Purpose:** Profile, appearance, account security, social bar categories & scale, contact info, calendar links, and social links.

```
+--------------------------------------------------+
| Settings                                          |
|--------------------------------------------------|
| Appearance                                        |
| • Light / Dark mode    [Light ▾]                  |
|--------------------------------------------------|
| Account & security                                |
| • Email:  [_________________________]  [Change]   |
| • Password:                           [Change]    |
| • Phone:  [_________________________]  [Add]      |
|--------------------------------------------------|
| Profile                                            |
| • Name, photo, timezone                           |
| • Location: [_________________________]           |
|--------------------------------------------------|
| Social bar — categorize by relationship           |
| Set how Friend, Family, Partner, Colleagues count:|
| Friend:   [■■■■□]  Family: [■■■■■]               |
| Partner:  [■■■■■]  Colleagues: [■■■□□]           |
| (slider or % per category)                        |
|--------------------------------------------------|
| Social bar scale                                  |
| • Scale / sensitivity: [Low ▾] [Medium] [High]    |
| • Weekly capacity target                          |
|--------------------------------------------------|
| Calendar connection                               |
| • [Link Apple Calendar]  [Link Google Calendar]   |
| • [Link Calendly]                                 |
|--------------------------------------------------|
| Other social links                                |
| • [Add social link]  (e.g. LinkedIn, Instagram)   |
| [_________________________] [Add]                 |
|--------------------------------------------------|
| Privacy                                            |
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
- Define the “three options” in Event Type Picker (assumed: Quick Call, Deep-Connection, Event).
- Decide whether Inbox is its own tab or accessed via Home bell icon.
- Define Social Bar math and weekly capacity model (needed for guardrail copy).
- Determine RSVP behavior and group chat behavior for Events.

---

## Next Wireframe Pack (When Ready)
- “Reconnect Suggestions” explainer screen (why this person now)
- Relationship analytics (Monthly patterns)
- Smart cadence setup wizard
- Admin tools / roles (later if needed)
