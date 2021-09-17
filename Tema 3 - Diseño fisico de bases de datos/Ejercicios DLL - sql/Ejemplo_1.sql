create table cliente(
    
    DNI int primary key,
    nombre varchar(20),
    apellido varchar(20),
    direccion varchar(50),
    poblacion varchar(20),
    provincia varchar(20),
    CP varchar(5)
);

select * from cliente;

ALTER TABLE cliente MODIFY (NOMBRE VARCHAR2(30)NOT NULL);

ALTER TABLE cliente DROP COLUMN DNI;

ALTER TABLE cliente ADD NIF varchar2(10);

ALTER TABLE cliente ADD CONSTRAINT PK_cliente PRIMARY KEY (NIF);

insert into cliente (DNI, nombre, apellido, direccion, poblacion, provincia, CP) values(12345678, 'Sergio', 'Diaz', 'Luis Montoto', 'Sevilla', 'Sevilla', 41005);

select * from cliente;

insert into cliente (DNI, nombre, apellido, direccion, poblacion, provincia, CP) values(10203040, 'Anuel', '2blea', 'Calle Los Dioses', 'PR', 'Puerto Rico', 12345);
insert into cliente (DNI, nombre, apellido, direccion, poblacion, provincia, CP) values(11223344, 'Ozuna', 'Negrito', 'Avenida Ojos Claros', 'CubaLibre', 'Cuba', 11223);

select * from cliente;

update cliente SET poblacion = 'San Juan';

select * from cliente;

update cliente SET poblacion = 'PR' where DNI = 10203040;

select * from cliente;

delete from cliente where DNI = 11223344;

ALTER TABLE cliente ADD CONSTRAINT MAYUS CHECK (PROVINCIA=UPPER(PROVINCIA));

ALTER TABLE cliente MODIFY (NOMBRE VARCHAR2(30)NOT NULL);

create table fabricante(

    COD_FABRICANTE number(3),
    NOMBRE varchar2(15),
    PAIS varchar2(15)
);

select * from fabricante;

ALTER TABLE fabricante ADD CONSTRAINT PK_COD_FABRICANTE PRIMARY KEY (COD_FABRICANTE);
ALTER TABLE fabricante ADD CONSTRAINT MAYUS CHECK (PAIS=UPPER(PAIS));

create table articulo(

    ARTICULO varchar2(20),
    COD_FABRICANTE number(3),
    PESO number(3),
    CATEGORIA varchar2(10),
    PRECIO_VENTA number(6,2),
    PRECIO_COSTO number(6,2),
    EXISTENCIAS number(5)
);

ALTER TABLE articulo ADD CONSTRAINT PK_CLAVE PRIMARY KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA);

ALTER TABLE articulo ADD CONSTRAINT FK_FAB FOREIGN KEY (COD_FABRICANTE) REFERENCES fabricante ON DELETE CASCADE;

ALTER TABLE articulo ADD CONSTRAINT mayorque0 CHECK (PRECIO_VENTA > 0 AND PRECIO_COSTO > 0 AND PESO > 0);

ALTER TABLE articulo ADD CONSTRAINT identificador1 CHECK (categoria IN ('PRIMERA','SEGUNDA','TERCERA'));

select * from articulo;

create table ventas(

    NIF varchar2 (10),
    ARTICULO varchar2 (20),
    COD_FABRICANTE number(3),
    PESO number(3),
    CATEGORIA varchar2 (10),
    FECHA_VENTAS date,
    UND_VENDIDAS number (4)
)

ALTER TABLE ventas ADD CONSTRAINT PK_CLAVE PRIMARY KEY (NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_VENTAS);

ALTER TABLE ventas ADD CONSTRAINT FK_ventas FOREIGN KEY (NIF) REFERENCES cliente ON DELETE CASCADE;

ALTER TABLE ventas ADD CONSTRAINT FK_ventas FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA) REFERENCES articulo ON DELETE CASCADE; -- por que no me funciona??

ALTER TABLE ventas ADD CONSTRAINT mayorque00 CHECK (UND_VENDIDAS > 0); -- he añadido un 0 a "mayorque0" porque sino se repite la etiqueta

ALTER TABLE ventas ADD CONSTRAINT identificador2 CHECK (categoria IN ('PRIMERA','SEGUNDA','TERCERA')); -- vamos cambiando el nombre del identificador con numeros

select * from ventas;

create table pedidos (

    NIF varchar2 (10),
    ARTICULO varchar2 (20),
    COD_FABRICANTE number(3),
    PESO number(3),
    CATEGORIA varchar2 (10),
    FECHA_PEDIDO date,
    UND_PEDIDAS number (4),
    EXISTENCIAS number(5)
)

ALTER TABLE pedidos ADD CONSTRAINT PK_PEDIDO PRIMARY KEY (NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_PEDIDO); --recuerda ir cambiando los identificadores, orden lógico Ser!!!

ALTER TABLE pedidos ADD CONSTRAINT FK_PEDIDOS FOREIGN KEY (NIF) REFERENCES cliente ON DELETE CASCADE;

ALTER TABLE pedidos ADD CONSTRAINT FK_PEDIDOS2 FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA) REFERENCES articulo ON DELETE CASCADE; -- por que no me funciona??

ALTER TABLE pedidos ADD CONSTRAINT mayorque000 CHECK (UND_PEDIDAS > 0); -- he añadido un 0 a "mayorque0" porque sino se repite la etiqueta

ALTER TABLE pedidos ADD CONSTRAINT identificador3 CHECK (categoria IN ('PRIMERA','SEGUNDA','TERCERA')); -- vamos cambiando el nombre del identificador con numeros

select * from pedidos;

SELECT INITCAP (nombre) FROM cliente;

ALTER TABLE ventas MODIFY (UND_VENDIDAS number(6));

ALTER TABLE pedidos MODIFY (UND_PEDIDAS number(6));

ALTER TABLE ventas ADD PVP number(5,2);

ALTER TABLE pedidos ADD PVP number(5,2);

ALTER TABLE cliente ADD CONSTRAINT RES_TOLEDO CHECK (provincia!='toledo');



