-- Ingresar de una calificacion con un perfil que no existe
EXECUTE PC_abogados.ad_calificacion (100, 'Comentario Calificacion 2', 2, '26/08/2021', 13, 1700);

-- Asesoria con duracion mayor a la establecida
EXECUTE PC_asesorias.ad_asesoria (101, 'Descripcion asesoria', '14/09/2021', 400, 500000, 3227082675, 5);

-- Lugar con direccion que ya existe
EXECUTE PC_lugares.ad_lugar (101, 'Vaupés', 'Yavaraté', '512 Sloan Hill');

-- Repetir el nombre de una area
EXECUTE PC_areas.ad_area (30, 'Derecho Penal', 'Descripcion area');

-- Actualizar el nombre de una firma a nulo
EXECUTE PC_firmas.up_firma ('990175312-9', NULL, '4998388610', 'correonuevo@gmail.com', 27);

-- Actualizar la remuneracion de un contrato con un númeroque excede el tamaño establecido
EXECUTE PC_contratos.up_contrato (1, 'Descripcion contrato', 'forma pago', 500000000000, 57);

-- Eliminar un cliente con contratos o demandas asociados
EXECUTE PC_clientes.de_cliente (1);

-- Agregar un solicitud con un usuario que no existe
EXECUTE PC_solicitudes.ad_solicitud (120, 'Descripcion Solicitud', '24/08/2020', 1700, 3364909962);

-- Actualizar una tipo de prueba que no existe
EXECUTE PC_demandas.up_prueba (500, 'TIPO', 'Nueva Descripcion prueba', 'Medio prueba 3');

-- Eliminar un juez con audiencias o sentencias asociadas
EXECUTE PC_jueces.de_juez ('8547705333');