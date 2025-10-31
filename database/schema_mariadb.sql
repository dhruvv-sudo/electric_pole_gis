-- =====================================
-- Electric Pole GIS (MariaDB-Compatible Schema)
-- =====================================

CREATE TABLE IF NOT EXISTS pole_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    material VARCHAR(50),
    description TEXT
);

CREATE TABLE IF NOT EXISTS poles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    type_id INT,
    height DECIMAL(6,2),
    class VARCHAR(20),
    installed_at DATE,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (type_id) REFERENCES pole_types(id)
);

CREATE TABLE IF NOT EXISTS pole_equipment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    equipment_name VARCHAR(100),
    manufacturer VARCHAR(100),
    installed_date DATE,
    FOREIGN KEY (pole_id) REFERENCES poles(id)
);

CREATE TABLE IF NOT EXISTS maintenance_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    maintenance_date DATE,
    performed_by VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (pole_id) REFERENCES poles(id)
);

CREATE TABLE IF NOT EXISTS inspection_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    inspection_date DATE,
    inspector_name VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (pole_id) REFERENCES poles(id)
);

CREATE TABLE IF NOT EXISTS attachments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pole_id) REFERENCES poles(id)
);

CREATE TABLE IF NOT EXISTS pole_circuits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    circuit_name VARCHAR(100),
    voltage VARCHAR(50),
    circuit_type VARCHAR(50),
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS pole_circuit_relations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    circuit_id INT,
    FOREIGN KEY (pole_id) REFERENCES poles(id),
    FOREIGN KEY (circuit_id) REFERENCES pole_circuits(id)
);
