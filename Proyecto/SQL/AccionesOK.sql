-- Las firmas se pueden eliminar en cualquier momento
DELETE FROM firmas WHERE nit = '391090737-2';

-- Cliente sin contratos y demandas asociados
DELETE FROM clientes WHERE id = 1001;
-- Cliente con demandas o contratos asociados
DELETE FROM clientes WHERE id = 12;

-- Abogado sin contratos asociados
DELETE FROM abogados WHERE nuip = '8531133246';
-- Abogado con contratos asociados
DELETE FROM abogados WHERE nuip = '7740474207';

-- Un perfil se puede eliminar en cualquier momento
DELETE FROM perfiles WHERE abogados_nuip = '3036640983';

-- Un hecho se puede eliminar en cualquier momento
DELETE FROM hechos WHERE id = 47;

