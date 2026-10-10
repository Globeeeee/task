export default {
  me(req, res) {
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
  },
};
