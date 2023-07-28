// controllers/userController.js
import pkg from 'firebase-admin';
const { auth, firestore } = pkg;

export async function register(req, res) {
  try {
    // Create user
    const userRecord = await auth().createUser({
      email: req.body.email,
      password: req.body.password,
      displayName: `${req.body.firstName} ${req.body.lastName}`
    });

    // Set custom claims for this user.
    // All new users will have the 'user' role
    await auth().setCustomUserClaims(userRecord.uid, { role: 'user' });

    // Create a new document in Firestore with the same ID as the new user
    await firestore().collection('users').doc(userRecord.uid).set({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      email: req.body.email,
      role: 'user'  // All new users will have the 'user' role
    });

    // Send back a response
    res.status(201).send({ status: 'Server Error: 201', message: `User created successfully with ID: ${userRecord.uid}` });
  } catch (err) {
    res.status(500).send({ message: `Error creating user: ${err.message}` });
  }
}

export async function login(req, res) {
    try {
        // Get the user by email
        const userRecord = await auth().getUserByEmail(req.body.email);

        // Generate a custom token
        const customToken = await auth().createCustomToken(userRecord.uid);

        // Send the JWT to the client
        res.status(200).send({ token: customToken });
    } catch (err) {
        res.status(500).send({ message: `Error logging in user: ${err.message}` });
    }
}
