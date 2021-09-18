-- 1.	Crea un procedimiento que reciba el nombre de un mecánico y obtenga su DNI. 
--      Controla adecuadamente las posibles excepciones NO_DATA_FOUND y TOO_MANY_ROWS) 
--      (Usa las funciones SQLCODE y SQLERRM para mostrar información cuando se produzcan las excepciones).

CREATE OR REPLACE PROCEDURE p_mostrarDNI (V_NOMBRE IN MECANICOS.NOMBRE%TYPE, V_DNI OUT MECANICOS.DNI%TYPE)
IS
    
BEGIN
    SELECT DNI INTO V_DNI
    FROM MECANICOS
    WHERE NOMBRE = V_NOMBRE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('no hay ningun mecanico con ese nombre');
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ': ' || SQLERRM);
    WHEN TOO_MENY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('hay mas de un mecanico con ese nombre');
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ': ' || SQLERRM);
    
END;

-- bloque anónimo

DECLARE
    V_NOMBRE1 MECANICOS.NOMBRE%TYPE;
    V_DNI1 MECANICOS.DNI%TYPE;
    
BEGIN
    V_NOMBRE1 := '&NOMBRE';
    
    p_mostrarDNI(V_NOMBRE1, V_DNI1);
    
    DBMS_OUTPUT.PUT_LINE(V_DNI1);
    
END;

-- 2.	Crea un procedimiento en el que se reciba el DNI de un mecánico y un salario y actualice a ese valor el salario de dicho mecánico. 
--      Si no existe el mecánico deberá mostrar un mensaje por pantalla que lo indique.

CREATE OR REPLACE PROCEDURE p_actualizarSalario (V_DNI IN MECANICOS.DNI%TYPE, V_SALARIO IN MECANICOS.SALARIO%TYPE)
IS 
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_SALARIO
    WHERE DNI = V_DNI;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('no hay ningun mecanico con ese DNI');
    
END p_actualizarSalario;

-- bloque anónimo

DECLARE
    V_DNI1 MECANICOS.DNI%TYPE;
    V_SALARIO1 MECANICOS.SALARIO%TYPE;
    V_MECANICO MECANICOS%ROWTYPE; -- hago esto para poder mostrar el resultadio dps
    
BEGIN
    V_DNI1 := '&DNI';
    V_SALARIO1 := &SALARIO;
    
    p_actualizarSalario(V_DNI1, V_SALARIO1);
    
    SELECT * INTO V_MECANICO
    FROM MECANICOS
    WHERE DNI = V_DNI1;
    DBMS_OUTPUT.PUT_LINE(V_MECANICO.SALARIO); -- y ahora para mostrar el resultado, pongo un DBMS con V_MECANICO.[nombre del campo que quiero mostrar]
    
END;

-- 3.	Actualiza el procedimiento anterior para que lance una excepción con el nombre NO_EXISTE_MECANICO (que hay que declarar previamente). 
--      Debes capturar la excepción.

CREATE OR REPLACE PROCEDURE p_actualizarSalario_v2 (V_DNI IN MECANICOS.DNI%TYPE, V_SALARIO IN MECANICOS.SALARIO%TYPE)
IS
    NO_EXISTE_MECANICO EXCEPTION;
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_SALARIO
    WHERE DNI = V_DNI;
    
    IF SQL%NOTFOUND THEN
        RAISE NO_EXISTE_MECANICO;
    END IF;
    
EXCEPTION
    WHEN NO_EXISTE_MECANICO THEN
    DBMS_OUTPUT.PUT_LINE('no hay ningun mecanico con ese DNI');
    
END p_actualizarSalario_v2;

-- bloque anónimo

DECLARE
    V_DNI1 MECANICOS.DNI%TYPE;
    V_SALARIO1 MECANICOS.SALARIO%TYPE;
    V_MECANICO MECANICOS%ROWTYPE;
    
BEGIN
    V_DNI1 := '&DNI';
    V_SALARIO1 := &SALARIO;
    
    p_actualizarSalario_v2(V_DNI1, V_SALARIO1);
    
    SELECT *
    FROM MECANICOS
    WHERE DNI = V_DNI1;
    DBMS_OUTPUT.PUT_LINE(V_MECANICO.SALARIO);
    
