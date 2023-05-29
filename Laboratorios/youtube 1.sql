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
    VALUES(3, 3, 1, '09/09/2022',
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
    
-- A. Extendiento Usuarios
-- 1
SELECT * FROM mbdaa01.DATA;
-- 2
-- INSERT INTO mbdaa01.DATA VALUES(46097, 'Angel Nicolas Cuervo Naranjo', 'angel.cuervo@mail.escuelaing.edu.co', 22);
-- INSERT INTO mbdaa01.DATA VALUES(46442, 'Jefer Alexis Gonzalez Romero', 'jefer.gonzalez@mail.escuelaing.edu.co', 22);
-- 3
UPDATE mbdaa01.DATA SET name = 'Angel Cuervo' WHERE id = 1000046097;
DELETE FROM mbdaa01.DATA WHERE id = 1000046442;
-- 4
GRANT SELECT, INSERT
ON mbdaa01.DATA
TO bd1000046442;
GRANT SELECT, INSERT
ON mbdaa01.DATA
TO bd1000046097;
-- La escribió mbdaa01
-- 5
INSERT INTO users SELECT id, email, name, CONCAT(NDAY, '/04/2022') FROM mbdaa01.DATA
WHERE NDAY IS NOT NULL AND
    NDAY < 31 AND 
    email LIKE '%@%.%' AND
    id IS NOT NULL
    AND name LIKE '% %' AND
    name IN (SELECT name FROM mbdaa01.DATA GROUP BY name HAVING COUNT(*) = 1) AND
    email IN (SELECT email FROM mbdaa01.DATA GROUP BY email HAVING COUNT(*) = 1) AND
    id IN (SELECT id FROM mbdaa01.DATA GROUP BY id HAVING COUNT(*) = 1);
    
-- CRUDE

CREATE OR REPLACE PACKAGE PC_SUBSCRIPTIONS IS
    PROCEDURE ad_subscription (xId IN NUMBER, xAccounts_id IN NUMBER,
        xSubscribed_to IN NUMBER, xCreatedAT IN DATE, xDetail IN VARCHAR2);
    PROCEDURE up_detail (xId IN NUMBER, xDetail IN VARCHAR2);
    PROCEDURE ad_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xStartAT IN DATE, xEndAT IN DATE, xPrice IN NUMBER, xStatus IN VARCHAR2);
    PROCEDURE up_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xEndAT IN DATE, xStatus IN VARCHAR2);
    PROCEDURE de_subscription (xId IN NUMBER);
    FUNCTION co_subscription (xId IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION co_stage (xSubscriptions_id IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION co_highest RETURN SYS_REFCURSOR;
    FUNCTION co_earnings (xAccount IN NUMBER) RETURN SYS_REFCURSOR;
END PC_SUBSCRIPTIONS;
/
-- CRUDI

CREATE OR REPLACE PACKAGE BODY PC_SUBSCRIPTIONS IS
    PROCEDURE ad_subscription (xId IN NUMBER, xAccounts_id IN NUMBER,
        xSubscribed_to IN NUMBER, xCreatedAT IN DATE, xDetail IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO subscriptions (id, accounts_id, subscribed_to, createdAT, detail)
            VALUES (xId, xAccounts_id, xSubscribed_to, xCreatedAT, xDetail);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar la suscripcion');
    END ad_subscription;
    
    PROCEDURE up_detail (xId IN NUMBER, xDetail IN VARCHAR2)
    IS
    BEGIN
        UPDATE subscriptions SET detail = xDetail WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar el detalle de la suscripcion');
    END up_detail;
    
    PROCEDURE ad_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xStartAT IN DATE, xEndAT IN DATE, xPrice IN NUMBER, xStatus IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO stages (subscriptions_id, exclusiveness_code, startAT, endAT, price, status)
            VALUES (xSubscriptions_id, xExclusiveness_code, xStartAT, xEndAT, xPrice, xStatus);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'Error al insertar la etapa');
    END ad_stage;
    
    PROCEDURE up_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xEndAT IN DATE, xStatus IN VARCHAR2)
    IS
    BEGIN
        UPDATE stages SET endAT = xEndAT
            WHERE subscriptions_id = xSubscriptions_id AND exclusiveness_code = xExclusiveness_code;
        UPDATE stages SET status = xStatus
            WHERE subscriptions_id = xSubscriptions_id AND exclusiveness_code = xExclusiveness_code;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20004, 'Error al actualizar la etapa');
    END up_stage;
    
    PROCEDURE de_subscription (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM subscriptions WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20005, 'Error al eliminar la suscripcion');
    END de_subscription;
    
    FUNCTION co_subscription (xId IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT accounts_id, subscribed_to, name, subscriptions.createdAT, detail
                FROM subscriptions JOIN accounts ON (subscribed_to = accounts.id)
                    WHERE subscriptions.id = xId;
        RETURN s_cursor;
    END co_subscription;
    
    FUNCTION co_stage (xSubscriptions_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT startAT, endAT, price, status
                FROM stages
                    WHERE subscriptions_id = xSubscriptions_id;
        RETURN s_cursor;
    END co_stage;
    
    FUNCTION co_highest RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT subscribed_to, ROUND(COUNT(subscribed_to)/30, 2) AS Average
                FROM accounts JOIN subscriptions
                ON (accounts.id = accounts_id) 
                WHERE ((SELECT current_date FROM dual) - subscriptions.createdAT) < 31
                GROUP BY subscribed_to;
        RETURN s_cursor;
    END co_highest;
    
    FUNCTION co_earnings (xAccount IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT accounts.id, accounts.name, EXTRACT(MONTH FROM startAT) AS Mes,
                EXTRACT(YEAR FROM startAT) AS Año, COUNT(subscriptions.id) AS Suscripciones,
                SUM(price) AS Ganancias
                FROM subscriptions JOIN stages ON (subscriptions_id = subscriptions.id)
                JOIN accounts ON (subscribed_to = accounts.id)
                WHERE accounts.id = xAccount
                GROUP BY EXTRACT(MONTH FROM startAT), EXTRACT(YEAR FROM startAT), 
                         accounts.id, accounts.name;
        RETURN s_cursor;
    END co_earnings;
END PC_subscriptions;

-- CRUDOK

EXECUTE PC_subscriptions.ad_subscription (4, 3, 2, '26/04/2022', 'subscription_detail_4');

EXECUTE PC_subscriptions.up_detail (4, 'subscription_detail_5');

EXECUTE PC_subscriptions.de_subscription (4);

VARIABLE consulta_uno REFCURSOR;
EXECUTE :consulta_uno:=PC_subscriptions.co_subscription(2); 
PRINT :consulta_uno;

VARIABLE consulta_tres REFCURSOR;
EXECUTE :consulta_tres:=PC_subscriptions.co_earnings(2); 
PRINT :consulta_tres;

-- CRUDNoOk

EXECUTE PC_subscriptions.ad_subscription (4, 100, 2, '26/04/2022', 'subscription_detail_4');

EXECUTE PC_subscriptions.up_detail (3, 'subscription_detail_detail_detail_detail_detail_detail__detail_5');

EXECUTE PC_subscriptions.ad_stage (3, 'EX-100004', '26/04/2022', NULL, NULL, 'Active');

-- XCRUD

DROP PACKAGE PC_subscriptions;

-- ActoresE

CREATE OR REPLACE PACKAGE PA_USER IS
    PROCEDURE ad_user (xId IN NUMBER, xEmail IN VARCHAR2, xName IN VARCHAR2,
        xCreatedAT IN DATE);
    PROCEDURE de_user (xId IN NUMBER);
    FUNCTION co_user (xId IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE ad_like (xUsers_id IN NUMBER, xContents_id IN NUMBER);
    FUNCTION co_like (xUsers_id IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE ad_subscription (xId IN NUMBER, xAccounts_id IN NUMBER, 
        xSubscribed_to IN NUMBER, xCreatedAT IN DATE, xDetail IN VARCHAR2);
    PROCEDURE up_subscription (xId IN NUMBER, xDetail IN VARCHAR2);
    PROCEDURE de_subscription (xId IN NUMBER);
    FUNCTION co_subscription (xId IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE ad_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xStartAT IN DATE, xEndAT IN DATE, xPrice IN NUMBER, xStatus IN VARCHAR2);
    PROCEDURE up_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xEndAT IN DATE, xStatus IN VARCHAR2);
    PROCEDURE de_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2);
    FUNCTION co_stage (xSubscriptions_id IN NUMBER) RETURN SYS_REFCURSOR;
END PA_USER;
/
CREATE OR REPLACE PACKAGE PA_EXPERIENCE_A IS
    FUNCTION co_highest RETURN SYS_REFCURSOR;
END PA_EXPERIENCE_A;
/
-- ActoresI

CREATE OR REPLACE PACKAGE BODY PA_USER IS
    PROCEDURE ad_user (xId IN NUMBER, xEmail IN VARCHAR2, xName IN VARCHAR2,
        xCreatedAT IN DATE)
    IS
    BEGIN
        INSERT INTO users (id, email, name, createdAT)
            VALUES (xId, xEmail, xName, xCreatedAT);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el usuario');
    END ad_user;
    
    PROCEDURE de_user (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM users WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20005, 'Error al eliminar el usuario');
    END de_user;
    
    FUNCTION co_user (xId IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT id, name, email, createdAT
                FROM users
                    WHERE id = xId;
        RETURN s_cursor;
    END co_user;
    
    PROCEDURE ad_like (xUsers_id IN NUMBER, xContents_id IN NUMBER)
    IS
    BEGIN
        INSERT INTO likes (users_id, contents_id)
            VALUES (xUsers_id, xContents_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el like');
    END ad_like;

    FUNCTION co_like (xUsers_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT title FROM likes JOIN contents ON (contents_id = contents.id)
            WHERE likes.users_id = xUsers_id;
        RETURN s_cursor;
    END co_like;
    
    PROCEDURE ad_subscription (xId IN NUMBER, xAccounts_id IN NUMBER,
        xSubscribed_to IN NUMBER, xCreatedAT IN DATE, xDetail IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO subscriptions (id, accounts_id, subscribed_to, createdAT, detail)
            VALUES (xId, xAccounts_id, xSubscribed_to, xCreatedAT, xDetail);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Error al insertar la suscripcion');
    END ad_subscription;
    
    PROCEDURE up_subscription (xId IN NUMBER, xDetail IN VARCHAR2)
    IS
    BEGIN
        UPDATE subscriptions SET detail = xDetail WHERE id = xId;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar la suscripcion');
    END up_subscription;
    
    PROCEDURE de_subscription (xId IN NUMBER)
    IS
    BEGIN
        DELETE FROM subscriptions WHERE (id = xId);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20005, 'Error al eliminar la suscripcion');
    END de_subscription;
    
    FUNCTION co_subscription (xId IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT accounts_id, subscribed_to, name, subscriptions.createdAT, detail
                FROM subscriptions JOIN accounts ON (subscribed_to = accounts.id)
                    WHERE subscriptions.id = xId;
        RETURN s_cursor;
    END co_subscription;
    
    PROCEDURE ad_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xStartAT IN DATE, xEndAT IN DATE, xPrice IN NUMBER, xStatus IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO stages (subscriptions_id, exclusiveness_code, startAT, endAT, price, status)
            VALUES (xSubscriptions_id, xExclusiveness_code, xStartAT, xEndAT, xPrice, xStatus);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'Error al insertar la etapa');
    END ad_stage;
    
    PROCEDURE up_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2,
        xEndAT IN DATE, xStatus IN VARCHAR2)
    IS
    BEGIN
        UPDATE stages SET endAT = xEndAT
            WHERE subscriptions_id = xSubscriptions_id AND exclusiveness_code = xExclusiveness_code;
        UPDATE stages SET status = xStatus
            WHERE subscriptions_id = xSubscriptions_id AND exclusiveness_code = xExclusiveness_code;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20004, 'Error al actualizar la etapa');
    END up_stage;
    
    PROCEDURE de_stage (xSubscriptions_id IN NUMBER, xExclusiveness_code IN VARCHAR2)
    IS
    BEGIN
        DELETE FROM stages WHERE (subscriptions_id = xSubscriptions_id AND exclusiveness_code = xExclusiveness_code);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20005, 'Error al eliminar la etapa');
    END de_stage;
    
    FUNCTION co_stage (xSubscriptions_id IN NUMBER) RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT startAT, endAT, price, status
                FROM stages
                    WHERE subscriptions_id = xSubscriptions_id;
        RETURN s_cursor;
    END co_stage;
END PA_USER;
/
CREATE OR REPLACE PACKAGE BODY PA_EXPERIENCE_A IS
    FUNCTION co_highest RETURN SYS_REFCURSOR
    AS s_cursor SYS_REFCURSOR;
    BEGIN
        OPEN s_cursor FOR
            SELECT subscribed_to, ROUND(COUNT(subscribed_to)/30, 2) AS Average
                FROM accounts JOIN subscriptions
                ON (accounts.id = accounts_id) 
                WHERE ((SELECT current_date FROM dual) - subscriptions.createdAT) < 31
                GROUP BY subscribed_to;
        RETURN s_cursor;
    END co_highest;
END PA_EXPERIENCE_A;

-- Seguridad

CREATE ROLE YTUSERS;

GRANT EXECUTE
ON "BD1000046442"."PA_USER"
TO "YTUSERS";

GRANT YTUSERS TO "BD1000046097";

REVOKE YTUSERS
FROM "BD1000046097"; 

CREATE ROLE YTANALYST;

GRANT EXECUTE
ON "BD1000046442"."PA_EXPERIENCE_A"
TO YTANALYST;

GRANT YTANALYST TO BD1000046097;

REVOKE YTANALYST
FROM BD1000046097; 

-- SeguridadOK

VARIABLE consulta_uno REFCURSOR;
EXECUTE :consulta_uno:="BD1000046442"."PA_USER".co_stage(2); 
PRINT :consulta_uno;

EXECUTE "BD1000046442"."PA_USER".ad_like (2, 3);

EXECUTE "BD1000046442"."PA_USER".up_subscription (3, 'subscription_detail_7');

EXECUTE "BD1000046442"."PA_USER".de_subscription (3);

VARIABLE consulta_tres REFCURSOR;
EXECUTE :consulta_tres:="BD1000046442"."PA_EXPERIENCE_A".co_highest; 
PRINT :consulta_tres;

-- SeguridadNoOK

EXECUTE "BD1000046442"."PA_USER".ad_stage (1, 'EX-100003', '02/05/2022', NULL, 100, 'Active')

VARIABLE consulta_cuatro REFCURSOR;
EXECUTE :consulta_cuatro:="BD1000046442"."PA_USER".co_like(2); 
PRINT :consulta_cuatro;

VARIABLE consulta_cinco REFCURSOR;
EXECUTE :consulta_cinco:="BD1000046442"."PA_EXPERIENCE_A".co_highest; 
PRINT :consulta_cinco;

-- xSeguridad

REVOKE ALL PRIVILEGES FROM YTusuarios1;

REVOKE ALL PRIVILEGES FROM YTanalistas;

DROP ROLE YTUSERS;

DROP ROLE YTANALYST;

DROP PACKAGE PA_USER;

DROP PACKAGE PA_EXPERIENCE_A;

-- Pruebas

-- 1. Vamos a ingresar un nuevo usario a la base de datos sin correo, con fecha 
-- e id dados
EXECUTE "BD1000046442"."PA_USER".ad_user(100, NULL, 'usuario uno', '25/08/2023');
-- 2. Consultaremos el usuario que acabamos de ingresar por su id
VARIABLE consulta_seis REFCURSOR;
EXECUTE :consulta_seis:="BD1000046442"."PA_USER".co_user(4); 
PRINT :consulta_seis;
-- 3. Al usuario le ha gustado el contenido 3
EXECUTE "BD1000046442"."PA_USER".ad_like(4, 3);
-- 4. Otro usuario que tiene id 3 se suscribe al usuario 2
EXECUTE "BD1000046442"."PA_USER".ad_subscription(350, 3, 2, NULL, NULL);
-- 5. Ahora veremos la suscripcion en la base de datos.
VARIABLE consulta_siete REFCURSOR;
EXECUTE :consulta_siete:="BD1000046442"."PA_USER".co_subscription(4); 
PRINT :consulta_siete;
-- 6. Actualiza el detalle de la suscripcion
EXECUTE "BD1000046442"."PA_USER".up_subscription(4, 'Detalle actualizado suscripcion nueva');
-- 7. Volvemos a consultar la nueva suscripcion
VARIABLE consulta_siete REFCURSOR;
EXECUTE :consulta_siete:="BD1000046442"."PA_USER".co_subscription(4); 
PRINT :consulta_siete;
-- 8. El usuario quiere que su suscripcion tenga un nivel mas alto, por lo tanto
-- se debe crear una nueva etapa y actualizar la que tenia 
EXECUTE "BD1000046442"."PA_USER".ad_stage(4, 'EX-100002', '02/05/2022', NULL, 300, 'Active');
EXECUTE "BD1000046442"."PA_USER".up_stage(4, 'EX-100001', '02/05/2022', 'Finished');
-- 9. Las etapas que ha tenido la suscripcion se presentan a continuacion
VARIABLE consulta_ocho REFCURSOR;
EXECUTE :consulta_ocho:="BD1000046442"."PA_USER".co_stage(4); 
PRINT :consulta_ocho;
-- 10. El usuario decide eliminar la suscripcion a esa cuenta
EXECUTE "BD1000046442"."PA_USER".de_subscription(4);
-- 11. Si se vuelve a consultar en la base de datos esa suscripcion, esta no parecera
VARIABLE consulta_siete REFCURSOR;
EXECUTE :consulta_siete:="BD1000046442"."PA_USER".co_subscription(4); 
PRINT :consulta_siete;

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


