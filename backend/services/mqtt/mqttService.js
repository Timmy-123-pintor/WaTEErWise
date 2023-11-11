import mqtt from 'mqtt';
import firebaseAdmin from 'firebase-admin';
import { sensor } from '../../../backend/firebase.js'
// import firebase from '../../firebase.js';

// const { sensor } = firebase;
let client = null;

const userSensorMap = {
    'renfil2001@gmail.com': 'sensor1',
    'timmypintor@gmail.com': 'sensor2',
};

const emailToPath = (email) => {
    return email.replace('@', '_at_').replace(/\./g, '_dot_');
};

const connect = () => {
    if (!client) {
        // Adjust the broker URL as needed
        const options = {
            username: 'waterwiseplus', 
            password: 'waterwise+20?' 
        };

        // Pass the options object to the connect function
        client = mqtt.connect('mqtt://broker.emqx.io:1883', options);

        client.on('connect', () => {
            console.log('Connected to MQTT Broker');
            // Subscribe to the dynamic topics
            client.subscribe('sensor/+/status'); //mo receive
            client.subscribe('sensor/+/data');
            client.subscribe('sensor/+/alert');
            // Configure LWT for the client
            client.publish('sensor/your_device_id/status', 'online', { retain: true });
        });

        client.on('message', (topic, message) => {
            console.log(`Received message on topic: ${topic}`); // Log every incoming message
            try {
                const [type, deviceId, category] = topic.split('/');
                if (type !== 'sensor') return;
                switch (category) {
                    case 'status':
                        handleDeviceStatus(deviceId, message.toString());
                        break;
                    case 'data':
                        storeDeviceData(deviceId, message.toString());
                        break;
                    case 'alert':
                        handleDeviceAlert(deviceId, message.toString());
                        break;
                    default:
                        console.log(`Unhandled topic: ${topic}`);
                }
            } catch (error) {
                console.error(`Error handling message: ${error.message}`);
            }
        });

        // client.on('error', (error) => {
        //     console.error('MQTT Connection Error:', error);
        // });
    }
};

const storeDeviceData = (deviceId, data) => {
    console.log(`Entering storeDeviceData for device ${deviceId} with data: ${data}`);
    const userEmail = Object.keys(userSensorMap).find(email => userSensorMap[email] === deviceId);
    if (!userEmail) {
        console.log(`No user found for device ID: ${deviceId}`);
        return;
    }
    const userPath = emailToPath(userEmail);
    const dataRef = sensor.ref(`user/${userPath}/sensors/${deviceId}`);
    dataRef.set({
        timestamp: firebaseAdmin.database.ServerValue.TIMESTAMP,
        data: data
    }).then(() => {
        console.log(`Data for device ${deviceId} stored successfully.`);
    }).catch((error) => {
        console.error(`Error storing data for device ${deviceId}: ${error}`);
    });
};

// const dataRef = firebaseAdmin.database().ref(`user/${userPath}/sensors/${deviceId}`);
// dataRef.push({
//     timestamp: firebaseAdmin.database.ServerValue.TIMESTAMP,
//     data: data
// });

// const subscribe = (topic) => {
//     if (client && client.connected) {
//         client.subscribe(topic);
//     } else {
//         console.error('MQTT Subscribe Error: Client not connected');
//     }
// };

const publish = (topic, message) => {
    if (client && client.connected) {
        client.publish(topic, message);
    } else {
        console.error('MQTT Publish Error: Client not connected');
    }
};

const subscribeToUserTopic = (userEmail) => {
    const userStatusTopic = `sensor/+/+/${userEmail}/status`;
    const userDataTopic = `sensor/+/+/${userEmail}/data`;
    const userAlertTopic = `sensor/+/+/${userEmail}/alert`;

    client.subscribe(userStatusTopic);
    client.subscribe(userDataTopic);
    client.subscribe(userAlertTopic);
};

const unsubscribeFromUserTopics = (userEmail) => {
    const userStatusTopic = `sensor/+/+/${userEmail}/status`;
    const userDataTopic = `sensor/+/+/${userEmail}/data`;
    const userAlertTopic = `sensor/+/+/${userEmail}/alert`;

    client.unsubscribe(userStatusTopic);
    client.unsubscribe(userDataTopic);
    client.unsubscribe(userAlertTopic);
};

const handleDeviceStatus = (deviceId, status) => {
    if (status === 'offline') {
        console.log(`Device ${deviceId} is offline.`);
        // Implement additional actions as needed
    }
};

// const storeDeviceData = (deviceId, data) => {
//     console.log(`Received data from device ${deviceId}: ${data}`);
//     // Implement database storage logic here
// };

const handleDeviceAlert = (deviceId, alertMessage) => {
    console.log(`Received alert from device ${deviceId}: ${alertMessage}`);
    // Implement alert handling logic here
};

export {
    connect,
    publish,
    subscribeToUserTopic,
    unsubscribeFromUserTopics,
    // Export any other functions you might add
};
