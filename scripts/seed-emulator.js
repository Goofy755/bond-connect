/**
 * BondConnect: Emulator Seeding Utility
 * Seeds the Firestore emulator with test data (Users, Relationships, Events).
 */

const admin = require('firebase-admin');

// Point to the emulator
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';

admin.initializeApp({
  projectId: 'bondconnect-dev'
});

const db = admin.firestore();

async function seed() {
  console.log('🌱 Seeding Firestore Emulator...');

  const testUser = {
    displayName: 'Mike (Tester)',
    email: 'mike@example.com',
    personalityType: 'introvert',
    personalityMultiplier: 1.4,
    weeklyCapacityTarget: 80,
    timezone: 'America/Los_Angeles',
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  };

  const socialState = {
    dailyCapacityPct: 15,
    dailySluUsed: 0.75,
    weeklyCapacityPct: 45,
    stage: 'balance',
    isolationDrainActive: false,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  };

  // 1. Create User
  const userRef = db.collection('users').doc('tester_mike');
  await userRef.set(testUser);
  await userRef.collection('socialState').doc('current').set(socialState);

  // 2. Create a Contact
  const contactRef = userRef.collection('relationships').doc('contact_sarah');
  await contactRef.set({
    contactName: 'Sarah',
    contactType: 'friend',
    sentimentTrend: 'positive',
    socialBarWithContact: {
      dailySluAvailable: 2,
      stage: 'thriving'
    }
  });

  console.log('✅ Seeding complete!');
  process.exit(0);
}

seed().catch(err => {
  console.error('❌ Seeding failed:', err);
  process.exit(1);
});