END;

-- 4.	Modifica el procedimiento anterior para que lance una excepción usando el procedimiento RAISE_APPLICATION_ERROR. 
--      Crea un bloque anónimo para probar el procedimiento (debes capturar las posibles excepciones que lance el procedimiento).

CREATE OR REPLACE PROCEDURE p_actualizarSalario_v3 (V_DNI IN MECANICOS.DNI%TYPE, V_SALARIO IN MECANICOS.SALARIO%TYPE)
IS
    NO_EXISTE_MECANICO EXCEPTION;
    
BEGIN
    UPDATE MECANICOS
    SET SALARIO = V_SALARIO
    WHERE DNI = V_DNI;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(20001, 'no existe este mecanico');
    END IF;
    
EXCEPTION
    WHEN NO_EXISTE_MECANICO THEN
    DBMS_OUTPUT.PUT_LINE('no hay ningun mecanico con ese DNI');
    -- ahora meto el WHEN OTHERS para esa 2º excepcion de antes del tipo RAISE_APPLICATION_ERROR
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Descripcion del error: ' || SQLCODE || ': ' || SQLERRM);
    
END p_actualizarSalario_v3;

-- bloque anónimo

DECLARE 
    V_DNI1 MECANICOS.DNI%TYPE;
    V_SALARIO1 MECANICOS.SALARIO%TYPE;
    V_MECANICO MECANICO%RORTYPE;
    
BEGIN
    V_DNI1 := '&DNI';
    V_SALARIO1 := &SALARIO;
    
    p_actualizarSalario_v3(V_DNI1, V_SALARIO1);

    SELECT *
    FROM MECANICOS
    WHERE DNI = V_DNI1;
    DBMS_OUTPUT.PUT_LINE(V_MECANICO.SALARIO);
    
END;


-----------------------------------------------------------------------------------

-- 1.	Crea un procedimiento que reciba un puesto y muestre por pantalla el DNI, el nombre y el salario de todos los mecánicos de ese puesto (utiliza un bucle while). 
-- Si no existe mecánicos del puesto indicado se debe mostrar por pantalla que no existen mecánicos de con ese puesto.

CREATE OR REPLACE PROCEDURE p_recibePuesto_v10 (V_PUESTO IN MECANICOS.PUESTO%TYPE)
IS
    CURSOR c_datos IS
        SELECT * 
        FROM MECANICOS
        WHERE PUESTO = V_PUESTO;
    
    V_DATOS MECANICOS%ROWTYPE;    
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.DNI);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.SALARIO);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existen mecánicos con ese puesto');
    
END p_recibePuesto_v10;

-- bloque anónimo

DECLARE
    V_PUESTO MECANICOS.PUESTO%TYPE;
    
BEGIN
    V_PUESTO := '&PUESTO';
    
    p_recibePuesto_v10(V_PUESTO);

END;

-- 2.	Realiza las acciones que se indican a continuación:

-- a.	Actualiza el procedimiento anterior para que lance una excepción con el nombre NO_EXISTEN_MECANICOS (que hay que declarar previamente) cuando no existan mecánicos con ese puesto. 
-- Captura la excepción en el propio procedimiento y pruébalo.

CREATE OR REPLACE PROCEDURE p_recibePuesto_v11 (V_PUESTO IN MECANICOS.PUESTO%TYPE)
IS
    CURSOR c_datos IS
        SELECT * 
        FROM MECANICOS
        WHERE PUESTO = V_PUESTO;
    
    V_DATOS MECANICOS%ROWTYPE;    
    
    NO_EXISTEN_MECANICOS EXCEPTION;
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.DNI);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.SALARIO);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
    IF SQL%NOTFOUND THEN
        RAISE NO_EXISTEN_MECANICOS;
    END IF;
    
EXCEPTION
    WHEN NO_EXISTEN_MECANICOS THEN
        DBMS_OUTPUT.PUT_LINE('No existen mecánicos con ese puesto');
    
END p_recibePuesto_v11;

