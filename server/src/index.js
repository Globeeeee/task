import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import router from './routes/index.js';

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

let corsOrigin = true;
if (process.env.FRONTEND_URL) {
  const parts = process.env.FRONTEND_URL.split(',').map((s) => s.trim()).filter(Boolean);
  if (parts.length === 1) corsOrigin = parts[0];
  else if (parts.length > 1) corsOrigin = parts;
}

app.use(cors({ origin: corsOrigin }));
app.use(express.json());
app.use('/api', router);

app.get('/health', (req, res) => {
  res.send('ok');
});

app.listen(port, () => {
  console.log('listening on', port);
});
