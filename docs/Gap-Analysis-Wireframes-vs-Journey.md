# Gap Analysis: Wireframes vs User Journey Map

**Structured comparison** between `BondConnect_Wireframes_v0.1.md` and `User-Journey-Map-BondConnect.md` to ensure alignment between user flow strategy and interface implementation.

---

## 1. Executive Summary

| Dimension | Status | Notes |
|-----------|--------|--------|
| **Journey → Wireframe coverage** | Aligned | All 9 journeys map to specific screens; no journey step lacks a wireframe. |
| **Wireframe → Journey coverage** | Aligned | All 23 screens support at least one journey; Screen 23 (Support) and deep flows (Reschedule, Event Detail) are referenced in Journey 6/5/7. |
| **Terminology** | Aligned | Deep-Connection, Colleagues, “current social bar,” “impact that day” consistent. |
| **Key flows** | Aligned | Inbox (dedicated tab, stay after Accept/Decline), Add Contact (text/email/both, QR), post-event (Deep helper), Settings. |
| **Open questions** | Documented | Social Bar math, RSVP/group behavior, “three options” definition remain in Wireframes only. |

**Verdict:** The two documents are well aligned. The gaps below are mostly edge cases, naming nuances, and opportunities to tighten consistency and implementation clarity.

---

## 2. UX Mismatches

*Where the user flow or mental model differs between the Journey Map and the Wireframes.*

### 2.1 Entry point for “Add contact” (Journey 3)

| Source | Description |
|--------|-------------|
| **Journey 3** | “User clicks on the **Contacts** tab and **[+ Add]**” — single step. |
| **Wireframes** | Screen 7 (Contacts) has “[+ Add] [Create group]”; Screen 8 is Add Contact. |

**Gap:** Journey does not say whether [+ Add] opens a full-screen (Screen 8) or an inline/modal. Wireframes assume a dedicated Add Contact screen.

**Recommendation:** Keep wireframe as-is; add one line to Journey 3: “Add Contact opens a dedicated screen (name, phone, email, status, city, cadence, send invite, QR).”

---

### 2.2 “Review” before send — consistency of label

| Source | Label / behavior |
|--------|------------------|
| **Journey 1, 2, 3** | “The system shows a **review screen**; he chooses to send invite by text, email, or both; everything looks ok. He **accepts**.” |
| **Wireframes** | Screen 15: “Review” with “[Send Invite]” and “[Edit]”; Screen 8 (Add Contact): “[Review]” at bottom. |

**Gap:** Journey uses “accepts” (user accepts the review); Wireframes use “Send Invite” / “Review.” Minor wording mismatch.

**Recommendation:** In Journey, add optional parenthetical: “(e.g. taps **Send Invite** on the review screen)” for clarity. No wireframe change.

---

### 2.3 Quick Call duration options

| Source | Detail |
|--------|--------|
| **Journey 1** | “**Quick Phone Call** (15 min)” only. |
| **Wireframes** | Screen 11/12: Quick Call “+8% (15m) or +12% (30m)”; duration 15m or 30m. |

**Gap:** Journey does not mention 30 min option; wireframes do.

**Recommendation:** In Journey 1 step 5, say “**Quick Phone Call** (15 min or 30 min)” so it matches wireframes and Event Type Picker.

---

### 2.4 Where “when to get notifications” appears

| Source | Detail |
|--------|--------|
| **Journey 1, 6** | “User can set **when to get notifications** (e.g. preferred time, quiet hours, reminder lead time).” |
| **Wireframes** | Screen 4 (Permissions): “When to notify (optional)” — preferred time, quiet hours, “Remind me for events: 15 min / 1 hr / 1 day before.” |

**Gap:** None functionally. Journey says “reminder lead time” without detail; Wireframes spell out 15 min / 1 hr / 1 day. Aligned.

**Recommendation:** Optional: in Journey 1 & 6, add “(e.g. 15 min, 1 hr, or 1 day before events)” for copy alignment.

---

## 3. Missing Components

*Elements present in one document but not the other.*

### 3.1 In Journey Map only

| Item | Journey location | Wireframe status |
|------|------------------|------------------|
| **“Suggested / recommended contacts (auto request)”** | Journey 7, Home tab | Screen 5 has “Reconnect: Tom (last: 180 days) [Plan]” and “Suggested Actions” — similar but “auto request” not explicit. |
| **“Status of connections throughout the month”** | Journey 7, Home tab | Screen 5: “This Month: Connected: 6 • Pending: 2 • Overdue: 3” — aligned. |
| **Tutorial “Skip” path** | Journey 6 | “Skip — Notifications and a **Support** tab help users find videos.” Wireframes: Screen 3 has [Skip]; Screen 23 is Support. Aligned. |

