# booking admin api

express + firebase auth + firestore. flutter app talks to `/api`.

## run

1. enable email/password + firestore in firebase
2. drop service account json at `server/config/database.config.json`
3. copy env stuff into `server/.env` (PORT, FRONTEND_URL, GOOGLE_APPLICATION_CREDENTIALS)
4. then:

```bash
cd server
npm i
npm run seed
npm run dev
```

seed accounts:
- admin@gmail.com / Admin@123 (admin)
- q@gmail.com / qasim@123 (customer)

## endpoints

all under `/api`, send `Authorization: Bearer <firebase id token>`

- `GET /auth/me`
- `GET /stylists`
- `GET /services`
- `POST /bookings` — body: stylistId, serviceId, customerName, slotStart (utc :00 or :30)
- `GET /admin/bookings?status=` — admin only
- `PATCH /admin/bookings/:id/status` — `{ "status": "confirmed" | "cancelled" }` admin only

admin middleware blocks non-admins. status changes append to `booking_audits`. new bookings take a `slot_locks` doc (create fails if that stylist+time is already held).
