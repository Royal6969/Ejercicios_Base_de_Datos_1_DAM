CONNECT CICLISMO12;

@C:\Ciclismo.sql;

-- 1.	Obtener el código, el tipo, el color y el premio de todos los maillots que hay.

SELECT MAILLOT.CODIGO, MAILLOT.TIPO, MAILLOT.COLOR, MAILLOT.PREMIO
FROM MAILLOT;

-- 2.	Obtener el dorsal y el nombre de los ciclistas cuya edad sea menor o igual que 25 años.

SELECT CICLISTA.DORSAL, CICLISTA.NOMBRE
FROM CICLISTA
WHERE CICLISTA.EDAD <= 25;

-- 3.	Obtener el nombre y la altura de todos los puertos de categoría ‘E’ (Especial).

SELECT PUERTO.NOMPUERTO, PUERTO.ALTURA
FROM PUERTO
WHERE PUERTO.CATEGORIA = 'E';

-- 4.	Obtener el valor del atributo netapa de aquellas etapas con salida y llegada en la misma ciudad.

SELECT ETAPA.NETAPA 
FROM ETAPA
WHERE ETAPA.SALIDA = ETAPA.LLEGADA;

-- 5.	¿Cuántos ciclistas hay?

SELECT COUNT(DISTINCT CICLISTA.DORSAL)
FROM CICLISTA;

-- 6.	¿Cuántos ciclistas hay con edad superior a 25 años?

SELECT COUNT(*)
FROM CICLISTA
WHERE CICLISTA.EDAD > 25;

-- 7.	¿Cuántos equipos hay?

SELECT COUNT(DISTINCT EQUIPO.NOMEQ)
FROM EQUIPO;

-- 8.	Obtener la media de edad de los ciclistas.

SELECT AVG(CICLISTA.EDAD)
FROM CICLISTA;

-- 9.	Obtener la altura mínima y máxima de los puertos de montaña.

SELECT MIN(PUERTO.ALTURA), MAX(PUERTO.ALTURA)
FROM PUERTO;

-- 10.	Obtener la altura máxima de los puertos por categoría.

SELECT PUERTO.CATEGORIA, MIN(PUERTO.ALTURA), MAX(PUERTO.ALTURA)
FROM PUERTO
GROUP BY PUERTO.CATEGORIA;

-- 11.	Obtener la media de edad de ciclistas para cada equipo.

SELECT EQUIPO.NOMEQ, AVG(CICLISTA.EDAD)
FROM CICLISTA, EQUIPO
WHERE CICLISTA.NOMEQ = EQUIPO.NOMEQ
GROUP BY EQUIPO.NOMEQ;

-- 12.	Obtener los equipos cuya media de edad es mayor de 30.

SELECT EQUIPO.NOMEQ, AVG(CICLISTA.EDAD)
FROM CICLISTA, EQUIPO
WHERE  CICLISTA.NOMEQ = EQUIPO.NOMEQ
HAVING AVG(CICLISTA.EDAD) > 30
GROUP BY EQUIPO.NOMEQ;

----------------------------------- Consultas sobre varias tablas --------------------------------------

-- 13.	Obtener el nombre y la categoría de los puertos ganados por ciclistas del equipo ‘Banesto’.

SELECT DISTINCT PUERTO.NOMPUERTO, PUERTO.CATEGORIA
FROM CICLISTA, PUERTO, EQUIPO
WHERE PUERTO.DORSAL = CICLISTA.DORSAl AND CICLISTA.NOMEQ = EQUIPO.NOMEQ
AND EQUIPO.NOMEQ = 'Banesto';

-- 14.	Obtener el nombre de cada puerto indicando el número (netapa) y los kilómetros de la etapa en la que se encuentra el puerto.

SELECT ETAPA.NETAPA, ETAPA.KM, PUERTO.NOMPUERTO
FROM ETAPA, PUERTO
WHERE PUERTO.NETAPA = ETAPA.NETAPA;

-- 15.	Obtener el nombre y el director de los equipos a los que pertenezca algún ciclista mayor de 33 años.

