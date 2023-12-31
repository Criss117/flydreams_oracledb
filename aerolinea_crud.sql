CREATE SEQUENCE avion_seq
    START WITH 3
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE AVION_CRUD AS
    PROCEDURE crear_avion(
        p_tipo_id IN NUMBER,
        p_capacidad_pasajeros IN NUMBER,
        p_distancia_maxima IN NUMBER,
        p_capacidad_combustible IN NUMBER,
        p_velocidad_crucero IN NUMBER,
        p_capacidad_bodega IN NUMBER
    );
    
    PROCEDURE leer_avion(
        p_avion_id IN NUMBER,
        p_info OUT avion%ROWTYPE
    );

    PROCEDURE actualizar_avion(
        p_avion_id IN NUMBER,
        p_capacidad_pasajeros IN NUMBER,
        p_distancia_maxima IN NUMBER
    );

    PROCEDURE eliminar_avion(
        p_avion_id IN NUMBER
    );
END AVION_CRUD;
/
CREATE OR REPLACE PACKAGE BODY AVION_CRUD AS
    PROCEDURE crear_avion(
        p_tipo_id IN NUMBER,
        p_capacidad_pasajeros IN NUMBER,
        p_distancia_maxima IN NUMBER,
        p_capacidad_combustible IN NUMBER,
        p_velocidad_crucero IN NUMBER,
        p_capacidad_bodega IN NUMBER
    ) IS
    BEGIN
        INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA)
        VALUES (avion_seq.NEXTVAL, p_tipo_id, p_capacidad_pasajeros, p_distancia_maxima, p_capacidad_combustible, p_velocidad_crucero, p_capacidad_bodega);
    END crear_avion;
    
    PROCEDURE leer_avion(
        p_avion_id IN NUMBER,
        p_info OUT avion%ROWTYPE
    ) IS
    BEGIN
        SELECT * 
        INTO p_info 
        FROM AVION 
        WHERE AVION_ID = p_avion_id;
    END leer_avion;

    PROCEDURE actualizar_avion(
        p_avion_id IN NUMBER,
        p_capacidad_pasajeros IN NUMBER,
        p_distancia_maxima IN NUMBER
    ) IS
    BEGIN
        UPDATE AVION
        SET CAPACIDAD_PASAJEROS = p_capacidad_pasajeros, DISTANCIA_MAXIMA = p_distancia_maxima
        WHERE AVION_ID = p_avion_id;
    END actualizar_avion;

    PROCEDURE eliminar_avion(
        p_avion_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM AVION
        WHERE AVION_ID = p_avion_id;
    END eliminar_avion;
END AVION_CRUD;
/

------------------------------------------------------------------------------------------------------
--Paquete para operaciones CRUD en la tabla AEROPUERTO
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
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
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
        WHERE a.aeropuerto_id = p_aeropuerto_id;
    END leer_aeropuerto;
    
    PROCEDURE leer_aeropuertos(
        p_aeropuertos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_aeropuertos FOR
        SELECT * 
        FROM aeropuerto;
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
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AEROPUERTO
        SET NOMBRE = p_nombre, PAIS = p_pais, CIUDAD = p_ciudad
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
        SET MOSTRAR = 0;
        COMMIT;
        RETURN TRUE;
    END eliminar_aeropuerto;
    
END aeropuerto_crud;
/
-------------------------------------------------------------------------------------------------------
--PARA PERSONA:
CREATE SEQUENCE persona_seq
    START WITH 15
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE PERSONA_CRUD AS
    PROCEDURE crear_persona(
        p_genero_id IN NUMBER,
        p_numero_identificacion IN NUMBER,
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2,
        p_fecha_nac IN DATE,
        p_pais_nac IN VARCHAR2,
        p_ciudad_nac IN VARCHAR2
    );
    
    PROCEDURE leer_persona(
        p_persona_id IN NUMBER,
        p_info OUT persona%ROWTYPE
    );

    PROCEDURE actualizar_persona(
        p_persona_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2
    );

    PROCEDURE eliminar_persona(
        p_persona_id IN NUMBER
    );
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
-----------------------------------------------------------------------------------------
--PARA AZAFATA
CREATE SEQUENCE azafata_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE OR REPLACE PACKAGE AZAFATA_CRUD AS
    PROCEDURE crear_azafata(
        p_persona_id IN NUMBER,
        p_vuelos_abordados IN NUMBER,
        p_idioma_natal IN VARCHAR2,
        p_idioma_secundario IN VARCHAR2
    );
    
    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_info OUT azafata%ROWTYPE
    );

    PROCEDURE actualizar_azafata(
        p_azafata_id IN NUMBER,
        p_vuelos_abordados IN NUMBER,
        p_idioma_natal IN VARCHAR2
    );

    PROCEDURE eliminar_azafata(
        p_azafata_id IN NUMBER
    );
END AZAFATA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY AZAFATA_CRUD AS
    PROCEDURE crear_azafata(
        p_persona_id IN NUMBER,
        p_vuelos_abordados IN NUMBER,
        p_idioma_natal IN VARCHAR2,
        p_idioma_secundario IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO)
        VALUES (p_persona_id, azafata_seq.NEXTVAL, p_vuelos_abordados, p_idioma_natal, p_idioma_secundario);
    END crear_azafata;

    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_info OUT azafata%ROWTYPE
    ) IS
    BEGIN
        SELECT *
        INTO p_info
        FROM AZAFATA 
        WHERE AZAFATA_ID = p_azafata_id;
    END leer_azafata;

    PROCEDURE actualizar_azafata(
        p_azafata_id IN NUMBER,
        p_vuelos_abordados IN NUMBER,
        p_idioma_natal IN VARCHAR2
    ) IS
    BEGIN
        UPDATE AZAFATA
        SET VUELOS_ABORDADOS = p_vuelos_abordados,
            IDIOMA_NATAL = p_idioma_natal
        WHERE AZAFATA_ID = p_azafata_id;
    END actualizar_azafata;

    PROCEDURE eliminar_azafata(p_azafata_id IN NUMBER) IS
    BEGIN
        DELETE FROM AZAFATA WHERE AZAFATA_ID = p_azafata_id;
    END eliminar_azafata;
