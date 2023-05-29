CREATE TABLE musician(
    m_no            NUMBER(11) NOT NULL, 
	m_name          VARCHAR2(20),
	born            DATE,
	died            DATE,
	born_in         NUMBER(11),
	living_in       NUMBER(11));
CREATE TABLE performer(
    perf_no         NUMBER(11) NOT NULL,
    perf_is         NUMBER(11),
    instrument      VARCHAR2(10) NOT NULL,
    perf_type       VARCHAR2(10));
CREATE TABLE composer(
    comp_no         NUMBER(11) NOT NULL,
    comp_is         NUMBER(11) NOT NULL,
    comp_type       VARCHAR2(10));
CREATE TABLE place(
    place_no        NUMBER(11) NOT NULL,
    place_town      VARCHAR2(20),
    place_country   VARCHAR2(20));  
CREATE TABLE band(
    band_no         NUMBER(11),
    band_name       VARCHAR2(20) NOT NULL,
    band_home       NUMBER(11) NOT NULL,
    band_type       VARCHAR2(10),
    b_date          DATE,
    band_contact    NUMBER(11) NOT NULL,
    informacion     XMLTYPE); 
CREATE TABLE composition(
    c_no            NUMBER(11) NOT NULL,
    comp_date       DATE,
    c_title         VARCHAR2(40) NOT NULL,
    c_in            NUMBER(11));
CREATE TABLE has_composed(
    cmpr_no         NUMBER(11) NOT NULL,
    cmpn_no         NUMBER(11) NOT NULL);
CREATE TABLE plays_in(
    player          NUMBER(11) NOT NULL,
    band_id         NUMBER(11) NOT NULL);
CREATE TABLE concert(
    concert_no          NUMBER(11) NOT NULL,
    concert_venue       VARCHAR(20),
    concert_in          NUMBER(11) NOT NULL,
    con_date            DATE NOT NULL,
    concert_orgniser    NUMBER(11) NOT NULL);
CREATE TABLE performance(
    pfrmnc_no           NUMBER(11) NOT NULL,
    gave                NUMBER(11) NOT NULL,
    performed           NUMBER(11) NOT NULL,
    conducted_by        NUMBER(11) NOT NULL,
    performed_in        NUMBER(11) NOT NULL);

ALTER TABLE musician ADD CONSTRAINT PK_musician
    PRIMARY KEY (m_no);
ALTER TABLE performer ADD CONSTRAINT PK_performer
    PRIMARY KEY (perf_no);
ALTER TABLE composer ADD CONSTRAINT PK_composer
    PRIMARY KEY (comp_no);
ALTER TABLE place ADD CONSTRAINT PK_place
    PRIMARY KEY (place_no);
ALTER TABLE band ADD  CONSTRAINT PK_band
    PRIMARY KEY (band_no);
ALTER TABLE composition ADD CONSTRAINT PK_composition
    PRIMARY KEY (c_no);
ALTER TABLE has_composed ADD CONSTRAINT PK_has_composed
    PRIMARY KEY (cmpn_no, cmpr_no);
ALTER TABLE plays_in ADD CONSTRAINT PK_plays_in
    PRIMARY KEY (player, band_id);
ALTER TABLE performance ADD CONSTRAINT PK_performance
    PRIMARY KEY (pfrmnc_no);
ALTER TABLE concert ADD CONSTRAINT PK_concert
    PRIMARY KEY (concert_no);

ALTER TABLE band ADD CONSTRAINT UK_band_band_name
    UNIQUE (band_name);
ALTER TABLE composition ADD CONSTRAINT UK_composition_c_title
    UNIQUE (c_title);

ALTER TABLE musician ADD CONSTRAINT FK_musician_place
    FOREIGN KEY (born_in) REFERENCES place(place_no);
ALTER TABLE musician ADD CONSTRAINT FK_musician_place1
    FOREIGN KEY (living_in) REFERENCES place(place_no);
ALTER TABLE performer ADD CONSTRAINT FK_performer_musician
    FOREIGN KEY (perf_is) REFERENCES musician(m_no);
ALTER TABLE composer ADD CONSTRAINT FK_composer_musician
    FOREIGN KEY (comp_is) REFERENCES musician(m_no);
ALTER TABLE band ADD CONSTRAINT FK_band_place
    FOREIGN KEY (band_home) REFERENCES place(place_no);
