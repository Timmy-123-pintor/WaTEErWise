// customerService.js
const admin = require('firebase-admin');

exports.fetchCustomerData = async (id) => {
  const snapshot = await admin.database().ref('/customers/' + id).once('value');
  return snapshot.val();
};
// ...
