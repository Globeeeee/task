import Firebase from '../../config/firebase.config.js';

const { db } = Firebase;
const bookingsCol = () => db.collection('bookings');
const locksCol = () => db.collection('slot_locks');
const auditsCol = () => db.collection('booking_audits');

function httpError(message, statusCode) {
  const err = new Error(message);
  err.statusCode = statusCode;
  return err;
}

async function wipeCollection(name) {
  const snap = await db.collection(name).get();
  if (snap.empty) return;
  const batch = db.batch();
  snap.docs.forEach((d) => batch.delete(d.ref));
  await batch.commit();
}

async function listBookings(status) {
  let q = bookingsCol();
  if (status) q = q.where('status', '==', status);

  const snap = await q.get();
  const list = [];
  snap.forEach((d) => list.push({ id: d.id, ...d.data() }));
  list.sort((a, b) => (a.slotStart > b.slotStart ? 1 : -1));
  return list;
}

async function placeBooking(booking) {
  const lockId = `${booking.stylistId}_${booking.slotStart}`;
  const bookingRef = bookingsCol().doc();
  const lockRef = locksCol().doc(lockId);

  try {
    await db.runTransaction(async (t) => {
      t.create(lockRef, {
        bookingId: bookingRef.id,
        stylistId: booking.stylistId,
        heldAt: Date.now(),
      });
      t.set(bookingRef, {
        ...booking,
        slotKey: lockId,
      });
    });
  } catch (e) {
    const already =
      e.code === 6 ||
      e.code === 'already-exists' ||
      (e.message && e.message.toLowerCase().includes('already exists'));
    if (already) throw httpError('slot taken', 409);
    throw e;
  }

  return { id: bookingRef.id, ...booking, slotKey: lockId };
}

async function changeStatus(bookingId, nextStatus, changedBy) {
  const bookingRef = bookingsCol().doc(bookingId);
  const snap = await bookingRef.get();
  if (!snap.exists) throw httpError('not found', 404);

  const current = snap.data();
  if (current.status !== 'pending') throw httpError('only pending can change', 409);

  const updatedAt = new Date().toISOString();
  const fromStatus = current.status;

  await bookingRef.update({ status: nextStatus, updatedAt });

  await auditsCol().add({
    bookingId,
    fromStatus,
    toStatus: nextStatus,
    changedBy,
    changedAt: updatedAt,
  });

  if (current.slotKey) {
    const lockRef = locksCol().doc(current.slotKey);
    if (nextStatus === 'cancelled') {
      await lockRef.delete().catch(() => {});
    } else {
      await lockRef.set({ status: nextStatus, updatedAt }, { merge: true });
    }
  }

  return { id: bookingId, ...current, status: nextStatus, updatedAt };
}

async function deleteBooking(bookingId) {
  const bookingRef = bookingsCol().doc(bookingId);
  const snap = await bookingRef.get();
  if (!snap.exists) throw httpError('not found', 404);

  const current = snap.data();
  await bookingRef.delete();
  if (current.slotKey) {
    await locksCol().doc(current.slotKey).delete().catch(() => {});
  }
  return true;
}

async function clearBookings() {
  await wipeCollection('bookings');
  await wipeCollection('slot_locks');
  await wipeCollection('booking_slots');
  await wipeCollection('booking_audits');
}

export default {
  listBookings,
  placeBooking,
  changeStatus,
  deleteBooking,
  clearBookings,
};
