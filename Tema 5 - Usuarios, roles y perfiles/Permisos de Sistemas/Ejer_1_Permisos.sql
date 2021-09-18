-- 1.	Otorga privilegio al empleado1 para conectarse a la base de datos y crear, borrar y modificar tablas.

GRANT CREATE SESSION, CREATE TABLE TO EMPLEADO1;

-- 2.	Consulta los privilegios de sistema del empleado1.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'EMPLEADO1';

-- 3.	Otorga privilegios al empleado2 para conectarse a la base de datos 
-- y seleccionar cualquier tabla de la base de datos de forma que pueda conceder ese privilegio a todos los usuarios

GRANT CREATE SESSION TO EMPLEADO2;
GRANT SELECT ANY TABLE TO EMPLEADO2 WITH ADMIN OPTION;

-- 4.	Consulta los privilegios de sistema del empleado2.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'EMPLEADO2';

-- 5.	Otorga privilegios al empleado3 para conectarse, crear tablas en su esquema, 
-- crear vistas en su esquema e insertar datos en cualquier tabla de la base de datos.

GRANT CREATE SESSION TO EMPLEADO3;
GRANT CREATE TABLE TO EMPLEADO3;
GRANT CREATE VIEW TO EMPLEADO3;
GRANT INSERT ANY TABLE TO EMPLEADO3;

-- 6.	Consulta los privilegios de sistema del empleado3.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'EMPLEADO3';

-- 7.	Revoca al empleado3 el privilegio de crear vistas en su esquema. Comprueba que no puede.

REVOKE CREATE VIEW FROM EMPLEADO3;

-- 8.	Consulta los privilegios de sistema del empleado3.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'EMPLEADO3';

-- 9.	Conéctate como empleado2 y concede el privilegio para seleccionar cualquier tabla de la base de datos al empleado3 ¿Es posible? ¿Por qué?

-- sí ha dejado, porque previamente en el apartado 3, le habíamos dado ya el privilegio al EMPLEADO2 de otorgar tal permiso a otros usuarios

-- 10.	Conéctate como system y consulta los privilegios de sistema del empleado3

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'EMPLEADO3';

-- 11.	Revoca el permiso para seleccionar cualquier tabla de la base de datos al empleado2 ¿Se le ha revocado el permiso de también al empleado 3? ¿Por qué?

REVOKE SELECT ANY TABLE FROM EMPLEADO2;

-- sí se ha podido, porque al quitar el permiso de SELECT ANY TABLE al EMPLEADO2, 
-- a su vez, se le quita el permiso "en cascada" al resto de usuarios a los que se lo haya otorgado el EMPLEADO2

-- 12.	Averigua qué usuarios de la base de datos tienen asignado el privilegio “create user” de forma directa

SELECT * FROM DBA_SYS_PRIVS WHERE PRIVILEGE = 'CREATE USER';

-- 13.	Conéctate como empleado2 y averigua los privilegios de sistema que tiene en esa sesión.

SELECT * FROM USER_SYS_PRIVS;

