SELECT SYS_CONTEXT('USERENV','CON_NAME') AS CONTAINER FROM dual;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = freepdb1;

SELECT * FROM v$containers;
SELECT * FROM dba_profiles;
SELECT * FROM dba_roles;
SELECT * FROM dba_users;

-- 1. Получите список всех табличных пространств.
SELECT * FROM dba_tablespaces;

-- 2. Создайте табличное пространство с именем XXX_QDATA (10 m). При создании
-- установите его в состояние offline. Затем переведите табличное пространство в состояние
-- online. Выделите пользователю XXX квоту 2 m в пространстве XXX_QDATA. От имени
-- XXX в пространстве XXX_ QDATA создайте таблицу XXX_T1 из двух столбцов, один из
-- которых будет являться первичным ключом. В таблицу добавьте 3 строки.

-- Создать tablespace OFFLINE
DROP TABLESPACE tim_qdata;

CREATE TABLESPACE TIM_QDATA
  DATAFILE '/opt/oracle/oradata/FREE/FREEPDB1/tim_qdata01.dbf' SIZE 10M REUSE
  -- EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;
  OFFLINE;

-- Перевести в ONLINE
ALTER TABLESPACE TIM_QDATA ONLINE;

-- drop USER timadmin;
-- CREATE USER TIMADMIN IDENTIFIED BY 111;
-- GRANT DBA TO TIMADMIN;


-- Квота 2M пользователю TIM
ALTER USER TIMADMIN QUOTA 2M ON TIM_QDATA;

-- Создать таблицу от имени TIM
CREATE TABLE TIMADMIN.TIM_T1 (
  id   NUMBER PRIMARY KEY,
  name VARCHAR2(100)
) TABLESPACE TIM_QDATA;

-- Добавить 3 строки
INSERT INTO TIMADMIN.TIM_T1 VALUES (1, 'row one');
INSERT INTO TIMADMIN.TIM_T1 VALUES (2, 'row two');
INSERT INTO TIMADMIN.TIM_T1 VALUES (3, 'row three');
COMMIT;

SELECT * FROM TIMADMIN.TIM_T1;


-- 3. Получите список сегментов табличного пространства XXX_QDATA.
SELECT *
FROM dba_segments
WHERE tablespace_name = 'TIM_QDATA';


-- 4. Определите сегмент таблицы XXX_T1.
SELECT *
FROM dba_segments
WHERE segment_name = 'TIM_T1';


-- 5. Определите остальные сегменты.
SELECT *
FROM dba_segments


-- 6. Удалите (DROP) таблицу XXX_T1.
-- DROP TABLE TIMADMIN.TIM_T1


-- 7. Получите список сегментов табличного пространства XXX_QDATA. Определите сегмент
-- таблицы XXX_T1. Выполните SELECT-запрос к представлению USER_RECYCLEBIN,
-- поясните результат.
SELECT segment_name, segment_type, bytes
FROM dba_segments
WHERE tablespace_name = 'TIM_QDATA';

-- Корзина
SELECT * FROM dba_recyclebin;


-- 8. Восстановите (FLASHBACK) удаленную таблицу.
-- Восстановить таблицу из корзины
FLASHBACK TABLE TIMADMIN.TIM_T1 TO BEFORE DROP;

-- Проверить
SELECT * FROM TIMADMIN.TIM_T1;


-- 9. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).
BEGIN
  FOR i IN 4..10000 LOOP
    INSERT INTO TIMADMIN.TIM_T1 VALUES (i, 'row ' || i);
  END LOOP;
  COMMIT;
END;



-- 10. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах.
SELECT extent_id, blocks, bytes
FROM dba_extents
WHERE segment_name = 'TIM_T1'
AND owner = 'TIMADMIN';



-- 11. Получите перечень всех экстентов в базе данных.
SELECT owner, segment_name, segment_type, extent_id, blocks, bytes
FROM dba_extents
ORDER BY owner, segment_name;



-- 12. Исследуйте значения псевдостолбца RowId в таблице XXX_T1 и других таблицах.
-- Поясните формат и использование RowId.
SELECT ROWID, id, name FROM TIMADMIN.TIM_T1 WHERE ROWNUM <= 5;


-- 13. Исследуйте значения псевдостолбца RowSCN в таблице XXX_T1 и других таблицах.
SELECT ORA_ROWSCN, id, name FROM TIMADMIN.TIM_T1 WHERE ROWNUM <= 5;


-- 14. (*) Измените таблицу так, чтобы для каждой строки RowSCN выставлялся
-- индивидуально.


SELECT DISTINCT segment_type FROM dba_segments ORDER BY segment_type;
SELECT value FROM v$parameter WHERE name = 'db_block_size';


-- 16. Удалите табличное пространство XXX_QDATA и его файл.
-- DROP TABLESPACE TIM_QDATA INCLUDING CONTENTS AND DATAFILES;
-- contents это индексы и прочие объекты и датафайлы
