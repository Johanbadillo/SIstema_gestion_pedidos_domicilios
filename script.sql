DROP DATABASE IF EXISTS pizzeria_don_piccolo;

CREATE DATABASE pizzeria_don_piccolo;

USE pizzeria_don_piccolo;

/*Creacion e inserciones ya encontradas en database.sql*/
CREATE TABLE persona (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    nombre VARCHAR(50) not null,
    apellido VARCHAR(50) not null,
    documento VARCHAR(20) not null,
    tipoDocumento ENUM('cc','ce') not null
);

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    tipoCliente VARCHAR(50) not null,
    FOREIGN KEY (id) REFERENCES persona(id)
);

CREATE TABLE zona (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    nombre VARCHAR(50) not null
);

CREATE TABLE repartidores (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    zona INT not null,
    estado ENUM('disponible','no_disponible') not null,
    FOREIGN KEY (id) REFERENCES persona(id),
    FOREIGN KEY (zona) REFERENCES zona(id)
);

CREATE TABLE trabajadores (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    tipo_trabajador VARCHAR(50) not null,
    fecha_ingreso DATETIME not NULL,
    FOREIGN KEY (id) REFERENCES persona(id)
);

CREATE TABLE pizza (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    nombre VARCHAR(80) not null,
    tamaño ENUM('pequeña','mediana','grande') not null,
    precio DOUBLE not null,
    tipo_pizza ENUM('vegetariana','especial','clasica') not null
);

CREATE TABLE ingredientes (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    nombre VARCHAR(50) not null,
    stock INT not null,
    precio_unidad INT not null
);

CREATE TABLE detalle_pizza (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    id_ingredientes INT not null,
    id_pizza INT not null,
    cantidad INT not null,
    subtotal DOUBLE not null,
    FOREIGN KEY (id_ingredientes) REFERENCES ingredientes(id),
    FOREIGN KEY (id_pizza) REFERENCES pizza(id)
);
/*Creación de tabla de pedidos
Crear una tabla pedidos con los siguientes campos:
id_pedido (PK, autoincremental)
id_cliente (FK que apunte a clientes)
fecha_pedido (DATE)
metodo_pago (VARCHAR)
estado (ENUM: 'pendiente', 'preparacion', 'entregado', 'cancelado')
total (DECIMAL(10,2))*/
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    id_cliente INT not null,
    fecha DATE not null,
    hora time not NULL,
    estado ENUM('pendiente', 'en preparación', 'entregado', 'cancelado') not null,
    total DOUBLE not null,
    recibido DOUBLE not null,
    estado_pago ENUM('abonado','pendiente','pagado') not null,
    descripcion VARCHAR(255) not null,
    tipo_pedido ENUM('local','domicilio') not null,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);
/*Creación de tabla intermedia
Crear una tabla pedido_pizza que relacione los pedidos con las pizzas.
Campos mínimos: id_pedido, id_pizza, cantidad.*/
CREATE TABLE detalle_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    id_pedido INT not null,
    id_pizza INT not null,
    cantidad INT not null,
    subtotal DOUBLE not null,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_pizza) REFERENCES pizza(id)
);

CREATE TABLE domicilio (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    id_pedido INT not null,
    id_repartidor INT not null,
    direccion VARCHAR(255) not null,
    costo_domicilio DOUBLE not null,
    descripcion VARCHAR(255) not null,
    hora_salida DATETIME not null,
    hora_entrega DATETIME not null,
    distancia_aproximada DOUBLE not null,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id)
);

CREATE TABLE pago (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    metodo ENUM('efectivo','tarjeta','app') not null,
    id_pedido INT not null,
    descripcion VARCHAR(255) not null,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);



INSERT INTO zona (nombre) VALUES 
('Florida'), ('Girón'), ('Cabecera'), ('Sotomayor'), ('Provenza'), ('La Cumbre');


