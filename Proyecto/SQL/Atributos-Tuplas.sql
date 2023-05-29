-- TCalificacion
ALTER TABLE calificaciones ADD CONSTRAINT CK_calificaciones_valoracion
    CHECK (valoracion BETWEEN 0 AND 5);
ALTER TABLE perfiles ADD CONSTRAINT CK_perfiles_calif_promedio
    CHECK (calificacion_promedio BETWEEN 0 AND 5);
-- TCorreo
ALTER TABLE abogados ADD CONSTRAINT CK_abogados_correo
    CHECK (REGEXP_LIKE(correo, '^[[:graph:]]+@[[:graph:]]+[.][[:graph:]]+'));
ALTER TABLE clientes ADD CONSTRAINT CK_clientes_correo
    CHECK (REGEXP_LIKE(correo, '^[[:graph:]]+@[[:graph:]]+[.][[:graph:]]+'));
ALTER TABLE jueces ADD CONSTRAINT CK_jueces_correo
    CHECK (REGEXP_LIKE(correo, '^[[:graph:]]+@[[:graph:]]+[.][[:graph:]]+'));
ALTER TABLE firmas ADD CONSTRAINT CK_firmas_correo
    CHECK (REGEXP_LIKE(correo, '^[[:graph:]]+@[[:graph:]]+[.][[:graph:]]+'));
ALTER TABLE juzgados ADD CONSTRAINT CK_juzgados_correo
    CHECK (REGEXP_LIKE(correo, '^[[:graph:]]+@[[:graph:]]+[.][[:graph:]]+'));
-- TDuracion
ALTER TABLE asesorias ADD CONSTRAINT CK_asesorias_duracion
    CHECK (duracion BETWEEN 0 AND 240);
ALTER TABLE audiencias ADD CONSTRAINT CK_audiencias_duracion
    CHECK (duracion BETWEEN 0 AND 240);
-- TEstado
ALTER TABLE casos ADD CONSTRAINT CK_casos_estado
    CHECK (estado IN ('Activo', 'Terminado', 'Cancelado'));
-- TJuzgado
ALTER TABLE juzgados ADD CONSTRAINT CK_juzgados_tipo
    CHECK (tipo IN ('CI', 'PE', 'LA', 'PA', 'FA', 'EP', 'PC',
            'CM', 'ES', 'PR', 'MS'));
-- TMoneda
ALTER TABLE asesorias ADD CONSTRAINT CK_asesorias_precio
    CHECK (precio >= 0);
ALTER TABLE contratos ADD CONSTRAINT CK_contratos_remuneracion
    CHECK (remuneracion >= 0);
ALTER TABLE demandas ADD CONSTRAINT CK_demandas_cuantia
    CHECK (cuantia >= 0);
ALTER TABLE perfiles ADD CONSTRAINT CK_perfiles_tarifa_minima
    CHECK (tarifa_minima >= 0);
-- TNit
ALTER TABLE personasJuridicas ADD CONSTRAINT CK_personasJuridicas_nit
    CHECK (REGEXP_LIKE(nit, '^\d{9}-\d{1}'));
ALTER TABLE firmas ADD CONSTRAINT CK_firmas_nit
    CHECK (REGEXP_LIKE(nit, '^\d{9}-\d{1}'));
-- TNombre
ALTER TABLE jueces ADD CONSTRAINT CK_jueces_nombre
    CHECK (REGEXP_LIKE(nombre, '[ ]'));
ALTER TABLE abogados ADD CONSTRAINT CK_abogados_nombre
    CHECK (REGEXP_LIKE(nombre, '[ ]'));
ALTER TABLE clientes ADD CONSTRAINT CK_clientes_nombre
    CHECK (REGEXP_LIKE(nombre, '[ ]'));
-- TNuip
ALTER TABLE personasNaturales ADD CONSTRAINT CK_personasNaturales_nuip
    CHECK (REGEXP_LIKE(nuip, '^\d{10}'));
ALTER TABLE jueces ADD CONSTRAINT CK_jueces_nuip
    CHECK (REGEXP_LIKE(nuip, '^\d{10}'));
ALTER TABLE abogados ADD CONSTRAINT CK_abogados_nuip
    CHECK (REGEXP_LIKE(nuip, '^\d{10}'));
-- TPrueba
ALTER TABLE pruebas ADD CONSTRAINT CK_pruebas_tipo
    CHECK (tipo IN ('INP', 'INT', 'DPU', 'DPR', 'DIP', 'REJ'));
-- TResultado
ALTER TABLE casos ADD CONSTRAINT CK_casos_resultado
    CHECK (resultado IN ('Ganado', 'Perdido'));
-- TTelefono
ALTER TABLE jueces ADD CONSTRAINT CK_jueces_telefono
    CHECK (REGEXP_LIKE(telefono, '^\d{10}'));
ALTER TABLE clientes ADD CONSTRAINT CK_clientes_telefono
    CHECK (REGEXP_LIKE(telefono, '^\d{10}'));
ALTER TABLE juzgados ADD CONSTRAINT CK_juzgados_telefono
    CHECK (REGEXP_LIKE(telefono, '^\d{10}'));
ALTER TABLE abogados ADD CONSTRAINT CK_abogados_telefono
    CHECK (REGEXP_LIKE(telefono, '^\d{10}'));
ALTER TABLE firmas ADD CONSTRAINT CK_firmas_telefono
    CHECK (REGEXP_LIKE(telefono, '^\d{10}'));