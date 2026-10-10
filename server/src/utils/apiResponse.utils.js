function ok(res, data, msg = 'ok', code = 200) {
  return res.status(code).json({ success: true, message: msg, data });
}

function fail(res, msg, code = 500, data = null) {
  return res.status(code).json({ success: false, message: msg, data });
}

export default {
  success: (res, message, data, statusCode) => ok(res, data, message, statusCode || 200),
  error: (res, message, data, statusCode) => fail(res, message, statusCode || 500, data),
  badRequest: (res, message) => fail(res, message || 'bad request', 400),
  unauthorized: (res, message) => fail(res, message || 'unauthorized', 401),
  forbidden: (res, message) => fail(res, message || 'forbidden', 403),
};
