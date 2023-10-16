class Device {
    constructor(id, deviceName, deviceType, currentUsage, settings, registrationDate, token) {
        this.id = id;
        this.deviceName = deviceName;
        this.deviceType = deviceType;
        this.currentUsage = currentUsage;
        this.settings = settings;
        this.registrationDate = registrationDate || new Date();
        this.token = token;
    }
}
