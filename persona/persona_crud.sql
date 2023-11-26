--PARA PERSONA:
CREATE SEQUENCE persona_seq
    START WITH 15
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE PERSONA_CRUD AS
    TYPE tipo_persona IS RECORD 
    (
       persona_id           persona.persona_id%TYPE,
       genero_id            persona.genero_id%TYPE,
       numero_identificacion persona.numero_identificacion%TYPE,
       nombre               persona.nombre%TYPE,
       apellido             persona.apellido%TYPE,
       fecha_nac            persona.fecha_nac%TYPE,
       pais_nac             persona.pais_nac%TYPE,
       ciudad_nac           persona.ciudad_nac%TYPE,
       mostrar              persona.mostrar%TYPE
    );

    FUNCTION crear_persona(
        p_persona_info tipo_persona
    ) RETURN BOOLEAN;

    FUNCTION actualizar_persona(
        p_persona_id IN NUMBER,
        p_persona_info tipo_persona
    )RETURN BOOLEAN;

    FUNCTION eliminar_persona(
        p_persona_id IN NUMBER
    )RETURN BOOLEAN;
END PERSONA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY PERSONA_CRUD AS
    PROCEDURE crear_persona(
        p_genero_id IN NUMBER,
        p_numero_identificacion IN NUMBER,
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2,
        p_fecha_nac IN DATE,
        p_pais_nac IN VARCHAR2,
        p_ciudad_nac IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
        VALUES (persona_seq.NEXTVAL, p_genero_id, p_numero_identificacion, p_nombre, p_apellido, p_fecha_nac, p_pais_nac, p_ciudad_nac);
    END crear_persona;
    
    PROCEDURE leer_persona(
        p_persona_id IN NUMBER,
        p_info OUT persona%ROWTYPE
    ) IS
    BEGIN
        SELECT *
        INTO p_info
        FROM PERSONA 
        WHERE PERSONA_ID = p_persona_id;
    END leer_persona;

    PROCEDURE actualizar_persona(
        p_persona_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2
    ) IS
    BEGIN
        UPDATE PERSONA
        SET NOMBRE = p_nombre, APELLIDO = p_apellido
        WHERE PERSONA_ID = p_persona_id;
    END actualizar_persona;

    PROCEDURE eliminar_persona(
        p_persona_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM PERSONA
        WHERE PERSONA_ID = p_persona_id;
    END eliminar_persona;
END PERSONA_CRUD;
/