CREATE TABLE Clientes (
cod_Cli INT PRIMARY KEY, 
nombre VARCHAR2(20),
NIF varchar2(9), 
direccion varchar2(30),
ciudad varchar2(20), 
telefono number(9)
);

CREATE TABLE Departamentos (
nom_Dep varchar2(20),
ciu_Dep varchar2(20),
telefono number(9),
CONSTRAINT PK_NOM PRIMARY KEY (nom_Dep, ciu_Dep)
);

--ALTER TABLE Departamentos ADD CONSTRAINT PK_DEP_CIU_DEP PRIMARY KEY (nom_Dep, ciu_Dep);

CREATE TABLE Proyectos (
cod_Pro INT PRIMARY KEY, 
nom_Pro varchar2(20), 
precio number(8,2), 
fechaIni date, 
fechaFin_prev date, 
fechaFin date, 
cod_Cli INT, 
CONSTRAINT FK_DEP_COD2 FOREIGN KEY (cod_Cli) REFERENCES Clientes (cod_Cli)
);

CREATE TABLE Empleados (
cod_Emp INT PRIMARY KEY, 
nom_Emp varchar2(20), 
apellido1 varchar2(20), 
sueldo number(8,2), 
nom_Dep varchar2(20),
--CONSTRAINT FK_EMP_NOM_DEP FOREIGN KEY (nom_Dep) REFERENCES Departamentos (nom_Dep),
ciu_Dep varchar2(20),
CONSTRAINT FK_EMP_CIU_DEP FOREIGN KEY (nom_Dep, ciu_Dep) REFERENCES Departamentos,
cod_Cli INT, 
CONSTRAINT FK_DEP_COD_CLI FOREIGN KEY (cod_Cli) REFERENCES Clientes (cod_Cli)
);

DROP TABLE Clientes CASCADE CONSTRAINTS PURGE;
DROP TABLE Departamentos CASCADE CONSTRAINTS PURGE;
DROP TABLE Proyectos CASCADE CONSTRAINTS PURGE;
DROP TABLE Empleados CASCADE CONSTRAINTS PURGE;

INSERT INTO Clientes (cod_Cli, nombre, NIF, direccion, ciudad, telefono) values(10, 'FTN', '12345678F', 'Aragon 11', 'Barcelona', NULL);
INSERT INTO Clientes (cod_Cli, nombre, NIF, direccion, ciudad, telefono) values(20, 'ZETA', '23456789Z', 'Valencia 22', 'Girona', 972123476);
INSERT INTO Clientes (cod_Cli, nombre, NIF, direccion, ciudad, telefono) values(30, 'ACME', '34565789A', 'Mallorca 33', 'Lleida', 973234567);
INSERT INTO Clientes (cod_Cli, nombre, NIF, direccion, ciudad, telefono) values(40, 'PETA', '45678901P', 'Rosellon 44', 'Tarragona', 077334455);

delete from Clientes where cod_Cli = xx;
delete from Clientes where cod_Cli = 20;
delete from Clientes where cod_Cli = 30;
delete from Clientes where cod_Cli = 40;

INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('DIR', 'Barcelona', 935551020);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('DIR', 'Girona', 935552030);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('DIST', 'Barcelona', 935553040);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('DIST', 'Lleida', 935554050);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('PROGR', 'Tarragona', 935555060);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('PROGR', 'Girona', 935556070);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('PROD', 'Barcelona', 935557080);
INSERT INTO Departamentos (nom_Dep, ciu_Dep, telefono) VALUES ('PROD', 'Tarragona', 935558090);

INSERT INTO Proyectos (cod_Pro, nom_Pro, precio, fechaIni, fechaFin_prev, fechaFin, cod_Cli) VALUES (1, 'GESCOM', 100000, '01012008', '01012009', NULL, 10); 
INSERT INTO Proyectos (cod_Pro, nom_Pro, precio, fechaIni, fechaFin_prev, fechaFin, cod_Cli) VALUES (2, 'PESCI', 200000, '01102006', '31032008', '01052008', 10); 
INSERT INTO Proyectos (cod_Pro, nom_Pro, precio, fechaIni, fechaFin_prev, fechaFin, cod_Cli) VALUES (3, 'SALSA', 100000, '10022008', '01022009', NULL, 20); 
INSERT INTO Proyectos (cod_Pro, nom_Pro, precio, fechaIni, fechaFin_prev, fechaFin, cod_Cli) VALUES (4, 'TINELL', 400000, '01012007', '01122009', NULL, 30);

INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (1, 'Maria', 'Puig', 100000, 'DIR', 'Girona', 10);  --OJO, hay un error en el PDF del enunciado, porque el cod_Cli que se inserta aqui, debe tener 2 cigras y no 1 sólo
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (2, 'Pedro', 'Mas', 90000, 'DIR', 'Barcelona', 40);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (3, 'Amara', 'Ros', 70000, 'DIST', 'Lleida', 30);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (4, 'Jorge', 'Roca', 70000, 'DIST', 'Barcelona', 40);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (5, 'Clara', 'Blanc', 40000, 'PROGR', 'Tarragona', 10);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (6, 'Laura', 'Tort', 30000, 'PROGR', 'Tarragona', 30);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (7, 'Roger', 'Salt', 40000, NULL, NULL, 40);
INSERT INTO Empleados (cod_Emp, nom_Emp, apellido1, sueldo, nom_Dep, ciu_Dep, cod_Cli) VALUES (8, 'Sergi', 'Grau', 30000, 'PROGR', 'Tarragona', NULL);
