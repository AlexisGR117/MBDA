CREATE OR REPLACE TRIGGER TR_calificaciones_BI
BEFORE INSERT ON calificaciones
FOR EACH ROW
DECLARE
    promedio NUMBER;
    numero NUMBER;
    fecha DATE;
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM calificaciones;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM calificaciones;
        :NEW.id := mayor;
    END IF;
    SELECT COUNT(*) INTO numero FROM calificaciones
    WHERE perfiles_id = :NEW.perfiles_id;
    IF numero = 0 THEN
        UPDATE perfiles SET calificacion_promedio = :NEW.valoracion
        WHERE perfiles.id = :NEW.perfiles_id;
    ELSE
        SELECT (SUM(valoracion)+ :NEW.valoracion) / (numero + 1)
            INTO promedio FROM calificaciones
            WHERE perfiles_id = :NEW.perfiles_id;
        UPDATE perfiles SET calificacion_promedio = promedio
        WHERE perfiles.id = :NEW.perfiles_id;
    END IF;
    SELECT current_date INTO fecha FROM dual;
    :NEW.fecha := fecha;
END TR_calificaciones_BI;
/
CREATE OR REPLACE TRIGGER TR_firmas_BI
BEFORE INSERT ON firmas
FOR EACH ROW
DECLARE
    correos VARCHAR2(70);
BEGIN
    IF :NEW.correo IS NULL THEN
        SELECT CONCAT(REPLACE(REPLACE(REPLACE(:NEW.nombre, ' ', ''), '-', ''), ',', ''),
                    '@cuervogonzalez.com')
            INTO correos FROM dual;
        :NEW.correo := correos;
    END IF;
END TR_firmas_BI;
/
CREATE OR REPLACE TRIGGER TR_abogados_BI
BEFORE INSERT ON abogados
FOR EACH ROW
DECLARE
    correos VARCHAR2(60);
BEGIN
    IF :NEW.correo IS NULL THEN
        SELECT CONCAT(SUBSTR(REPLACE(:NEW.nombre, ' ', ''), 3),
                      CONCAT(:NEW.nuip, '@cuervogonzalez.com'))
            INTO correos FROM dual;
        :NEW.correo := correos;
    END IF;
END TR_abogados_BI;
/
CREATE OR REPLACE TRIGGER TR_solicitudes_BI
BEFORE INSERT ON solicitudes
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
    fecha DATE;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM solicitudes;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM solicitudes;
        :NEW.id := mayor;
    END IF;
    SELECT current_date INTO fecha FROM dual;
    :NEW.fecha_envio := fecha;
END TR_solicitudes_BI;
/
CREATE OR REPLACE TRIGGER TR_espAbog_BI
BEFORE INSERT ON espAbog
FOR EACH ROW
DECLARE
    especialidades NUMBER(1);
BEGIN
    SELECT COUNT(*) INTO especialidades FROM espAbog
        WHERE abogados_nuip = :NEW.abogados_nuip;
    IF especialidades = 5 THEN
        RAISE_APPLICATION_ERROR(-20001,
        'Un abogado solo puede tener como maximo 5 especialidades');
    END IF;
END TR_espAbog_BI;
/
CREATE OR REPLACE TRIGGER TR_perfiles_BI
BEFORE INSERT ON perfiles
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM perfiles;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM perfiles;
        :NEW.id := mayor;
    END IF;
    :NEW.calificacion_promedio := NULL;
END TR_perfiles_BI;
/
CREATE OR REPLACE TRIGGER TR_lugares_BI
BEFORE INSERT ON lugares
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM lugares;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM lugares;
        :NEW.id := mayor;
    END IF;
END TR_lugares_BI;
/
CREATE OR REPLACE TRIGGER TR_areas_BI
BEFORE INSERT ON areas
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM areas;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM areas;
        :NEW.id := mayor;
    END IF;
END TR_areas_BI;
/
CREATE OR REPLACE TRIGGER TR_estudios_BI
BEFORE INSERT ON estudios
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM estudios;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM estudios;
        :NEW.id := mayor;
    END IF;
END TR_estudios_BI;
/
CREATE OR REPLACE TRIGGER TR_asesorias_BI
BEFORE INSERT ON asesorias
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM asesorias;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM asesorias;
        :NEW.id := mayor;
    END IF;
END TR_asesorias_BI;
/
CREATE OR REPLACE TRIGGER TR_contratos_BI
BEFORE INSERT ON contratos
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM contratos;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM contratos;
        :NEW.id := mayor;
    END IF;
END TR_contratos_BI;
/
CREATE OR REPLACE TRIGGER TR_clientes_BI
BEFORE INSERT ON clientes
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
    correos VARCHAR2(60);
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM clientes;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM clientes;
        :NEW.id := mayor;
    END IF;
    IF :NEW.correo IS NULL THEN
        SELECT CONCAT(SUBSTR(REPLACE(:NEW.nombre, ' ', ''), 3),
                      CONCAT(:NEW.id, '@cuervogonzalez.com'))
            INTO correos FROM dual;
        :NEW.correo := correos;
    END IF;
