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