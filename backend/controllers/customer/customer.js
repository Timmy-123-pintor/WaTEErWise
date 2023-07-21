// customerController.js
const customerService = require('../services/customerService');

exports.getCustomerData = async (req, res) => {
  const data = await customerService.fetchCustomerData(req.params.id); // assuming id is passed in url
  res.json(data);
};
// ...
