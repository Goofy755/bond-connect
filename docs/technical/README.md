# BondConnect: Technical Documentation Index

*Last Updated: February 2026*

---

## 📚 Document Map

| Document | Purpose | Read When |
|:---|:---|:---|
## 📚 Document Map

| Document | Purpose | Read When |
|:---|:---|:---|
| [requirements.md](design/requirements.md) | Software Requirements Specification — all functional & non-functional requirements | Understanding *what* the system must do |
| [implementation-roadmap.md](implementation/implementation-roadmap.md) | **Phased breakdown and sprint schedule** | Planning the delivery sequence |
| [system-architecture.md](design/system-architecture.md) | High-level architecture, component diagram, Cloud Functions table, testing strategy | Understanding *how* components fit together |
| [system-design.md](design/system-design.md) | Firestore schema, API contracts, state machine, indexes, FCM payloads, QR flow | Implementing any feature that touches data or Cloud Functions |
| [social-bar-algorithm.md](design/social-bar-algorithm.md) | Complete Social Bar algorithm spec with formulas and worked example | Implementing BOND-03 (calculateSocialImpact) or BOND-10 (isolation drain) |
| [firestore-security-rules.md](design/firestore-security-rules.md) | Draft Firestore Security Rules for all collections | Implementing BOND-12 |
| [deployment.md](implementation/deployment.md) | Firebase project setup, environment vars, distribution strategy, monitoring, rollback | Setting up projects (BOND-01) and distributing builds |

---

## 🗂️ Trello Card Specs

All card specs live in `implementation/specs/`. Each spec links back to the relevant sections of the master docs above — don't duplicate, just reference.

| Card | Title | Role | Days | Depends On |
|:---|:---|:---|:---|:---|
| [BOND-01](implementation/specs/BOND-01-firebase-setup.md) | Firebase Project Setup | Backend | 1 | — |
| [BOND-02](implementation/specs/BOND-02-auth-onboarding.md) | Auth + User Onboarding | Full-stack | 2 | BOND-01 |
| [BOND-03](implementation/specs/BOND-03-social-bar-cf.md) | calculateSocialImpact Cloud Function | Backend | 3 | BOND-02 |
| [BOND-04](implementation/specs/BOND-04-social-bar-ui.md) | Social Bar UI — Home Dashboard | Frontend | 2 | BOND-03 |
| [BOND-05](implementation/specs/BOND-05-event-creation.md) | Event Creation + Impact Preview | Full-stack | 3 | BOND-03, BOND-04 |
| [BOND-06](implementation/specs/BOND-06-event-notifications.md) | onEventCreated CF + FCM | Backend | 2 | BOND-02 |
| [BOND-07](implementation/specs/BOND-07-inbox-rsvp.md) | Inbox + RSVP Flow UI | Frontend | 2 | BOND-06 |
| [BOND-08](implementation/specs/BOND-08-contacts.md) | Contacts List + Relationship Schema | Full-stack | 2 | BOND-02 |
| [BOND-09](implementation/specs/BOND-09-post-reflection.md) | Post-Event Reflection + Pm Nudge CF | Full-stack | 2 | BOND-07 |
| [BOND-10](implementation/specs/BOND-10-isolation-check.md) | onIsolationCheck CF + Isolation Drain | Backend | 2 | BOND-03 |
| [BOND-11](implementation/specs/BOND-11-invite-tokens.md) | Invite Tokens + Deep Linking | Backend | 2 | BOND-06 |
| [BOND-12](implementation/specs/BOND-12-security-rules.md) | Firestore Security Rules + Indexes | Backend | 1 | BOND-01 |

**Total Phase 1 MVP estimate: ~24 dev-days** across 3–4 developers.

---

## 🚀 Getting Started

New to the project? Start here: **[getting-started.md](implementation/getting-started.md)**

---

## 📋 Phase 1 MVP Scope

Per `design/requirements.md §3`:

- ✅ Authentication & Onboarding (BOND-01, BOND-02)
- ✅ Social Bar calculation (BOND-03, BOND-04)
- ✅ Event creation + impact preview (BOND-05)
- ✅ Inbox + basic RSVP (accept/decline only) (BOND-06, BOND-07)
- ✅ Contacts list (BOND-08)
- ✅ Post-event reflection (BOND-09)
- ✅ Security + infrastructure (BOND-10, BOND-11, BOND-12)
- ❌ Chat — deferred to Phase 2
- ❌ Calendar integration — deferred to Phase 2
