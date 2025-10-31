// server.js
const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const poleController = require('./controllers/poleController');
const app = express();

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());

// API routes
app.get('/api/poles', poleController.getAllPoles);
app.post('/api/poles', poleController.createPole);

// ✅ FIX: Use absolute path for /public
const publicPath = path.join(__dirname, 'public');
app.use(express.static(publicPath));

// ✅ Serve index.html for any non-API route
app.get('*', (req, res) => {
  res.sendFile(path.join(publicPath, 'index.html'));
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
