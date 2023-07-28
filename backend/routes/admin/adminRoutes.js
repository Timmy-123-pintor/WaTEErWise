import { Router } from 'express';
import setAdminRole from '../../controllers/admin/adminController.js';
import { getCustomerData, getCustomerBills, setWaterLimit } from '../../controllers/customer/customerController.js';
import { authMiddleware, checkRole } from '../../middleware/authMiddleware.js';

const router = Router();

router.get('/', authMiddleware, checkRole('admin'), getCustomerData);
router.get('/bills/:userId', authMiddleware, getCustomerBills); // Include the userId in the route
router.post('/limit/:userId', authMiddleware, setWaterLimit); // Include the userId in the route
router.post('/setAdmin', authMiddleware, checkRole('admin'), setAdminRole);

router.post('/login', (req, res) => {
    const { email, password } = req.body;
    
    auth().signInWithEmailAndPassword(email, password)
    .then((userCredential) => {
        const user = userCredential.user;

        // Fetch additional user info from Firebase
        auth().getUser(user.uid)
        .then((userRecord) => {
            // Check if user has admin role
            if (userRecord.customClaims && userRecord.customClaims.role === 'admin') {
                res.json({ status: "success", message: "Admin logged in", data: user });
            } else {
                res.json({ status: "error", message: "User is not an admin" });
            }
        })
        .catch((error) => {
            res.json({ status: "error", message: error.message });
        });
    })
    .catch((error) => {
        res.json({ status: "error", message: error.message });
    });
});

export default router;
