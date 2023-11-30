-- PARA PILOTO
DROP SEQUENCE piloto_seq;
CREATE SEQUENCE piloto_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/

CREATE OR REPLACE PACKAGE PILOTO_CRUD AS
    TYPE piloto_type IS RECORD 
    (
        persona_id           piloto.persona_id%TYPE,
        piloto_id            piloto.piloto_id%TYPE,
        licencia_id          piloto.licencia_id%TYPE,
        vuelos               piloto.vuelos%TYPE,
        emision_licencia     piloto.emision_licencia%TYPE,
        vencimiento_licencia piloto.vencimiento_licencia%TYPE,
        mostrar              piloto.mostrar%TYPE,
        licencia             tipo_licencia.licencia%TYPE
    );

    FUNCTION crear_piloto(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_piloto_info IN piloto_type
    ) RETURN BOOLEAN;
    
    PROCEDURE leer_piloto(
        p_piloto_id IN NUMBER,
        p_piloto_info OUT piloto_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    );
    
    PROCEDURE leer_pilotos(
        p_pilotos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );
    
    FUNCTION eliminar_piloto(
        p_piloto_id IN NUMBER
    ) RETURN BOOLEAN;
    
    FUNCTION asignar_piloto(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_piloto_id IN piloto.piloto_id%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION eliminar_piloto(
        p_piloto_id IN piloto.piloto_id%TYPE
    ) RETURN BOOLEAN;
END PILOTO_CRUD;
/

CREATE OR REPLACE PACKAGE BODY PILOTO_CRUD AS
    FUNCTION crear_piloto(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_piloto_info IN piloto_type
    )
    RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_insert_piloto VARCHAR2(30) := 'BEFORE_INSERT_PILOTO';
    BEGIN
        SAVEPOINT v_before_insert_piloto;
        v_persona_id := PERSONA_CRUD.crear_persona(p_persona_info);
        INSERT INTO piloto (persona_id, piloto_id, licencia_id, vuelos, emision_licencia, vencimiento_licencia, mostrar)
        VALUES (
            v_persona_id, 
            piloto_seq.NEXTVAL,
            p_piloto_info.licencia_id,
            p_piloto_info.vuelos, 
            p_piloto_info.emision_licencia,
            p_piloto_info.vencimiento_licencia,
            1);
            
        COMMIT;
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_piloto;
        RAISE;
    END crear_piloto;

    PROCEDURE leer_piloto(
        p_piloto_id IN NUMBER,
        p_piloto_info OUT piloto_type,
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
            pi.persona_id,
            pi.piloto_id,
            pi.licencia_id,
            pi.vuelos,
            pi.emision_licencia,
            pi.vencimiento_licencia,
            pi.mostrar,
            tl.licencia
        INTO 
            p_persona_info.persona_id, 
            p_persona_info.genero_id,
            p_persona_info.numero_identificacion,
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            p_piloto_info.persona_id,
            p_piloto_info.piloto_id,
            p_piloto_info.licencia_id,
            p_piloto_info.vuelos,
            p_piloto_info.emision_licencia,
            p_piloto_info.vencimiento_licencia,
            p_piloto_info.mostrar,
            p_piloto_info.licencia
        FROM piloto pi
        INNER JOIN persona p
        ON pi.persona_id = p.persona_id
        INNER JOIN tipo_licencia tl
        ON tl.licencia_id = pi.licencia_id
        WHERE pi.piloto_id = p_piloto_id
        AND pi.mostrar = 1 
        AND p.mostrar = 1;
    END leer_piloto;
    
    PROCEDURE leer_pilotos(
        p_pilotos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    )IS
    BEGIN
        OPEN p_pilotos FOR
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
                pi.piloto_id,
                pi.licencia_id,
                pi.vuelos,
                pi.emision_licencia,
                pi.vencimiento_licencia,
                pi.mostrar,
                tl.licencia,
                ROW_NUMBER() OVER (ORDER BY p.persona_id) AS rn
            FROM piloto pi 
            INNER JOIN persona p
            ON pi.persona_id = p.persona_id
            INNER JOIN tipo_licencia tl
            ON pi.licencia_id = tl.licencia_id
            AND pi.mostrar = 1 
            AND p.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END leer_pilotos;
    
    FUNCTION eliminar_piloto(p_piloto_id IN NUMBER)
        RETURN BOOLEAN
    IS
    BEGIN
        UPDATE piloto 
        SET mostrar = 0
        WHERE piloto_id = p_piloto_id;
        COMMIT;
        RETURN TRUE;    
    END eliminar_piloto;
    
    FUNCTION asignar_piloto(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_piloto_id IN piloto.piloto_id%TYPE
    )
    RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO se_asigna (vuelo_id, mostrar)
        VALUES (p_vuelo_id, 1);
        COMMIT;
        RETURN TRUE;
    END asignar_piloto;
    
    FUNCTION eliminar_piloto(
        p_piloto_id IN piloto.piloto_id%TYPE
    ) RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_delete_piloto VARCHAR2(30) := 'BEFORE_DELETE_PILOTO';
        v_res BOOLEAN := FALSE;
        delete_error EXCEPTION;  -- Declaración de la excepción
    BEGIN
        SELECT pi.persona_id
        INTO v_persona_id
        FROM piloto pi
        WHERE pi.piloto_id = p_piloto_id;
    
        SAVEPOINT v_before_delete_piloto;
        
        UPDATE piloto pi
        SET pi.mostrar = 0
        WHERE pi.piloto_id = p_piloto_id;
        
        v_res := persona_crud.eliminar_persona(v_persona_id);
        IF v_res THEN
            COMMIT;
            RETURN TRUE;
        ELSE
            RAISE delete_error;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_delete_piloto;
        RAISE;
    END eliminar_piloto;
END PILOTO_CRUD;
/