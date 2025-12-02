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


select id, total_pedido(id) from pedidos;











