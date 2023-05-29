-- Consultar los abogados especializados en un area
SELECT areas.nombre AS Area, nuip, abogados.nombre AS Abogado, años_experiencia,
           tarifa_minima, calificacion_promedio
        FROM abogados JOIN espAbog ON (nuip = abogados_nuip)
            JOIN areas ON (areas_id = areas.id)
            JOIN perfiles ON (perfiles.abogados_nuip = abogados.nuip)
        WHERE areas.nombre IN ('&area1', '&area2') AND calificacion_promedio IS NOT NULL
        ORDER BY calificacion_promedio DESC, años_experiencia DESC, tarifa_minima;
-- Consultar las calificaciones de un abogado
SELECT clientes.nombre as NombreCliente, fecha, comentario, valoracion
        FROM abogados JOIN perfiles ON (nuip = abogados_nuip)
            JOIN calificaciones ON (perfiles_id = perfiles.id) JOIN clientes ON (clientes_id =  clientes.id)
        WHERE nuip = '&NUIP'
        ORDER BY valoracion;
-- 5556550891 - 6834216715
-- Consultar las firmas que tienen alguna especialidad de un abogado
SELECT nuip, areas.nombre AS Area, firmas.nit AS NIT, firmas.nombre AS Firma, departamento, municipio, direccion
    FROM abogados JOIN espAbog ON (nuip = abogados_nuip)
        JOIN espFirmas ON (espFirmas.areas_id = espAbog.areas_id)
        JOIN areas ON (espAbog.areas_id = areas.id)
        JOIN firmas ON (espFirmas.firmas_nit = firmas.nit)
        JOIN lugares ON (lugares.id = firmas.lugares_id)
    WHERE nuip = '&NUIP'
    ORDER BY departamento;
-- 6708477211

-- Consultar los hechos con sus respectivas pruebas de una demanda
SELECT hechos.id AS Hecho, hechos.fecha AS Fecha, hechos.descripcion AS Descripcion_Hecho,
    pruebas.id AS Prueba, tipo, pruebas.descripcion AS Descripcion_prueba
    FROM demandas JOIN hechos ON (demandas.id = demandas_id) 
                  LEFT JOIN pruebas ON (hechos.id = hechos_id)
    WHERE demandas.id = '&Id'
    ORDER BY Fecha DESC;
-- 583
-- Consultar informacion relacionada a las audiencias de un juez
SELECT audiencias.id AS Audiencia, fecha, juzgados.nombre AS Juzgado,
    departamento, municipio, direccion
FROM audiencias JOIN jueces ON (jueces_nuip = nuip)
                JOIN juzgados ON (juzgados_id = juzgados.id)
                JOIN lugares ON (lugares_id = lugares.id)
    WHERE jueces.nuip = '&NUIP'
    ORDER BY fecha DESC;
--  4123610951
-- Consultar informacion de las demandas que ha hecho un cliente
SELECT demandas.id, pretencion, demandas.fecha, estado, resultado, fallo, sentencias.fecha, nuip, nombre
    FROM demandas JOIN casos ON (demandas_id = demandas.id)
                  LEFT JOIN sentencias ON (casos.id = casos_id)
                  LEFT JOIN jueces ON (jueces.nuip = jueces_nuip)
    WHERE clientes_id = '&Id'
    ORDER BY demandas.fecha DESC;
-- 69

