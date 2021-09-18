----------------------------------- Cursores impl�citos -----------------------------------

-- Consideraciones previas: �nicamente se deben pedir datos por teclado o imprimir mensajes por pantalla en los bloques an�nimos, evitando hacerlo dentro de funciones/procedimientos.

-- 1.	Crea un procedimiento que reciba el nombre de un mec�nico y obtenga su DNI. 
--      Controla adecuadamente las posibles excepciones NO_DATA_FOUND y TOO_MANY_ROWS) 
--      (Usa las funciones SQLCODE y SQLERRM para mostrar informaci�n cuando se produzcan las excepciones).

CREATE OR REPLACE PROCEDURE P_obtenerDNIporNombre(V_NOMBRE IN MECANICOS.NOMBRE%TYPE, V_DNI OUT MECANICOS.DNI%TYPE)
IS

BEGIN
    SELECT DNI INTO V_DNI 
    FROM MECANICOS
    WHERE NOMBRE = V_NOMBRE;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay mec�nicos con ese nombre');
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ': ' || SQLERRM); -- smp es bueno poner esta l�nea para la posible posterior depuraci�n
    
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Hay m�s de un mec�nico con ese nombre');
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ': ' || SQLERRM);
    
END P_obtenerDNIporNombre;

-- bloque an�nimo

DECLARE 
    V_NOMBRE1 MECANICOS.NOMBRE%TYPE;
    V_DNI1 MECANICOS.DNI%TYPE;
    
BEGIN
    V_NOMBRE1 := '&Nombre';
    
    P_obtenerDNIporNombre(V_NOMBRE1, V_DNI1);
    
    DBMS_OUTPUT.PUT_LINE(V_DNI1);
    
END;

-- 2.	Crea un procedimiento en el que se reciba el DNI de un mec�nico y un salario y actualice a ese valor el salario de dicho mec�nico. 
--      Si no existe el mec�nico deber� mostrar un mensaje por pantalla que lo indique.

CREATE OR REPLACE PROCEDURE P_actualizarSalario(V_DNI IN MECANICOS.DNI%TYPE, V_NUEVO_SALARIO IN MECANICOS.SALARIO%TYPE)
IS
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_NUEVO_SALARIO
    WHERE DNI = V_DNI;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay mec�nicos con ese DNI');
    
END P_actualizarSalario;

-- bloque an�nimo

DECLARE 
    V_DNI1 MECANICOS.DNI%TYPE;
    V_NEW_SALARIO MECANICOS.SALARIO%TYPE;
    V_MECANICO MECANICOS%ROWTYPE;
    
BEGIN
    V_DNI1 := '&DNI';
    V_NEW_SALARIO := &SALARIO;
    
    P_actualizarSalario(V_DNI1, V_NEW_SALARIO);
    
    SELECT * INTO V_MECANICO
    FROM MECANICOS
    WHERE DNI = V_DNI1;
    DBMS_OUTPUT.PUT_LINE(V_MECANICO.SALARIO);
    
END;

-- 3.	Actualiza el procedimiento anterior para que lance una excepci�n con el nombre NO_EXISTE_MECANICO (que hay que declarar previamente). 
--      Debes capturar la excepci�n.

CREATE OR REPLACE PROCEDURE P_actualizarSalario_v2 (V_DNI IN MECANICOS.DNI%TYPE, V_NUEVO_SALARIO IN MECANICOS.SALARIO%TYPE)
IS
    NO_EXISTE_MECANICO EXCEPTION;
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_NUEVO_SALARIO
    WHERE DNI = V_DNI;
    
    if SQL%NOTFOUND THEN
    RAISE NO_EXISTE_MECANICO;
    END IF;
    
EXCEPTION    
    WHEN NO_EXISTE_MECANICO THEN
    DBMS_OUTPUT.PUT_LINE('NO existe el mec�nico');
    
END P_actualizarSalario_v2;

-- bloque an�nimo

DECLARE 
    V_DNI1 MECANICOS.DNI%TYPE;
    V_NEW_SALARIO MECANICOS.SALARIO%TYPE;
    V_MECANICO MECANICOS%ROWTYPE;
    
BEGIN
    V_DNI1 := '&DNI';
    V_NEW_SALARIO := &SALARIO;
    
    P_actualizarSalario_v2(V_DNI1, V_NEW_SALARIO);
    
    SELECT * INTO V_MECANICO
    FROM MECANICOS
    WHERE DNI = V_DNI1;
    
    DBMS_OUTPUT.PUT_LINE(V_MECANICO.SALARIO);
    
END;

-- 4.	Modifica el procedimiento anterior para que lance una excepci�n usando el procedimiento RAISE_APPLICATION_ERROR. 
--      Crea un bloque an�nimo para probar el procedimiento (debes capturar las posibles excepciones que lance el procedimiento).

CREATE OR REPLACE PROCEDURE P_actualizarSalario_v3 (V_DNI IN MECANICOS.DNI%TYPE, V_NUEVO_SALARIO IN MECANICOS.SALARIO%TYPE)
IS
    NO_EXISTE_MECANICO EXCEPTION;
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_NUEVO_SALARIO
    WHERE DNI = V_DNI;
    
    IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'No existe este mec�nico');
    END IF;
    
EXCEPTION
    WHEN NO_EXISTE_MECANICO THEN
    DBMS_OUTPUT.PUT_LINE('No hay mec�nicos con ese DNI');
    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Descripcion del error' || SQLCODE || ': ' || SQLERRM);
    
END P_actualizarSalario_v3;

-- bloque an�nimo

DECLARE
  V_DNI VARCHAR2(9);
  V_NUEVO_SALARIO NUMBER;

BEGIN
  V_DNI := &DNI;
  V_NUEVO_SALARIO := &SALARIO;

  P_actualizarSalario_v3(V_DNI, V_NUEVO_SALARIO);
 
END;

