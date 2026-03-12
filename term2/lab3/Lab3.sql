-- task1
SELECT name, open_mode
FROM V$pdbs
--FROM dba_pdbs;

-- task2
ALTER SESSION SET CONTAINER = CDB$ROOT;

CREATE PLUGGABLE DATABASE TIM_PDB
ADMIN USER pdbadmin IDENTIFIED BY 111
FILE_NAME_CONVERT = (
  '/opt/oracle/oradata/FREE/pdbseed/',
  '/opt/oracle/oradata/PDB_TEST/'
);
ALTER PLUGGABLE DATABASE TIM_PDB OPEN;
ALTER PLUGGABLE DATABASE TIM_PDB SAVE STATE;

-- task3
SELECT name, open_mode
FROM V$pdbs
--FROM dba_pdbs;

-- task4
-- Постоянный tablespace
DROP TABLESPACE TS_TIM_PDB;
CREATE TABLESPACE TS_TIM_PDB
DATAFILE '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb01.dbf'
SIZE 7M
AUTOEXTEND ON NEXT 5M MAXSIZE 30M;

-- Временный tablespace
CREATE TEMPORARY TABLESPACE TS_TIM_PDB_TEMP
TEMPFILE '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb_temp01.dbf'
SIZE 5M
AUTOEXTEND ON NEXT 3M MAXSIZE 20M;

SELECT tablespace_name, status 
FROM dba_tablespaces 
WHERE tablespace_name LIKE 'TS_TIM_PDB%';


 -- GRANT ALL PRIVILEGES TO pdbadmin;


CREATE ROLE RL_TIM_PDB;

GRANT CREATE SESSION TO RL_TIM_PDB;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO RL_TIM_PDB;

CREATE PROFILE PF_TIM_PDB LIMIT
PASSWORD_LIFE_TIME 30
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_REUSE_TIME 30
PASSWORD_REUSE_MAX 5;


CREATE USER U1_TIM_PDB
IDENTIFIED BY 111
DEFAULT TABLESPACE TS_TIM_PDB
TEMPORARY TABLESPACE TS_TIM_PDB_TEMP
PROFILE PF_TIM_PDB
ACCOUNT UNLOCK;


-- Выдаём роль
GRANT RL_TIM_PDB TO U1_TIM_PDB;

-- Ограничиваем дисковое пространство
ALTER USER U1_TIM_PDB QUOTA 2M ON TS_TIM_PDB;


-- Проверяем пользователей
SELECT username, account_status FROM dba_users WHERE username='U1_TIM_PDB';

-- Проверяем tablespace
SELECT tablespace_name, status FROM dba_tablespaces WHERE tablespace_name LIKE 'TS_TIM_PDB%';

-- Проверяем роли
SELECT role FROM dba_roles WHERE role='RL_TIM_PDB';


-- task5
CREATE TABLE TIM_table (
  id NUMBER,
  name VARCHAR2(50)
);

INSERT INTO TIM_table VALUES (1,'Test');
COMMIT;

SELECT * FROM TIM_table;

-- task6
-- табличные пространства
SELECT tablespace_name FROM dba_tablespaces;

-- файлы постоянные и временные
SELECT file_name FROM dba_data_files;
SELECT file_name FROM dba_temp_files;

-- роли
SELECT role FROM dba_roles;
SELECT * FROM dba_sys_privs WHERE grantee='RL_TIM_PDB';

--пользователи
SELECT username FROM dba_users;
SELECT * FROM dba_role_privs WHERE grantee='U1_TIM_PDB';


-- task7
--SELECT con_id, name, open_mode, restricted
--FROM v$сdbs;
--FROM v$pdbs;

--ALTER SESSION SET CONTAINER = CDB$ROOT;
--
--CREATE USER C##TIM IDENTIFIED BY 111 CONTAINER=ALL;
--
--GRANT CREATE SESSION TO C##TIM CONTAINER=ALL;

-- task8
--GRANT CREATE TABLE TO C##TIM CONTAINER=ALL;

-- task9
-- task10
-- tim_pdb pdb
ALTER USER C##TIM QUOTA 2M ON TS_TIM_PDB;
ALTER USER C##TIM QUOTA 2M  ON USERS;
ALTER USER C##TIM QUOTA 2m ON USERS CONTAINER=ALL;

CREATE  TABLE C##TIM_table_FREEPDB1 (
  id NUMBER,
  name VARCHAR2(50)
)

INSERT INTO C##TIM_table_FREEPDB1 VALUES (1,'C##TIM Test');
COMMIT;

SELECT * FROM C##TIM_table_FREEPDB1;


-- free cdb
CREATE  TABLE C##TIM_table_FREE (
  id NUMBER,
  name VARCHAR2(50)
);
INSERT INTO C##TIM_table_FREE VALUES (1,'C##TIM Test');
COMMIT;

SELECT * FROM C##TIM_table_FREE;
-- task11
-- task12

--CREATE USER C##COMMON IDENTIFIED BY 111 CONTAINER=ALL;
--GRANT CREATE SESSION TO C##COMMON CONTAINER=ALL;
--ALTER SESSION SET CONTAINER = TIM_PDB;
--GRANT CREATE TABLE TO C##COMMON;
--ALTER USER C##COMMON QUOTA 2m ON TS_TIM_PDB;
-- task13
-- task14

--pdb
ALTER SESSION SET CONTAINER = TIM_PDB;
SELECT sid, username, program, machine, status, logon_time
FROM v$session
WHERE username IN ('U1_TIM_PDB','C##TIM','C##COMMON');
--cdb
ALTER SESSION SET CONTAINER = CDB$ROOT;
SELECT sid, username, program, machine, status, logon_time
FROM v$session
WHERE username IN ('C##TIM','C##COMMON');











