----------------------- 1.	Realiza el diseño físico para el siguiente modelo relacional. Asigna el tipo de datos que consideres más adecuado. Realiza el diseño sin restricciones. ----------------------

CREATE TABLE Sucursal (
cod_sucursal number(10),
nom_sucursal varchar2(20),
direcc_sucursal varchar2(30),
local_sucursal varchar2(20),
CONSTRAINT PK_SUCURSAL PRIMARY KEY (cod_sucursal)
);

CREATE TABLE Cliente (
dni_cli varchar2(9),
nom_cli varchar2(20),
direcc_cli varchar2(30),
local_cli varchar2(20),
fecha_nac date,
sexo varchar2(10),
CONSTRAINT PK_CLIENTE PRIMARY KEY (dni_cli)
);

CREATE TABLE Cuenta (
cod_sucursal number(10),
cod_cuenta number(10),
CONSTRAINT PK_CUENTA PRIMARY KEY (cod_sucursal, cod_cuenta),
CONSTRAINT FK_CUENTA FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal)
);

CREATE TABLE Transaccion (
cod_sucursal number(10),
cod_cuenta number(10), 
num_transaccion number(10),
fecha_transaccion date,
cantidad_transaccion number(9,2),
tipo_transaccion varchar2(10),
CONSTRAINT PK_TRANSACCION PRIMARY KEY (cod_sucursal, cod_cuenta, num_transaccion),
CONSTRAINT FK_TRANSACCION FOREIGN KEY (cod_sucursal, cod_cuenta) REFERENCES Cuenta (cod_sucursal, cod_cuenta)
);

CREATE TABLE CliCuenta (
cod_sucursal number(10), 
cod_cuenta number(10),
dni_cli varchar2(9),
CONSTRAINT PK_CLICUENTA PRIMARY KEY (cod_sucursal, cod_cuenta, dni_cli),
CONSTRAINT FK_CLICUENTA FOREIGN KEY (cod_sucursal, cod_cuenta) REFERENCES Cuenta (cod_sucursal, cod_cuenta),
CONSTRAINT FK_CLICUENTA_DNI FOREIGN KEY (dni_cli) REFERENCES Cliente (dni_cli)
);

DROP TABLE Sucursal CASCADE CONSTRAINTS PURGE;
DROP TABLE Cliente CASCADE CONSTRAINTS PURGE;
DROP TABLE Cuenta CASCADE CONSTRAINTS PURGE;
DROP TABLE Transaccion CASCADE CONSTRAINTS PURGE;
DROP TABLE CliCuenta CASCADE CONSTRAINTS PURGE;

----------------------- 2.	Modifica el ancho de columna del código de sucursal. Presta atención a la coherencia entre tablas -----------------

ALTER TABLE Sucursal MODIFY cod_sucursal number(20);
ALTER TABLE Cuenta MODIFY cod_sucursal number(20);
ALTER TABLE Transaccion MODIFY cod_sucursal number(20);
ALTER TABLE CliCuenta MODIFY cod_sucursal number(20);

----------------------- 3.	Añade las restricciones necesarias (utilizando etiquetas para cada restricción): --------------------

--------------------- 4.	Añade la tabla teléfonos y enlázalo a clientes, de tal forma que cada cliente pueda tener más de un teléfono asignado. ----------
--------------------- Considerar teléfonos una entidad débil con clave compuesta de DNI y un contador de teléfonos de cada usuario. -------------------------

CREATE TABLE Telefonos (
dni_cli varchar2(9),
tlfn_cli number(9),
CONSTRAINT PK_TELEFONOS PRIMARY KEY (dni_cli),
CONSTRAINT FK_TELEFONOS FOREIGN KEY (dni_cli) REFERENCES Cliente (dni_cli)
);

CREATE SEQUENCE contador_telefonos 
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCYCLE;

---------------------- 5.	Añade a la tabla cliente el campo “email”: ----------------------

ALTER TABLE Cliente ADD email varchar2(30);
ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_EMAIL CHECK(email='%@%.com');

---------------------- 6.1.	 Edad mayor o igual a 18 ----------------------

ALTER TABLE Cliente ADD edad number(2);
ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_EDAD CHECK(edad>=18);

---------------------- 6.2.	 Fecha de transacción igual o posterior a hoy ----------------------

ALTER TABLE Transaccion ADD CONSTRAINT CHECK_TRANSACCION_FECHA CHECK(fecha_transaccion >= DATE '2021-02-12'); --fecha superior a hoy Viernes 12/02/2021

---------------------- 6.3.	 Fecha de nacimiento anterior a hoy. ----------------------

ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_FECHANAC CHECK(fecha_nac <= DATE '2021-02-12'); --fecha inferior a hoy Viernes 12/02/2021

---------------------- 6.4.	 Tipo de transacción: T – Transferencia, D – Domiciliación -------------

TRUNCATE TABLE Transaccion;
ALTER TABLE Transaccion ADD CONSTRAINT CHECK_TRANSACCION_TIPO CHECK(tipo_transaccion='T' OR tipo_transaccion='D');

