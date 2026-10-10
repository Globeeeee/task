import express from 'express';
import ServicesService from '../services/services.services.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const services = await ServicesService.listServices();
    res.json({ success: true, data: services });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message || 'failed' });
  }
});

export default router;
