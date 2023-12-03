import { Router } from 'express';
import { login } from '../../controllers/user/userController.js';

const router = Router();

router.post('/login', login);

export default router;
