import firebaseAdmin from 'firebase-admin';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, resolve } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const serviceAccount = JSON.parse(readFileSync(resolve(__dirname, "./middleware/waterwise-database-firebase-adminsdk-mzebg-97388e538e.json"), 'utf8'));

const app = firebaseAdmin.initializeApp({
    credential: firebaseAdmin.credential.cert(serviceAccount),
    databaseURL: "https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app"
});

export const auth = app.auth();
export const sensor = app.database(); 
export const db = app.firestore(); 
export default app;

