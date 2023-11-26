-----------------------------------------------------------------------------------------
--PARA AZAFATA
DROP SEQUENCE azafata_seq;
CREATE SEQUENCE azafata_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE OR REPLACE PACKAGE AZAFATA_CRUD AS
    TYPE azafata_type IS RECORD 
    (
       persona_id            persona.persona_id%TYPE,
       genero_id             persona.genero_id%TYPE,
       numero_identificacion persona.numero_identificacion%TYPE,
       nombre                persona.nombre%TYPE,
       apellido              persona.apellido%TYPE,
       fecha_nac             persona.fecha_nac%TYPE,
       pais_nac              persona.pais_nac%TYPE,
       ciudad_nac            persona.ciudad_nac%TYPE,
       azafata_id            azafata.azafata_id%TYPE,
       vuelos_abordados      azafata.vuelos_abordados%TYPE,
       idioma_natal          azafata.idioma_natal%TYPE,
       idioma_secundario     azafata.idioma_secundario%TYPE,
       mostrar               azafata.mostrar%TYPE
    );
    
    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_info OUT azafata_type
    );
    
    PROCEDURE leer_azafatas(
        p_azafatas OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN NUMBER
    ) RETURN BOOLEAN;
END AZAFATA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY AZAFATA_CRUD AS
    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_info OUT azafata_type
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
            a.azafata_id,
            a.vuelos_abordados,
            a.idioma_natal,
            a.idioma_secundario,
            a.mostrar
        INTO p_info
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
    
END AZAFATA_CRUD;
/




