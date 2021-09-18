-- Para ver los roles del usuario conectado en ese momento:

select username, granted_role
   from user_role_privs;

-- La siguiente select muestra los roles asignados a un usuario en concreto:

select grantee, granted_role from dba_role_privs
  where grantee = upper ('&grantee')
  order by grantee;

-- Para ver los roles asignado a un rol:

select role, granted_role
 from role_role_privs;

-- Para ver los roles definidos en la base de datos:

select role from dba_roles;

-- para ver a quien se le ha concedido el rol X

SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE = 'X' ;

-----------------------------------------------------------------------------------------------

-- 1.	Sobre la base de datos Oracle conéctate como usuario system.

SELECT * FROM SESSION_ROLES;



-- 2.	Consulta los roles predefinidos en Oracle.

-- 1º posibilidad
SELECT * FROM DBA_ROLE_PRIVS;
-- 2º posibilidad
SELECT DISTINCT GRANTED_ROLE, DEFAULT_ROLE FROM DBA_ROLE_PRIVS WHERE DEFAULT_ROLE = 'YES';

-- 3.	Consulta los privilegios de sistema concedidos a los roles CONNECT y RESOURCE.

-- nuestra opción es:
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE';

-------------- otra opcion ---------------
select
    grantee           role_name,
    privilege         privilege,
    admin_option      admin_grantable
from
    dba_sys_privs
where
    grantee in
    (
        select
             role
        from
             dba_roles
    );
    
-- UNION ALL 

select
    grantee           role_name,
    privilege         privilege,
    grantable         admin_grantable
from
    dba_tab_privs
(
        select
             role
        from
             dba_roles
    );
------------------------------------------------------------

select privilege 
from dba_sys_privs 
where grantee='CONNECT' 
order by 1;

-------------------------------------------------------

select * from USER_ROLE_PRIVS where USERNAME='SAMPLE';
select * from USER_TAB_PRIVS where Grantee = 'SAMPLE';
select * from USER_SYS_PRIVS where USERNAME = 'SAMPLE';

-- 4.	Consulta los privilegios de sistema concedidos al rol DBA.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'DBA';

-- 5.	Consulta los privilegios sobre objetos concedidos a los roles CONNECT y RESOURCE.

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'RESOURCE'; -- no sale nada?? exactooo, se comprueba con el siguiente apartado
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'CONNECT'; -- no sale nada??

-- 6.	Consulta los privilegios sobre objetos concedidos al rol DBA.

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'DBA';

-- 7.	Crea el usuario alumno1 con contraseña alumno1.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER ALUMNO1 IDENTIFIED BY ALUMNO1;

ALTER USER ALUMNO1 QUOTA 5M ON USERS;

-- 8.	Crea el usuario alumno2 con contraseña alumno2.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER ALUMNO2 IDENTIFIED BY ALUMNO2;

ALTER USER ALUMNO2 QUOTA 5M ON USERS;

-- 9.	Crea el rol alumnos sin contraseña.

CREATE ROLE ALUMNO NOT IDENTIFIED;

-- 10.	Verifica que se ha creado el rol.

SELECT * 
FROM DBA_ROLE_PRIVS
WHERE GRANTED_ROLE = 'ALUMNO';

----------------------- Asignar roles a usuarios ------------------------------

-- 11.	Asigna el rol alumnos a los usuarios alumno1 y alumno2.

GRANT ALUMNO TO ALUMNO1, ALUMNO2;

-- 12.	Verifica que el rol se ha asignado a los usuarios. 

SELECT * 
FROM DBA_ROLE_PRIVS
WHERE GRANTED_ROLE = 'ALUMNO';

-- Asignar privilegios a roles // Privilegios de sistema

-- 13.	Asigna los privilegios de sistema CREATE SESSION, CREATE TABLE y CREATE VIEW al rol alumnos.

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO ALUMNO;

-- 14.	Verifica que se han asignado los privilegios

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'ALUMNO';

-- 15.	Establece una conexión como alumno1 y verifica los privilegios de sistema y roles que tiene disponibles en su sesión.

