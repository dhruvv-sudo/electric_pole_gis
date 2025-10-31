-- create database
CREATE DATABASE IF NOT EXISTS electric_pole_gis;
USE electric_pole_gis;

-- users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin','editor','viewer') NOT NULL DEFAULT 'viewer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- pole types
CREATE TABLE pole_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    material VARCHAR(50),
    height_range VARCHAR(50),
    load_capacity VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- pole status
CREATE TABLE pole_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- equipment types
CREATE TABLE equipment_types (
    equip_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- poles table (spatial)
CREATE TABLE poles (
    pole_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_number VARCHAR(50) NOT NULL UNIQUE,
    location POINT NOT NULL SRID 4326,
    type_id INT,
    height DECIMAL(6,2),
    class VARCHAR(20),
    installation_date DATE,
    manufacturer VARCHAR(100),
    status_id INT,
    last_inspection_date DATE,
    last_maintenance_date DATE,
    notes TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    SPATIAL INDEX(location),
    FOREIGN KEY (type_id) REFERENCES pole_types(type_id),
    FOREIGN KEY (status_id) REFERENCES pole_status(status_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- equipment on poles
CREATE TABLE pole_equipment (
    equip_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT NOT NULL,
    equip_type_id INT NOT NULL,
    serial_number VARCHAR(100),
    installation_date DATE,
    manufacturer VARCHAR(100),
    model VARCHAR(100),
    capacity VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(pole_id),
    FOREIGN KEY (equip_type_id) REFERENCES equipment_types(equip_type_id)
);

-- maintenance records
CREATE TABLE maintenance_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    maintenance_type VARCHAR(100) NOT NULL,
    performed_by VARCHAR(100),
    cost DECIMAL(10,2),
    description TEXT,
    next_maintenance_date DATE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(pole_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- inspection records
CREATE TABLE inspection_records (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT NOT NULL,
    inspection_date DATE NOT NULL,
    inspector VARCHAR(100),
    condition_rating INT,
    issues_found TEXT,
    recommendations TEXT,
    next_inspection_date DATE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(pole_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- attachments
CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    file_size INT,
    description TEXT,
    uploaded_by INT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(pole_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- service areas (polygons)
CREATE TABLE service_areas (
    area_id INT AUTO_INCREMENT PRIMARY KEY,
    area_name VARCHAR(100) NOT NULL,
    geometry POLYGON NOT NULL SRID 4326,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SPATIAL INDEX(geometry)
);

-- circuits (linestrings)
CREATE TABLE circuits (
    circuit_id INT AUTO_INCREMENT PRIMARY KEY,
    circuit_name VARCHAR(100) NOT NULL,
    path LINESTRING NOT NULL SRID 4326,
    voltage VARCHAR(50),
    circuit_type VARCHAR(50),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SPATIAL INDEX(path)
);

-- pole-circuit relations
CREATE TABLE pole_circuit_relations (
    relation_id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT NOT NULL,
    circuit_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(pole_id),
    FOREIGN KEY (circuit_id) REFERENCES circuits(circuit_id),
    UNIQUE KEY (pole_id, circuit_id)
);
