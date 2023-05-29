-- Un abogado con mas de 6 especialidades
INSERT INTO espAbog VALUES ('3867384444', 1);

-- Los lugares no se pueden eliminar
DELETE FROM lugares WHERE id = 1;
-- Los lugares no se pueden actualizar
UPDATE lugares SET id = 1 WHERE id = 2;

-- Las revisiones no se pueden actualizar
UPDATE revisiones SET perfiles_id = 1 WHERE clientes_id = 3;

-- Actualizar una persona natural
UPDATE personasNaturales SET nuip = '2828767298' WHERE nuip = '9905955801';

-- Actualizar la especialidad de una firma
UPDATE espFirmas SET firmas_nit = '937708198-9' WHERE areas_id = 1;

-- Eliminar un area
DELETE FROM areas WHERE id = 4;

-- Actualizar una tarjeta profesional
UPDATE tarjetasProfesionales SET universidad = 'Universidad tarjeta'
    WHERE abogados_nuip = '1923222848';

-- Actualizar la especialidad de un abogado
UPDATE espAbog SET areas_id = 1 WHERE abogados_nuip = '9590811213';

-- Los estudios no se puede actualizar
UPDATE estudios SET titulo = 'Abogado' WHERE perfiles_id = 1;

-- Eliminar una asesoria
DELETE FROM asesorias WHERE id = 4;

-- Eliminar un contrato
DELETE FROM contratos WHERE id = 87;

-- No se pueden eliminar las demandas
DELETE FROM demandas WHERE id = 56;

-- Eliminar un fundamento de derecho
DELETE FROM fundamentosDerechos WHERE id = 23;

-- Los casos no se pueden eliminar
DELETE FROM casos WHERE demandas_id = 34;

-- Las sentenicias no se pueden actualizar
UPDATE sentencias SET fecha = '15/05/2022' WHERE numero = 54;
-- Las sentenicas no se pueden eliminar 
DELETE FROM sentencias WHERE numero = 24;

-- No se pueden eliminar los juzgados
DELETE FROM juzgados WHERE id = 23;