SELECT * FROM USER_SYS_PRIVS; -- por qué no me sale nada con este??
SELECT * FROM USER_ROLE_PRIVS;

------------------------ Privilegios sobre objetos. ----------------------------

-- 16.	Desde el usuario system asigna los privilegios sobre objetos 
-- para consultar e insertar en las tablas jugadores y equipos de usuario nbaxx al rol alumnos.

GRANT SELECT, INSERT ON nba12.JUGADORES TO ALUMNO;
GRANT SELECT, INSERT ON nba12.EQUIPOS TO ALUMNO;

-- 17.	Verifica que se han asignado los privilegios.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'ALUMNO';

-- 18.	Establece una conexión como alumno1 y verifica los privilegios de objetos y roles que tiene disponibles en su sesión. 
-- Comprueba que puede consultar la tabla jugadores del usuario taller.
-- en realidad se refiere al nba12

SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;

SELECT * FROM nba12.JUGADORES;

-- en la tabla de los permisos de objetos, no aparece el privilegio de consuktar una tabla de otro usuario...
-- sin embargo ALUMNO1 ha podido consultar en nba12...
-- esto es porque ese privilegio no es directo, si no que lo tiene a través del rol ALUMNO, y por eso no salía en la tabla de objetos

-------------------  Revocar privilegios a roles -------------------------
-- Privilegios de sistema

-- 19.	Revoca el privilegio CREATE VIEW al rol alumnos.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
REVOKE CREATE VIEW FROM ALUMNO;

-- 20.	Verifica que se ha revocado el privilegio.

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'ALUMNO';

--------------------- Privilegios sobre objetos --------------------------

-- 21.	Revoca los privilegios sobre objetos para consultar e insertar en la tabla equipos del usuario nba al rol alumnos.

REVOKE SELECT ON nba12.EQUIPOS FROM ALUMNO;
REVOKE INSERT ON nba12.EQUIPOS FROM ALUMNO;

-- 22.	Verifica que se han revocado los privilegios.

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'ALUMNO';

--------------------- Privilegio de un usuario que pertenece a un rol. -------------------------

-- 23.	Revoca el privilegio CREATE TABLE solo al alumno2. ¿Qué problema hay y como solucionarlo?

REVOKE CREATE TABLE FROM ALUMNO2;

-- no me deja hacerlo porque no es un privilegio directo
-- tendré que revocárselo al rol

REVOKE CREATE TABLE FROM ALUMNO;

-- extra
-- No es posible porque el usuario tiene el privilegio concedido a través del rol alumnos y no directamente.
-- Habría que quitarle el rol al usuario y (dos posibilidades):
-- – Asignarle el resto de privilegios directamente de uno en uno.
-- – Crear un nuevo rol nuevo a partir del alumno, quitarle el privilegio (CREATE TABLE) al nuevo rol y asignarle el nuevo rol al usuario.

CREATE ROLE ALUMNOv2 NOT IDENTIFIED;

GRANT CREATE SESSION TO ALUMNOv2;

GRANT SELECT, INSERT ON nba12.JUGADORES TO ALUMNOv2;

REVOKE ALUMNO FROM ALUMNO2;

GRANT ALUMNOv2 TO ALUMNO2;



--------------------- Revocar roles ------------------------------

-- 24.	Revoca el rol alumnos a los usuarios alumno1 y alumno2.

REVOKE ALUMNO FROM ALUMNO1;
-- al ALUMNO2 ya se lo había quitado en el apartado anterior

-- 25.	Verifica que el rol se ha revocado a los usuarios.

SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'ALUMNO1';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'ALUMNO2';

-------------------- Borrar roles -------------------------------

-- 26.	Borra el rol alumnos sin contraseña.

DROP ROLE ALUMNO;

-- 27.	Verifica que se ha borrado el rol.

SELECT * 
FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'ALUMNOv2';

SELECT * 
FROM DBA_ROLE_PRIVS
WHERE GRANTED_ROLE = 'ALUMNOv2';

-- 28.	Borra los usuarios alumno1 y alumno2 (asegúrate de no tener sesiones abiertas con estos usuarios).

DROP USER ALUMNO1;
DROP USER ALUMNO2;