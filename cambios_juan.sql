--Cambios en el crud - vuelo Obtener vuelos paginados ordenados por fechas, retornar sys_refcursor.
CREATE OR REPLACE PACKAGE VUELO_CRUD AS
    PROCEDURE crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE,
        p_cantidad_pasajeros IN NUMBER
    );
    
    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo%ROWTYPE
    );

    PROCEDURE actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
    );

    PROCEDURE eliminar_vuelo(
        p_vuelo_id IN NUMBER
    );
    
    -- Procedimiento para obtener vuelos paginados ordenados por fechas
    PROCEDURE obtener_vuelos_paginados(
        p_pagina_actual IN NUMBER,
        p_tamano_pagina IN NUMBER,
        p_vuelos OUT SYS_REFCURSOR
    );
END VUELO_CRUD;
CREATE OR REPLACE PACKAGE BODY VUELO_CRUD AS
    PROCEDURE crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE,
        p_cantidad_pasajeros IN NUMBER
    ) IS
    BEGIN
        INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS)
        VALUES (vuelo_seq.NEXTVAL, p_aeropuerto_salida_id, p_aeropuerto_llegada_id, p_avion_id, p_destino, p_fecha_salida, p_fecha_llegada, p_cantidad_pasajeros);
    END crear_vuelo;

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo%ROWTYPE
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM VUELO 
        WHERE VUELO_ID = p_vuelo_id;
    END leer_vuelo;

    PROCEDURE actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
    ) IS
    BEGIN
        UPDATE VUELO
        SET CANTIDAD_PASAJEROS = p_cantidad_pasajeros,
            DESTINO = p_destino
        WHERE VUELO_ID = p_vuelo_id;
    END actualizar_vuelo;

    PROCEDURE eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM VUELO WHERE VUELO_ID = p_vuelo_id;
    END eliminar_vuelo;
    
    -- Procedimiento para obtener vuelos paginados ordenados por fechas
    PROCEDURE obtener_vuelos_paginados(
        p_pagina_actual IN NUMBER,
        p_tamano_pagina IN NUMBER,
        p_vuelos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        -- Calcular el rango de filas para la paginación
        OPEN p_vuelos FOR
        SELECT *
        FROM (
            SELECT VUELO.*, ROW_NUMBER() OVER (ORDER BY FECHA_SALIDA) AS rn
            FROM VUELO
        )
        WHERE rn BETWEEN (p_pagina_actual - 1) * p_tamano_pagina + 1 AND p_pagina_actual * p_tamano_pagina;
    END obtener_vuelos_paginados;
END VUELO_CRUD;

--Cambios en el crud - aeropuerto Obtener toda la información de un aeropuerto según el id en un rowtype, además de los vuelos que llegan y salen de ese aeropuerto, usando sys_refcursor.
create or replace PACKAGE aeropuerto_crud AS
    -- Procedimiento para crear un nuevo aeropuerto
    PROCEDURE crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    );

    -- Procedimiento para leer información de un aeropuerto
    FUNCTION leer_aeropuerto(p_aeropuerto_id IN NUMBER) RETURN aeropuerto%ROWTYPE;

    PROCEDURE leer_aeropuertos(p_aeropuertos OUT SYS_REFCURSOR);

    -- Procedimiento para actualizar información de un aeropuerto
    PROCEDURE actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    );

    -- Procedimiento para eliminar un aeropuerto
    PROCEDURE eliminar_aeropuerto(p_aeropuerto_id IN NUMBER);
    -- Procedimiento para obtener información de un aeropuerto y sus vuelos
    PROCEDURE obtener_info_aeropuerto_con_vuelos(
        p_aeropuerto_id IN NUMBER,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
        p_vuelos OUT SYS_REFCURSOR
    );
END aeropuerto_crud;

