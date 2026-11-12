DROP DATABASE IF EXISTS zapateria;
CREATE DATABASE zapateria;
USE zapateria;

CREATE TABLE proveedor (
    CUIT BIGINT NOT NULL PRIMARY KEY,
    razon_social VARCHAR(250) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    tel_fijo INT NOT NULL
);

CREATE TABLE zapato (
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(20) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (modelo, color),
    CONSTRAINT chk_zapato_precio CHECK (precio >= 0 AND precio <= 200000)
);

CREATE TABLE talle (
    nro_talle INT NOT NULL PRIMARY KEY
);

CREATE TABLE vendedor (
    nro_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(250) NOT NULL,
    apellido VARCHAR(250) NOT NULL,
    DNI INT NOT NULL,
    dirección VARCHAR(250) NOT NULL
);

CREATE TABLE dia (
    nombre VARCHAR(15) NOT NULL PRIMARY KEY
);

CREATE TABLE cliente (
    DNI INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL
);


CREATE TABLE celulares (
    CUIT BIGINT NOT NULL,
    numero BIGINT NOT NULL,
    PRIMARY KEY (CUIT, numero),
    CONSTRAINT fk_celulares_proveedor 
        FOREIGN KEY (CUIT) REFERENCES proveedor(CUIT) 
        ON DELETE CASCADE
);

CREATE TABLE provee (
    CUIT BIGINT NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(20) NOT NULL,
    PRIMARY KEY (CUIT, modelo, color),
    CONSTRAINT fk_provee_cuit 
        FOREIGN KEY (CUIT) REFERENCES proveedor(CUIT) 
        ON DELETE CASCADE,
    CONSTRAINT fk_provee_zapato 
        FOREIGN KEY (modelo, color) REFERENCES zapato(modelo, color) 
        ON DELETE CASCADE
);

CREATE TABLE tiene (
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(20) NOT NULL,
    nro_talle INT NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    PRIMARY KEY (modelo, color, nro_talle),
    CONSTRAINT fk_tiene_zapato 
        FOREIGN KEY (modelo, color) REFERENCES zapato(modelo, color) 
        ON DELETE CASCADE,
    CONSTRAINT fk_tiene_talle 
        FOREIGN KEY (nro_talle) REFERENCES talle(nro_talle) 
        ON DELETE CASCADE
);

CREATE TABLE venta (
    nro_factura INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nro_vendedor INT,
    monto DECIMAL(10,2),
    fecha DATE,
    CONSTRAINT fk_venta_vendedor 
        FOREIGN KEY (nro_vendedor) REFERENCES vendedor(nro_vendedor) 
        ON DELETE RESTRICT
);

CREATE TABLE compra (
    nro_factura INT NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(20) NOT NULL,
    nro_talle INT NOT NULL,
    precio DECIMAL(10,2) CHECK (precio >= 0 AND precio <= 200000),
    cantidad INT NOT NULL,
    PRIMARY KEY (nro_factura, modelo, color, nro_talle),
    CONSTRAINT fk_compra_venta
        FOREIGN KEY (nro_factura) REFERENCES venta(nro_factura)
        ON DELETE CASCADE,
    CONSTRAINT fk_compra_zapato 
        FOREIGN KEY (modelo, color) REFERENCES zapato(modelo, color) 
        ON DELETE CASCADE,
    CONSTRAINT fk_compra_talle 
        FOREIGN KEY (nro_talle) REFERENCES talle(nro_talle) 
        ON DELETE CASCADE
);

CREATE TABLE realiza (
    nro_factura INT NOT NULL,
    DNI INT NOT NULL,
    descuento DECIMAL(5,2) CHECK (descuento >= 0 AND descuento <= 100),
    PRIMARY KEY (nro_factura, DNI),
    CONSTRAINT fk_realiza_factura 
        FOREIGN KEY (nro_factura) REFERENCES venta(nro_factura) 
        ON DELETE CASCADE,
    CONSTRAINT fk_realiza_cliente 
        FOREIGN KEY (DNI) REFERENCES cliente(DNI) 
        ON DELETE RESTRICT
);

CREATE TABLE franco (
    nro_franco INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nro_vendedor INT,
    fecha DATE,
    observación VARCHAR(250),
    CONSTRAINT fk_franco_vendedor 
        FOREIGN KEY (nro_vendedor) REFERENCES vendedor(nro_vendedor) 
        ON DELETE CASCADE
);

CREATE TABLE trabaja (
    nro_vendedor INT NOT NULL,
    nombre VARCHAR(15) NOT NULL,
    hs_salida DATETIME,
    hs_entrada DATETIME,
    PRIMARY KEY (nro_vendedor, nombre),
    CONSTRAINT fk_trabaja_vendedor 
        FOREIGN KEY (nro_vendedor) REFERENCES vendedor(nro_vendedor) 
        ON DELETE CASCADE,
    CONSTRAINT fk_trabaja_dia 
        FOREIGN KEY (nombre) REFERENCES dia(nombre) 
        ON DELETE CASCADE
);

CREATE TABLE mayorista (
    DNI INT NOT NULL PRIMARY KEY,
    descuento_gral DECIMAL(5,2) CHECK (descuento_gral >= 0 AND descuento_gral <= 100),
    CONSTRAINT fk_mayorista_cliente 
        FOREIGN KEY (DNI) REFERENCES cliente(DNI) 
        ON DELETE RESTRICT
);

CREATE TABLE minorista (
    DNI INT NOT NULL PRIMARY KEY,
    fecha_nacimiento DATE,
    CONSTRAINT fk_minorista_cliente 
        FOREIGN KEY (DNI) REFERENCES cliente(DNI) 
        ON DELETE RESTRICT
);

CREATE TABLE registro (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nro_factura INT,
    monto_anterior DECIMAL(10, 2),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TRIGGER tg_precio 
BEFORE UPDATE ON venta 
FOR EACH ROW
INSERT INTO registro (nro_factura, monto_anterior, fecha_registro)
SELECT OLD.nro_factura, OLD.monto, NOW()
WHERE OLD.monto <> NEW.monto;
