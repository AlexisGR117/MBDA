CREATE OR REPLACE PACKAGE PC_abogados IS
    PROCEDURE ad_calificacion (xId IN NUMBER, xComentario IN VARCHAR2, xValoracion IN NUMBER,
        xFecha IN DATE, xClientes_id IN NUMBER, xPerfiles_id IN NUMBER);
    PROCEDURE up_calificacion (xId IN NUMBER, xComentario IN VARCHAR2, xValoracion IN NUMBER,
        xFecha IN DATE, xPerfiles_id IN NUMBER);
    PROCEDURE de_calificacion (xId IN NUMBER);
    PROCEDURE ad_abogado (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xNombre IN VARCHAR2, xFecha_nacimiento IN DATE, xLugares_id IN NUMBER, xFirmas_nit IN VARCHAR2);
    PROCEDURE up_abogado (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xLugares_id IN NUMBER, xFirmas_nit IN VARCHAR2);
    PROCEDURE de_abogado (xNuip IN VARCHAR2);
    PROCEDURE ad_espAbog (xAbogados_nuip IN VARCHAR2, xAreas_id IN NUMBER);
    PROCEDURE de_espAbog (xAbogados_nuip IN VARCHAR2, xAreas_id IN NUMBER);
    PROCEDURE ad_perfil (xId IN NUMBER, xDescripcion IN VARCHAR2, xAños_experiencia IN NUMBER,
        xTarifa_minima IN NUMBER, xCalificacion_promedio IN NUMBER, xAbogados_nuip IN VARCHAR2);
    PROCEDURE up_perfil (xId IN NUMBER, xDescripcion IN VARCHAR2, xAños_experiencia IN NUMBER,
        xTarifa_minima IN NUMBER, xCalificacion_promedio IN NUMBER);
    PROCEDURE de_perfil (xId IN NUMBER);    
    PROCEDURE ad_estudio(xId IN NUMBER, xTitulo IN VARCHAR2, xUniversidad IN VARCHAR2, 
        xFecha_inicio IN DATE, xFecha_final IN DATE, xPerfiles_id IN NUMBER);
    PROCEDURE de_estudio (xId IN NUMBER);
    PROCEDURE ad_tarjetaProfesional(xNumero IN VARCHAR2, xFecha_expedicion IN DATE,
        xFecha_grado IN DATE, xUniversidad IN VARCHAR2, xConsejo_seccional IN VARCHAR2, 
        xAbogados_nuip IN VARCHAR2);
    FUNCTION co_abogado (xArea IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION co_calificacion (xNuip IN VARCHAR2) RETURN SYS_REFCURSOR;
END PC_abogados;
/
CREATE OR REPLACE PACKAGE PC_asesorias IS
    PROCEDURE ad_asesoria (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha IN DATE,
        xDuracion IN NUMBER, xPrecio IN NUMBER, xAbogados_nuip IN VARCHAR2, xClientes_id IN NUMBER);
    PROCEDURE up_asesoria (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha IN DATE,
        xDuracion IN NUMBER, xPrecio IN NUMBER, xClientes_id IN NUMBER);
END PC_asesorias;
/
CREATE OR REPLACE PACKAGE PC_lugares IS
    PROCEDURE ad_lugar (xId IN NUMBER, xDepartamento IN VARCHAR2, xMunicipio IN VARCHAR2,
        xDireccion IN VARCHAR2);
END PC_lugares;
/
CREATE OR REPLACE PACKAGE PC_areas IS
    PROCEDURE ad_area (xId IN NUMBER, xNombre IN VARCHAR2, xDescripcion IN VARCHAR2);
    PROCEDURE up_area (xId IN NUMBER, xDescripcion IN VARCHAR2);
END PC_areas;
/
CREATE OR REPLACE PACKAGE PC_firmas IS
    PROCEDURE ad_firma (xNit IN VARCHAR2, xNombre IN VARCHAR, xTelefono IN VARCHAR, 
        xCorreo IN VARCHAR2, xLugares_id IN NUMBER);
    PROCEDURE up_firma (xNit IN VARCHAR2, xNombre IN VARCHAR, xTelefono IN VARCHAR, 
        xCorreo IN VARCHAR2, xLugares_id IN NUMBER);
    PROCEDURE de_firma (xNit IN VARCHAR2);
    PROCEDURE ad_espFirma (xFirmas_nit IN VARCHAR2, xAreas_id IN NUMBER);
    PROCEDURE de_espFirma (xFirmas_nit IN VARCHAR2, xAreas_id IN NUMBER);
    FUNCTION co_firma (xNuip IN VARCHAR2) RETURN SYS_REFCURSOR;
END PC_firmas;
/
CREATE OR REPLACE PACKAGE PC_contratos IS
    PROCEDURE ad_contrato (xId IN NUMBER, xFecha_firma IN DATE, xDescripcion IN VARCHAR2,
        xForma_pago IN VARCHAR2, xRemuneracion IN NUMBER, xClientes_id IN NUMBER,
        xAbogados_nuip IN VARCHAR, xLugares_id IN NUMBER);
    PROCEDURE up_contrato (xId IN NUMBER, xDescripcion IN VARCHAR2, xForma_pago IN VARCHAR2,
        xRemuneracion IN NUMBER, xLugares_id IN NUMBER);
END PC_contratos;
/
CREATE OR REPLACE PACKAGE PC_clientes IS
    PROCEDURE ad_cliente (xId IN NUMBER, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2, xAbogados_nuip IN VARCHAR2);
    PROCEDURE up_cliente (xId IN NUMBER, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xAbogados_nuip IN VARCHAR2);
    PROCEDURE de_cliente (xId IN NUMBER);
    PROCEDURE ad_personaNatural (xNuip IN VARCHAR2, xFecha_nacimiento IN DATE, xClientes_id IN NUMBER);
    PROCEDURE ad_personaJuridica (xNit IN VARCHAR2, xRazon_social IN VARCHAR2, xClientes_id IN NUMBER);
    PROCEDURE up_personaJuridica (xNit IN VARCHAR2, xRazon_social IN VARCHAR2);
END PC_clientes;
/
CREATE OR REPLACE PACKAGE PC_solicitudes IS
    PROCEDURE ad_solicitud (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha_envio IN DATE,
        xClientes_id IN NUMBER, xAbogados_nuip IN VARCHAR2);
    PROCEDURE up_solicitud (xId IN NUMBER, xDescripcion IN VARCHAR2, xAbogados_nuip IN VARCHAR2);
    PROCEDURE de_solicitud (xId IN NUMBER);
END PC_solicitudes;
/
CREATE OR REPLACE PACKAGE PC_demandas IS
    PROCEDURE ad_demanda (xId IN NUMBER, xDemandado IN NUMBER, xPretencion IN VARCHAR2,
        xCuantia IN NUMBER, xFecha IN DATE, xClientes_id IN NUMBER, xJuzgados_id IN NUMBER);
    PROCEDURE up_demanda (xId IN NUMBER, xPretencion IN VARCHAR2, xCuantia IN NUMBER,
        xFecha IN DATE, xJuzgados_id IN NUMBER);
    PROCEDURE ad_hecho (xId IN NUMBER, xLugares_id IN NUMBER, xDemandas_id IN NUMBER,
        xFecha IN DATE, xDescripcion IN VARCHAR2);
    PROCEDURE up_hecho (xId IN NUMBER, xFecha IN DATE, xDescripcion IN VARCHAR2);
    PROCEDURE de_hecho (xId IN NUMBER);
    PROCEDURE ad_prueba (xId IN NUMBER, xTipo IN VARCHAR2, xDescripcion IN VARCHAR2,
        xMedio IN VARCHAR2, xHechos_id IN NUMBER);
    PROCEDURE up_prueba (xId IN NUMBER, xTipo IN VARCHAR2, xDescripcion IN VARCHAR2,
        xMedio IN VARCHAR2);
    PROCEDURE de_prueba (xId IN NUMBER);
    PROCEDURE ad_fundamentoDerecho (xId IN NUMBER, xNorma_juridica IN VARCHAR2, xDescripcion IN VARCHAR2);
    PROCEDURE up_fundamentoDerecho (xId IN NUMBER, xDescripcion IN VARCHAR2);
    PROCEDURE ad_demFun (xDemandas_id IN NUMBER, xFundamentosDerechos_id IN NUMBER);
    PROCEDURE de_demFun (xDemandas_id IN NUMBER, xFundamentosDerechos_id IN NUMBER);
    PROCEDURE ad_caso (xId IN NUMBER, xEstado IN VARCHAR2, xResultado IN VARCHAR2,
        xDemandas_id IN NUMBER);
    PROCEDURE up_caso (xId IN NUMBER, xEstado IN VARCHAR2, xResultado IN VARCHAR2);
    PROCEDURE ad_sentencia (xNumero IN NUMBER, xFecha IN DATE, xFallo IN VARCHAR2, 
        xCasos_id IN NUMBER, xJueces_nuip IN VARCHAR);
    FUNCTION co_hecho (xDemandas_id IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION co_demanda (xClientes_id IN NUMBER) RETURN SYS_REFCURSOR;
END PC_demandas;
/
CREATE OR REPLACE PACKAGE PC_audiencias IS
    PROCEDURE ad_audiencia (xId IN NUMBER, xFecha IN DATE, xDuracion IN NUMBER, xJueces_nuip IN VARCHAR2, 
        xJuzgados_id IN NUMBER);
    PROCEDURE up_audiencia (xId IN NUMBER, xFecha IN DATE, xDuracion IN NUMBER, xJueces_nuip IN VARCHAR2);
    PROCEDURE de_audiencia (xId IN NUMBER);
    FUNCTION co_audiencia (xJueces_nuip IN VARCHAR2) RETURN SYS_REFCURSOR;
END PC_audiencias;
/
CREATE OR REPLACE PACKAGE PC_jueces IS
    PROCEDURE ad_juez (xNuip IN VARCHAR2, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2);
    PROCEDURE up_juez (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2);
    PROCEDURE de_juez (xNuip IN VARCHAR2);
END PC_jueces;
/
CREATE OR REPLACE PACKAGE PC_juzgados IS
    PROCEDURE ad_juzgado (xId IN NUMBER, xNombre IN VARCHAR2, xTipo IN VARCHAR2,
        xCorreo IN VARCHAR2, xTelefono IN VARCHAR2, xLugares_id IN NUMBER);
    PROCEDURE up_juzgado (xId IN NUMBER, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2, xLugares_id IN NUMBER);
END PC_juzgados;