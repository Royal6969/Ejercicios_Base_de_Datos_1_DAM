----------- 1.	Crea el usuario “distribucion” con contraseña “distribución” y una cuota de 5 Megabytes en el tablespace “USERS”. --------

----------- 2.	Concédele permiso de acceso y utilización de los recursos. -----------------------
 
----------- 3.	Conéctate al usuario “distribucion” desde SQLPLUS. ------------------------

CONNECT DISTRIBUCION12;

----------- 4.	Crea la tabla “departamentos” con la siguiente especificación: ------------------

CREATE TABLE Departamentos (
cod_dpto INT,
nom_dpto varchar2(40) NOT NULL,
local_dpto varchar2(40) NOT NULL,
CONSTRAINT PK_DEPARTAMENTOS PRIMARY KEY (cod_dpto)
);

----------- 5.	Inserta los siguientes datos en la tabla departamentos: --------------

INSERT INTO Departamentos (cod_dpto, nom_dpto, local_dpto) VALUES(10, 'CONTABILIDAD', 'BARCELONA');
INSERT INTO Departamentos (cod_dpto, nom_dpto, local_dpto) VALUES(20, 'INVESTIGACION', 'VALENCIA');
INSERT INTO Departamentos (cod_dpto, nom_dpto, local_dpto) VALUES(30, 'VENTAS', 'MADRID');
INSERT INTO Departamentos (cod_dpto, nom_dpto, local_dpto) VALUES(40, 'PRODUCCION', 'SEVILLA');
INSERT INTO Departamentos (cod_dpto, nom_dpto, local_dpto) VALUES(50, 'INFORMATICA', 'MADRID');

DELETE FROM Departamentos WHERE cod_dpto = 10; 
DELETE FROM Departamentos WHERE cod_dpto = 20; 
DELETE FROM Departamentos WHERE cod_dpto = 30; 
DELETE FROM Departamentos WHERE cod_dpto = 40; 
DELETE FROM Departamentos WHERE cod_dpto = 50; 

----------- 6.	Carga   el   script   DDL,   el   cual   crea   el   resto   de   tablas	necesarias del esquema (DistribucionDDL.sql). ---------

@C:\Ejer_1_Distribucion\DistribucionDDL.sql

----------- 7.	Carga el script DML, el cual inserta los datos de la base de datos en las tablas correspondientes (DistribucionDML.sql). --------

@C:\Ejer_1_Distribucion\DistribucionDML.sql

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- A continuación, la empresa cliente necesita algunos informes sobre su base de datos, los cuales vamos a proceder a realizar mediante consultas (para ello usaremos SQL DEVELOPER). Concretamente necesitamos: 

-- 1.	Un listado que contenga el código de cliente y nombre de todos los clientes que no se encuentren en ‘BARCELONA’, ordenados por nombre, alfabéticamente. 

SELECT COD_CLIENTE, NOMBRE FROM CLIENTES WHERE LOCALIDAD != 'BARCELONA' ORDER BY NOMBRE ASC; -- lo del != es equivalente al NOT LIKE

-- 2.	Un listado que contenga el nombre de los departamentos que se encuentran en la siguiente lista (se deben utilizar listas) de ciudades: Madrid, Barcelona 

SELECT NOM_DPTO, LOCAL_DPTO FROM DEPARTAMENTOS WHERE LOCAL_DPTO IN ('MADRID', 'BARCELONA');
--SELECT NOM_DPTO FROM DEPARTAMENTOS WHERE LOCALIDAD LIKE 'BARCELONA' OR LOCALIDAD LIKE 'MADRID'; así NO se debe hacer

-- 3.	El salario más bajo, el más alto y la media de la tabla de empleados.

SELECT MIN(SALARIO), MAX(SALARIO), AVG(SALARIO) FROM EMPLEADOS;

-- 4.	Un listado de productos (descripción, stock, precio) ordenados por stock de forma descendente y por precio de forma descendente y alfabéticamente de forma ascendente.

SELECT DESCRIPCION, STOCK_DISPONIBLE, PRECIO_ACTUAL FROM PRODUCTOS ORDER BY STOCK_DISPONIBLE DESC, PRECIO_ACTUAL DESC, DESCRIPCION ASC;

