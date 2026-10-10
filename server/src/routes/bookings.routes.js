import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import BookingsController from '../controllers/bookings.controllers.js';

const router = express.Router();

router.post('/', authMiddleware, BookingsController.createBooking);

export default router;
