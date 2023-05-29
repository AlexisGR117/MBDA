-- CICLO 1: Tablas

CREATE TABLE users(
    id              NUMBER(5) NOT NULL, 
	email           VARCHAR2(100) NOT NULL,
	name            VARCHAR2(50) NOT NULL,
	createdAT       DATE NOT NULL);
CREATE TABLE accounts(
    id              NUMBER(5) NOT NULL,
    users_id	    NUMBER(5) NOT NULL,
    name            VARCHAR2(70) NOT NULL,
    createdAt       DATE NOT NULL,
    subscribers     NUMBER(5) NOT NULL);
CREATE TABLE exclusiveness(
    code            VARCHAR2(9) NOT NULL,
    accounts_id	    NUMBER(5) NOT NULL,
    orden           NUMBER(3) NOT NULL,
    name            VARCHAR2(55) NOT NULL,
    price           NUMBER(9),
    duration        NUMBER(2));
CREATE TABLE subscriptions(
    id		        NUMBER(5) NOT NULL,
    accounts_id	    NUMBER(5) NOT NULL,
    subscribed_to   NUMBER(5) NOT NULL,
    createdAt       DATE NOT NULL,
    detail	        XMLTYPE);
CREATE TABLE contents(
    id                  NUMBER(10) NOT NULL,
    users_id            NUMBER(5) NOT NULL,
    exclusiveness_code  VARCHAR2(9),
    title               VARCHAR2(20) NOT NULL,
    publishingDate      DATE NOT NULL,
    description         VARCHAR2(30));
CREATE TABLE stages(
    exclusiveness_code  VARCHAR2(9) NOT NULL,
    subscriptions_id    NUMBER(5) NOT NULL,
    startAT             DATE NOT NULL,
    endAT               DATE,
    price               NUMBER(9) NOT NULL,
    status              VARCHAR2(9) NOT NULL);
CREATE TABLE lables(
    exclusiveness_code	VARCHAR2(9) NOT NULL,
    lable         	    VARCHAR2(10) NOT NULL);
CREATE TABLE likes(
    users_id	        NUMBER(5) NOT NULL,
    contents_id         NUMBER(10) NOT NULL);
CREATE TABLE videos(
    contents_id         NUMBER(10) NOT NULL,
    duration            NUMBER(4) NOT NULL);
CREATE TABLE events(
    contents_id         NUMBER(10) NOT NULL,
    plannedDate         DATE,
    duration            NUMBER(4));
CREATE TABLE posts(
    contents_id         NUMBER(10) NOT NULL,
    text                VARCHAR2(50) NOT NULL);

-- CICLO 1: Atributos

ALTER TABLE stages ADD CONSTRAINT CK_stage_status
    CHECK (status IN ('Active', 'Finished', 'Cancelled'));
ALTER TABLE exclusiveness ADD CONSTRAINT CK_exclusiveness_code
    CHECK (REGEXP_LIKE(code, '^EX-\d{6}'));
ALTER TABLE lables ADD CONSTRAINT CK_lables_lable
    CHECK (lable LIKE '#%');
ALTER TABLE exclusiveness ADD CONSTRAINT CK_exclusiveness_duration
    CHECK (duration between 1 AND 90);
ALTER TABLE users ADD CONSTRAINT CK_users_email
    CHECK (email LIKE '%@%.%');
ALTER TABLE videos ADD CONSTRAINT CK_videos_duration
    CHECK (duration between 1 AND 1380);
ALTER TABLE events ADD CONSTRAINT CK_events_duration
    CHECK (duration between 1 AND 1380);  
ALTER TABLE exclusiveness ADD CONSTRAINT CK_exclusiveness_price
    CHECK (price >= 0);
ALTER TABLE stages ADD CONSTRAINT CK_stages_price
    CHECK (price >= 0);
ALTER TABLE exclusiveness ADD CONSTRAINT CK_exclusiveness_orden
    CHECK (orden >= 0);
ALTER TABLE exclusiveness ADD CONSTRAINT CK_exclusiveness_price_2
    CHECK (price <= 500000000);