-- 5.	Un listado de apellidos y fechas de alta de vendedores que no cobren comisiones

SELECT APELLIDO, FECHA_ALTA FROM EMPLEADOS WHERE OFICIO='VENDEDOR' AND COMISION=0;

-- 6.	Un listado que contenga código de producto, descripción y stock de mesas con un stock comprendido entre 10 y 20 unidades.

SELECT COD_PRODUCTO, DESCRIPCION, STOCK_DISPONIBLE FROM PRODUCTOS WHERE DESCRIPCION LIKE '%MESA%' AND STOCK_DISPONIBLE BETWEEN 10 AND 20;

-- 7.	Un listado que contenga los nombres y localidades de los clientes que alguna vez han sido atendidos por un director.

SELECT NOMBRE, LOCALIDAD FROM CLIENTES WHERE COD_VENDEDOR LIKE '7839';
--SELECT CLIENTES.NOMBRE, CLIENTES.LOCALIDAD 
--FROM CLIENTES, EMPLEADOS
--WHERE CLIENTES.COD_VENDEDOR=EMPLEADOS.COD_EMPLEADO
--AND EMPLEADOS.OFICIO='DIRECTOR';

-- 8.	Listado con el nombre y localidad de los clientes que tienen pedidos con menos de 3 unidades en el mes de noviembre de 1999.

ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

SELECT CLIENTES.NOMBRE, CLIENTES.LOCALIDAD 
FROM CLIENTES, PEDIDOS
WHERE CLIENTES.COD_CLIENTE=PEDIDOS.COD_CLIENTE
AND PEDIDOS.UNIDADES < 3
AND PEDIDOS.FECHA_PEDIDO BETWEEN '1999-11-01' AND '1999-11-30';

-- 9.	Listado con el nombre y localidad de cliente, nombre de departamento, y apellido del empleado que le atendió para todos aquellos clientes que fueron atendidos por un empleado perteneciente a algún departamento de Madrid. 
--      El resultado debe mostrarse ordenado por orden alfabético del apellido del empleado y en caso de empate, por el del nombre de cliente, también alfabéticamente.

SELECT CLIENTES.NOMBRE, CLIENTES.LOCALIDAD, DEPARTAMENTOS.NOM_DPTO, EMPLEADOS.APELLIDO 
FROM CLIENTES, DEPARTAMENTOS, EMPLEADOS 
WHERE CLIENTES.COD_VENDEDOR=EMPLEADOS.COD_EMPLEADO
AND EMPLEADOS.COD_DEPARTAMENTO=DEPARTAMENTOS.COD_DPTO 
AND DEPARTAMENTOS.LOCAL_DPTO='MADRID' 
ORDER BY EMPLEADOS.APELLIDO ASC, CLIENTES.NOMBRE ASC;

-- 10.	Un listado con el nombre y localidad del cliente, apellido y nombre de departamento del empleado que le atendió, descripción del producto que compró y fecha del pedido, 
--      de todos aquellos clientes que compraron una “…SILLA DIRECTOR…” en el mes de noviembre de 1999 ordenando los resultados ascendentemente por fecha de pedido.

ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

SELECT CLIENTES.NOMBRE, CLIENTES.LOCALIDAD, DEPARTAMENTOS.NOM_DPTO, EMPLEADOS.APELLIDO, PRODUCTOS.DESCRIPCION, PEDIDOS.FECHA_PEDIDO
FROM CLIENTES, EMPLEADOS, DEPARTAMENTOS, PEDIDOS, PRODUCTOS
WHERE CLIENTES.COD_VENDEDOR = EMPLEADOS.COD_EMPLEADO 
AND EMPLEADOS.COD_DEPARTAMENTO = DEPARTAMENTOS.COD_DPTO
AND PEDIDOS.COD_CLIENTE = CLIENTES.COD_CLIENTE
AND PEDIDOS.COD_PRODUCTO = PRODUCTOS.COD_PRODUCTO
AND PRODUCTOS.DESCRIPCION LIKE '%SILLA%DIRECTOR%' 
AND PEDIDOS.FECHA_PEDIDO BETWEEN '1999-11-01' AND '1999-11-30'
ORDER BY PEDIDOS.FECHA_PEDIDO ASC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Por último, el cliente nos informa de que va a necesitar algunos informes estadísticos para los que vamos a necesitar algunas sentencias más complejas. En concreto necesitamos:

-- 11.	Un listado con el nombre de la localidad y la suma del crédito que tienen sus clientes, agrupado por localidad.

SELECT CLIENTES.LOCALIDAD, 
SUM(CLIENTES.LIMITE_CREDITO) 
FROM CLIENTES 
GROUP BY CLIENTES.LOCALIDAD;

-- 12.	Un listado que muestre nombre del departamento, oficio y media salarial, agrupado por departamento y oficio, que tengan asignado un salario superior a 200000 €, todo ello ordenado descendentemente por la media salarial.

SELECT DEPARTAMENTOS.NOM_DPTO, EMPLEADOS.OFICIO, 
AVG(EMPLEADOS.SALARIO)
FROM DEPARTAMENTOS, EMPLEADOS
WHERE EMPLEADOS.COD_DEPARTAMENTO = DEPARTAMENTOS.COD_DPTO
GROUP BY DEPARTAMENTOS.NOM_DPTO, EMPLEADOS.OFICIO
HAVING AVG(EMPLEADOS.SALARIO) > 200000
ORDER BY AVG(EMPLEADOS.SALARIO) DESC;

--FROM DEPARTAMENTOS d, EMPLEADOS e

-- 13.	Un listado que muestre los códigos de cliente y nombres de los clientes cuya suma total de los pedidos (también hay que mostrarla) que han realizado sea mayor que 8.000.000€, ordenado ascendentemente por número de código de cliente.

SELECT CLIENTES.COD_CLIENTE, CLIENTES.NOMBRE,
SUM(PEDIDOS.UNIDADES * PRODUCTOS.PRECIO_ACTUAL) --as total
FROM CLIENTES, PEDIDOS, PRODUCTOS
WHERE CLIENTES.COD_CLIENTE = PEDIDOS.COD_CLIENTE
AND PEDIDOS.COD_PRODUCTO = PRODUCTOS.COD_PRODUCTO
GROUP BY CLIENTES.COD_CLIENTE, CLIENTES.NOMBRE
HAVING SUM(PEDIDOS.UNIDADES * PRODUCTOS.PRECIO_ACTUAL) > 8000
ORDER BY CLIENTES.COD_CLIENTE ASC;

-- 14.	Un listado de los departamentos, su ciudad y su número de empleados, cuyo departamento tenga más de 2 empleados, ordenado por número de empleados ascendentemente.

SELECT DEPARTAMENTOS.COD_DPTO, DEPARTAMENTOS.LOCAL_DPTO, 
COUNT(*) --AS NUM_EMPLEADOS
FROM DEPARTAMENTOS, EMPLEADOS
WHERE DEPARTAMENTOS.COD_DPTO = EMPLEADOS.COD_DEPARTAMENTO
GROUP BY DEPARTAMENTOS.COD_DPTO, DEPARTAMENTOS.LOCAL_DPTO
HAVING COUNT(*) > 2
ORDER BY COUNT(*) ASC;

-- lo del asterisco (*) es para contar todas las líneas de datos

-- 15.	Un listado de los nombres de departamento y el mínimo salario de los departamentos en los que todos sus empleados cobren más de 135.000€, ordenado por salario minimo descendentemente y por nombre de departamento ascendentemente.

SELECT DEPARTAMENTOS.NOM_DPTO, 
MIN(EMPLEADOS.SALARIO) --as salario
FROM DEPARTAMENTOS, EMPLEADOS
WHERE EMPLEADOS.COD_DEPARTAMENTO = DEPARTAMENTOS.COD_DPTO
GROUP BY DEPARTAMENTOS.NOM_DPTO
HAVING MIN(EMPLEADOS.SALARIO) >= 135000
ORDER BY MIN(EMPLEADOS.SALARIO) DESC, DEPARTAMENTOS.NOM_DPTO ASC;



