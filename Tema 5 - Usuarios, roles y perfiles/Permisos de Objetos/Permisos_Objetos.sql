-- 1.	Con�ctate como system y otorga privilegios al empleado1 para seleccionar, insertar, borrar y modificar datos 
-- de la tabla jugadores del usuario nbaXX de forma que pueda conceder este permiso a otros usuarios.

-- OJO ! tengo creado el usuario de EMPLEADO1, pero �l no tiene una conexi�n propia

GRANT SELECT, INSERT, DELETE, UPDATE 
ON nba12.JUGADORES 
TO EMPLEADO1 
WITH GRANT OPTION; -- mejor que el admin... as� dps se puede deshacer en cascada

-- 2.   Consulta los privilegios sobre objetos asignados al empleado1 (dba_tab_privs).

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'EMPLEADO1';

-- 3.	Con�ctate como empleado1 y concede los privilegios seleccionar, insertar, borrar y modificar datos 
-- de la tabla jugadores del usuario nbaXX al empleado2 �Es posible? �Por qu�?

-- OJO! aqu� le creo la conexi�n a EMPLEADO1

GRANT SELECT, INSERT, DELETE, UPDATE 
ON nba12.JUGADORES 
TO EMPLEADO2; 

-- ha sido posible gracias a que en el apartado anterior pusimos una �ltima sentencia que dec�a WITH GRANT OPTION

-- 4.	Como empleado1 consulta los privilegios que ha concedido y a quien. Explica qu� es cada columna (all_tab_privs_made).

SELECT PRIVILEGE, GRANTEE FROM all_tab_privs_made WHERE GRANTOR = 'EMPLEADO1';

-- 5.	Como empleado1 consulta los privilegios que tiene concedidos (recibidos) y qui�n se los ha concedido. 
-- Explica qu� es cada columna (all_tab_privs_recd).

SELECT PRIVILEGE, GRANTOR FROM all_tab_privs_recd WHERE GRANTEE = 'EMPLEADO1';

-- 6.	Con�ctate como system y consulta los privilegios de sistema del empleado2.
-- este enunciado dice "de sistema" pero en vd se refiere a "de objetos"

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'EMPLEADO2';

-- 7.	Observa quien se los ha concedido (grantor).
-- OJO! para que salga bn el resultado, tendr� que ejecutar la sentencia desde EMPLEADO2

SELECT PRIVILEGE, GRANTOR FROM all_tab_privs_recd WHERE GRANTEE = 'EMPLEADO2'; 

-- 8.	Consulta los privilegios de sistema que ha concedido el empleado1.
-- este enunciado dice "de sistema" pero en vd se refiere a "de objetos"
-- ejecutar la sentencia desde el usuario "EMPLEADO1"

SELECT PRIVILEGE, GRANTEE FROM all_tab_privs_made WHERE GRANTOR = 'EMPLEADO1';

-- 9.	Como empleado2 consulta los privilegios que ha concedido y a quien.

SELECT PRIVILEGE, GRANTEE FROM all_tab_privs_made WHERE GRANTOR = 'EMPLEADO2';

-- 10.	Como empleado2 consulta los privilegios que tiene concedidos (recibidos) y quien se los ha concedido.

SELECT PRIVILEGE, GRANTOR FROM all_tab_privs_recd WHERE GRANTEE = 'EMPLEADO2';

-- 11.	Desde system revoca al empleado1 los privilegios para seleccionar, insertar, borrar y modificar datos 
-- de la tabla coches del usuario taller. 
-- (no es taller, es el ejercicio de la nba)
-- �Se le ha revocado el permiso de tambi�n al empleado2? �Por qu�?

REVOKE SELECT, INSERT, DELETE, UPDATE 
ON nba12.JUGADORES
FROM EMPLEADO1;

-- 12.	Borra los usuarios empleado1, empleado 2 y empleado3 obligando a que se borren todos los objetos de sus esquemas. 
-- Recuerda que previamente debes cerrar las sesiones que estos usuarios tuvieran abiertas.

-- Primero cerramos la sesi�n del usuario empleado1.
SELECT INST_ID, SID, SERIAL# FROM GV$SESSION WHERE USERNAME = 'EMPLEADO1';
ALTER SYSTEM KILL SESSION '25,22241,@1';

-- Cerramos la sesi�n del usuario empelado2.
SELECT INST_ID, SID, SERIAL# FROM GV$SESSION WHERE USERNAME = 'EMPLEADO2';
ALTER SYSTEM KILL SESSION '274,16699,@1';

-- Eliminamos los 3 usuarios.
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
DROP USER EMPLEADO2 CASCADE;
DROP USER EMPLEADO1 CASCADE;
DROP USER EMPLEADO3 CASCADE;


