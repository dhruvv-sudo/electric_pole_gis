// ================================
// Electric Pole GIS - Controller
// ================================

const db = require('../config/db');

// ================================
// Get All Poles
// ================================
exports.getAllPoles = async (req, res) => {
  try {
    console.log("🔍 Attempting to fetch poles from database...");

    // Fetch poles joined with pole_types (your current schema)
    const [rows] = await db.query(`
      SELECT 
        p.id AS pole_id,
        p.latitude,
        p.longitude,
        pt.type_name,
        p.height,
        p.class,
        p.installed_at,
        p.status
      FROM poles p
      LEFT JOIN pole_types pt ON p.type_id = pt.id
      LIMIT 1000
    `);

    console.log(`✅ Query executed successfully. Rows fetched: ${rows.length}`);

    res.status(200).json(rows);
  } catch (err) {
    console.error("❌ Detailed MySQL Error:");
    console.error("Code:", err.code);
    console.error("SQL:", err.sql);
    console.error("SQL Message:", err.sqlMessage);
    console.error("Stack:", err.stack);
    res.status(500).json({ message: 'Server error', error: err.sqlMessage || err.message });
  }
};

// ================================
// Create New Pole
// ================================
exports.createPole = async (req, res) => {
  try {
    const {
      latitude,
      longitude,
      type_id,
      height,
      class: poleClass,
      installed_at,
      status
    } = req.body;

    if (!latitude || !longitude) {
      return res.status(400).json({ message: 'Latitude and Longitude are required' });
    }

    const [result] = await db.query(
      `INSERT INTO poles (latitude, longitude, type_id, height, class, installed_at, status)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [latitude, longitude, type_id, height, poleClass, installed_at, status]
    );

    console.log("✅ New pole inserted with ID:", result.insertId);
    res.status(201).json({ message: 'Pole created successfully', pole_id: result.insertId });
  } catch (err) {
    console.error("❌ Error while creating pole:");
    console.error("Code:", err.code);
    console.error("SQL:", err.sql);
    console.error("SQL Message:", err.sqlMessage);
    console.error("Stack:", err.stack);
    res.status(500).json({ message: 'Server error', error: err.sqlMessage || err.message });
  }
};

// ================================
// Get Pole by ID
// ================================
exports.getPoleById = async (req, res) => {
  try {
    const poleId = req.params.id;
    const [rows] = await db.query(`
      SELECT 
        p.id AS pole_id,
        p.latitude,
        p.longitude,
        pt.type_name,
        p.height,
        p.class,
        p.installed_at,
        p.status
      FROM poles p
      LEFT JOIN pole_types pt ON p.type_id = pt.id
      WHERE p.id = ?
    `, [poleId]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Pole not found' });
    }

    res.status(200).json(rows[0]);
  } catch (err) {
    console.error("❌ Error while fetching pole by ID:", err);
    res.status(500).json({ message: 'Server error', error: err.sqlMessage || err.message });
  }
};

// ================================
// Delete Pole
// ================================
exports.deletePole = async (req, res) => {
  try {
    const poleId = req.params.id;
    const [result] = await db.query(`DELETE FROM poles WHERE id = ?`, [poleId]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Pole not found' });
    }

    console.log(`🗑️ Pole with ID ${poleId} deleted`);
    res.status(200).json({ message: 'Pole deleted successfully' });
  } catch (err) {
    console.error("❌ Error while deleting pole:", err);
    res.status(500).json({ message: 'Server error', error: err.sqlMessage || err.message });
  }
};
