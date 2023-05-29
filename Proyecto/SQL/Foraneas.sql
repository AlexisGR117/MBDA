ALTER TABLE firmas ADD CONSTRAINT FK_firmas_lugares
    FOREIGN KEY (lugares_id) REFERENCES lugares(id);
ALTER TABLE abogados ADD CONSTRAINT FK_abogados_lugares
    FOREIGN KEY (lugares_id) REFERENCES lugares(id);
ALTER TABLE espFirmas ADD CONSTRAINT FK_espFirmas_areas
    FOREIGN KEY (areas_id) REFERENCES areas(id);
ALTER TABLE espAbog ADD CONSTRAINT FK_espAbog_areas
    FOREIGN KEY (areas_id) REFERENCES areas(id);
ALTER TABLE contratos ADD CONSTRAINT FK_contratos_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip);
ALTER TABLE contratos ADD CONSTRAINT FK_contratos_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id);
ALTER TABLE contratos ADD CONSTRAINT FK_contratos_lugares
    FOREIGN KEY (lugares_id) REFERENCES lugares(id);
ALTER TABLE juzgados ADD CONSTRAINT FK_juzgados_lugares
    FOREIGN KEY (lugares_id) REFERENCES lugares(id);
ALTER TABLE demandas ADD CONSTRAINT FK_demandas_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id);
ALTER TABLE demandas ADD CONSTRAINT FK_demandas_clientes_2
    FOREIGN KEY (demandado) REFERENCES clientes(id);
ALTER TABLE demandas ADD CONSTRAINT FK_demandas_juzgados
    FOREIGN KEY (juzgados_id) REFERENCES juzgados(id);
ALTER TABLE casos ADD CONSTRAINT FK_casos_demandas
    FOREIGN KEY (demandas_id) REFERENCES demandas(id); 
ALTER TABLE hechos ADD CONSTRAINT FK_hechos_lugares
    FOREIGN KEY (lugares_id) REFERENCES lugares(id);
ALTER TABLE hechos ADD CONSTRAINT FK_hechos_demandas
    FOREIGN KEY (demandas_id) REFERENCES demandas(id);
ALTER TABLE sentencias ADD CONSTRAINT FK_sentencias_casos
    FOREIGN KEY (casos_id) REFERENCES casos(id);
ALTER TABLE sentencias ADD CONSTRAINT FK_sentencias_jueces
    FOREIGN KEY (jueces_nuip) REFERENCES jueces(nuip);
ALTER TABLE demFun ADD CONSTRAINT FK_demFun_demandas
    FOREIGN KEY (demandas_id) REFERENCES demandas(id);
ALTER TABLE demFun ADD CONSTRAINT FK_demFun_fundamentosDerechos
    FOREIGN KEY (fundamentosDerechos_id) REFERENCES fundamentosDerechos(id);
ALTER TABLE audiencias ADD CONSTRAINT FK_audiencias_jueces
    FOREIGN KEY (jueces_nuip) REFERENCES jueces(nuip);
ALTER TABLE audiencias ADD CONSTRAINT FK_audicencas_juzgados
    FOREIGN KEY (juzgados_id) REFERENCES juzgados(id);