ALTER TABLE stages ADD CONSTRAINT CK_stages_price_2
    CHECK (price <= 500000000);  
ALTER TABLE users ADD CONSTRAINT CK_users_name
    CHECK (name LIKE '% %');    

-- CICLO 1: Primarias

ALTER TABLE users ADD CONSTRAINT PK_users
    PRIMARY KEY (id);
ALTER TABLE accounts ADD CONSTRAINT PK_accounts
    PRIMARY KEY (id);
ALTER TABLE exclusiveness ADD CONSTRAINT PK_exclusiveness
    PRIMARY KEY (code);
ALTER TABLE subscriptions ADD CONSTRAINT PK_subscriptions
    PRIMARY KEY (id);
ALTER TABLE contents ADD  CONSTRAINT PK_contents
    PRIMARY KEY (id);
ALTER TABLE stages ADD CONSTRAINT PK_stages
    PRIMARY KEY (exclusiveness_code, subscriptions_id);
ALTER TABLE lables ADD CONSTRAINT PK_lables
    PRIMARY KEY (exclusiveness_code, lable);
ALTER TABLE likes ADD CONSTRAINT PK_likes
    PRIMARY KEY (users_id, contents_id);
ALTER TABLE videos ADD CONSTRAINT PK_videos
    PRIMARY KEY (contents_id);
ALTER TABLE events ADD CONSTRAINT PK_events
    PRIMARY KEY (contents_id);
ALTER TABLE posts ADD CONSTRAINT PK_posts
    PRIMARY KEY (contents_id);

-- CICLO 1: Unicas

ALTER TABLE users ADD CONSTRAINT UK_users_email
    UNIQUE (email);

-- CICLO 1: Foraneas

ALTER TABLE accounts ADD CONSTRAINT FK_accounts_users
    FOREIGN KEY (users_id) REFERENCES users(id);
ALTER TABLE exclusiveness ADD CONSTRAINT FK_exclusiveness_accounts
    FOREIGN KEY (accounts_id) REFERENCES accounts(id);
ALTER TABLE subscriptions ADD CONSTRAINT FK_subscriptions_accounts
    FOREIGN KEY (accounts_id) REFERENCES accounts(id);
ALTER TABLE subscriptions ADD CONSTRAINT FK_subscriptions_subscribed_to
    FOREIGN KEY (subscribed_to) REFERENCES accounts(id);
ALTER TABLE contents ADD CONSTRAINT FK_contents_users
    FOREIGN KEY (users_id) REFERENCES users(id);
ALTER TABLE contents ADD CONSTRAINT FK_contents_exclusiveness
    FOREIGN KEY (exclusiveness_code) REFERENCES exclusiveness(code);
ALTER TABLE stages ADD CONSTRAINT FK_stages_exclusiveness
    FOREIGN KEY (exclusiveness_code) REFERENCES exclusiveness(code);
ALTER TABLE lables ADD CONSTRAINT FK_lables_exclusiveness
    FOREIGN KEY (exclusiveness_code) REFERENCES exclusiveness(code);
ALTER TABLE likes ADD CONSTRAINT FK_likes_contents
    FOREIGN KEY (contents_id) REFERENCES contents(id);
ALTER TABLE videos ADD CONSTRAINT FK_videos_contents
    FOREIGN KEY (contents_id) REFERENCES contents(id);
ALTER TABLE events ADD CONSTRAINT FK_events_contents
    FOREIGN KEY (contents_id) REFERENCES contents(id);
ALTER TABLE posts ADD CONSTRAINT FK_posts_contents
    FOREIGN KEY (contents_id) REFERENCES contents(id);
 
-- CICLO 1: CRUD: Mantener suscripcion 

ALTER TABLE stages ADD CONSTRAINT FK_stages_subscriptions
    FOREIGN KEY (subscriptions_id) REFERENCES subscriptions(id) ON DELETE CASCADE;
/
CREATE TRIGGER TR_SUSCRIPTION_BI
BEFORE INSERT ON subscriptions
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
    fecha DATE;
