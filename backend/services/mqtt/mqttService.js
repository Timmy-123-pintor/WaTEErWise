import mqtt from 'mqtt';

let client = null;

const connect = () => {
    if (!client) {
        // Adjust the broker URL as needed
        const options = {
            username: 'waterwiseplus.20@gmail.com', 
            password: 'waterwise+20?' 
        };

        // Pass the options object to the connect function
        client = mqtt.connect('mqtt://broker.emqx.io:1883', options);

        client.on('connect', () => {
            console.log('Connected to MQTT Broker');
            // Subscribe to the dynamic topics
            client.subscribe('sensor/+/status');
            client.subscribe('sensor/+/data');
            client.subscribe('sensor/+/alert');
            // Configure LWT for the client
            client.publish('sensor/your_device_id/status', 'online', { retain: true });
        });

        client.on('message', (topic, message) => {
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
                    console.log(`Received message on unhandled topic: ${topic}`);
            }
        });

        client.on('error', (error) => {
            console.error('MQTT Connection Error:', error);
        });
    }
};

const publish = (topic, message) => {
    if (client && client.connected) {
        client.publish(topic, message);
    } else {
        console.error('MQTT Publish Error: Client not connected');
    }
};

const subscribe = (topic) => {
    if (client && client.connected) {
        client.subscribe(topic);
    } else {
        console.error('MQTT Subscribe Error: Client not connected');
    }
};

const handleDeviceStatus = (deviceId, status) => {
    if (status === 'offline') {
        console.log(`Device ${deviceId} is offline.`);
        // Implement additional actions as needed
    }
};

const storeDeviceData = (deviceId, data) => {
    console.log(`Received data from device ${deviceId}: ${data}`);
    // Implement database storage logic here
};

const handleDeviceAlert = (deviceId, alertMessage) => {
    console.log(`Received alert from device ${deviceId}: ${alertMessage}`);
    // Implement alert handling logic here
};

export {
    connect,
    publish,
    subscribe,
    // Export any other functions you might add
};