-- bloque anónimo
SET SERVEROUTPUT ON;

DECLARE
    V_PUESTO MECANICOS.PUESTO%TYPE; -- no me salta mensaje de excepcion
    
BEGIN
    V_PUESTO := '&PUESTO';
    
    p_recibePuesto_v11(V_PUESTO);

END;

-- b.	Ahora captura la excepción fuera del procedimiento (en el bloque anónimo desde donde pruebas) ¿Qué ocurre? ¿Por qué?

CREATE OR REPLACE PROCEDURE p_recibePuesto_v12 (V_PUESTO IN MECANICOS.PUESTO%TYPE)
IS
    CURSOR c_datos IS
        SELECT * 
        FROM MECANICOS
        WHERE PUESTO = V_PUESTO;
    
    V_DATOS MECANICOS%ROWTYPE;    
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.DNI);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.SALARIO);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
END p_recibePuesto_v12;

-- bloque anónimo

DECLARE
    V_PUESTO MECANICOS.PUESTO%TYPE;
    NO_EXISTEN_MECANICOS EXCEPTION;
    
BEGIN
    V_PUESTO := '&PUESTO';
    
    p_recibePuesto_v12(V_PUESTO);
    
    IF SQL%NOTFOUND THEN
        RAISE NO_EXISTEN_MECANICOS;
    END IF;
    
EXCEPTION
    WHEN NO_EXISTEN_MECANICOS THEN
        DBMS_OUTPUT.PUT_LINE('No hay mecanicos con ese puesto');

END;

-- c.	Utiliza ahora la directiva RAISE_APPLICATION_ERROR(-20000,'No existen mecánicos con el puesto indicado') para lazar la excepción en lugar de NO_EXISTEN_MECANICOS. 
-- Captura la excepción fuera del procedimiento usando PRAGMA EXCEPTION_INIT(no_existen_mecanicos,-20000);

CREATE OR REPLACE PROCEDURE p_recibePuesto_v13 (V_PUESTO IN MECANICOS.PUESTO%TYPE)
IS
    CURSOR c_datos IS
        SELECT * 
        FROM MECANICOS
        WHERE PUESTO = V_PUESTO;
    
    V_DATOS MECANICOS%ROWTYPE;    
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.DNI);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE(V_DATOS.SALARIO);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'No existen mecanicos con el puesto indicado');
    END IF;
    
END p_recibePuesto_v13;

-- bloque anónimo

DECLARE
    V_PUESTO MECANICOS.PUESTO%TYPE;
    
    NO_EXISTEN_MECANICOS EXCEPTION;
    PRAGMA EXCEPTION_INIT(NO_EXISTEN_MECANICOS, -20010);
    
BEGIN
    V_PUESTO := '&PUESTO';
    
    p_recibePuesto_v10(V_PUESTO);

END;

-- 3.	Crea un procedimiento que reciba una marca y muestre por pantalla los datos de los coches de esa marca (utiliza un bucle for).

CREATE OR REPLACE PROCEDURE p_recibeMarca_v10 (V_MARCA IN COCHES.MARCA%TYPE)
IS
    CURSOR c_datos IS
        SELECT *
        FROM COCHES
        WHERE MARCA = V_MARCA;
    
    V_DATOS COCHES%ROWTYPE;
    
BEGIN
    FOR V_DATOS IN c_datos LOOP
        DBMS_OUTPUT.PUT_LINE(V_DATOS.MATRICULA);
        DBMS_OUTPUT.PUT_LINE(V_DATOS.MARCA);
        DBMS_OUTPUT.PUT_LINE(V_DATOS.MODELO);
        DBMS_OUTPUT.PUT_LINE(V_DATOS.AÑO_FABRICACION);
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    
END p_recibeMarca_v10;

-- bloque anónimo

DECLARE
    V_MARCA COCHES.MARCA%TYPE;
    
BEGIN
    V_MARCA := '&MARCA';
    
    p_recibeMarca_v10(V_MARCA);
    
END;

-- 4.	Crear una función denominada HorasPorCoche que reciba la matrícula de un coche y muestre el número de horas que se ha trabajado en ese coche. 
-- Trata las excepciones que consideres oportunas.

