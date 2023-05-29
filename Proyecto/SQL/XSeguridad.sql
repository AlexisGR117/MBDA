-- Revocacion de permisos
REVOKE EXECUTE ON PA_abogado FROM abogado;
REVOKE EXECUTE ON PA_cliente FROM clienteCG;
REVOKE EXECUTE ON PA_directorFirma FROM directorFirma;
REVOKE EXECUTE ON PA_juez FROM juez;

-- Eliminacion de paquetes
DROP PACKAGE PA_abogado;
DROP PACKAGE PA_directorFirma;
DROP PACKAGE PA_cliente;
DROP PACKAGE PA_juez;

-- Eliminacion de roles
DROP ROLE abogado;
DROP ROLE clienteCG;
DROP ROLE directorFirma;
DROP ROLE juez;
