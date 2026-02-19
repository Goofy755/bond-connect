# BondConnect: Deployment & Distribution Guide (v1.0)
*Last Updated: February 2026*

---

## 1. Overview

BondConnect uses a **fully serverless stack** — no VMs or servers to manage. All infrastructure runs on Firebase and Expo's cloud services.

### Cloud Services Summary

| Service | Purpose | Cost |
|:---|:---|:---|
| **Firebase** (Firestore, Auth, Functions, FCM) | Backend, database, auth, push notifications | Free Spark plan covers prototype; Blaze (pay-as-you-go) for anything beyond free tier limits |
| **Google Maps Places API** | Location auto-classification | Free up to 28,500 calls/month; ~$0.017/call beyond |
| **Expo EAS Build** | Cloud build service for iOS/Android binaries | Free tier: 30 builds/month; Pro: ~$99/month |
| **Apple Developer Program** | Required for TestFlight distribution | $99/year |

> [!NOTE]
> No additional cloud infrastructure is required. Firebase Cloud Functions replaces any need for a dedicated application server.

---

## 2. Firebase Project Setup

### 2.1 Two-Environment Strategy

Maintain **two separate Firebase projects** to isolate development from user-facing testing:

| Environment | Firebase Project ID | Used By |
|:---|:---|:---|
| `development` | `bondconnect-dev` | Developers, local testing, CI |
| `staging` | `bondconnect-staging` | External prototype testers (TestFlight / App Distribution) |

> [!IMPORTANT]
> Never point a TestFlight build at `bondconnect-dev`. External testers must always hit `bondconnect-staging` so test data stays isolated and security rules are validated before production.

> [!IMPORTANT]
> **Billing Setup**: Cloud Functions require the **Blaze (pay-as-you-go) plan** — the free Spark plan does not support Cloud Functions.
>
> 1. Firebase Console → Project Settings → Usage and Billing
> 2. Click "Modify plan" → Select **Blaze**
> 3. Link a Google Cloud billing account (or create one)
>
> You still get Firebase's generous free tier limits (2M function invocations/month, 400K GB-seconds/month). Charges only apply when you exceed them.

### 2.2 Project Initialization

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize (run once per project)
firebase use --add   # select bondconnect-dev or bondconnect-staging
```

### 2.3 Required Firebase Services to Enable (per project)

- Firestore (Native mode)
- Authentication (Email/Password, Apple, Google)
- Cloud Functions (Node.js 20 runtime)
- Cloud Messaging (FCM)
- Cloud Scheduler (for `onIsolationCheck` Pub/Sub trigger)

### 2.4 Enable Required Google Cloud APIs

Before deploying, enable these APIs for each Firebase project:

```bash
gcloud services enable \
  firestore.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudscheduler.googleapis.com \
  pubsub.googleapis.com \
  --project=bondconnect-staging
```

### 2.5 Firebase App Check (Optional — Phase 3)

App Check protects backend resources from abuse. Defer to Phase 3 (wider beta), but enable before production launch.

1. Firebase Console → App Check → Get Started
2. Register your iOS and Android apps
3. Configure attestation (App Attest for iOS, Play Integrity for Android)
4. Enable enforcement in Firestore Security Rules (see `../design/firestore-security-rules.md`)

---

## 3. Environment Variables & Secrets

### 3.1 Client-Side (Expo)

Use Expo's environment variable support via `app.config.js`:

```js
// app.config.js
export default {
  extra: {
    firebaseApiKey: process.env.FIREBASE_API_KEY,
    firebaseProjectId: process.env.FIREBASE_PROJECT_ID,
    googleMapsApiKey: process.env.GOOGLE_MAPS_API_KEY,
    environment: process.env.APP_ENV, // "development" | "staging"
  }
};
```

**Access variables in app code**:
```js
import Constants from 'expo-constants';

const firebaseConfig = {
  apiKey: Constants.expoConfig?.extra?.firebaseApiKey,
  projectId: Constants.expoConfig?.extra?.firebaseProjectId,
};
```

**Environment switching**:
```bash
# Local development (hits bondconnect-dev)
APP_ENV=development npx expo start

