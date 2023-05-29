-- Atributos-Tupla 
-- TCalificacion
-- Valoracion mayor a 5
INSERT INTO calificaciones
    VALUES(1006, NULL, 6, '08/04/2022', 1001, 1001);

-- TCorreo
-- Sin arroba
INSERT INTO firmas
    VALUES('782903512-6', 'correonombre.uno', '3206734490', 'correonombre.uno', 5);
-- Sin punto
INSERT INTO abogados
    VALUES('1003618876', 'correo@nombredos', '3184617625', 'nombre dos', 
           '12/12/1984', 13, '782903512-6');
-- Sin caracteres antes del arroba
INSERT INTO clientes 
    VALUES(1, 'nombre tres', '@nombre.tres', '3147335536', '1003618876');
-- Sin caracteres entre el arroba y el punto
INSERT INTO jueces
    VALUES('1003615431', 'nombre cuatro', 'correo@.cuatro', NULL);
-- Sin caracteres despues del punto
INSERT INTO juzgados
    VALUES(1, 'nombre cinco', 'FA', 'correo@nombre.', '3218530710', 2);

-- TDuracion
-- Duracion mayor a 240 minutos
INSERT INTO audiencias
    VALUES(1, '21/03/2021', 241, '1003615431', 1);

-- TEstado
-- Tipo de estado que no esta dentro de los establecidos
INSERT INTO casos
    VALUES(1, 'Finalizado', 'Ganado', 101);

-- TJuzgado
-- Tipo de juzgado que no esta dentro de los establecidos
INSERT INTO juzgados
    VALUES(2, 'nombre seis', 'CA', 'correo@nombre.seis', '3137685430', 3);

-- TMoneda
-- precio menor que cero
INSERT INTO Asesorias
    VALUES(1, 'asesoria uno', '21/03/2021', 124, -1000000, '1003618876', 1);
    
--TNit
-- No cumpla con el formato del NIT
INSERT INTO personasJuridicas
    VALUES('7829035126', 'Razon social uno', 1);

-- TNombre
-- Nombre sin espacios
INSERT INTO jueces
    VALUES('1005984735', 'nombresiete', 'correo@numero.siete', '3156328762');
    
-- TNuip
-- NUIP con caracteres que no son digitos
INSERT INTO personasNaturales
    VALUES('100361886A', '17/01/2003', 1);
    
-- TPrueba
-- Tipo de prueba que no esta dentro de los establecidos
INSERT INTO pruebas
    VALUES(1, 'INS', 'Descripcion prueba uno', 'medio prueba', 1);

-- TResultado
-- Tipo de resultado que no esta dentro de los establecidos
INSERT INTO casos
    VALUES(2, 'Activo', 'Ga', 101);

-- TTelefono
-- Telefono con caracteres que no son digitos
INSERT INTO jueces
    VALUES('1005984735', 'nombre ocho', 'correo@numero.ocho', '315632876A');

-- Nulidades
-- Ingresar una tarjeta profesional sin universidad
INSERT INTO tarjetasProfesionales
    VALUES ('118298', '04/10/2020', '12/05/1998', NULL, 'pede malesuada', 4526457663);

-- Ingresar un abogado sin nombre
INSERT INTO abogados 
    VALUES (4526457664, 'abye@shareasale.com', '9567034628', NULL, '20/04/1967', 32, '871765399-7');

-- Ingresar una asesoria sin fecha
INSERT INTO asesorias
    VALUES (101, 'Descripcion asesoria', NULL, 120, 1000000, 6064916141, 23);

-- Un estudio sin titulo
INSERT INTO estudios
    VALUES (101, NULL, 'University of London', '25/11/2008', '26/12/2016', 86);
    
-- Un perfil sin descripcion
INSERT INTO perfiles
    VALUES (101, NULL, 41, 1151498822, 2.3, 4526457663);

-- Calificacion sin valoracion
INSERT INTO calificaciones 
    VALUES (1, 'Comentario calificacion', NULL, '13/02/2021', 47, 47);

-- Ingresar una pueba sin tipo
INSERT INTO pruebas 
    VALUES (101, NULL, 'Descripcion prueba', 'Video', 51);

-- Claves Primarias
-- Repetir el numero de una tarjeta profesional
INSERT INTO tarjetasProfesionales
    VALUES ('118297', '04/10/2020', '12/05/1998', 'Yamanashi University', 'pede malesuada', 4526467663);

-- NUIP abogado repetido
INSERT INTO abogados
    VALUES (4526457663, 'abye0@shareale.com', '9567035638', 'Alexandre Bye', '20/04/1967', 35, '871765399-7');

-- Repetir el NIT de una firma
INSERT INTO firmas 
    VALUES ('658348525-0', 'Grady and Lang', '2234164392', null, 54);
    
-- Ingresar una especialidad que ya tenia un abogado
INSERT INTO espAbog 
    VALUES (1243158530, 13);
    
-- Claves Unicas
-- Ingresar un lugar con una direccion que ya tenia otro
INSERT INTO lugares 
    VALUES (101, 'Cauca', 'Villa Rica', '19521 Westridge Pass');

-- Ingresar una firma con un nombre repetido
INSERT INTO firmas
    VALUES ('658348526-0', 'Grady, Roob and Lang', '2234064392', null, 54);

-- Repetir el correo de un cliente 
INSERT INTO clientes 
    VALUES (101, 'Step Hanus', 'jairs0@acquirethisname.com', '5990503684', 9202293643);
    
-- Ingresar una tarjeta profesional con abogado que ya tenia tarjeta
INSERT INTO tarjetasProfesionales
    VALUES ('118387', '04/10/2020', '12/05/1998', 'Yamanashi University', 'pede malesuada', '5572066346');

-- Repetir la demanda en un caso
INSERT INTO casos
    VALUES (1006, 'Activo', 'Ganado', 341);

-- Claves Foraneas
-- Ingresar un contrato con un abogado que no existe
INSERT INTO contratos 
    VALUES (1, '06/05/2021', 'Descripcion contrato', 'Forma pago', 500000, 54, '9999999999', 90);
    
-- Juzgado con un lugar que no existe
INSERT INTO juzgados
    VALUES (101, 'Littleleaf back', 'CM', 'ctarbard7@constantcontact.com', '1734333622', 1500);

-- Demanda con un cliente que no existe
INSERT INTO demandas
    VALUES (101, 11, 'Pretencion demanda', 500000, '19/05/2021', 1500, 84);

-- Ingresar un hecho con una demanda que no existe
INSERT INTO hechos
    VALUES (101, 61, 1500, '24/05/2020', 'Descripcion hecho');

-- Audiencias con juez que no existe
INSERT INTO audiencias
    VALUES (101, '09/02/2021', 71, '9999999999', 30);
