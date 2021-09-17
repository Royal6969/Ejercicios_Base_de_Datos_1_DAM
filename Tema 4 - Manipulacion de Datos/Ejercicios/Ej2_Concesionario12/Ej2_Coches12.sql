-- 1.	Crea un usuario llamado COCHESXX, donde XX es tu número de alumno. Debes asignarle 5 megas de memoria en USERS. Conéctate desde ese nuevo usuario.

-- 2.	Crea la tabla “clientes” atendiendo a las siguientes especificaciones:
    -- DNI alfanumérico de 4 caracteres, clave primaria.
    -- NOMBRE alfanumérico de 20 caracteres, no puede estar vacío.
    -- APELLIDO alfanumérico de 20 caracteres.
    -- CIUDAD alfanumérico de 20 caracteres.
    
CREATE TABLE CLIENTES(
dni_cli varchar2(4),
nom_cli varchar2(20) NOT NULL,
ape_cli varchar2(20),
ciu_cli varchar2(20),
CONSTRAINT PK_CLIENTES PRIMARY KEY (dni_cli)
);

-- 3.	Ejecuta el Script 1, para cargar el resto de tablas cargadas por los compañeros de tu equipo.

@C:\Ej2_Concesionario12\1c.sql

-- 4.	Crea una clave foránea a la tabla COCHES, llamada “FK_MARCAS_COCHES” que referencie a la tabla “MARCAS”.

ALTER TABLE COCHES ADD CONSTRAINT FK_COCHES FOREIGN KEY (COD_MARCA) REFERENCES MARCAS (COD_MARCA);

-- 5.	Ejecuta el Script 2, para cargar el resto de tablas cargadas por los compañeros de tu equipo.

@C:\Ej2_Concesionario12\2c.sql

-- 6.	Inserta los datos de estos dos clientes:
--      1. LUIS, GARCIA, MADRID
--      2. ANTONIO, LOPEZ, BARCELONA

INSERT INTO CLIENTES (DNI_CLI, NOM_CLI, APE_CLI, CIU_CLI) VALUES('123A', 'Luis', 'Garcia', 'Madrid');
INSERT INTO CLIENTES (DNI_CLI, NOM_CLI, APE_CLI, CIU_CLI) VALUES('123B', 'Antonio', 'Lopez', 'Barcelona');

-- Aunque no se diga nada al respecto, he insertado tmb los DNIs porque una PK lleva implícito el NOT NULL e INT

-- 7.	Ejecuta el Script 3, para cargar el resto de tablas cargadas por los compañeros de tu equipo.

@C:\Ej2_Concesionario12\3c.sql

-- 57 filas insertadas

-- 8.	Añade la columna de precio en la tabla VENTAS,  es un número de 5 enteros y 2 decimales.

ALTER TABLE VENTAS ADD PRECIO_COCHE number(7,2);

-- 9.	Introduce valores de precio para las ventas: 5000, 10000, 15000, 20000, 25000, 30000.

-- primero, voy a cambiar los datos que introduje a los dos primeros clientes que me dijo el enunciado que crease
-- esto lo hago porque viendo los dni más genéricos que los scripst crearon, adaptar aquellos dos a la secuencia que siguen los que crearon los script

UPDATE CLIENTES SET DNI_CLI = '0001' where DNI_CLI = '123A';
UPDATE CLIENTES SET DNI_CLI = '0002' where DNI_CLI = '123B';

-- con el mismo UPDATE, insertaré los datos de PRECIO_COCHE en la tabla VENTAS
 
