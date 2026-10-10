import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import router from './routes/index.js';

const app = express();
const port = process.env.PORT || '';

app.use(cors({ origin: true }));
app.use(express.json());
app.use('/api', router);

app.get('/health', (res) => {
  res.send('ok');
});

app.listen(port, () => {
  console.log('listening on', port);
});
