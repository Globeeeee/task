const _friendly = {
  'INVALID_LOGIN_CREDENTIALS': 'Invalid email or password',
  'EMAIL_NOT_FOUND': 'Invalid email or password',
  'INVALID_PASSWORD': 'Invalid email or password',
  'INVALID_EMAIL': 'Enter a valid email address',
  'USER_DISABLED': 'This account has been disabled',
  'TOO_MANY_ATTEMPTS_TRY_LATER': 'Too many attempts. Try again later',
  'NETWORK_ERROR': 'Network error. Check your connection',
};

String cleanErr(Object e) {
  final raw = e.toString().replaceFirst('Exception: ', '').trim();
  return _friendly[raw] ?? raw;
}
