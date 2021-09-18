------------------------------- Ejer 1 ---------------------------

CREATE OR REPLACE FUNCTION f_jugadores (V_EQUIPO IN JUGADORES.NOMBRE_EQUIPO%TYPE) 
RETURN NUMBER
IS
    V_JUGADORES NUMBER;

BEGIN
    SELECT COUNT(*) INTO V_JUGADORES
    FROM JUGADORES
    WHERE NOMBRE_EQUIPO = V_EQUIPO;

    RETURN V_JUGADORES;
    
END;

--------------------------------- Ejer 2 ---------------------------
-- bloque anónimo

DECLARE
    V_EQUIPO JUGADORES.NOMBRE_EQUIPO%TYPE;
    V_JUGADORES NUMBER;
    
BEGIN
    V_EQUIPO := '&EQUIPO';
    
    V_JUGADORES := f_jugadores(V_EQUIPO);
    
    DBMS_OUTPUT.PUT_LINE('El equipo ' || V_EQUIPO || ' tiene ' || V_JUGADORES || ' jugadores');

END;

------------------------------- Ejer 3 ----------------------------

CREATE OR REPLACE PROCEDURE p_partido
(V_EQUIPO_LOCAL IN PARTIDOS.EQUIPO_LOCAL%TYPE, V_EQUIPO_VISITANTE IN PARTIDOS.EQUIPO_VISITANTE%TYPE, V_TEMPORADA IN PARTIDOS.TEMPORADA%TYPE,
V_PUNTOS_LOCAL OUT PARTIDOS.PUNTOS_LOCAL%TYPE, V_PUNTOS_VISITANTE OUT PARTIDOS.PUNTOS_VISITANTE%TYPE)
IS
    GANA_VISITANTE EXCEPTION;

BEGIN
    SELECT PUNTOS_LOCAL, PUNTOS_VISITANTE INTO V_PUNTOS_LOCAL, V_PUNTOS_VISITANTE
    FROM PARTIDOS
    WHERE EQUIPO_LOCAL = V_EQUIPO_LOCAL
    AND EQUIPO_VISITANTE = V_EQUIPO_VISITANTE
    AND TEMPORADA = V_TEMPORADA;
    
    IF V_PUNTOS_VISITANTE > V_PUNTOS_LOCAL THEN
        RAISE GANA_VISITANTE;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se han encontrado equipos con ese nombre y/o ese numero de temporada');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas de un mismo equipo con ese nombre y/o mas de una temporada con esa numeracion');
    WHEN GANA_VISITANTE THEN
        DBMS_OUTPUT.PUT_LINE('El equipo local ' || V_EQUIPO_LOCAL || ' ha perdido en casa');

END p_partido;

----------------------------- Ejer 4 -----------------------------
-- bloque anónimo

DECLARE 
    V_EQUIPO_LOCAL PARTIDOS.EQUIPO_LOCAL%TYPE; 
    V_EQUIPO_VISITANTE PARTIDOS.EQUIPO_VISITANTE%TYPE; 
    V_TEMPORADA PARTIDOS.TEMPORADA%TYPE;
    V_PUNTOS_LOCAL PARTIDOS.PUNTOS_LOCAL%TYPE; 
    V_PUNTOS_VISITANTE PARTIDOS.PUNTOS_VISITANTE%TYPE;
    
BEGIN
    V_EQUIPO_LOCAL := '&EQUIPO_LOCAL';
    V_EQUIPO_VISITANTE := '&EQUIPO_VISITANTE';
    V_TEMPORADA := '&TEMPORADA';
    
    p_partido(V_EQUIPO_LOCAL, V_EQUIPO_VISITANTE, V_TEMPORADA, V_PUNTOS_LOCAL, V_PUNTOS_VISITANTE);
    --p_partido_v2(V_EQUIPO_LOCAL, V_EQUIPO_VISITANTE, V_TEMPORADA, V_PUNTOS_LOCAL, V_PUNTOS_VISITANTE); esta línea sirve para el ejercicio 5
    
    DBMS_OUTPUT.PUT_LINE('El resultado del partido fue:');
    DBMS_OUTPUT.PUT_LINE(V_EQUIPO_LOCAL || ' ' || V_PUNTOS_LOCAL );
    DBMS_OUTPUT.PUT_LINE(V_EQUIPO_VISITANTE || ' ' || V_PUNTOS_VISITANTE);
    
