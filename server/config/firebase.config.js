import fs from 'fs';
import path from 'path';
import { createRequire } from 'module';
import { initializeApp, getApps, cert } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

const require = createRequire(import.meta.url);
const credPath = path.resolve(
  process.cwd(),
  process.env.GOOGLE_APPLICATION_CREDENTIALS || './config/database.config.json',
);

if (!fs.existsSync(credPath)) {
  throw new Error('firebase key missing: ' + credPath);
}

if (!getApps().length) {
  initializeApp({ credential: cert(require(credPath)) });
}

export default {
  db: getFirestore(),
  auth: getAuth(),
};
