-- añadir contacto

CREATE OR REPLACE PROCEDURE p_añadirContacto(
    dato1 IN MECANICOS.DNI%TYPE,
    dato2 IN MECANICOS.APELLIDOS%TYPE,
    dato3 IN MECANICOS.NOMBRE%TYPE,
    dato4 IN MECANICOS.PUESTO%TYPE,
    dato5 IN MECANICOS.SALARIO%TYPE,
    dato6 IN MECANICOS.PARCIAL%TYPE,
    dato7 IN MECANICOS.TELEFONO%TYPE
)
IS

BEGIN
    INSERT INTO MECANICOS VALUES (
    dato1,
    dato2,
    dato3,
    dato4,
    dato5,
    dato6,
    dato7
);

END p_añadirContacto;


CREATE OR REPLACE PROCEDURE p_eliminarContacto(V_DNI MECANICOS.DNI%TYPE)
IS

BEGIN
    DELETE FROM MECANICOS
    WHERE DNI = V_DNI;

END p_eliminarContacto;

CREATE OR REPLACE PROCEDURE p_modificarTelefono(V_TELEFONO IN MECANICOS.TELEFONO%TYPE, V_NEW_TELEFONO MECANICOS.TELEFONO%TYPE)
IS

BEGIN
    UPDATE MECANICOS
    SET TELEFONO = V_NEW_TELEFONO
    WHERE TELEFONO = V_TELEFONO;
    
END p_modificarTelefono;

-- bloque anónimo

DECLARE
    V_OPCION NUMBER;
    V_DNI1 MECANICOS.DNI%TYPE;
    V_APELLIDOS1 MECANICOS.APELLIDOS%TYPE;
    V_NOMBRE1 MECANICOS.NOMBRE%TYPE;
    V_PUESTO1 MECANICOS.PUESTO%TYPE;
    V_SALARIO1 MECANICOS.SALARIO%TYPE;
    V_PARCIAL1 MECANICOS.PARCIAL%TYPE;
    V_TELEFONO1 MECANICOS.TELEFONO%TYPE;
    
    V_DNI MECANICOS.DNI%TYPE;
    V_TLFN MECANICOS.TELEFONO%TYPE;
    V_NEW_TLFN MECANICOS.TELEFONO%TYPE;
    
BEGIN
    OPCION := '&OPCION';
    
    CASE 
        WHEN OPCION = '1' THEN
            dato1 := '&DNI';
            dato2 := '&APELLIDOS';
            dato3 := '&NOMBRE';
            dato4 := '&PUESTO';
            dato5 := '&SALARIO';
            dato6 := '&PARCIAL';
            dato7 := '&TELEFONO';
            p_añadirContacto(dato1, dato2, dato3, dato4, dato5, dato6, dato7);
    
        WHEN OPCION = '2' THEN
            V_TLFN := '&BUSCAR_TLFN';
            V_NEW_TLFN := '&NEW_TLFN';
            p_modificarTelefono(V_TLFN, V_NEW_TLFN);
        
        WHEN OPCION = '3' THEN
            V_DNI := '&DNI';
            p_eliminarContacto(V_DNI);
            
        END CASE;        
END;