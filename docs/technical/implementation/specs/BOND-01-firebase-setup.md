# BOND-01: Firebase Project Setup
*Card ID: BOND-01 | Estimated effort: 1 day | Priority: P0 | Role: Backend*

---

## Overview

Initialize both Firebase projects (`bondconnect-dev` and `bondconnect-staging`), enable all required services and Google Cloud APIs, configure the Firebase CLI, and set up the Firestore emulator for local development. This is the foundation every other card depends on.

---

## Dependencies

- **Requires**: Nothing — this is the first card
- **Blocks**: All other BOND cards

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Two-environment strategy | [deployment.md](../deployment.md) | §2.1 |
| Firebase CLI initialization | [deployment.md](../deployment.md) | §2.2 |
| Required services | [deployment.md](../deployment.md) | §2.3 |
| Enable Google Cloud APIs | [deployment.md](../deployment.md) | §2.4 |
| Blaze billing setup | [deployment.md](../deployment.md) | §2.1 (billing note) |
| Firestore emulator | [deployment.md](../deployment.md) | §4.5 |
| Required Firestore indexes | [system-design.md](../../design/system-design.md) | §8 |
| Deployment order | [deployment.md](../deployment.md) | §4.6 |

---

## Implementation Tasks

- [ ] Create Firebase project `bondconnect-dev` in Firebase Console
- [ ] Create Firebase project `bondconnect-staging` in Firebase Console
- [ ] Upgrade both projects to **Blaze** (pay-as-you-go) plan
- [ ] Enable all required services on both projects (Firestore, Auth, Functions, FCM, Cloud Scheduler)
- [ ] Enable required Google Cloud APIs (`gcloud services enable ...` per `deployment.md §2.4`)
- [ ] Install Firebase CLI (`npm install -g firebase-tools`) and log in
- [ ] Create `.firebaserc` with project aliases (`dev` → `bondconnect-dev`, `staging` → `bondconnect-staging`)
- [ ] Create `firebase.json` with Firestore, Functions, and Emulator configuration
- [ ] Create `firestore.rules` (initial open rules — hardened in BOND-12)
- [ ] Create `firestore.indexes.json` with all indexes from `system-design.md §8`
- [ ] Run `firebase emulators:start` and confirm Firestore + Functions emulators start cleanly
- [ ] Add `.env.example` with all required variable names (no real values)
- [ ] Add `.env` to `.gitignore`
- [ ] Document the Firebase App IDs and config objects in the shared team secrets store

---

## Tests

### Manual Verification
- [ ] `firebase use dev` switches to `bondconnect-dev` without error
- [ ] `firebase use staging` switches to `bondconnect-staging` without error
- [ ] `firebase emulators:start` starts Firestore and Functions emulators
- [ ] Emulator UI is accessible at `http://localhost:4000`
- [ ] `firebase deploy --only firestore:indexes --project bondconnect-dev` succeeds

---

## Acceptance Criteria

- [ ] Both Firebase projects exist and are on the Blaze plan
- [ ] All required Google Cloud APIs are enabled on both projects
- [ ] `.firebaserc`, `firebase.json`, `firestore.rules`, and `firestore.indexes.json` are committed to the repo
- [ ] Firestore emulator starts locally with `firebase emulators:start`
- [ ] `getting-started.md` Steps 1–4 work end-to-end for a new developer cloning the repo

---

## Out of Scope

- Security rules hardening (BOND-12)
- Cloud Scheduler / Pub/Sub setup (BOND-10)
- Any application code
