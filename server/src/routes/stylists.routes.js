import express from 'express';
import { listStylists } from '../services/stylists.services.js';

const router = express.Router();

router.get('/', async (_req, res) => {
  try {
    const stylists = await listStylists();
    res.json({ success: true, data: stylists });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

export default router;