**Recommendation:** In Wireframes Screen 5, under Components, add: “Reconnect/suggested contacts (optional auto-request behavior TBD).” No change required in Journey.

---

### 3.2 In Wireframes only

| Item | Wireframe location | Journey status |
|------|--------------------|----------------|
| **Capacity Check / guardrail messaging** | Screens 12, 13, 14 | Not in Journey (e.g. “Within limits ✅”, “Near weekly limit ⚠”, “Shorten / Reschedule / Proceed”). |
| **“When contact typically checks inbox”** on Pending/Sent | Screen 16 | Journey 4/5 mention this for *invitee* view (Inbox); not explicitly for *sender* after send. |
| **Optional note on Decline** | Screen 18 | Journey 5: “Decline — Sender gets a notification that it doesn’t fit.” No “optional note to sender.” |
| **Support / Tutorials Library** | Screen 23 | Journey 6 mentions “Support tab” for skip path; no full screen description. |
| **Calendly** | Screen 22 Settings | Journey 9: “Calendar links — Apple Calendar, Google Calendar, Calendly.” Aligned. |
| **Time-of-day categories (detailed)** | Screen 10 | Journey 7: “When you're most active (time-of-day breakdown, e.g. Morning, Evening).” Wireframes list full set (Early Morning, Morning, Afternoon, etc.). Aligned at concept level. |

**Recommendation:**  
- Add to Journey 5 Decline bullet: “User can add an optional note to sender (Wireframe Screen 18).”  
- Add to Journey 2 or 7 (Calendar/Events): “Optional capacity guardrails (e.g. near weekly limit) when scheduling.”  
- Keep Screen 23 as the canonical Support/Tutorials screen; Journey 6 already references Support tab.

---

## 4. Redundant Elements

*Intentional repetition vs. true redundancy.*

| Element | Where it appears | Assessment |
|---------|------------------|------------|
| **Social bar on many screens** | Home, Inbox, Calendar, Event Picker, Quick Call, Deep-Connection, Group Event, Event Detail, Respond, Reschedule, Chat | **Intentional.** Principles: “Social bar is shown in context where decisions affect it.” No change. |
| **Calendar vs Events tab** | Both open same view (Wireframes note; Journey 7) | **Documented once** in both; no redundancy issue. |
| **“When contact checks inbox / responds”** | Screens 16, 17, 19; Journey 4, 5 | **Intentional.** Sender and invitee both need this context. No change. |
| **Review + Send flow** | Journey 1/2/3 + Screens 8, 15 | Same flow; Journey is high-level, Wireframes are screen-level. **Appropriate.** |

**Recommendation:** No removal. Consider a one-line “Principles” note in the Wireframes intro: “Social bar and ‘when they respond’ are repeated by design where they inform decisions.”

---

## 5. Functional Inconsistencies

*Behavioral or copy differences that could affect implementation.*

### 5.1 Event “Pending” after sender action

| Source | Wording |
|--------|--------|
| **Journey 1, 2, 3** | “The system sends an invitation … and the event is in **Pending** status.” |
| **Journey 5** | “The system sends to the user, and the event remains in **Pending** status.” (After Accept/Reschedule/Decline from invitee side.) |

**Gap:** Journey 5 step 6 is ambiguous: “sends to the user” could mean “sends confirmation to the invitee” or “sends new time to sender.” Wireframes: Reschedule sends “new time proposal to the sender”; Accept confirms and event moves to confirmed (implied), not Pending.

**Recommendation:** In Journey 5 step 6, clarify: “After **Reschedule**, the invitee’s new time proposal is sent to the sender; the event remains **Pending** until the sender accepts the new time. After **Accept**, the event is confirmed.” Align wireframe Screen 19 and any Pending/sent copy with this.

---

### 5.2 Notes field: Add Contact vs Contact Detail

| Screen | Notes |
|--------|--------|
| **Screen 8 (Add Contact)** | “Notes: [_________________________]” |
| **Screen 9 (Contact Detail)** | “Notes” section with example bullets. |
| **Journey 3** | Does not mention Notes. |

**Gap:** Journey 3 does not list “Notes” as an Add Contact field; Wireframes do. No conflict—additive.

**Recommendation:** In Journey 3 step 3, add “Notes (optional)” to the Add Contact field list for full alignment.

