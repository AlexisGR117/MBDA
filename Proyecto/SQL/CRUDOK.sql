
EXECUTE PC_abogados.ad_calificacion (100, 'Comentario Calificacion 2', 2, '26/08/2021', 13, 93);

EXECUTE PC_abogados.up_calificacion (1, 'Nuevo comentario', 3, '26/08/2021', 24);

EXECUTE PC_abogados.de_calificacion (1);

EXECUTE PC_abogados.ad_abogado (7196660674, 'cdrysdale36@trellian.com', '7900717131', 'Cati Drysdale', '17/02/1965', 56, null);

EXECUTE PC_abogados.up_abogado (7196660674, 'nuevocorreo@trellian.com', '7900717131', 12, '242557634-2');

EXECUTE PC_abogados.de_abogado (7196660674);

EXECUTE PC_abogados.ad_espAbog (1038730783, 8);

EXECUTE PC_abogados.de_espAbog (1038730783, 8);

-- Agregar de nuevo el abogado
EXECUTE PC_abogados.ad_abogado (7196660674, 'cdrysdale36@trellian.com', '7900717131', 'Cati Drysdale', '17/02/1965', 56, null);
EXECUTE PC_abogados.ad_perfil (130, 'Descripcion perfil', 13, 2000000, null, 7196660674);

EXECUTE PC_abogados.up_perfil (1, 'Nueva Descripcion', 42, 7000000, 3);

EXECUTE PC_abogados.de_perfil (1);

EXECUTE PC_abogados.ad_estudio (101, 'Abogado', 'Milligan College', '27/04/1998', '19/11/1973', 39);

EXECUTE PC_abogados.de_estudio (1);

EXECUTE PC_abogados.ad_tarjetaProfesional ('717418', '14/10/2015', '09/12/2021', 'Xinjiang Normal University', 'Concejo', 7196660674);

VARIABLE consulta_uno REFCURSOR;
EXECUTE :consulta_uno:=PC_abogados.co_abogado('Derecho Penal'); 
PRINT :consulta_uno;

VARIABLE consulta_dos REFCURSOR;
EXECUTE :consulta_dos:=PC_abogados.co_calificacion(4713971537); 
PRINT :consulta_dos;

EXECUTE PC_asesorias.ad_asesoria (101, 'Descripcion asesoria', '14/09/2021', 90, 500000, 3227082675, 5);

EXECUTE PC_asesorias.up_asesoria (1, 'Nueva Descripcion', '14/09/2021', 120, 1000000, 5);

EXECUTE PC_lugares.ad_lugar (101, 'Vaupés', 'Yavaraté', NULL);

EXECUTE PC_areas.ad_area (20, 'Nombre area', 'Descripcion area');

EXECUTE PC_areas.up_area (1, 'Nueva descripcion');

EXECUTE PC_firmas.ad_firma ('956889881-5', 'Spinka DuBuque', '4998388610', 'correo@gmail.com', 37);

EXECUTE PC_firmas.up_firma ('956889881-5', 'Spinka', '4998388610', 'correonuevo@gmail.com', 27);

EXECUTE PC_firmas.de_firma ('956889881-5');

EXECUTE PC_firmas.ad_espFirma ('821558136-2', 9);

EXECUTE PC_firmas.de_espFirma ('821558136-2', 9);

VARIABLE consulta_tres REFCURSOR;
EXECUTE :consulta_tres:=PC_firmas.co_firma(1041968914); 
PRINT :consulta_tres;

EXECUTE PC_contratos.ad_contrato (101, '12/02/2021', 'Descripcion contrato', 'forma pago', 500000, 54, 9289412860, 57);

EXECUTE PC_contratos.up_contrato (101, 'Descripcion contrato', 'forma pago', 500000, 57);

EXECUTE PC_clientes.ad_cliente (101, 'Giffer Nest', 'gnester100h@usda.gov', '0508252365', 8256887486);

EXECUTE PC_clientes.up_cliente (101, 'nuevocorreo@usda.gov', '0508252367', 8256887486);

EXECUTE PC_clientes.de_cliente (1006);

EXECUTE PC_clientes.ad_personaNatural ('7712586634', '27/06/1998', 780);

EXECUTE PC_clientes.ad_personaJuridica ('296253916-5', 'Razon Social', 23);

EXECUTE PC_clientes.up_personaJuridica ('296253916-5', 'Nueva Razon Social');

EXECUTE PC_solicitudes.ad_solicitud (101, 'Descripcion Solicitud', '24/08/2020', 32, 3364909962);

EXECUTE PC_solicitudes.up_solicitud (101, 'Nueva Descripcion Solicitud', 3364909962);

EXECUTE PC_solicitudes.de_solicitud (1);

EXECUTE PC_demandas.ad_demanda (1006, 15, 'Pretencion Demanda', 526763072, '07/02/2021', 99, 8);

EXECUTE PC_demandas.up_demanda (1006, 'Nueva Pretencion Demanda', 5000000, '08/02/2021', 9);

EXECUTE PC_demandas.ad_hecho (1006, 60, 20, '26/01/2022', 'Descripcion hecho');

EXECUTE PC_demandas.up_hecho (1006, '26/02/2022', 'Nueva Descripcion hecho');

EXECUTE PC_demandas.de_hecho (1000);

EXECUTE PC_demandas.ad_prueba (1001, 'REJ', null, 'Medio prueba', 75);

EXECUTE PC_demandas.up_prueba (1001, 'DIP', 'Nueva Descripcion', 'Medio prueba 2');

EXECUTE PC_demandas.de_prueba (1000);

EXECUTE PC_demandas.ad_fundamentoDerecho (1006, 'Art.1006', 'Descripcion fundamento');

EXECUTE PC_demandas.up_fundamentoDerecho (1000, 'Nueva descripcion del fundamento');

EXECUTE PC_demandas.ad_demFun (1000, 1000);

EXECUTE PC_demandas.de_demFun (1000, 1000);

EXECUTE PC_demandas.ad_caso (10006, 'Cancelado', null, 1006);

EXECUTE PC_demandas.up_caso (10006, 'Terminado', 'Perdido');

EXECUTE PC_demandas.ad_sentencia (1006, '08/01/2021', 'Fallo', 865, '5281141333');

VARIABLE consulta_cuatro REFCURSOR;
EXECUTE :consulta_cuatro:=PC_demandas.co_hecho(583); 
PRINT :consulta_cuatro;

VARIABLE consulta_cinco REFCURSOR;
EXECUTE :consulta_cinco:=PC_demandas.co_demanda(69); 
PRINT :consulta_cinco;

EXECUTE PC_audiencias.ad_audiencia (1006, '29/08/2021', 100, '7489092388', 872);

EXECUTE PC_audiencias.up_audiencia (1006, '29/08/2021', 100, '6882023816');

EXECUTE PC_audiencias.de_audiencia (1000);

VARIABLE consulta_seis REFCURSOR;
EXECUTE :consulta_seis:=PC_audiencias.co_audiencia('4123610951'); 
PRINT :consulta_seis;

EXECUTE PC_jueces.ad_juez ('8606360968', 'May Aslet', null, null);

EXECUTE PC_jueces.up_juez ('8547705333', null, null);

EXECUTE PC_jueces.de_juez ('8606360968');

EXECUTE PC_juzgados.ad_juzgado (1006, 'Hawthorn two', 'MS', 'rdaulbyk@mail.ru', '9366088384', 54);

EXECUTE PC_juzgados.up_juzgado (1006, 'Nuevo nombre', 'rdaulbyk@mail.ru', '9366088384', 762);