-- Consultar los abogados especializados en un area
SELECT Area, nuip, Abogado, años_experiencia,
       tarifa_minima, calificacion_promedio
    FROM VAbogado
    WHERE Area IN ('&area1', '&area2');
-- Consultar las calificaciones de un abogado
SELECT NombreCliente, fecha, comentario, valoracion
    FROM VCalifiaciones
    WHERE nuip = '&NUIP';
-- 3877565182 - 6293493877
-- Consultar las firmas que tienen alguna especialidad de un abogado
SELECT Area, NIT, Firma, departamento, municipio, direccion
    FROM VFirma
    WHERE nuip = '&NUIP';
-- 6708477211

-- Consultar los hechos con sus respectivas pruebas de una demanda
SELECT Hecho, Fecha, Descripcion_Hecho, Prueba, tipo, Descripcion_prueba
    FROM VHechos
    WHERE demanda = '&Id';
-- 583
-- Consultar informacion relacionada a una audiencia
SELECT Audiencia, fecha, Juzgado, departamento, municipio, direccion
FROM VAudiencias
    WHERE nuip = '&NUIP';
--  4123610951
-- Consultar informacion de las demandas que ha hecho un cliente
SELECT Demanda, pretencion, Fecha_Demanda, estado, resultado, fallo, Fecha_sentencia, nuip, nombre
    FROM VDemandas
    WHERE clientes_id = '&Id';
-- 69