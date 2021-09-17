CREATE TABLE empleados (
dni INT PRIMARY KEY,
nombre varchar2(20),
apellido1 varchar2(20),
direccion varchar2(40),
ciudad varchar2 (20),
municipio varchar2(20),
cod_postal number(5),
sexo varchar2(10)
);

CREATE TABLE estudios (
cod_estudios INT PRIMARY KEY,
titulo varchar2(20),
ciudad varchar2(20)
);

CREATE TABLE historial_laboral (
fecha_Ini date,
fecha_Fin date
);

CREATE TABLE historial_salarial (
cod_salario INT PRIMARY KEY,
salario number(6,2),
fecha_Inicio date,
fecha_Fin date
);

CREATE TABLE trabajos (
cod_trabajo INT PRIMARY KEY,
nom_trabajo varchar2(20),
salario_min number(6,2),
salario_max number(6,2)
);

CREATE TABLE departamentos (
cod_dpto INT PRIMARY KEY,
nom_dpto varchar2(20),
presupuesto number(6,2),
pres_actual number(6,2)
);

CREATE SYNONYM h_lab FOR historial_laboral;

CREATE SYNONYM h_sal FOR historial_salarial;

CREATE INDEX ape_index ON empleados (apellido1, nombre, DNI);

CREATE SEQUENCE cod_dptos 
INCREMENT BY 1
START WITH 1
MAXVALUE 10
NOCYCLE;

CREATE VIEW v_emple AS SELECT nombre, apellido1, ciudad, sexo FROM empleados;
