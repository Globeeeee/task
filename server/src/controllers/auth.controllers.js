import UsersService from '../services/users.services.js';

async function login(req, res) {
  const email = (req.body && req.body.email) || '';
  const password = (req.body && req.body.password) || '';
  const apiKey = process.env.FIREBASE_API_KEY;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'email and password required' });
  }
  if (!apiKey) {
    return res.status(500).json({ success: false, message: 'FIREBASE_API_KEY missing in server .env' });
  }

  try {
    const url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=' + apiKey;
    const fbRes = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    });
    const fb = await fbRes.json();

    if (!fbRes.ok) {
      return res.status(401).json({
        success: false,
        message: (fb.error && fb.error.message) || 'login failed',
      });
    }

    const profile = await UsersService.findUserByEmail(email);
    const role = (profile && profile.role) || 'customer';

    if (role !== 'admin') {
      return res.status(403).json({ success: false, message: 'admin only' });
    }

    return res.json({
      success: true,
      data: {
        token: fb.idToken,
        email,
        role,
        name: (profile && profile.name) || email,
      },
    });
  } catch (e) {
    console.log('login err', e.message);
    return res.status(500).json({ success: false, message: 'login failed' });
  }
}

function me(req, res) {
  res.json({
    success: true,
    message: 'ok',
    data: {
      uid: req.user.uid,
      email: req.user.email,
      role: req.user.role,
      name: req.user.name,
    },
  });
}

export default { login, me };
