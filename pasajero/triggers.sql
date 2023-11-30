CREATE OR REPLACE TRIGGER TRG_VERIFICAR_DISPONIBILIDAD
BEFORE INSERT OR UPDATE ON REALIZA
FOR EACH ROW
DECLARE
    v_asientos_ocupados NUMBER;
    v_capacidad_pasajeros NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_asientos_ocupados
    FROM realiza r
    WHERE r.vuelo_id = :NEW.vuelo_id;
    
    SELECT a.capacidad_pasajeros
    INTO v_capacidad_pasajeros
    FROM vuelo v
    INNER JOIN avion a
    ON v.avion_id = a.avion_id
    WHERE v.vuelo_id = :NEW.vuelo_id;
    
    IF v_asientos_ocupados > v_capacidad_pasajeros THEN
        RAISE_APPLICATION_ERROR(-20062, 'No hay asientos disponibles en este vuelo.');
    END IF;
END;