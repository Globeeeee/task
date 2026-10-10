import BookingsService from '../services/bookings.services.js';
import ApiResponse from '../utils/apiResponse.utils.js';

async function listBookings(req, res) {
  try {
    const status = req.query.status || null;
    const bookings = await BookingsService.listBookings(status);
    return ApiResponse.success(res, 'ok', bookings);
  } catch (e) {
    console.log('list bookings err', e.message);
    return ApiResponse.error(res, e.message || 'could not load bookings');
  }
}

async function createBooking(req, res) {
  const { stylistId, serviceId, customerName, slotStart } = req.body || {};

  try {
    const created = await BookingsService.createBooking({
      stylistId,
      serviceId,
      customerName,
      slotStart,
      customerId: req.user.uid,
    });
    return ApiResponse.success(res, 'created', created, 201);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'booking failed', null, e.statusCode || 500);
  }
}

async function updateStatus(req, res) {
  const id = req.params.id;
  const next = req.body?.status;

  if (next !== 'confirmed' && next !== 'cancelled') {
    return ApiResponse.badRequest(res, 'status must be confirmed or cancelled');
  }

  try {
    const updated = await BookingsService.changeStatus(id, next, req.user.uid);
    return ApiResponse.success(res, 'updated', updated);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'update failed', null, e.statusCode || 500);
  }
}

async function removeBooking(req, res) {
  try {
    await BookingsService.deleteBooking(req.params.id);
    return ApiResponse.success(res, 'deleted', null);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'delete failed', null, e.statusCode || 500);
  }
}

export default { listBookings, createBooking, updateStatus, removeBooking };
