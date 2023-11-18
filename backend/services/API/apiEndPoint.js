import firebaseAdmin from '../../firebase.js'; 
import { Router } from 'express';
const router = Router();

// Endpoint to fetch sensor data
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
        // Return all data if dataType is not provided
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

// Add a generic route for handling 404
// router.get('*', (req, res) => {
//   res.status(404).json({ error: 'Route not found' });
// });

router.get('/getSensorId/:userEmail', async (req, res) => {
  try {
    const { userEmail } = req.params;
    const userPath = userEmail.replace('@', '_at_').replace(/\./g, '_dot_');
    
    const userRef = firebaseAdmin.database().ref(`user/${userPath}`);
    const snapshot = await userRef.once('value');
    const userData = snapshot.val();

    if (userData && userData.sensors) {
      // Extract the sensorId from the user's data
      const sensorId = Object.keys(userData.sensors)[0]; // Assuming there's only one sensor per user
      res.json({ sensorId });
    } else {
      res.status(404).json({ error: 'User data not found or no sensors available' });
    }
  } catch (error) {
    console.error('Error fetching user data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a generic route for handling 404
router.get('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

export default router;
