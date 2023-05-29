INSERT INTO calificaciones (comentario, valoracion, clientes_id, perfiles_id)
    VALUES ('Comentario seis', 4, 5, 4);

INSERT INTO firmas 
    VALUES('860000643-8', 'Lloreda S A S',
            '6016065611', NULL, 1);

INSERT INTO abogados
    VALUES ('8437983344', NULL, '3369550678',
            'Harri Lane', '06/02/1989', 3, NULL);

INSERT INTO solicitudes (descripcion, clientes_id, abogados_nuip)
    VALUES ('Descripcion seis', 6, '4526457663');

INSERT INTO lugares (departamento, municipio, direccion)
    VALUES ('Atlántico', 'Barranquilla', NULL);
    
INSERT INTO areas (nombre, descripcion)
    VALUES ('Derecho Mercantil', 'Descripcion area');

INSERT INTO estudios (titulo, universidad, fecha_inicio, fecha_final, perfiles_id)
    VALUES ('Environmental Specialist', 'Universidade Fernando Pessoa',
            '13/09/2015', '11/03/2019', 561);

INSERT INTO asesorias (descripcion, fecha, duracion, precio, abogados_nuip, clientes_id)
    VALUES ('Descripcion seis', '19/06/2019', 120, 500000, '4526457663', 2);


INSERT INTO contratos (fecha_firma, descripcion, forma_pago, remuneracion, clientes_id, abogados_nuip, lugares_id)
    VALUES ('09/10/2020', 'Descripcion seis', 'Forma seis', 1000000,
            2, '4526457663', 1);

INSERT INTO clientes (nombre, correo, telefono, abogados_nuip)
    VALUES ('Abernathy Lockman', 'clientecinco@gmail.com', 
            '6927071632', '4526457663');
            
INSERT INTO demandas (demandado, pretencion, cuantia, fecha, clientes_id, juzgados_id)
    VALUES (27, 'Pretencion demanda', 5000000, '18/08/2021', 38, 24);
    
INSERT INTO hechos (lugares_id, demandas_id, fecha, descripcion)
    VALUES (98, 28, '22/06/2020', 'Descripcion Hecho');
    
INSERT INTO pruebas (tipo, descripcion, medio, hechos_id)
    VALUES ('DPR', null, 'Video', 56);
    
INSERT INTO fundamentosDerechos (norma_juridica, descripcion)
    VALUES ('Art.101', 'Descripcion fundamento');
        
INSERT INTO juzgados (nombre, tipo, correo, telefono, lugares_id)
    VALUES ('Nombre juzgado', 'PR', 'juzgado@tamu.edu', '8027508058', 78);

INSERT INTO audiencias (fecha, duracion, jueces_nuip, juzgados_id)
    VALUES ('15/10/2020', 50, 9503598451, 7);