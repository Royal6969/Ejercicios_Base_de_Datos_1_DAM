-------------------------------- Programaci�n PL/SQL: Bloques an�nimos -------------------------------

-- Genera los siguientes c�digos PL/SQL sobre la base de datos de ciclistas:

-- 1. Escribe una funci�n que tenga como par�metro de entrada un equipo y devuelva la media de edad de sus ciclistas. 
-- Tratar la excepci�n definida por Oracle al introducir un equipo que no existe. 
-- Escribe un bloque an�nimo para probar que se recoge la excepci�n. 
-- �Habr�a que controlar la excepci�n �TOO_MANY_ROWS�? �Por qu�?

CREATE OR REPLACE FUNCTION f_mediaEdad(V_EQUIPO IN CICLISTA.NOMEQ%TYPE)
RETURN CICLISTA.EDAD%TYPE

IS
    V_EDAD_MEDIA CICLISTA.EDAD%TYPE;
    
BEGIN
    SELECT AVG(CICLISTA.EDAD) INTO V_EDAD_MEDIA
    FROM CICLISTA
    WHERE NOMEQ = V_EQUIPO;
    
    RETURN V_EDAD_MEDIA;
    
EXCEPTION  
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay equipos con ese nombre'); -- preguntar a fran por qu� no sale en el DBMS
    
END;

-- bloque an�nimo

DECLARE
    V_EQUIPO1 CICLISTA.NOMEQ%TYPE;
    V_MEDIA_EDAD CICLISTA.EDAD%TYPE;
    
BEGIN
    V_EQUIPO1 := '&EQUIPO';
    
    V_MEDIA_EDAD := f_mediaEdad(V_EQUIPO1);
    
    DBMS_OUTPUT.PUT_LINE(V_MEDIA_EDAD);
    
END;

-- 2. Escribe una funci�n que tenga como par�metro de entrada el c�digo de maillot y devuelva el premio que corresponde por llevarlo. 
-- Crea una excepci�n de usuario con nombre, llamada NO_EXISTE_MAILLOT, y haz su gesti�n. 
-- Escribe un bloque an�nimo para probar que se recoge la excepci�n

CREATE OR REPLACE FUNCTION f_premioMaillot (V_COD_MAILLOT IN MAILLOT.CODIGO%TYPE) 
RETURN MAILLOT.PREMIO%TYPE

IS
    V_PREMIO MAILLOT.PREMIO%TYPE;
    --NO_EXISTE_MAILLOT EXCEPTION;
    
BEGIN
    SELECT PREMIO INTO V_PREMIO
    FROM MAILLOT
    WHERE CODIGO = V_COD_MAILLOT;
    
    --IF V_PREMIO IS NULL THEN
        --RAISE NO_EXISTE_MAILLOT;
    --END IF;
    
    RETURN V_PREMIO;
    
EXCEPTION
    --WHEN NO_EXISTE_MAILLOT THEN
        --DBMS_OUTPUT.PUT_LINE('No hay ningun ciclista con ese maillot');  -- preguntar a fran por qu� no sale en el DBMS
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR (-20005, 'No hay ningun ciclista con ese maillot');
END;

-- bloque an�nimo

DECLARE 
    V_CODIGO MAILLOT.CODIGO%TYPE;
    V_PREMIO1 MAILLOT.PREMIO%TYPE;
    
    NO_EXISTE_MAILLOT EXCEPTION;
    PRAGMA EXCEPTION_INIT (NO_EXISTE_MAILLOT, -20005);
    
BEGIN
    V_CODIGO := '&CODIGO';
    
    V_PREMIO1 := f_premioMaillot(V_CODIGO);
    
    DBMS_OUTPUT.PUT_LINE(V_PREMIO1);
    
END;

-- 3. Escribe una funci�n que tenga como par�metro el nombre del ciclista y devuelva todos sus datos (de la tabla ciclista). 
-- Dentro de la funci�n, recoge cualquier excepci�n que pueda surgir (sin importar su tipo). 
-- Lanza una una excepci�n de usuario �sin nombre� (RAISE_APPLICATION_ERROR) 
-- y haz su tratamiento (PRAGMA EXCEPTION_INIT) en el bloque an�nimo que debes generar para probar la funci�n.

