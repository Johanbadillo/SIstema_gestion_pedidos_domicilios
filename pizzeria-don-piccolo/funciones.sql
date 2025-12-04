/*Funciones y Procedimientos
Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.*/


-- esctructura function
/*
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
*/
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
DECLARE v_neto_diario double;
select sum(dp.subtotal)-sum(dpi.subtotal) into v_neto_diario 
from detalle_pedido dp 
left join pizza p on dp.id_pizza=p.id 
left join detalle_pizza dpi on p.id=dpi.id_pizza
left join pedidos ped on ped.id=dp.id_pedido where fecha=v_fecha_diaria;
RETURN v_neto_diario;

end; //
DELIMITER ;

select calculo_ganancia('fecha');
select calculo_ganancia('2025-11-01');



-- 3. Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.
DELIMITER //
DROP procedure if EXISTS marcar_pedido_como_entregado;
create procedure marcar_pedido_como_entregado(in v_id_pedido int)
begin
DECLARE v_hora_entrega DATETIME;

    SELECT d.hora_entrega INTO v_hora_entrega
    FROM domicilio d
    WHERE d.id_pedido = v_id_pedido;

if v_hora_entrega <=now() then
    update pedidos p
    set p.estado = 'entregado' 
    where p.id = v_id_pedido;
end if;

end; //
DELIMITER ;

CALL marcar_pedido_como_entregado(1);
























































-- Cosas posiblemente utiles

-- conseguir el total del pedido(sin domicilio aun) en base del detalle_pedido
SELECT SUM(pi.precio)
FROM pedidos ped LEFT JOIN detalle_pedido dp on ped.id=dp.id_pedido 
LEFT JOIN pizza pi on dp.id_pizza=pi.id  
WHERE ped.id= 1
GROUP BY ped.fecha;  