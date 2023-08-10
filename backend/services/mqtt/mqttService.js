import mqtt from 'mqtt';

let client = null;

export const connect = () => {
    if(!client) {
        client = mqtt.connect('mqtt://localhost:1883'); // Default Mosquitto config
        
        client.on('connect', () => {
            console.log('Connected to MQTT Broker');
        });

        client.on('message', (topic, message) => {
            // Handle received messages here
        });
    }
}

export const publish = (topic, message) => {
    if(client && client.connected) {
        client.publish(topic, message);
    }
}

export const subscribe = (topic) => {
    if(client && client.connected) {
        client.subscribe(topic);
    }
}
