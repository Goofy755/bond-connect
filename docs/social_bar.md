# BondConnect: Social Bar Algorithm (v1.1)
*Last Updated: February 2026*

## 1. Overview
The **Social Bar** is a core psychological metaphor and data-driven tool designed to help users manage their social energy. While not a medical diagnosis, it represents the finite amount of mental and emotional energy an individual has for social interaction before feeling overstimulated or withdrawn.

## 2. The Core Algorithm
The **Impact on Social Bar ($I$)** for a specific event is calculated using the following variables:

$$I = (Duration \times PersonalityMultiplier) + EnvironmentWeight + InteractionIntensity - ConnectionBonus$$

---

## 3. Variable Definitions & Research Evidence

### A. Duration & The Fatigue Curve
Socializing is a form of cognitive and emotional "work" for the brain.
*   **The 3-Hour Fatigue Rule:** Research found that regardless of whether a person is an introvert or extrovert, they report higher levels of fatigue after approximately **three hours** of socializing.
*   **Lagged Fatigue Effect:** Social interaction often provides immediate vigor but leads to **delayed fatigue**, with peak effects occurring 2–4 hours after initial contact.

### B. Personality Multiplier ($P_m$)
Individuals process social stimulation differently at a neurological level.
*   **Introverts ($P_m > 1.0$):** Have higher baseline arousal in their nervous systems, making them more sensitive to stimulation. They expend energy during interaction and must recharge through solitude.
*   **Extroverts ($P_m \le 1.0$):** Have a more active dopamine reward system and are energized by social stimuli. While they still experience fatigue from extended interactions, their battery typically drains more slowly.

### C. Interaction Intensity ($I_i$)
The cognitive and emotional load of the social episode.
*   **High Load:** Conflict, emotional labor (managing one's tone/expressions to meet expectations), and interactions requiring high attention (group settings or meeting strangers) significantly deplete the battery.
*   **Low Load:** Small talk is generally neutral for well-being and doesn't significantly drain or boost happiness.

### D. Environment Weight ($E_w$)
*   **Stressors:** Loud, unpredictable, or crowded urban environments trigger irritation and fatigue.
*   **Restoration:** Natural environments (forests, parks with water) have a proven **restorative effect**, reducing stress, lowering heart rate, and restoring mental energy and vigor.

### E. Connection Bonus ($C_b$)
*   **Supportive Connections:** Interactions with intimate or close ties are correlated with positive psychological well-being. Social support can also suppress cortisol (stress hormone) levels.

---

## 4. Key Logic: Social Homeostasis
A critical guardrail for the "Min" stage of the bar: **Zero social contact is also draining.**
*   **Isolation as Energy Depletion:** Experimental studies show that **8 hours of social isolation** leads to lowered energetic arousal and heightened fatigue comparable to 8 hours of food deprivation.
*   **Homeostatic Response:** Lowered energy during isolation is a homeostatic adaptive response to a lack of social contact.

---

## 5. Sample Calculation Examples

| Event Scenario | Duration | $P_m$ (User Type) | $I_i$ (Intensity) | $E_w$ (Location) | $C_b$ (Relationship) | **Net Impact** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Deep Conversation in Park** | 60m | 1.5 (Introvert) | +10% (Substantive) | -15% (Nature) | -10% (Close Friend) | **-5% (Recovery)** |
| **Loud Bar / Networking** | 120m | 0.8 (Extrovert) | +20% (Strangers) | +15% (Urban/Noisy) | 0% (Weak Tie) | **+51% Drain** |
| **Solo Work / Isolation** | 480m | 1.0 (Average) | N/A | 0% (Home) | N/A | **+30% (Homeostatic)** |

---

## 6. References
- *Positive Reset Of Eatontown* - Understanding Low Social Battery (2025)
- *Forbes* - 1 Way For Introverts To Measure Their 'Social Battery' (2026)
- *PMC* - Bluetooth-sensed social presence is associated with delayed fatigue (2025)
- *Psychological Science* - Homeostatic Regulation of Energetic Arousal During Acute Social Isolation (2023)
- *ScienceDirect* - Restorative effects of visits to urban and forest environments (2014)
- *Medical News Today* - Social battery: What it is and how to recharge it (2022)
