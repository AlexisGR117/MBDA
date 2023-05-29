CREATE OR REPLACE PACKAGE BODY PA_abogado IS
    PROCEDURE ad_abogado (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xNombre IN VARCHAR2, xFecha_nacimiento IN DATE, xLugares_id IN NUMBER, xFirmas_nit IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO abogados (nuip, correo, telefono, nombre, fecha_nacimiento, lugares_id, firmas_nit)
            VALUES (xNuip, xCorreo, xTelefono, xNombre, xFecha_nacimiento, xLugares_id, xFirmas_nit);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el abogado');
    END ad_abogado;
    
    PROCEDURE up_abogado (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xLugares_id IN NUMBER, xFirmas_nit IN VARCHAR2)
    IS
    BEGIN
        UPDATE abogados SET correo = xCorreo WHERE nuip = xNuip;
        UPDATE abogados SET telefono = xTelefono WHERE nuip = xNuip;
        UPDATE abogados SET lugares_id = xLugares_id WHERE nuip = xNuip;
        UPDATE abogados SET firmas_nit = xFirmas_nit WHERE nuip = xNuip;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar el abogado');
    END up_abogado;
    
    PROCEDURE de_abogado (xNuip IN VARCHAR2)
    IS
    BEGIN
        DELETE FROM abogados WHERE (nuip = xNuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'Error al eliminar el abogado');
    END de_abogado;
    
        PROCEDURE ad_espAbog (xAbogados_nuip IN VARCHAR2, xAreas_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO espAbog (abogados_nuip, areas_id)
            VALUES (xAbogados_nuip, xAreas_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20004, 'Error al insertar la especialidad del abogado');
    END ad_espAbog;
    
    PROCEDURE de_espAbog (xAbogados_nuip IN VARCHAR2, xAreas_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM espAbog WHERE (abogados_nuip = xAbogados_nuip AND areas_id  = xAreas_id );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20005, 'Error al eliminar la especialidad del abogado');
    END de_espAbog;
    
    PROCEDURE ad_perfil (xId IN NUMBER, xDescripcion IN VARCHAR2, xAños_experiencia IN NUMBER,
        xTarifa_minima IN NUMBER, xCalificacion_promedio IN NUMBER, xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO perfiles (id, descripcion, años_experiencia, tarifa_minima, calificacion_promedio, abogados_nuip)
            VALUES (xId, xDescripcion, xAños_experiencia, xTarifa_minima, xCalificacion_promedio, xAbogados_nuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20006, 'Error al insertar el perfil');
    END ad_perfil;
    
    PROCEDURE up_perfil (xId IN NUMBER, xDescripcion IN VARCHAR2, xAños_experiencia IN NUMBER,
        xTarifa_minima IN NUMBER, xCalificacion_promedio IN NUMBER)
    IS
    BEGIN
        UPDATE perfiles SET descripcion = xDescripcion WHERE id = xId;
        UPDATE perfiles SET años_experiencia = xAños_experiencia WHERE id = xId;
        UPDATE perfiles SET tarifa_minima = xTarifa_minima WHERE id = xId;
        UPDATE perfiles SET calificacion_promedio = xCalificacion_promedio WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20007, 'Error al actualizar el perfil');
    END up_perfil;
    
    PROCEDURE de_perfil (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM perfiles WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20008, 'Error al eliminar el perfil');
    END de_perfil;
    
    PROCEDURE ad_estudio(xId IN NUMBER, xTitulo IN VARCHAR2, xUniversidad IN VARCHAR2, 
        xFecha_inicio IN DATE, xFecha_final IN DATE, xPerfiles_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO estudios (id, titulo, universidad, fecha_inicio, fecha_final, perfiles_id)
            VALUES (xId, xTitulo, xUniversidad, xFecha_inicio, xFecha_final, xPerfiles_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20012, 'Error al insertar el estudio del abogado');
    END ad_estudio;
    
    PROCEDURE de_estudio (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM estudios WHERE (id  = xId );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20009, 'Error al eliminar el estudio del abogado');
    END de_estudio;
    
    PROCEDURE ad_tarjetaProfesional(xNumero IN VARCHAR2, xFecha_expedicion IN DATE,
        xFecha_grado IN DATE, xUniversidad IN VARCHAR2, xConsejo_seccional IN VARCHAR2, 
        xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO tarjetasProfesionales (numero, fecha_expedicion, fecha_grado, universidad, consejo_seccional, abogados_nuip)
            VALUES (xNumero, xFecha_expedicion, xFecha_grado, xUniversidad, xConsejo_seccional, xAbogados_nuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20010, 'Error al insertar la tarjeta profesional del abogado');
    END ad_tarjetaProfesional;
    
    FUNCTION co_abogado (xArea IN VARCHAR2) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Area, nuip, Abogado, años_experiencia,
                   tarifa_minima, calificacion_promedio
                FROM VAbogado
                WHERE Area IN (xArea);
        RETURN s_cursor;
    END co_abogado;
    
    FUNCTION co_calificacion (xNuip IN VARCHAR2) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT NombreCliente, fecha, comentario, valoracion
                FROM VCalificaciones
                WHERE nuip = xNuip;
        RETURN s_cursor;
    END co_calificacion;
    
    PROCEDURE ad_asesoria (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha IN DATE,
        xDuracion IN NUMBER, xPrecio IN NUMBER, xAbogados_nuip IN VARCHAR2, xClientes_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO asesorias (id, descripcion, fecha, duracion, precio, abogados_nuip, clientes_id)
            VALUES (xId, xDescripcion, xFecha, xDuracion, xPrecio, xAbogados_nuip, xClientes_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20011, 'Error al insertar la asesoria');
    END ad_asesoria;
    
    PROCEDURE up_asesoria (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha IN DATE,
        xDuracion IN NUMBER, xPrecio IN NUMBER, xClientes_id IN NUMBER)
    IS
    BEGIN
        UPDATE asesorias SET descripcion = xDescripcion WHERE id = xId;
        UPDATE asesorias SET fecha = xFecha WHERE id = xId;
        UPDATE asesorias SET duracion = xDuracion WHERE id = xId;
        UPDATE asesorias SET precio = xPrecio WHERE id = xId;
        UPDATE asesorias SET clientes_id = xClientes_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20012, 'Error al actualizar la asesoria');
    END up_asesoria;
    
    PROCEDURE ad_area (xId IN NUMBER, xNombre IN VARCHAR2, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO areas (id, nombre, descripcion)
            VALUES (xId, xNombre, xDescripcion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20013, 'Error al insertar el area');
    END ad_area;
    
    PROCEDURE up_area (xId IN NUMBER, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        UPDATE areas SET descripcion = xDescripcion WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20014, 'Error al actualizar el area');
    END up_area;
    
    PROCEDURE ad_lugar (xId IN NUMBER, xDepartamento IN VARCHAR2, xMunicipio IN VARCHAR2,
        xDireccion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO lugares (id, departamento, municipio, direccion)
            VALUES (xId, xDepartamento, xMunicipio, xDireccion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20015, 'Error al insertar el lugar');
    END ad_lugar;

    PROCEDURE ad_contrato (xId IN NUMBER, xFecha_firma IN DATE, xDescripcion IN VARCHAR2,
        xForma_pago IN VARCHAR2, xRemuneracion IN NUMBER, xClientes_id IN NUMBER,
        xAbogados_nuip IN VARCHAR, xLugares_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO contratos (id, fecha_firma, descripcion, forma_pago, remuneracion, clientes_id, abogados_nuip, lugares_id)
            VALUES (xId, xFecha_firma, xDescripcion, xForma_pago, xRemuneracion, xClientes_id, xAbogados_nuip, xLugares_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20016, 'Error al insertar el contrato');
    END ad_contrato;
    
    PROCEDURE up_contrato (xId IN NUMBER, xDescripcion IN VARCHAR2, xForma_pago IN VARCHAR2,
        xRemuneracion IN NUMBER, xLugares_id IN NUMBER)
    IS
    BEGIN
        UPDATE contratos SET descripcion = xDescripcion WHERE id = xId;
        UPDATE contratos SET forma_pago = xForma_pago WHERE id = xId;
        UPDATE contratos SET remuneracion = xRemuneracion WHERE id = xId;
        UPDATE contratos SET lugares_id = xLugares_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20017, 'Error al actualizar el contrato');
    END up_contrato;
    
        FUNCTION co_hecho (xDemandas_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Hecho, Fecha, Descripcion_Hecho, Prueba, tipo, Descripcion_prueba
                FROM VHechos
                WHERE demanda = xDemandas_id;
        RETURN s_cursor;
    END co_hecho;
    
    FUNCTION co_demanda (xClientes_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Demanda, pretencion, Fecha_Demanda, estado, resultado, fallo, Fecha_sentencia, nuip, nombre
                FROM VDemandas
                WHERE clientes_id = xClientes_id;
        RETURN s_cursor;
    END co_demanda;
END PA_abogado;
/
CREATE OR REPLACE PACKAGE BODY PA_cliente IS
    PROCEDURE ad_cliente (xId IN NUMBER, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2, xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO clientes (id, nombre, correo, telefono, abogados_nuip)
            VALUES (xId, xNombre, xCorreo, xTelefono, xAbogados_nuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20018, 'Error al insertar el cliente');
    END ad_cliente;
    
    PROCEDURE up_cliente (xId IN NUMBER, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2,
        xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        UPDATE clientes SET correo = xCorreo WHERE id = xId;
        UPDATE clientes SET telefono = xTelefono WHERE id = xId;
        UPDATE clientes SET abogados_nuip = xAbogados_nuip WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20019, 'Error al actualizar el cliente');
    END up_cliente;
    
    PROCEDURE de_cliente (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM clientes WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20020, 'Error al eliminar el cliente');
    END de_cliente;
    
    PROCEDURE ad_personaNatural (xNuip IN VARCHAR2, xFecha_nacimiento IN DATE, xClientes_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO personasNaturales (nuip, fecha_nacimiento, clientes_id)
            VALUES (xNuip, xFecha_nacimiento, xClientes_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20021, 'Error al insertar la persona natural');
    END ad_personaNatural;
    
    PROCEDURE ad_personaJuridica (xNit IN VARCHAR2, xRazon_social IN VARCHAR2, xClientes_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO personasJuridicas (nit, razon_social, clientes_id)
            VALUES (xNit, xRazon_social, xClientes_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20022, 'Error al insertar la persona juridica');
    END ad_personaJuridica;
    
    PROCEDURE up_personaJuridica (xNit IN VARCHAR2, xRazon_social IN VARCHAR2)
    IS
    BEGIN
        UPDATE personasJuridicas SET razon_social = xRazon_social WHERE nit = xNit;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20023, 'Error al actualizar la persona juridica');
    END up_personaJuridica;
    
    PROCEDURE ad_solicitud (xId IN NUMBER, xDescripcion IN VARCHAR2, xFecha_envio IN DATE,
        xClientes_id IN NUMBER, xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO solicitudes (id, descripcion, fecha_envio, clientes_id, abogados_nuip)
            VALUES (xId, xDescripcion, xFecha_envio, xClientes_id, xAbogados_nuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20024, 'Error al insertar la solicitud');
    END ad_solicitud;
    
    PROCEDURE up_solicitud (xId IN NUMBER, xDescripcion IN VARCHAR2, xAbogados_nuip IN VARCHAR2)
    IS
    BEGIN
        UPDATE solicitudes SET descripcion = xDescripcion WHERE id = xId;
        UPDATE solicitudes SET abogados_nuip = xAbogados_nuip WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20025, 'Error al actualizar la solicitud');
    END up_solicitud;
    
    PROCEDURE de_solicitud (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM solicitudes WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20026, 'Error al eliminar la solicitud');
    END de_solicitud;
    
    PROCEDURE ad_contrato (xId IN NUMBER, xFecha_firma IN DATE, xDescripcion IN VARCHAR2,
        xForma_pago IN VARCHAR2, xRemuneracion IN NUMBER, xClientes_id IN NUMBER,
        xAbogados_nuip IN VARCHAR, xLugares_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO contratos (id, fecha_firma, descripcion, forma_pago, remuneracion, clientes_id, abogados_nuip, lugares_id)
            VALUES (xId, xFecha_firma, xDescripcion, xForma_pago, xRemuneracion, xClientes_id, xAbogados_nuip, xLugares_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20027, 'Error al insertar el contrato');
    END ad_contrato;
    
    PROCEDURE up_contrato (xId IN NUMBER, xDescripcion IN VARCHAR2, xForma_pago IN VARCHAR2,
        xRemuneracion IN NUMBER, xLugares_id IN NUMBER)
    IS
    BEGIN
        UPDATE contratos SET descripcion = xDescripcion WHERE id = xId;
        UPDATE contratos SET forma_pago = xForma_pago WHERE id = xId;
        UPDATE contratos SET remuneracion = xRemuneracion WHERE id = xId;
        UPDATE contratos SET lugares_id = xLugares_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20028, 'Error al actualizar el contrato');
    END up_contrato;
    
    PROCEDURE ad_calificacion (xId IN NUMBER, xComentario IN VARCHAR2, xValoracion IN NUMBER,
        xFecha IN DATE, xClientes_id IN NUMBER, xPerfiles_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO calificaciones (id, comentario, valoracion, fecha, clientes_id, perfiles_id)
            VALUES (xId, xComentario, xValoracion, xFecha, xClientes_id, xPerfiles_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20029, 'Error al insertar la calificacion');
    END ad_calificacion;
    
    PROCEDURE up_calificacion (xId IN NUMBER, xComentario IN VARCHAR2, xValoracion IN NUMBER,
        xFecha IN DATE, xPerfiles_id IN NUMBER)
    IS
    BEGIN
        UPDATE calificaciones SET comentario = xComentario WHERE id = xId;
        UPDATE calificaciones SET valoracion = xValoracion WHERE id = xId;
        UPDATE calificaciones SET fecha = xFecha WHERE id = xId;
        UPDATE calificaciones SET perfiles_id = xPerfiles_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20030, 'Error al actualizar la calificacion');
    END up_calificacion;
    
    PROCEDURE de_calificacion (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM calificaciones WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20031, 'Error al eliminar la calificacion');
    END de_calificacion;
    
    PROCEDURE ad_demanda (xId IN NUMBER, xDemandado IN NUMBER, xPretencion IN VARCHAR2,
        xCuantia IN NUMBER, xFecha IN DATE, xClientes_id IN NUMBER, xJuzgados_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO demandas (id, demandado, pretencion, cuantia, fecha, clientes_id, juzgados_id)
            VALUES (xId, xDemandado, xPretencion, xCuantia, xFecha, xClientes_id, xJuzgados_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20036, 'Error al insertar la demanda');
    END ad_demanda;
    
    PROCEDURE up_demanda (xId IN NUMBER, xPretencion IN VARCHAR2, xCuantia IN NUMBER,
        xFecha IN DATE, xJuzgados_id IN NUMBER)
    IS
    BEGIN
        UPDATE demandas SET pretencion = xPretencion WHERE id = xId;
        UPDATE demandas SET cuantia = xCuantia WHERE id = xId;
        UPDATE demandas SET fecha = xFecha WHERE id = xId;
        UPDATE demandas SET juzgados_id = xJuzgados_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20037, 'Error al actualizar la demanda');
    END up_demanda;
    
    PROCEDURE ad_hecho (xId IN NUMBER, xLugares_id IN NUMBER, xDemandas_id IN NUMBER,
        xFecha IN DATE, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO hechos (id, lugares_id, demandas_id, fecha, descripcion)
            VALUES (xId, xLugares_id, xDemandas_id, xFecha, xDescripcion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20038, 'Error al insertar el hecho');
    END ad_hecho;
    
    PROCEDURE up_hecho (xId IN NUMBER, xFecha IN DATE, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        UPDATE hechos SET fecha = xFecha WHERE id = xId;
        UPDATE hechos SET descripcion = xDescripcion WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20039, 'Error al actualizar el hecho');
    END up_hecho;
    
    PROCEDURE de_hecho (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM hechos WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20040, 'Error al eliminar el hecho');
    END de_hecho;    
    
    PROCEDURE ad_prueba (xId IN NUMBER, xTipo IN VARCHAR2, xDescripcion IN VARCHAR2,
        xMedio IN VARCHAR2, xHechos_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO pruebas (id, tipo, descripcion, medio, hechos_id)
            VALUES (xId, xTipo, xDescripcion, xMedio, xHechos_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20041, 'Error al insertar la prueba');
    END ad_prueba;
    
    PROCEDURE up_prueba (xId IN NUMBER, xTipo IN VARCHAR2, xDescripcion IN VARCHAR2,
        xMedio IN VARCHAR2)
    IS
    BEGIN
        UPDATE pruebas SET tipo = xTipo WHERE id = xId;
        UPDATE pruebas SET descripcion = xDescripcion WHERE id = xId;
        UPDATE pruebas SET medio = xMedio WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20042, 'Error al actualizar la prueba');
    END up_prueba;
    
    PROCEDURE de_prueba (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM pruebas WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20043, 'Error al eliminar la prueba');
    END de_prueba;
    
    PROCEDURE ad_fundamentoDerecho (xId IN NUMBER, xNorma_juridica IN VARCHAR2, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO fundamentosDerechos (id, norma_juridica, descripcion)
            VALUES (xId, xNorma_juridica, xDescripcion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20044, 'Error al insertar el fundamento de derecho');
    END ad_fundamentoDerecho;
    
    PROCEDURE up_fundamentoDerecho (xId IN NUMBER, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        UPDATE fundamentosDerechos SET descripcion = xDescripcion WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20045, 'Error al actualizar el funamento de derecho');
    END up_fundamentoDerecho;
    
    PROCEDURE ad_demFun (xDemandas_id IN NUMBER, xFundamentosDerechos_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO demFun (demandas_id, fundamentosDerechos_id)
            VALUES (xDemandas_id, xFundamentosDerechos_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20046, 'Error al insertar el fundamento de derecho de la demanda');
    END ad_demFun;
    
    PROCEDURE de_demFun (xDemandas_id IN NUMBER, xFundamentosDerechos_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM demFun WHERE (demandas_id = xDemandas_id AND xFundamentosDerechos_id = fundamentosDerechos_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20047, 'Error al eliminar el fundamento de derecho de la demanda');
    END de_demFun;

    PROCEDURE ad_caso (xId IN NUMBER, xEstado IN VARCHAR2, xResultado IN VARCHAR2,
        xDemandas_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO casos (id, estado, resultado, demandas_id)
            VALUES (xId, xEstado, xResultado, xDemandas_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20048, 'Error al insertar el caso');
    END ad_caso;
    
    PROCEDURE up_caso (xId IN NUMBER, xEstado IN VARCHAR2, xResultado IN VARCHAR2)
    IS
    BEGIN
        UPDATE casos SET estado = xEstado WHERE id = xId;
        UPDATE casos SET resultado = xResultado WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20049, 'Error al actualizar el caso');
    END up_caso;
    
   PROCEDURE ad_sentencia (xNumero IN NUMBER, xFecha IN DATE, xFallo IN VARCHAR2, 
        xCasos_id IN NUMBER, xJueces_nuip IN VARCHAR)
    IS
    BEGIN
        INSERT INTO sentencias (numero, fecha, fallo, casos_id, jueces_nuip)
            VALUES (xNumero, xFecha, xFallo, xCasos_id, xJueces_nuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20050, 'Error al insertar la sentencia');
    END ad_sentencia; 

    PROCEDURE ad_lugar (xId IN NUMBER, xDepartamento IN VARCHAR2, xMunicipio IN VARCHAR2,
        xDireccion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO lugares (id, departamento, municipio, direccion)
            VALUES (xId, xDepartamento, xMunicipio, xDireccion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20039, 'Error al insertar el lugar');
    END ad_lugar;

    FUNCTION co_hecho (xDemandas_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Hecho, Fecha, Descripcion_Hecho, Prueba, tipo, Descripcion_prueba
                FROM VHechos
                WHERE demanda = xDemandas_id;
        RETURN s_cursor;
    END co_hecho;
    
    FUNCTION co_demanda (xClientes_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Demanda, pretencion, Fecha_Demanda, estado, resultado, fallo, Fecha_sentencia, nuip, nombre
                FROM VDemandas
                WHERE clientes_id = xClientes_id;
        RETURN s_cursor;
    END co_demanda;
    
    FUNCTION co_abogado (xArea IN VARCHAR2, xTarifa IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Area, nuip, Abogado, años_experiencia,
                   tarifa_minima, calificacion_promedio
                FROM VAbogado
                WHERE Area IN (xArea) AND tarifa_minima < xTarifa;
        RETURN s_cursor;
    END co_abogado;
END PA_cliente;
/
CREATE OR REPLACE PACKAGE BODY PA_directorFirma IS
    PROCEDURE ad_firma (xNit IN VARCHAR2, xNombre IN VARCHAR, xTelefono IN VARCHAR, 
        xCorreo IN VARCHAR2, xLugares_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO firmas (nit, nombre, telefono, correo, lugares_id)
            VALUES (xNit, xNombre, xTelefono, xCorreo, xLugares_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20020, 'Error al insertar la firma');
    END ad_firma;
    
    PROCEDURE up_firma (xNit IN VARCHAR2, xNombre IN VARCHAR, xTelefono IN VARCHAR, 
        xCorreo IN VARCHAR2, xLugares_id IN NUMBER)
    IS
    BEGIN
        UPDATE firmas SET nombre = xNombre WHERE nit = xNIT;
        UPDATE firmas SET telefono = xTelefono WHERE nit = xNIT;
        UPDATE firmas SET correo = xCorreo WHERE nit = xNIT;
        UPDATE firmas SET lugares_id = xLugares_id WHERE nit = xNIT;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20021, 'Error al actualizar la firma');
    END up_firma;
    
    PROCEDURE de_firma (xNit IN VARCHAR2)
    IS
    BEGIN
        DELETE FROM firmas WHERE (nit = xNit);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20022, 'Error al eliminar la firma');
    END de_firma;

    PROCEDURE ad_espFirma (xFirmas_nit IN VARCHAR2, xAreas_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO espFirmas (firmas_nit, areas_id)
            VALUES (xFirmas_nit, xAreas_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20023, 'Error al insertar la especialidad de la firma');
    END ad_espFirma;
    
    PROCEDURE de_espFirma (xFirmas_nit IN VARCHAR2, xAreas_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM espFirmas WHERE (firmas_nit = xFirmas_nit AND areas_id  = xAreas_id );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20024, 'Error al eliminar la especialidad de la firma');
    END de_espfirma;
    
    FUNCTION co_firma (xNuip IN VARCHAR2) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Area, NIT, Firma, departamento, municipio, direccion
                FROM VFirma
                WHERE nuip = xNuip;
        RETURN s_cursor;
    END co_firma;
    
    PROCEDURE ad_area (xId IN NUMBER, xNombre IN VARCHAR2, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO areas (id, nombre, descripcion)
            VALUES (xId, xNombre, xDescripcion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20018, 'Error al insertar el area');
    END ad_area;
    
    PROCEDURE up_area (xId IN NUMBER, xDescripcion IN VARCHAR2)
    IS
    BEGIN
        UPDATE areas SET descripcion = xDescripcion WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20019, 'Error al actualizar el area');
    END up_area;
    PROCEDURE ad_lugar (xId IN NUMBER, xDepartamento IN VARCHAR2, xMunicipio IN VARCHAR2,
        xDireccion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO lugares (id, departamento, municipio, direccion)
            VALUES (xId, xDepartamento, xMunicipio, xDireccion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20017, 'Error al insertar el lugar');
    END ad_lugar;
END PA_directorFirma;
/
CREATE OR REPLACE PACKAGE BODY PA_juez IS
    PROCEDURE ad_audiencia (xId IN NUMBER, xFecha IN DATE, xDuracion IN NUMBER, xJueces_nuip IN VARCHAR2, 
        xJuzgados_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO audiencias (id, fecha, duracion, jueces_nuip, juzgados_id)
            VALUES (xId, xFecha, xDuracion, xJueces_nuip, xJuzgados_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20051, 'Error al insertar la audiencia');
    END ad_audiencia;
    
    PROCEDURE up_audiencia (xId IN NUMBER, xFecha IN DATE, xDuracion IN NUMBER, xJueces_nuip IN VARCHAR2)
    IS
    BEGIN
        UPDATE audiencias SET fecha = xFecha WHERE id = xId;
        UPDATE audiencias SET duracion = xDuracion WHERE id = xId;
        UPDATE audiencias SET jueces_nuip = xJueces_nuip WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20052, 'Error al actualizar la audiencia');
    END up_audiencia;
    
    PROCEDURE de_audiencia (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM audiencias WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20053, 'Error al eliminar la audiencia');
    END de_audiencia;
    
    FUNCTION co_audiencia (xJueces_nuip IN VARCHAR2) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Audiencia, fecha, Juzgado, departamento, municipio, direccion
            FROM VAudiencias
                WHERE nuip = xJueces_nuip;
        RETURN s_cursor;
    END co_audiencia;

    PROCEDURE ad_juez (xNuip IN VARCHAR2, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO jueces (nuip, nombre, correo, telefono)
            VALUES (xNuip, xNombre, xCorreo, xTelefono);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20054, 'Error al insertar el juez');
    END ad_juez;
    
    PROCEDURE up_juez (xNuip IN VARCHAR2, xCorreo IN VARCHAR2, xTelefono IN VARCHAR2)
    IS
    BEGIN
        UPDATE jueces SET correo = xTelefono WHERE nuip = xNuip;
        UPDATE jueces SET telefono = xTelefono WHERE nuip = xNuip;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20055, 'Error al actualizar el juez');
    END up_juez;
    
    PROCEDURE de_juez (xNuip IN VARCHAR2)
    IS
    BEGIN
        DELETE FROM jueces WHERE (nuip = xNuip);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20056, 'Error al eliminar el juez');
    END de_juez;

    PROCEDURE ad_juzgado (xId IN NUMBER, xNombre IN VARCHAR2, xTipo IN VARCHAR2,
        xCorreo IN VARCHAR2, xTelefono IN VARCHAR2, xLugares_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO juzgados (id, nombre, tipo, correo, telefono, lugares_id)
            VALUES (xId, xNombre, xTipo, xCorreo, xTelefono, xLugares_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20057, 'Error al insertar el juzgado');
    END ad_juzgado;
    
    PROCEDURE up_juzgado (xId IN NUMBER, xNombre IN VARCHAR2, xCorreo IN VARCHAR2,
        xTelefono IN VARCHAR2, xLugares_id IN NUMBER)
    IS
    BEGIN
        UPDATE juzgados SET correo = xCorreo WHERE id = xId;
        UPDATE juzgados SET nombre = xNombre WHERE id = xId;
        UPDATE juzgados SET telefono = xTelefono WHERE id = xId;
        UPDATE juzgados SET lugares_id = xLugares_id WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20058, 'Error al actualizar el juzgado');
    END up_juzgado;
    
    PROCEDURE ad_lugar (xId IN NUMBER, xDepartamento IN VARCHAR2, xMunicipio IN VARCHAR2,
        xDireccion IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO lugares (id, departamento, municipio, direccion)
            VALUES (xId, xDepartamento, xMunicipio, xDireccion);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20039, 'Error al insertar el lugar');
    END ad_lugar;
    
    FUNCTION co_hecho (xDemandas_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Hecho, Fecha, Descripcion_Hecho, Prueba, tipo, Descripcion_prueba
                FROM VHechos
                WHERE demanda = xDemandas_id;
        RETURN s_cursor;
    END co_hecho;
    
    FUNCTION co_demanda (xClientes_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT Demanda, pretencion, Fecha_Demanda, estado, resultado, fallo, Fecha_sentencia, nuip, nombre
                FROM VDemandas
                WHERE clientes_id = xClientes_id;
        RETURN s_cursor;
    END co_demanda;
END PA_juez;
/
CREATE OR REPLACE PACKAGE BODY PA_gerente IS
    FUNCTION co_abogados RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
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
        RETURN s_cursor;
    END co_abogados;
    FUNCTION co_firmas RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT nit, firmas.nombre AS Firma, COUNT(nit) AS Abogados, ROUND(AVG(calificacion_promedio), 1) AS CalificacionPromedio
                FROM firmas LEFT JOIN abogados ON (firmas.nit = firmas_nit)
                            LEFT JOIN perfiles ON (abogados_nuip = nuip)
                GROUP BY nit, firmas.nombre
                ORDER BY Abogados DESC, CalificacionPromedio DESC;
        RETURN s_cursor;
    END co_firmas;
    FUNCTION co_juzgados RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
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
        RETURN s_cursor;
    END co_juzgados;
    FUNCTION co_municipios RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
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
        RETURN s_cursor;
    END co_municipios;
    FUNCTION co_meses RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
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
        RETURN s_cursor;
    END co_meses;
END PA_gerente;