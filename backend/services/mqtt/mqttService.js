import mqtt from 'mqtt';

let client = null;

export const connect = () => {
    if (!client) {
        // Adjust the broker URL as needed
        client = mqtt.connect('mqtt://localhost:1883');

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
    }
};

export const publish = (topic, message) => {
    if (client && client.connected) {
        client.publish(topic, message);
    }
};

export const subscribe = (topic) => {
    if (client && client.connected) {
        client.subscribe(topic);
    }
};

function handleDeviceStatus(deviceId, status) {
    if (status === 'offline') {
        // Notify relevant parties that the device is offline
        console.log(`Device ${deviceId} is offline.`);
        // You can send notifications, update a status in your database, or trigger actions as needed.
    }
}

function storeDeviceData(deviceId, data) {
    // Store the incoming data in your database
    console.log(`Received data from device ${deviceId}: ${data}`);
    // Implement your database storage logic here.
}

function handleDeviceAlert(deviceId, alertMessage) {
    // Handle critical alerts and notify the relevant parties
    console.log(`Received alert from device ${deviceId}: ${alertMessage}`);
    // Implement your alert handling and notification logic here.
}
