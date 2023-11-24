CREATE VIEW vista_info_pasajero AS
SELECT
    p.pasajero_id,
    pe.nombre,
    pe.apellido,
    pe.fecha_nac,
    pe.pais_nac,
    pe.ciudad_nac,
    p.costo,
    p.destino
FROM
    pasajero p
    INNER JOIN persona pe ON p.persona_id = pe.persona_id;
/
--Vista para azafata:
CREATE VIEW vista_info_azafata AS
SELECT
    a.azafata_id,
    pe.nombre,
    pe.apellido,
    pe.fecha_nac,
    pe.pais_nac,
    pe.ciudad_nac,
    a.vuelos_abordados,
    a.idioma_natal
FROM
    azafata a
    INNER JOIN persona pe ON a.persona_id = pe.persona_id;
--testeo:
SELECT * FROM vista_info_pasajero;
SELECT * FROM vista_info_azafata;