UPDATE VENTAS SET PRECIO_COCHE = 5000 where DNI = 0001; 
-- se me han actualizado 2 filas... hay un mismo cliente que tiene 2 coches ?? TENGO QUE ARREGLAR ESTO 
-- para ello, voy a especificar el COD_CONCESIONARIO en la misma sentencia de antes
UPDATE VENTAS SET PRECIO_COCHE = 10000 where DNI = 0001 AND COD_CONCESIONARIO = 0002; -- BINGO!
-- ahora a repetir esto con cada precio que el enunciado me dijo
UPDATE VENTAS SET PRECIO_COCHE = 15000 where DNI = 0002 AND COD_CONCESIONARIO = 0003;
UPDATE VENTAS SET PRECIO_COCHE = 20000 where DNI = 0002 AND COD_CONCESIONARIO = 0001;
UPDATE VENTAS SET PRECIO_COCHE = 25000 where DNI = 0003 AND COD_CONCESIONARIO = 0004;
UPDATE VENTAS SET PRECIO_COCHE = 30000 where DNI = 0004 AND COD_CONCESIONARIO = 0005;

----------------------------------------------------------------------------------------------------------------------------------
-- Ya tenemos creada la BBDD y hemos completado la información de las distintas tablas. Ahora necesitamos los siguientes informes:

SELECT * FROM ALL_CONSTRAINTS
WHERE TABLE_NAME = 'CLIENTES';

-- 1.	Lista de coches “SEAT”.

SELECT COD_COCHE, COD_MARCA, TIPO, MODELO
FROM COCHES 
WHERE COD_MARCA = 0001; -- porque 0001 es el COD_MARCA para SEAT

-- 2.	Lista de coches “GT” que hay en catálogo (incluye cualquiera que incluya “gt” en su modelo)

SELECT COD_COCHE, COD_MARCA, TIPO, MODELO
FROM COCHES
WHERE MODELO LIKE '%GT%';

-- 3.	Mostrar DNI, NOMBRE, APELLIDOS y CIUDAD (del cliente), COLOR, NOMBRE (de la marca), TIPO y MODELO (del coche o coches comprados)  donde el cliente tiene DNI “0001”.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI, CLIENTES.CIU_CLI, VENTAS.COLOR, MARCAS.NOMBRE, COCHES.TIPO, COCHES.MODELO
FROM CLIENTES, MARCAS, COCHES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI AND COCHES.COD_MARCA = MARCAS.COD_MARCA AND VENTAS.COD_COCHE = COCHES.COD_COCHE
AND CLIENTES.DNI_CLI = 0001;

-- 4.	¿Cuántos coches se han vendido a clientes de madrid?

SELECT COUNT(*)
FROM VENTAS, CONCESIONARIOS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO 
AND CONCESIONARIOS.CIUDAD = 'MADRID';

-- 5.	¿Cuántos coches se han vendido en cada ciudad?

SELECT CONCESIONARIOS.CIUDAD, COUNT(*)
FROM CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO
GROUP BY CONCESIONARIOS.CIUDAD; 

-- 6.	Lista de concesionarios que han vendido un coche rojo.

SELECT CONCESIONARIOS.NOMBRE
FROM CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO
AND VENTAS.COLOR = 'ROJO';

-- 7.	Lista de clientes de ECAR.

SELECT CLIENTES.NOM_CLI, CONCESIONARIOS.NOMBRE
FROM CLIENTES, CONCESIONARIOS, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI AND VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO
AND CONCESIONARIOS.NOMBRE = 'ECAR';

-- 8.	Lista de los concesionarios de MADRID y la cantidad de ventas de cada uno.

SELECT CONCESIONARIOS.NOMBRE, CONCESIONARIOS.CIUDAD, COUNT(*) 
FROM CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO
AND CONCESIONARIOS.CIUDAD = 'MADRID'
GROUP BY CONCESIONARIOS.NOMBRE, CONCESIONARIOS.CIUDAD;

-- 9.	Lista de clientes de concesionarios de MADRID.

SELECT DISTINCT CLIENTES.NOM_CLI, CONCESIONARIOS.CIUDAD
FROM CLIENTES, CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO AND VENTAS.DNI = CLIENTES.DNI_CLI
AND CONCESIONARIOS.CIUDAD = 'MADRID';

-- 10.	Datos de clientes y nombre del concesionario de aquellos clientes que han comprado un coche en su misma ciudad.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI, CLIENTES.CIU_CLI, CONCESIONARIOS.COD_CONCESIONARIO, CONCESIONARIOS.NOMBRE, CONCESIONARIOS.CIUDAD
FROM CLIENTES, CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO AND VENTAS.DNI = CLIENTES.DNI_CLI
AND UPPER(CLIENTES.CIU_CLI) = UPPER(CONCESIONARIOS.CIUDAD);


