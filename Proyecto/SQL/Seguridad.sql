CREATE ROLE abogado;

GRANT EXECUTE
ON PA_abogado
TO abogado;

CREATE ROLE clienteCG;

GRANT EXECUTE
ON PA_cliente
TO clienteCG;

CREATE ROLE directorFirma;

GRANT EXECUTE
ON PA_directorFirma
TO directorFirma;

CREATE ROLE juez;

GRANT EXECUTE
ON PA_juez
TO juez;

