-----------------------------------------------------------------------------------
--TRIGGERS
CREATE OR REPLACE TRIGGER verificar_vuelo
    BEFORE INSERT ON vuelo
FOR EACH ROW
DECLARE
    CURSOR aviones IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM vuelo v
        WHERE v.avion_id = :NEW.avion_id;
    v_capacidad_pasajeros_avion vuelo.cantidad_pasajeros%TYPE;
BEGIN
    FOR avionInfo IN aviones LOOP
        IF :NEW.fecha_salida 
        BETWEEN avionInfo.fecha_salida 
        AND avionInfo.fecha_llegada 
        OR
        :NEW.fecha_llegada 
        BETWEEN avionInfo.fecha_salida 
        AND avionInfo.fecha_llegada 
        THEN
            RAISE_APPLICATION_ERROR(
                -20202, 
                'El avion ya tiene asignado un vuelo en el rango de fechas'
            );
        END IF;      
    END LOOP;
    
    IF :NEW.aeropuerto_salida_id = :NEW.aeropuerto_llegada_id THEN
        RAISE_APPLICATION_ERROR(
            -20203, 
            'El aeropuerto de salida no puede ser igual al aeropuerto de llegada'
        );
    END IF;
        
    IF :NEW.fecha_salida > :NEW.fecha_llegada THEN
        RAISE_APPLICATION_ERROR(
            -20201, 
            'La fecha de salida no puede ser mayor a la fecha de llegada'
        );
    END IF;
END;
/

UPDATE vuelo v 
SET 
    v.aeropuerto_salida_id = 1,
    v.aeropuerto_llegada_id = 2,
    v.avion_id = 1, 
    v.destino = 'Destino1',
    v.fecha_salida = TO_DATE('2023-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    v.fecha_llegada = TO_DATE('2023-01-05 16:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    v.cantidad_pasajeros  = 100,
    v.mostrar = 1
WHERE v.vuelo_id = 1;


SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER verificar_pasajeros_vuelo
    BEFORE UPDATE OF cantidad_pasajeros ON vuelo
FOR EACH ROW
DECLARE
    v_capacidad_pasajeros_avion avion.capacidad_pasajeros%TYPE;
    v_capacidad_equipaje_avion avion.capacidad_bodega%TYPE;
    v_peso_actual avion.capacidad_bodega%TYPE;
    v_aux avion.capacidad_bodega%TYPE;
    CURSOR equipaje_pasajeros IS
        SELECT r.pasajero_id
        FROM realiza r
        WHERE r.vuelo_id = :OLD.avion_id;
BEGIN
    SELECT a.capacidad_pasajeros, a.capacidad_bodega
    INTO v_capacidad_pasajeros_avion, v_capacidad_equipaje_avion
    FROM avion a
    WHERE a.avion_id = :OLD.avion_id;
    
    IF :NEW.cantidad_pasajeros > v_capacidad_pasajeros_avion THEN
        RAISE_APPLICATION_ERROR(
            -20204, 
            'No hay mas puestos en el avión'
        );
    END IF;
       
    FOR equipaje_pasajero IN equipaje_pasajeros LOOP
        SELECT SUM(e.peso)
        INTO v_aux
        FROM equipaje_bodega e
        WHERE e.pasajero_id = equipaje_pasajero.pasajero_id;
        v_peso_actual := v_peso_actual + v_aux;
    END LOOP;    
    
    IF v_peso_actual > v_capacidad_equipaje_avion THEN 
        RAISE_APPLICATION_ERROR(
            -20205, 
            'Capacidad de carga excedida'
        );
    END IF;
END;

CREATE OR REPLACE TRIGGER verificar_azafata
    BEFORE INSERT ON se_asigna
FOR EACH ROW
DECLARE
    v_mostrar_vuelo vuelo.mostrar%TYPE;
    v_fecha_llegada vuelo.fecha_llegada%TYPE;
    v_fecha_salida vuelo.fecha_salida%TYPE;
    CURSOR azafatas_vuelos IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM se_asigna sa
        INNER JOIN vuelo v
        ON sa.vuelo_id = v.vuelo_id
        WHERE sa.azafata_id = :NEW.azafata_id;   
BEGIN 
    SELECT v.mostrar 
    INTO v_mostrar_vuelo
    FROM vuelo v
    WHERE v.vuelo_id = :NEW.vuelo_id;

    IF v_mostrar_vuelo = 0 THEN
        RAISE_APPLICATION_ERROR(
                -20142, 
                'El vuelo no está disponible'
            );
    END IF;

    SELECT v.fecha_salida, v.fecha_llegada
    INTO v_fecha_salida, v_fecha_llegada
    FROM vuelo v
    WHERE v.vuelo_id = :NEW.vuelo_id;
    
    FOR azafata_vuelo IN azafatas_vuelos LOOP
        IF v_fecha_salida 
        BETWEEN azafata_vuelo.fecha_salida 
        AND azafata_vuelo.fecha_llegada 
        OR
        v_fecha_llegada 
        BETWEEN azafata_vuelo.fecha_salida 
        AND azafata_vuelo.fecha_llegada 
        THEN
            RAISE_APPLICATION_ERROR(
                -20141, 
                'La azafata ya tiene asignado un vuelo en el rango de fechas'
            );
        END IF;      
    END LOOP;
END;








