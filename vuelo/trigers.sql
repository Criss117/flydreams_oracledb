-----------------------------------------------------------------------------------
--TRIGGERS
--DROP TRIGGER verificar_vuelo;
--verifica que el avión asignado no esté asignado a otro vuelo en el mismo intervalo de tiempo
CREATE OR REPLACE TRIGGER verificar_vuelo
    BEFORE INSERT OR UPDATE ON vuelo
FOR EACH ROW
DECLARE
    CURSOR aviones IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM vuelo v
        WHERE v.avion_id = :NEW.avion_id;
BEGIN
    FOR avionInfo IN aviones LOOP
        IF 
            :NEW.fecha_salida 
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
    END LOOP;
END;
/

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
        SELECT eb.peso
        INTO v_aux
        FROM equipaje_bodega eb
        WHERE eb.pasajero_id = equipaje_pasajero.pasajero_id;
        
        v_peso_actual := v_peso_actual + v_aux;
    END LOOP;    
    
    IF v_peso_actual > v_capacidad_equipaje_avion THEN 
        RAISE_APPLICATION_ERROR(
            -20205, 
            'Capacidad de carga excedida'
        );
    END IF;
END;