CREATE OR REPLACE FUNCTION f_horasPorCoche_v10 (V_MATRICULA COCHES.MATRICULA%TYPE)
RETURN NUMBER

IS
    CURSOR c_datos IS
        SELECT SUM(HORAS)
        FROM TRABAJOS
        WHERE MATRICULA = V_MATRICULA;
    
    V_HORAS NUMBER;
        
BEGIN
    -- aquí pensaría que hay un FOR o un WHILE, pero pienso...
    OPEN c_datos;
        FETCH c_datos INTO V_HORAS;
    CLOSE c_datos;
    
    RETURN V_HORAS;
    
END;

-- bloque anónimo

DECLARE 
    V_MATRICULA COCHES.MATRICULA%TYPE;
    V_TOTAL_HORAS NUMBER;
    
BEGIN
    V_MATRICULA := '&MATRICULA';
    
    V_TOTAL_HORAS := f_horasPorCoche_v10 (V_MATRICULA);
   
    DBMS_OUTPUT.PUT_LINE(V_TOTAL_HORAS); 

END;

-- 5.	Crea un procedimiento que utilice la función anterior para mostrar por pantalla las horas trabajadas de todos los coches.

CREATE OR REPLACE PROCEDURE p_horasTodosLosCoches --()
IS --aqui voy a declarar un cursor que será el qu ele vaya pasando a la función las matrículas de los coches
    CURSOR c_matriculas IS
        SELECT MATRICULA
        FROM COCHES;
        
    V_MATRICULA COCHES.MATRICULA%TYPE; -- la misma variable de matricula que le pasábamos antes a la función
    V_TOTAL_HORAS NUMBER; -- la variable del total de horas donde guardábamos el resultado de la función
    
BEGIN
    OPEN c_matriculas;
        FETCH c_matriculas INTO V_MATRICULA;
            WHILE c_matriculas%FOUND LOOP
                V_TOTAL_HORAS := f_horasPorCoche_v10(V_MATRICULA);
                
                DBMS_OUTPUT.PUT_LINE(V_MATRICULA || ' ' || V_TOTAL_HORAS);
                DBMS_OUTPUT.PUT_LINE(' ');
                
                FETCH c_matriculas INTO V_MATRICULA;
            END LOOP;
    CLOSE c_matriculas;

END p_horasTodosLosCoches;

-- bloque anónimo

DECLARE 

BEGIN
    p_horasTodosLosCoches;
    
END;

-- 6.	Crea un procedimiento que muestre los puestos de los mecánicos y el número de mecánicos de cada puesto.

CREATE OR REPLACE PROCEDURE p_mostrarPuestosConMecanicos --()
IS
    V_PUESTO MECANICOS.PUESTO%TYPE;
    V_NUM_MEC NUMBER;
    
    CURSOR c_puestos IS
        SELECT DISTINCT PUESTO INTO V_PUESTO
        FROM MECANICOS
        WHERE PUESTO IS NOT NULL; -- porque precísamente hay un par vacios sin puesto
        
    CURSOR c_mecanicos IS
        SELECT COUNT(*) INTO V_NUM_MEC
        FROM MECANICOS
        WHERE PUESTO = V_PUESTO; --para que vaya fijándose en un mismo puesto para cada COUNT
        
BEGIN
    OPEN c_puestos;
        FETCH c_puestos INTO V_PUESTO;
            WHILE c_puestos%FOUND LOOP --mientras que siga habiendo un puesto...
                OPEN c_mecanicos;
                    FETCH c_mecanicos INTO V_NUM_MEC;
                        DBMS_OUTPUT.PUT_LINE(V_PUESTO || ' ' || V_NUM_MEC);
                        DBMS_OUTPUT.PUT_LINE(' ');
                    FETCH c_puestos INTO V_PUESTO;
                    --importante NO poner aquí el FETCH final de c_mecanicos
                CLOSE c_mecanicos;
            END LOOP;
    CLOSE c_puestos;

END p_mostrarPuestosConMecanicos;

-- bloque anónimo

DECLARE

