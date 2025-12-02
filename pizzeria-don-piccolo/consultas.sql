/*
Clientes con pedidos entre dos fechas (BETWEEN).
Pizzas más vendidas (GROUP BY y COUNT).
Pedidos por repartidor (JOIN).
Promedio de entrega por zona (AVG y JOIN).
Clientes que gastaron más de un monto (HAVING).
Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
*/

-- 1. Clientes con pedidos entre dos fechas (BETWEEN).
DELIMITER //
CREATE PROCEDURE clientes_pedidos_rango(in v_fecha_inicio date,in v_fecha_fin date)
begin
SELECT concat(p.nombre,' ',p.apellido) as nombre_completo, pe.total, pe.descripcion, pe.tipo_pedido from pedidos pe left join persona p on pe.id_cliente=p.id
where DATE(pe.fecha) BETWEEN v_fecha_inicio and v_fecha_fin
ORDER BY pe.fecha DESC;
END; //
DELIMITER ;

call clientes_pedidos_rango('yyyy-mm-dd','yyyy-mm-dd');
call clientes_pedidos_rango('2025-01-01','2025-12-31');


-- 2. Pizzas más vendidas (GROUP BY y COUNT).
DELIMITER //
CREATE PROCEDURE top_pizzas()
BEGIN
SELECT COUNT(*) as cantidad_pedidos_por_pizza ,SUM(cantidad) as cantidad_pizzas, pi.nombre as nombre_pizza, pi.tipo_pizza as tipo_pizza, sum(dp.subtotal) as total_ganado 
FROM detalle_pedido dp left join pizza pi on dp.id_pizza=pi.id 
GROUP BY  dp.id_pizza 
ORDER BY  cantidad_pizzas DESC;
END; //
DELIMITER ;

call top_pizzas;


-- 3. Pedidos por repartidor (JOIN).
DELIMITER //
CREATE PROCEDURE pedidos_repartidor(in v_repartidor int)
BEGIN
SELECT p.id  as pedido_id, concat(pe.nombre,' ',pe.apellido) as nombre_completo, 
p.estado as estado_pedido, p.descripcion as descripcion_pedido
from domicilio d left join persona pe on d.id_repartidor=pe.id left join pedidos p on d.id_pedido=p.id
WHERE d.id_repartidor=v_repartidor
ORDER BY nombre_completo DESC;
END; //
DELIMITER ;

call pedidos_repartidor(id_repartidor);
call pedidos_repartidor(21);


-- 4. Promedio de entrega por zona (AVG y JOIN).
DELIMITER //
CREATE PROCEDURE promedio_zona()
BEGIN
SELECT z.nombre as nombre_zona, AVG(d.costo_domicilio) as promedio_ganado, COUNT(*) as cantidad_entregas
FROM domicilio d left join repartidores r on d.id_repartidor=r.id left join zona z on r.zona=z.id 
GROUP BY z.nombre 
ORDER BY promedio_ganado DESC;
END; //
DELIMITER ;

call promedio_zona;


-- 5. Clientes que gastaron más de un monto (HAVING).
DELIMITER //
CREATE PROCEDURE clientes_vip(in v_monto_minimo double)
begin
SELECT concat(p.nombre,' ',p.apellido) as nombre_completo, SUM(total) as total_gastado
FROM persona p LEFT JOIN pedidos pe on p.id=pe.id_cliente 
GROUP BY nombre_completo 
HAVING total_gastado>=v_monto_minimo 
ORDER BY total_gastado DESC;
end; //
DELIMITER ;

call clientes_vip(monto_De_busqueda);
call clientes_vip(100000);


-- 6. Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
DELIMITER //
CREATE PROCEDURE busqueda_parcial(in v_nombre_parcial VARCHAR(50))
begin
SELECT nombre, tipo_pizza from pizza where nombre LIKE concat('%',v_nombre_parcial,'%');
end; //
DELIMITER ;

call busqueda_parcial('nombre para la busqueda parcial');
call busqueda_parcial('s');


-- 7. Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
DELIMITER //
CREATE PROCEDURE clientes_frecuentes()
begin
SELECT p.id_cliente, COUNT(*) as cantidad_pedidos, concat(pe.nombre,' ',pe.apellido) as nombre_completo 
from pedidos p left join persona pe on p.id_cliente=pe.id 
GROUP by p.id_cliente HAVING cantidad_pedidos>=5; 
end; //
DELIMITER ;

call clientes_frecuentes();