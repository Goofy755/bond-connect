# BOND-02: Authentication + User Onboarding
*Card ID: BOND-02 | Estimated effort: 2 days | Priority: P0 | Role: Full-stack*

---

## Overview

Implement Firebase Authentication (Email/Password + Apple Sign-In) and the onboarding flow that collects the user's personality type, Social Bar scale, weekly capacity target, and notification preferences. On first sign-in, create the user document in Firestore at `/users/{userId}`.

---

## Dependencies

- **Requires**: BOND-01 (Firebase projects initialized)
- **Blocks**: BOND-03, BOND-06, BOND-08

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| User profile schema | [system-design.md](../../design/system-design.md) | §2.2 |
| Auth + onboarding requirements | [requirements.md](../../design/requirements.md) | FR-01 – FR-09 |
| Firestore security rules (users) | [firestore-security-rules.md](../../design/firestore-security-rules.md) | `/users` rules |
| Personality Multiplier seed values | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §4 (Pm) |

---

## Implementation Tasks

### Backend
- [ ] Enable Email/Password and Apple Sign-In in Firebase Console (both projects)
- [ ] Write Firestore `onCreate` trigger (or client-side logic) to create `/users/{userId}` document on first sign-in
- [ ] Create initial `/users/{userId}/socialState/current` document with default values:
  - `dailySluUsed: 0`, `dailyCapacityPct: 0`
  - `weeklySluUsed: 0`, `weeklyCapacityPct: 0`
  - `projectedDailyPct: 0`
  - `stage: "balance"`
  - `isolationDrainActive: false`, `soloRechargeActive: false`
  - `categoryBreakdown: { friend: 0, family: 0, partner: 0, colleague: 0, self: 0 }`
- [ ] Seed `personalityMultiplier` based on personality type: Introvert → 1.4, Ambivert → 1.0, Extrovert → 0.7
- [ ] Initialize `nextIsolationCheckAt` to `now + 1 hour` and `consecutiveDivergenceCount` to `0`
- [ ] Initialize `soloRechargeActive: false`

### Frontend
- [ ] Login screen: Email/Password form + "Sign in with Apple" button
- [ ] On app launch: request notification permission via `expo-notifications`
- [ ] Get FCM token and write to `/users/{uid}.fcmTokens` array (append if not already present)
- [ ] Onboarding screen 1: Personality type selection (Introvert / Ambivert / Extrovert)
- [ ] Onboarding screen 2: Social Bar scale preference (Low / Medium / High)
- [ ] Onboarding screen 3: Weekly capacity target (default 80%)
- [ ] Onboarding screen 4: Notification preferences (reminder time, quiet hours)
- [ ] On onboarding complete: write all collected fields to `/users/{userId}` and navigate to Home
- [ ] Persist auth session so user stays logged in across app restarts (`AsyncStorage`)
- [ ] Handle auth errors gracefully (wrong password, network error, Apple Sign-In cancelled)

---

## Tests

### Unit Tests
- [ ] Pm seed: given `personalityType = "introvert"`, assert `personalityMultiplier = 1.4`
- [ ] Pm seed: given `personalityType = "extrovert"`, assert `personalityMultiplier = 0.7`
- [ ] Onboarding form validation: all required fields must be filled before proceeding

### Integration Tests (Firestore Emulator)
- [ ] Sign up with Email/Password → `/users/{userId}` document is created with correct schema
- [ ] Sign up with Email/Password → `/users/{userId}/socialState/current` is created with correct defaults
- [ ] FCM token is correctly stored in `/users/{uid}.fcmTokens` after permission is granted
- [ ] All required fields are present and correctly typed
- [ ] Sign up with Apple → user document is created (mock Apple token in test)
- [ ] Second sign-in does NOT overwrite existing user document fields

### Manual Verification
- [ ] Complete onboarding from scratch on a real iOS device
- [ ] Kill the app and reopen — user is still logged in
- [ ] Sign in with Apple works end-to-end

---

## Acceptance Criteria

- [ ] User can sign up and log in with Email/Password and Apple Sign-In
- [ ] On first login, `/users/{userId}` is created in Firestore with all fields from `system-design.md §2.2`
- [ ] `/users/{userId}/socialState/current` is initialized with all fields per `system-design.md §2.4`
- [ ] `personalityMultiplier` is correctly seeded from the onboarding personality type selection
- [ ] FCM token is registered and stored in the user profile
- [ ] Subsequent logins do not overwrite the user document
- [ ] Auth session persists across app restarts

---

## Out of Scope

- Google Sign-In (deferred to Phase 2)
- Profile editing (deferred — use onboarding values)
- Calendar linking (`calendarLinks` field can be null)
