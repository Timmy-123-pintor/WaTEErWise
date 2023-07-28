import { Router } from 'express';
import { getDeviceData, updateDeviceSettings, getCurrentUsage } from '../../controllers/device/deviceController.js';

const router = Router();

router.get('/:id', getDeviceData);
router.put('/:id/settings', updateDeviceSettings);
router.get('/:id/usage', getCurrentUsage);

export default router;
