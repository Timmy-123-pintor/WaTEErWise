import firebaseAdmin, { auth, db } from './firebase.js';

const setAdminClaim = async (email) => {
  // Get the user by email
  const user = await auth.getUserByEmail(email);

  // Set the custom user claims
  await auth.setCustomUserClaims(user.uid, { role: 'admin' });

  // Get the Firestore user document
  const userDoc = db.collection('users').doc(user.uid);

  // Get the user document snapshot
  const docSnapshot = await userDoc.get();

  // Check if the document exists
  if (!docSnapshot.exists) {
    // If the document does not exist, create it
    await userDoc.set({ 
        role: 'admin',
        email: user.email, 
        displayName: user.displayName || 'No display name provided' 
    });
  } else {
    // If the document exists, update it
    await userDoc.update({ role: 'admin' });
  }

  console.log(`${email} is now an admin`);
};

// Set an admin email :)
setAdminClaim('waterwiseplus.20@gmail.com').catch(console.error);
