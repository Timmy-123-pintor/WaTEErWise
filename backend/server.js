import express from 'express';
import cors from 'cors'; 
import { connect as connectMQTT } from './services/mqtt/mqttService.js';

const app = express();

// app.use(cors({
//     origin: ['http://localhost:3000', 'http://10.0.2.2:3000', 'http://localhost:53560']
// }));
app.use(cors());

// Import the routes
import customerRoutes from './routes/customer/customerRoutes.js';
import adminRoutes from './routes/admin/adminRoutes.js';
import deviceRoutes from './routes/device/deviceRoutes.js';
import userRoutes from './routes/user/userRoutes.js';

// Middleware for parsing JSON bodies
app.use(express.json());

// Use the routes
app.use('/customer', customerRoutes);
app.use('/admin', adminRoutes);
app.use('/device', deviceRoutes);
app.use('/user', userRoutes);

const port = process.env.PORT || 3000;

// Connect to MQTT Broker
connectMQTT();

app.listen(port, '0.0.0.0', () => console.log(`Server is listening on port ${port}`));


