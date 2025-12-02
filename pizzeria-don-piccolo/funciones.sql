/*Funciones y Procedimientos
Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.*/


-- esctructura function
delimiter //
create function descuento_producto(id_detalle int )
returns double
not deterministic
reads sql data

begin
declare v_tipo_venta VARCHAR(50);
declare v_subtotal double;

select tipo_venta, subtotal into v_tipo_venta, v_subtotal from detalle_venta where id=id_detalle;
IF v_tipo_venta = 'producto' then
return v_subtotal*0.90;
ELSEIF v_tipo_venta = 'paquete' then
return v_subtotal*0.85;
ELSE 
return v_subtotal*0.95;

end if;
end; //
delimiter ;

-- mensaje de error definido por el usuario.
signal sqlstate '45000' set message_text='mensaje de guia para ver porque lugares se ejecutabien la funcion'; 




-- 1. Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).

DROP function if EXISTS total_pedido;
DELIMITER //
CREATE function total_pedido(v_id_pedido int)
returns double
not deterministic
reads sql data

begin

declare v_tipo_pedido VARCHAR(50);
declare v_precio_pizza double;
declare v_costo_domicilio double;
declare v_total_final double default 0;


select min(pe.tipo_pedido), COALESCE(SUM(dp.subtotal), 0) into v_tipo_pedido, v_precio_pizza 
from pedidos pe left join detalle_pedido dp on pe.id=dp.id_pedido 
where pe.id=v_id_pedido
GROUP by pe.id, pe.tipo_pedido;

if v_tipo_pedido = 'domicilio' then 
SELECT costo_domicilio into v_costo_domicilio from domicilio d where d.id_pedido=v_id_pedido;
set v_total_final = (v_precio_pizza + COALESCE(v_costo_domicilio,0))*1.19;

ELSE
set v_total_final = v_precio_pizza*1.19;
end if;

return  v_total_final;


end; //
DELIMITER ;


select id as id_pedido, fecha,tipo_pedido, total_pedido(id) as total_pedido from pedidos ORDER BY id ASC;




-- 2. Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).

DELIMITER //
CREATE FUNCTION calculo_ganancia(v_fecha_diaria date)
RETURNS double
deterministic
reads sql data

BEGIN
DECLARE v_precio_venta double;
DECLARE v_costo double;
DECLARE v_ganancia double;
DECLARE v_fecha_diaria date; -- Creo que es opcional 



SELECT id_id
-- sacar el costo ingredientes x pizza
SELECT COALESCE(SUM(dp.subtotal),0) into v_costo
from pizza pi LEFT JOIN detalle_pizza dp on pi.id=dp.id_pizza 
GROUP BY dp.id_pizza; -- funcial pero genera un error la data esta incompleta pero al invocar una pizza sin detalle_pizza pierde el orden

SELECT sum(total) 
GROUP BY fecha -- agrupar por dia para saber el total x dia


SELECT SUM(dp.subtotal), p.precio,SUM(dp.subtotal)-p.precio into v_costo, v_precio_venta,v_ganancia
from detalle_pizza dp left join pizza p on dp.id_pizza=p.id GROUP BY id_pizza ;


end; //
DELIMITER ;






























































-- Cosas posiblemente utiles

-- conseguir el total del pedido(sin domicilio aun) en base del detalle_pedido
SELECT SUM(pi.precio)
FROM pedidos ped LEFT JOIN detalle_pedido dp on ped.id=dp.id_pedido 
LEFT JOIN pizza pi on dp.id_pizza=pi.id  
WHERE ped.id= 1
GROUP BY ped.fecha;  