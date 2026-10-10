import Firebase from '../../config/firebase.config.js';

const { db } = Firebase;

const ServicesService = {
  async listServices() {
    const snap = await db.collection('services').get();
    return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
  },

  async getServiceById(id) {
    const doc = await db.collection('services').doc(id).get();
    return doc.exists ? { id: doc.id, ...doc.data() } : null;
  },

  async addService(service) {
    const ref = await db.collection('services').add(service);
    return { id: ref.id, ...service };
  },

  async clearServices() {
    const snap = await db.collection('services').get();
    if (snap.empty) return;
    const batch = db.batch();
    snap.forEach((d) => batch.delete(d.ref));
    await batch.commit();
  },
};

export default ServicesService;
