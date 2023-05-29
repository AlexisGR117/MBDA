CREATE TABLE tarjetasProfesionales(
    numero                  VARCHAR(6) NOT NULL,
    fecha_expedicion	    DATE NOT NULL,
    fecha_grado             DATE NOT NULL,
    universidad             VARCHAR2(80) NOT NULL,
    consejo_seccional       VARCHAR2(40) NOT NULL,
    abogados_nuip           VARCHAR2(10) NOT NULL);
CREATE TABLE abogados(
    nuip                    VARCHAR2(10) NOT NULL,
    correo	                VARCHAR2(60) NOT NULL,
    telefono                VARCHAR2(10) NOT NULL,
    nombre                  VARCHAR2(40) NOT NULL,
    fecha_nacimiento        DATE NOT NULL,
    lugares_id              NUMBER(5) NOT NULL,
    firmas_nit              VARCHAR2(11));
CREATE TABLE clientes(
    id                      NUMBER(5) NOT NULL,
    nombre                  VARCHAR2(40) NOT NULL,
    correo	                VARCHAR2(40) NOT NULL,
    telefono                VARCHAR2(10) NOT NULL,
    abogados_nuip           VARCHAR2(10));
CREATE TABLE personasJuridicas(
    nit                     VARCHAR2(11) NOT NULL,
    razon_social            VARCHAR2(90) NOT NULL,
    clientes_id             NUMBER(5) NOT NULL);
CREATE TABLE personasNaturales(
    nuip                    VARCHAR2(10) NOT NULL,
    fecha_nacimiento        DATE NOT NULL,
    clientes_id             NUMBER(5) NOT NULL);
CREATE TABLE revisiones(
    perfiles_id             NUMBER(5) NOT NULL,
    clientes_id             NUMBER(5) NOT NULL);
CREATE TABLE areas(
    id                      NUMBER(5) NOT NULL,
    nombre	                VARCHAR(30) NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL);
CREATE TABLE firmas(
    nit                     VARCHAR2(11) NOT NULL,
    nombre	                VARCHAR2(50) NOT NULL,
    telefono                VARCHAR2(10) NOT NULL,
    correo                  VARCHAR2(70) NOT NULL,
    lugares_id              NUMBER(5) NOT NULL);
CREATE TABLE asesorias(
    id                      NUMBER(5) NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL,
    fecha                   DATE NOT NULL, 
    duracion                NUMBER(3) NOT NULL,
    precio                  NUMBER(10) NOT NULL,
    abogados_nuip           VARCHAR2(10) NOT NULL,
    clientes_id             NUMBER(5));
CREATE TABLE estudios(
    id                      NUMBER(5) NOT NULL,
    titulo	                VARCHAR2(40) NOT NULL,
    universidad             VARCHAR2(80) NOT NULL,
    fecha_inicio            DATE NOT NULL,
    fecha_final             DATE NOT NULL,
    perfiles_id             NUMBER(5) NOT NULL);
CREATE TABLE solicitudes(
    id                      NUMBER(5) NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL,
    fecha_envio             DATE NOT NULL,
    clientes_id             NUMBER(5) NOT NULL,
    abogados_nuip           VARCHAR2(10) NOT NULL);
CREATE TABLE lugares(
    id                      NUMBER(5) NOT NULL,
    departamento            VARCHAR2(20) NOT NULL,
    municipio               VARCHAR2(30) NOT NULL,
    direccion               VARCHAR2(30));
CREATE TABLE perfiles(
    id                      NUMBER(5) NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL,
    años_experiencia        NUMBER(2) NOT NULL,  
    tarifa_minima           NUMBER(10) NOT NULL,
    calificacion_promedio   NUMBER(2, 1),
    abogados_nuip           VARCHAR2(10) NOT NULL);
CREATE TABLE calificaciones(
    id                      NUMBER(5) NOT NULL,
    comentario	            VARCHAR2(500),
    valoracion              NUMBER(2,1) NOT NULL,
    fecha                   DATE NOT NULL,
    clientes_id             NUMBER(5) NOT NULL,
    perfiles_id             NUMBER(5) NOT NULL);
CREATE TABLE contratos(
    id                      NUMBER(5) NOT NULL,
    fecha_firma	            DATE NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL,
    forma_pago              VARCHAR2(50) NOT NULL,
    remuneracion            NUMBER(10),
    clientes_id             NUMBER(5) NOT NULL,
    abogados_nuip           VARCHAR2(10) NOT NULL,
    lugares_id              NUMBER(5) NOT NULL);
CREATE TABLE espAbog(
    abogados_nuip           VARCHAR2(10) NOT NULL,
    areas_id	            NUMBER(5) NOT NULL);
CREATE TABLE espFirmas(
    firmas_nit              VARCHAR2(11) NOT NULL,
    areas_id	            NUMBER(5) NOT NULL);
CREATE TABLE demandas(
    id                      NUMBER(5) NOT NULL,
    demandado               NUMBER(5) NOT NULL,
    pretencion              VARCHAR2(500) NOT NULL,
    cuantia                 NUMBER(10),
    fecha                   DATE NOT NULL,
    clientes_id             NUMBER(5) NOT NULL,
    juzgados_id             NUMBER(5) NOT NULL);
CREATE TABLE hechos(
    id                      NUMBER(5) NOT NULL,
    lugares_id	            NUMBER(5) NOT NULL,
    demandas_id	            NUMBER(5) NOT NULL,
    fecha                   DATE NOT NULL,
    descripcion             VARCHAR2(500) NOT NULL);
CREATE TABLE juzgados(
    id                      NUMBER(5) NOT NULL,
    nombre	                VARCHAR2(30) NOT NULL,
    tipo                    VARCHAR2(2) NOT NULL,
    correo                  VARCHAR2(40) NOT NULL,
    telefono                VARCHAR2(10) NOT NULL,
    lugares_id              NUMBER(5) NOT NULL);
CREATE TABLE casos(
    id                      NUMBER(5) NOT NULL,
    estado	                VARCHAR2(10) NOT NULL,
    resultado               VARCHAR2(10),
    demandas_id             NUMBER(5) NOT NULL);
CREATE TABLE sentencias(
    numero                  NUMBER(5) NOT NULL,
    fecha	                DATE NOT NULL,
    fallo                   VARCHAR2(500) NOT NULL,
    casos_id                NUMBER(5) NOT NULL,
    jueces_nuip             VARCHAR2(10) NOT NULL);
CREATE TABLE audiencias(
    id                      NUMBER(5) NOT NULL,
    fecha	                DATE NOT NULL,
    duracion                NUMBER(3) NOT NULL,
    jueces_nuip             VARCHAR2(10) NOT NULL,
    juzgados_id             NUMBER(5) NOT NULL);
CREATE TABLE pruebas(
    id                      NUMBER(5) NOT NULL,
    tipo                    VARCHAR2(3) NOT NULL,
    descripcion             VARCHAR2(500),
    medio                   VARCHAR2(30) NOT NULL,
    hechos_id	            NUMBER(5) NOT NULL);
CREATE TABLE jueces(
    nuip                    VARCHAR2(10) NOT NULL,
    nombre                  VARCHAR(40) NOT NULL,
    correo                  VARCHAR2(40),
    telefono                VARCHAR2(10));
CREATE TABLE fundamentosDerechos(
    id                      NUMBER(5) NOT NULL,
    norma_juridica          VARCHAR(20) NOT NULL,
    descripcion             VARCHAR(500) NOT NULL);
CREATE TABLE demFun(
    demandas_id             NUMBER(5) NOT NULL,
    fundamentosDerechos_id  NUMBER(5) NOT NULL);