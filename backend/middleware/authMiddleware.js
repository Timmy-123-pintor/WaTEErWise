import firebaseAdmin from 'firebase-admin';

const { auth } = firebaseAdmin;

export const authMiddleware = async (req, res, next) => {
  // Extract the token from the 'Authorization' header
  const headerToken = req.headers.authorization;

  // If no token is provided, respond with 401 status
  if (!headerToken) {
    return res.status(401).send({ message: 'No token provided' });
  }

  // Check if the token is in the correct format (i.e., 'Bearer <token>')
  if (headerToken.startsWith('Bearer ')) {
    const idToken = headerToken.split('Bearer ')[1];

    try {
      // Verify the token
      const decodedToken = await auth().verifyIdToken(idToken);

      // Attach the decoded token to the request object
      req.user = decodedToken;

      // Call the next middleware function
      next();
    } catch (e) {
      // If token verification fails, respond with 401 status
      return res.status(401).send({ message: 'Invalid token' });
    }
  } else {
    // If the token is not in the correct format, respond with 401 status
    return res.status(401).send({ message: 'Unauthorized request' });
  }
};

export const checkRole = (role) => async (req, res, next) => {
  try {
    // If user does not have the right role, respond with 403 status
    if (req.user.role !== role) {
      return res.status(403).send({ message: 'Forbidden' });
    }
    // If user has the right role, call the next middleware function
    next();
  } catch (e) {
    // If something goes wrong, respond with 500 status
    return res.status(500).send({ message: 'Internal Server Error' });
  }
};
