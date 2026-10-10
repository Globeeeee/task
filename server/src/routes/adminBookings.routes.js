import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import adminMiddleware from '../middleware/admin.middleware.js';
import BookingsController from '../controllers/bookings.controllers.js';

const router = express.Router();
const admin = [authMiddleware, adminMiddleware];

router.get('/', ...admin, BookingsController.listBookings);
router.post('/', ...admin, BookingsController.createBooking);
router.patch('/:id/status', ...admin, BookingsController.updateStatus);
router.delete('/:id', ...admin, BookingsController.removeBooking);

export default router;
