import firebaseAdmin from 'firebase-admin';
import listAllUsers from '../../services/admin/adminServices.js';

const { auth } = firebaseAdmin;

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

export { setAdminRole, getAllUsers };
