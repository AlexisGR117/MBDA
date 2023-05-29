ALTER TABLE espFirmas ADD CONSTRAINT FK_espFirmas_firmas
    FOREIGN KEY (firmas_nit) REFERENCES firmas(nit) ON DELETE CASCADE;
ALTER TABLE abogados ADD CONSTRAINT FK_abogados_firmas
    FOREIGN KEY (firmas_nit) REFERENCES firmas(nit) ON DELETE SET NULL;

ALTER TABLE solicitudes ADD CONSTRAINT FK_solicitudes_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE CASCADE;
ALTER TABLE revisiones ADD CONSTRAINT FK_revisiones_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE CASCADE;
ALTER TABLE personasNaturales ADD CONSTRAINT FK_personasNaturales_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE CASCADE;
ALTER TABLE personasJuridicas ADD CONSTRAINT FK_personasJuridicas_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE CASCADE;
ALTER TABLE calificaciones ADD CONSTRAINT FK_calificaciones_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE CASCADE;
ALTER TABLE asesorias ADD CONSTRAINT FK_asesorias_clientes
    FOREIGN KEY (clientes_id) REFERENCES clientes(id) ON DELETE SET NULL;
    
ALTER TABLE tarjetasProfesionales ADD CONSTRAINT FK_tarProfesionales_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE CASCADE;
ALTER TABLE espAbog ADD CONSTRAINT FK_espAbog_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE CASCADE;
ALTER TABLE solicitudes ADD CONSTRAINT FK_solicitudes_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE CASCADE;
ALTER TABLE perfiles ADD CONSTRAINT FK_perfiles_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE CASCADE;
ALTER TABLE asesorias ADD CONSTRAINT FK_asesorias_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE SET NULL;
ALTER TABLE clientes ADD CONSTRAINT FK_clientes_abogados
    FOREIGN KEY (abogados_nuip) REFERENCES abogados(nuip) ON DELETE SET NULL;

ALTER TABLE revisiones ADD CONSTRAINT FK_revisiones_perfiles
    FOREIGN KEY (perfiles_id) REFERENCES perfiles(id) ON DELETE CASCADE;
ALTER TABLE calificaciones ADD CONSTRAINT FK_calificaciones_perfiles
    FOREIGN KEY (perfiles_id) REFERENCES perfiles(id) ON DELETE CASCADE;
ALTER TABLE estudios ADD CONSTRAINT FK_estudios_perfiles
    FOREIGN KEY (perfiles_id) REFERENCES perfiles(id) ON DELETE CASCADE;
    
ALTER TABLE pruebas ADD CONSTRAINT FK_pruebas_hechos
    FOREIGN KEY (hechos_id) REFERENCES hechos(id) ON DELETE CASCADE;
    
