import { Router } from 'express';
import { startOfWeek, startOfMonth, isSameWeek, isSameMonth } from 'date-fns';
import firebaseAdmin from '../../firebase.js';

const router = Router();

// Existing endpoint to fetch sensor data
router.get('/sensor/:userEmail/:sensorId/:dataType?', async (req, res) => {
  try {
    const { userEmail, sensorId, dataType } = req.params;
    const userPath = userEmail.replace('@', '_at_').replace(/\./g, '_dot_');

    const sensorRef = firebaseAdmin.database().ref(`user/${userPath}/sensors/${sensorId}`);
    const snapshot = await sensorRef.once('value');
    const sensorData = snapshot.val();

    if (sensorData) {
      if (dataType) {
        switch (dataType) {
          case 'totalLiters':
            res.json({ totalLiters: sensorData.totalLiters });
            break;

          default:
            res.status(400).json({ error: 'Invalid data type requested' });
        }
      } else {
        res.json(sensorData);
      }
    } else {
      res.status(404).json({ error: 'Sensor data not found' });
    }
  } catch (error) {
    console.error('Error fetching sensor data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Existing endpoint to get sensorId
router.get('/getSensorId/:userEmail', async (req, res) => {
  try {
    const { userEmail } = req.params;
    const userPath = userEmail.replace('@', '_at_').replace(/\./g, '_dot_');

    const userRef = firebaseAdmin.database().ref(`user/${userPath}`);
    const snapshot = await userRef.once('value');
    const userData = snapshot.val();

    if (userData && userData.sensors) {
      const sensorId = Object.keys(userData.sensors)[0];
      res.json({ sensorId });
    } else {
      res.status(404).json({ error: 'User data not found or no sensors available' });
    }
  } catch (error) {
    console.error('Error fetching user data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// New endpoint to fetch weekly data
router.get('/sensor/:userEmail/:sensorId/weeklyData', async (req, res) => {
  try {
    const { userEmail, sensorId } = req.params;
    const userPath = userEmail.replace('@', '_at_').replace(/\./g, '_dot_');

    const sensorRef = firebaseAdmin.database().ref(`user/${userPath}/sensors/${sensorId}`);
    const snapshot = await sensorRef.once('value');
    const sensorData = snapshot.val();

    if (sensorData && sensorData.weeklyData) {
      res.json(sensorData.weeklyData);
    } else {
      res.status(404).json({ error: 'Weekly data not found for the sensor' });
    }
  } catch (error) {
    console.error('Error fetching weekly data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// New endpoint to fetch monthly data
router.get('/sensor/:userEmail/:sensorId/monthlyData', async (req, res) => {
  try {
    const { userEmail, sensorId } = req.params;
    const userPath = userEmail.replace('@', '_at_').replace(/\./g, '_dot_');

    const sensorRef = firebaseAdmin.database().ref(`user/${userPath}/sensors/${sensorId}`);
    const snapshot = await sensorRef.once('value');
    const sensorData = snapshot.val();

    if (sensorData && sensorData.monthlyData) {
      res.json(sensorData.monthlyData);
    } else {
      res.status(404).json({ error: 'Monthly data not found for the sensor' });
    }
  } catch (error) {
    console.error('Error fetching monthly data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Generic route for handling 404
router.get('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

export default router;
