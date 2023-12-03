import mqtt from 'mqtt';
import firebaseAdmin from 'firebase-admin';
import { sensor } from '../../../backend/firebase.js'
import { startOfWeek, startOfMonth, isSameWeek, isSameMonth} from 'date-fns';

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

    const litersMatch = data.match(/Total Volume: (\d+\.\d+)/);
    const cubicMetersMatch = data.match(/Cubic Meters: (\d+\.\d+)/);
    
    if (!litersMatch || !cubicMetersMatch) {
        console.log(`Couldn't find liters or cubic meters in the data.`);
        return;
    }

    const totalLiters = parseFloat(litersMatch[1]);
    const totalCubicMeters = parseFloat(cubicMetersMatch[1]);

    const dataRef = sensor.ref(`user/${userPath}/sensors/${deviceId}`);
    dataRef.set({
        // timestamp: firebaseAdmin.database.ServerValue.TIMESTAMP,
        data: data,
        totalLiters,
        totalCubicMeters,

        weeklyData: processWeeklyData(totalLiters, totalCubicMeters),
        monthlyData: processMonthlyData(totalLiters, totalCubicMeters),
    }).then(() => {
        console.log(`Data for device ${deviceId} stored successfully.`);
    }).catch((error) => {
        console.error(`Error storing data for device ${deviceId}: ${error}`);
    });
};

const processWeeklyData = (liters, cubicMeters) => {
    const today = new Date();
    const startOfWeekDate = startOfWeek(today);

    if (isSameWeek(startOfWeekDate, today)) {
        return{
            totalLiters: liters,
            totalCubicMeters: cubicMeters,
        };
    } else {
        return {
            totalLiters: 0,
            totalCubicMeters: 0,
        }
    }
};

const processMonthlyData = (liters, cubicMeters) => {
    const today = new Date();
    const startOfMonthDate = startOfMonth(today);

    if (isSameMonth(startOfMonthDate, today)) {
        return {
            totalLiters: liters,
            totalCubicMeters: cubicMeters,
        };
    } else {
        return {
            totalLiters: 0,
            totalCubicMeters: 0,
        };
    }
};

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