INSERT INTO persona (nombre, apellido, documento, tipoDocumento) VALUES
('Juan José',        'Pérez Gómez',      '1037654321', 'cc'),
('María Camila',     'López Ruiz',       '1002345678', 'cc'),
('Carlos Andrés',    'Ramírez Soto',     '9876543210', 'cc'),
('Laura Valentina',  'García Mendoza',   '1122334455', 'cc'),
('Pedro José',       'Morales Díaz',     '5566778899', 'cc'),
('Ana Sofía',        'Hernández Vega',   '6677889900', 'cc'),
('Diego Armando',    'Martínez Castro',  '1234567890', 'cc'),
('Valeria',          'Torres Ospina',    '9988776655', 'cc'),
('Camilo Andrés',    'Ríos Salazar',     '1112223334', 'cc'),
('Luis Miguel',      'Gómez Arias',      '2223334445', 'cc'),
('Felipe',           'Vargas Ortiz',     '3334445556', 'cc'),
('Daniela',          'Quintero Bedoya',  '4445556667', 'cc'),
('Santiago',         'Castro Jiménez',   '5556667778', 'cc'),
('Valentina',        'Rojas Peña',       '6667778889', 'cc'),
('Mateo',            'Silva Ortiz',      '7778889990', 'cc'), 
('Andrés Felipe',    'Ortiz Ramírez',    '8889990001', 'cc'),
('Sofía Alejandra',  'Ruiz Mendoza',     '9990001112', 'cc'),
('Nicolás',          'Bedoya Castro',    '1112223335', 'cc'),
('Isabella',         'Gómez Salazar',    '2223334446', 'cc'),
('Sebastián',        'Pérez Ospina',     '3334445557', 'cc'),
('Gabriela',         'López Vargas',     '4445556668', 'cc'),
('Alejandro',        'Morales Quintero', '5556667779', 'cc'),
('Catalina',         'Hernández Ríos',   '6667778890', 'cc'),
('Julián',           'Martínez Silva',   '7778889901', 'cc'),
('Emma',             'Torres Bedoya',    '8889990012', 'cc'),
('Samuel',           'García Ortiz',     '9990001123', 'cc'),
('Lucía',            'Ramírez Peña',     '1112223345', 'cc'),
('Martín',           'Castro Gómez',     '2223334456', 'cc'),
('Sara',             'Vargas Mendoza',   '3334445567', 'cc'),
('Emilio',           'Ríos Castro',      '4445556678', 'cc');


INSERT INTO clientes (id, tipoCliente) VALUES
(1,'frecuente'),(2,'frecuente'),(3,'ocasional'),(4,'nuevo'),(5,'frecuente'),
(6,'ocasional'),(7,'frecuente'),(8,'nuevo'),(9,'frecuente'),(10,'ocasional'),
(11,'frecuente'),(12,'nuevo'),(13,'ocasional'),(14,'frecuente'),(15,'frecuente'),
(16,'ocasional'),(17,'nuevo'),(18,'frecuente'),(19,'ocasional'),(20,'frecuente');


INSERT INTO repartidores (id, zona, estado) VALUES
(21,1,'disponible'),(22,2,'disponible'),(23,3,'no_disponible'),(24,4,'disponible'),(25,5,'disponible');


INSERT INTO trabajadores (id, tipo_trabajador, fecha_ingreso) VALUES
(26,'cajero','2023-03-15 08:00:00'),
(27,'cocinero','2022-07-20 07:30:00'),
(28,'cocinero','2023-11-10 07:45:00'),
(29,'cajero','2024-01-05 09:00:00'),
(30,'gerente','2021-06-01 10:00:00');


INSERT INTO pizza (nombre, tamaño, precio, tipo_pizza) VALUES
('Margarita',           'mediana',  28900, 'clasica'),
('Hawaiana',            'grande',   39900, 'clasica'),
('Pepperoni',           'pequeña',  25900, 'clasica'),
('Vegetariana Deluxe',  'mediana',  34900, 'vegetariana'),
('Cuatro Quesos',       'grande',   44900, 'especial'),
('Carnívora',           'grande',   49900, 'especial'),
('Pollo Champiñones',   'mediana',  37900, 'clasica'),
('Napolitana',          'pequeña',  26900, 'clasica'),
('Mexicana Picante',    'grande',   45900, 'especial'),
('Barbacoa BBQ',        'grande',   47900, 'especial'),
('Pollo BBQ',           'mediana',  38900, 'clasica'),
('Hawaiana Especial',   'grande',   42900, 'clasica');


INSERT INTO ingredientes (nombre, stock, precio_unidad) VALUES
('Queso Mozzarella',250,8500),('Salsa Tomate',400,4200),('Pepperoni',150,13000),
('Jamón',120,11000),('Piña',100,6500),('Champiñones',180,7000),
('Aceitunas',90,5500),('Pimentón',130,4500),('Cebolla',140,3500),
('Pollo Desmechado',100,16000),('Carne Molida',90,14000),('Queso Cheddar',120,9000),
('Bacon',80,18000),('Chorizo',70,15000),('Jalapeños',60,8000);