BEGIN
    p_mostrarPuestosConMecanicos;
    
END;

---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 1.	Crea un procedimiento que actualice el ganador del premio de un puerto.

CREATE OR REPLACE PROCEDURE p_actualizarGanador_v10(V_NOMPUERTO IN PUERTO.NOMPUERTO%TYPE ,V_DORSAL IN PUERTO.DORSAL%TYPE)
IS
    
BEGIN
    UPDATE PUERTO
    SET DORSAL = V_DORSAL
    WHERE NOMPUERTO = V_NOMPUERTO;
    
    DBMS_OUTPUT.PUT_LINE('Se ha actualizado el ganador de este puerto');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se ha encontrado ningún puerto con ese nombre');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay más de un puerto con este mismo nombre');
    
END p_actualizarGanador_v10;

-- bloque anónimo

DECLARE 
    V_NOMPUERTO PUERTO.NOMPUERTO%TYPE;
    V_DORSAL PUERTO.DORSAL%TYPE;
    
BEGIN
    V_NOMPUERTO := '&PUERTO';
    V_DORSAL := '&DORSAL';
    
    p_actualizarGanador_v10(V_NOMPUERTO, V_DORSAL);

END;

-- 2.	Crea un procedimiento que enumere los puertos con una pendiente mayor que 6. Utiliza ambos tipos de cursor explícito. FOR/WHILE

CREATE OR REPLACE PROCEDURE p_pendienteMayor_v10

IS
    CURSOR c_datos IS
        SELECT NOMPUERTO 
        FROM PUERTO
        WHERE PENDIENTE > 6;

    V_PUERTOS PUERTO.NOMPUERTO%TYPE;
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_PUERTOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_PUERTOS);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_PUERTOS;
            END LOOP;
    CLOSE c_datos;
                
END p_pendienteMayor_v10;

---------------------- ahora con el FOR -------------------

CREATE OR REPLACE PROCEDURE p_pendienteMayor_v11

IS
    CURSOR c_datos IS
        SELECT * 
        FROM PUERTO
        WHERE PENDIENTE > 6;

    V_PUERTOS PUERTO%ROWTYPE;
    
BEGIN
    FOR V_PUERTOS IN c_datos LOOP
        DBMS_OUTPUT.PUT_LINE(V_PUERTOS.NOMPUERTO);
        DBMS_OUTPUT.PUT_LINE(V_PUERTOS.PENDIENTE);
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
                
END p_pendienteMayor_v11;

-- blque anónimo

DECLARE 
    
BEGIN
    p_pendienteMayor_v11;
    
END;

-- 3.	Crea una función que acepte el nombre del puerto y devuelva la pendiente del mismo. 
-- Si la pendiente es superior a 7, debe lanzarse una excepción de usuario.

CREATE OR REPLACE FUNCTION f_recibeNombrePuerto(V_NOMPUERTO IN PUERTO.NOMPUERTO%TYPE)
RETURN PUERTO.PENDIENTE%TYPE

IS
    V_PENDIENTE PUERTO.PENDIENTE%TYPE;
    PENDIENTE_MAYOR EXCEPTION;

BEGIN
    SELECT PENDIENTE INTO V_PENDIENTE
    FROM PUERTO
    WHERE NOMPUERTO = V_NOMPUERTO;

    IF V_PENDIENTE > 7 THEN
        RAISE PENDIENTE_MAYOR;
        RETURN 0;
    END IF;

    RETURN V_PENDIENTE;
    
EXCEPTION
    WHEN PENDIENTE_MAYOR THEN
        DBMS_OUTPUT.PUT_LINE('Este puerto tiene una pendiente mayor que 7');

END;

-- bloque anónimo

DECLARE
    V_NOMPUERTO PUERTO.NOMPUERTO%TYPE;
    V_PENDIENTE PUERTO.PENDIENTE%TYPE;
    
BEGIN
    V_NOMPUERTO := '&PUERTO';
    V_PENDIENTE := f_recibeNombrePuerto(V_NOMPUERTO);
    
    DBMS_OUTPUT.PUT_LINE(V_NOMPUERTO || ' ' || V_PENDIENTE);
    
