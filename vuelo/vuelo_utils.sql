CREATE OR REPLACE PACKAGE vuelo_utils AS
    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    );
END vuelo_utils;

CREATE OR REPLACE PACKAGE BODY vuelo_utils AS
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
END vuelo_utils;
