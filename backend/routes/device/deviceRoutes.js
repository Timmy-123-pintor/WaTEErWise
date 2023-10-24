import { Router } from 'express';
import { getDeviceData, 
         updateDeviceSettings, 
         getCurrentUsage, 
         publishAction, 
         register, 
         listDevices,
         regenerateToken,
         deleteDevice, 
         updateDeviceStatus } from '../../controllers/device/deviceController.js';

const router = Router();

router.post('/register', register);
router.get('/list', listDevices);
router.put('/:id/token/regenerate', regenerateToken);
router.delete('/:id', deleteDevice);
router.post('/update-device-status', updateDeviceSettings);

export default router;