INSERT INTO detalle_pizza (id_ingredientes, id_pizza, cantidad, subtotal) VALUES
(1,1,400,17000),(2,1,200,4200),
(1,2,500,21250),(3,2,300,39000),(4,2,300,33000),(5,2,400,26000),
(1,3,400,17000),(2,3,200,4200),(3,3,500,65000),
(1,4,500,21250),(6,4,300,21000),(7,4,200,11000),(8,4,300,13500),(9,4,300,10500),
(1,5,600,25500),(12,5,300,27000),
(1,6,500,21250),(3,6,400,52000),(11,6,400,56000),(14,6,200,30000);


INSERT INTO pedidos (id_cliente, fecha, hora, estado, total,recibido,estado_pago, descripcion, tipo_pedido) VALUES
(1,'2025-11-01','18:30:00','entregado',68800,0,'abonado','Sin piña por favor','domicilio'),
(2,'2025-11-02','19:15:00','entregado',70800,0,'abonado','Extra queso en ambas','local'),
(3,'2025-11-03','20:00:00','entregado',155800,0,'abonado','Para fiesta de 15','domicilio'),
(5,'2025-11-05','19:45:00','entregado',97800,0,'abonado','Cumpleaños infantil','domicilio'),
(7,'2025-11-08','20:30:00','entregado',147800,0,'abonado','Con gaseosas incluidas','domicilio'),
(10,'2025-11-10','19:00:00','en preparación',94800,0,'abonado','Urgente por favor','domicilio'),
(12,'2025-11-12','18:20:00','entregado',127700,10000,'abonado','Para ver fútbol','domicilio'),
(15,'2025-11-15','13:30:00','entregado',53800,0,'abonado','Almuerzo familiar','local'),
(18,'2025-11-18','20:15:00','cancelado',49900,49900,'abonado','Cliente cambió de idea','domicilio'),
(20,'2025-11-20','12:45:00','entregado',86800,49900,'abonado','Dos grandes carnívoras','local'),
(1,'2025-11-22','19:30:00','entregado',73800,0,'abonado','Sin cebolla','domicilio'),
(4,'2025-11-25','18:00:00','entregado',28900,0,'abonado','Solo una margarita','local'),
(6,'2025-11-28','20:45:00','entregado',107800,0,'abonado','Para reunión de trabajo','domicilio'),
(9,'2025-12-01','19:10:00','entregado',127900,0,'abonado','Cena navideña','domicilio');


INSERT INTO detalle_pedido (id_pedido, id_pizza, cantidad, subtotal) VALUES
(1,2,1,39900),(1,1,1,28900),
(2,5,1,44900),(2,6,1,49900),
(3,6,2,99800),(3,10,1,47900),(3,2,1,39900),
(4,6,1,49900),(4,10,1,47900),
(5,6,2,99800),(5,5,1,44900),
(6,10,1,47900),(6,5,1,44900),
(7,6,1,49900),(7,10,1,47900),(7,2,1,39900),
(8,4,1,34900),(8,7,1,37900),
(10,6,2,99800),(10,5,1,44900),
(11,6,1,49900),(11,2,1,39900),
(12,1,1,28900),(12,4,1,34900),(12,9,1,45900),
(13,6,1,49900),(13,10,1,47900),(13,2,1,39900),
(14,6,2,99800),(14,5,1,44900),(14,3,1,25900);


INSERT INTO domicilio (id_pedido, id_repartidor, direccion, costo_domicilio, descripcion, hora_salida, hora_entrega, distancia_aproximada) VALUES
(1,21,'Calle 45 #23-15 Florida',6000,'Portería avisa','2025-11-01 18:45:00','2025-11-01 19:10:00',4.8),
(3,22,'Carrera 33 Cabecera',8000,'Edificio alto apt 802','2025-11-03 20:15:00','2025-11-03 20:50:00',7.2),
(4,23,'Transversal 93 Girón',9000,'Conjunto cerrado','2025-11-05 20:00:00','2025-11-05 20:35:00',9.1),
(5,24,'Calle 56 Sotomayor',5000,'Casa azul','2025-11-08 20:45:00','2025-11-08 21:15:00',6.3),
(6,25,'Carrera 27 Provenza',7000,'Local comercial','2025-11-10 19:15:00','2025-11-10 19:40:00',5.7),
(7,21,'Calle 104 Florida',6500,'Condominio','2025-11-12 18:35:00','2025-11-12 19:05:00',8.1),
(11,22,'Calle 200 La Cumbre',9500,'Casa grande','2025-11-22 19:45:00','2025-11-22 20:20:00',10.8);


