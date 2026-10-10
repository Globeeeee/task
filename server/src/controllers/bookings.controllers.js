import BookingsService from '../services/bookings.services.js';
import StylistsService from '../services/stylists.services.js';
import ServicesService from '../services/services.services.js';
import ApiResponse from '../utils/apiResponse.utils.js';
import { normalizeSlot } from '../utils/slot.utils.js';

async function createBooking(req, res) {
  const { stylistId, serviceId, customerName, slotStart } = req.body || {};
  const start = normalizeSlot(slotStart);

  if (!stylistId || !serviceId || !customerName || !start) {
    return ApiResponse.badRequest(res, 'need stylistId, serviceId, customerName, and slot on :00/:30 UTC');
  }

  try {
    const stylist = await StylistsService.getStylistById(stylistId);
    const service = await ServicesService.getServiceById(serviceId);
    if (!stylist) return ApiResponse.badRequest(res, 'stylist not found');
    if (!service) return ApiResponse.badRequest(res, 'service not found');

    const end = new Date(start.getTime() + 30 * 60 * 1000);

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
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });

    return ApiResponse.success(res, 'created', created, 201);
  } catch (e) {
    return ApiResponse.error(res, e.message || 'booking failed', null, e.statusCode || 500);
  }
}

export default { createBooking };
