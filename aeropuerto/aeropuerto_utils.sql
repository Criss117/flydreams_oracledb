CREATE OR REPLACE PACKAGE aeropuerto_utils AS
    TYPE aeropuerto_type IS RECORD
    (
        aeropuerto_id aeropuerto.aeropuerto_id%TYPE,
        nombre aeropuerto.nombre%TYPE,
        pais aeropuerto.pais%TYPE,
        ciudad aeropuerto.ciudad%TYPE
    );
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    );
END aeropuerto_utils;

CREATE OR REPLACE PACKAGE BODY aeropuerto_utils AS
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    ) IS
    BEGIN
        SELECT * 
        INTO p_aeropuerto_info 
        FROM aeropuerto a
        WHERE a.aeropuerto_id = p_aeropuerto_id;
        
        OPEN p_vuelos_llegada FOR
        SELECT * 
        FROM vuelo v
        WHERE v.aeropuerto_llegada_id = p_aeropuerto_id;
        
        OPEN p_vuelos_salida FOR
        SELECT * 
        FROM vuelo v
        WHERE v.aeropuerto_salida_id = p_aeropuerto_id;
    END obtener_info;
END aeropuerto_utils;

DECLARE
    aeropuerto_info aeropuerto%ROWTYPE;
BEGIN
    aeropuerto_utils.obtener_info(1, aeropuerto_info);
END;