-- Número de procesos y calificaciones que llevan los abogados
SELECT nuip, Abogado, CASE WHEN Demandas IS NULL AND Asesorias IS NULL AND Contratos IS NULL THEN 0
                           WHEN Asesorias IS NULL AND Contratos IS NULL THEN Demandas
                           WHEN Demandas IS NULL AND Contratos IS NULL THEN Asesorias
                           WHEN Asesorias IS NULL AND Demandas IS NULL THEN Contratos
                           WHEN Demandas IS NULL THEN Contratos + Asesorias
                           WHEN Asesorias IS NULL THEN Contratos + Demandas
                           WHEN Contratos IS NULL THEN Asesorias + Demandas
                           ELSE Asesorias + Contratos + Demandas
                        END AS Procesos, Demandas, Asesorias, Contratos, calificacion_promedio, COUNT(perfiles_id) AS Calificaciones 
    FROM (SELECT nuip, abogados.nombre AS Abogado, Demandas, Asesorias, Contratos
                FROM abogados LEFT JOIN (SELECT abogados_nuip, COUNT(abogados_nuip) AS Demandas
                                            FROM clientes JOIN demandas ON (clientes_id = clientes.id)
                                            GROUP BY abogados_nuip) a ON (nuip = a.abogados_nuip)
                              LEFT JOIN (SELECT abogados_nuip, COUNT(abogados_nuip) AS Asesorias
                                            FROM abogados JOIN asesorias ON (abogados_nuip = nuip)
                                            GROUP BY abogados_nuip) b ON (nuip = b.abogados_nuip)
                              LEFT JOIN (SELECT abogados_nuip, COUNT(abogados_nuip) AS Contratos
                                            FROM abogados JOIN contratos ON (abogados_nuip = nuip)
                                            GROUP BY abogados_nuip) c ON (nuip = c.abogados_nuip)
                GROUP BY nuip, abogados.nombre, Demandas, Asesorias, Contratos) JOIN perfiles ON (perfiles.abogados_nuip = nuip)
                                                LEFT JOIN calificaciones ON (perfiles_id = perfiles.id)
    GROUP BY nuip, Abogado, Demandas, Asesorias, Contratos, calificacion_promedio
    ORDER BY Procesos DESC, Calificaciones DESC, calificacion_promedio DESC;
-- Firmas con su número de abogados y calificación promedio
SELECT nit, firmas.nombre AS Firma, COUNT(nit) AS Abogados, ROUND(AVG(calificacion_promedio), 1) AS CalificacionPromedio
    FROM firmas LEFT JOIN abogados ON (firmas.nit = firmas_nit)
                LEFT JOIN perfiles ON (abogados_nuip = nuip)
    GROUP BY nit, firmas.nombre
    ORDER BY Abogados DESC, CalificacionPromedio DESC;
-- Número de procesos que hay en los diferentes tipos de juzgados
SELECT CASE WHEN tipo = 'CI' THEN 'Civil'
            WHEN tipo = 'PE' THEN 'Penal'
            WHEN tipo = 'LA' THEN 'Laboral'
            WHEN tipo = 'PA' THEN 'Penales para adolescentes'
            WHEN tipo = 'FA' THEN 'Familiar'
            WHEN tipo = 'EP' THEN 'Ejecucion de penas'
            WHEN tipo = 'PC' THEN 'Pequeñas causas'
            WHEN tipo = 'CM' THEN 'Competencias multiple'
            WHEN tipo = 'ES' THEN 'Especializado'
            WHEN tipo = 'PR' THEN 'Promiscuo'
            ELSE 'Medidas de seguridad'
        END AS Tipos, CASE WHEN Audiencias IS NULL AND Demandas IS NULL THEN 0
                           WHEN Audiencias IS NULL THEN Demandas
                           WHEN Demandas IS NULL THEN Audiencias
                           ELSE Audiencias + Demandas
                      END AS Procesos, Audiencias, Demandas
    FROM juzgados LEFT JOIN (SELECT tipo AS tipoa, COUNT(tipo) AS Audiencias
                                            FROM juzgados JOIN audiencias ON (juzgados_id = juzgados.id)
                                            GROUP BY tipo) a ON (juzgados.tipo = a.tipoa)
                  LEFT JOIN (SELECT tipo AS tipob, COUNT(tipo) AS Demandas
                                            FROM juzgados JOIN demandas ON (juzgados_id = juzgados.id)
                                            GROUP BY tipo) b ON (juzgados.tipo = b.tipob)
    GROUP BY tipo, Audiencias, Demandas
    ORDER BY Procesos DESC;
