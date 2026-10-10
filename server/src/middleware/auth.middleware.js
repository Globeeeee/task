import Firebase from '../../config/firebase.config.js';
import UsersService from '../services/users.services.js';

const authMiddleware = async (req, res, next) => {
  const header = req.headers.authorization || '';
  if (!header.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'missing token' });
  }

  const idToken = header.slice(7);

  try {
    const decoded = await Firebase.auth.verifyIdToken(idToken);
    let role = 'customer';
    let name = decoded.name || null;

    if (decoded.email) {
      const profile = await UsersService.findUserByEmail(decoded.email);
      if (profile) {
        role = profile.role || role;
        name = profile.name || name;
      }
    }

    req.user = {
      uid: decoded.uid,
      email: decoded.email || null,
      role,
      name,
    };
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: 'invalid token' });
  }
};

export default authMiddleware;
