import express from 'express';
import authMiddleware from '../middleware/auth.middleware.js';
import adminMiddleware from '../middleware/admin.middleware.js';
import StylistsService from '../services/stylists.services.js';

const router = express.Router();
const admin = [authMiddleware, adminMiddleware];

router.get('/', async (_req, res) => {
  try {
    const stylists = await StylistsService.listStylists();
    res.json({ success: true, data: stylists });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

router.post('/', ...admin, async (req, res) => {
  const name = (req.body?.name || '').trim();
  if (!name) return res.status(400).json({ success: false, message: 'name required' });
  try {
    const created = await StylistsService.addStylist({ name });
    res.status(201).json({ success: true, data: created });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

router.patch('/:id', ...admin, async (req, res) => {
  const name = (req.body?.name || '').trim();
  if (!name) return res.status(400).json({ success: false, message: 'name required' });
  try {
    const updated = await StylistsService.updateStylist(req.params.id, { name });
    if (!updated) return res.status(404).json({ success: false, message: 'not found' });
    res.json({ success: true, data: updated });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

router.delete('/:id', ...admin, async (req, res) => {
  try {
    const ok = await StylistsService.deleteStylist(req.params.id);
    if (!ok) return res.status(404).json({ success: false, message: 'not found' });
    res.json({ success: true, message: 'deleted' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

export default router;
