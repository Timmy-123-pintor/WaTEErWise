// customerController.js
const customerService = require('../services/customerService');
const admin = require('firebase-admin');

exports.getCustomerData = async (req, res) => {
  const data = await customerService.fetchCustomerData(req.params.id); // assuming id is passed in url
  res.json(data);
};

exports.setAdmin = async (req, res, next) => {
  const { email } = req.body;
  
  // Get the user and add custom claim (admin role)
  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, { role: 'admin' });
    
    res.status(200).send({ message: `Success! ${email} has been made an admin.` });
  } catch (error) {
    next(error);
  }
};
// ...
