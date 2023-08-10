import pkg from "firebase-admin";
const { auth, firestore } = pkg;

export async function register(req, res) {
  try {
    const userRecord = await auth().createUser({
      email: req.body.email,
      password: req.body.password,
      displayName: `${req.body.firstName} ${req.body.lastName}`,
    });

    await auth().setCustomUserClaims(userRecord.uid, { role: "user" });

    await firestore().collection("users").doc(userRecord.uid).set({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      email: req.body.email,
      role: "user",
    });

    res
      .status(201)
      .send({
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
}

export async function login(req, res) {
  try {
    const userRecord = await auth().getUserByEmail(req.body.email);

    const customToken = await auth().createCustomToken(userRecord.uid);

    res.status(200).send({ token: customToken });
  } catch (err) {
    res.status(500).send({ message: `Error logging in user: ${err.message}` });
  }
}
