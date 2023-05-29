EXECUTE PA_abogado.ad_abogado (7196664674, 'cdrysdale40@trellian.com', '7900787231', 'Cati Drys', '17/02/1965', 56, null);

EXECUTE PA_abogado.ad_perfil (130, 'Descripcion perfil 2', 13, 2000000, null, 7196664674);

EXECUTE PA_abogado.ad_tarjetaProfesional ('717419', '14/10/2015', '09/12/2021', 'Xinjiang Normal University', 'Concejo', 7196664674);

VARIABLE consulta_uno REFCURSOR;
EXECUTE :consulta_uno:=PA_abogado.co_calificacion('6834216715'); 
PRINT :consulta_uno;

VARIABLE consulta_dos REFCURSOR;
EXECUTE :consulta_dos:=BD1000046442.PA_abogado.co_abogado('Derecho Familiar'); 
PRINT :consulta_dos;

EXECUTE PA_cliente.ad_cliente (101, 'Giffer Est', 'gnester19h@usda.gov', '0518252365', NULL);

EXECUTE PA_cliente.ad_cliente (1006, 'Maria Perez', 'gnester19h@usda.gov', '0518252365', NULL);


EXECUTE PA_cliente.ad_calificacion (100, 'Comentario Calificacion 100', 3, '26/08/2021', 13, 93);

EXECUTE PA_cliente.ad_solicitud (101, 'Descripcion Solicitud 2', '24/08/2020', 32, 7196664674);

EXECUTE PA_directorFirma.ad_firma ('956880881-5', 'Spinka Du', '4998488610', 'correo45@gmail.com', 37);

VARIABLE consulta_tres REFCURSOR;
EXECUTE :consulta_tres:=PA_directorFirma.co_firma('6708477211'); 
PRINT :consulta_tres;

EXECUTE PA_juez.ad_audiencia (1006, '29/08/2021', 100, '7489092388', 872);

VARIABLE consulta_cuatro REFCURSOR;
EXECUTE :consulta_cuatro:= PA_juez.co_audiencia('4123610951'); 
PRINT :consulta_cuatro;

EXECUTE PC_juzgados.up_juzgado (562, 'Nuevo nombre juzgado', 'rdaulbyka@mail.ru', '9466088384', 762);

VARIABLE consulta_cinco REFCURSOR;
EXECUTE :consulta_cinco:=PA_gerente.co_abogados; 
PRINT :consulta_cinco;

VARIABLE consulta_seis REFCURSOR;
EXECUTE :consulta_seis:=PA_gerente.co_firmas; 
PRINT :consulta_seis;

VARIABLE consulta_siete REFCURSOR;
EXECUTE :consulta_siete:=PA_gerente.co_juzgados; 
PRINT :consulta_siete;

VARIABLE consulta_ocho REFCURSOR;
EXECUTE :consulta_ocho:=PA_gerente.co_municipios; 
PRINT :consulta_ocho;

VARIABLE consulta_nueve REFCURSOR;
EXECUTE :consulta_nueve:=PA_gerente.co_meses; 
PRINT :consulta_nueve;