# Staging build (hits bondconnect-staging)
APP_ENV=staging eas build --platform ios --profile staging
```

Store secrets in EAS Secret Store (never commit to git):
```bash
eas secret:create --scope project --name FIREBASE_API_KEY --value <value>
eas secret:create --scope project --name FIREBASE_PROJECT_ID --value <value>
eas secret:create --scope project --name GOOGLE_MAPS_API_KEY --value <value>
```

### 3.2 Cloud Functions

**Generate Service Account Key** (used for JWT signing of invite tokens):
1. Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save the JSON file securely — **never commit to git**

**Set secrets via Firebase CLI**:
```bash
firebase functions:secrets:set GOOGLE_MAPS_API_KEY
firebase functions:secrets:set FIREBASE_SERVICE_ACCOUNT_KEY  # paste JSON content
```

**Access in function code**:
```js
const mapsKey = process.env.GOOGLE_MAPS_API_KEY;
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
```

---

## 4. Backend Deployment

### 4.1 Firestore Security Rules

```bash
# Deploy rules to the target environment
firebase use bondconnect-staging
firebase deploy --only firestore:rules
```

> [!CAUTION]
> Always deploy and validate security rules **before** pointing any build at a new Firebase project. An unsecured project is a data breach risk from day one.

### 4.2 Firestore Indexes

```bash
firebase deploy --only firestore:indexes
```

Indexes are defined in `firestore.indexes.json` at the project root. See `../design/system-design.md §8` for the full index list.

### 4.3 Cloud Functions

```bash
# Deploy all functions to staging
firebase use bondconnect-staging
firebase deploy --only functions

# Deploy a single function (faster for iteration)
firebase deploy --only functions:calculateSocialImpact
```

### 4.4 Cloud Scheduler Setup (Pub/Sub Trigger)

The `onIsolationCheck` function requires a Pub/Sub topic and a Cloud Scheduler job. Run once per Firebase project:

```bash
# Create the Pub/Sub topic
gcloud pubsub topics create isolation-check-trigger --project=bondconnect-staging

# Create the hourly scheduler job
gcloud scheduler jobs create pubsub isolation-check-hourly \
  --schedule="0 * * * *" \
  --topic=isolation-check-trigger \
  --message-body='{"trigger": "hourly"}' \
  --project=bondconnect-staging
```

In the Cloud Function, subscribe to the topic:
```js
exports.onIsolationCheck = functions.pubsub
  .topic('isolation-check-trigger')
  .onPublish(async (message) => {
    // function logic
  });
```

> [!NOTE]
> Requires the Cloud Scheduler API to be enabled (included in §2.4 API enablement step).

### 4.5 Local Development (Firestore Emulator)

Use the Firebase Emulator Suite for local testing — never hit the live Firebase project during development.

```bash
# Initialize emulators (run once)
firebase init emulators

# Start emulators locally
firebase emulators:start

# Set env var so tests use the emulator
export FIRESTORE_EMULATOR_HOST=localhost:8080
```

See `../design/system-architecture.md §7` for the full testing strategy using emulators.

### 4.6 Full Deployment Order

Always deploy in this sequence to avoid dependency errors:

```
1. firebase deploy --only firestore:rules
2. firebase deploy --only firestore:indexes
3. firebase deploy --only functions
4. (one-time) Set up Cloud Scheduler job per §4.4
```

---

## 5. Distribution Strategy

BondConnect follows a **three-phase distribution model** as the prototype matures:

```
Phase 1 (Internal Dev)     Phase 2 (Prototype Testers)      Phase 3 (Wider Beta)
─────────────────────      ────────────────────────────      ────────────────────
Expo Go                →   EAS Build + TestFlight        →   EAS Build +
(team only)                (invited testers, iOS)            Firebase App Distribution
                                                             (iOS + Android)
```

---

### 5.1 Phase 1 — Internal Development (Expo Go)

**Who**: Developers and immediate team only.

**How it works**: The app runs inside the Expo Go container. No build needed — testers install Expo Go and scan a QR code.

```bash
# Start dev server and generate QR
npx expo start
```

**Limitations**: Cannot test custom native modules (e.g., `expo-contacts` in release mode). Use this phase for UI and algorithm iteration only.

---

### 5.2 Phase 2 — Prototype Testers (EAS Build + TestFlight)

**Who**: Invited early testers (friends, advisors, target personas like "Mike").

**Target**: iOS-first (React Native Expo, per requirements).

**Setup**:
```bash
# Install EAS CLI
npm install -g eas-cli

# Login to Expo account
eas login

