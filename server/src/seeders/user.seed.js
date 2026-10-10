import dotenv from 'dotenv';
import Firebase from '../../config/firebase.config.js';
import UsersService from '../services/users.services.js';
import BookingsService from '../services/bookings.services.js';
import StylistsService from '../services/stylists.services.js';
import ServicesService from '../services/services.services.js';

dotenv.config();

const { auth } = Firebase;

async function ensureAuthUser(email, password, displayName) {
  try {
    const existing = await auth.getUserByEmail(email);
    await auth.updateUser(existing.uid, { password, displayName });
    return existing.uid;
  } catch (e) {
    if (e.code === 'auth/user-not-found') {
      const created = await auth.createUser({ email, password, displayName });
      return created.uid;
    }
    throw e;
  }
}

async function main() {
  console.log('clearing old data...');
  await UsersService.clearUsers();
  await BookingsService.clearBookings();
  await StylistsService.clearStylists();
  await ServicesService.clearServices();

  const adminUid = await ensureAuthUser('admin@gmail.com', 'Admin@123', 'Admin');
  await UsersService.saveUser(adminUid, {
    email: 'admin@gmail.com',
    name: 'Admin',
    role: 'admin',
  });

  const customerUid = await ensureAuthUser('q@gmail.com', 'qasim@123', 'Qasim');
  await UsersService.saveUser(customerUid, {
    email: 'q@gmail.com',
    name: 'Qasim',
    role: 'customer',
  });

  const ali = await StylistsService.addStylist({ name: 'Ali' });
  const bilal = await StylistsService.addStylist({ name: 'Bilal' });
  const usman = await StylistsService.addStylist({ name: 'Usman' });

  const haircut = await ServicesService.addService({ name: 'Haircut' });
  const color = await ServicesService.addService({ name: 'Color' });

  const now = new Date().toISOString();

  await BookingsService.placeBooking({
    customerId: customerUid,
    customerName: 'Qasim',
    serviceId: haircut.id,
    serviceName: haircut.name,
    stylistId: ali.id,
    stylistName: ali.name,
    slotStart: '2026-10-12T10:00:00.000Z',
    slotEnd: '2026-10-12T10:30:00.000Z',
    status: 'pending',
    createdAt: now,
    updatedAt: now,
  });

  await BookingsService.placeBooking({
    customerId: customerUid,
    customerName: 'Hassan',
    serviceId: color.id,
    serviceName: color.name,
    stylistId: bilal.id,
    stylistName: bilal.name,
    slotStart: '2026-10-12T11:00:00.000Z',
    slotEnd: '2026-10-12T11:30:00.000Z',
    status: 'confirmed',
    createdAt: now,
    updatedAt: now,
  });

  await BookingsService.placeBooking({
    customerId: customerUid,
    customerName: 'Ali',
    serviceId: haircut.id,
    serviceName: haircut.name,
    stylistId: usman.id,
    stylistName: usman.name,
    slotStart: '2026-10-12T14:30:00.000Z',
    slotEnd: '2026-10-12T15:00:00.000Z',
    status: 'pending',
    createdAt: now,
    updatedAt: now,
  });

  console.log('done seeding');
  console.log('admin@gmail.com / Admin@123');
  console.log('q@gmail.com / qasim@123');
  process.exit(0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
