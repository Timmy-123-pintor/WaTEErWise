import firebaseAdmin from 'firebase-admin';

const { auth } = firebaseAdmin;

export const authMiddleware = async (req, res, next) => {

  const headerToken = req.headers.authorization;

  if (!headerToken) {
    return res.status(401).send({ message: 'No token provided' });
  }

  if (headerToken.startsWith('Bearer ')) {
    const idToken = headerToken.split('Bearer ')[1];

    try {
      const decodedToken = await auth().verifyIdToken(idToken);

      req.user = decodedToken;

      next();
    } catch (e) {
      console.error(e);
      return res.status(401).send({ message: 'Invalid token' });
    }
  } else {
    return res.status(401).send({ message: 'Unauthorized request' });
  }
};

export const checkRole = (role) => async (req, res, next) => {
  try {
    if (req.user.role !== role) {
      return res.status(403).send({ message: 'Forbidden' });
    }
    next();
  } catch (e) {
    return res.status(500).send({ message: 'Internal Server Error' });
  }
};