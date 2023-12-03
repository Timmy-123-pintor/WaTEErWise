import pkg from "firebase-admin";
const { auth, firestore } = pkg;

export async function login(req, res) {
  try {
    const idToken = req.body.idToken;

    // Verify the ID token
    const decodedToken = await auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // Retrieve user record from Firestore
    const userDocument = await firestore().collection("users").doc(uid).get();
    const userData = userDocument.data();

    if (!userData) {
      return res.status(404).send({ message: "User not found in Firestore." });
    }

    // Ensure that userData.role is set; if not, set it to a default value such as "user"
    userData.role = userData.role || 'user';

    // Send back the user's data
    res.status(200).send({
      userId: uid,
      email: userData.email,
      role: userData.role,
    });

  } catch (err) {
    console.error('Error in login:', err);
    res.status(500).send({ message: `Error logging in user: ${err.message}` });
  }
}