CREATE OR REPLACE FUNCTION f_datosCiclista (V_NOMBRE IN CICLISTA.NOMBRE%TYPE)
RETURN CICLISTA%ROWTYPE

IS
    V_DATOS CICLISTA%ROWTYPE;

BEGIN
    SELECT * INTO V_DATOS
    FROM CICLISTA
    WHERE NOMBRE = V_NOMBRE;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'No hay ciclistas con este nombre');
    END IF;
    
    RETURN V_DATOS;
    
END;

-- bloque an�nimo

DECLARE 
    V_NOMBRE1 CICLISTA.NOMBRE%TYPE;
    V_REGISTRO CICLISTA%ROWTYPE;
    NO_EXISTE_CICLISTA EXCEPTION;
    PRAGMA EXCEPTION_INIT(NO_EXISTE_CICLISTA, -20010);
    
BEGIN
    V_NOMBRE1 := '&NOMBRE';
    
    V_REGISTRO := f_datosCiclista(V_NOMBRE1);
    
    DBMS_OUTPUT.PUT_LINE(V_REGISTRO.DORSAL || ' ' || V_REGISTRO.NOMBRE || ' ' || V_REGISTRO.EDAD || ' ' || V_REGISTRO.NOMEQ);
    
EXCEPTION
    WHEN NO_EXISTE_CICLISTA THEN
        DBMS_OUTPUT.PUT_LINE('Error: no existe ciclista');  -- preguntar a fran por qu� no sale en el DBMS
    
END;

-- 4. Escribe un procedimiento que incluya un cursor expl�cito, manejado con �OPEN, FETCH, CLOSE� y prop�n el manejo de sus excepciones.

CREATE OR REPLACE PROCEDURE p_datosCiclista_v2 (V_EQUIPO IN CICLISTA.NOMEQ%TYPE)-- ejor no declarar aqu� el V_DATOS porque esta variable en vd no va a salir, sino que se va a mostrar

IS
    V_DATOS CICLISTA%ROWTYPE;
    
    CURSOR c_datos IS
        SELECT * 
        FROM CICLISTA
        WHERE NOMEQ = V_EQUIPO;

BEGIN 
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.EDAD);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMEQ);
                
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
END p_datosCiclista_v2;
            
-- bloque an�nimo

DECLARE 
    V_EQUIPO1 CICLISTA.NOMEQ%TYPE;
    
BEGIN
    V_EQUIPO1 := '&EQUIPO';
    
    p_datosCiclista_v2(V_EQUIPO1);
    
    -- los datos ya los muestra el cursor
END;

-- 5. Escribe un procedimiento que incluya un cursor expl�cito, manejado con �FOR� y prop�n el manejo de sus excepciones

CREATE OR REPLACE PROCEDURE p_datosCiclista_v3 (V_EQUIPO IN CICLISTA.NOMEQ%TYPE)-- ejor no declarar aqu� el V_DATOS porque esta variable en vd no va a salir, sino que se va a mostrar

IS
    V_DATOS CICLISTA%ROWTYPE;
    
    CURSOR c_datos IS
        SELECT * 
        FROM CICLISTA
        WHERE NOMEQ = V_EQUIPO;

BEGIN
    FOR V_DATOS IN c_datos LOOP
        DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
        DBMS_OUTPUT.PUT_LINE(V_DATOS.EDAD);
        DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMEQ);
    END LOOP;
            
END p_datosCiclista_v3;
            
-- bloque an�nimo

DECLARE 
    V_EQUIPO1 CICLISTA.NOMEQ%TYPE;
    
BEGIN
    V_EQUIPO1 := '&EQUIPO';
    
    p_datosCiclista_v3(V_EQUIPO1);
    
    -- los datos ya los muestra el cursor
END;
