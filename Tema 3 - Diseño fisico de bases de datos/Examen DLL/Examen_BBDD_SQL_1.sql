CREATE TABLE Empleado12 (
cod_emp number(10),
nif_emp varchar2(9)UNIQUE,
nom_emp varchar2(20),
ape_emp varchar2(20),
direcc_emp varchar2(40),
tlfn_emp number(9),
fecha_nac_emp date,
sal_emp number(6,2),
CONSTRAINT PK_EMPLEADO12 PRIMARY KEY (cod_emp)
);

CREATE TABLE EmpCapacitado12 (
cod_emp number(10),
CONSTRAINT PK_EMPCAPACITADO12 PRIMARY KEY (cod_emp),
CONSTRAINT FK_EMPCAPACITADO12 FOREIGN KEY (cod_emp) REFERENCES Empleado12 (cod_emp)
);

CREATE TABLE EmpNoCapacitado12 (
cod_emp number(10),
CONSTRAINT PK_EMPNOCAPACITADO12 PRIMARY KEY (cod_emp),
CONSTRAINT FK_EMPNOCAPACITADO12 FOREIGN KEY (cod_emp) REFERENCES Empleado12 (cod_emp)
);

CREATE TABLE Edicion12 (
cod_curso number(10),
fecha_ini_curso date,
lugar_curso varchar2(40),
hora_curso number(4,2), --creo que no habia salido un dato de hora antes... 2 enteros para las horas y 2 decimales para los minutos
prof_curso varchar2(20),
CONSTRAINT PK_EDICION12 PRIMARY KEY (cod_curso, fecha_ini_curso),
CONSTRAINT FK_EDICION12 FOREIGN KEY (cod_curso) REFERENCES Curso12 (cod_curso)
);

CREATE TABLE Curso12 (
cod_curso number(10),
nom_curso varchar2(30),
dur_curso number(2),
cos_curso number(6,2),
CONSTRAINT PK_CURSO12 PRIMARY KEY (cod_curso)
);

CREATE TABLE Recibe12 (
cod_emp number(10),
cod_curso number(10),
fecha_ini_curso date
);

CREATE TABLE Prerrequesito12 (
curso_soli varchar2(30),
curso_prev varchar2(30),
curso_obli varchar2(2) -- 2 caracteres de SI/NO ... nunca hemos trabajado con el dato tipo boolean
);


ALTER TABLE Recibe12 ADD CONSTRAINT PK_RECIBE12 PRIMARY KEY (cod_emp, cod_curso, fecha_ini_curso);
ALTER TABLE Prerrequesito12 ADD CONSTRAINT PK_PRERREQUESITO12 PRIMARY KEY (curso_soli, curso_prev);

ALTER TABLE Recibe12 ADD CONSTRAINT FK_RECIBE12 FOREIGN KEY (cod_emp) REFERENCES Empleado12 (cod_emp);
ALTER TABLE Recibe12 ADD CONSTRAINT FK_RECIBE12_2 FOREIGN KEY (cod_curso, fecha_ini_curso) REFERENCES Edicion12 (cod_curso, fecha_ini_curso);
ALTER TABLE Prerrequesito12 ADD CONSTRAINT FK_PRERREQUESITO12_1 FOREIGN KEY (curso_soli) REFERENCES Curso12 (cod_curso); --ORA-02267 - CORREGIDO
ALTER TABLE Prerrequesito12 ADD CONSTRAINT FK_PRERREQUESITO12_2 FOREIGN KEY (curso_prev) REFERENCES Curso12 (cod_curso); --ORA-02267 - CORREGIDO

ALTER TABLE Prerrequesito12 MODIFY curso_soli number(20);
ALTER TABLE Prerrequesito12 MODIFY curso_prev number(20);

ALTER TABLE Empleado12 ADD sexo_emp varchar2(6);
ALTER TABLE Empleado12 ADD CONSTRAINT CHECK_EMPLEADO12_SEXO CHECK(sexo_emp='H' OR sexo_emp='M');

ALTER TABLE Empleado12 ADD edad_emp number(2);
ALTER TABLE Empleado12 ADD CONSTRAINT CHECK_EMPLEADO12_EDAD CHECK(edad_emp>=18);

CREATE SYNONYM EmpCap FOR EmpCapacitado12;
CREATE SYNONYM EmpNoCap FOR EmpNoCapacitado12;

CREATE INDEX INDEX_TLFN ON Empleado12 (nom_emp, tlfn_emp);
CREATE INDEX INDEX_NOM_APE ON Empleado12 (nom_emp, ape_emp);

CREATE VIEW v_emp AS SELECT cod_emp, nif_emp, nom_emp, ape_emp, tlfn_emp, fecha_nac_emp, edad_emp, sexo_emp FROM Empleado12;

CREATE SEQUENCE seq_cod_emp 
INCREMENT BY 1
START WITH 10000
MINVALUE 1
MAXVALUE 99999
NOCYCLE;









