// server/server.js
const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

// Controllers
const poleController = require('./controllers/poleController');

const app = express();

// ✅ Middleware
app.use(cors());
app.use(express.json());

// ✅ API Routes
app.get('/api/poles', poleController.getAllPoles);
app.post('/api/poles', poleController.createPole);

// ✅ Serve static frontend (Cesium app)
app.use(express.static(path.join(__dirname, '../public')));

// ✅ Handle SPA routing (if frontend uses direct URLs)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// ✅ Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🌍 Server running on port ${PORT}`);
});