# Configure builds (run once)
eas build:configure
```

**Build for TestFlight**:
```bash
# Build iOS staging binary
APP_ENV=staging eas build --platform ios --profile staging
```

**`eas.json` profile**:
```json
{
  "build": {
    "staging": {
      "distribution": "internal",
      "ios": {
        "buildConfiguration": "Release"
      },
      "env": {
        "APP_ENV": "staging"
      }
    }
  }
}
```

**TestFlight distribution**:
1. EAS automatically uploads the build to App Store Connect.
2. Add testers in App Store Connect → TestFlight → External Testers.
3. Apple reviews external TestFlight builds (typically 24–48 hrs for first submission).
4. Testers receive an email invite and install via the TestFlight app.

> [!IMPORTANT]
> Apple Developer Program membership ($99/year) is required. Enroll at [developer.apple.com](https://developer.apple.com) before starting Phase 2.

---

### 5.3 Phase 3 — Wider Beta (Firebase App Distribution)

**Who**: Larger tester pool across iOS and Android.

**Why Firebase App Distribution over TestFlight for this phase**:
- No Apple review delay for each new build
- Single dashboard for iOS + Android testers
- Integrates directly with the Firebase project already in use
- Testers can submit in-app feedback via the Firebase SDK

**Setup**: EAS Build has built-in Firebase App Distribution support — no additional packages needed.

Update `eas.json` to add a distribution profile:
```json
{
  "build": {
    "staging": {
      "distribution": "store",
      "ios": { "buildConfiguration": "Release" },
      "android": { "buildType": "apk" },
      "env": { "APP_ENV": "staging" }
    }
  }
}
```

**Build and distribute**:
```bash
# Build for iOS + Android
eas build --platform all --profile staging

# Distribute to testers via Firebase CLI
firebase appdistribution:distribute <path-to-build> \
  --app <FIREBASE_APP_ID> \
  --groups "beta-testers" \
  --release-notes "Build $(date +%Y%m%d): Social Bar + Event creation"
```

> [!NOTE]
> Firebase App ID can be found in Firebase Console → Project Settings → Your Apps.

Testers receive an email with a direct install link. No app store review required.

---

## 6. Tester Onboarding

For prototype testers (Phase 2 & 3), send the following alongside the TestFlight/App Distribution invite:

- **What to test**: Prioritize event creation, Social Bar feedback, and post-reflection check-in (per MVP scope in `../design/requirements.md §3`)
- **Known limitations**: Chat and Calendar integration deferred to Phase 2
- **Feedback channel**: Provide a simple form (Typeform or Google Form) for structured feedback
- **Test accounts**: Pre-create 2–3 test contact accounts in `bondconnect-staging` so testers can immediately experience the invite/RSVP flow

---

## 7. Monitoring

| What | Tool | How |
|:---|:---|:---|
| Cloud Function errors & logs | Firebase Console → Functions → Logs | Real-time log streaming; set up log-based alerts |
| Firestore read/write costs | Firebase Console → Usage tab | Monitor daily; set budget alerts in Google Cloud Billing |
| App crashes | **Expo Sentry** or **Firebase Crashlytics** | Integrate SDK; view crash reports by build version |
| FCM delivery rates | Firebase Console → Messaging | Monitor delivery rate; flag if drops below 90% |
| API cost (Google Maps) | Google Cloud Console → Maps API usage | Set daily quota cap to prevent runaway cost |

### Budget Alert Setup (Google Cloud Billing)

```
Google Cloud Console → Billing → Budgets & Alerts
→ Set budget: $50/month for prototype phase
→ Alert thresholds: 50%, 90%, 100%
→ Notify: team email
```

---

## 8. Rollback Plan

If a bad build reaches staging testers:

1. **Cloud Functions**: Redeploy a previous version from git:
   ```bash
   git checkout <previous-commit-hash>
   firebase deploy --only functions:calculateSocialImpact
   git checkout main  # return to latest
   ```
   **OR** use Firebase Console → Functions → select the function → choose a previous deployment.

2. **Firestore Rules**: Re-deploy from the previous commit:
   ```bash
   git checkout <previous-commit-hash>
   firebase deploy --only firestore:rules
   git checkout main
   ```

3. **Firestore Indexes**: Indexes are additive — no rollback is needed. Remove orphaned indexes via Firebase Console if required.

4. **App binary**: Push a new TestFlight/App Distribution build with the fix. Previous builds remain installable by testers.

> [!NOTE]
> There is no "pull back" mechanism for TestFlight builds already installed on tester devices. Ship fixes quickly as a new build.
