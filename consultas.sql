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

#a) Devolver el Nº más vendido por c/modelo de zapatos.
SELECT c1.modelo, c1.nro_talle AS talle_mas_vendido, 
  SUM(c1.cantidad) AS total_vendido FROM compra c1
GROUP BY c1.modelo, c1.nro_talle
HAVING 
    SUM(c1.cantidad) >= ALL (
        SELECT SUM(c2.cantidad) FROM compra c2 WHERE c1.modelo = c2.modelo
        GROUP BY c2.nro_talle
    );

#b) Listado de vendedores con sus ventas totales(monto total) durante 2025.
SELECT 
    v.nro_vendedor,
    v.nombre,
    v.apellido,
    SUM(vta.monto) AS venta_total
FROM vendedor v
INNER JOIN venta vta ON v.nro_vendedor = vta.nro_vendedor
WHERE YEAR(vta.fecha) = 2025
GROUP BY v.nro_vendedor, v.nombre, v.apellido;

#c) Apellido y Nombre de los vendedores que no han tenido francos en enero de 2026
SELECT v.nombre, v.apellido 
FROM vendedor v
LEFT JOIN franco f 
    ON f.nro_vendedor = v.nro_vendedor
    AND f.fecha >= '2026-01-01'
    AND f.fecha < '2026-02-01'
WHERE f.nro_vendedor IS NULL;

#d) Definir consultas propias (no menos de tres), donde por lo menos una utilice subconsultas.
#1. clientes que compraron un modelo específico (subconsulta: busca los DNIs de las facturas donde se vendió el modelo runner)
SELECT nombre, apellido FROM cliente
WHERE 
    DNI IN (
        SELECT r.DNI FROM realiza r
        INNER JOIN compra c ON r.nro_factura = c.nro_factura
        WHERE c.modelo = 'Runner'
    );

#2. Zapatos cuyo precio es mayor al precio máximo de aquellos de modelo "Runner": Subconsulta: Seleccionar el precio máximo de los zapatos cuyo modelo sea "Runner"
SELECT modelo, color, precio
FROM zapato
WHERE precio > (
    SELECT MAX(precio)
    FROM zapato
    WHERE modelo = 'Runner' 
);

#3.Listar el nombre y apellido de los vendedores que realizaron alguna venta cuyo monto supere al monto máximo vendido durante el año 2026. SUBCONSULTA:
#revisar todas las ventas del año 2026 y descubrir cuál fue la venta individual más cara
SELECT DISTINCT v.nombre, v.apellido
FROM vendedor v
INNER JOIN venta vta ON v.nro_vendedor = vta.nro_vendedor
WHERE vta.monto > (
    SELECT MAX(monto)
    FROM venta
    WHERE YEAR(fecha) = 2026
);