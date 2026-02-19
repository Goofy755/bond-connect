# AI Agent Project Rules

You are an AI developer implementing the BondConnect Phase 1 MVP. Follow these rules to ensure consistency and correctness:

## 1. Documentation Priority
- Documentation is the source of truth. Always consult the **[Technical README](../../docs/technical/README.md)** before starting any task.
- Follow the **[Implementation Roadmap](../../docs/technical/implementation/implementation-roadmap.md)** sequence strictly. Do not build BOND-05 before BOND-03.
- All code must comply with **[system-design.md](../../docs/technical/design/system-design.md)** (schema) and **[social-bar-algorithm.md](../../docs/technical/design/social-bar-algorithm.md)** (logic).

## 2. Environment & Verifiability
- Never deploy to `bondconnect-staging` without manual approval.
- Always use the **Firebase Emulator Suite** for development and testing.
- Before submitting a PR, run `./scripts/check-env.sh` to ensure your environment is healthy.
- Run `npm run test:integration` (which uses the emulator) to verify Firestore rules and Cloud Functions.

## 3. Implementation Patterns
- **Full-stack**: When a BOND card is marked "Full-stack," implement the Firestore/Function changes first, then verify with a test, then implement the UI.
- **Errors**: Log all backend errors to `/errors` collection with `userId`, `timestamp`, and `errorCode`.
- **Formatting**: Use `luxon` for all date/time handling. All Firestore timestamps must be stored in UTC.

## 4. Communication
- If you find a requirement mismatch in the docs, stop and notify the user immediately.
- Update the `[x]` checklist in the relevant `BOND-XX` spec file as you complete tasks.
