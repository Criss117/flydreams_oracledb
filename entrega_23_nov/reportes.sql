-------------------------PARA PILOTO:
CREATE OR REPLACE PACKAGE PILOTO_REPORTES AS
    PROCEDURE informacion_licencia_piloto(
        p_piloto_id IN NUMBER,
        p_licencia_info OUT SYS_REFCURSOR
    );
END PILOTO_REPORTES;
/

CREATE OR REPLACE PACKAGE BODY PILOTO_REPORTES AS
    PROCEDURE informacion_licencia_piloto(
        --p_piloto_id IN NUMBER,
        p_licencia_info OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_licencia_info FOR
        SELECT licencia_id, vuelos, emision_licencia, vencimiento_licencia
        FROM piloto
        WHERE piloto_id = p_piloto_id;
    END informacion_licencia_piloto;
END PILOTO_REPORTES;
/
--------------------------PARA LA TABLA DE PERSONA
CREATE OR REPLACE PACKAGE PERSONA_REPORTES AS
    PROCEDURE informacion_completa_persona(
        p_persona_id IN NUMBER,
        p_info OUT persona%ROWTYPE
    );
END PERSONA_REPORTES;
/

CREATE OR REPLACE PACKAGE BODY PERSONA_REPORTES AS
    PROCEDURE informacion_completa_persona(
        p_persona_id IN NUMBER,
        p_info OUT persona%ROWTYPE
    ) IS
    BEGIN
        SELECT *
        INTO p_info
        FROM persona
        WHERE persona_id = p_persona_id;
        EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para la persona con ID ' || p_persona_id);         
    END informacion_completa_persona;
END PERSONA_REPORTES;
/
------------------------EJECUCION:
SET SERVEROUTPUT ON
DECLARE
    v_piloto_id NUMBER := 1; -- Coloca el ID del piloto que quieres consultar
    v_licencia_info SYS_REFCURSOR;
    
    -- Variables para almacenar los resultados
    v_licencia_id piloto.licencia_id%TYPE;
    v_vuelos piloto.vuelos%TYPE;
    v_emision_licencia piloto.emision_licencia%TYPE;
    v_vencimiento_licencia piloto.vencimiento_licencia%TYPE;
BEGIN
    -- Llamada al procedimiento
    PILOTO_REPORTES.informacion_licencia_piloto(v_piloto_id, p_licencia_info => v_licencia_info);

    -- Mostrar los resultados
    LOOP
        FETCH v_licencia_info INTO v_licencia_id, v_vuelos, v_emision_licencia, v_vencimiento_licencia;
        EXIT WHEN v_licencia_info%NOTFOUND;
        -- Imprimir o manipular los resultados según sea necesario
        DBMS_OUTPUT.PUT_LINE('Licencia ID: ' || v_licencia_id);
        DBMS_OUTPUT.PUT_LINE('Número de vuelos: ' || v_vuelos);
        DBMS_OUTPUT.PUT_LINE('Emisión de licencia: ' || TO_CHAR(v_emision_licencia, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Vencimiento de licencia: ' || TO_CHAR(v_vencimiento_licencia, 'DD-MM-YYYY'));
    END LOOP;

    -- Cerrar el cursor después de usarlo
    CLOSE v_licencia_info;
END;
----------------------prueba paquete persona:
DECLARE
    v_persona_id NUMBER := 1; -- Coloca el ID de la persona que quieres consultar
    v_info_persona persona%ROWTYPE;
BEGIN
    -- Llamada al procedimiento
    PERSONA_REPORTES.informacion_completa_persona(v_persona_id, v_info_persona);
    -- Imprimir o manipular los resultados según sea necesario
    DBMS_OUTPUT.PUT_LINE('Persona ID: ' || v_info_persona.persona_id);
    DBMS_OUTPUT.PUT_LINE('Género ID: ' || v_info_persona.genero_id);
    DBMS_OUTPUT.PUT_LINE('Número de Identificación: ' || v_info_persona.numero_identificacion);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_info_persona.nombre);
    DBMS_OUTPUT.PUT_LINE('Apellido: ' || v_info_persona.apellido);
    DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento: ' || TO_CHAR(v_info_persona.fecha_nac, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('País de Nacimiento: ' || v_info_persona.pais_nac);
    DBMS_OUTPUT.PUT_LINE('Ciudad de Nacimiento: ' || v_info_persona.ciudad_nac);
END;
/