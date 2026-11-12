INSERT INTO proveedor (CUIT, razon_social, direccion, tel_fijo) VALUES
(20301112229, 'Distribuidora del Calzado S.A.', 'Av. Corrientes 1234', 1143215555),
(20303334449, 'Calzados Argentinos SRL', 'Calle San Martín 567', 1149876666);

INSERT INTO zapato (modelo, color, precio) VALUES
('Runner', 'Negro', 25000.00),
('Urban', 'Blanco', 18500.00),
('Mocasin', 'Marrón', 32000.00);

INSERT INTO talle (nro_talle) VALUES
(38), (39), (40), (41), (42);

INSERT INTO vendedor (nombre, apellido, DNI, dirección) VALUES
('Carlos', 'Gómez', 35123456, 'Calle Falsa 123'),
('María', 'López', 38987654, 'Av. Belgrano 456');

INSERT INTO dia (nombre) VALUES
('Lunes'), ('Martes'), ('Miércoles'), ('Jueves'), ('Viernes'), ('Sábado');

INSERT INTO cliente (DNI, nombre, apellido) VALUES
(25111222, 'Juan', 'Pérez'),
(28333444, 'Laura', 'Fernández'),
(31555666, 'Pedro', 'Martínez');

INSERT INTO celulares (CUIT, numero) VALUES
(20301112229, 1155443322),
(20301112229, 1166778899),
(20303334449, 1122334455);

INSERT INTO provee (CUIT, modelo, color) VALUES
(20301112229, 'Runner', 'Negro'),
(20301112229, 'Urban', 'Blanco'),
(20303334449, 'Mocasin', 'Marrón');

INSERT INTO tiene (modelo, color, nro_talle, stock) VALUES
('Runner', 'Negro', 40, 15),
('Runner', 'Negro', 41, 10),
('Urban', 'Blanco', 38, 5),
('Mocasin', 'Marrón', 42, 8);

INSERT INTO mayorista (DNI, descuento_gral) VALUES
(25111222, 15.00);

INSERT INTO minorista (DNI, fecha_nacimiento) VALUES
(28333444, '1995-04-12'),
(31555666, '2000-08-25');

INSERT INTO trabaja (nro_vendedor, nombre, hs_entrada, hs_salida) VALUES
(1, 'Lunes', '2026-01-01 09:00:00', '2026-01-01 17:00:00'),
(1, 'Martes', '2026-01-01 09:00:00', '2026-01-01 17:00:00'),
(2, 'Lunes', '2026-01-01 13:00:00', '2026-01-01 21:00:00');

INSERT INTO franco (nro_vendedor, fecha, observación) VALUES
(1, '2026-05-15', 'Franco compensatorio'),
(2, '2026-05-16', 'Franco semanal');

INSERT INTO venta (nro_vendedor, monto, fecha) VALUES
(1, 500000, '2025-02-09'),
(1, 43500.00, '2026-05-10'),
(2, 32000.00, '2026-05-11');

INSERT INTO realiza (nro_factura, DNI, descuento) VALUES
(1, 25111222, 10.00),
(2, 28333444, 0.00);

INSERT INTO compra (nro_factura, modelo, color, nro_talle, precio, cantidad) VALUES
(1, 'Runner', 'Negro', 40, 25000.00, 1),
(1, 'Urban', 'Blanco', 38, 18500.00, 1),
(2, 'Mocasin', 'Marrón', 42, 32000.00, 1);