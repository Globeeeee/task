import Firebase from '../../config/firebase.config.js';

const { db } = Firebase;

export async function listStylists() {
  const snap = await db.collection('stylists').get();
  return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
}

export async function getStylistById(id) {
  const doc = await db.collection('stylists').doc(id).get();
  if (!doc.exists) return null;
  return { id: doc.id, ...doc.data() };
}

export async function addStylist(data) {
  const ref = await db.collection('stylists').add(data);
  return { id: ref.id, ...data };
}

export async function clearStylists() {
  const snap = await db.collection('stylists').get();
  if (snap.empty) return;
  const batch = db.batch();
  for (const d of snap.docs) batch.delete(d.ref);
  await batch.commit();
}

export default {
  listStylists,
  getStylistById,
  addStylist,
  clearStylists,
};
