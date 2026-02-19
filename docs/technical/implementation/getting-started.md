# BondConnect: Getting Started Guide
*For new developers joining the project*

---

## 🤖 For AI Agents & Bot Developers
This project is **Agent-Ready**. If you are an AI assistant:
1. Read the **`.agent/agent-rules.md`** for project-specific implementation guidelines.
2. Run **`./scripts/check-env.sh`** to verify your environment setup.
3. Use **`npm run seed:emulator`** to populate your local database before testing UI.

---

## Prerequisites

Install the following before anything else:

```bash
# Node.js 20+
node --version   # should be >= 20.0.0

# Firebase CLI
npm install -g firebase-tools
firebase --version  # should be >= 13.0.0

# EAS CLI (Expo Application Services)
npm install -g eas-cli

# Google Cloud CLI (for Pub/Sub + Cloud Scheduler setup)
# Install via: https://cloud.google.com/sdk/docs/install
gcloud --version
```

---

## Step 1: Clone & Install

```bash
git clone <repo-url>
cd bond-connect
npm install
```

---

## Step 2: Firebase CLI Login

```bash
firebase login
firebase use --add   # select bondconnect-dev
```

Confirm your active project:
```bash
firebase use   # should print: bondconnect-dev
```

---

## Step 3: Configure Environment Variables

Copy the example env file:
```bash
cp .env.example .env
```

Fill in the values from the team's shared secrets store (ask the lead dev for access):

```
FIREBASE_API_KEY=...
FIREBASE_PROJECT_ID=bondconnect-dev
GOOGLE_MAPS_API_KEY=...
APP_ENV=development
```

> [!CAUTION]
> Never commit `.env` to git. It is already in `.gitignore`.

---

## Step 4: Start the Firestore Emulator

For local development and running tests, always use the emulator — never the live `bondconnect-dev` project.

```bash
firebase emulators:start
```

The emulator UI will be available at: `http://localhost:4000`

Set the emulator env var in your terminal before running tests:
```bash
export FIRESTORE_EMULATOR_HOST=localhost:8080
```

---

## Step 5: Run the App Locally

```bash
npx expo start
```

Scan the QR code with **Expo Go** on your iOS device. The app will connect to `bondconnect-dev` (or the local emulator if configured).

> [!NOTE]
> Some native features (e.g., `expo-contacts`) require a real device. The iOS Simulator will work for most UI development.

---

## Step 6: Run Tests

```bash
# Unit tests (no emulator needed)
npm test

# Integration tests (start emulator first)
firebase emulators:start --only firestore,functions &
npm run test:integration
```

See `../design/system-architecture.md §7` for the full testing strategy.

---

## Step 7: Create Test Data (Optional)

For local testing, you can manually seed the Firestore emulator with test data via the Emulator UI at `http://localhost:4000`.

Alternatively, use the project's seeding utility (if available):
```bash
npm run seed:emulator
```

---

## Project Structure

```
bond-connect/
├── app/                  # Expo Router screens
│   ├── (auth)/           # Login, onboarding
│   ├── (tabs)/           # Home, Inbox, Contacts, Profile
│   └── ...
├── functions/            # Firebase Cloud Functions (Node.js)
│   ├── calculateSocialImpact.js
│   ├── onEventCreated.js
│   └── ...
├── firestore.rules       # Firestore Security Rules
├── firestore.indexes.json
├── firebase.json
├── .firebaserc           # Project aliases (dev / staging)
├── eas.json              # EAS Build profiles
└── docs/
    └── technical/        # All spec & design docs
```

---

## Key Links

| Resource | URL |
|:---|:---|
| Firebase Console (dev) | `https://console.firebase.google.com/project/bondconnect-dev` |
| Firebase Console (staging) | `https://console.firebase.google.com/project/bondconnect-staging` |
| Expo Dashboard | `https://expo.dev` |
| Trello Board | *(link here)* |

---

## Your First Task

1. Complete Steps 1–5 above
2. Find your assigned Trello card in `specs/BOND-XX-*.md`
3. Read the referenced sections of the master docs listed in your card
4. Start with the task checklist in the spec — each step is ordered by dependency

---

## Questions?

- **Architecture questions** → `../design/system-architecture.md`
- **Schema / API questions** → `../design/system-design.md`
- **Algorithm questions** → `../design/social-bar-algorithm.md`
- **Deployment questions** → `deployment.md`
- **Still stuck?** → ping the lead dev on Slack
