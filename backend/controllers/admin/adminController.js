import firebaseAdmin from 'firebase-admin';
import listAllUsers from '../../services/admin/adminServices.js';

const { auth, firestore} = firebaseAdmin;

export async function register(req, res) {
  try {
    // Create a user in Firebase Authentication
    const userRecord = await auth().createUser({
      email: req.body.email,
      displayName: `${req.body.firstName} ${req.body.lastName}`,
      password: req.body.password,
    });

    if (!userRecord) {
      throw new Error('Failed to create user in Firebase Authentication');
    }

    // Store additional user details in Firestore
    await firestore().collection("users").doc(userRecord.uid).set({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      email: req.body.email,
      role: "user",
      location: req.body.location,
      deviceName: req.body.deviceName,
      deviceType: req.body.deviceType,
      // Add other user details
    });

    res.status(201).send({
      status: "Success",
      message: "User created successfully",
      userId: userRecord.uid,
    });
  } catch (err) {
    const errorMessage =
      err.code === "auth/email-already-exists"
        ? "Email already exists. Please try again."
        : "Error! Input email or password. Please try again.";

    res.status(400).send({ status: "Error", message: errorMessage });
  }
};

const setAdminRole = async (req, res) => {

  if (req.user && req.user.role === 'admin') {
    try {
      const user = await auth().getUserByEmail(req.body.email);
      await auth().setCustomUserClaims(user.uid, {
        role: 'admin',
      });
      res.send({ message: `Success! ${req.body.email} has been made an admin.` });
    } catch (err) {
      console.error(err);
      res.status(500).send({ message: 'An error occurred. Please try again later.' });
    }
  } else {
    res.status(403).send({ message: 'Unauthorized.' });
  }
};

const getAllUsers = async (req, res) => {
  if (req.user && req.user.role === 'admin') {
    try {
      const users = await listAllUsers();
      res.send(users);
    } catch (err) {
      console.error(err);
      res.status(500).send({ message: 'An error occurred. Please try again later.' });
    }
  } else {
    res.status(403).send({ message: 'Unauthorized.' });
  }
};

export { setAdminRole, getAllUsers};