ALTER TABLE band ADD CONSTRAINT FK_band_musician
    FOREIGN KEY (band_contact) REFERENCES musician(m_no);
ALTER TABLE performance ADD CONSTRAINT FK_performance_band
    FOREIGN KEY (gave) REFERENCES band(band_no);
ALTER TABLE composition ADD CONSTRAINT FK_compostion_place
    FOREIGN KEY (c_in) REFERENCES place(place_no);
ALTER TABLE has_composed ADD CONSTRAINT FK_has_composed_composer
    FOREIGN KEY (cmpr_no) REFERENCES composer(comp_no);
ALTER TABLE has_composed ADD CONSTRAINT FK_has_composed_composition
    FOREIGN KEY (cmpn_no) REFERENCES composition(c_no);
ALTER TABLE plays_in ADD CONSTRAINT FK_plays_in_performer
    FOREIGN KEY (player) REFERENCES performer(perf_no); 
ALTER TABLE concert ADD CONSTRAINT FK_concert_musician
    FOREIGN KEY (concert_orgniser) REFERENCES musician(m_no); 
ALTER TABLE concert ADD CONSTRAINT FK_concert_place
    FOREIGN KEY (concert_in) REFERENCES place(place_no);
ALTER TABLE performance ADD CONSTRAINT FK_performance_composition
    FOREIGN KEY (performed) REFERENCES composition(c_no); 
ALTER TABLE performance ADD CONSTRAINT FK_performance_musician
    FOREIGN KEY (conducted_by) REFERENCES musician(m_no); 
ALTER TABLE performance ADD CONSTRAINT FK_performance_concert
    FOREIGN KEY (performed_in) REFERENCES concert(concert_no); 
    
ALTER TABLE band ADD CONSTRAINT CK_band_band_type
    CHECK (REGEXP_LIKE(band_type, '^\S+$'));
ALTER TABLE band ADD CONSTRAINT CK_band_band_name
    CHECK (REGEXP_LIKE(band_name, '\w{1,20}'));
/    
CREATE TRIGGER TR_BAND_BI
BEFORE INSERT ON band
FOR EACH ROW
DECLARE
    mayores NUMBER;
    vacio NUMBER;
    fecha_actual DATE;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM band;
    IF vacio < 2 THEN
        :NEW.band_no := vacio;
    ELSE
    SELECT MAX(band_no) + 1 INTO mayores FROM band;
        :NEW.band_no := mayores;
    END IF;
    SELECT current_date INTO fecha_actual FROM dual;
    :NEW.b_date := fecha_actual;
    IF :NEW.band_type IS NULL THEN
        :NEW.band_type := 'rock';
    END IF;
END;
/
ALTER TABLE band ADD CONSTRAINT CK_band_name_type
    CHECK (REGEXP_LIKE(band_name, '[^band_type]'));
/
CREATE TRIGGER TR_BAND_BU
BEFORE UPDATE OF band_no, band_name, band_home, b_date, band_contact ON band
FOR EACH ROW
BEGIN
    :NEW.band_no := :OLD.band_no;
    :NEW.band_name := :OLD.band_name;
    :NEW.band_home := :OLD.band_home;
    :NEW.b_date := :OLD.b_date;
    :NEW.band_contact := :OLD.band_contact;
END;
/
CREATE TRIGGER TR_PLAYS_IN_BI
BEFORE INSERT ON plays_in
FOR EACH ROW
DECLARE
    veces NUMBER;
BEGIN
    SELECT COUNT(*) INTO veces FROM band WHERE band_contact = :NEW.player;
    IF veces != 0 THEN
        DELETE FROM plays_in WHERE :NEW.player = player;
    END IF;
END;
/
CREATE TRIGGER TR_PLAYS_IN_BU
BEFORE UPDATE ON plays_in
FOR EACH ROW
BEGIN
    :NEW.player := :OLD.player;
    :NEW.band_id := :OLD.band_id;
END;
/
ALTER TABLE plays_in ADD CONSTRAINT FK_plays_in_band
    FOREIGN KEY (band_id) REFERENCES band(band_no) ON DELETE CASCADE;
    
