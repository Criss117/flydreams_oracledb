-- PARA PASAJERO
DROP SEQUENCE pasajero_seq;
DROP SEQUENCE equipaje_seq;
CREATE SEQUENCE pasajero_seq
    START WITH 6
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE equipaje_seq
    START WITH 6
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE PASAJERO_CRUD AS
    TYPE pasajero_type IS RECORD 
    (
        persona_id      pasajero.persona_id%TYPE,
        pasajero_id     pasajero.pasajero_id%TYPE,
        costo           pasajero.costo%TYPE,
        destino         pasajero.destino%TYPE,
        peso            equipaje_bodega.peso%TYPE,
        mostrar         pasajero.mostrar%TYPE
    );

    FUNCTION crear_pasajero(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_pasajero_info IN pasajero_type
    ) RETURN NUMBER;
    
    PROCEDURE leer_pasajero(
        p_pasajero_id IN NUMBER,
        p_pasajero_info OUT pasajero_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    );
    
    PROCEDURE leer_pasajeros(
        p_pasajeros OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );
    
    FUNCTION asignar_vuelo(
        p_pasajero_id pasajero.pasajero_id%TYPE,
        p_vuelo_id vuelo.vuelo_id%TYPE
    )RETURN BOOLEAN;
    
    FUNCTION eliminar_pasajero(
        p_pasajero_id IN NUMBER
    ) RETURN BOOLEAN;
    
END PASAJERO_CRUD;
/

CREATE OR REPLACE PACKAGE BODY PASAJERO_CRUD AS
    FUNCTION crear_pasajero(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_pasajero_info IN pasajero_type
    )
    RETURN NUMBER
    IS
        v_persona_id persona.persona_id%TYPE;
        v_pasajero_id pasajero.pasajero_id%TYPE;
        v_before_insert_pasajero VARCHAR2(30) := 'BEFORE_INSERT_PASAJERO';
    BEGIN
        SAVEPOINT v_before_insert_pasajero;
        v_persona_id := PERSONA_CRUD.crear_persona(p_persona_info);
        v_pasajero_id := pasajero_seq.NEXTVAL;
        INSERT INTO pasajero (persona_id, pasajero_id, costo, destino, mostrar)
        VALUES (
            v_persona_id, 
            v_pasajero_id,
            p_pasajero_info.costo,
            p_pasajero_info.destino,
            1);
       
        INSERT INTO equipaje_bodega(equipaje_id, pasajero_id, peso, mostrar)
        VALUES (equipaje_seq.NEXTVAL, v_pasajero_id, p_pasajero_info.peso, 1);
        COMMIT;
        RETURN v_pasajero_id;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_pasajero;
        RAISE;
    END;

    PROCEDURE leer_pasajero(
        p_pasajero_id IN NUMBER,
        p_pasajero_info OUT pasajero_type,
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
            pa.persona_id,
            pa.pasajero_id,
            pa.costo,
            pa.destino,
            pa.mostrar
        INTO 
            p_persona_info.persona_id, 
            p_persona_info.genero_id,
            p_persona_info.numero_identificacion,
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            p_pasajero_info.persona_id,
            p_pasajero_info.pasajero_id,
            p_pasajero_info.costo,
            p_pasajero_info.destino,
            p_pasajero_info.mostrar
        FROM pasajero pa
        INNER JOIN persona p
        ON pa.persona_id = p.persona_id
        WHERE pa.pasajero_id = p_pasajero_id
        AND pa.mostrar = 1 
        AND p.mostrar = 1;
    END leer_pasajero;
    
    PROCEDURE leer_pasajeros(
        p_pasajeros OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    )IS
    BEGIN
        OPEN p_pasajeros FOR
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
                pa.pasajero_id,
                pa.costo,
                pa.destino,
                pa.mostrar,
                ROW_NUMBER() OVER (ORDER BY p.persona_id) AS rn
            FROM pasajero pa 
            INNER JOIN persona p
            ON pa.persona_id = p.persona_id
            AND pa.mostrar = 1 
            AND p.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END leer_pasajeros;
    
    FUNCTION eliminar_pasajero(p_pasajero_id IN NUMBER)
        RETURN BOOLEAN
    IS
    BEGIN
        UPDATE PASAJERO 
        SET MOSTRAR = 0
        WHERE pasajero_id = p_pasajero_id;
        COMMIT;
        RETURN TRUE;    
    END;
    
    FUNCTION asignar_vuelo(
        p_pasajero_id pasajero.pasajero_id%TYPE,
        p_vuelo_id vuelo.vuelo_id%TYPE
    )RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO realiza(vuelo_id, pasajero_id, mostrar)
        VALUES(p_vuelo_id, p_pasajero_id, 1);
        COMMIT;
    RETURN TRUE;
    END;
    
END PASAJERO_CRUD;
/