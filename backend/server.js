// server.js
const express = require('express');
const app = express();

const customerRoutes = require('./routes/customer');
const adminRoutes = require('./routes/admin');
const deviceRoutes = require('./routes/devices');
const firebase = require('firebase/app');
require('firebase/auth');

app.use('/customer', customerRoutes);
app.use('/admin', adminRoutes);
app.use('/devices', deviceRoutes);

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`Server is listening on port ${port}`));
