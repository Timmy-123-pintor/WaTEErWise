// adminController.js
import firebaseAdmin from 'firebase-admin';

const { auth } = firebaseAdmin;

const setAdminRole = async (req, res) => {
  // Make sure user is authenticated and has admin role
  if (req.user && req.user.role === 'admin') {
    try {
      const user = await auth().getUserByEmail(req.body.email);
      await auth().setCustomUserClaims(user.uid, {
        role: 'admin',
      });
      res.send({ message: `Success! ${req.body.email} has been made an admin.` });
    } catch (err) {
      // Log the actual error message for debugging, but send a generic error message to the client
      console.error(err);
      res.status(500).send({ message: 'An error occurred. Please try again later.' });
    }
  } else {
    // If user is not authenticated or does not have admin role, return unauthorized
    res.status(403).send({ message: 'Unauthorized.' });
  }
};


export default setAdminRole;
