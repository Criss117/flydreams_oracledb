DROP SEQUENCE aeropuertos_seq;
CREATE SEQUENCE aeropuertos_seq
    START WITH 7
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE aeropuerto_crud AS
    TYPE aeropuerto_type IS RECORD
    (
        aeropuerto_id aeropuerto.aeropuerto_id%TYPE,
        nombre aeropuerto.nombre%TYPE,
        pais aeropuerto.pais%TYPE,
        ciudad aeropuerto.ciudad%TYPE,
        mostrar aeropuerto.mostrar%TYPE
    );
    -- Procedimiento para crear un nuevo aeropuerto
    FUNCTION crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) RETURN BOOLEAN;
    
    -- Procedimiento para leer información de un aeropuerto
    PROCEDURE leer_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aeropuerto_info OUT aeropuerto_type
    );
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto_type,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    );
    
    PROCEDURE leer_aeropuertos(p_aeropuertos OUT SYS_REFCURSOR);
    
    -- Procedimiento para actualizar información de un aeropuerto
    FUNCTION actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aero_info IN aeropuerto_type
    )RETURN BOOLEAN;
    
    -- Procedimiento para eliminar un aeropuerto
    FUNCTION eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) RETURN BOOLEAN;
END aeropuerto_crud;
/
CREATE OR REPLACE PACKAGE BODY aeropuerto_crud AS
    -- Implementación de procedimiento para crear un aeropuerto
    FUNCTION crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
        VALUES (aeropuertos_seq.NEXTVAL, p_nombre, p_pais, p_ciudad, 1);
        COMMIT;
        RETURN true;
    END crear_aeropuerto;
    
    -- Implementación de función para leer un aeropuerto
    PROCEDURE leer_aeropuerto(
        p_aeropuerto_id IN NUMBER, 
        p_aeropuerto_info OUT aeropuerto_type) 
    IS
    BEGIN
        SELECT * 
        INTO p_aeropuerto_info
        FROM aeropuerto a
        WHERE a.aeropuerto_id = p_aeropuerto_id
        AND a.mostrar = 1;
    END leer_aeropuerto;
    
    PROCEDURE leer_aeropuertos(
        p_aeropuertos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_aeropuertos FOR
        SELECT * 
        FROM aeropuerto
        WHERE mostrar = 1;
    END;
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto_type,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    ) IS
    BEGIN
        SELECT * 
        INTO p_aeropuerto_info 
        FROM aeropuerto a
        WHERE a.aeropuerto_id = p_aeropuerto_id;
        
        OPEN p_vuelos_llegada FOR
        SELECT 
            v.vuelo_id, 
            v.destino, 
            v.fecha_llegada, 
            v.fecha_salida, 
            v.cantidad_pasajeros,
            a.nombre aeropuerto_salida
        FROM vuelo v
        INNER JOIN aeropuerto a
        ON v.aeropuerto_salida_id = a.aeropuerto_id
        WHERE v.aeropuerto_llegada_id = p_aeropuerto_id;
        
        OPEN p_vuelos_salida FOR
        SELECT 
            v.vuelo_id, 
            v.destino, 
            v.fecha_llegada, 
            v.fecha_salida, 
            v.cantidad_pasajeros,
            a.nombre aeropuerto_llegada
        FROM vuelo v
        INNER JOIN aeropuerto a
        ON v.aeropuerto_llegada_id = a.aeropuerto_id
        WHERE v.aeropuerto_salida_id = p_aeropuerto_id;
    END obtener_info;
    
    -- Implementación de procedimiento para actualizar un aeropuerto
    FUNCTION actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aero_info IN aeropuerto_type
    )
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AEROPUERTO
        SET 
            NOMBRE = p_aero_info.nombre, 
            PAIS = p_aero_info.pais, 
            CIUDAD = p_aero_info.ciudad
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        COMMIT;
        RETURN TRUE;
    END actualizar_aeropuerto;
    
    -- Implementación de procedimiento para eliminar un aeropuerto
    FUNCTION eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AEROPUERTO 
        SET MOSTRAR = 0
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        COMMIT;
        RETURN TRUE;
    END eliminar_aeropuerto;
    
END aeropuerto_crud;
/