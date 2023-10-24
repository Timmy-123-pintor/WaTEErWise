import firebaseAdmin from 'firebase-admin';

const { database } = firebaseAdmin;

export async function getDeviceById(id) {
  const snapshot = await database().ref('/devices/' + id).once('value');
  return snapshot.val();
}

export async function updateDeviceInDatabase(id, settings) {
  const ref = database().ref('/devices/' + id);
  await ref.update({settings: settings});
  
  const snapshot = await ref.once('value');
  return snapshot.val();
}

export async function calculateCurrentUsage(id) {
  const snapshot = await database().ref('/devices/' + id).once('value');
  const deviceData = snapshot.val();

  const usage = deviceData.settings * 100;

  return usage;
}

export async function deleteDeviceFromDatabase(id) {
  const ref = database().ref('/devices/' + id);
  await ref.remove();
}

export async function getAllDevices() {
  try {
      const devicesSnapshot = await database().ref('devices').once('value');
      const devices = devicesSnapshot.val();

      const devicesArray = [];
      for (let deviceId in devices) {
          const device = devices[deviceId];
          device.id = deviceId;  // Add the Firebase node key to the device data
          devicesArray.push(device);
      }

      return devicesArray;
  } catch (error) {
      throw new Error("Failed to fetch devices from Firebase");
  }
}
