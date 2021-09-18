
-- 1.	Procedimiento al que se le pasarán dos números y visualice si uno es divisor de otro 
-- (se utilizará la función MOD(dividendo,divisor) que da el resto de dividir el primer número entre el segundo).

SET SERVEROUT ON;

DECLARE
    V_NUM1 NUMBER(5);
    V_NUM2 NUMBER(5);
    V_RESULTADO NUMBER(5);
    
BEGIN
    V_NUM1 := &Introduce_el_primer_número; --OJO al pedir las cosas, que si pido un número, nada de frases con espacios en las palabras, una sola cadena (sin comillas)
    V_NUM2 := &Introduce_el_segundo_número;
    
    V_RESULTADO := MOD(V_NUM1,V_NUM2); 
    
    IF V_RESULTADO = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Si son divisibles');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('No son divisibles');
        
    END IF;
END;


-- 2.	Visualizar la tabla de multiplicar de un número entre 1 y 10 introducido por teclado.

SET SERVEROUT ON;

DECLARE
    V_NUM NUMBER; -- no hace falta especificar el tamaño
    V_RESULTADO NUMBER; --mejor smp guardar el resultado en una variable resultado
    --V_MULTIPLICADOR NUMBER(5);
    
BEGIN
    V_NUM := &Introduzca_un_número;
    --V_MULTIPLICADOR := V_NUM;
    
    FOR i IN 1..10 LOOP
        V_RESULTADO := V_NUM * i;
        --V_MULTIPLICADOR ++;
        
        DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
    
    END LOOP;

END;

-- 3.	Obtener las tablas de multiplicar de los números del 1 al 10.

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
    i NUMBER;
    j NUMBER;
    
BEGIN
    FOR i IN 1..10 LOOP
        FOR j IN 1..10 LOOP
        V_RESULTADO := i * j;
    
        DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
        END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
    
-- 4.	Calcular la suma de los números del 1 al 100.

SET SERVEROUTPUT ON;

DECLARE
    V_SUMA NUMBER(5) := 0; 

BEGIN
    FOR i in 1..100 LOOP
        V_SUMA := V_SUMA+i;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(V_SUMA);

END;

-- 5.	Calcular el producto de los números del 1 al 100.

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER := 1; 

BEGIN
    FOR i IN 1..100 LOOP
        V_RESULTADO := V_RESULTADO * i;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(V_RESULTADO); -- el numero es demasiado largo para mostrarlo

END;

-- 6.	Imprimir los múltiplos de 3 hasta N, siendo N un valor introducido por teclado.

DECLARE
    V_MULTI3 NUMBER := 3;
    V_RESULTADO NUMBER;
    V_LIMITE NUMBER;

BEGIN
    V_LIMITE := &Intruzca_el_número_límite;
    
    FOR i IN 1..V_LIMITE LOOP
        V_RESULTADO := V_MULTI3 * i;
        DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
    END LOOP;
    
END;

-- 7.	Visualizar el factorial de un número que se pide por teclado.

SET SERVEROUTPUT ON;

DECLARE
    V_NUM NUMBER;
    V_RESULTADO NUMBER := 1;
  
BEGIN         
    V_NUM := &Introduce_Un_Numero_Para_saber_Su_Factorial;   
    
    FOR i IN REVERSE 1..V_NUM LOOP
        V_RESULTADO := V_RESULTADO * i;
      
    END LOOP;
    dbms_output.put_line(V_RESULTADO);
END;

-- 8.	Visualizar los factoriales de los números del 1 al 10.

SET SERVEROUTPUT ON;

DECLARE
    V_NUM NUMBER := 1;
    V_RESULTADO NUMBER := 1;
    
BEGIN 
    FOR i IN 1..10 LOOP
        FOR j IN REVERSE 1..V_NUM LOOP
        
        V_RESULTADO := V_RESULTADO * i;
        
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
        
    END LOOP;
    
END;


-- 9.	Visualizar la suma de todos los números existentes entre dos introducidos por teclado.

SET SERVEROUTPUT ON;

DECLARE 
    V_NUM1 NUMBER;
    V_NUM2 NUMBER;
    V_RESULTADO NUMBER := 0;
    
BEGIN
    V_NUM1 := &Introduzca_el_1º_número;
    V_NUM2 := &Introduzca_el_2º_número;
    
    FOR i IN V_NUM1..V_NUM2 LOOP
        V_RESULTADO := V_RESULTADO + i;  
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
    
END;

