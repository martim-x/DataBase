--  1. Прочитайте задание полностью и выдайте своему пользователю необходимые права.
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = freepdb1;

CREATE USER TM IDENTIFIED BY "111";
COMMIT;

GRANT DBA TO TM;
COMMIT;


--	2. Создайте временную таблицу, добавьте в нее данные и продемонстрируйте, как
--	долго они хранятся. Поясните особенности работы с временными таблицами.

CREATE GLOBAL TEMPORARY TABLE TEMP_T (
    ID   NUMBER,
    TXT  VARCHAR2(100)
) ON COMMIT DELETE ROWS;
-- ON COMMIT PRESERVE ROWS
COMMIT;


INSERT INTO TEMP_T VALUES (1, 'row 1');
INSERT INTO TEMP_T VALUES (2, 'row 2');

SELECT * FROM TEMP_T;

COMMIT;

SELECT * FROM TEMP_T;

--	3. Создайте последовательность S1 (SEQUENCE), со следующими характеристиками:
--	начальное значение 1000; приращение 10; нет минимального значения; нет
--	максимального значения; не циклическая; значения не кэшируются в памяти;
--	хронология значений не гарантируется. Получите несколько значений
--	последовательности. Получите текущее значение последовательности.

ALTER SEQUENCE S1 RESTART; -- !!!!!!!!!!!
DROP SEQUENCE s1;

CREATE SEQUENCE S1
    START WITH 1000
    INCREMENT BY 10
    NOMINVALUE
    NOMAXVALUE
    NOCYCLE
    NOCACHE
    NOORDER;
COMMIT;


SELECT S1.NEXTVAL AS S1_VAL FROM DUAL;
SELECT S1.NEXTVAL AS S1_VAL FROM DUAL;
SELECT S1.NEXTVAL AS S1_VAL FROM DUAL;

SELECT S1.CURRVAL AS S1_CURR FROM DUAL;

--	4. Создайте последовательность S2 (SEQUENCE), со следующими характеристиками:
--	начальное значение 10; приращение 10; максимальное значение 100; не
--	циклическую. Получите все значения последовательности. Попытайтесь получить
--	значение, выходящее за максимальное значение.

ALTER SEQUENCE S2 RESTART;

CREATE SEQUENCE S2
    START WITH 10
    INCREMENT BY 10
    MAXVALUE 100
    NOCYCLE;
COMMIT;


SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 10
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 20
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 30
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 40
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 50
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 60
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 70
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 80
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 90
SELECT S2.NEXTVAL AS S2_VAL FROM DUAL; -- 100

-- SELECT S2.NEXTVAL FROM DUAL;  -- даст ORA-08004

--	5. Создайте последовательность S3 (SEQUENCE), со следующими характеристиками:
--	начальное значение 10; приращение -10; минимальное значение -100; не
--	циклическую; гарантирующую хронологию значений. Получите все значения
--	последовательности. Попытайтесь получить значение, меньше минимального
--	значения.

ALTER SEQUENCE S3 RESTART;
DROP SEQUENCE s3;

CREATE SEQUENCE S3
    START WITH 10
    INCREMENT BY -10
    MINVALUE -100
    MAXVALUE 10
    NOCYCLE
    ORDER;
COMMIT;


SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- 10
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- 0
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -10
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -20
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -30
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -40
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -50
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -60
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -70
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -80
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -90
SELECT S3.NEXTVAL AS S3_VAL FROM DUAL; -- -100

-- SELECT S3.NEXTVAL FROM DUAL;  -- ORA-08004

--	6. Создайте последовательность S4 (SEQUENCE), со следующими характеристиками:
--	начальное значение 1; приращение 1; минимальное значение 10; циклическая;
--	кэшируется в памяти 5 значений; хронология значений не гарантируется.
--	Продемонстрируйте цикличность генерации значений последовательностью S4.


ALTER SEQUENCE S4 RESTART;

CREATE SEQUENCE S4
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 10
    CYCLE
    CACHE 5
    NOORDER;
COMMIT;


SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 1
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 2
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 3
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 4
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 5
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 6
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 7
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 8
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 9
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 10
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 1 (цикл)
SELECT S4.NEXTVAL AS S4_VAL FROM DUAL; -- 2