SELECT EQUIPO.NOMEQ, EQUIPO.DESCRIPCION
FROM EQUIPO, CICLISTA
WHERE CICLISTA.NOMEQ = EQUIPO.NOMEQ
AND CICLISTA.EDAD > 33;

-- 16.	Obtener el nombre de los ciclistas con el color de cada maillot que hayan llevado.

SELECT DISTINCT CICLISTA.NOMBRE, MAILLOT.COLOR
FROM CICLISTA, MAILLOT, LLEVAR
WHERE MAILLOT.CODIGO = LLEVAR.CODIGO AND LLEVAR.DORSAL = CICLISTA.DORSAL;

-- 17.	Obtener pares de nombre de ciclista y número de etapa tal que ese ciclista haya ganado esa etapa habiendo llevado el maillot de color ‘Amarillo’ al menos una vez.

SELECT DISTINCT CICLISTA.NOMBRE, ETAPA.NETAPA, MAILLOT.COLOR
FROM CICLISTA, ETAPA, LLEVAR, MAILLOT
WHERE ETAPA.DORSAl = CICLISTA.DORSAL AND LLEVAR.CODIGO = MAILLOT.CODIGO AND LLEVAR.DORSAL = CICLISTA.DORSAl AND LLEVAR.DORSAl = ETAPA.DORSAL
AND MAILLOT.COLOR = 'Amarillo'; 

----------------------------------- Consultas con subconsultas -----------------------------------------

-- 18.	Obtener el valor del atributo netapa y la ciudad de salida de aquellas etapas que no tengan puertos de montaña.

SELECT ETAPA.NETAPA, ETAPA.SALIDA
FROM ETAPA
WHERE ETAPA.NETAPA NOT IN (SELECT PUERTO.NETAPA FROM PUERTO);

-- 19.	Obtener la edad media de los ciclistas que han ganado alguna etapa.

SELECT AVG(CICLISTA.EDAD) 
FROM CICLISTA, ETAPA
WHERE ETAPA.DORSAl = CICLISTA DORSAL;

-- 20.	Selecciona el nombre de los puertos con una altura superior a la altura media de todos los puertos.

SELECT PUERTO.NOMPUERTO, PUERTO.ALTURA
FROM PUERTO
WHERE PUERTO.ALTURA > (SELECT AVG(PUERTO.ALTURA) FROM PUERTO);

SELECT AVG(PUERTO.ALTURA) FROM PUERTO;

-- 21.	Obtener el nombre de la ciudad de salida y de llegada (de las 3 primeras etapas) etapas donde estén los puertos con mayor pendiente.

SELECT ETAPA.SALIDA, ETAPA.LLEGADA
FROM ETAPA
WHERE ETAPA.NETAPA IN (

SELECT PUERTO.NETAPA 
FROM PUERTO
ORDER BY (PUERTO.PENDIENTE) DESC
FETCH FIRST 3 ROWS ONLY
);

-- 22.	Obtener el dorsal y el nombre de los ciclistas que han ganado los puertos de mayor altura.

SELECT CICLISTA.DORSAL, CICLISTA.NOMBRE 
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (

SELECT PUERTO.DORSAL 
FROM PUERTO
ORDER BY PUERTO.ALTURA DESC
FETCH FIRST 2 ROWS ONLY
);

-- 23.	Obtener el nombre del ciclista más joven.

-- 1º posibilidad
SELECT CICLISTA.NOMBRE
FROM CICLISTA
WHERE CICLISTA.EDAD = (

SELECT MIN(CICLISTA.EDAD) 
FROM CICLISTA
);

-- 2º posibilidad
SELECT CICLISTA.NOMBRE
FROM CICLISTA
ORDER BY CICLISTA.EDAD ASC
FETCH FIRST 1 ROW ONLY;

-- 24.	Obtener el nombre del ciclista más joven que ha ganado al menos una etapa.

SELECT CICLISTA.NOMBRE
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (

SELECT ETAPA.DORSAL
FROM ETAPA
ORDER BY CICLISTA.EDAD ASC
FETCH FIRST 1 ROW ONLY
);

