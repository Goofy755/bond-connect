# BOND-08: Contacts List + Relationship Schema
*Card ID: BOND-08 | Estimated effort: 2 days | Priority: P0 | Role: Full-stack*

---

## Overview

Build the Contacts screen that lets users import contacts from their device, add them to their BondConnect network, and view/edit relationship details. Relationship documents are stored at `/users/{userId}/relationships/{contactId}`. No raw contact data (phone/email) is sent to the server without explicit user action.

---

## Dependencies

- **Requires**: BOND-02 (auth required to write to user sub-collections)
- **Blocks**: BOND-03 (event creation uses contacts), BOND-11 (QR code flow creates relationships)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Relationship schema | [system-design.md](../../design/system-design.md) | §2.3 |
| Cb default for new contacts | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §7 |
| Contacts requirements | [requirements.md](../../design/requirements.md) | FR-60 – FR-75 |
| Contact request FCM payload | [system-design.md](../../design/system-design.md) | §3.6 |

---

## Implementation Tasks

### Device Contact Import
- [ ] Request `expo-contacts` permission on first access
- [ ] Display device contacts list (name + phone/email) filtered by those with a phone number or email
- [ ] "Add to BondConnect" button on each contact
- [ ] Do NOT store raw contact data server-side; only store what the user explicitly fills in the relationship form

### Relationship Creation
- [ ] On "Add" → open relationship detail form
- [ ] Form fields: status (`friend | family | partner | colleague`), city, cadence (`weekly | biweekly | monthly`), goals (primary + secondary), notes, groups
- [ ] On save, write to `/users/{userId}/relationships/{contactId}` with all fields from `system-design.md §2.3`
- [ ] Initialize `sentimentTrend: "neutral"` (Cb default per `social-bar-algorithm.md §7`)
- [ ] Initialize all `stats` fields to 0
- [ ] Initialize `socialBarWithContact` to `{ youToThem: 0, themToYou: 0, stage: "min" }`
- [ ] If the contact has a BondConnect account (matched by phone/email), set `contactUserId` and send a contact request FCM notification to them

### Contacts List Screen
- [ ] Display existing relationships in a searchable, filterable list
- [ ] Filter by `status` (friend / family / partner / colleague)
- [ ] Sort by `lastContactDate` DESC (most recently contacted first)
- [ ] Tap a contact → contact detail/edit screen

### Contact Detail Screen
- [ ] Display all relationship fields with edit capability
- [ ] Show `stats` (total calls, meetups, initiation ratio)
- [ ] Show `sentimentTrend` and `topActivities`

---

## Tests

### Unit Tests
- [ ] New relationship: `sentimentTrend` defaults to `"neutral"`
- [ ] New relationship: all `stats` fields initialize to 0
- [ ] Filter by `status: "friend"` returns only friend relationships
- [ ] Contact with `contactUserId = null` does not trigger FCM notification

### Integration Tests (Firestore Emulator)
- [ ] Create relationship → document at `/users/{uid}/relationships/{contactId}` has all schema fields
- [ ] `sentimentTrend` is `"neutral"` on creation
- [ ] Update relationship → `updatedAt` timestamp is refreshed

### Manual Verification
- [ ] Device contacts appear correctly in the import list
- [ ] Adding a contact and completing the form creates the Firestore document
- [ ] Contacts list updates in real time when a new relationship is added

---

## Acceptance Criteria

- [ ] User can import device contacts and add them to BondConnect
- [ ] Relationship document is created with all fields from `system-design.md §2.3`
- [ ] `sentimentTrend` is initialized to `"neutral"` on all new relationships
- [ ] No raw contact data (phone/email from the device) is sent to the server without explicit user input
- [ ] Contacts list is filterable by relationship status

---

## Out of Scope

- Groups management (Phase 2)
- QR code contact flow (BOND-11)
- `socialBarWithContact` calculation (reads from algorithm output — starts at 0)