BEGIN
    SELECT COUNT(*) + 1 INTO vacio FROM subscriptions;
    IF vacio = 1 THEN 
        :NEW.id := vacio;
    ELSE 
        SELECT MAX(id) + 1 INTO mayor FROM subscriptions;
        :NEW.id := mayor;
    END IF;
    SELECT current_date INTO fecha FROM dual;
    :NEW.createdAt := fecha;
END;
/
CREATE TRIGGER TR_SUSCRIPTION_AI
AFTER INSERT ON subscriptions
FOR EACH ROW
DECLARE
    vacio NUMBER;
    fecha DATE;
    codigo VARCHAR2(9);
    existe NUMBER;
BEGIN
    SELECT current_date INTO fecha FROM dual;
    SELECT COUNT(*) INTO existe FROM exclusiveness WHERE orden = 0 AND accounts_id = :NEW.subscribed_to;
    IF existe = 0 THEN
        SELECT COUNT(*) INTO vacio FROM exclusiveness;
        IF vacio = 0 THEN
            codigo := 'EX-100001';
        ELSE
            SELECT CONCAT('EX-', TO_NUMBER(MAX(SUBSTR(code, 4, 9)))+1) INTO codigo FROM exclusiveness;
        END IF;
        INSERT INTO exclusiveness VALUES (codigo, :NEW.subscribed_to, 0, 'Free', NULL, NULL);
    ELSE
        SELECT code INTO codigo FROM exclusiveness WHERE orden = 0 AND accounts_id = :NEW.subscribed_to;
    END IF;
    INSERT INTO stages VALUES (codigo, :NEW.id, current_date, NULL, 0, 'Active');
END;
/
CREATE TRIGGER TR_SUSCRIPTION_BU
BEFORE UPDATE ON subscriptions
FOR EACH ROW
BEGIN
    :NEW.id  := :OLD.id;
    :NEW.accounts_id  := :OLD.accounts_id;
    :NEW.subscribed_to := :OLD.subscribed_to;
    :NEW.createdAt  := :OLD.createdAt;
END;
/
CREATE TRIGGER TR_SUSCRIPTION_BD
BEFORE DELETE ON subscriptions
FOR EACH ROW
DECLARE
    fecha DATE;
BEGIN
    SELECT current_date INTO fecha FROM dual;
    IF fecha - :OLD.createdAT > 2 THEN
        RAISE_APPLICATION_ERROR(-20001,
        'No se puede eliminar la suscripcion,
        solo se puede durante los primeros dos dias despues de creada');
    END IF;
END;
/
ALTER TABLE likes ADD CONSTRAINT FK_likes_users
    FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE;
/
DROP SEQUENCE SEQ_users;
/
CREATE SEQUENCE SEQ_users
MINVALUE 1
INCREMENT BY 1
CACHE 10;
/
CREATE TRIGGER TR_users_BI
BEFORE INSERT ON users
FOR EACH ROW
DECLARE
    vacio NUMBER;
    mayor NUMBER;
    fecha DATE;
    correos VARCHAR2(100);
    nombre VARCHAR2(70);
    nombreid VARCHAR2(75);
BEGIN
    :NEW.id := SEQ_users.nextval;
    SELECT current_date INTO fecha FROM dual;
    :NEW.createdAt := fecha;
    IF :NEW.email IS NULL THEN
        SELECT CONCAT(REPLACE(:NEW.name, ' ', '_'), '_') INTO nombre FROM dual;
        SELECT CONCAT(nombre, :NEW.id) INTO nombreid FROM dual;
        SELECT CONCAT(nombreid, '@gmail.com') INTO correos FROM dual;
        :NEW.email := correos;
    END IF;
END;
/
CREATE TRIGGER TR_likes_BDU
BEFORE DELETE OR UPDATE ON likes
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20002,
    'No se puede actualizar o eliminar los contenidos que le gustan a un usuario');
END;
/
CREATE TRIGGER TR_users_BU
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20003,
    'No se puede actualizar un usuario');
END;
/
    
-- CICLO 1: PoblarOK

INSERT INTO users
    VALUES(1, 'user_name_1@gmail.com', 'user name 1', '01/01/2000');
INSERT INTO users
    VALUES(2, 'user_name_2@gmail.com', 'user name 2', '02/02/2001');