INSERT INTO pago (id_pedido, metodo, descripcion) VALUES
(1,'efectivo','Pagó con 80000, devuelta 5200'),
(2,'tarjeta','Débito Bancolombia'),
(3,'app','Pago por Nequi'),
(4,'efectivo','Pagó con 100000'),
(5,'app','Daviplata'),
(6,'tarjeta','Crédito'),
(7,'efectivo','Exacto'),
(8,'app','Rappi Pay'),
(10,'efectivo','Pagó con 100000'),
(11,'tarjeta','Débito'),
(12,'app','Nequi'),
(13,'efectivo','Pagó con 150000'),
(14,'tarjeta','Crédito');




alter table ingredientes add column stock_minimo int default 30;

CREATE TABLE IF NOT EXISTS historial_precios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_pizza INT,
        precio_anterior DOUBLE,
        precio_nuevo DOUBLE,
        fecha_cambio DATETIME);


/*insercion necesaria para poder verificar el punto de clientes frecuentes esto es adicional a la de que encuentra en database*/
INSERT INTO pedidos (id_cliente, fecha, hora, estado, total,recibido,estado_pago, descripcion, tipo_pedido) VALUES
(1,'2025-11-01','18:30:00','entregado',68800,0,'abonado','Sin piña por favor','domicilio'),
(1,'2025-11-02','19:15:00','entregado',70800,0,'abonado','Extra queso en ambas','local'),
(1,'2025-11-03','20:00:00','entregado',155800,0,'abonado','Para fiesta de 15','domicilio'),
(1,'2025-11-05','19:45:00','entregado',97800,0,'abonado','Cumpleaños infantil','domicilio'),
(1,'2025-11-08','20:30:00','entregado',147800,0,'abonado','Con gaseosas incluidas','domicilio'),
(1,'2025-11-10','19:00:00','en preparación',94800,0,'abonado','Urgente por favor','domicilio'),
(1,'2025-11-12','18:20:00','entregado',127700,10000,'abonado','Para ver fútbol','domicilio');





/*Consulta de pedidos por cliente
Consulta SQL que muestre el nombre del cliente, el ID del pedido, el total y el estado del pedido. */
DROP PROCEDURE if EXISTS pedidos_clientes;
DELIMITER //
CREATE PROCEDURE pedidos_clientes()
BEGIN
SELECT concat(pe.nombre,' ',pe.apellido) as nombre_cliente, p.id as id_pedido, p.total as total_pedido,p.estado as estado_pedido
FROM pedidos p left JOIN persona pe on p.id_cliente=pe.id
ORDER BY total_pedido DESC;
end; //
DELIMITER ;

call pedidos_clientes;


/*Consulta de pedidos entregados en un rango de fechas
Mostrar los pedidos con estado entregado cuya fecha esté entre dos fechas dadas (usa BETWEEN).*/
DROP PROCEDURE if EXISTS clientes_pedidos_rango;
DELIMITER //
CREATE PROCEDURE clientes_pedidos_rango(in fecha_incio date,in fecha_final date)
BEGIN
SELECT * from pedidos WHERE estado='entregado' and DATE(fecha) BETWEEN fecha_incio and fecha_final ORDER BY fecha DESC;
end; //
DELIMITER ;

call clientes_pedidos_rango('2025-01-01','2025-12-31');


/*Consulta de resumen de pedidos por método de pago
Mostrar cuántos pedidos se hicieron por cada método de pago y el total acumulado (GROUP BY).*/
DROP PROCEDURE if EXISTS resumen_metodo_pago;
DELIMITER //
CREATE PROCEDURE resumen_metodo_pago()
BEGIN
SELECT sum(p.total) as total_por_metodo_pago, pa.metodo as metodo_pagado 
FROM pago pa left JOIN pedidos p on pa.id_pedido=p.id
GROUP BY metodo_pagado
ORDER BY total_por_metodo_pago DESC;
end; //
DELIMITER ;

call resumen_metodo_pago;

/*Consulta de clientes frecuentes
Mostrar los clientes que tengan más de 5 pedidos en total (usa HAVING COUNT(*) > 5).*/
DROP PROCEDURE if EXISTS clientes_frecuentes;
DELIMITER //
CREATE PROCEDURE clientes_frecuentes()
BEGIN
SELECT p.id_cliente, COUNT(*) as cantidad_pedidos, concat(pe.nombre,' ',pe.apellido) as nombre_completo 
from pedidos p left join persona pe on p.id_cliente=pe.id 
GROUP by p.id_cliente HAVING cantidad_pedidos>=5; 
end; //
DELIMITER ;

call clientes_frecuentes();