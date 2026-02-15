# Gap Analysis: Wireframes vs User Journey Map (Updated)

**Structured comparison** between `BondConnect_Wireframes_v0.1.md` and `User-Journey-Map-BondConnect.md` — post-alignment review.

---

## 1. Executive Summary

| Category | Count | Severity |
|----------|--------|----------|
| **Remaining terminology mismatches** | 0 | — |
| **Missing from Journey** | 0 | — |
| **Missing from Wireframes** | 0 | — |
| **Minor inconsistencies** | 2 | Low |
| **Open design decisions** | 2 | Medium |

**Status:** Journey and Wireframes are well aligned. Remaining gaps are minor (Add Contact [Both] option, Screen 21 Deep definition) and a few open product decisions.

---

## 2. Remaining Terminology / Copy Mismatches

### 2.1 ~~Stray "Work" in Journey 4~~ ✓ Fixed

- **Location:** Journey 4, step 4 — was "status (Friend, Partner, Family, Work)"
- **Fix applied:** Replaced "Work" with "Colleagues" in Journey 4.

---

## 3. Minor Inconsistencies

### 3.1 Add Contact: Send by "Both"

- **Journey 3 & Screen 15:** User can send invite by "text, email, or **both**."
- **Screen 8 (Add Contact):** Wireframe shows `[Send text message] [Send email]` — no `[Both]` option.
- **Recommendation:** Add `[Both]` to Screen 8 Send invite section, or document that Add Contact sends to one channel per contact (phone → text, email → email) while Review & Send (Screen 15) offers Both for event invites.

---

### 3.2 Post-Event: Deep definition in wireframe

- **Journey 8:** "Deep" (meaningful/fulfilling connection) — definition provided.
- **Screen 21:** Shows `[Energizing] [Neutral] [Draining] [Deep]` with no tooltip or definition.
- **Recommendation:** Add a brief tooltip or helper text for "Deep" on Screen 21 (e.g. "Deep = meaningful/fulfilling connection") for consistency.

---

### 3.3 ~~Screen 11 Purpose line~~ ✓ Fixed

- **Was:** "Option to customize event. "three options"."
- **Fix applied:** Clarified as "Option to customize event (Quick Call, Deep-Connection, Event)."

---

## 4. Redundant Elements (Intentional — No Change)

| Element | Location | Note |
|---------|----------|------|
| **Calendar vs Events tab** | Both open same view | Documented once; no change needed. |
| **Social bar on many screens** | Home, Inbox, Calendar, Create flows, Event Detail, Respond, Reschedule, Chat | Intentional — shown where decisions affect it. Principles and copy-consistency note cover this. |
| **"When contact checks inbox/chats"** | Screens 16, 17, 19, 20 | Repeated pattern; documented in Journey 4/5. |

---

## 5. Open Design Decisions

### 5.1 Post-Accept/Decline destination

- **Current:** "User returns to **Contacts** tab (or stays in Inbox, depending on product choice)."
- **Action needed:** Decide product behavior and remove "depending on product choice" once finalized.

---

### 5.2 Inbox as tab vs Home bell

- **Open Questions (Wireframes):** "Decide whether Inbox is its own tab or accessed via Home bell icon."
- **Journey:** Refers to "Inbox tab" without specifying access pattern.
- **Action needed:** Finalize and document in both.

---

## 6. Alignment Checklist (Current State)

| Journey | Primary screens | Aligned? |
|---------|-----------------|----------|
| 1 – Starting point | Splash, Sign up, Permissions, Calendar, Event Picker, Quick Call / Deep-Connection, Review, Sent | ✓ |
| 2 – Multiple people | Home, Calendar, Event Picker, Group Event, Review, Sent | ✓ |
| 3 – Add contact | Contacts, Add Contact (phone, email, status, city, cadence), QR, send by text/email, Review, Sent | ✓ (minor: [Both] on Screen 8) |
| 4 – Notification | Home, Inbox (weekly bar, per-request impact, when they respond, new contact CTA), Contacts | ✓ |
| 5 – Not able to do dates | Inbox, Accept/Reschedule/Decline, Reschedule (both parties' bar, impact per time), Contacts | ✓ |
| 6 – New contact (invitee) | Splash, App store, Sign up, Tutorial, Permissions | ✓ |
| 7 – All tabs | Home, Contacts, Calendar, Chat, Events — with full feature lists | ✓ |
| 8 – Post-event | Post-Event Check-in (Energizing/Neutral/Draining/Deep, Remind me, voice-to-text, Track) | ✓ (minor: Deep def in wireframe) |
| 9 – Settings | Profile, appearance, account, social bar categories & scale, calendar links, social links | ✓ |

---

## 7. Actionable Recommendations (Prioritized)

### High priority

- *(None remaining.)*

### Medium priority

1. **Screen 8:** Add `[Both]` to Send invite options, or document that Add Contact uses one channel per field (phone vs email).
2. **Screen 21:** Add tooltip or helper for "Deep" (meaningful/fulfilling connection).

### Low priority

3. **Product decision:** Finalize post-Accept/Decline destination (Contacts vs Inbox).
4. **Product decision:** Finalize Inbox access (dedicated tab vs Home bell only).

---

## 8. Summary

The Wireframes and User Journey Map are closely aligned. Terminology (Deep-Connection, Colleagues), flows (notifications, social bar, Inbox, Contacts, Calendar, create flows, send options, QR, when they respond, both parties' bar, Chat details, post-event, Settings), and Principles are consistent. Two minor wireframe tweaks (Add Contact [Both], Deep tooltip) and two product decisions remain.

---

*Gap analysis updated after alignment. Re-run when product decisions are finalized.*
