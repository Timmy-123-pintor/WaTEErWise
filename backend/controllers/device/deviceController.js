import { getDeviceById, updateDeviceInDatabase, calculateCurrentUsage, getAllDevices } from '../../services/device/deviceServices.js';
import { publish } from '../../services/mqtt/mqttService.js';
import { auth as deviceAuth, db as deviceDb } from '../../firebase.js';

export async function register(req, res) {
  try {
    // User Registration
    const userRecord = await auth().createUser({
      email: req.body.email,
      password: req.body.password,
      displayName: `${req.body.firstName} ${req.body.lastName}`,
    });

    await auth().setCustomUserClaims(userRecord.uid, { role: "user" });

    await firestore().collection("users").doc(userRecord.uid).set({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      email: req.body.email,
      role: "user",
    });

    // Device Registration
    if (req.body.device) {
      const { deviceName, deviceUID, deviceType } = req.body.device;
      const deviceToken = await deviceAuth().createCustomToken(deviceUID);
      await deviceDb().collection("devices").add({
        name: deviceName,
        uid: deviceUID,
        type: deviceType,
        userId: userRecord.uid, // Associate device with user
        token: deviceToken,
        registrationDate: new Date()
      });
    }

    res.status(201).send({
      status: "Success",
      message: "User and device created successfully",
      userId: userRecord.uid,
    });

  } catch (err) {
    const errorMessage =
      err.code === "auth/email-already-exists"
        ? "Email already exists. Please try again."
        : "Error! Input email or password. Please try again.";

    res.status(400).send({ status: "Error", message: errorMessage });
  }
}

export async function getDeviceData(req, res) {
  const data = await getDeviceById(req.params.id);
  res.json(data);
}

export async function updateDeviceSettings(req, res) {
  const updatedDevice = await updateDeviceInDatabase(req.params.id, req.body.settings);
  res.json(updatedDevice);
}

export async function deleteDevice(req, res) {
  try {
    await deleteDeviceFromDatabase(req.params.id);
    res.status(200).send({ success: true, message: 'Device deleted successfully' });
  } catch (error) {
    res.status(500).send({ success: false, message: error.message });
  }
}

export async function getCurrentUsage(req, res) {
  const usage = await calculateCurrentUsage(req.params.id);
  res.json(usage);
}

export function publishAction(req, res) {
  try {
    const { topic, message } = req.body;
    publish(topic, message);
    res.status(200).send({ success: true, message: 'Published successfully' });
  } catch (error) {
    res.status(500).send({ success: false, message: error.message });
  }
}

export async function updateDeviceStatus(req, res) {
  try {
    const { deviceId, status } = req.body;
    const ref = database().ref('/devices/' + deviceId);
    await ref.update({ status: status });
    res.status(200).send({ success: true, message: 'Device status updated successfully' });
  } catch (error) {
    res.status(500).send({ success: false, message: error.message });
  }
}

export const listDevices = async (req, res) => {
  try {
      const devices = await getAllDevices();
      res.status(200).json(devices);
  } catch (error) {
      res.status(500).json({ message: "Failed to load devices." });
  }
};

export async function regenerateToken(req, res) {
  try {
    const deviceId = req.params.id;
    // Regenerate a new token for the device
    const newToken = "Your logic to generate a new token"; 

    const ref = database().ref('/devices/' + deviceId);
    await ref.update({ token: newToken });

    res.status(200).send({ success: true, message: 'Token regenerated successfully' });
  } catch (error) {
    res.status(500).send({ success: false, message: error.message });
  }
}
