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