INSERT INTO users
    VALUES(3, 'user_name_3@gmail.com', 'user name 3', '03/03/2003');

INSERT INTO accounts
    VALUES(1, 2, 'account_name_1', '04/04/2010', 0);
INSERT INTO accounts
    VALUES(2, 2, 'account_name_2', '05/05/2011', 0);
INSERT INTO accounts
    VALUES(3, 1, 'account_name_3', '06/06/2012', 0);

INSERT INTO subscriptions
    VALUES(1, 1, 2, '07/07/2020',
'
<detail>
    <requests>
        <request content="violent">
            <description>Acts that are related to the practice of physical or verbal force</description>
        </request>
        <request content="sports"></request>
    </requests>
	<description>Description of the first subscription</description>
</detail>
'
);
INSERT INTO subscriptions
    VALUES(2, 2, 2, '08/08/2021',
'
<detail>
    <requests>
        <request content="educational">
            <description>Facilitate the learning of knowledge</description>
        </request>
        <request content="mathematical">
            <description>Properties of numbers and the relationships between them.</description>
        </request>
    </requests>
	<description>Description of the second subscription</description>
</detail>
'    
);
INSERT INTO subscriptions
    VALUES(3, 1, 3, '09/09/2022',
'
<detail>
    <requests>
        <request content="violent">
            <description>Acts that are related to the practice of physical or verbal force</description>
        </request>
    </requests>
	<description>Description of the third subscription</description>
</detail>
'    
);

INSERT INTO exclusiveness
    VALUES('EX-100003', 1, 0, 'Free', 0, 30);
INSERT INTO exclusiveness
    VALUES('EX-100004', 2, 1, 'Free', NULL, 20);
INSERT INTO exclusiveness
    VALUES('EX-100005', 3, 2, 'Premium', 300, NULL);

INSERT INTO contents
    VALUES(1, 1, 'EX-100001', 'content_title_1', '10/10/2020',
           'content_description_1');
INSERT INTO contents
    VALUES(2, 2, NULL, 'content_title_2', '11/11/2021', NULL);
INSERT INTO contents
    VALUES(3, 1, 'EX-100003', 'content_title_3', '12/12/2022',
           'content_description_3');
INSERT INTO contents
    VALUES(4, 2, 'EX-100002', 'content_title_4', '01/01/2022',
           'content_description_4');
INSERT INTO contents
    VALUES(5, 2, 'EX-100002', 'content_title_5', '02/01/2022',
           'content_description_5');
INSERT INTO contents
    VALUES(6, 1, 'EX-100003', 'content_title_6', '03/01/2022',
           'content_description_6');
INSERT INTO contents
    VALUES(7, 2, 'EX-100001', 'content_title_7', '04/01/2022',
           'content_description_7');
INSERT INTO contents
    VALUES(8, 1, NULL, 'content_title_8', '05/01/2022', NULL);
INSERT INTO contents
    VALUES(9, 2, 'EX-100001', 'content_title_9', '05/01/2022',
           'content_description_9');

INSERT INTO stages
    VALUES('EX-100003', 2, '10/10/2020', '11/11/2021', 100, 'Finished');
INSERT INTO stages
    VALUES('EX-100002', 2, '11/11/2021', '12/12/2022', 300, 'Active');
INSERT INTO stages
    VALUES('EX-100003', 3, '12/12/2022', NULL, 300, 'Active');

INSERT INTO lables
    VALUES('EX-100001', '#abc_123');
INSERT INTO lables
    VALUES('EX-100001', '#defg_45');
INSERT INTO lables
    VALUES('EX-100002', '#h6i_jk7');

INSERT INTO likes
    VALUES(1, 1);
INSERT INTO likes
    VALUES(1, 2);
INSERT INTO likes
    VALUES(3, 1);

INSERT INTO videos
    VALUES(1, 20);
INSERT INTO videos
    VALUES(2, 15);
INSERT INTO videos
    VALUES(3, 35);

INSERT INTO events
    VALUES(4, '01/01/2015', NULL);
INSERT INTO events
    VALUES(5, '02/03/2016', 60);