-- 11.	¿Cuántas ciudades han vendido más de un coche?

SELECT CONCESIONARIOS.CIUDAD, COUNT(DISTINCT CONCESIONARIOS.CIUDAD)
FROM CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO
GROUP BY CONCESIONARIOS.CIUDAD
HAVING COUNT(*) > 1;

-- 12.	Datos de cliente y concesionario, de ventas realizadas por un concesionario de BARCELONA a un cliente de MADRID.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI, CLIENTES.CIU_CLI, CONCESIONARIOS.COD_CONCESIONARIO, CONCESIONARIOS.NOMBRE, CONCESIONARIOS.CIUDAD
FROM CLIENTES, CONCESIONARIOS, VENTAS
WHERE VENTAS.COD_CONCESIONARIO = CONCESIONARIOS.COD_CONCESIONARIO AND VENTAS.DNI = CLIENTES.DNI_CLI
AND CONCESIONARIOS.CIUDAD = 'BARCELONA'
AND UPPER(CLIENTES.CIU_CLI) = 'MADRID';
-- no me sale nada... NO HAY NINGÚN DATO

-- 13.	Lista de coches que valen más de 15000€

SELECT COCHES.COD_COCHE, COCHES.COD_MARCA, COCHES.TIPO, COCHES.MODELO, VENTAS.PRECIO_COCHE
FROM COCHES, VENTAS
WHERE VENTAS.COD_COCHE = COCHES.COD_COCHE
AND VENTAS.PRECIO_COCHE > 15000;

-- 14.	Lista de clientes que se han gastado exactamente 15000.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI, VENTAS.PRECIO_COCHE
FROM CLIENTES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI
AND VENTAS.PRECIO_COCHE = 15000;

-- 15.	Lista de clientes acompañada de la suma de sus compras.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI,
SUM(VENTAS.PRECIO_COCHE)
FROM CLIENTES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI
GROUP BY CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI;

-- 16.	Lista de clientes acompañada de la cantidad de compras.
SELECT CLIENTES.NOM_CLI, CLIENTES.APE_CLI, COUNT(*)
FROM CLIENTES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI
GROUP BY CLIENTES.NOM_CLI, CLIENTES.APE_CLI;

-- 17.	Lista de clientes que hayan gastado en coches más que la media de clientes.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI
FROM CLIENTES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI
GROUP BY CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI
HAVING SUM(VENTAS.PRECIO_COCHE) > (SELECT AVG(VENTAS.PRECIO_COCHE) 
FROM CLIENTES, VENTAS);

-- 18.	Datos del cliente que haya comprado el coche blanco más caro.

SELECT CLIENTES.DNI_CLI, CLIENTES.NOM_CLI, CLIENTES.APE_CLI
FROM CLIENTES, VENTAS
WHERE VENTAS.DNI = CLIENTES.DNI_CLI 
AND VENTAS.COLOR = 'BLANCO' 
AND VENTAS.PRECIO_COCHE = (SELECT MAX(VENTAS.PRECIO_COCHE) FROM VENTAS WHERE VENTAS.COLOR = 'BLANCO');

-- 19.	Datos del coche más caro que haya sido vendido.

SELECT COCHES.COD_COCHE, COCHES.TIPO, COCHES.MODELO
FROM COCHES, VENTAS
WHERE VENTAS.COD_COCHE = COCHES.COD_COCHE
AND VENTAS.PRECIO_COCHE = (SELECT MAX(VENTAS.PRECIO_COCHE) FROM VENTAS);

-- 20.	Cantidad de coches del catálogo por nombre y tipo.

SELECT COCHES.MODELO, COCHES.TIPO, COUNT (*)
FROM COCHES
GROUP BY COCHES.MODELO, COCHES.TIPO;
-- Me ha dado 20 resultados ... osea todo porque todos eran diferentes

commit work;