END;

-- 4.	Crea un procedimiento que acepte una categoría de puerto y liste todos los puertos de esa categoría. 
-- Utiliza ambos tipos de cursor explícito.

CREATE OR REPLACE PROCEDURE p_puertosCategoria_v10(V_CATEGORIA IN PUERTO.CATEGORIA%TYPE)
IS
    CURSOR c_datos IS
        SELECT *
        FROM PUERTO
        WHERE CATEGORIA = V_CATEGORIA;
        
    V_DATOS PUERTO%ROWTYPE;
    
BEGIN
    OPEN c_datos;
        FETCH c_datos INTO V_DATOS;
            WHILE c_datos%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMPUERTO || ' ' || V_DATOS.CATEGORIA);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos INTO V_DATOS;
            END LOOP;
    CLOSE c_datos;
    
END p_puertosCategoria_v10;

---------------------------- ahora con FOR --------------------------

CREATE OR REPLACE PROCEDURE p_puertosCategoria_v11(V_CATEGORIA IN PUERTO.CATEGORIA%TYPE)
IS
    CURSOR c_datos IS
        SELECT *
        FROM PUERTO
        WHERE CATEGORIA = V_CATEGORIA;
        
    V_DATOS PUERTO%ROWTYPE;
    
BEGIN
    FOR V_DATOS IN c_datos LOOP
        DBMS_OUTPUT.PUT_LINE(V_DATOS.NOMPUERTO || ' ' || V_DATOS.CATEGORIA);
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    
END p_puertosCategoria_v11;

-- bloque anónimo

DECLARE 
    V_CATEGORIA PUERTO.CATEGORIA%TYPE;
    
BEGIN
    V_CATEGORIA := '&CATEGORIA';
    
    p_puertosCategoria_v11(V_CATEGORIA);
    
END;

-- 4. (ABUSIVE VERSION)	Crea un procedimiento que liste todas las categoriaso y de cada una de ellas, 
-- que liste todos los puertos de esa categoría. 

CREATE OR REPLACE PROCEDURE p_listarCategoriasConPuertos_v10
IS
    CURSOR c_datos2 IS
        SELECT CATEGORIA
        FROM PUERTO;
        
    V_CATEGORIA PUERTO.CATEGORIA%TYPE;
    
BEGIN
    OPEN c_datos2;
        FETCH c_datos2 INTO V_CATEGORIA;
            WHILE c_datos2%FOUND LOOP
                p_puertosCategoria_v10(V_CATEGORIA);
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c_datos2 INTO V_CATEGORIA;
            END LOOP;
    CLOSE c_datos2;
    
END p_listarCategoriasConPuertos_v10;
    
-- bloque anónimo

DECLARE

BEGIN
    p_listarCategoriasConPuertos_v10;

END;

-- 5.	Crea una función que acepte un número de dorsal y retorne la cantidad de puertos que ha ganado. 
-- Si ha ganado más de 1 puerto, lanzar la excepción “experto”.

CREATE OR REPLACE FUNCTION f_puertosGanados_v10(V_DORSAL IN PUERTO.DORSAL%TYPE)
RETURN NUMBER

IS
    V_VICTORIAS NUMBER;
    EXPERTO EXCEPTION;
    
BEGIN
    SELECT COUNT(*) INTO V_VICTORIAS
    FROM PUERTO
    WHERE DORSAL = V_DORSAL;
    
    IF V_VICTORIAS > 1 THEN
        RETURN V_VICTORIAS;
        RAISE EXPERTO;
    END IF;
    
    RETURN V_VICTORIAS;
    
EXCEPTION
    WHEN EXPERTO THEN
        DBMS_OUTPUT.PUT_LINE('Este ciclista ha ganado más de un puerto... es todo un experto!');
    
END;

-- bloque anónimo

DECLARE 
    V_VICTORIAS NUMBER;
    V_DORSAL PUERTO.DORSAL%TYPE;
    
BEGIN
    V_DORSAL := '&DORSAL';
    
    V_VICTORIAS := f_puertosGanados_v10(V_DORSAL);
    
    DBMS_OUTPUT.PUT_LINE('El dorsal ' || V_DORSAL || ' tiene ' || V_VICTORIAS || ' victorias');
    
