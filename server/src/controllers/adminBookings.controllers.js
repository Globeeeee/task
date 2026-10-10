import BookingsService from '../services/bookings.services.js';
import ApiResponse from '../utils/apiResponse.utils.js';

export async function listBookings(req, res) {
  try {
    const status = req.query.status || null;
    const bookings = await BookingsService.listBookings(status);
    return ApiResponse.success(res, 'ok', bookings);
  } catch (e) {
    console.log('list bookings err', e.message);
    return ApiResponse.error(res, e.message || 'could not load bookings');
  }
}

export async function updateStatus(req, res) {
  const id = req.params.id;
  const next = req.body?.status;

  if (next !== 'confirmed' && next !== 'cancelled') {
    return res.status(400).json({ success: false, message: 'status must be confirmed or cancelled' });
  }

  try {
    const updated = await BookingsService.changeStatus(id, next, req.user.uid);
    return ApiResponse.success(res, 'updated', updated);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'update failed', null, e.statusCode || 500);
  }
}

export default { listBookings, updateStatus };
