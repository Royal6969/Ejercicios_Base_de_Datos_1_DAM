---------------------------- Perfil por defecto -----------------------

-- 1.	Consulta los datos de los perfiles creados en la base de datos.

SELECT * FROM dba_profiles;

-- 2.	Consulta los datos de todos los usuarios de la base de datos ¿Cuál es el perfil por defecto de los usuarios nbaXX y jardineriaXX?

SELECT * FROM dba_users
WHERE USERNAME = 'JARDINERIA12'
OR USERNAME = 'NBA12';

-- 3.	Crea el usuario profesor1 con password profesor1.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER PROFESOR1 IDENTIFIED BY PROFESOR1;
ALTER USER PROFESOR1 QUOTA 5M ON USERS;

-- 4.	Consulta los datos de todos los usuarios de la base de datos. ¿Cuál es el perfil por defecto del usuario profesor1?

SELECT * FROM dba_users
WHERE USERNAME = 'PROFESOR1';

-- 5.	Consulta los los límites asignados al perfil DEFAULT.

SELECT PROFILE, LIMIT FROM dba_profiles
WHERE PROFILE = 'DEFAULT';

------------------- Habilitar/deshabilitar la limitación de recursos mediante perfiles ------------------------

-- 6.	Consulta el valor del parámetro de inicialización RESOURCE_LIMIT .

SHOW PARAMETER RESOURCE_LIMIT;

-- 7.	Habilita la limitación de recursos mediante perfiles.

ALTER SYSTEM SET RESOURCE_LIMIT=TRUE;

-------------------- Crear perfiles ------------------------

-- 8.	Crea un perfil denominado TARDE con los siguientes limites:
-- •	El número máximo de sesiones concurrentes será 2.
-- •	El tiempo de inactividad continuada en una sesión será de 5 minutos.
-- •	La contraseña caduca cada dos meses.
-- •	Solo se permiten tres intentos fallidos en el acceso a la cuenta.
-- •	Si se superan los 3 intentos la cuenta se bloqueará.

CREATE PROFILE TARDE LIMIT 
    SESSIONS_PER_USER 2
    IDLE_TIME 5
    PASSWORD_LIFE_TIME 60
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_LOCK_TIME UNLIMITED;
 
-- 9.	Consulta los los límites asignados al perfi TARDE.

SELECT PROFILE, LIMIT FROM dba_profiles
WHERE PROFILE = 'TARDE';

----------------------- Asignar perfiles a usuarios -------------------------------

-- 10.	Asigna el perfil TARDE al usuario profesor1.

ALTER USER PROFESOR1 PROFILE TARDE;

-- 11.	Crea el usuario profesor2 con password profesor2 y el perfil TARDE.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER PROFESOR2 IDENTIFIED BY PROFESOR2;
ALTER USER PROFESOR1 QUOTA 5M ON USERS;

-- 12.	Consulta el perfil asignado a los usuarios profesor1 y profesor2.

SELECT USERNAME, PROFILE
FROM dba_users
WHERE USERNAME = 'PROFESOR1' OR USERNAME = 'PROFESOR2';

-- 13.	Asigna el rol CONNECT al profesor1.

GRANT CONNECT TO PROFESOR1;

-- 14.	Conéctate como profesor1 y consulta los límites de recursos y passwords que tiene el usuario.

SELECT * FROM USER_RESOURCE_LIMITS;

--------------------- Modificar perfiles ----------------------------

-- 15.	Modifica el perfil TARDE para que el número máximo de sesiones concurrentes sea 3.

ALTER PROFILE TARDE LIMIT SESSIONS_PER_USER 3;

-- 16.	Consulta los los límites asignados al perfi TARDE.

SELECT PROFILE, LIMIT FROM dba_profiles
WHERE PROFILE = 'TARDE';

------------------------ Borrar perfiles --------------------------

-- 17.	Borra el perfil TARDE.

DROP PROFILE TARDE CASCADE;

-- 18.	Borra los usuarios profesor1 y profesor2.

SELECT INST_ID, SID, SERIAL# FROM GV$SESSION WHERE USERNAME = 'PROFESOR1';
ALTER SYSTEM KILL SESSION '148,12600,@1';