END;

------------------------------ Ejer 5 ---------------------------

CREATE OR REPLACE PROCEDURE p_partido_v2
(V_EQUIPO_LOCAL IN PARTIDOS.EQUIPO_LOCAL%TYPE, V_EQUIPO_VISITANTE IN PARTIDOS.EQUIPO_VISITANTE%TYPE, V_TEMPORADA IN PARTIDOS.TEMPORADA%TYPE,
V_PUNTOS_LOCAL OUT PARTIDOS.PUNTOS_LOCAL%TYPE, V_PUNTOS_VISITANTE OUT PARTIDOS.PUNTOS_VISITANTE%TYPE)
IS

BEGIN
    SELECT PUNTOS_LOCAL, PUNTOS_VISITANTE INTO V_PUNTOS_LOCAL, V_PUNTOS_VISITANTE
    FROM PARTIDOS
    WHERE EQUIPO_LOCAL = V_EQUIPO_LOCAL
    AND EQUIPO_VISITANTE = V_EQUIPO_VISITANTE
    AND TEMPORADA = V_TEMPORADA;
    
    IF V_PUNTOS_VISITANTE < V_PUNTOS_LOCAL THEN
        RAISE_APPLICATION_ERROR(-20100, 'El equipo visitante ' || V_EQUIPO_VISITANTE || ' ha  PERDIDO');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se han encontrado equipos con ese nombre y/o ese numero de temporada');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas de un mismo equipo con ese nombre y/o mas de una temporada con esa numeracion');

END p_partido_v2;

-- para el bloque anónimo de este ejercicio, puede reutilizarse el del ejercicio 4, 
-- poniendo correctamente el nombre en la llamada del anterior procedimiento pero esta vez acabado en "_v2"
-- lo cual se acaba viendo el el próximo ejercicio 6 a continuación

------------------------------- Ejer 6 ---------------------------
-- bloque anónimo

DECLARE 
    V_EQUIPO_LOCAL PARTIDOS.EQUIPO_LOCAL%TYPE; 
    V_EQUIPO_VISITANTE PARTIDOS.EQUIPO_VISITANTE%TYPE; 
    V_TEMPORADA PARTIDOS.TEMPORADA%TYPE;
    V_PUNTOS_LOCAL PARTIDOS.PUNTOS_LOCAL%TYPE; 
    V_PUNTOS_VISITANTE PARTIDOS.PUNTOS_VISITANTE%TYPE;
    
    VISITANTE_PIERDE EXCEPTION;
    PRAGMA EXCEPTION_INIT(VISITANTE_PIERDE, -20100);
    
BEGIN
    V_EQUIPO_LOCAL := '&EQUIPO_LOCAL';
    V_EQUIPO_VISITANTE := '&EQUIPO_VISITANTE';
    V_TEMPORADA := '&TEMPORADA';
    
    p_partido_v2(V_EQUIPO_LOCAL, V_EQUIPO_VISITANTE, V_TEMPORADA, V_PUNTOS_LOCAL, V_PUNTOS_VISITANTE);
    
    DBMS_OUTPUT.PUT_LINE('El resultado del partido fue:');
    DBMS_OUTPUT.PUT_LINE(V_EQUIPO_LOCAL || ' ' || V_PUNTOS_LOCAL );
    DBMS_OUTPUT.PUT_LINE(V_EQUIPO_VISITANTE || ' ' || V_PUNTOS_VISITANTE);
    
EXCEPTION
    WHEN VISITANTE_PIERDE THEN
        DBMS_OUTPUT.PUT_LINE('El equipo visitante ' || V_EQUIPO_VISITANTE || ' ha  PERDIDO');
    
END;