--	7. Получите список всех последовательностей в словаре базы данных, владельцем
--	которых является пользователь XXX.

SELECT SEQUENCE_NAME,
       MIN_VALUE,
       MAX_VALUE,
       INCREMENT_BY,
       CYCLE_FLAG,
       CACHE_SIZE,
       ORDER_FLAG
FROM USER_SEQUENCES
ORDER BY SEQUENCE_NAME;

--	8. Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20),
--	кэшируемую и расположенную в буферном пуле KEEP. С помощью оператора
--	INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с
--	помощью последовательностей S1, S2, S3, S4.

CREATE TABLE T1 (
    N1 NUMBER(20),
    N2 NUMBER(20),
    N3 NUMBER(20),
    N4 NUMBER(20)
) CACHE
  STORAGE (BUFFER_POOL KEEP);
COMMIT;


INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);

COMMIT;

SELECT * FROM T1;


--	9. Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля:
--	X (NUMBER (10)), V (VARCHAR2(12)).

CREATE CLUSTER ABC (
    X NUMBER(10),
    V VARCHAR2(12)
)
HASHKEYS 200;
COMMIT;

--	10. Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA
--	(VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный
--	столбец.


--	11. Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB
--	(VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный
--	столбец.


--	12. Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС
--	(VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный
--	столбец.


CREATE TABLE A (
    XA      NUMBER(10),
    VA      VARCHAR2(12),
    A_EXTRA VARCHAR2(50)
) CLUSTER ABC (XA, VA);
COMMIT;



CREATE TABLE B (
    XB      NUMBER(10),
    VB      VARCHAR2(12),
    B_EXTRA VARCHAR2(50)
) CLUSTER ABC (XB, VB);
COMMIT;



CREATE TABLE C (
    XC      NUMBER(10),
    VC      VARCHAR2(12),
    C_EXTRA VARCHAR2(50)
) CLUSTER ABC (XC, VC);
COMMIT;



--	13. Найдите созданные таблицы и кластер в представлениях словаря Oracle.

SELECT CLUSTER_NAME, CLUSTER_TYPE, HASHKEYS
FROM USER_CLUSTERS;

SELECT TABLE_NAME, CLUSTER_NAME
FROM USER_TABLES
WHERE CLUSTER_NAME = 'ABC';

--	14. Создайте частный синоним для таблицы XXX.С и продемонстрируйте его
--	применение.


CREATE SYNONYM SYN_C FOR C;
COMMIT;


INSERT INTO SYN_C VALUES (1, 'SYN_C_VAL', 'via private synonym');
COMMIT;

SELECT * FROM SYN_C;


--	15. Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его
--	применение.

CREATE PUBLIC SYNONYM B_PUB FOR TM.B;
COMMIT;


INSERT INTO B_PUB VALUES (1, 'B_PUB_VAL', 'via public synonym');
COMMIT;

SELECT * FROM B_PUB;


--	16. Создайте две произвольные таблицы A и B (с первичным и внешним ключами),
--	заполните их данными, создайте представление V1, основанное на SELECT... FOR A
--	inner join B. Продемонстрируйте его работоспособность.

CREATE TABLE A2 (
    ID   NUMBER PRIMARY KEY,
    NAME VARCHAR2(50)
);
COMMIT;


CREATE TABLE B2 (
    ID    NUMBER PRIMARY KEY,
    A2_ID NUMBER REFERENCES A2(ID),
    INFO  VARCHAR2(100)
);
COMMIT;


INSERT INTO A2 VALUES (1, 'Alpha');
INSERT INTO A2 VALUES (2, 'Beta');

INSERT INTO B2 VALUES (10, 1, 'Info Alpha');
INSERT INTO B2 VALUES (11, 2, 'Info Beta');
COMMIT;

CREATE VIEW V1 AS
SELECT A2.ID AS AID, A2.NAME,
       B2.ID AS BID, B2.INFO
FROM A2
INNER JOIN B2 ON A2.ID = B2.A2_ID;
COMMIT;


SELECT * FROM V1;

--	17. На основе таблиц A и B создайте материализованное представление MV_XXX,
--	которое имеет периодичность обновления 2 минуты. Продемонстрируйте его
--	работоспособность.

CREATE MATERIALIZED VIEW MV_TM
    BUILD IMMEDIATE
    REFRESH COMPLETE
    START WITH SYSDATE
    NEXT SYSDATE + INTERVAL '2' MINUTE
AS
SELECT A2.ID AS AID, A2.NAME,
       B2.ID AS BID, B2.INFO
FROM A2
INNER JOIN B2 ON A2.ID = B2.A2_ID;
COMMIT;


SELECT * FROM MV_TM;

-- Добавим новые данные и обновим вручную:
INSERT INTO A2 VALUES (3, 'Gamma');
INSERT INTO B2 VALUES (12, 3, 'Info Gamma');
COMMIT;

BEGIN
    DBMS_MVIEW.REFRESH('MV_TM', 'C');
END;


SELECT * FROM MV_TM;


--	18. Создайте DBlink по схеме USER1-USER2 для подключения к другой базе данных
--	(если ваша БД находится на сервере ORA12W, то надо подключаться к БД на сервере
--	ORA12D, если вы работаете на своем сервере, то договоритесь с кем-то из группы).


-- под SYS в CDB$ROOT

ALTER SESSION SET CONTAINER = CDB$ROOT;

CREATE PLUGGABLE DATABASE PDB_DBLINK
  ADMIN USER PDBADMIN IDENTIFIED BY "111"
  ROLES = (DBA)
  CREATE_FILE_DEST = '/opt/oracle/oradata/FREE/PDB_DBLINK';

ALTER PLUGGABLE DATABASE PDB_DBLINK OPEN;
ALTER PLUGGABLE DATABASE PDB_DBLINK SAVE STATE;
COMMIT;


ALTER SESSION SET CONTAINER = PDB_DBLINK;

CREATE USER TM2 IDENTIFIED BY "111";

GRANT DBA TO TM2;
COMMIT;

-- под TM2 в PDB_DBLINK
CREATE TABLE REMOTE_T (
    ID   NUMBER PRIMARY KEY,
    TXT  VARCHAR2(100)
);
COMMIT;

INSERT INTO REMOTE_T VALUES (1, 'remote row 1');
INSERT INTO REMOTE_T VALUES (2, 'remote row 2');
COMMIT;

CREATE OR REPLACE PROCEDURE REMOTE_PROC(p_id NUMBER, p_txt VARCHAR2) AS
BEGIN
    INSERT INTO REMOTE_T(ID, TXT) VALUES (p_id, p_txt);
END;

COMMIT;

CREATE OR REPLACE FUNCTION REMOTE_FUNC(p_id NUMBER)
RETURN VARCHAR2
AS
    v_txt VARCHAR2(100);
BEGIN
    SELECT TXT INTO v_txt
    FROM REMOTE_T
    WHERE ID = p_id;

    RETURN v_txt;
END;


-- под TM в FREEPDB1
CREATE DATABASE LINK LINK_TO_PDB_DBLINK
  CONNECT TO TM2 IDENTIFIED BY "111"
  USING 'localhost:1521/PDB_DBLINK';
COMMIT;


BEGIN
    REMOTE_PROC@LINK_TO_PDB_DBLINK(200, 'from remote proc');
END;

-- вызов функции на удалённом сервере
SELECT REMOTE_FUNC@LINK_TO_PDB_DBLINK(200) AS REMOTE_VALUE
FROM DUAL;


--	19. Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE,
--	вызов процедур и функций с объектами удаленного сервера.


-- чтение данных с удалённого сервера
SELECT * FROM REMOTE_T@LINK_TO_PDB_DBLINK;

INSERT INTO REMOTE_T@LINK_TO_PDB_DBLINK (ID, TXT)
VALUES (100, 'insert via dblink');
COMMIT;

SELECT * FROM REMOTE_T@LINK_TO_PDB_DBLINK WHERE ID = 100;


UPDATE REMOTE_T@LINK_TO_PDB_DBLINK
SET TXT = 'updated via dblink'
WHERE ID = 100;
COMMIT;

SELECT * FROM REMOTE_T@LINK_TO_PDB_DBLINK WHERE ID = 100;


DELETE FROM REMOTE_T@LINK_TO_PDB_DBLINK
WHERE ID = 100;
COMMIT;

SELECT * FROM REMOTE_T@LINK_TO_PDB_DBLINK;




