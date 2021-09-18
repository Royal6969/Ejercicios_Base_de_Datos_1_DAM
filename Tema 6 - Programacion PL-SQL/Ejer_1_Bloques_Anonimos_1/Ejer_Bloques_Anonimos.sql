@C:\Creación_taller.sql;

@C:\Inserciones_taller.sql;

--------------------------------------------------------------------------------

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER TALLER12 IDENTIFIED BY oracle;
ALTER USER TALLER12 QUOTA 5M ON USERS;

GRANT CONNECT, RESOURCE TO TALLER12;

--------------------------------------------------------------------------------

-- 1.	Crea un bloque PL/SQL que pida al usuario su nombre por teclado y que posteriormente lo visualice de la siguiente forma “El nombre introducido es: NOMBRE”.
SET SERVEROUT ON;

DECLARE V_NOMBRE VARCHAR2(50); 
BEGIN V_NOMBRE:='&IntroduzcaUnNombre'; 
DBMS_OUTPUT.PUT_LINE('EL NOMBRE INTRODUCIDO ES: '|| V_NOMBRE); 
END;

-- 2.	Crea un bloque PL/SQL en el que se declaren dos variables que almacenen dos números que se pidan por teclado y se muestre su suma por pantalla.

SET SERVEROUT ON;

DECLARE
    V_NUM1 number(1);
    V_NUM2 number(1);

BEGIN 
    V_NUM1:=&v_n1;
    V_NUM2:=&v_n2;

    V_NUM1 := V_NUM1 + V_NUM2;

    DBMS_OUTPUT.PUT_LINE('La suma de los numeros es: ' || V_NUM1); 
END;

-- 3.	Crea un bloque PL/SQL que muestre la suma del salario de todos los mecánicos (tienes que hacer uso de %TYPE para declarar una variable).

SET SERVEROUT ON;

DECLARE 
    V_SALARIO mecanicos.salario%TYPE;
    
BEGIN 
    SELECT SUM(mecanicos.salario) into V_SALARIO
    FROM MECANICOS;

    DBMS_OUTPUT.PUT_LINE('La suma de todos los sueldos es: ' || V_SALARIO); 
END;

-- 4.	Crea un bloque PL/SQL que muestre el número mecánicos y si no hay mecánicos que muestre por pantalla “No hay mecánicos”.

SET SERVEROUT ON;

DECLARE
    V_NUM_MEC NUMBER(3); -- no se usa aquí el %TYPE porque luego haremos un SELECT con un COUNT(*)
    
BEGIN
    SELECT COUNT(*) INTO V_NUM_MEC
    FROM MECANICOS;
    
    IF V_NUM_MEC = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No hay mecánicos');
    
    ELSE
    DBMS_OUTPUT.PUT_LINE('El número de mecánicos es:' || V_NUM_MEC);
    END IF;
END;

-- 5.	Crea un bloque PL/SQL que muestre los datos del mecánico con DNI '1001' (tienes que hacer uso de %ROWTYPE para declarar una variable).

SET SERVEROUT ON;

DECLARE 
    V_MEC MECANICOS%ROWTYPE;

BEGIN 

    SELECT * INTO V_MEC
    FROM MECANICOS
    WHERE DNI='1001';

    DBMS_OUTPUT.PUT_LINE(V_MEC.DNI || ' - '|| V_MEC.APELLIDOS || ' - ' || V_MEC.NOMBRE || ' - ' || V_MEC.PUESTO || ' - ' || V_MEC.SALARIO || ' - ' || V_MEC.PARCIAL || ' - ' || V_MEC.TELEFONO);
END;


-- 6.	Crea un bloque PL/SQL que obtenga el año de fabricación del coche con matrícula 'M3020KY' y muestre por pantalla 'Muy antiguo' si el año es menor que 1990, 'Antiguo' si está entre 1990 y 2000, y 'Moderno' si es superior a 2000.

SET SERVEROUT ON;

DECLARE
    V_AÑO_FAB COCHES.AÑO_FABRICACION%TYPE;
    
BEGIN
    SELECT COCHES.AÑO_FABRICACION INTO V_AÑO_FAB
    FROM COCHES
    WHERE COCHES.MATRICULA = 'M3020KY';
    
    IF V_AÑO_FAB < 1990 THEN
        DBMS_OUTPUT.PUT_LINE(V_AÑO_FAB || ' - Muy antiguo');
    END IF;
    
    IF V_AÑO_FAB >= 1990 AND V_AÑO_FAB <= 2000 THEN
        DBMS_OUTPUT.PUT_LINE(V_AÑO_FAB || ' - Antiguo');
    END IF;
    
    IF V_AÑO_FAB >= 2000 THEN
        DBMS_OUTPUT.PUT_LINE(V_AÑO_FAB || ' - Moderno');
    END IF;
