-----------------------------------------------------------------------------------------
--PARA AZAFATA
DROP SEQUENCE azafata_seq;
CREATE SEQUENCE azafata_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE AZAFATA_CRUD AS
    TYPE azafata_type IS RECORD 
    (
        persona_id            azafata.persona_id%TYPE,
        azafata_id            azafata.azafata_id%TYPE,
        vuelos_abordados      azafata.vuelos_abordados%TYPE,
        idioma_natal          azafata.idioma_natal%TYPE,
        idioma_secundario     azafata.idioma_secundario%TYPE,
        mostrar               azafata.mostrar%TYPE
    );
    
    FUNCTION crear_azafata(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_azafata_info IN azafata_type
    )RETURN BOOLEAN;
    
    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_azafata_info OUT azafata_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    );
    
    PROCEDURE leer_azafatas(
        p_azafatas OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN NUMBER
    ) RETURN BOOLEAN;
    
    PROCEDURE leer_azafatas_por_vuelo(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafatas OUT SYS_REFCURSOR
    );
    
    FUNCTION eliminar_se_asigna(
        p_vuelo_id vuelo.vuelo_id%TYPE,
        p_azafata_id azafata.azafata_id%TYPE
    )RETURN BOOLEAN;
    
     FUNCTION asignar_azafata(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN;
    
END AZAFATA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY AZAFATA_CRUD AS
    FUNCTION crear_azafata(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_azafata_info IN azafata_type
    )
    RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_insert_azafata VARCHAR2(30) := 'BEFORE_INSERT_AZAFATA';
    BEGIN
        SAVEPOINT v_before_insert_azafata;
        v_persona_id := PERSONA_CRUD.crear_persona(p_persona_info);
        INSERT INTO azafata (persona_id, azafata_id, vuelos_abordados, idioma_natal, idioma_secundario, mostrar)
        VALUES (
            v_persona_id, 
            azafata_seq.NEXTVAL, 
            p_azafata_info.vuelos_abordados, 
            p_azafata_info.idioma_natal,
            p_azafata_info.idioma_secundario,
            1);
            
        COMMIT;
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_azafata;
        RAISE;
    END;

    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_azafata_info OUT azafata_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    ) IS
    BEGIN
        SELECT 
            p.persona_id,
            p.genero_id,
            p.numero_identificacion,
            p.nombre,
            p.apellido,
            p.fecha_nac,
            p.pais_nac,
            p.ciudad_nac,
            a.persona_id,
            a.azafata_id,
            a.vuelos_abordados,
            a.idioma_natal,
            a.idioma_secundario,
            a.mostrar
        INTO 
            p_persona_info.persona_id, 
            p_persona_info.genero_id,
            p_persona_info.numero_identificacion,
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            p_azafata_info.persona_id,
            p_azafata_info.azafata_id,
            p_azafata_info.vuelos_abordados,
            p_azafata_info.idioma_natal,
            p_azafata_info.idioma_secundario,
            p_azafata_info.mostrar
        FROM azafata a 
        INNER JOIN persona p
        ON a.persona_id = p.persona_id
        WHERE a.azafata_id = p_azafata_id
        AND a.mostrar = 1 
        AND p.mostrar = 1;
    END leer_azafata;
    
    PROCEDURE leer_azafatas(
        p_azafatas OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    )IS
    BEGIN
        OPEN p_azafatas FOR
        SELECT *
        FROM (
            SELECT 
                p.persona_id,
                p.genero_id,
                p.numero_identificacion,
                p.nombre,
                p.apellido,
                p.fecha_nac,
                p.pais_nac,
                p.ciudad_nac,
                a.azafata_id,
                a.vuelos_abordados,
                a.idioma_natal,
                a.idioma_secundario,
                a.mostrar,
                ROW_NUMBER() OVER (ORDER BY p.persona_id) AS rn
            FROM azafata a 
            INNER JOIN persona p
            ON a.persona_id = p.persona_id
            AND a.mostrar = 1 
            AND p.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END leer_azafatas;
    
    FUNCTION eliminar_azafata(p_azafata_id IN NUMBER)
        RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AZAFATA 
        SET MOSTRAR = 0
        WHERE AZAFATA_ID = p_azafata_id;
        COMMIT;
        RETURN TRUE;    
    END;
    
    PROCEDURE leer_azafatas_por_vuelo(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafatas OUT SYS_REFCURSOR
    )IS
    BEGIN
        OPEN p_azafatas FOR 
            SELECT * 
            FROM azafata a
            INNER JOIN se_asigna sa
            ON a.azafata_id = sa.azafata_id
            INNER JOIN persona p
            ON p.persona_id = a.persona_id
            WHERE sa.vuelo_id = p_vuelo_id
            AND a.mostrar = 1;
    END;
    
    FUNCTION eliminar_se_asigna(
        p_vuelo_id vuelo.vuelo_id%TYPE,
        p_azafata_id azafata.azafata_id%TYPE
    )RETURN BOOLEAN
    IS
    BEGIN
        DELETE 
        FROM se_asigna sa
        WHERE sa.vuelo_id = p_vuelo_id 
        AND sa.azafata_id = p_azafata_id;
        COMMIT;
        RETURN TRUE;
    END;
    
    FUNCTION asignar_azafata(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafata_id IN azafata.azafata_id%TYPE
    )
    RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO se_asigna (azafata_id, vuelo_id, mostrar)
        VALUES (p_azafata_id, p_vuelo_id, 1);
        COMMIT;
        RETURN TRUE;
    END asignar_azafata;
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_delete_azafata VARCHAR2(30) := 'BEFORE_DELETE_AZAFATA';
        v_res BOOLEAN := false;
    BEGIN
        SELECT a.persona_id
        INTO v_persona_id
        FROM azafata a
        WHERE a.azafata_id = p_azafata_id;
    
        SAVEPOINT v_before_delete_azafata;
        
        UPDATE azafata a
        SET a.mostrar = 0
        WHERE a.azafata_id = p_azafata_id;
        
        res := persona_crud.eliminar_persona(v_persona_id);
        IF res THEN
            COMMIT;
            RETURN TRUE;
        ELSE
            RAISE delete_error;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_azafata;
        RAISE;
    END;
END AZAFATA_CRUD;
/
