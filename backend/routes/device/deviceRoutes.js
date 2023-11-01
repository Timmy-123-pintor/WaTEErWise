import { Router } from 'express';
import { getDeviceData, updateDeviceSettings, getCurrentUsage, publishAction, register, listDevices } from '../../controllers/device/deviceController.js';
import { getAllDevices } from '../../services/device/deviceServices.js';
import { authMiddleware } from '../../middleware/authMiddleware.js';

const router = Router();

router.post('/register', authMiddleware, register);
router.get('/list', listDevices);
// router.put('/:id/token/regenerate', regenerateToken);
// router.delete('/:id', deleteDevice);
router.get('/all-devices', async (req, res) => {
    try {
      const devices = await getAllDevices();
      res.status(200).json(devices);
    } catch (error) {
      res.status(500).send({ message: 'Error fetching devices', error: error.message });
    }
  });
router.post('/update-device-status', updateDeviceSettings);

export default router;