INSERT INTO place VALUES(1, 'Manchester', 'England');
INSERT INTO place VALUES(2, 'Edinburgh', 'Scotland');
INSERT INTO place VALUES(3, 'Salzburg', 'Austria');
INSERT INTO place VALUES(4, 'New York', 'USA');
INSERT INTO place VALUES(5, 'Birmingham', 'England');
INSERT INTO place VALUES(6, 'Glasgow', 'Scotland');
INSERT INTO place VALUES(7, 'London', 'England');
INSERT INTO place VALUES(8, 'Chicago', 'USA');
INSERT INTO place VALUES(9, 'Amsterdam', 'Netherlands');

INSERT INTO musician VALUES (1, 'Fred Bloggs', TO_DATE('1948-01-02', 'YYYY-MM-DD'), NULL, 1, 2);
INSERT INTO musician VALUES (2, 'John Smith', TO_DATE('1950-03-03', 'YYYY-MM-DD'), NULL, 3, 4);
INSERT INTO musician VALUES (3, 'Helen Smyth', TO_DATE('1948-08-08', 'YYYY-MM-DD'), NULL, 4, 5);
INSERT INTO musician VALUES (4, 'Harriet Smithson', TO_DATE('1909-05-09', 'YYYY-MM-DD'), TO_DATE('1980-09-20', 'YYYY-MM-DD'), 5, 6);
INSERT INTO musician VALUES (5, 'James First', TO_DATE('1965-06-10', 'YYYY-MM-DD'), NULL, 7, 7);
INSERT INTO musician VALUES (6, 'Theo Mengel', TO_DATE('1948-08-12', 'YYYY-MM-DD'), NULL, 7, 1);
INSERT INTO musician VALUES (7, 'Sue Little', TO_DATE('1945-02-21', 'YYYY-MM-DD'), NULL, 8, 9);
INSERT INTO musician VALUES (8, 'Harry Forte', TO_DATE('1951-02-28', 'YYYY-MM-DD'), NULL, 1, 8);
INSERT INTO musician VALUES (9, 'Phil Hot', TO_DATE('1942-06-30', 'YYYY-MM-DD'), NULL, 2, 7);
INSERT INTO musician VALUES (10, 'Jeff Dawn', TO_DATE('1945-12-12', 'YYYY-MM-DD'), NULL, 3, 6);
INSERT INTO musician VALUES (11, 'Rose Spring', TO_DATE('1948-05-25', 'YYYY-MM-DD'), NULL, 4, 5);
INSERT INTO musician VALUES (12, 'Davis Heavan', TO_DATE('1975-10-03', 'YYYY-MM-DD'), NULL, 5, 4);
INSERT INTO musician VALUES (13, 'Lovely Time', TO_DATE('1948-12-28', 'YYYY-MM-DD'), NULL, 6, 3);
INSERT INTO musician VALUES (14, 'Alan Fluff', TO_DATE('1935-01-15', 'YYYY-MM-DD'), TO_DATE('1997-05-15', 'YYYY-MM-DD'), 7, 2);
INSERT INTO musician VALUES (15, 'Tony Smythe', TO_DATE('1932-04-02', 'YYYY-MM-DD'), NULL, 8, 1);
INSERT INTO musician VALUES (16, 'James Quick', TO_DATE('1924-08-08', 'YYYY-MM-DD'), NULL, 9, 2);
INSERT INTO musician VALUES (17, 'Freda Miles', TO_DATE('1920-07-04', 'YYYY-MM-DD'), NULL, 9, 3);
INSERT INTO musician VALUES (18, 'Elsie James', TO_DATE('1947-05-06', 'YYYY-MM-DD'), NULL, 8, 5);
INSERT INTO musician VALUES (19, 'Andy Jones', TO_DATE('1958-10-08', 'YYYY-MM-DD'), NULL, 7, 6);
INSERT INTO musician VALUES (20, 'Louise Simpson', TO_DATE('1948-01-10', 'YYYY-MM-DD'), TO_DATE('1998-02-11', 'YYYY-MM-DD'), 6, 6);
INSERT INTO musician VALUES (21, 'James Steeple', TO_DATE('1947-01-10', 'YYYY-MM-DD'), NULL, 5, 6);
INSERT INTO musician VALUES (22, 'Steven Chaytors', TO_DATE('1956-03-11', 'YYYY-MM-DD'), NULL, 6, 7);

