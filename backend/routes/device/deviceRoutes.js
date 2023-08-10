import { Router } from 'express';
import { getDeviceData, updateDeviceSettings, getCurrentUsage, publishAction } from '../../controllers/device/deviceController.js';

const router = Router();

router.get('/:id', getDeviceData);
router.put('/:id/settings', updateDeviceSettings);
router.get('/:id/usage', getCurrentUsage);
router.post('/publish', publishAction);

export default router;