-- 25.	Obtener el nombre de los ciclistas que han ganado más de un puerto.

SELECT CICLISTA.NOMBRE
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (

SELECT PUERTO.DORSAL --, COUNT(PUERTO.DORSAL) 
FROM PUERTO
GROUP BY PUERTO.DORSAL
HAVING COUNT(PUERTO.DORSAL) > 1
);

----------------------- Consultas con cuantificación universal (CON NOT EXISTS O NOT IN) -------------------------------------

-- 26.	Obtener el valor del atributo netapa de aquellas etapas tales que todos los puertos que están en ellas tienen más de 700 metros de altura.

SELECT DISTINCT PUERTO.NETAPA
FROM PUERTO
WHERE PUERTO.NETAPA NOT IN 
AND PUERTO.ALTURA NOT IN (

SELECT PUERTO.ALTURA
FROM PUERTO
WHERE PUERTO.ALTURA < 700
);

-- 2º Posibilidad

SELECT DISTINCT PUERTO.NETAPA
FROM PUERTO
WHERE PUERTO.NETAPA NOT IN (

SELECT PUERTO.NETAPA
FROM PUERTO
GROUP BY PUERTO.NETAPA
HAVING MIN(PUERTO.ALTURA) >700
);

-- este no está acbado

-- 27.	Obtener el nombre y el director de los equipos tales que todos sus ciclistas son mayores de 26 años.

SELECT EQUIPO.NOMEQ, EQUIPO.DESCRIPCION
FROM EQUIPO 
WHERE EQUIPO.NOMEQ IN (

SELECT CICLISTA.NOMEQ
FROM CICLISTA
GROUP BY CICLISTA.NOMEQ
HAVING MIN(CICLISTA.EDAD) > 16
);

-- esto no se si da bn ...

-- 28.	Obtener el dorsal y el nombre de los ciclistas tales que todas las etapas que han ganado tienen más de 170 km (es decir que sólo han ganado etapas de más de 170 km).

SELECT CICLISTA.DORSAL, CICLISTA.NOMBRE
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (

SELECT ETAPA.DORSAL
FROM ETAPA
GROUP BY ETAPA.DORSAL
HAVING MIN(ETAPA.KM) > 170
);

-- 29.	Obtener el nombre de los ciclistas que han ganado todos los puertos de una etapa y además han ganado esa misma etapa.

SELECT CICLISTA.NOMBRE 
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (

SELECT ETAPA.DORSAL
FROM ETAPA
WHERE ETAPA.DORSAL IN (

SELECT PUERTO.DORSAL
FROM PUERTO
WHERE PUERTO.NETAPA = ETAPA.NETAPA
)
);

-- 30.	Obtener el nombre de los equipos tales que todos sus corredores han llevado algún maillot o han ganado algún puerto. --------------- OJO ESTE ES DE EXAMEN

SELECT DISTINCT CICLISTA.NOMEQ
FROM CICLISTA
WHERE CICLISTA.DORSAL IN (SELECT LLEVAR.DORSAL FROM LLEVAR)
OR CICLISTA.DORSAL IN (SELECT PUERTO.DORSAl FROM PUERTO);

-- 31.	Obtener el código y el color de aquellos maillots que sólo han sido llevados por ciclistas de un mismo equipo.

SELECT DISTINCT MAILLOT.CODIGO, MAILLOT.COLOR
FROM MAILLOT, LLEVAR, CICLISTA
WHERE LLEVAR.DORSAl = CICLISTA.DORSAL AND LLEVAR.CODIGO = MAILLOT.CODIGO
GROUP BY MAILLOT.CODIGO, MAILLOT.COLOR
HAVING COUNT(DISTINCT CICLISTA.NOMEQ) = 1;

--------------------------- Consultas agrupadas -------------------------------------

-- 33.	Obtener el valor del atributo netapa de aquellas etapas que tienen puertos de montaña indicando cuántos tiene.

SELECT PUERTO.NETAPA, COUNT(*)
FROM PUERTO
GROUP BY PUERTO.NETAPA;

