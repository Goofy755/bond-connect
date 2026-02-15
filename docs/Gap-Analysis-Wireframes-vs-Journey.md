# Gap Analysis: Wireframes vs User Journey Map

**Structured comparison** between `BondConnect_Wireframes_v0.1.md` and `User-Journey-Map-BondConnect.md` to align user flow strategy with interface implementation.

---

## 1. Executive Summary

| Category | Count | Severity |
|----------|--------|----------|
| **Terminology / naming mismatches** | 4 | High |
| **Missing from Journey** (in Wireframes only) | 15+ | Medium |
| **Missing from Wireframes** (in Journey only) | 2 | Low |
| **Redundant or duplicate concepts** | 3 | Low |
| **Functional inconsistencies** | 5 | High |

**Top priorities:** Align event type naming (Deep Talk → Deep-Connection) and duration (30 min → 1 hr / 2 hr) across both docs; add Journey coverage for key wireframe-only features (Social Bar stages, send by text/email/both, QR, inbox/chat response patterns); fix remaining “Deep Talk” references in wireframes.

---

## 2. Terminology & Naming Mismatches

### 2.1 Deep Talk vs Deep-Connection

| Location | Journey | Wireframes |
|----------|---------|------------|
| **Event type** | “Deep Talk” (30 min) | “Deep-Connection” (1 hr or 2 hr+) |
| **Journey 1, 2, 7** | Quick Phone Call, **Deep Talk**, Event | Quick Call, **Deep-Connection**, Event |
| **Journey 8** | “Deep Talk with Tom” | “Deep-Connection with Tom” |
| **Screen Index** | — | Still lists “Create 1:1 **Deep Talk**” (Screen 13) |
| **Global nav note** | — | “Quick Call, **Deep Talk**, Event” |
| **Inbox / Calendar / Contact Detail / Open Questions** | — | Several “Deep Talk” labels remain |

**Impact:** Users and stakeholders may expect “Deep Talk” and 30 min; the product offers “Deep-Connection” and 1 hr or 2 hr. Confusion in copy, support, and analytics.

**Recommendation:**
- **Journey:** Replace all “Deep Talk” with “Deep-Connection”; change duration from “30 min” to “1 hr or 2 hr (per request).”
- **Wireframes:** Replace every remaining “Deep Talk” with “Deep-Connection” (Screen Index, Global nav note, Inbox example, Calendar upcoming, Contact Detail CTAs and history, Open Questions).

---

### 2.2 Event duration: 30 min vs 1 hr / 2 hr

- **Journey 1:** “Deep Talk (30 min).”
- **Wireframes:** Deep-Connection is 1 hr or 2 hr+.

**Recommendation:** Treat 1 hr / 2 hr as the product standard. Update Journey 1 (and any other “30 min” references for this type) to “1 hr or 2 hr.”

---

### 2.3 Colleagues vs Work