-- Municipios con su número de procesos
SELECT departamento, municipio, CASE WHEN Demandas IS NULL AND Audiencias IS NULL AND Contratos IS NULL THEN 0
                           WHEN Audiencias IS NULL AND Contratos IS NULL THEN Demandas
                           WHEN Demandas IS NULL AND Contratos IS NULL THEN Audiencias
                           WHEN Audiencias IS NULL AND Demandas IS NULL THEN Contratos
                           WHEN Demandas IS NULL THEN Contratos + Audiencias
                           WHEN Audiencias IS NULL THEN Contratos + Demandas
                           WHEN Contratos IS NULL THEN Audiencias + Demandas
                           ELSE Audiencias + Contratos + Demandas
                        END AS Procesos, Demandas, Audiencias, Contratos
    FROM lugares LEFT JOIN (SELECT lugares_id AS ma, COUNT(municipio) AS Contratos
                                            FROM lugares JOIN contratos ON (lugares_id = lugares.id)
                                            GROUP BY lugares_id) a ON (lugares.id = a.ma)
                 LEFT JOIN (SELECT lugares_id AS mb, COUNT(municipio) AS Audiencias
                                            FROM lugares JOIN juzgados ON (lugares_id = lugares.id)
                                                            JOIN audiencias ON (juzgados.id = juzgados_id) 
                                            GROUP BY lugares_id) b ON (lugares.id = b.mb)
                 LEFT JOIN (SELECT lugares_id AS mc, COUNT(municipio) AS Demandas
                                            FROM lugares JOIN juzgados ON (lugares_id = lugares.id)
                                                            JOIN demandas ON (juzgados.id = juzgados_id) 
                                            GROUP BY lugares_id) c ON (lugares.id = c.mc)
    GROUP BY municipio, departamento, Demandas, Audiencias, Contratos
    ORDER BY Procesos DESC;
-- Consultar el número de procesos de los últimos meses
SELECT EXTRACT(year FROM fecha) AS Año, EXTRACT(month FROM fecha) AS Mes, SUM(Procesos) AS Procesos,
       SUM(Demandas) AS Demandas, SUM(Asesorias) AS ASesorias, SUM(Contratos) AS Contratos
       FROM (SELECT fecha, CASE WHEN Demandas IS NULL AND Asesorias IS NULL AND Contratos IS NULL THEN 0
                      WHEN Asesorias IS NULL AND Contratos IS NULL THEN Demandas
                           WHEN Demandas IS NULL AND Contratos IS NULL THEN Asesorias
                           WHEN Asesorias IS NULL AND Demandas IS NULL THEN Contratos
                           WHEN Demandas IS NULL THEN Contratos + Asesorias
                           WHEN Asesorias IS NULL THEN Contratos + Demandas
                           WHEN Contratos IS NULL THEN Asesorias + Demandas
                           ELSE Asesorias + Contratos + Demandas
                        END AS Procesos, Demandas, Asesorias, Contratos
    FROM (SELECT fecha as fecha, COUNT(fecha) AS Demandas FROM demandas GROUP BY fecha) a
          LEFT JOIN (SELECT fecha_firma, COUNT(fecha_firma) AS Contratos FROM contratos GROUP BY fecha_firma) b ON (a.fecha = b.fecha_firma)
          LEFT JOIN (SELECT fecha AS fechac, COUNT(fecha) AS ASesorias FROM asesorias GROUP BY fecha) c ON (a.fecha = c.fechac))
    WHERE fecha < current_date - EXTRACT(day FROM current_date) AND fecha > current_date - 365 - EXTRACT(day FROM current_date)
    GROUP BY EXTRACT(year FROM fecha), EXTRACT(month FROM fecha)
    ORDER BY EXTRACT(year FROM fecha) DESC, EXTRACT(month FROM fecha) DESC;