-- 34.	Obtener el nombre de los equipos que tengan ciclistas indicando cuántos tiene cada uno.

SELECT CICLISTA.NOMEQ, COUNT(*) 
FROM CICLISTA
GROUP BY CICLISTA.NOMEQ;
--ORDER BY COUNT(*);

-- 36.	Obtener el director y el nombre de los equipos que tengan más de 3 ciclistas y cuya edad media sea inferior o igual a 30 años.

SELECT EQUIPO.DESCRIPCION
FROM EQUIPO
WHERE EQUIPO.NOMEQ IN (

SELECT CICLISTA.NOMEQ
FROM CICLISTA
GROUP BY CICLISTA.NOMEQ
HAVING COUNT(CICLISTA.DORSAL) > 3
AND AVG(CICLISTA.EDAD) <= 30
);

-- 37.	Obtener el nombre de los ciclistas que pertenezcan a un equipo que tenga más de cinco corredores y que hayan ganado alguna etapa indicando cuántas etapas ha ganado.

SELECT CICLISTA.NOMBRE, COUNT(CICLISTA.DORSAL)
FROM CICLISTA, ETAPA
WHERE ETAPA.DORSAL = CICLISTA.DORSAL
AND CICLISTA.NOMEQ IN (

SELECT CICLISTA.NOMEQ
FROM CICLISTA
GROUP BY CICLISTA.NOMEQ
HAVING COUNT(CICLISTA.DORSAL) > 5
)

GROUP BY CICLISTA.NOMBRE
;

-- 38.	Obtener el nombre de los equipos y la edad media de sus ciclistas de aquellos equipos que tengan la media de edad máxima de todos los equipos.

SELECT CICLISTA.NOMEQ, AVG(CICLISTA.EDAD)
FROM CICLISTA
GROUP BY CICLISTA.NOMEQ 
HAVING AVG(CICLISTA.EDAD) = (

SELECT AVG(CICLISTA.EDAD) 
FROM CICLISTA 
GROUP BY CICLISTA.NOMEQ 
ORDER BY AVG(CICLISTA.EDAD) DESC 
FETCH FIRST 1 ROWS ONLY
);

-- 39.	Obtener el director de los equipos cuyos ciclistas han llevado más días maillots de cualquier tipo. 
-- Nota: cada tupla de la relación llevar indica que un ciclista ha llevado un maillot un día

SELECT EQUIPO.NOMEQ, EQUIPO.DESCRIPCION
FROM EQUIPO
WHERE EQUIPO.NOMEQ = (

SELECT CICLISTA.NOMEQ --, COUNT(*)
FROM CICLISTA, LLEVAR, MAILLOT
WHERE LLEVAR.DORSAl = CICLISTA.DORSAl AND LLEVAR.CODIGO = MAILLOT.CODIGO
GROUP BY CICLISTA.NOMEQ
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY
);

-------------------------- Consultas generales -------------------------

-- 40.	Obtener el código y el color del maillot que ha sido llevado por algún ciclista que no ha ganado ninguna etapa.

SELECT DISTINCT MAILLOT.CODIGO, MAILLOT.COLOR
FROM MAILLOT, ETAPA, LLEVAR
WHERE LLEVAR.CODIGO = MAILLOT.CODIGO
AND LLEVAR.DORSAL NOT IN (

SELECT ETAPA.DORSAL
FROM ETAPA
);

-- 41.	Obtener el valor del atributo netapa, la ciudad de salida y la ciudad de llegada de las etapas de más de 190 km. y que tengan por lo menos dos puertos.

SELECT ETAPA.NETAPA, ETAPA.SALIDA, ETAPA.LLEGADA
FROM ETAPA
WHERE ETAPA.KM > 190
AND ETAPA.NETAPA IN ( 

SELECT PUERTO.NETAPA
FROM PUERTO
GROUP BY PUERTO.NETAPA
HAVING COUNT(*) >= 2
);

-- 42.	Obtener el dorsal y el nombre de los ciclistas que no han llevado todos los maillots que ha llevado el ciclista de dorsal 20

