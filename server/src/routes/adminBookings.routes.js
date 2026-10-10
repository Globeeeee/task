import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import adminMiddleware from '../middleware/admin.middleware.js';
import AdminBookingsController from '../controllers/adminBookings.controllers.js';

const router = express.Router();
const admin = [authMiddleware, adminMiddleware];

router.get('/', ...admin, AdminBookingsController.listBookings);
router.post('/', ...admin, AdminBookingsController.createBooking);
router.patch('/:id/status', ...admin, AdminBookingsController.updateStatus);
router.delete('/:id', ...admin, AdminBookingsController.removeBooking);

export default router;
