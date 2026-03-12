SELECT SYS_CONTEXT('USERENV','CON_NAME') AS CONTAINER FROM dual;
ALTER SESSION SET CONTAINER = CDB$ROOT;



-- просмотр всех табличных пространств
-- задание 1
SELECT TABLESPACE_NAME,
       CONTENTS,
       STATUS,
       EXTENT_MANAGEMENT
FROM DBA_TABLESPACES;



-- просмотр файлов всех табличных пространств
-- задание 2

-- перманентные + отката
SELECT FILE_NAME,
       TABLESPACE_NAME,
       BYTES/1024/1024 AS SIZE_MB
FROM DBA_DATA_FILES;

-- постоянные
SELECT FILE_NAME,
       TABLESPACE_NAME,
       BYTES/1024/1024 AS SIZE_MB
FROM DBA_TEMP_FILES;


-- группы журналов повтора
-- задание 3
SELECT GROUP#, STATUS, SEQUENCE#, BYTES/1024/1024 AS SIZE_MB
FROM V$LOG;


-- файлы журналов повтора
-- задание 4
SELECT GROUP#, MEMBER
FROM V$LOGFILE
ORDER BY GROUP#;


-- полный цикл переключений к 
-- задание 5

-- проверка текущего SCN 
SELECT CURRENT_SCN FROM V$DATABASE;

-- переключение журнала
ALTER SYSTEM SWITCH LOGFILE;


-- после каждого переключения проверить
SELECT GROUP#, SEQUENCE#, STATUS
FROM V$LOG;

-- и SCN
SELECT CURRENT_SCN FROM V$DATABASE;



-- задание 6
-- создать 3 файла отката

ALTER DATABASE ADD LOGFILE GROUP 4
(
'/opt/oracle/oradata/FREE/redo04a.log',
'/opt/oracle/oradata/FREE/redo04b.log',
'/opt/oracle/oradata/FREE/redo04c.log'
) SIZE 50M;


-- проверка группы
SELECT GROUP#, STATUS FROM V$LOG;

-- проверка файлов
SELECT GROUP#, MEMBER FROM V$LOGFILE;

-- проверка работоспособности
ALTER SYSTEM SWITCH LOGFILE;

-- снова проверить
SELECT GROUP#, SEQUENCE#, STATUS FROM V$LOG;



-- удалить группу отката
--задание 7

-- проверить что текущая не наша
SELECT GROUP#, STATUS FROM V$LOG;

-- перевести все в inactive
ALTER SYSTEM CHECKPOINT;

-- удалить 
ALTER DATABASE DROP LOGFILE GROUP 4;

-- проверить
SELECT GROUP# FROM V$LOG;


-- проверить влючено ли архивирование
-- задание 8
SELECT LOG_MODE FROM V$DATABASE;


-- последний архив
-- задание 9
SELECT MAX(SEQUENCE#) 
FROM V$ARCHIVED_LOG;
-- вывело null


-- влючить архивирование
-- задание 10
-- сделал в slqplus 

--Disconnected from Oracle AI Database 26ai Free Release 23.26.0.0.0 - Develop, Learn, and Run for Free
--Version 23.26.0.0.0
--sh-4.4$ sqlplus / as sysdba
--
--SQL*Plus: Release 23.26.0.0.0 - Production on Thu Mar 5 15:37:36 2026
--Version 23.26.0.0.0
--
--Copyright (c) 1982, 2025, Oracle.  All rights reserved.
--
--
--Connected to:
--Oracle AI Database 26ai Free Release 23.26.0.0.0 - Develop, Learn, and Run for Free
--Version 23.26.0.0.0
--
--SQL> SELECT LOG_MODE FROM V$DATABASE;
--
--LOG_MODE
--------------
--NOARCHIVELOG
--
--SQL> SHOW CON_NAME;
--
--CON_NAME
--------------------------------
--CDB$ROOT
--SQL> SHUTDOWN IMMEDIATE;
--Database closed.
--Database dismounted.
--ORACLE instance shut down.
--SQL> STARTUP MOUNT;
--ORACLE instance started.
--
--Total System Global Area 1603373280 bytes
--Fixed Size                  5007584 bytes
--Variable Size             486539264 bytes
--Database Buffers         1107296256 bytes
--Redo Buffers                4530176 bytes
--Database mounted.
--SQL> ALTER DATABASE ARCHIVELOG;
--
--Database altered.
--
--SQL> ALTER DATABASE OPEN;
--
--Database altered.
--
--SQL> 



-- задание 11

ALTER SYSTEM ARCHIVE LOG CURRENT;

-- создаем архив
SELECT SEQUENCE#, NAME
FROM V$ARCHIVED_LOG
ORDER BY SEQUENCE# DESC;


-- посмотреть SCN
SELECT SEQUENCE#, FIRST_CHANGE#, NEXT_CHANGE#
FROM V$ARCHIVED_LOG;

-- 17	2532939	2536368


-- выключить архивирование
-- задние 12
--
--SQL> SHUTDOWN IMMEDIATE;
--Database closed.
--Database dismounted.
--ORACLE instance shut down.
--SQL> STARTUP MOUNT;
--ORACLE instance started.
--
--Total System Global Area 1603373280 bytes
--Fixed Size                  5007584 bytes
--Variable Size             486539264 bytes
--Database Buffers         1107296256 bytes
--Redo Buffers                4530176 bytes
--Database mounted.
--SQL> ALTER DATABASE ARCHIVELOG;
--
--Database altered.
--
--SQL> ALTER DATABASE OPEN;
--
--Database altered.
--
--SQL> SHUTDOWN IMMEDIATE;
--Database closed.
--Database dismounted.
--ORACLE instance shut down.
--SQL> STARTUP MOUNT;
--ORACLE instance started.
--
--Total System Global Area 1603373280 bytes
--Fixed Size                  5007584 bytes
--Variable Size             486539264 bytes
--Database Buffers         1107296256 bytes
--Redo Buffers                4530176 bytes
--Database mounted.
--SQL> ALTER DATABASE NOARCHIVELOG;
--
--Database altered.
--
--SQL> ALTER DATABASE OPEN;
--
--Database altered.
--
--SQL> 


-- норер последного архива
-- SELECT MAX(SEQUENCE#) FROM V$ARCHIVED_LOG;

-- список управляющий файлов
-- задание 13
SELECT NAME
FROM V$CONTROLFILE;




-- параметры управляющего файла
-- задание 14
SELECT *
FROM V$CONTROLFILE_RECORD_SECTION;

-- проверить что ничего не осталось
-- задание 15


-- проверить redo
SELECT GROUP#, MEMBER FROM V$LOGFILE;

-- проверить архивы
SELECT NAME FROM V$ARCHIVED_LOG;