---

### 5.3 Settings order and grouping

| Source | Order / grouping |
|--------|------------------|
| **Journey 9** | Profile → Appearance → Account & security → Social bar categories & scale → Calendar links → Other social links → Privacy. |
| **Wireframes Screen 22** | Appearance → Account & security → Profile → Social bar → Calendar → Other social links → Privacy. |

**Gap:** Minor. Journey puts Profile first; Wireframes put Appearance and Account first, then Profile. Functionally equivalent.

**Recommendation:** Either reorder Wireframes to match Journey (Profile first) or add a note in Wireframes: “Section order can follow Journey 9 for consistency.” Low priority.

---

## 6. Alignment Checklist (Journey → Screens)

| Journey | Key steps | Primary wireframe screens | Aligned? |
|---------|-----------|---------------------------|----------|
| **1** – Starting point | Download, sign up, permissions, calendar, event type, Quick Call or Deep-Connection, review, send | 1, 2, 4, 10, 11, 12 or 13, 15, 16 | ✓ (add 30m to Journey 1 Quick Call) |
| **2** – Multiple people | Calendar/Events, [+ Add], Event, length/description/date/time/location/RSVP, invite many, review, send | 10, 11, 14, 15, 16 | ✓ |
| **3** – Add contact | Contacts, [+ Add], name/phone/email/status/city/cadence, send text/email/both or QR, review | 7, 8, 15 (or 8 Review) | ✓ (add Notes in Journey) |
| **4** – Notification | Notification → Inbox, weekly bar, per-request impact, accept/reschedule/decline, new contact CTA, stay in Inbox | 5 (bell), 6, 17, 18 | ✓ |
| **5** – Not able to do dates | Inbox, event details, Accept/Reschedule/Decline, both parties’ bar, suggested times, stay in Inbox | 6, 17, 18, 19 | ✓ (clarify Pending in Journey) |
| **6** – New contact (invitee) | Link → Splash/App Store, sign up, tutorial or skip, permissions, all tabs | 1, 2, 3, 4, 23 | ✓ |
| **7** – All tabs | Home, Inbox, Contacts, Calendar, Chat, Events + feature list | 5, 6, 7, 9, 10, 20, 10/11 | ✓ |
| **8** – Post-event | Prompt, Energizing/Neutral/Draining/Deep, Soon/Later/Pause, reminder, note, Track | 21 | ✓ |
| **9** – Settings | Profile, appearance, account, social bar, calendar links, social links, privacy | 22 | ✓ |

---

## 7. Actionable Recommendations (Prioritized)

### High priority

1. **Journey 5 step 6:** Clarify Pending vs confirmed after Accept vs Reschedule (invitee sends new time to sender; event remains Pending until sender accepts).
2. **Journey 1 step 5:** Add “or 30 min” to Quick Phone Call so it matches Event Type Picker and Screen 12.

### Medium priority

3. **Journey 3:** Add “Notes (optional)” to Add Contact fields; add one sentence that Add Contact opens a dedicated screen (matches Screen 8).
4. **Journey 5 Decline:** Mention optional note to sender (Screen 18).
5. **Journey 2 or 7:** One line on capacity guardrails when scheduling (Screens 12–14).
6. **Wireframes Screen 5 Components:** Note “Reconnect/suggested contacts (optional auto-request TBD).”

### Low priority

7. **Journey 1 & 6:** Optional copy tweak: “reminder lead time (e.g. 15 min, 1 hr, 1 day before events).”
8. **Journey 1/2/3:** Optional: “(e.g. taps **Send Invite** on the review screen)” for “accepts.”
9. **Settings order:** Align Wireframes Screen 22 section order with Journey 9 (Profile first) or document the intentional difference.

---

## 8. Summary

- **Wireframes** and **User Journey Map** are aligned on navigation (Inbox as dedicated tab, stay in Inbox after Accept/Decline), terminology (Deep-Connection, Colleagues, current social bar, impact that day), and core flows (add contact, invite, accept/reschedule/decline, post-event, settings).
- **Gaps** are mostly small: one missing duration (30m Quick Call in Journey), optional fields (Notes, decline note), Pending/confirmed wording in Journey 5, and minor ordering/copy tweaks.
- **Redundancy** is intentional (social bar and “when they respond” in context).
- Applying the **high- and medium-priority recommendations** will bring the two documents to full alignment for implementation.

---

*Gap analysis: structured comparison for UX and implementation alignment. Update when either document changes.*
