// adminService.js
import { getDatabase } from 'firebase-admin';

const db = getDatabase();

export const fetchAdminData = async (id) => {
    const snapshot = await db.ref(`/admins/${id}`).get();
    if (snapshot.exists()) {
        return snapshot.val();
    } else {
        console.log('No data available');
    }
};
// ... other functions
