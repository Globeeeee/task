import fs from 'fs';
import path from 'path';
import { initializeApp, getApps, cert } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

const credPath = path.resolve(
  process.cwd(),
  process.env.GOOGLE_APPLICATION_CREDENTIALS || './config/database.config.json',
);

if (!fs.existsSync(credPath)) {
  throw new Error('firebase key missing: ' + credPath);
}

const serviceAccount = JSON.parse(fs.readFileSync(credPath, 'utf8'));

if (!getApps().length) {
  initializeApp({ credential: cert(serviceAccount) });
}

export default {
  db: getFirestore(),
  auth: getAuth(),
};
