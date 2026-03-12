-- preparation
ALTER SESSION SET "_oracle_script" = TRUE;


--task 1
CREATE TABLESPACE TS_TIM
DATAFILE 'TS_TIM.dbf'
SIZE 7 M
AUTOEXTEND ON
NEXT 5 M MAXSIZE 30 M;
COMMIT;

-- task 2
CREATE TEMPORARY TABLESPACE TS_TIM_TEMP
TEMPFILE 'TS_TIM_TEMP.dbf'
SIZE 5 M
AUTOEXTEND ON
NEXT 3 M MAXSIZE 20 M;
COMMIT;

--task 3
-- Список всех табличных пространств
SELECT tablespace_name, status, contents
FROM dba_tablespaces;

--task 4
-- Список всех табличных пространств
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb
FROM dba_data_files;

-- Для временных файлов
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb
FROM dba_temp_files;

--task 5
CREATE ROLE RL_TIMCORE;

GRANT CREATE SESSION TO RL_TIMCORE;
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO RL_TIMCORE;
GRANT ALTER ANY TABLE, DROP ANY TABLE TO RL_TIMCORE;


-- !!! GRANT UPDATE VIEW TO RL_TIMCORE;

--task 6
SELECT * FROM dba_roles WHERE role = 'RL_TIMCORE';

--task 7
SELECT * FROM dba_sys_privs WHERE grantee = 'RL_TIMCORE';


--task 8
CREATE PROFILE PF_TIMCORE
LIMIT
    PASSWORD_LIFE_TIME 30
    PASSWORD_REUSE_TIME 30
    PASSWORD_REUSE_MAX 5
    FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LOCK_TIME 1
    PASSWORD_GRACE_TIME 7
    SESSIONS_PER_USER 3
    CONNECT_TIME 60
    IDLE_TIME 30;


--task 9
SELECT DISTINCT profile
FROM dba_profiles;


--task 10
SELECT profile, resource_name, limit
FROM dba_profiles
WHERE profile = 'PF_TIMCORE'
ORDER BY resource_name;

--task 11
SELECT profile, resource_name, limit
FROM dba_profiles
WHERE profile = 'DEFAULT'
ORDER BY resource_name;


--task 12
CREATE USER TIMCORE
IDENTIFIED BY Temp123
DEFAULT TABLESPACE TS_TIM
TEMPORARY TABLESPACE TS_TIM_TEMP
PROFILE PF_TIMCORE
ACCOUNT UNLOCK;

ALTER USER TIMCORE PASSWORD EXPIRE;

GRANT RL_TIMCORE TO TIMCORE;



--task 13
sqlplus TIMCORE@ORCL


--task 14
-- create connection on TIM profile

--task 15
--created as tim user
CREATE TABLE TIM_T (
    id NUMBER(3) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(50),
    created_at DATE DEFAULT SYSDATE
);

INSERT INTO TIM_T(name) VALUES ('Alice');
--expected error



--task 16
ALTER USER TIMCORE QUOTA 2M ON TS_TIM;


--task 17
INSERT INTO TIM_T(name) VALUES ('Alice');
INSERT INTO TIM_T(name) VALUES ('Bob');
COMMIT;

SELECT * FROM TIM_T;


--task 18
ALTER TABLESPACE TS_TIM OFFLINE;



--task 19
SELECT * FROM TIM_T;


--task 20
ALTER TABLESPACE TS_TIM ONLINE;
ALTER TABLESPACE TS_TIM ONLINE;




