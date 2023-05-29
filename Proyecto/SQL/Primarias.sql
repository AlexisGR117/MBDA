ALTER TABLE lugares ADD CONSTRAINT PK_lugares
    PRIMARY KEY (id);   
ALTER TABLE abogados ADD CONSTRAINT PK_abogados
    PRIMARY KEY (nuip);
ALTER TABLE clientes ADD CONSTRAINT PK_clientes
    PRIMARY KEY (id);
ALTER TABLE revisiones ADD CONSTRAINT PK_revisiones
    PRIMARY KEY (perfiles_id, clientes_id);
ALTER TABLE tarjetasProfesionales ADD CONSTRAINT PK_tarjetasProfesionales
    PRIMARY KEY (numero);
ALTER TABLE areas ADD CONSTRAINT PK_areas
    PRIMARY KEY (id);
ALTER TABLE firmas ADD CONSTRAINT PK_firmas
    PRIMARY KEY (nit);
ALTER TABLE asesorias ADD CONSTRAINT PK_asesorias
    PRIMARY KEY (id);
ALTER TABLE estudios ADD CONSTRAINT PK_estudios
    PRIMARY KEY (id);
ALTER TABLE solicitudes ADD CONSTRAINT PK_solicitudes
    PRIMARY KEY (id);
ALTER TABLE perfiles ADD CONSTRAINT PK_perfiles
    PRIMARY KEY (id);
ALTER TABLE calificaciones ADD CONSTRAINT PK_calificaciones
    PRIMARY KEY (id);
ALTER TABLE contratos ADD CONSTRAINT PK_contratos
    PRIMARY KEY (id);
ALTER TABLE espAbog ADD CONSTRAINT PK_espAbog
    PRIMARY KEY (abogados_nuip, areas_id);
ALTER TABLE espFirmas ADD CONSTRAINT PK_espFirmas
    PRIMARY KEY (firmas_nit, areas_id);
ALTER TABLE personasJuridicas ADD CONSTRAINT PK_personasJuridicas
    PRIMARY KEY (nit);
ALTER TABLE personasNaturales ADD CONSTRAINT PK_personasNaturales
    PRIMARY KEY (nuip);
ALTER TABLE demandas ADD CONSTRAINT PK_demandas
    PRIMARY KEY (id);
ALTER TABLE hechos ADD CONSTRAINT PK_hechos
    PRIMARY KEY (id);
ALTER TABLE juzgados ADD CONSTRAINT PK_juzgados
    PRIMARY KEY (id);
ALTER TABLE casos ADD CONSTRAINT PK_casos
    PRIMARY KEY (id);
ALTER TABLE sentencias ADD CONSTRAINT PK_sentencias
    PRIMARY KEY (numero);
ALTER TABLE audiencias ADD CONSTRAINT PK_audiencias
    PRIMARY KEY (id);
ALTER TABLE pruebas ADD CONSTRAINT PK_pruebas
    PRIMARY KEY (id);
ALTER TABLE jueces ADD CONSTRAINT PK_jueces
    PRIMARY KEY (nuip);
ALTER TABLE fundamentosDerechos ADD CONSTRAINT PK_fundamentosDerechos
    PRIMARY KEY (id);
ALTER TABLE demFun ADD CONSTRAINT PK_demFun
    PRIMARY KEY (demandas_id, fundamentosDerechos_id);