---------------------- 6.5.	 Localidad (para sucursal y cliente) debe empezar en una letra mayúscula ------------------------

ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_LOCALIDAD_INITCAP CHECK(local_cli=INITCAP(local_cli));
ALTER TABLE Sucursal ADD CONSTRAINT CHECK_SUCURSAL_LOCALIDAD_INITCAP CHECK(local_sucursal=INITCAP(local_sucursal));

---------------------- 6.6. Sexo del cliente debe ser: H – Hombre, M – Mujer ------------------------------

TRUNCATE TABLE Cliente;
ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_SEXO CHECK(sexo='H' OR sexo='M');

---------------------- 7.	Modifica la restricción “Tipo de transacción” para añadir “I – Ingreso” ------------------------

ALTER TABLE Transaccion DROP CONSTRAINT CHECK_TRANSACCION_TIPO;
ALTER TABLE Cliente DROP CONSTRAINT CHECK_CLIENTE_SEXO;

TRUNCATE TABLE Transaccion;
ALTER TABLE Transaccion ADD CONSTRAINT CHECK_TRANSACCION_TIPO CHECK(tipo_transaccion='T' OR tipo_transaccion='D' OR tipo_transaccion='I');

TRUNCATE TABLE Cliente;
ALTER TABLE Cliente ADD CONSTRAINT CHECK_CLIENTE_SEXO CHECK(sexo='H' OR sexo='M');


---------------------- 8.	Crea 3 índices que consideres de utilidad. ---------------------------------------------------

CREATE INDEX Nombres_Clientes ON Cliente (nom_cli, dni_cli, fecha_nac);
CREATE INDEX Codigos_Sucursales ON Sucursal (cod_sucursal, nom_sucursal);
CREATE INDEX Historial_Transacciones ON Transaccion (fecha_transaccion, num_transaccion, cantidad_transaccion, cod_cuenta);

---------------------- 9.	Crea secuencias para aquellos campos que consideres de utilidad. -------------------------------

CREATE SEQUENCE Codigos_Sucursales 
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCYCLE;

CREATE SEQUENCE DNI_Clientes 
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCYCLE;

CREATE SEQUENCE Codigos_Cuentas 
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCYCLE;

CREATE SEQUENCE Numero_Transacciones 
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCYCLE;

---------------------- 10.	Crea sinónimos para una tabla y una secuencia. ---------------------------------------

CREATE SYNONYM trans FOR Transaccion;
CREATE SYNONYM nTrans FOR Numero_Transacciones;

---------------------- 11.	Crea una vista que simplifique la tabla de cliente. -------------------------------

CREATE VIEW v_cliente AS SELECT dni_cli, nom_cli FROM Cliente;

---------------------- 12.	Realiza una inserción para cada tabla. --------------------------------------------

INSERT INTO Sucursal (cod_sucursal, nom_sucursal, direcc_sucursal, local_sucursal) VALUES(10000, 'sevilla este', 'Av/de las Ciencias N55', 'sevilla');
INSERT INTO Cliente (dni_cli, nom_cli, direcc_cli, local_cli, fecha_nac, sexo) VALUES('10203040A', 'Sergio', 'Av/de las Ciencias 4B', 'sevilla', '17041995', 'H');
INSERT INTO Cuenta (cod_sucursal, cod_cuenta) VALUES(10000, 25053006);
INSERT INTO Transaccion (cod_sucursal, cod_cuenta, num_transaccion, fecha_transaccion, cantidad_transaccion, tipo_transaccion) VALUES(10000, 25053006, 11111, '13022021', 10.50, 'T');
INSERT INTO CliCuenta (cod_sucursal, cod_cuenta, dni_cli) VALUES(10000, 25053006, '10203040A');
INSERT INTO Telefonos (dni_cli, tlfn_cli) VALUES('10203040A', 684367181);

DELETE FROM Sucursal WHERE cod_sucursal = 10000; 
DELETE FROM Cliente WHERE dni_cli = '10203040A'; 
DELETE FROM Cuenta WHERE cod_sucursal = 10000 AND cod_cuenta = 25053006;
DELETE FROM Transaccion WHERE cod_sucursal = 10000 AND cod_cuenta = 25053006 AND num_transaccion = 11111;
DELETE FROM CliCuenta WHERE cod_sucursal = 10000 AND cod_cuenta = 25053006 AND dni_cli = '10203040A'; 
DELETE FROM Telefonos WHERE dni_cli = '10203040A';

---------------------- 13.	Realiza algún SELECT de una tabla y de la vista creada anteriormente. ---------------

SELECT * FROM Cliente;
SELECT * FROM v_cliente;

---------------------- 14.	Vacía todas las tablas. ------------------------------------------------------------

DELETE FROM Sucursal;
DELETE FROM Cliente;
DELETE FROM Cuenta;
DELETE FROM Transaccion;
DELETE FROM CliCuenta;
DELETE FROM Telefonos;

------------------ 15.	Elimina la tabla de teléfonos -------------------------

DROP TABLE Telefonos CASCADE CONSTRAINTS PURGE;
