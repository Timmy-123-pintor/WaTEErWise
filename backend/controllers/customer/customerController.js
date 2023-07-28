import firebaseAdmin from 'firebase-admin';
import { 
  fetchCustomerData, 
  fetchCustomerBills, 
  setWaterLimit as setWaterLimitService 
} from '../../services/customer/customerServices.js';

const { auth } = firebaseAdmin;

export async function getCustomerData(req, res) {
  try {
    const data = await fetchCustomerData(req.params.id); 
    res.json(data);
  } catch (error) {
    res.status(500).send({ message: `Failed to get customer data: ${error.message}` });
  }
}

export async function getCustomerBills(req, res) {
  try {
    const bills = await fetchCustomerBills(req.params.id); 
    res.json(bills);
  } catch (error) {
    res.status(500).send({ message: `Failed to get customer bills: ${error.message}` });
  }
}

export async function setWaterLimit(req, res) {
  try {
    const { limit } = req.body;
    await setWaterLimitService(req.params.id, limit); 
    res.status(200).send({ message: `Water limit has been set to ${limit}` });
  } catch (error) {
    res.status(500).send({ message: `Failed to set water limit: ${error.message}` });
  }
}

export async function setAdmin(req, res) {
  const { email } = req.body;
  
  try {
    const user = await auth().getUserByEmail(email);
    await auth().setCustomUserClaims(user.uid, { role: 'admin' });
    res.status(200).send({ message: `Success! ${email} has been made an admin.` });
  } catch (error) {
    res.status(500).send({ message: `Failed to set admin role: ${error.message}` });
  }
}
