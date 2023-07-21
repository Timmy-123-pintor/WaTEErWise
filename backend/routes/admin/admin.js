// customer.js
const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');
const firebase = require('firebase');

router.get('/', customerController.getCustomerData);
router.get('/bills', customerController.getCustomerBills);
router.post('/limit', customerController.setWaterLimit);
router.post('/setAdmin', adminController.setAdmin);

router.post('/login', (req, res) => {
    const { email, password } = req.body;
    
    firebase.auth().signInWithEmailAndPassword(email, password)
    .then((userCredential) => {
        // If sign in is successful, user data will be in userCredential
        const user = userCredential.user;
        
        // Here we are checking if the email belongs to an admin
        // Replace 'admin@example.com' with actual admin emails
        if (email === 'admin@example.com') {
            res.json({ status: "success", message: "Admin logged in", data: user });
        } else {
            res.json({ status: "error", message: "User is not an admin" });
        }
    })
    .catch((error) => {
        res.json({ status: "error", message: error.message });
    });
});

module.exports = router;