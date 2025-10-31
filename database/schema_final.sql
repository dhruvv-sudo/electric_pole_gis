-- ================================================
-- ELECTRIC POLE GIS - FINAL MARIADB SCHEMA (Dhruv)
-- ================================================

-- Use InnoDB for foreign keys
SET default_storage_engine=InnoDB;

CREATE TABLE IF NOT EXISTS pole_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    material VARCHAR(50),
    description TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS poles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    type_id INT,
    height DECIMAL(6,2),
    class VARCHAR(20),
    installed_at DATE,
    status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT fk_pole_type FOREIGN KEY (type_id) REFERENCES pole_types(id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pole_equipment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    equipment_name VARCHAR(100),
    manufacturer VARCHAR(100),
    installed_date DATE,
    CONSTRAINT fk_pole_eq FOREIGN KEY (pole_id) REFERENCES poles(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS maintenance_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    maintenance_date DATE,
    performed_by VARCHAR(100),
    notes TEXT,
    CONSTRAINT fk_maint_pole FOREIGN KEY (pole_id) REFERENCES poles(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS inspection_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    inspection_date DATE,
    inspector_name VARCHAR(100),
    remarks TEXT,
    CONSTRAINT fk_insp_pole FOREIGN KEY (pole_id) REFERENCES poles(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS attachments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_attach_pole FOREIGN KEY (pole_id) REFERENCES poles(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pole_circuits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    circuit_name VARCHAR(100),
    voltage VARCHAR(50),
    circuit_type VARCHAR(50),
    status VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pole_circuit_relations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pole_id INT,
    circuit_id INT,
    CONSTRAINT fk_rel_pole FOREIGN KEY (pole_id) REFERENCES poles(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rel_circuit FOREIGN KEY (circuit_id) REFERENCES pole_circuits(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
