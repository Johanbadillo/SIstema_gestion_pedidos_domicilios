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
    precio INT not null
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

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT not null,
    id_cliente INT not null,
    fecha DATE not null,
    estado ENUM('pendiente', 'en preparación', 'entregado', 'cancelado') not null,
    total DOUBLE not null,
    descripcion VARCHAR(255) not null,
    tipo_pedido ENUM('local','domicilio') not null,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

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
    dirrecion VARCHAR(255) not null,
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