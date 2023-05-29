CREATE INDEX IFirmas
    ON firmas(lugares_id);
CREATE INDEX IAbogados
    ON abogados(lugares_id);
CREATE INDEX IPerfiles1
    ON perfiles(años_experiencia DESC);
CREATE INDEX IPerfiles2
    ON perfiles(tarifa_minima);
CREATE INDEX IPerfiles3
    ON perfiles(calificacion_promedio DESC);
CREATE INDEX ISolicitudes
    ON solicitudes(fecha_envio ASC);
CREATE INDEX IContratos
    ON contratos(fecha_firma ASC);
   
CREATE INDEX ILugares1
    ON lugares(departamento);
CREATE INDEX ILugares2
    ON lugares(municipio);   
    
CREATE INDEX IDemandas1
    ON demandas(clientes_id);
CREATE INDEX IDemandas2
    ON demandas(fecha DESC);
CREATE INDEX IHechos1
    ON hechos(fecha DESC);
CREATE INDEX IHechos2
    ON hechos(demandas_id);
CREATE INDEX IPruebas
    ON pruebas(hechos_id);
CREATE INDEX IAudiencias
    ON audiencias(fecha DESC);
CREATE INDEX ISentencias
    ON sentencias(jueces_nuip);