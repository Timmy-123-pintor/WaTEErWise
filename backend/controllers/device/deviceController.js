import { getDeviceById, updateDeviceInDatabase, calculateCurrentUsage } from '../../services/device/deviceServices.js';

export async function getDeviceData(req, res) {
  const data = await getDeviceById(req.params.id);
  res.json(data);
}

export async function updateDeviceSettings(req, res) {
  const updatedDevice = await updateDeviceInDatabase(req.params.id, req.body.settings);
  res.json(updatedDevice);
}

export async function getCurrentUsage(req, res) {
  const usage = await calculateCurrentUsage(req.params.id);
  res.json(usage);
}