END;

-- 6.	Crea un procedimiento que acepte un número de etapa y una cantidad de kilómetros y actualice los datos de la etapa. 
-- Además debe devolver (dato de salida) el dorsal del ciclista que la ganó.

CREATE OR REPLACE PROCEDURE p_actualizarEtapa_v10(V_NETAPA IN ETAPA.NETAPA%TYPE, V_KM IN ETAPA.KM%TYPE, V_DORSAL OUT ETAPA.DORSAL%TYPE)
IS
    
BEGIN
    UPDATE ETAPA
    SET KM = V_KM
    WHERE NETAPA = V_NETAPA;
    
    SELECT DORSAL INTO V_DORSAL
    FROM ETAPA
    WHERE NETAPA = V_NETAPA;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay etapas con ese número');
    
END p_actualizarEtapa_v10;

-- bloque anónimo

DECLARE
    V_NETAPA ETAPA.NETAPA%TYPE;
    V_KM ETAPA.KM%TYPE;
    V_DORSAL ETAPA.DORSAL%TYPE;
    
BEGIN
    V_NETAPA := '&ETAPA';
    V_KM := '&KMs';
    
    p_actualizarEtapa_v10(V_NETAPA, V_KM, V_DORSAL);
    
    DBMS_OUTPUT.PUT_LINE('y el ganador de la etapa ' || V_NETAPA || ' fue el dorsal ' || V_DORSAL);
    
END;

-- 7.	Crea un procedimiento que acepte un nombre de equipo y un nombre de director y añada éste a la tabla de equipos.

CREATE OR REPLACE PROCEDURE p_añadirDirector_v10(V_EQUIPO IN EQUIPO.NOMEQ%TYPE, V_DIRECTOR EQUIPO.DESCRIPCION%TYPE)
IS

BEGIN
    INSERT INTO EQUIPO (NOMEQ, DESCRIPCION)
    VALUES (V_EQUIPO, V_DIRECTOR);
    
END p_añadirDirector_v10;

-- Bloque anónimo

DECLARE
    V_EQUIPO EQUIPO.NOMEQ%TYPE;
    V_DIRECTOR EQUIPO.DESCRIPCION%TYPE;
    
BEGIN
    V_EQUIPO := '&EQUIPO';
    V_DIRECTOR := '&DIRECTOR';
    
    p_añadirDirector_v10(V_EQUIPO, V_DIRECTOR);
    
END;

-- 8.	Crea una función que acepte un nombre de equipo y devuelva la cantidad de integrantes del equipo. 
-- En el caso de haber menos de 5 ciclistas, lanzar una excepción de usuario sin nombre que será recogida en el bloque anónimo.

CREATE OR REPLACE FUNCTION f_cantidadCiclistasEquipo_10(V_EQUIPO IN CICLISTA.NOMEQ%TYPE)
RETURN NUMBER
IS
    V_CICLISTAS NUMBER;
    POCOS_CICLISTAS EXCEPTION;
    
BEGIN
    SELECT COUNT(*) INTO V_CICLISTAS
    FROM CICLISTA
    WHERE NOMEQ = V_EQUIPO;
    
    IF V_CICLISTAS < 5 THEN
        RAISE POCOS_CICLISTAS;
    END IF;
    
    RETURN V_CICLISTAS;
    
EXCEPTION
    WHEN POCOS_CICLISTAS THEN
        DBMS_OUTPUT.PUT_LINE('Este equipo tiene menos de 5 ciclistas');
    
END f_cantidadCiclistasEquipo_10;

-- bloque anónimo

DECLARE 
    V_EQUIPO CICLISTA.NOMEQ%TYPE;
    V_CICLISTAS NUMBER;
    
BEGIN
    V_EQUIPO := '&EQUIPO';
    
    V_CICLISTAS := f_cantidadCiclistasEquipo_10(V_EQUIPO);
    
    DBMS_OUTPUT.PUT_LINE(V_CICLISTAS);
    
END;