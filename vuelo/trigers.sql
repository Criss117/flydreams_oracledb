DROP TRIGGER verificar_avion_vuelo;
--verifica que el avión asignado no esté asignado a otro vuelo en el mismo intervalo de tiempo
CREATE OR REPLACE TRIGGER verificar_avion_vuelo
    BEFORE INSERT OR UPDATE OF avion_id ON vuelo
FOR EACH ROW
DECLARE
    CURSOR aviones IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM vuelo v
        WHERE v.avion_id = :NEW.avion_id;
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
END;