SELECT DISTINCT CICLISTA.DORSAl, CICLISTA.NOMBRE
FROM CICLISTA, LLEVAR
WHERE LLEVAR.DORSAL = CICLISTA.DORSAL
AND LLEVAR.CODIGO != ALL (

SELECT LLEVAR.CODIGO 
FROM LLEVAR
WHERE LLEVAR.DORSAl = 20
);

-- 43.	Obtener el dorsal y el nombre de los ciclistas que han llevado al menos un maillot de los que ha llevado el ciclista de dorsal 20.

SELECT DISTINCT CICLISTA.DORSAL, CICLISTA.NOMBRE
FROM CICLISTA, LLEVAR
WHERE LLEVAR.DORSAl = CICLISTA.DORSAl 
AND LLEVAR.CODIGO IN (

SELECT LLEVAR.CODIGO 
FROM LLEVAR
WHERE LLEVAR.DORSAl = 20
);

-- 44.	Obtener el dorsal y el nombre de los ciclistas que no han llevado ningún maillot de los que ha llevado el ciclista de dorsal 20.

SELECT DISTINCT CICLISTA.DORSAl, CICLISTA.NOMBRE
FROM CICLISTA, LLEVAR
WHERE LLEVAR.DORSAL = CICLISTA.DORSAL
AND LLEVAR.CODIGO NOT IN (

SELECT LLEVAR.CODIGO 
FROM LLEVAR
WHERE LLEVAR.DORSAl = 20
);

-- 45.	Obtener el dorsal y el nombre de los ciclistas que han llevado todos los maillots que ha llevado el ciclista de dorsal 20.
--lo mismo exactamente que la 43

-- 46.	Obtener el dorsal y el nombre de los ciclistas que han llevado exactamente los mismos maillots que ha llevado el ciclista de dorsal 20.

SELECT DISTINCT CICLISTA.DORSAL, CICLISTA.NOMBRE
FROM CICLISTA, LLEVAR
WHERE LLEVAR.DORSAl = CICLISTA.DORSAl 
AND LLEVAR.CODIGO IN (

SELECT DISTINCT LLEVAR.CODIGO 
FROM LLEVAR
WHERE LLEVAR.DORSAl = 20
);

-- solucion FRAN

SELECT DISTINCT CICLISTA.DORSAL, CICLISTA.NOMBRE
FROM CICLISTA, LLEVAR
WHERE LLEVAR.DORSAl = CICLISTA.DORSAl 
AND LLEVAR.CODIGO = ALL ( -- que es esto del ALL ?? el resultado no da nada ??

SELECT DISTINCT LLEVAR.CODIGO 
FROM LLEVAR
WHERE LLEVAR.DORSAl = 20
);

-- 47.	Obtener el dorsal y el nombre del ciclista que ha llevado durante más kilómetros un mismo maillot e indicar también el color de dicho maillot.

SELECT DISTINCT CICLISTA.DORSAl, CICLISTA.NOMBRE, MAILLOT.COLOR
FROM CICLISTA, LLEVAR, MAILLOT
WHERE LLEVAR.DORSAl = CICLISTA.DORSAL AND LLEVAR.CODIGO = MAILLOT.CODIGO 
AND LLEVAR.NETAPA = (

SELECT ETAPA.NETAPA
FROM ETAPA
ORDER BY ETAPA.KM DESC 
FETCH FIRST 1 ROWS ONLY
);
-- FETCH FIRST 1 ROWS ONLY; POR LOS JAJA

-- SOLUCION FRAN

SELECT CICLISTA.DORSAl, CICLISTA.NOMBRE, MAILLOT.COLOR 
FROM CICLISTA, LLEVAR, MAILLOT, ETAPA
WHERE CICLISTA.DORSAl = LLEVAR.DORSAL AND LLEVAR.CODIGO = MAILLOT.CODIGO AND LLEVAR.NETAPA = ETAPA.NETAPA
GROUP BY CICLISTA.DORSAl, CICLISTA.NOMBRE, MAILLOT.COLOR
ORDER BY SUM(ETAPA.KM) DESC 
FETCH FIRST 1 ROWS ONLY;