# ⚡ Electric Pole GIS — Google Earth Style Viewer

A GIS application built with CesiumJS + Node.js + MySQL for managing electrical pole data on a 3D globe.

---

## 🏗️ Features

- Interactive **3D globe** (CesiumJS)
- Add / view **electrical poles** on real coordinates
- **Spatial database** using MySQL with POINT geometry
- Backend **REST API** (Node.js + Express)
- Optional Docker setup (MySQL + Server)
- Easy expansion for maintenance, equipment, and inspection modules

---

## 🧩 Folder Structure

ElectricPoleGIS/
├── database/ # SQL schema
├── server/ # Node backend
├── client/public/ # Cesium front-end
└── docker-compose.yml # Optional container setup
