--PARA VUELO
DROP SEQUENCE vuelo_seq;
CREATE SEQUENCE vuelo_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/ 
CREATE OR REPLACE PACKAGE vuelo_crud AS
    TYPE vuelo_type IS RECORD
    (
        vuelo_id             vuelo.vuelo_id%TYPE,
        aeropuerto_salida_id vuelo.aeropuerto_salida_id%TYPE,
        aeropuerto_llegada_id vuelo.aeropuerto_llegada_id%TYPE,
        avion_id             vuelo.avion_id%TYPE,
        destino              vuelo.destino%TYPE,
        fecha_salida         vuelo.fecha_salida%TYPE,
        fecha_llegada        vuelo.fecha_llegada%TYPE,
        cantidad_pasajeros   vuelo.cantidad_pasajeros%TYPE,
        mostrar              vuelo.mostrar%TYPE
    );

    FUNCTION crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE, 
        p_fecha_llegada IN DATE
    ) RETURN vuelo.vuelo_id%TYPE;
    
    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    );

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo_type
    );
    
    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );

    FUNCTION actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_vuelo_info IN vuelo_type
    ) RETURN BOOLEAN;

    FUNCTION eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) RETURN BOOLEAN;
    
   
END vuelo_crud;
/
CREATE OR REPLACE PACKAGE BODY vuelo_crud AS
     FUNCTION crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE
    ) 
    RETURN vuelo.vuelo_id%TYPE
    IS
        v_vuelo_id vuelo.vuelo_id%TYPE := vuelo_seq.NEXTVAL;
    BEGIN
        INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS, MOSTRAR)
        VALUES (v_vuelo_id, p_aeropuerto_salida_id, p_aeropuerto_llegada_id, p_avion_id, p_destino, p_fecha_salida, p_fecha_llegada, 0, 1);
        COMMIT;
        RETURN v_vuelo_id;
    END crear_vuelo;

    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_aviones FOR
        SELECT a.avion_id, ta.tipo_avion
        FROM avion a
        INNER JOIN tipo_avion ta
        ON a.tipo_id = ta.tipo_id;
        
        OPEN p_aeropuertos FOR
        SELECT a.aeropuerto_id, a.nombre
        FROM aeropuerto a;
    END obtener_info_para_crear;

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo_type
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM VUELO 
        WHERE VUELO_ID = p_vuelo_id
        AND mostrar = 1;
    END leer_vuelo;

    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    ) IS
    BEGIN
        OPEN p_vuelos FOR
        SELECT *
        FROM (
            SELECT 
                v.vuelo_id,
                v.aeropuerto_salida_id,
                v.aeropuerto_llegada_id,
                a.nombre aeropuerto_llegada,
                b.nombre aeropuerto_salida,
                v.destino,
                v.fecha_llegada,
                v.fecha_salida,
                v.cantidad_pasajeros, 
                v.mostrar,
                ROW_NUMBER() OVER (ORDER BY FECHA_SALIDA) AS rn
            FROM vuelo v
            INNER JOIN aeropuerto a
            ON v.aeropuerto_salida_id = a.aeropuerto_id
            INNER JOIN aeropuerto b
            ON v.aeropuerto_llegada_id = b.aeropuerto_id
            WHERE v.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END;

    FUNCTION actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_vuelo_info IN vuelo_type
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE VUELO
        SET 
            AEROPUERTO_SALIDA_ID = p_vuelo_info.aeropuerto_salida_id,
            AEROPUERTO_LLEGADA_ID = p_vuelo_info.aeropuerto_llegada_id,
            AVION_ID = p_vuelo_info.avion_id,
            DESTINO = p_vuelo_info.destino,
            FECHA_SALIDA = p_vuelo_info.fecha_salida,
            FECHA_LLEGADA = p_vuelo_info.fecha_llegada
        WHERE VUELO_ID = p_vuelo_id;
        COMMIT;
        RETURN TRUE;
    END actualizar_vuelo;

    FUNCTION eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE VUELO 
        SET MOSTRAR = 0
        WHERE VUELO_ID = p_vuelo_id;
        COMMIT;
        RETURN TRUE;
    END eliminar_vuelo;
    
END vuelo_crud;
/