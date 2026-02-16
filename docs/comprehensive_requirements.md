# BondConnect: Comprehensive Requirements Document (v1.0)

This document serves as the "Source of Truth" for the BondConnect prototype, consolidating technical architecture, psychometric algorithms, and UX principles.

## 1. Project Overview & Principles
BondConnect is a relationship management tool designed to protect a user's time and social energy.
- **Homeostatic Regulation**: The app monitors and predicts social exhaustion to help users reach a state of "Social Balance."
- **Transparency**: Both senders and receivers see the impact of connection choices on their respective social batteries.

## 2. Technical Architecture
| Component | Technology | Rationale |
| :--- | :--- | :--- |
| **Frontend** | **React Native (Expo)** | Rapid native API integration (Contacts, Calendar, Notifications). |
| **Backend/Cloud** | **Firebase (Firestore)** | Real-time state sync, offline support, and low-latency invite triggers. |
| **Logic Layer** | **Firebase Cloud Functions**| Server-side calculation of Social Load Units (SLU). |
| **External APIs** | **Google Maps Places** | Auto-detection of "Restorative" vs. "Stressful" environments. |

## 3. The Social Bar Algorithm (SSH Model)
The primary unit of cost is the **Standard Social Hour (SSH)**.
- **Baseline**: 1 SSH = 20% Drain for an average user ($P_m = 1.0$).
- **Formula**: $I = (Duration \times P_m) + E_w + I_i - C_b$

### A. Variable Definitions
- **Personality Multiplier ($P_m$)**: 
    - *Manual*: User selects Introvert/Extrovert/Ambivert during onboarding.
    - *Dynamic*: Inferred adjustment if post-event feedback consistently deviates from predictions.
- **Interaction Intensity ($I_i$)**: Weight added for conflict, emotional labor, or group settings.
- **Environment Weight ($E_w$)**: 
    - *Restoration Bonus*: -15% for nature/quiet spaces (auto-detected via Maps or manual tag).
    - *Stress Load*: +15% for urban/noisy environments.
- **Connection Bonus ($C_b$)**: Reduction in drain for high-intimacy/supportive ties.

### B. Homeostasis: Isolation vs. Solitude
- **Solo Recharge Mode**: A manual toggle.
    - *Active*: Time is restorative (reduces drain).
    - *Inactive*: Prolonged alone time triggers "Isolation Drain" (homeostatic hunger for contact).

## 4. UI/UX Implementation
- **Lagged Fatigue (Ghost Bar)**: To account for the 2–4 hour delay in social exhaustion, the UI will display:
    - *Primary Bar*: Current felt state.
    - *Shadow Overlay*: Projected state based on recent/upcoming interactions.
- **Aesthetics**: "Calm UX" featuring:
    - Palette: Deep greens, soft blues, and glassmorphism.
    - Support: Empathetic copy (e.g., "You're doing great, but maybe take tonight for yourself?").
    - Distraction-Free: Notifications respect "Quiet Hours" and "Preferred Reminder Times."

## 5. Database Schema: Relationship CRM
The data model treats sentiment as a core metric:
- **`Relationships`**: Tracks status (Colleague/Friend), Cadence, and "Sentiment History."
- **`Events`**: Stores planned SLU impact vs. actual "Reflection Delta."
- **`SentimentFeedback`**: Energizing, Neutral, Draining, or Deep.
- **`Aggregates`**: Real-time rollups of Daily and Weekly SLU levels.

## 6. Prototype "Steel Thread" Scope
1. **Onboarding**: Name, Status, Initial $P_m$ selection.
2. **Dashboard**: Social Bar with "Ghost Bar" projection.
3. **Event Creation**: Quick Call (15m) / Deep-Connection (1hr) with real-time SLU impact preview.
4. **The Loop**: Event completion → Reflection prompt → Algorithm update.
