import BookingsService from '../services/bookings.services.js';
import StylistsService from '../services/stylists.services.js';
import ServicesService from '../services/services.services.js';
import ApiResponse from '../utils/apiResponse.utils.js';
import { normalizeSlot } from '../utils/slot.utils.js';

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

export async function createBooking(req, res) {
  const { stylistId, serviceId, customerName, slotStart } = req.body || {};
  const start = normalizeSlot(slotStart);

  if (!stylistId || !serviceId || !customerName || !start) {
    return ApiResponse.badRequest(
      res,
      'missing values',
    );
  }

  try {
    const stylist = await StylistsService.getStylistById(stylistId);
    const service = await ServicesService.getServiceById(serviceId);
    if (!stylist) return ApiResponse.badRequest(res, 'stylist not found');
    if (!service) return ApiResponse.badRequest(res, 'service not found');

    const end = new Date(start.getTime() + 30 * 60 * 1000);
    const now = new Date().toISOString();

    const created = await BookingsService.placeBooking({
      customerId: req.user.uid,
      customerName,
      serviceId: service.id,
      serviceName: service.name,
      stylistId: stylist.id,
      stylistName: stylist.name,
      slotStart: start.toISOString(),
      slotEnd: end.toISOString(),
      status: 'pending',
      createdAt: now,
      updatedAt: now,
    });

    return ApiResponse.success(res, 'created', created, 201);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'booking failed', null, e.statusCode || 500);
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

export async function removeBooking(req, res) {
  try {
    await BookingsService.deleteBooking(req.params.id);
    return ApiResponse.success(res, 'deleted', null);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'delete failed', null, e.statusCode || 500);
  }
}

export default { listBookings, createBooking, updateStatus, removeBooking };