INSERT INTO events
    VALUES(6, NULL, 70);

INSERT INTO posts
    VALUES(7, 'post_text_1');
INSERT INTO posts
    VALUES(8, 'post_text_2');
INSERT INTO posts
    VALUES(9, 'post_text_3');
    
-- Consulta

-- Subscriptions requiring violent content
SELECT accounts_id AS accountId, id AS Subscription
    FROM subscriptions, XMLTABLE('/detail/requests/request'
                                PASSING subscriptions.detail 
                                COLUMNS "content" VARCHAR2(30) PATH '/*/@content') x
    WHERE x."content" = 'violent';

SELECT accounts_id AS accountId, count(accounts_id)
    FROM subscriptions, XMLTABLE('/detail/requests/request'
                                PASSING subscriptions.detail 
                                COLUMNS "content" VARCHAR2(30) PATH '/*/@content') x
    WHERE x."content" = 'violent'
    GROUP BY accounts_id;

-- Contents with the highest number of requests

SELECT x."content", count(x."content") AS Requests
    FROM subscriptions, XMLTABLE('/detail/requests/request'
                                PASSING subscriptions.detail 
                                COLUMNS "content" VARCHAR2(30) PATH '/*/@content') x
    WHERE ROWNUM <= 3
    GROUP BY x."content"
    ORDER BY Requests DESC;

-- Estension de la informacion

INSERT INTO subscriptions
    VALUES(1, 1, 2, '07/07/2020',
'
<detail language="English" country="Canada">
    <requests>
        <request content="violent" minimumAge="18">
            <description>Acts that are related to the practice of physical or verbal force</description>
        </request>
        <request content="sports" minimumAge="7"></request>
    </requests>
	<description>Description of the first subscription</description>
</detail>
'
);
INSERT INTO subscriptions
    VALUES(2, 2, 2, '08/08/2021',
'
<detail language="Spanish" country="Colombia">
    <requests>
        <request content="educativo">
            <description>Facilitar el aprendizaje del conocimiento</description>
        </request>
        <request content="matematico" minimumAge="7">
            <description>Propiedades de los numeros y las relaciones entre ellos</description>
        </request>
    </requests>
	<description>Descripcion de la segunda suscripcion</description>
</detail>
'    
);
INSERT INTO subscriptions
    VALUES(3, 1, 3, '09/09/2022',
'
<detail language="English" country="USA">
    <requests>
        <request content="violent" minimumAge="16">
            <description>Acts that are related to the practice of physical or verbal force</description>
        </request>
    </requests>
	<description>Description of the third subscription</description>
</detail>
'    
);

-- Less used languages in subscription details

SELECT x."language", count(x."language") AS Details
    FROM subscriptions, XMLTABLE('/detail'
                                PASSING subscriptions.detail 
                                COLUMNS "language" VARCHAR2(30) PATH '/*/@language') x
    WHERE ROWNUM <= 3
    GROUP BY x."language"
    ORDER BY Details;

-- XDisparadores

DROP TRIGGER TR_SUSCRIPTION_BI;
DROP TRIGGER TR_SUSCRIPTION_AI;
DROP TRIGGER TR_SUSCRIPTION_BU;
DROP TRIGGER TR_SUSCRIPTION_BD;
DROP TRIGGER TR_users_BI;
DROP TRIGGER TR_likes_BDU;
DROP TRIGGER TR_users_BU;


-- CICLO 1: XPoblar

DELETE FROM posts;
DELETE FROM events;
DELETE FROM videos;
DELETE FROM likes;
DELETE FROM lables;
DELETE FROM stages;
DELETE FROM contents;
DELETE FROM subscriptions;
DELETE FROM exclusiveness;
DELETE FROM accounts;
DELETE FROM users;

-- CICLO 1: XTablas

DROP TABLE posts;
DROP TABLE events;
DROP TABLE videos;
DROP TABLE likes;
DROP TABLE lables;
DROP TABLE stages;
DROP TABLE contents;
DROP TABLE subscriptions;
DROP TABLE exclusiveness;
DROP TABLE accounts;
DROP TABLE users;


