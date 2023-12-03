import express from 'express';
import cors from 'cors';
import { connect as connectMQTT } from './services/mqtt/mqttService.js';

import apiEndPoint from '../backend/services/API/apiEndPoint.js'
import graphEndPoint from '../backend/services/API/graphEndPoint.js'
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api', apiEndPoint);
app.use('/graph', graphEndPoint);

import customerRoutes from './routes/customer/customerRoutes.js';
import adminRoutes from './routes/admin/adminRoutes.js';
import deviceRoutes from './routes/device/deviceRoutes.js';
import userRoutes from './routes/user/userRoutes.js';


// app.use('/api', apiEndPoint);

// Use the routes
app.use('/customer', customerRoutes);
app.use('/admin', adminRoutes);
app.use('/device', deviceRoutes);
app.use('/user', userRoutes);
app.use('/upload', fileUploadRouter(firebaseBucket));
app.use(function (err, _req, res, _next) {
    console.error(err.stack);
    res.status(500).send('An error occurred. Please check the server logs for more details.');
  });

const port = process.env.PORT || 3000;

connectMQTT();

app.listen(port, '0.0.0.0', () => console.log(`Server is listening on port ${port}`));
