ALTER TABLE calificaciones ADD CONSTRAINT UK_calificaciones_comentario
    UNIQUE (comentario);
ALTER TABLE lugares ADD CONSTRAINT UK_lugares_dirrecion
    UNIQUE (direccion); 
ALTER TABLE firmas ADD CONSTRAINT UK_firmas_nombre
    UNIQUE (nombre);
ALTER TABLE firmas ADD CONSTRAINT UK_firmas_telefono
    UNIQUE (telefono);
ALTER TABLE firmas ADD CONSTRAINT UK_firmas_correo
    UNIQUE (correo);
ALTER TABLE areas ADD CONSTRAINT UK_areas_nombre
    UNIQUE (nombre);
ALTER TABLE abogados ADD CONSTRAINT UK_abogados_telefono
    UNIQUE (telefono);
ALTER TABLE abogados ADD CONSTRAINT UK_abogados_correo
    UNIQUE (correo);    
ALTER TABLE perfiles ADD CONSTRAINT UK_perfil_descripcion
    UNIQUE (descripcion);    
ALTER TABLE clientes ADD CONSTRAINT UK_clientes_telefono
    UNIQUE (telefono);
ALTER TABLE clientes ADD CONSTRAINT UK_clientes_correo
    UNIQUE (correo);
ALTER TABLE juzgados ADD CONSTRAINT UK_juzgados_correo
    UNIQUE (correo);
ALTER TABLE juzgados ADD CONSTRAINT UK_juzgados_nombre
    UNIQUE (nombre);
ALTER TABLE juzgados ADD CONSTRAINT UK_juzgados_telefono
    UNIQUE (telefono);
ALTER TABLE jueces ADD CONSTRAINT UK_jueces_telefono
    UNIQUE (telefono);
ALTER TABLE jueces ADD CONSTRAINT UK_jueces_correo
    UNIQUE (correo);        
ALTER TABLE fundamentosDerechos ADD CONSTRAINT UK_funDerechos_norma_juridica
    UNIQUE (norma_juridica);
ALTER TABLE tarjetasProfesionales ADD CONSTRAINT UK_tarProf_abogados_nuip
    UNIQUE (abogados_nuip);
ALTER TABLE personasNaturales ADD CONSTRAINT UK_persNaturales_clientes_id
    UNIQUE (clientes_id); 
ALTER TABLE personasJuridicas ADD CONSTRAINT UK_persJuridicas_clientes_id
    UNIQUE (clientes_id);
ALTER TABLE perfiles ADD CONSTRAINT UK_perfil_abogados_nuip
    UNIQUE (abogados_nuip);
ALTER TABLE sentencias ADD CONSTRAINT UK_sentencias_casos_id
    UNIQUE (casos_id);
ALTER TABLE casos ADD CONSTRAINT UK_casos_demandas_id
    UNIQUE (demandas_id);