END AZAFATA_CRUD;
/
---------------------------------------------------------------------------------------------------
--PARA PILOTO:
CREATE SEQUENCE piloto_seq
    START WITH 7
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE OR REPLACE PACKAGE PILOTO_CRUD AS
    PROCEDURE crear_piloto(
        p_persona_id IN NUMBER,
        p_licencia_id IN NUMBER,
        p_vuelos IN NUMBER,
        p_emision_licencia IN DATE,
        p_vencimiento_licencia IN DATE
    );
    
    PROCEDURE leer_piloto(
        p_piloto_id IN NUMBER,
        p_info OUT piloto%ROWTYPE
    );

    PROCEDURE actualizar_piloto(
        p_piloto_id IN NUMBER,
        p_vuelos IN NUMBER,
        p_emision_licencia IN DATE
    );

    PROCEDURE eliminar_piloto(
        p_piloto_id IN NUMBER
    );
END PILOTO_CRUD;
/
CREATE OR REPLACE PACKAGE BODY PILOTO_CRUD AS
    PROCEDURE crear_piloto(
        p_persona_id IN NUMBER,
        p_licencia_id IN NUMBER,
        p_vuelos IN NUMBER,
        p_emision_licencia IN DATE,
        p_vencimiento_licencia IN DATE
    ) IS
    BEGIN
        INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
        VALUES (p_persona_id, piloto_seq.NEXTVAL, p_licencia_id, p_vuelos, p_emision_licencia, p_vencimiento_licencia);
    END crear_piloto;

    PROCEDURE leer_piloto(
        p_piloto_id IN NUMBER,
        p_info OUT piloto%ROWTYPE
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM PILOTO 
        WHERE PILOTO_ID = p_piloto_id;
    END leer_piloto;

    PROCEDURE actualizar_piloto(
        p_piloto_id IN NUMBER,
        p_vuelos IN NUMBER,
        p_emision_licencia IN DATE
    ) IS
    BEGIN
        UPDATE PILOTO
        SET VUELOS = p_vuelos,
            EMISION_LICENCIA = p_emision_licencia
        WHERE PILOTO_ID = p_piloto_id;
    END actualizar_piloto;

    PROCEDURE eliminar_piloto(p_piloto_id IN NUMBER) IS
    BEGIN
        DELETE FROM PILOTO WHERE PILOTO_ID = p_piloto_id;
    END eliminar_piloto;
END PILOTO_CRUD;
/
---------------------------------------------------------------------------------------
--PARA VUELO
DROP SEQUENCE vuelo_seq;
CREATE SEQUENCE vuelo_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/ 
CREATE OR REPLACE PACKAGE vuelo_crud AS
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
        p_info OUT vuelo%ROWTYPE
    );
    
    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );

    FUNCTION actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
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
        p_info OUT vuelo%ROWTYPE
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
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE VUELO
        SET CANTIDAD_PASAJEROS = p_cantidad_pasajeros,
            DESTINO = p_destino
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
-----------------------------------------------------------------------------------
--PARA PASAJERO:
CREATE SEQUENCE pasajero_seq
    START WITH 7
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE OR REPLACE PACKAGE PASAJERO_CRUD AS
    PROCEDURE crear_pasajero(
        p_persona_id IN NUMBER,
        p_costo IN NUMBER,
        p_destino IN VARCHAR2,
        p_companion_id IN NUMBER DEFAULT NULL
    );
    
    PROCEDURE leer_pasajero(
        p_pasajero_id IN NUMBER,
        p_info OUT pasajero%ROWTYPE
    );

    PROCEDURE actualizar_pasajero(
        p_pasajero_id IN NUMBER,
        p_costo IN NUMBER,
        p_destino IN VARCHAR2
    );

    PROCEDURE eliminar_pasajero(
        p_pasajero_id IN NUMBER
    );
END PASAJERO_CRUD;
/
CREATE OR REPLACE PACKAGE BODY PASAJERO_CRUD AS
    PROCEDURE crear_pasajero(
        p_persona_id IN NUMBER,
        p_costo IN NUMBER,
        p_destino IN VARCHAR2,
        p_companion_id IN NUMBER DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO PASAJERO (PASAJERO_ID, PERSONA_ID, COSTO, DESTINO, COMPANION_ID)
        VALUES (pasajero_seq.NEXTVAL, p_persona_id, p_costo, p_destino, p_companion_id);
    END crear_pasajero;

    PROCEDURE leer_pasajero(
        p_pasajero_id IN NUMBER,
        p_info OUT pasajero%ROWTYPE
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM PASAJERO 
        WHERE PASAJERO_ID = p_pasajero_id;
    END leer_pasajero;

    PROCEDURE actualizar_pasajero(
        p_pasajero_id IN NUMBER,
        p_costo IN NUMBER,
        p_destino IN VARCHAR2
    ) IS
    BEGIN
        UPDATE PASAJERO
        SET COSTO = p_costo,
            DESTINO = p_destino
        WHERE PASAJERO_ID = p_pasajero_id;
    END actualizar_pasajero;

    PROCEDURE eliminar_pasajero(
        p_pasajero_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM PASAJERO WHERE PASAJERO_ID = p_pasajero_id;
    END eliminar_pasajero;
END PASAJERO_CRUD;
/


