import express from 'express';
import authRouter from './auth.routes.js';
import bookingsRouter from './bookings.routes.js';
import adminBookingsRouter from './adminBookings.routes.js';
import stylistsRouter from './stylists.routes.js';
import servicesRouter from './services.routes.js';

const router = express.Router();

router.use('/auth', authRouter);
router.use('/bookings', bookingsRouter);
router.use('/admin/bookings', adminBookingsRouter);
router.use('/stylists', stylistsRouter);
router.use('/services', servicesRouter);

export default router;
