// customerRoutes.js
import { Router } from 'express';
const router = Router();
import { getCustomerData, getCustomerBills, setWaterLimit } from '../../controllers/customer/customerController.js';
 

router.get('/', getCustomerData);
router.get('/bills', getCustomerBills);
router.post('/limit', setWaterLimit);

export default router;
 