INSERT INTO performer VALUES (1, 2, 'violin', 'classical');
INSERT INTO performer VALUES (2, 4, 'viola', 'classical');
INSERT INTO performer VALUES (3, 6, 'banjo', 'jazz');
INSERT INTO performer VALUES (4, 8, 'violin', 'classical');
INSERT INTO performer VALUES (5, 12, 'guitar', 'jazz');
INSERT INTO performer VALUES (6, 14, 'violin', 'classical');
INSERT INTO performer VALUES (7, 16, 'trumpet', 'jazz');
INSERT INTO performer VALUES (8, 18, 'viola', 'classical');
INSERT INTO performer VALUES (9, 20, 'bass', 'jazz');
INSERT INTO performer VALUES (10, 2, 'flute', 'jazz');
INSERT INTO performer VALUES (11, 20, 'cornet', 'jazz');
INSERT INTO performer VALUES (12, 6, 'violin', 'jazz');
INSERT INTO performer VALUES (13, 8, 'drums', 'jazz');
INSERT INTO performer VALUES (14, 10, 'violin', 'classical');
INSERT INTO performer VALUES (15, 12, 'cello', 'classical');
INSERT INTO performer VALUES (16, 14, 'viola', 'classical');
INSERT INTO performer VALUES (17, 16, 'flute', 'jazz');
INSERT INTO performer VALUES (18, 18, 'guitar', 'not known');
INSERT INTO performer VALUES (19, 20, 'trombone', 'jazz');
INSERT INTO performer VALUES (20, 3, 'horn', 'jazz');
INSERT INTO performer VALUES (21, 5, 'violin', 'jazz');
INSERT INTO performer VALUES (22, 7, 'cello', 'classical');
INSERT INTO performer VALUES (23, 2, 'bass', 'jazz');
INSERT INTO performer VALUES (24, 4, 'violin', 'jazz');
INSERT INTO performer VALUES (25, 6, 'drums', 'classical');
INSERT INTO performer VALUES (26, 8, 'clarinet', 'jazz');
INSERT INTO performer VALUES (27, 10, 'bass', 'jazz');
INSERT INTO performer VALUES (28, 12, 'viola', 'classical');
INSERT INTO performer VALUES (29, 18, 'cello', 'classical');

INSERT INTO composer VALUES (1, 1, 'jazz');
INSERT INTO composer VALUES (2, 3, 'classical');
INSERT INTO composer VALUES (3, 5, 'jazz');
INSERT INTO composer VALUES (4, 7, 'classical');
INSERT INTO composer VALUES (5, 9, 'jazz');
INSERT INTO composer VALUES (6, 11, 'rock');
INSERT INTO composer VALUES (7, 13, 'classical');
INSERT INTO composer VALUES (8, 15, 'jazz');
INSERT INTO composer VALUES (9, 17, 'classical');
INSERT INTO composer VALUES (10, 19, 'jazz');
INSERT INTO composer VALUES (11, 10, 'rock');
INSERT INTO composer VALUES (12, 8, 'jazz');

INSERT INTO band VALUES (1, 'ROP', 5, 'classical', TO_DATE('1930-01-01', 'YYYY-MM-DD'), 11,
'
<Informacion>
    <Web>www.ROP.com</Web>
    <Logo color="rojo" texto="texto ROP" imagen="imagenROP.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1ROP</Influencia>
        <Influencia>influencia2ROP</Influencia>
    </Influencias>
	<Discografia nombre="discografiaROP"  ano="2001" ventas="2000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2001" trabajo="trabajo1ROP" nombre="nombre1ROP" resultado="ganador"></Nominacion>
        <Nominacion ano="2007" trabajo="trabajo2ROP" nombre="nombre2ROP" resultado="nominado"></Nominacion>
	</Nominaciones>
</Informacion>
'
);