- **Journey 3, 4, 7:** Status options include “Work.”
- **Wireframes (Contacts, Add Contact):** Use “Colleagues” in labels/sort and “Work” in dropdowns (Friend/Partner/Family/**Work**).

**Impact:** Minor copy split (Colleagues vs Work).

**Recommendation:** Choose one term for relationship status (e.g. “Work” everywhere) and use it in both Journey and Wireframes; or use “Colleagues” everywhere and align dropdowns.

---

### 2.4 Post-event options: 3 vs 4

- **Journey 8:** “How did that connection feel? **Energizing**, **Neutral**, or **Draining**.”
- **Wireframes (Screen 21):** Four options: **Energizing**, **Neutral**, **Draining**, **Deep**.

**Impact:** Journey does not describe “Deep” as a feeling option.

**Recommendation:** Update Journey 8 to: “User is asked how the connection felt: **Energizing**, **Neutral**, **Draining**, or **Deep**.” Add a one-line definition of “Deep” (e.g. “meaningful / deep connection”) in the Journey or a glossary.

---

## 3. Missing from User Journey (in Wireframes only)

These are implemented or specified in the wireframes but not reflected in the Journey. Adding them to the Journey will align strategy with implementation.

| # | Wireframe feature | Journey gap | Recommendation |
|---|-------------------|-------------|-----------------|
| 1 | **Screen 4:** When to notify (time, quiet hours, remind-before) | Journey 1 & 6 mention “permissions” but not scheduling of notifications | Add one step: “User can set when to get notifications (e.g. preferred time, quiet hours, reminder lead time).” |
| 2 | **Screen 5:** Social bar **stage** (Min / Balance / Max) for today and week; monthly % by Work, Family, Partner, Friends, Self | Journey 7 Home tab only “Social bar meter” and “Weekly capacity bar” | Add: “Stages (Min / Balance / Max) for today and week; monthly % breakdown by relationship category.” |
| 3 | **Screen 6:** Social bar % for the week; per-request social bar impact; “Accept / Let’s schedule” for new contacts | Journey 4 describes Inbox but not social bar or new-contact CTA wording | Add: “Inbox shows weekly social bar and per-request impact; new contact: Accept / Let’s schedule or Decline.” |
| 4 | **Screens 7, 9:** Sort by Most % / Less %; groups; person goals for BondConnect; capacity “can receive” this/next week; who engages most; connection counts | Journey 7 Contacts/Events only high-level; no “person goals,” capacity, or engagement | Add to Journey 7 (or new journey): Contact list and detail include sort by %, groups, person goals, capacity, who engages most, connection counts. |
| 5 | **Screen 8:** Separate phone & email; send invite by **text** or **email** or both; **QR** (scan / show my QR) | Journey 3: “sends an invitation” only | Add: “User can send invite by text, email, or both (with editable prompt); or add via QR (scan theirs or show mine).” |
| 6 | **Screen 10:** Social bar % for month and week; % per upcoming event; “most active time” (time-of-day bands) | Journey 7 Calendar: “Add Event” only | Add: “Calendar shows month/week social bar %, impact per upcoming event, and when user is most active (time-of-day).” |
| 7 | **Screens 11–14:** Current social bar; **impact that day** when date is set; **Customize event** | Journeys 1 & 2: no social bar or “impact that day” in create flow | Add: “When creating an event, user sees current social bar and, once date is set, impact that day; optional custom event type.” |
| 8 | **Screen 15:** Send invite by **[Text] [Email] [Both]** | Journey 1 & 2: “sends an invitation” only | Add: “User chooses to send invite by text, email, or both.” |
| 9 | **Screens 16, 17, 18, 19:** **When contact checks inbox or responds** (e.g. morning, late evening; rarely late morning, afternoon) | Journeys 4 & 5: no “when they respond” | Add: “User can see when this contact typically checks inbox or responds (e.g. often morning/late evening; rarely late morning/afternoon).” |
| 10 | **Screen 17:** Invitee sees **current social bar** (week or that date) and impact | Journey 4/5: no social bar on invitee view | Add: “Invitee sees their current social bar (week or event date) and impact of accepting.” |
| 11 | **Screen 19:** **Both parties’** current social bar and impact; impact % per **suggested time** | Journey 5 Reschedule: “suggested times” only | Add: “Reschedule shows both parties’ social bar and impact; each suggested time shows impact that day.” |
| 12 | **Screen 20:** Social % exchanged in conversation; **when contact typically chats**; chars/words; **top topic**; tabs **Search contacts**, **Most/Least chat** | Journey 7 Chat: “messages,” “contacts today,” “Add Event” only | Add: “Chat shows social % exchanged, when contact usually chats, characters/words, top topic; tabs: Search contacts, Most/Least chat.” |
| 13 | **Screen 21:** **Remind me**; **voice-to-text** for note; **[Track]** (not Save); **Deep** as 4th feeling | Journey 8: only Energizing/Neutral/Draining and “add a note” | Add: “User can set a reminder; add optional note (or voice-to-text); choose Deep as a feeling; submit with Track.” |
| 14 | **Screen 22:** Light/dark mode; password & email change; phone; location; **social bar by relationship** (Friend/Family/Partner/Work); **social bar scale**; **Calendar (Apple, Google, Calendly)**; **other social links** | Journey: no Settings flow | Add a short “Journey 9: Settings” (or subsection): profile, appearance, account, social bar categories & scale, calendar links, social links. |
| 15 | **Screens 6, 16–19:** Sender and receiver **both see current social bar** in relevant flows | Journey does not state this principle | Add one line to Journey 4/5 (and optionally to a “Principles” section): “Sender and receiver both see their own current social bar in invite/accept/reschedule flows.” |

---

## 4. Missing from Wireframes (in Journey only)

| # | Journey element | Wireframe gap | Recommendation |
|---|-----------------|---------------|-----------------|
| 1 | **Journey 4 & 5:** “User ends up in the **Contacts** tab” after Accept/Decline | Wireframes state “returns to Contacts (or stays in Inbox)” | Decide product behavior; if Contacts is canonical, update wireframe copy to “returns to Contacts tab.” |
| 2 | **Journey 7 Events tab:** “Quick Call, **Deep Talk**, or Event” | Already covered by Event Type Picker; naming should be Deep-Connection | Update Journey 7 to “Quick Call, Deep-Connection, or Event” when fixing terminology. |

---

## 5. Redundant or Duplicate Elements

| # | Issue | Location | Recommendation |
|----|--------|----------|-----------------|
| 1 | **Calendar vs Events tab** both open “same calendar view” with [+ Add] | Global nav, Journey 7 | Keep as-is; document once in Journey 7 that “Calendar and Events open the same view.” No wireframe change. |
| 2 | **Social bar** appears on many screens (Home, Inbox, Calendar, Create flows, Event Detail, Respond, Reschedule, Chat) | Multiple screens | Intentional for context; ensure copy is consistent (“current social bar,” “impact that day”). Add to Journey that “social bar is shown in context where decisions affect it.” |
| 3 | **“When contact checks inbox/chats”** on Screen 16, 17, 19, 20 | Repeated pattern | Keep; document in Journey as “User can see when contact typically checks inbox or chats (e.g. morning, late evening).” |

---

## 6. Functional Inconsistencies

### 6.1 Event type and duration end-to-end

- **Journey 1:** User picks “Deep Talk” (30 min) → review → send.
- **Wireframes:** User picks “Deep-Connection” (1 hr or 2 hr) → review shows “Deep-Connection (1 hr or 2 hr)” → send by Text/Email/Both.

**Fix:** Journey 1 steps 5–8: use “Deep-Connection (1 hr or 2 hr)” and add “User chooses to send by text, email, or both” before send.

---

### 6.2 Contact Detail CTAs

- **Wireframes (Screen 9):** “[Plan Quick Call] [Plan **Deep Talk**] [Invite Event].”
- **Rest of wireframes:** Event type is Deep-Connection.

**Fix:** In Screen 9, change “[Plan Deep Talk]” to “[Plan Deep-Connection]” (or “[Plan Deep Connection]”).

---

### 6.3 Inbox and Calendar examples

- **Screen 6 Inbox:** “[Tom] **Deep Talk** • 30 min • Fri 7:30 PM.”
- **Screen 10 Calendar:** “**Deep Talk** w/ Tom.”

**Fix:** Replace with “Deep-Connection” and “1 hr” or “2 hr” (e.g. “Deep-Connection • 1 hr • Fri 7:30 PM”).

---

### 6.4 Screen Index and global note

- **Screen Index:** “13. Create 1:1 **Deep Talk**.”
- **Global nav note:** “Quick Call, **Deep Talk**, Event.”

**Fix:** Use “Deep-Connection” in both. Update Open Questions: “three options” = Quick Call, Deep-Connection, Event.

---

### 6.5 History in Contact Detail

- **Screen 9 History:** “• Oct 01 — **Deep Talk** (30m) — Energizing.”

**Fix:** Either “Deep-Connection (1 hr)” for new events, or keep “Deep Talk (30m)” only for legacy past events and add a note that “historical events may show legacy labels.”

---

## 7. Actionable Recommendations (Prioritized)

### High priority (alignment and consistency)

1. **Unify event type naming and duration**
   - **Journey:** Replace “Deep Talk” and “30 min” with “Deep-Connection” and “1 hr or 2 hr” in Journeys 1, 2, 7, 8.
   - **Wireframes:** Replace every remaining “Deep Talk” with “Deep-Connection” (Screen Index, global note, Inbox, Calendar, Contact Detail CTAs and history, Open Questions). Use “1 hr” or “2 hr” in examples.

2. **Post-event feeling options**
   - **Journey 8:** Add “Deep” as fourth option and (optionally) a one-line definition.

3. **Send invite channel**
   - **Journey 1, 2, 3:** Add “User can send invite by text, email, or both (and, for new contact, via QR).”

4. **Contact Detail (Screen 9):** Change “[Plan Deep Talk]” to “[Plan Deep-Connection]” (or equivalent).

### Medium priority (document strategy)

5. **Journey additions**
   - Social bar stages (Min/Balance/Max) and monthly % by category (Journey 7 Home).
   - Inbox: weekly social bar, per-request impact, “Accept / Let’s schedule” for new contacts (Journey 4).
   - When contact checks inbox/chats (Journey 4/5 and Reschedule).
   - Sender and receiver both see current social bar where relevant (Journey 4/5).
   - Calendar: month/week social bar, % per upcoming event, most active time (Journey 7).
   - Create flows: current social bar, impact that day when date set, Customize event (Journey 1/2).
   - Reschedule: both parties’ social bar, impact per suggested time (Journey 5).
   - Chat: social % exchanged, when they chat, chars/words, top topic, Search / Most–Least chat (Journey 7).
   - Post-event: Remind me, voice-to-text note, Track, Deep option (Journey 8).
   - Settings: appearance, account, social bar by relationship & scale, calendar links, social links (new Journey 9 or subsection).

6. **Wireframes**
   - Decide and document post-Accept/Decline destination (Contacts vs Inbox) and align copy.

### Low priority (polish)

7. **Colleagues vs Work:** Choose one term; apply in both docs.

8. **Open Questions (wireframes):** Update “three options” to “Quick Call, Deep-Connection, Event.”

9. **Legacy history:** If old events can show “Deep Talk (30m),” add a short note in wireframes or Journey.

---

## 8. Summary Table: Journey ↔ Wireframe Alignment

| Journey | Primary screens | Aligned? | Gaps |
|--------|-----------------|----------|------|
| 1 – Starting point | Splash, Sign up, Permissions, Calendar, Event Picker, Quick Call / **Deep-Connection**, Review, Sent | No | Naming (Deep Talk), duration (30 min), send by text/email/both, social bar in create |
| 2 – Multiple people | Home, Calendar, Event Picker, Group Event, Review, Sent | Partial | Send by text/email/both; social bar & impact that day |
| 3 – Add contact | Contacts, Add Contact (phone, email, status, city, cadence), Review, Sent | Partial | QR, send by text/email, Show my QR |
| 4 – Notification | Home, Inbox (requests, accept/reschedule/decline), Contacts | Partial | Weekly social bar, per-request impact, when they respond, “Accept / Let’s schedule” |
| 5 – Not able to do dates | Inbox, Accept/Reschedule/Decline, Reschedule flow | Partial | Both parties’ social bar, impact per suggested time, when they respond |
| 6 – New contact (invitee) | Splash, App store, Sign up, Tutorial, Permissions | Yes | — |
| 7 – All tabs | Home, Contacts, Calendar, Chat, Events | Partial | Stages, monthly %, Calendar details, Chat details (social %, when they chat, topic, tabs) |
| 8 – Post-event | Post-Event Check-in | Partial | Deep option, Remind me, voice-to-text, Track |

---

## 9. Next Steps

1. **Apply high-priority fixes** in both docs (Deep-Connection naming, duration, send channel, Screen 9 CTA).
2. **Update Journey** with the “Missing from Journey” items (table in §3) so strategy matches wireframes.
3. **Fix remaining “Deep Talk”** references in wireframes (grep for “Deep Talk” and replace with “Deep-Connection” where it denotes the event type).
4. **Add a short “Principles” or “Cross-cutting” section** to the Journey (e.g. “Sender and receiver see current social bar”; “When they check inbox/chats is shown where relevant”).
5. **Re-run this gap analysis** after changes and before locking v1 scope.

---

*Gap analysis: Wireframes v0.1 vs User Journey Map. Update both documents for alignment.*
