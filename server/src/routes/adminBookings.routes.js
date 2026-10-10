import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import adminMiddleware from '../middleware/admin.middleware.js';
import AdminBookingsController from '../controllers/adminBookings.controllers.js';

const router = express.Router();

router.get('/', authMiddleware, adminMiddleware, AdminBookingsController.listBookings);
router.patch(
  '/:id/status',
  authMiddleware,
  adminMiddleware,
  AdminBookingsController.updateStatus,
);

export default router;