END TR_clientes_BI;
/
CREATE OR REPLACE TRIGGER TR_lugares_BDU
BEFORE DELETE OR UPDATE ON lugares
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001,
    'No se puede actualizar o eliminar lugares');
END TR_lugares_BDU;
/
CREATE OR REPLACE TRIGGER TR_revisiones_BU
BEFORE UPDATE ON revisiones
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20002,
    'No se puede actualizar las revisiones');
END TR_revisiones_BU;
/
CREATE OR REPLACE TRIGGER TR_clientes_BU
BEFORE UPDATE ON clientes
FOR EACH ROW
BEGIN
    :NEW.id := :OLD.id;
    :NEW.nombre := :OLD.nombre;
END TR_clientes_BU;
/
CREATE OR REPLACE TRIGGER TR_personasNaturales_BU
BEFORE UPDATE ON personasNaturales
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20003,
    'No se puede actualizar las personas naturales');
END TR_personasNaturales_BU;
/
CREATE OR REPLACE TRIGGER TR_personasJuridicas_BU
BEFORE UPDATE ON personasJuridicas
FOR EACH ROW
BEGIN
    :NEW.nit := :OLD.nit;
    :NEW.clientes_id := :OLD.clientes_id;
END TR_personasJuridicas_BDU;
/
CREATE OR REPLACE TRIGGER TR_firmas_BU
BEFORE UPDATE ON firmas
FOR EACH ROW
BEGIN
    :NEW.nit := :OLD.nit;
END TR_firmas_BU;
/
CREATE OR REPLACE TRIGGER TR_espFirmas_BU
BEFORE UPDATE ON espFirmas
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20005,
    'No se puede actualizar las especialidades de las firmas');
END TR_espFirmas_BU;
/
CREATE OR REPLACE TRIGGER TR_areas_BDU
BEFORE DELETE OR UPDATE ON areas
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20006,
        'No se puede eliminar las areas');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.nombre := :OLD.nombre;
    END IF;
END TR_areas_BDU;
/
CREATE OR REPLACE TRIGGER TR_abogados_BU
BEFORE UPDATE ON abogados
FOR EACH ROW
BEGIN
    :NEW.nuip := :OLD.nuip;
    :NEW.fecha_nacimiento := :OLD.fecha_nacimiento;
    :NEW.nombre := :OLD.nombre;
END TR_abogados_BU;
/
CREATE OR REPLACE TRIGGER TR_perfiles_BU
BEFORE UPDATE ON perfiles
FOR EACH ROW
BEGIN
    :NEW.id := :OLD.id;
    :NEW.abogados_nuip := :OLD.abogados_nuip ;
END TR_perfiles_BU;
/
CREATE OR REPLACE TRIGGER TR_tarjetasProfesionales_BU
BEFORE UPDATE ON tarjetasProfesionales
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20007,
    'No se puede actualizar las tarjetas profesionales');
END TR_tarjetasProfesionales_BU;
/
CREATE OR REPLACE TRIGGER TR_espAbog_BU
BEFORE UPDATE ON espAbog
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20008,
    'No se puede actualizar las especialidades de los abogados');
END TR_espAbog_BU;
/
CREATE OR REPLACE TRIGGER TR_estudios_BU
BEFORE UPDATE ON estudios-- 
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20009,
    'No se puede actualizar los estudios');
END TR_estudios_BU;
/
CREATE OR REPLACE TRIGGER TR_calificaciones_BU
BEFORE UPDATE ON calificaciones
FOR EACH ROW
DECLARE
    fechas DATE;
BEGIN
    :NEW.id := :OLD.id;
    SELECT current_date INTO fechas FROM dual;
    :NEW.fecha := fechas;
    :NEW.clientes_id := :OLD.clientes_id;    
END TR_calificaciones_BU;
/
CREATE OR REPLACE TRIGGER TR_asesorias_BDU
BEFORE DELETE OR UPDATE ON asesorias
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20010,
        'No se puede eliminar las asesorias');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.abogados_nuip := :OLD.abogados_nuip;
    END IF;
END TR_asesorias_BU;
/
CREATE OR REPLACE TRIGGER TR_solicitudes_BU
BEFORE UPDATE ON solicitudes
FOR EACH ROW
DECLARE
    fechas DATE;
BEGIN
    :NEW.id := :OLD.id;
    SELECT current_date INTO fechas FROM dual;
    :NEW.fecha_envio := fechas;
    :NEW.clientes_id := :OLD.clientes_id;    
END TR_solicitudes_BU;
/
CREATE OR REPLACE TRIGGER TR_contratos_BDU
BEFORE DELETE OR UPDATE ON contratos
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20011,
        'No se puede eliminar las contratos');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.fecha_firma := :OLD.fecha_firma;
        :NEW.clientes_id := :OLD.clientes_id;
        :NEW.abogados_nuip := :OLD.abogados_nuip;
    END IF;
END TR_contratos_BDU;
/
CREATE OR REPLACE TRIGGER TR_demandas_BI
BEFORE INSERT ON demandas
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM demandas;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM demandas;
        :NEW.id := mayor;
    END IF;
