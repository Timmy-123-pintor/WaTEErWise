import firebaseAdmin from '../../firebase.js';

const db = firebaseAdmin.database();

export const fetchCustomerData = async (id) => {
    const snapshot = await db.ref(`/customers/${id}`).get();
    if (snapshot.exists()) {
        return snapshot.val();
    } else {
        console.log('No data available');
    }
};

export const fetchCustomerBills = async (id) => {
    const snapshot = await db.ref(`/customers/${id}/bills`).get();
    if (snapshot.exists()) {
        return snapshot.val();
    } else {
        console.log('No bill data available');
    }
};

export const setWaterLimit = async (id, limit) => {
    try {
        await db.ref(`/customers/${id}`).update({
            waterLimit: limit
        });
        return { success: true };
    } catch (error) {
        console.error(`Error updating water limit: ${error}`);
        return { success: false };
    }
};
