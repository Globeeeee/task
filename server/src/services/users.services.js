import Firebase from '../../config/firebase.config.js';

const { db } = Firebase;

async function findUserByEmail(email) {
  const snap = await db.collection('users').where('email', '==', email).limit(1).get();
  if (snap.empty) return null;
  const d = snap.docs[0];
  return { id: d.id, ...d.data() };
}

async function saveUser(uid, data) {
  await db.collection('users').doc(uid).set(data);
  return { id: uid, ...data };
}

async function clearUsers() {
  const snap = await db.collection('users').get();
  const batch = db.batch();
  snap.docs.forEach((d) => batch.delete(d.ref));
  if (!snap.empty) await batch.commit();
}

export default { findUserByEmail, saveUser, clearUsers };
