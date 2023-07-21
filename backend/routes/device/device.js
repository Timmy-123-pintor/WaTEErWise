// customer.js
const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

router.get('/', customerController.getCustomerData);
router.get('/bills', customerController.getCustomerBills);
router.post('/limit', customerController.setWaterLimit);

module.exports = router;