create or replace PACKAGE BODY aeropuerto_crud AS
    -- Implementación de procedimiento para crear un aeropuerto
    PROCEDURE crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
        VALUES (aeropuertos_seq.NEXTVAL, p_nombre, p_pais, p_ciudad);
        COMMIT;
    END crear_aeropuerto;

    -- Implementación de función para leer un aeropuerto
    FUNCTION leer_aeropuerto(p_aeropuerto_id IN NUMBER) RETURN aeropuerto%ROWTYPE IS
        v_info aeropuerto%ROWTYPE;
    BEGIN
        SELECT * INTO v_info
        FROM AEROPUERTO
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        RETURN v_info;
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


    -- Implementación de procedimiento para actualizar un aeropuerto
    PROCEDURE actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) IS
    BEGIN
        UPDATE AEROPUERTO
        SET NOMBRE = p_nombre, PAIS = p_pais, CIUDAD = p_ciudad
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
    END actualizar_aeropuerto;

    -- Implementación de procedimiento para eliminar un aeropuerto
    PROCEDURE eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) IS
    BEGIN
        DELETE FROM AEROPUERTO
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
    END eliminar_aeropuerto;
    -- Procedimiento para obtener información de un aeropuerto y sus vuelos
    PROCEDURE obtener_info_aeropuerto_con_vuelos(
        p_aeropuerto_id IN NUMBER,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
        p_vuelos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        -- Obtener información del aeropuerto
        SELECT * INTO p_aeropuerto_info
        FROM AEROPUERTO
        WHERE AEROPUERTO_ID = p_aeropuerto_id;

        -- Obtener vuelos que llegan y salen de ese aeropuerto
        OPEN p_vuelos FOR
        SELECT VUELO.*
        FROM VUELO
        WHERE AEROPUERTO_SALIDA_ID = p_aeropuerto_id OR AEROPUERTO_LLEGADA_ID = p_aeropuerto_id;
    END obtener_info_aeropuerto_con_vuelos;
END aeropuerto_crud;


--Cambios en el CRUD - piloto -Asignar piloto a un avión, verificar que el piloto no esté asignado a un avión en el mismo intervalo de tiempo.
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
    
     -- Procedimiento para asignar un piloto a un avión y verificar disponibilidad
    FUNCTION asignar_piloto(
        p_piloto_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE
    )
    RETURN BOOLEAN;
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
    
    -- Procedimiento para asignar un piloto a un avión y verificar disponibilidad
    FUNCTION asignar_piloto(
        p_piloto_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE
    )
    RETURN BOOLEAN
    IS
        v_piloto_disponible number;
    BEGIN
        -- Verificar si el piloto está disponible en el intervalo de tiempo
        SELECT COUNT(*)
        INTO v_piloto_disponible
        FROM PILOTO p INNER JOIN PILOTA ON p.PILOTO_ID = PILOTA.PILOTO_ID
            INNER JOIN AVION ON PILOTA.AVION_ID = AVION.AVION_ID
            INNER JOIN VUELO v ON AVION.AVION_ID = v.AVION_ID
        WHERE p.PILOTO_ID = p_piloto_id
          AND (
            (v.FECHA_SALIDA BETWEEN p_fecha_salida AND p_fecha_llegada)
            OR (v.FECHA_LLEGADA BETWEEN p_fecha_salida AND p_fecha_llegada)
            OR (p_fecha_salida BETWEEN v.FECHA_SALIDA AND v.FECHA_LLEGADA)
            OR (p_fecha_llegada BETWEEN v.FECHA_SALIDA AND v.FECHA_LLEGADA)
          );
        
        
        -- Si el piloto está disponible, asignarlo al avión
        IF v_piloto_disponible!=0 THEN
            UPDATE PILOTA
            SET PILOTO_ID = p_piloto_id
            WHERE AVION_ID = p_avion_id;

            -- Devolver TRUE para indicar éxito en la asignación
            RETURN TRUE;
        ELSE
            -- Devolver FALSE si el piloto no está disponible en el intervalo de tiempo
            RETURN FALSE;
        END IF;
    END asignar_piloto;
END PILOTO_CRUD;

--Cambios CRUD - Avion Obtener todos los aviones paginados, retornar un sys_refcursor.
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
    
    -- Procedimiento para obtener aviones paginados
    PROCEDURE obtener_aviones_paginados(
        p_pagina IN NUMBER,
        p_tamano_pagina IN NUMBER,
        p_aviones OUT SYS_REFCURSOR
    );
END AVION_CRUD;
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
    
    -- Procedimiento para obtener aviones paginados
    PROCEDURE obtener_aviones_paginados(
        p_pagina IN NUMBER,
        p_tamano_pagina IN NUMBER,
        p_aviones OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_aviones FOR
        SELECT *
        FROM (
            SELECT
                AVION_ID,
                TIPO_ID,
                CAPACIDAD_PASAJEROS,
                DISTANCIA_MAXIMA,
                CAPACIDAD_COMBUSTIBLE,
                VELOCIDAD_CRUCERO,
                CAPACIDAD_BODEGA,
                ROW_NUMBER() OVER (ORDER BY AVION_ID) AS rn
            FROM AVION
        )
        WHERE rn >= (p_pagina - 1) * p_tamano_pagina + 1
          AND rn <= p_pagina * p_tamano_pagina;
    END obtener_aviones_paginados;
END AVION_CRUD;



--Trigger:  Al crear o actualizar un pasajero, verificar que el peso del equipaje no supera la capacidad_bodega del avión,  de lo contrario lanzar una excepción con el código -20061 y un mensaje.
CREATE OR REPLACE TRIGGER TRG_VERIFICAR_DISPONIBILIDAD
BEFORE INSERT OR UPDATE ON REALIZA
FOR EACH ROW
DECLARE
    v_asientos_disponibles NUMBER;
    v_costo_pasajero NUMBER;
BEGIN
    -- Obtener el costo del pasajero desde la tabla PASAJERO
    SELECT COSTO
    INTO v_costo_pasajero
    FROM PASAJERO
    WHERE PERSONA_ID = :NEW.PASAJERO_ID;

    -- Obtener la cantidad de asientos disponibles en el vuelo asociado al pasajero
    SELECT (AV.CAPACIDAD_PASAJEROS - NVL(COUNT(P.PASAJERO_ID), 0))
    INTO v_asientos_disponibles
    FROM VUELO V
    JOIN AVION AV ON V.AVION_ID = AV.AVION_ID
    LEFT JOIN REALIZA R ON V.VUELO_ID = R.VUELO_ID
    LEFT JOIN PASAJERO P ON R.PASAJERO_ID = P.PERSONA_ID;

    -- Verificar si hay asientos disponibles
    IF v_costo_pasajero > 0 AND v_asientos_disponibles <= 0 THEN
        -- Lanzar una excepción con el código -20062 y un mensaje personalizado
        RAISE_APPLICATION_ERROR(-20062, 'No hay asientos disponibles en este vuelo.');
    END IF;
END;




--Procedimiento: Procedimiento: Leer los datos de un pasajero y los vuelos asignados, el procedimiento recibe pasajero_id y retorna un tipo compuesto con los datos del pasajero
-- Crear un tipo de registro para almacenar los datos del pasajero
CREATE OR REPLACE TYPE PasajeroInfo AS OBJECT (
    PersonaID NUMBER,
    GeneroID NUMBER,
    NumeroIdentificacion NUMBER,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    FechaNacimiento DATE,
    PaisNacimiento VARCHAR2(50),
    CiudadNacimiento VARCHAR2(50)
);

-- Crear un tipo de tabla para almacenar varios registros de tipo PasajeroInfo
CREATE OR REPLACE TYPE PasajeroInfoList AS TABLE OF PasajeroInfo;

-- Crear un procedimiento que devuelve datos del pasajero, equipaje y vuelos
CREATE OR REPLACE PROCEDURE ObtenerInfoPasajero(
    p_PasajeroID IN NUMBER,
    p_PasajeroInfo OUT PasajeroInfo,
    p_VuelosCursor OUT SYS_REFCURSOR
)
AS
BEGIN
     -- Inicializar el objeto PasajeroInfo
    p_PasajeroInfo := PasajeroInfo(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    -- Obtener datos del pasajero
    SELECT PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC,
           PAIS_NAC, CIUDAD_NAC
    INTO p_PasajeroInfo.PersonaID, p_PasajeroInfo.GeneroID,
         p_PasajeroInfo.NumeroIdentificacion, p_PasajeroInfo.Nombre,
         p_PasajeroInfo.Apellido, p_PasajeroInfo.FechaNacimiento,
         p_PasajeroInfo.PaisNacimiento, p_PasajeroInfo.CiudadNacimiento
    FROM PERSONA
    WHERE PERSONA_ID = p_PasajeroID;

    -- Abrir el cursor para los datos de los vuelos
    OPEN p_VuelosCursor FOR
        SELECT V.*
        FROM VUELO V
        JOIN REALIZA R ON V.VUELO_ID = R.VUELO_ID
        WHERE R.PASAJERO_ID = p_PasajeroID;
END ObtenerInfoPasajero;
--Se utiliza el procedimiento asi:
-- Declarar variables para almacenar la información del pasajero y los vuelos
DECLARE
    v_PasajeroInfo PasajeroInfo;
    v_VuelosCursor SYS_REFCURSOR;
    v_VueloRec VUELO%ROWTYPE;
BEGIN
    -- Llamar al procedimiento y abrir el cursor
    ObtenerInfoPasajero(1, v_PasajeroInfo, v_VuelosCursor);

    -- Acceder a los datos del pasajero
    DBMS_OUTPUT.PUT_LINE('Nombre del Pasajero: ' || v_PasajeroInfo.Nombre);
    DBMS_OUTPUT.PUT_LINE('Apellido del Pasajero: ' || v_PasajeroInfo.Apellido);
    -- Otros campos del pasajero
    
    -- Acceder a los datos de los vuelos con un bucle FOR
    LOOP
        FETCH v_VuelosCursor INTO v_VueloRec;
        EXIT WHEN v_VuelosCursor%NOTFOUND;

        -- Mostrar información del vuelo
        DBMS_OUTPUT.PUT_LINE('Vuelo ID: ' || v_VueloRec.VUELO_ID);
        DBMS_OUTPUT.PUT_LINE('Aeropuerto de Salida: ' || v_VueloRec.AEROPUERTO_SALIDA_ID);
        -- Otros campos del vuelo
        DBMS_OUTPUT.PUT_LINE('Aeropuerto de Llegada: ' || v_VueloRec.AEROPUERTO_LLEGADA_ID);
        DBMS_OUTPUT.PUT_LINE('Destino: ' || v_VueloRec.DESTINO);
        DBMS_OUTPUT.PUT_LINE('Fecha de Salida: ' || TO_CHAR(v_VueloRec.FECHA_SALIDA, 'DD-MON-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('Fecha de Llegada: ' || TO_CHAR(v_VueloRec.FECHA_LLEGADA, 'DD-MON-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('Cantidad de Pasajeros: ' || v_VueloRec.CANTIDAD_PASAJEROS);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;

    -- Cerrar el cursor
    CLOSE v_VuelosCursor;
END;