END;

-- 7.	Crea un bloque PL/SQL que muestre por pantallas los número de 1 al 10 usando un bucle FOR, los números de 20 al 30 usando un bucle WHILE y los números del 40 al 50 usando un bucle LOOP.

-------------- for ------ del 1 al 10 -----------

SET SERVEROUT ON;

BEGIN   
  FOR i IN 1..10
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;

-- De 10 a 1
BEGIN
  FOR i IN REVERSE 1..10
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;

-------- while --------------
DECLARE
  i NUMBER(8) := 20;
BEGIN   
  WHILE (i<=30)
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    i := i+1;
  END LOOP;
END;

--------- loop -------------
DECLARE
  i NUMBER(2) := 40;
BEGIN   
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    EXIT WHEN i=50;
    i := i+1;
  END LOOP;
END;

----------- Jaime ---------------

SET SERVEROUT ON;

DECLARE 
    I NUMBER;
BEGIN 
    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;

    FOR I IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;

    I:= 20;
    WHILE I>19 AND I<31 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I:=I+1;
    END LOOP;

    I:=40;
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I:=I+1;
        IF I>50 THEN
        EXIT;
        END IF;
    END LOOP;
END;


-- 8.	Crea un bloque aumente el 100 el salario de todos los mecánicos cuyo puesto es CHAPA.

SELECT * FROM MECANICOS WHERE MECANICOS.PUESTO = 'CHAPA';

SET SERVEROUT ON;

DECLARE 
    V_SAL_INCREASE MECANICOS.SALARIO%TYPE := 100;
    
    
BEGIN
    UPDATE MECANICOS
    SET MECANICOS.SALARIO = MECANICOS.SALARIO + V_SAL_INCREASE
    WHERE MECANICOS.PUESTO = 'CHAPA';
    
END;

SELECT * FROM MECANICOS WHERE MECANICOS.PUESTO = 'CHAPA';

-- 9.	Crea un bloque PL/SQL que que reciba una cadena de texto por teclado y la muestre por pantalla al revés.

SET SERVEROUT ON;

DECLARE
    V_CADENA VARCHAR(10);
    V_CADENA_REV VARCHAR(10);
BEGIN
    V_CADENA:='&v_cad';
FOR i IN REVERSE 1..LENGTH(V_CADENA) LOOP
    V_CADENA_REV := V_CADENA_REV || SUBSTR(V_CADENA,i,1);
END LOOP;
    DBMS_OUTPUT.PUT_LINE(V_CADENA_REV);
END;

-- 10.	Crea un bloque PL/SQL que muestre el número de años completos que hay entre dos fechas (crea dos variables de tipo fecha con las fechas que quieras para probar).

SET SERVEROUT ON;

-- ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD'; opcional para poner el formato que queramos

DECLARE
    V_FECHA1 DATE := TO_DATE('01-01-2021');
    V_FECHA2 DATE := TO_DATE('01-01-2020');
    V_RESULTADO NUMBER;

BEGIN
    V_RESULTADO := (V_FECHA1 - V_FECHA2)/365; -- si no lo dividiera entre 365, el resultado sería en días
    DBMS_OUTPUT.PUT_LINE(V_RESULTADO);

END;

-- 11.	Crea un bloque PL/SQL que inserte dos mecánicos en la tabla coches y que aumente el salario de un mecánico en 100.

SET SERVEROUT ON;

DECLARE 
    V_MEC1 MECANICOS%ROWTYPE := (1020, 'Diaz', 'SERGIO', 'CHAPA', 1000, 0, 6666666);
    V_MEC2 MECANICOS%ROWTYPE := (3040, 'Campos', 'FERNANDO', 'MOTOR', 2000, 1, 7777777);
    V_SAL_INCREASE MECANICOS.SALRIO%TYPE := 100;
    
