# BondConnect: Firestore Security Rules (v1.0)
*Last Updated: February 2026*

---

## Overview

These rules enforce the data access model defined in `system-architecture.md` and `system-design.md`. The core principles are:

1. **Users own their own data** — a user may only read/write their own profile, relationships, sentiment log, and social state.
2. **Events are shared by participants** — creators can write; all RSVP holders can read.
3. **Cloud Functions are the only writers for sensitive documents** — `socialState`, `notifications`, and `inviteTokens` are write-protected from the client.
4. **Messages are immutable** — once written, messages cannot be edited or deleted by any client.

---

## Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ─── Helpers ────────────────────────────────────────────────────────────

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function isEventCreator(eventData) {
      return isAuthenticated() && eventData.creatorId == request.auth.uid;
    }

    function hasRsvp(eventId) {
      // Returns true if an RSVP document exists for the calling user on this event
      return isAuthenticated() &&
        exists(/databases/$(database)/documents/events/$(eventId)/rsvps/$(request.auth.uid));
    }

    function isThreadParticipant(threadData) {
      return isAuthenticated() && request.auth.uid in threadData.participantIds;
    }

    // ─── User Profile ────────────────────────────────────────────────────────

    match /users/{userId} {
      allow read, write: if isOwner(userId);

      // Relationship CRM — private to the owning user
      match /relationships/{contactId} {
        allow read, write: if isOwner(userId);
      }

      // Sentiment log — private to the owning user
      match /sentimentLog/{reflectionId} {
        allow read, write: if isOwner(userId);
      }

      // Social state — readable by owner; only Cloud Functions may write
      match /socialState/{document} {
        allow read: if isOwner(userId);
        allow write: if false; // Cloud Functions only
      }

      // In-app notifications — readable by owner; only Cloud Functions may write
      match /notifications/{notificationId} {
        allow read: if isOwner(userId);
        allow write: if false; // Cloud Functions only
      }
    }

    // ─── Events ──────────────────────────────────────────────────────────────

    match /events/{eventId} {
      // Creator or any RSVP holder may read the event
      allow read: if isAuthenticated() &&
                    (isEventCreator(resource.data) || hasRsvp(eventId));

      // Only authenticated users may create; they must set themselves as creator
      allow create: if isAuthenticated() &&
                      request.resource.data.creatorId == request.auth.uid;

      // Only the creator may update or delete the event
      allow update, delete: if isEventCreator(resource.data);

      // RSVPs — each user manages their own RSVP record
      match /rsvps/{rsvpUserId} {
        // Creator or the RSVP owner may read
        allow read: if isAuthenticated() &&
                      (rsvpUserId == request.auth.uid ||
                       get(/databases/$(database)/documents/events/$(eventId)).data.creatorId == request.auth.uid);

        // Only the RSVP owner may write their own RSVP
        allow write: if isOwner(rsvpUserId);
      }
    }

    // ─── Chat Threads ────────────────────────────────────────────────────────

    match /messages/{threadId} {
      // Only thread participants may read the thread document
      allow read: if isThreadParticipant(resource.data);

      // Participants may not create threads directly (Cloud Functions create threads)
      allow write: if false;

      match /messages/{messageId} {
        // Only participants may read messages
        allow read: if isAuthenticated() &&
                      request.auth.uid in
                        get(/databases/$(database)/documents/messages/$(threadId)).data.participantIds;

        // Participants may create new messages (sender must be themselves)
        allow create: if isAuthenticated() &&
                        request.auth.uid in
                          get(/databases/$(database)/documents/messages/$(threadId)).data.participantIds &&
                        request.resource.data.senderId == request.auth.uid;

        // Messages are immutable — no updates or deletes
        allow update, delete: if false;
      }
    }

    // ─── Invite Tokens ───────────────────────────────────────────────────────

    // No client access — tokens are created, read, and invalidated exclusively
    // by Cloud Functions (onEventCreated, validateInviteToken).
    match /inviteTokens/{token} {
      allow read, write: if false;
    }

  }
}
```

---

## Known Gaps (Prototype → Production)

| Gap | Notes |
|:---|:---|
| **Rate limiting** | Firestore rules have no built-in rate limiting. Add Firebase App Check and/or Cloud Armor before production. |
| **Thread creation** | Chat threads are currently created by Cloud Functions only. If client-side creation is added, validate that `participantIds` contains only real, authenticated users. |
| **Group events** | The `hasRsvp` helper performs a document existence check per read, which counts as an extra Firestore read. Monitor costs as group event sizes grow. |
| **Data validation** | These rules enforce access control only. Add `request.resource.data` field validation (types, required fields) before production. |
