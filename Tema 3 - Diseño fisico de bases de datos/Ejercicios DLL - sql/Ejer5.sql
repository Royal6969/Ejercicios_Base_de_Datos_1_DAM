CREATE TABLE Profesor (
ID_prof INT PRIMARY KEY,
dni varchar2(9) UNIQUE,
nom_prof varchar2(20),
direccion varchar2(30),
edad number(2)
);

CREATE TABLE Modulos (
cod_modu INT PRIMARY KEY,
nom_modu varchar2(20),
ID_prof number(10),
CONSTRAINT FK_MODU_ID_PROF FOREIGN KEY (ID_prof) REFERENCES Profesor (ID_prof)
);

CREATE TABLE Alumnos (
n_expe INT PRIMARY KEY,
nom_alum varchar2(20),
apellido1 varchar2(20),
apellido2 varchar2(20),
fecha_Nac date,
n_dele number(3) --aparentemente este campo es una FK que apuntaría hacia otro (n_dele) que estaría como PK de una posible tabla "Delegados"
);

CREATE TABLE Matriculas (
n_expe number(10),
CONSTRAINT FK_MATRI_N_EXPE FOREIGN KEY (n_expe) REFERENCES Alumnos (n_expe),
cod_modu number(10),
CONSTRAINT FK_MATRI_COD_MODU FOREIGN KEY (cod_modu) REFERENCES Modulos (cod_modu)
);

DROP TABLE Profesor CASCADE CONSTRAINTS PURGE;
DROP TABLE Modulos CASCADE CONSTRAINTS PURGE;
DROP TABLE Alumnos CASCADE CONSTRAINTS PURGE;
DROP TABLE Matriculas CASCADE CONSTRAINTS PURGE;

INSERT INTO Profesor (ID_prof, dni, nom_prof, direccion, edad) VALUES(1, NULL, 'Josep', 'C/Principal', NULL);
INSERT INTO Profesor (ID_prof, dni, nom_prof, direccion, edad) VALUES(2, NULL, 'Maria', 'Plaza Mayor', NULL);

INSERT INTO Modulos (cod_modu, nom_modu, ID_prof) VALUES(100, 'Mates', 1);
INSERT INTO Modulos (cod_modu, nom_modu, ID_prof) VALUES(200, 'Lengua', 2);
INSERT INTO Modulos (cod_modu, nom_modu, ID_prof) VALUES(300, 'Fisica', 1);
INSERT INTO Modulos (cod_modu, nom_modu, ID_prof) VALUES(400, 'Filosofia', 2);

INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(10, 'Isabel', 'Ribes', NULL, NULL, NULL);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(20, 'Raul', 'Rios', NULL, '01021978', 10);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(30, 'Carmen', 'Gimenez', NULL, NULL, 10);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(40, 'Laura', 'Lahoz', NULL, '20111981', NULL);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(50, 'Ana', 'Medina', NULL, NULL, 40);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(60, 'Juan', 'Sanchez', NULL, NULL, 40);
INSERT INTO Alumnos (n_expe, nom_alum, apellido1, apellido2, fecha_Nac, n_dele) VALUES(70, 'Jesus', 'Pena', NULL, NULL, 40);

INSERT INTO Matriculas (n_expe, cod_modu) VALUES(10, 100);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(10, 300);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(20, 400);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(30, 200);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(30, 400);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(40, 100);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(40, 200);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(40, 300);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(50, 200);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(60, 100);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(60, 300);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(70, 100);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(70, 200);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(70, 300);
INSERT INTO Matriculas (n_expe, cod_modu) VALUES(70, 400);





