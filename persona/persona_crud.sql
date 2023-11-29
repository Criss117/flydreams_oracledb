--PARA PERSONA:
DROP SEQUENCE persona_seq;
CREATE SEQUENCE persona_seq
    START WITH 15
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE PERSONA_CRUD AS
    TYPE persona_type IS RECORD 
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
        p_persona_info persona_type
    ) RETURN NUMBER;
    
    FUNCTION eliminar_persona(
        p_persona_id persona.persona_id%TYPE
    )RETURN BOOLEAN;
END PERSONA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY PERSONA_CRUD AS
    FUNCTION crear_persona(
        p_persona_info persona_type
    ) 
    RETURN NUMBER
    IS
        v_persona_id persona.persona_id%TYPE := persona_seq.NEXTVAL;
    BEGIN
        SAVEPOINT v_before_insert_persona;
        INSERT INTO persona (persona_id, genero_id, numero_identificacion, nombre, apellido, fecha_nac, pais_nac, ciudad_nac, mostrar)
        VALUES (
            v_persona_id, 
            p_persona_info.genero_id, 
            p_persona_info.numero_identificacion, 
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            1);
        RETURN v_persona_id;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_persona;
        RAISE;
    END crear_persona;
    
     FUNCTION eliminar_persona(
        p_persona_id persona.persona_id%TYPE
    )RETURN BOOLEAN
    IS
    BEGIN
        SAVEPOINT v_before_delete_persona;
        UPDATE persona p 
        SET p.mostrar = 0
        WHERE p.persona_id = p_persona_id;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_persona;
        RAISE;
    END;
END PERSONA_CRUD;
/