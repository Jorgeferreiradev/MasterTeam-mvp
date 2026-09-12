-- 1. Configuración de Base de Datos Magistral
-- Soporte completo para caracteres especiales y emojis
CREATE DATABASE IF NOT EXISTS master_team_db
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE master_team_db;

-- 2. Tabla Usuarios (Centraliza todos los actores)
-- Agrupa a Administrador, Entrenador, Acudiente y Manager
CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rol ENUM('ADMIN', 'ENTRENADOR', 'ACUDIENTE', 'MANAGER') NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE, -- RBN-02: Borrado lógico
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_rol_activo (rol, activo) -- Optimiza filtrado por rol y estado
) ENGINE=InnoDB;

-- 3. Tabla Deportistas
CREATE TABLE deportistas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria)
) ENGINE=InnoDB;

-- 4. Relación N:M (Acudiente - Deportista)
-- Un acudiente (usuario) puede tener varios deportistas, y un deportista varios acudientes
CREATE TABLE acudiente_deportista (
    acudiente_id BIGINT NOT NULL,
    deportista_id BIGINT NOT NULL,
    parentesco VARCHAR(50) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (acudiente_id, deportista_id),
    FOREIGN KEY (acudiente_id) REFERENCES usuarios(id) ON DELETE RESTRICT,
    FOREIGN KEY (deportista_id) REFERENCES deportistas(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Tabla Grupos (Asignación deportiva)
CREATE TABLE grupos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entrenador_id BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entrenador_id) REFERENCES usuarios(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 6. Tabla Sesiones (1:N desde Deportista/Grupo)
CREATE TABLE sesiones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    grupo_id BIGINT NOT NULL,
    fecha DATETIME NOT NULL,
    tema VARCHAR(200) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON DELETE RESTRICT,
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB;

-- 7. Tabla Asistencias y Evidencias (1:N desde Sesión)
CREATE TABLE asistencias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sesion_id BIGINT NOT NULL,
    deportista_id BIGINT NOT NULL,
    estado ENUM('PRESENTE', 'AUSENTE', 'EXCUSADO') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (sesion_id) REFERENCES sesiones(id) ON DELETE RESTRICT,
    FOREIGN KEY (deportista_id) REFERENCES deportistas(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE evidencias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sesion_id BIGINT NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL, -- Guardamos la ruta local, no el archivo físico
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (sesion_id) REFERENCES sesiones(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 8. Tabla Pagos (Módulo Financiero y Wompi)
CREATE TABLE pagos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    acudiente_id BIGINT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    estado ENUM('PENDIENTE', 'APROBADO', 'RECHAZADO') DEFAULT 'PENDIENTE',
    referencia_wompi VARCHAR(255) UNIQUE, -- Clave para conciliar el Webhook
    fecha_pago DATETIME,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (acudiente_id) REFERENCES usuarios(id) ON DELETE RESTRICT,
    INDEX idx_estado_pago (estado)
) ENGINE=InnoDB;