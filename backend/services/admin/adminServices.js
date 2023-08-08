import { db, auth } from '../../firebase.js';

export const fetchAdminData = async (id) => {
  const doc = await db.collection('admins').doc(id).get();
  if (doc.exists) {
    return doc.data();
  } else {
    console.log("No data available");
  }
};

async function listAllUsers(nextPageToken) {
  const users = [];
  const listUsersResult = await auth.listUsers(1000, nextPageToken);

  listUsersResult.users.forEach((userRecord) => {
    if (userRecord.customClaims && userRecord.customClaims["role"] === "user") {
      users.push(userRecord.toJSON());
    }
  });

  if (listUsersResult.pageToken) {
    return users.concat(await listAllUsers(listUsersResult.pageToken));
  }

  return users;
}

export default listAllUsers;
