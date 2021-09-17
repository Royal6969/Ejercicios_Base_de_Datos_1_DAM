-------------------- 2.	Crea las tablas inicialmente SIN RESTRICCIONES y posteriormente añade las que sean necesarias para representar el siguiente esquema relacional: ----------------

CREATE TABLE Cliente (
num_cli number(10),
saldo_cli number(6,2),
lim_cred_cli number(6,2),
dto_cli number(5,2)
);

CREATE TABLE Pedidos (
num_pedido number(10),
fecha_pedido date,
num_cli number(10),
cod_direcc_pedido number(10)
);

CREATE TABLE Direccion (
cod_direcc_pedido number(10),
via varchar2(8),
nom_via varchar2(30),
n_calle number(3),
piso number(2),
portal number(2),
cod_postal number(5)
);

CREATE TABLE Articulo (
num_articulo number(10),
descripcion_articulo varchar2(50)
);

CREATE TABLE Fabrica (
num_fabrica number(10),
tlfn_fabrica number(9)
);

CREATE TABLE Posee (
num_cli number(10),
cod_direcc_pedido number(10)
);

CREATE TABLE Incluye (
num_pedido number(10),
num_articulo number(10)
);

CREATE TABLE Distribuye (
num_articulo number(10),
num_fabrica number(10),
cant_suministro number(10),
existencias number(10)
);

ALTER TABLE Cliente ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (num_cli);
ALTER TABLE Pedidos ADD CONSTRAINT PK_PEDIDOS PRIMARY KEY (num_pedido);
ALTER TABLE Direccion ADD CONSTRAINT PK_DIRECCION PRIMARY KEY (cod_direcc_pedido);
ALTER TABLE Articulo ADD CONSTRAINT PK_ARTICULO PRIMARY KEY (num_articulo);
ALTER TABLE Fabrica ADD CONSTRAINT PK_FABRICA PRIMARY KEY (num_fabrica);

ALTER TABLE Posee ADD CONSTRAINT PK_POSEE PRIMARY KEY (num_cli, cod_direcc_pedido);
ALTER TABLE Incluye ADD CONSTRAINT PK_INCLUYE PRIMARY KEY (num_pedido, num_articulo);
ALTER TABLE Distribuye ADD CONSTRAINT PK_DISTRIBUYE PRIMARY KEY (num_articulo, num_fabrica);

ALTER TABLE Posee ADD CONSTRAINT FK_POSEE_1 FOREIGN KEY (num_cli) REFERENCES Cliente (num_cli);
ALTER TABLE Posee ADD CONSTRAINT FK_POSEE_2 FOREIGN KEY (cod_direcc_pedido) REFERENCES Direccion (cod_direcc_pedido);
ALTER TABLE Incluye ADD CONSTRAINT FK_INCLUYE_1 FOREIGN KEY (num_pedido) REFERENCES Pedidos (num_pedido);
ALTER TABLE Incluye ADD CONSTRAINT FK_INCLUYE_2 FOREIGN KEY (num_articulo) REFERENCES Articulo (num_articulo);
ALTER TABLE Distribuye ADD CONSTRAINT FK_DISTRIBUYE_1 FOREIGN KEY (num_articulo) REFERENCES Articulo (num_articulo);
ALTER TABLE Distribuye ADD CONSTRAINT FK_DISTRIBUYE_2 FOREIGN KEY (num_fabrica) REFERENCES Fabrica (num_fabrica);

----------------------------- 3.	Crea un sinónimo justificando tu elección ----------------------

CREATE SYNONYM Cli FOR Cliente;
CREATE SYNONYM Pedi FOR Pedidos;
CREATE SYNONYM Direcc FOR Direccion;
CREATE SYNONYM Art FOR Articulo;
CREATE SYNONYM Cli FOR Fabrica;

--------------- 4.	Crea un índice justificando tu elección. ----------------

CREATE INDEX Entrega ON Direccion (via, nom_via, n_calle);

--------------5.	Elige una tabla y atributo, y justificando tu elección crea una secuencia que creas que podrías aplicar. Explica sus parámetros. -----------------

CREATE SEQUENCE N_PEDIDO 
INCREMENT BY 1
START WITH 10000
MAXVALUE 99999
NOCYCLE;

---------- 6.	Crea una vista que nos ofrezca alguna utilidad. Justifica tu elección. -----------------

CREATE VIEW Descuento AS SELECT num_cli, dto_cli FROM Cliente;