INSERT INTO band VALUES (2, 'AASO', 6, 'classical', NULL, 10,
'
<Informacion>
    <Web>www.AASO.com</Web>
    <Logo color="azul" texto="texto AASO" imagen="imagenAASO.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1AASO</Influencia>
    </Influencias>
	<Discografia nombre="discografiaAASO"  ano="2002" ventas="1000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2001" trabajo="trabajo1AASO" nombre="nombre1AASO" resultado="nominado"></Nominacion>
        <Nominacion ano="2004" trabajo="trabajo2AASO" nombre="nombre2AASO" resultado="nominado"></Nominacion>
        <Nominacion ano="2007" trabajo="trabajo3AASO" nombre="nombre3AASO" resultado="nominado"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (3, 'The J Bs', 8, 'jazz', NULL, 12,
'
<Informacion>
    <Web>www.TheJBs.com</Web>
    <Logo color="rojo" texto="texto TheJBs" imagen="imagenTheJBs.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1TheJBs</Influencia>
        <Influencia>influencia2TheJBs</Influencia>
    </Influencias>
	<Discografia nombre="discografiaTheJBs"  ano="2003" ventas="3000"></Discografia>
	<Nominaciones>
        <Nominacion ano="1999" trabajo="trabajo1TheJBs" nombre="nombre1TheJBs" resultado="nominado"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (4, 'BBSO', 9, 'classical', NULL, 21,
'
<Informacion>
    <Web>www.BBSO.com</Web>
    <Logo color="verde" texto="texto BBSO" imagen="imagenBBSO.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1BBSO</Influencia>
        <Influencia>influencia2BBSO</Influencia>
        <Influencia>influencia3BBSO</Influencia>
    </Influencias>
	<Discografia nombre="discografiaBBSO"  ano="2000" ventas="5000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2011" trabajo="trabajo1BBSO" nombre="nombre1BBSO" resultado="ganador"></Nominacion>
        <Nominacion ano="2012" trabajo="trabajo2BBSO" nombre="nombre2BBSO" resultado="ganador"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (5, 'The left Overs', 2, 'jazz', NULL, 8,
'
<Informacion>
    <Web>www.TheleftOvers.com</Web>
    <Logo color="azul" texto="texto TheleftOvers" imagen="imagenTheleftOvers.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1TheleftOvers</Influencia>
        <Influencia>influencia2TheleftOvers</Influencia>
        <Influencia>influencia3TheleftOvers</Influencia>
        <Influencia>influencia4TheleftOvers</Influencia>
        <Influencia>influencia5TheleftOvers</Influencia>
        <Influencia>influencia6TheleftOvers</Influencia>
    </Influencias>
	<Discografia nombre="discografiaTheleftOvers"  ano="2004" ventas="20000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2009" trabajo="trabajo1TheleftOvers" nombre="nombre1TheleftOvers" resultado="nominado"></Nominacion>
        <Nominacion ano="2013" trabajo="trabajo2TheleftOvers" nombre="nombre2TheleftOvers" resultado="ganador"></Nominacion>
        <Nominacion ano="2017" trabajo="trabajo3TheleftOvers" nombre="nombre3TheleftOvers" resultado="nominado"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (6, 'Somebody Loves this', 1, 'jazz', NULL, 6,
'
<Informacion>
    <Web>www.SomebodyLovesthis.com</Web>
    <Logo color="rojo" texto="texto ROP" imagen="imagenSomebodyLovesthis.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1SomebodyLovesthis</Influencia>
        <Influencia>influencia2SomebodyLovesthis</Influencia>
    </Influencias>
	<Discografia nombre="discografiaSomebodyLovesthis"  ano="2003" ventas="9000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2020" trabajo="trabajo1SomebodyLovesthis" nombre="nombre1SomebodyLovesthis" resultado="ganador"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (7, 'Oh well', 4, 'classical', NULL, 3,
'
<Informacion>
    <Web>www.Ohwell.com</Web>
    <Logo color="amarillo" texto="texto Ohwell" imagen="imagenOhwell.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1Ohwell</Influencia>
        <Influencia>influencia2Ohwell</Influencia>
        <Influencia>influencia2Ohwell</Influencia>
        <Influencia>influencia2Ohwell</Influencia>
    </Influencias>
	<Discografia nombre="discografiaOhwell"  ano="2001" ventas="7000"></Discografia>
	<Nominaciones>
        <Nominacion ano="1997" trabajo="trabajo1Ohwell" nombre="nombre1Ohwell" resultado="nominado"></Nominacion>
        <Nominacion ano="2006" trabajo="trabajo2Ohwell" nombre="nombre2Ohwell" resultado="nominado"></Nominacion>
        <Nominacion ano="2011" trabajo="trabajo3Ohwell" nombre="nombre3Ohwell" resultado="ganador"></Nominacion>
        <Nominacion ano="2021" trabajo="trabajo4Ohwell" nombre="nombre4Ohwell" resultado="ganador"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (8, 'Swinging strings', 4, 'classical', NULL, 7,
'
<Informacion>
    <Web>www.Swingingstrings.com</Web>
    <Logo color="azul" texto="texto Swingingstrings" imagen="imagenSwingingstrings.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1Swingingstrings</Influencia>
    </Influencias>
	<Discografia nombre="discografiaSwingingstrings"  ano="2012" ventas="200000"></Discografia>
	<Nominaciones>
        <Nominacion ano="2002" trabajo="trabajo1Swingingstrings" nombre="nombre1Swingingstrings" resultado="nominado"></Nominacion>
        <Nominacion ano="2004" trabajo="trabajo2Swingingstrings" nombre="nombre2Swingingstrings" resultado="nominado"></Nominacion>
	</Nominaciones>
</Informacion>
'
);
INSERT INTO band VALUES (9, 'The Rest', 9, 'jazz', NULL, 16,
'
<Informacion>
    <Web>www.TheRest.com</Web>
    <Logo color="rojo" texto="textoTheRest" imagen="imagenTheRest.jpg"></Logo>
	<Influencias>
        <Influencia>influencia1TheRest</Influencia>
        <Influencia>influencia2TheRest</Influencia>
        <Influencia>influencia3TheRest</Influencia>
    </Influencias>
	<Discografia nombre="discografiaTheRest"  ano="2011" ventas="500"></Discografia>
	<Nominaciones>
            <Nominacion ano="2007" trabajo="trabajo1TheRest" nombre="nombre1TheRest" resultado="nominado"></Nominacion>
    </Nominaciones>
</Informacion>
'
);

-- Consultas

-- 1. El nombre y direccion del sitio web de todas las bandas.
SELECT band_name AS Banda,
extractvalue(Informacion,'/Informacion/Web') AS Web
    FROM band;
-- 2. El nombre de las bandas que tienen logos de color rojo
SELECT band_name AS Banda FROM band
    WHERE extractvalue(Informacion,'/Informacion/Logo/@color') = 'rojo';
-- 3. Las influencias de una banda dada
SELECT x.* FROM band, XMLTABLE('/Informacion/Influencias/Influencia'
                                PASSING band.Informacion 
                                COLUMNS "Influencias" VARCHAR2(30) PATH '/*') x
    WHERE band.band_name = '&Banda';
-- 4. La banda que ha logrado mayores ventas en sus discos
SELECT band_name FROM band, XMLTABLE('/Informacion/Discografia' 
                                    PASSING band.Informacion
                                    COLUMNS "ventas" VARCHAR2(30) PATH '/*/@ventas') x
WHERE x."ventas" IN (SELECT max(x."ventas")
    FROM band, XMLTABLE('/Informacion/Discografia'
        PASSING band.Informacion
        COLUMNS "ventas" VARCHAR2(30) PATH '/*/@ventas') x);
-- 5. Las bandas ganadoras en un año dado. (Nombre de la banda y nombre del trabajo)
SELECT band_name, x."trabajos" FROM band, XMLTABLE('/Informacion/Nominaciones/Nominacion'
                                PASSING band.Informacion 
                                COLUMNS "anos" VARCHAR2(30) PATH '/*/@ano',
                                "trabajos" VARCHAR2(30) PATH '/*/@trabajo') x
    WHERE x."anos" = '&ano';
-- 6. Las nominaciones que ha tenido una banda dada.
SELECT x.* FROM band, XMLTABLE('/Informacion/Nominaciones/Nominacion'
                                PASSING band.Informacion 
                                COLUMNS "anos" VARCHAR2(30) PATH '/*/@ano',
                                "trabajos" VARCHAR2(30) PATH '/*/@trabajo',
                                "nombres" VARCHAR2(30) PATH '/*/@nombre',
                                "resultados" VARCHAR2(30) PATH '/*/@resultado') x
    WHERE band_name = '&banda';
-- 7. Las bandas que han lo grado ventas mayores a cantidad dada.
SELECT band_name FROM band, XMLTABLE('/Informacion/Discografia' 
                                    PASSING band.Informacion
                                    COLUMNS "ventas" VARCHAR2(30) PATH '/*/@ventas') x
WHERE x."ventas" > &cantidad;


INSERT INTO composition VALUES (1, TO_DATE('1975-06-17', 'YYYY-MM-DD'), 'Opus 1', 1);
INSERT INTO composition VALUES (2, TO_DATE('1976-07-21', 'YYYY-MM-DD'), 'Here Goes', 2);
INSERT INTO composition VALUES (3, TO_DATE('1981-12-14', 'YYYY-MM-DD'), 'Valiant Knight', 3);
INSERT INTO composition VALUES (4, TO_DATE('1982-01-12', 'YYYY-MM-DD'), 'Little Piece', 4);
INSERT INTO composition VALUES (5, TO_DATE('1985-03-13', 'YYYY-MM-DD'), 'Simple Song', 5);
INSERT INTO composition VALUES (6, TO_DATE('1986-04-14', 'YYYY-MM-DD'), 'Little Swing Song', 6);
INSERT INTO composition VALUES (7, TO_DATE('1987-05-13', 'YYYY-MM-DD'), 'Fast Journey', 7);
INSERT INTO composition VALUES (8, TO_DATE('1976-02-14', 'YYYY-MM-DD'), 'Simple Love Song', 8);
INSERT INTO composition VALUES (9, TO_DATE('1982-01-21', 'YYYY-MM-DD'), 'Complex Rythms', 9);
INSERT INTO composition VALUES (10, TO_DATE('1985-02-23', 'YYYY-MM-DD'), 'Drumming Rythms', 9);
INSERT INTO composition VALUES (11, TO_DATE('1978-03-18', 'YYYY-MM-DD'), 'Fast Drumming', 8);
INSERT INTO composition VALUES (12, TO_DATE('1984-08-13', 'YYYY-MM-DD'), 'Slow Song', 7);
INSERT INTO composition VALUES (13, TO_DATE('1968-09-14', 'YYYY-MM-DD'), 'Blue Roses', 6);
INSERT INTO composition VALUES (14, TO_DATE('1983-11-15', 'YYYY-MM-DD'), 'Velvet Rain', 5);
INSERT INTO composition VALUES (15, TO_DATE('1982-05-16', 'YYYY-MM-DD'), 'Cold Wind', 4);
INSERT INTO composition VALUES (16, TO_DATE('1983-06-18', 'YYYY-MM-DD'), 'After the Wind Blows', 3);
INSERT INTO composition VALUES (17, NULL, 'A Simple Piece', 2);
INSERT INTO composition VALUES (18, TO_DATE('1985-01-12', 'YYYY-MM-DD'), 'Long Rythms', 1);
INSERT INTO composition VALUES (19, TO_DATE('1988-02-12', 'YYYY-MM-DD'), 'Eastern Wind', 1);
INSERT INTO composition VALUES (20, NULL, 'Slow Symphony Blowing', 2);
INSERT INTO composition VALUES (21, TO_DATE('1990-07-12', 'YYYY-MM-DD'), 'A Last Song', 6);

INSERT INTO has_composed VALUES (1, 1);
INSERT INTO has_composed VALUES (1, 8);
INSERT INTO has_composed VALUES (2, 11);
INSERT INTO has_composed VALUES (3, 2);
INSERT INTO has_composed VALUES (3, 13);
INSERT INTO has_composed VALUES (3, 14);
INSERT INTO has_composed VALUES (3, 18);
INSERT INTO has_composed VALUES (4, 12);
INSERT INTO has_composed VALUES (4, 20);
INSERT INTO has_composed VALUES (5, 3);
INSERT INTO has_composed VALUES (5, 13);
INSERT INTO has_composed VALUES (5, 14);
INSERT INTO has_composed VALUES (6, 15);
INSERT INTO has_composed VALUES (6, 21);
INSERT INTO has_composed VALUES (7, 4);
INSERT INTO has_composed VALUES (7, 9);
INSERT INTO has_composed VALUES (8, 16);
INSERT INTO has_composed VALUES (9, 5);
INSERT INTO has_composed VALUES (9, 10);
INSERT INTO has_composed VALUES (10, 17);
INSERT INTO has_composed VALUES (11, 6);
INSERT INTO has_composed VALUES (12, 7);
INSERT INTO has_composed VALUES (12, 19);

INSERT INTO plays_in VALUES (1, 1);
INSERT INTO plays_in VALUES (1, 7);
INSERT INTO plays_in VALUES (3, 1);
INSERT INTO plays_in VALUES (4, 1);
INSERT INTO plays_in VALUES (4, 7);
INSERT INTO plays_in VALUES (5, 1);
INSERT INTO plays_in VALUES (6, 1);
INSERT INTO plays_in VALUES (6, 7);
INSERT INTO plays_in VALUES (7, 1);
INSERT INTO plays_in VALUES (8, 1);
INSERT INTO plays_in VALUES (8, 7);
INSERT INTO plays_in VALUES (10, 2);
INSERT INTO plays_in VALUES (12, 2);
INSERT INTO plays_in VALUES (13, 2);
INSERT INTO plays_in VALUES (14, 2);
INSERT INTO plays_in VALUES (14, 8);
INSERT INTO plays_in VALUES (15, 2);
INSERT INTO plays_in VALUES (15, 8);
INSERT INTO plays_in VALUES (17, 2);
INSERT INTO plays_in VALUES (18, 2);
INSERT INTO plays_in VALUES (19, 3);
INSERT INTO plays_in VALUES (20, 3);
INSERT INTO plays_in VALUES (21, 4);
INSERT INTO plays_in VALUES (22, 4);
INSERT INTO plays_in VALUES (23, 4);
INSERT INTO plays_in VALUES (25, 5);
INSERT INTO plays_in VALUES (26, 6);
INSERT INTO plays_in VALUES (27, 6);
INSERT INTO plays_in VALUES (28, 7);
INSERT INTO plays_in VALUES (28, 8);
INSERT INTO plays_in VALUES (16, 7);

INSERT INTO concert VALUES (1, 'Bridgewater Hall', 1, '06/01/95', 21);
INSERT INTO concert VALUES (2, 'Bridgewater Hall', 1, '08/05/96', 3);
INSERT INTO concert VALUES(3, 'Usher Hall', 2, '03/06/95', 3);
INSERT INTO concert VALUES (4, 'Assembly Rooms', 2, '20/09/97', 21);
INSERT INTO concert VALUES (5, 'Festspiel Haus', 3, '21/02/95', 8);
INSERT INTO concert VALUES (6, 'Royal Albert Hall', 7, '12/04/93', 8);
INSERT INTO concert VALUES (7, 'Concertgebouw', 9, '14/05/93', 8);
INSERT INTO concert VALUES (8, 'Metropolitan', 4, '15/06/97', 21);

INSERT INTO performance VALUES (1, 1, 1, 21, 1);
INSERT INTO performance VALUES (2, 1, 3, 21, 1);
INSERT INTO performance VALUES (3, 1, 5, 21, 1);
INSERT INTO performance VALUES (4, 1, 2, 1, 2);
INSERT INTO performance VALUES (5, 2, 4, 21, 2);
INSERT INTO performance VALUES (6, 2, 6, 21, 2);
INSERT INTO performance VALUES (7, 4, 19, 9, 3);
INSERT INTO performance VALUES (8, 4, 20, 10, 3);
INSERT INTO performance VALUES (9, 5, 12, 10, 4);
INSERT INTO performance VALUES (10, 5, 13, 11, 4);
INSERT INTO performance VALUES (11, 3, 5, 13, 5);
INSERT INTO performance VALUES (12, 3, 6, 13, 5);
INSERT INTO performance VALUES (13, 3, 7, 13, 5);
INSERT INTO performance VALUES (14, 6, 20, 14, 6);
INSERT INTO performance VALUES (15, 8, 12, 15, 7);
INSERT INTO performance VALUES (16, 9, 16, 21, 8);
INSERT INTO performance VALUES (17, 9, 17, 21, 8);
INSERT INTO performance VALUES (18, 9, 18, 21, 8);
INSERT INTO performance VALUES (19, 9, 19, 21, 8);
INSERT INTO performance VALUES (20, 4, 12, 10, 3);

    


-- XDisparadores

DROP TRIGGER TR_BAND_BI;
DROP TRIGGER TR_BAND_BU;
DROP TRIGGER TR_PLAYS_IN_BI;
DROP TRIGGER TR_PLAYS_IN_BU;

-- XPoblar

DELETE FROM performance;
DELETE FROM concert;
DELETE FROM has_composed;
DELETE FROM plays_in;
DELETE FROM band;
DELETE FROM composition;
DELETE FROM performer;
DELETE FROM composer;
DELETE FROM musician;
DELETE FROM place;

-- XTablas

DROP TABLE performance;
DROP TABLE concert;
DROP TABLE has_composed;
DROP TABLE plays_in;
DROP TABLE band;
DROP TABLE composition;
DROP TABLE performer;
DROP TABLE composer;
DROP TABLE musician;
DROP TABLE place;