BEGIN
    INSERT INTO MECANICOS VALUES (V_MEC1.DNI, V_MEC1.APELLIDOS, V_MEC1.NOMBRE, V_MEC1.PUESTO, V_MEC1.SALARIO, V_MEC1.PARCIAL, V_MEC1.TELEFONO); 
    INSERT INTO MECANICOS VALUES (V_MEC2.DNI, V_MEC2.APELLIDOS, V_MEC2.NOMBRE, V_MEC2.PUESTO, V_MEC2.SALARIO, V_MEC2.PARCIAL, V_MEC2.TELEFONO);

    UPDATE MECANICOS
    SET MECANICOS.SALARIO = MECANICOS.SALARIO + V_SAL_INCREASE
    WHERE MECANICOS.DNI = V_MEC1.DNI;
    
    DBMS_OUTPUT.PUT_LINE(V_MEC1.DNI || V_MEC1.APELLIDOS || V_MEC1.NOMBRE || V_MEC1.PUESTO || V_MEC1.SALARIO || V_MEC1.PARCIAL || V_MEC1.TELEFONO);
    DBMS_OUTPUT.PUT_LINE(V_MEC2.DNI || V_MEC2.APELLIDOS || V_MEC2.NOMBRE || V_MEC2.PUESTO || V_MEC2.SALARIO || V_MEC2.PARCIAL || V_MEC2.TELEFONO);

END;

------------------ Adan ---------------------

SET SERVEROUT ON;

DECLARE
    V_MECANICO MECANICOS%ROWTYPE;
BEGIN
    FOR I IN 1..2 LOOP
    V_MECANICO.DNI := '&DNIVAR';
    V_MECANICO.APELLIDOS := '&APEVAR';
    V_MECANICO.NOMBRE := '&NOMVAR';
    V_MECANICO.PUESTO := '&PUEVAR';
    V_MECANICO.SALARIO := '&SALVAR';
    V_MECANICO.PARCIAL := '&PARVAR';
    V_MECANICO.TELEFONO := '&TELVAR';
    INSERT INTO MECANICOS VALUES (V_MECANICO.DNI, V_MECANICO.APELLIDOS, V_MECANICO.NOMBRE, V_MECANICO.PUESTO, V_MECANICO.SALARIO, V_MECANICO.PARCIAL, V_MECANICO.TELEFONO);
    END LOOP;
    
    UPDATE MECANICOS SET SALARIO = SALARIO +100 WHERE DNI LIKE DNIVAR;
END;

----------------- Jaime ------------------------
SET SERVEROUTPUT ON;

DECLARE
    V_MEC1 MECANICOS%ROWTYPE;
    V_MEC2 MECANICOS%ROWTYPE;

    V_DNIMEC MECANICOS.DNI%TYPE;
    V_AUMENTO MECANICOS.SALARIO%TYPE := 100;
    
    V_MECACT MECANICOS%ROWTYPE; --mecanico actualizado
    V_MECACT2 MECANICOS%ROWTYPE; --mecánico actualizado

BEGIN

    V_MEC1.DNI:='1020';
    V_MEC1.APELLIDOS:='Diaz';
    V_MEC1.NOMBRE:='SERGIO';
    V_MEC1.PUESTO:='MOTOR';
    V_MEC1.SALARIO:=1000;
    V_MEC1.PARCIAL:='0';
    V_MEC1.TELEFONO:='6666666';

    V_MEC2.DNI:='3040';
    V_MEC2.APELLIDOS:='Diaz';
    V_MEC2.NOMBRE:='FERNANDO';
    V_MEC2.PUESTO:='CHAPA';
    V_MEC2.SALARIO:=1100;
    V_MEC2.PARCIAL:='0';
    V_MEC2.TELEFONO:='7777777';

    V_DNIMEC := V_MEC2.DNI;

    INSERT INTO MECANICOS VALUES (V_MEC1.DNI, V_MEC1.APELLIDOS, V_MEC1.NOMBRE, V_MEC1.PUESTO, V_MEC1.SALARIO, V_MEC1.PARCIAL, V_MEC1.TELEFONO);
    INSERT INTO MECANICOS VALUES (V_MEC2.DNI, V_MEC2.APELLIDOS, V_MEC2.NOMBRE, V_MEC2.PUESTO, V_MEC2.SALARIO, V_MEC2.PARCIAL, V_MEC2.TELEFONO);

    UPDATE MECANICOS

    SET SALARIO = SALARIO + V_AUMENTO
    WHERE DNI = V_DNIMEC;

    SELECT * INTO V_MECACT
    FROM MECANICOS
    WHERE DNI=V_DNIMEC;

    V_DNIMEC := V_MEC1.DNI;

    SELECT * INTO V_MECACT2
    FROM MECANICOS
    WHERE DNI=V_DNIMEC;

END;


