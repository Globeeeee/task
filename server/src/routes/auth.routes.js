import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import AuthController from '../controllers/auth.controllers.js';

const router = express.Router();

router.get('/me', authMiddleware, AuthController.me);

export default router;
