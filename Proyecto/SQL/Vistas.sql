CREATE OR REPLACE VIEW VAbogado AS
    SELECT areas.nombre AS Area, nuip, abogados.nombre AS Abogado, años_experiencia,
           tarifa_minima, calificacion_promedio
        FROM abogados JOIN espAbog ON (nuip = abogados_nuip)
            JOIN areas ON (areas_id = areas.id)
            JOIN perfiles ON (perfiles.abogados_nuip = abogados.nuip)
        WHERE calificacion_promedio IS NOT NULL
        ORDER BY calificacion_promedio DESC, años_experiencia DESC, tarifa_minima;
CREATE OR REPLACE VIEW VCalificaciones AS 
    SELECT nuip, clientes.nombre as NombreCliente, fecha, comentario, valoracion
        FROM abogados JOIN perfiles ON (nuip = abogados_nuip)
            JOIN calificaciones ON (perfiles_id = perfiles.id) JOIN clientes ON (clientes_id =  clientes.id)
        ORDER BY valoracion;
CREATE OR REPLACE VIEW VFirma AS
    SELECT nuip, areas.nombre AS Area, firmas.nit AS NIT, firmas.nombre AS Firma, departamento, municipio, direccion
    FROM abogados JOIN espAbog ON (nuip = abogados_nuip)
        JOIN espFirmas ON (espFirmas.areas_id = espAbog.areas_id)
        JOIN areas ON (espAbog.areas_id = areas.id)
        JOIN firmas ON (espFirmas.firmas_nit = firmas.nit)
        JOIN lugares ON (lugares.id = firmas.lugares_id)
    ORDER BY departamento;
        
CREATE OR REPLACE VIEW VAudiencias AS
    SELECT audiencias.id AS Audiencia, fecha, nuip, jueces.nombre AS Juez, juzgados.nombre AS Juzgado,
        departamento, municipio, direccion
    FROM audiencias JOIN jueces ON (jueces_nuip = nuip)
                    JOIN juzgados ON (juzgados_id = juzgados.id)
                    JOIN lugares ON (lugares_id = lugares.id)
    ORDER BY fecha DESC;
CREATE OR REPLACE VIEW VHechos AS
    SELECT demandas.id AS demanda, hechos.id AS Hecho, hechos.fecha AS Fecha, hechos.descripcion AS Descripcion_Hecho,
        pruebas.id AS Prueba, tipo, pruebas.descripcion AS Descripcion_prueba
        FROM demandas JOIN hechos ON (demandas.id = demandas_id) 
                      LEFT JOIN pruebas ON (hechos.id = hechos_id)
        ORDER BY Fecha DESC;
CREATE OR REPLACE VIEW VDemandas AS
    SELECT clientes_id, demandas.id AS Demanda, pretencion, demandas.fecha AS Fecha_Demanda,
        estado, resultado, fallo, sentencias.fecha AS Fecha_Sentencia, nuip, nombre
        FROM demandas JOIN casos ON (demandas_id = demandas.id)
                      LEFT JOIN sentencias ON (casos.id = casos_id)
                      LEFT JOIN jueces ON (jueces.nuip = jueces_nuip)
        ORDER BY demandas.fecha DESC;