END TR_demandas_BI;
/
CREATE OR REPLACE TRIGGER TR_hechos_BI
BEFORE INSERT ON hechos
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM hechos;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM hechos;
        :NEW.id := mayor;
    END IF;
END TR_hechos_BI;
/
CREATE OR REPLACE TRIGGER TR_pruebas_BI
BEFORE INSERT ON pruebas
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM pruebas;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM pruebas;
        :NEW.id := mayor;
    END IF;
END TR_pruebas_BI;
/
CREATE OR REPLACE TRIGGER TR_fundamentosDerechos_BI
BEFORE INSERT ON fundamentosDerechos
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM fundamentosDerechos;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM fundamentosDerechos;
        :NEW.id := mayor;
    END IF;
END TR_fundamentosDerechos_BI;
/
CREATE OR REPLACE TRIGGER TR_casos_BI
BEFORE INSERT ON casos
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM casos;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM casos;
        :NEW.id := mayor;
    END IF;
END TR_casos_BI;
/
CREATE OR REPLACE TRIGGER TR_sentencias_BI
BEFORE INSERT ON sentencias
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM sentencias;
    IF vacio = 1 THEN 
        :NEW.numero := vacio;
    ELSE 
        SELECT MAX(numero) + 1 INTO mayor FROM sentencias;
        :NEW.numero := mayor;
    END IF;
END TR_sentencias_BI;
/
CREATE OR REPLACE TRIGGER TR_juzgados_BI
BEFORE INSERT ON juzgados
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM juzgados;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM juzgados;
        :NEW.id := mayor;
    END IF;
END TR_juzgados_BI;
/
CREATE OR REPLACE TRIGGER TR_audiencias_BI
BEFORE INSERT ON audiencias
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM audiencias;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM audiencias;
        :NEW.id := mayor;
    END IF;
END TR_audiencias_BI;
/
CREATE OR REPLACE TRIGGER TR_demandas_BDU
BEFORE DELETE OR UPDATE ON demandas
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20006,
        'No se puede eliminar las demandas');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.demandado := :OLD.demandado;
        :NEW.clientes_id := :OLD.clientes_id;
    END IF;
END TR_demandas_BDU;
/
CREATE OR REPLACE TRIGGER TR_hechos_BU
BEFORE UPDATE ON hechos
FOR EACH ROW
BEGIN
    :NEW.id := :OLD.id;
    :NEW.lugares_id := :OLD.lugares_id;
    :NEW.demandas_id := :OLD.demandas_id;
END TR_hechos_BDU;
/
CREATE OR REPLACE TRIGGER TR_pruebas_BU
BEFORE UPDATE ON pruebas
FOR EACH ROW
BEGIN
    :NEW.id := :OLD.id;
    :NEW.hechos_id := :OLD.hechos_id;
END TR_pruebas_BDU;
/
CREATE OR REPLACE TRIGGER TR_fundamentosDerechos_BDU
BEFORE DELETE OR UPDATE ON fundamentosDerechos
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20006,
        'No se puede eliminar las fundamentos de derechos');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.norma_juridica := :OLD.norma_juridica;
    END IF;
END TR_fundamentosDerechos_BDU;
/
CREATE OR REPLACE TRIGGER TR_demFun_BU
BEFORE UPDATE ON demFun
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20006,
        'No se puede actualiza los fundamentos de derechos de una demanda');
END TR_demFun_BU;
/
CREATE OR REPLACE TRIGGER TR_casos_BDU
BEFORE DELETE OR UPDATE ON casos
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20006,
        'No se puede eliminar los casos');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.demandas_id := :OLD.demandas_id;
    END IF;
END TR_casos_BDU;
/
CREATE OR REPLACE TRIGGER TR_sentencias_BDU
BEFORE DELETE OR UPDATE ON sentencias
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20006,
    'No se puede eliminar o actualizar las sentencias');
END TR_sentencias_BDU;
/
CREATE OR REPLACE TRIGGER TR_juzgados_BDU
BEFORE DELETE OR UPDATE ON juzgados
FOR EACH ROW
BEGIN
    IF DELETING THEN
        RAISE_APPLICATION_ERROR(-20006,
        'No se puede eliminar los juzgados');
    ELSIF UPDATING THEN
        :NEW.id := :OLD.id;
        :NEW.tipo := :OLD.tipo;
    END IF;
END TR_juzgados_BDU;
/
CREATE OR REPLACE TRIGGER TR_jueces_BU
BEFORE UPDATE ON jueces
FOR EACH ROW
BEGIN
    :NEW.nuip := :OLD.nuip;
    :NEW.nombre := :OLD.nombre;
END TR_jueces_BDU;
/
CREATE OR REPLACE TRIGGER TR_audiencias_BU
BEFORE UPDATE ON audiencias
FOR EACH ROW
BEGIN
    :NEW.id := :OLD.id;
    :NEW.juzgados_id := :OLD.juzgados_id;
END TR_audiencias_BDU;