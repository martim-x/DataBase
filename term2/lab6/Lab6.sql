SELECT SYS_CONTEXT('USERENV','CON_NAME') AS CONTAINER FROM dual;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = freepdb1;

SELECT * FROM v$containers;
SELECT * FROM dba_profiles;
SELECT * FROM dba_roles;
SELECT * FROM dba_users;



--	1. Определите местоположение файла параметров инстанса.	
SELECT VALUE FROM V$PARAMETER WHERE NAME = 'spfile';

--	2. Убедитесь в наличии этого файла в операционной системе.
--	CC"FeCC"EeCC"DeCsh-4.4$ ls
--	TS_TIM.dbf  TS_TIM_TEMP.dbf  arch1_17_1224024843.dbf  hc_FREE.dat  init.ora  lkFREE  orapwFREE  spfileFREE.ora
--	sh-4.4$ pwd
--	/opt/oracle/product/26ai/dbhomeFree/dbs
--	sh-4.4$ 
--	
--	3. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните
CREATE PFILE='/tmp/FREE_PFILE.ORA' FROM SPFILE;


--	известные вам параметры в файле.
--	4. Измените какой-либо параметр в файле PFILE.

--	sh-4.4$ 
--	sh-4.4$ pwd
--	/tmp
--	sh-4.4$ cd tmp
--	sh: cd: tmp: No such file or directory
--	sh-4.4$ ls
--	FREE_PFILE.ORA  hsperfdata_oracle
--	sh-4.4$ cat FREE_PFILE.ORA 
--	FREE.__data_transfer_cache_size=0
--	FREE.__datamemory_area_size=0
--	FREE.__db_cache_size=1023410176
--	FREE.__inmemory_ext_roarea=0
--	FREE.__inmemory_ext_rwarea=0
--	FREE.__java_pool_size=0
--	FREE.__large_pool_size=16777216
--	FREE.__oracle_base='/opt/oracle'#ORACLE_BASE set from environment
--	FREE.__pga_aggregate_target=536870912
--	FREE.__sga_target=1610612736
--	FREE.__shared_io_pool_size=83886080
--	FREE.__shared_pool_size=452984832
--	FREE.__streams_pool_size=0
--	FREE.__unified_pga_pool_size=0
--	*._enable_memory_protection_keys=FALSE
--	FREE._instance_recovery_bloom_filter_size=1048576
--	*.common_user_prefix=''
--	*.compatible='23.6.0'
--	*.control_files='/opt/oracle/oradata/FREE/control01.ctl','/opt/oracle/oradata/FREE/control02.ctl'
--	*.control_management_pack_access='DIAGNOSTIC+TUNING'
--	*.cpu_count='2'
--	*.db_block_size=8192
--	*.db_name='FREE'
--	*.diagnostic_dest='/opt/oracle'
--	*.dispatchers='(PROTOCOL=TCP) (SERVICE=FREEXDB)'
--	*.enable_pluggable_database=true
--	*.fast_start_parallel_rollback='FALSE'
--	*.job_queue_processes=1
--	*.local_listener=''
--	*.nls_language='AMERICAN'
--	*.nls_territory='AMERICA'
--	*.open_cursors=300
--	*.pga_aggregate_target=512m
--	*.processes=200
--	*.remote_login_passwordfile='EXCLUSIVE'
--	*.sga_target=1536m
--	*.undo_tablespace='UNDOTBS1'
--	sh-4.4$ 


--	sh-4.4$ sed -i 's/\*.processes=200/\*.processes=320/' /tmp/FREE_PFILE.ORA
--	sh-4.4$ grep processes /tmp/FREE_PFILE.ORA
--	*.job_queue_processes=1
--	*.processes=320




--	5. Создайте новый SPFILE.
CREATE SPFILE='/tmp/spfileFREE_new.ora' FROM PFILE='/tmp/FREE_PFILE.ORA';
--	sh-4.4$ cat spfileFREE_new.ora 
--	C"m6ICC".vFREE.__data_transfer_cache_size=0
--	FREE.__datamemory_area_size=0
--	FREE.__db_cache_size=1023410176
--	FREE.__inmemory_ext_roarea=0
--	FREE.__inmemory_ext_rwarea=0
--	FREE.__java_pool_size=0
--	FREE.__large_pool_size=16777216
--	FREE.__oracle_base='/opt/oracle'#ORACLE_BASE set from environment
--	FREE.__pga_aggregate_target=536870912
--	FREE.__sga_target=1610612736
--	FREE.__shared_io_pool_size=83886080
--	FREE.__shared_pool_size=452984832
--	FREE.__streams_pool_size=0
--	FREE.__unified_pga_pool_size=0
--	*._enable_memory_CC".protection_keys=FALSE
--	FREE._instance_recovery_bloom_filter_size=1048576
--	*.common_user_prefix=''
--	*.compatible='23.6.0'
--	*.control_files='/opt/oracle/oradata/FREE/control01.ctl','/opt/oracle/oradata/FREE/control02.ctl'
--	*.control_management_pack_access='DIAGNOSTIC+TUNING'
--	*.cpu_count='2'
--	*.db_block_size=8192
--	*.db_name='FREE'
--	*.diagnostic_dest='/opt/oracle'
--	*.dispatchers='(PROTOCOL=TCP) (SERVICE=FREEXDB)'
--	*.enable_pluggable_database=true
--	*.fast_start_parallel_rollback='FALSE'
--	*.job_queue_CC"yMprocesses=1
--	*.local_listener=''
--	*.nls_language='AMERICAN'
--	*.nls_territory='AMERICA'
--	*.open_cursors=300
--	*.pga_aggregate_target=512m
--	*.processes=320
--	*.remote_login_passwordfile='EXCLUSIVE'
--	*.sga_target=1536m
--	*.undo_tablespace='UNDOTBS1'
--	CC"FeCC"EeCC"DeCsh-4.4$ 


--	6. Запустите инстанс с новыми параметрами.

--	 Перезапускаем инстанс (в CDB root)
--	SHUTDOWN IMMEDIATE;

--	cp /tmp/spfileFREE_new.ora /opt/oracle/product/26ai/dbhomeFree/dbs/spfileFREE.ora
--	STARTUP;

--	 Проверяем что параметр применился
--	SHOW PARAMETER PROCESSES;

--	SQL> startup;
--	ORACLE instance started.
--	
--	Total System Global Area 1603373280 bytes
--	Fixed Size                  5007584 bytes
--	Variable Size             486539264 bytes
--	Database Buffers         1107296256 bytes
--	Redo Buffers                4530176 bytes
--	Database mounted.
--	Database opened.
--	SQL> SHOW PARAMETER PROCESSES;
--	
--	NAME                                 TYPE        VALUE
--	------------------------------------ ----------- ------------------------------
--	aq_tm_processes                      integer     1
--	db_writer_processes                  integer     1
--	gcs_server_processes                 integer     0
--	global_txn_processes                 integer     1
--	job_queue_processes                  integer     1
--	log_archive_max_processes            integer     4
--	processes                            integer     320
--	SQL> 


--	7. Вернитесь к прежним значениям параметров другим способом.

-- Способ 1 был через PFILE, теперь используем ALTER SYSTEM напрямую

ALTER SYSTEM SET PROCESSES=200 SCOPE=SPFILE;
--	SQL> SHUTDOWN IMMEDIATE;
--	Database closed.
--	Database dismounted.
--	ORACLE instance shut down.
--	SQL> startup
--	ORACLE instance started.
--	
--	Total System Global Area 1603373280 bytes
--	Fixed Size                  5007584 bytes
--	Variable Size             486539264 bytes
--	Database Buffers         1107296256 bytes
--	Redo Buffers                4530176 bytes
--	Database mounted.
--	Database opened.
--	SQL> HOW PARAMETER PROCESSES;
--	SP2-0734: unknown command beginning "HOW PARAME..." - rest of line ignored.
--	Help: https://docs.oracle.com/error-help/db/sp2-0734/
--	SQL> sHOW PARAMETER PROCESSES;
--	
--	NAME                                 TYPE        VALUE
--	------------------------------------ ----------- ------------------------------
--	aq_tm_processes                      integer     1
--	db_writer_processes                  integer     1
--	gcs_server_processes                 integer     0
--	global_txn_processes                 integer     1
--	job_queue_processes                  integer     1
--	log_archive_max_processes            integer     4
--	processes                            integer     200
--	SQL> 



--	8. Получите список управляющих файлов.
-- Способ 1 sqlplus 
SHOW PARAMETER CONTROL_FILES;

-- Способ 2 — детальнее
SELECT NAME, STATUS FROM V$CONTROLFILE;


--	9. Создайте скрипт для изменения управляющего файла.
-- Сбрасываем содержимое управляющего файла в трейс
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;

-- Находим где лежит трейс

-- Смотрим содержимое трейса (путь подставишь из предыдущего запроса)
HOST cat /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_2156.trc

--	SQL> HOST cat /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_2156.trc
--	Trace file /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_2156.trc
--	Oracle AI Database 26ai Free Release 23.26.0.0.0 - Develop, Learn, and Run for Free
--	Version 23.26.0.0.0
--	Build label:    RDBMS_23.26.0.0.0DBRU_LINUX.ARM64_250926.FREE4
--	ORACLE_HOME:    /opt/oracle/product/26ai/dbhomeFree
--	System name:    Linux
--	Node name:      9a043543db2d
--	Release:        6.10.14-linuxkit
--	Version:        #1 SMP Thu Aug 14 19:26:13 UTC 2025
--	Machine:        aarch64
--	CLID:   P
--	Instance name: FREE
--	Instance number: 1
--	Database name: FREE 
--	Database unique name: FREE 
--	Database id: 1496081483
--	Database role: PRIMARY
--	Redo thread mounted by this instance: 1
--	Oracle binary inode:    54288
--	Oracle process number: 0
--	Unix process pid:       2156
--	             created:   2026-03-19T15:58:52.000000+00:00
--	             image:     
--	
--	
--	*** 2026-03-19T15:58:53.242231+00:00 (CDB$ROOT(1))
--	2026-03-19 15:58:53.242005 : fsd_notify_cb: FsDirect not implemented
--	*** SESSION ID:(53.56979) 2026-03-19T15:59:17.101841+00:00
--	*** SERVICE NAME:(free) 2026-03-19T15:59:17.101921+00:00
--	*** MODULE NAME:(DBeaver 25?3?4 ? SQLEditor ?Lab6?sql?) 2026-03-19T15:59:17.101937+00:00
--	*** ACTION NAME:() 2026-03-19T15:59:17.101947+00:00
--	*** CLIENT DRIVER:(jdbcthin : 23.2.0.0.0) 2026-03-19T15:59:17.101956+00:00
--	*** CONTAINER ID:(1) 2026-03-19T15:59:17.101965+00:00
--	*** CLIENT IP:(192.168.65.1) 2026-03-19T15:59:17.101980+00:00
--	*** CONNECTION ID:(dxca12mBRQW63S58rcJKWQ==) 2026-03-19T15:59:17.102003+00:00
--	 
--	
--	*** 2026-03-19T15:59:17.101812+00:00 (CDB$ROOT(1))
--	-- The following are current System-scope REDO Log Archival related
--	-- parameters and can be included in the database initialization file.
--	--
--	-- LOG_ARCHIVE_DEST=''
--	-- LOG_ARCHIVE_DUPLEX_DEST=''
--	--
--	-- LOG_ARCHIVE_FORMAT=%t_%s_%r.dbf
--	--
--	-- DB_UNIQUE_NAME="FREE"
--	--
--	-- LOG_ARCHIVE_CONFIG='SEND, RECEIVE, NODG_CONFIG'
--	-- LOG_ARCHIVE_MAX_PROCESSES=4
--	-- STANDBY_FILE_MANAGEMENT=MANUAL
--	-- FAL_CLIENT=''
--	-- FAL_SERVER=''
--	--
--	-- LOG_ARCHIVE_DEST_1='LOCATION=/opt/oracle/product/26ai/dbhomeFree/dbs/arch'
--	-- LOG_ARCHIVE_DEST_1='MANDATORY REOPEN=300 NODELAY'
--	-- LOG_ARCHIVE_DEST_1='ARCH NOAFFIRM SYNC'
--	-- LOG_ARCHIVE_DEST_1='NOREGISTER'
--	-- LOG_ARCHIVE_DEST_1='NOALTERNATE'
--	-- LOG_ARCHIVE_DEST_1='NODEPENDENCY'
--	-- LOG_ARCHIVE_DEST_1='NOMAX_FAILURE NOQUOTA_SIZE NOQUOTA_USED NODB_UNIQUE_NAME'
--	-- LOG_ARCHIVE_DEST_1='VALID_FOR=(PRIMARY_ROLE,ONLINE_LOGFILES)'
--	-- LOG_ARCHIVE_DEST_STATE_1=ENABLE
--	
--	--
--	-- Below are two sets of SQL statements, each of which creates a new
--	-- control file and uses it to open the database. The first set opens
--	-- the database with the NORESETLOGS option and should be used only if
--	-- the current versions of all online logs are available. The second
--	-- set opens the database with the RESETLOGS option and should be used
--	-- if online logs are unavailable.
--	-- The appropriate set of statements can be copied from the trace into
--	-- a script file, edited as necessary, and executed when there is a
--	-- need to re-create the control file.
--	--
--	--     Set #1. NORESETLOGS case
--	--
--	-- The following commands will create a new control file and use it
--	-- to open the database.
--	-- Data used by Recovery Manager will be lost.
--	-- Additional logs may be required for media recovery of offline
--	-- Use this only if the current versions of all online logs are
--	-- available.
--	
--	-- After mounting the created controlfile, the following SQL
--	-- statement will place the database in the appropriate
--	-- protection mode:
--	--  ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE
--	
--	STARTUP NOMOUNT
--	CREATE CONTROLFILE REUSE DATABASE "FREE" NORESETLOGS  NOARCHIVELOG
--	    MAXLOGFILES 16
--	    MAXLOGMEMBERS 3
--	    MAXDATAFILES 1024
--	    MAXINSTANCES 8
--	    MAXLOGHISTORY 292
--	LOGFILE
--	  GROUP 1 '/opt/oracle/oradata/FREE/redo01.log'  SIZE 200M BLOCKSIZE 512,
--	  GROUP 2 '/opt/oracle/oradata/FREE/redo02.log'  SIZE 200M BLOCKSIZE 512,
--	  GROUP 3 '/opt/oracle/oradata/FREE/redo03.log'  SIZE 200M BLOCKSIZE 512
--	-- STANDBY LOGFILE
--	DATAFILE
--	  '/opt/oracle/oradata/FREE/system01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/system01.dbf',
--	  '/opt/oracle/oradata/FREE/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/users01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/system01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/users01.dbf',
--	  '/opt/oracle/product/26ai/dbhomeFree/dbs/TS_TIM.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/system01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/sysaux01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/undotbs01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/tim_qdata01.dbf'
--	CHARACTER SET AL32UTF8
--	;
--	
--	-- Commands to re-create incarnation table
--	-- Below log names MUST be changed to existing filenames on
--	-- disk. Any one log file from each branch can be used to
--	-- re-create incarnation records.
--	-- ALTER DATABASE REGISTER LOGFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/arch1_1_1215669386.dbf';
--	-- ALTER DATABASE REGISTER LOGFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/arch1_1_1224024843.dbf';
--	-- Recovery is required if any of the datafiles are restored backups,
--	-- or if the last shutdown was not normal or immediate.
--	RECOVER DATABASE
--	
--	-- Database can now be opened normally.
--	ALTER DATABASE OPEN;
--	
--	-- Open all the PDBs.
--	ALTER PLUGGABLE DATABASE ALL OPEN;
--	
--	-- Commands to add tempfiles to temporary tablespaces.
--	-- Online tempfiles have complete space information.
--	-- Other tempfiles may require adjustment.
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER SESSION SET CONTAINER = "PDB$SEED";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/pdbseed/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER SESSION SET CONTAINER = "FREEPDB1";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/FREEPDB1/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER TABLESPACE TS_TIM_TEMP ADD TEMPFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/TS_TIM_TEMP.dbf'
--	     SIZE 5242880  REUSE AUTOEXTEND ON NEXT 3145728  MAXSIZE 20971520 ;
--	ALTER SESSION SET CONTAINER = "TIM_PDB";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/PDB_TEST/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER TABLESPACE TS_TIM_PDB_TEMP ADD TEMPFILE '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb_temp01.dbf'
--	     SIZE 5242880  REUSE AUTOEXTEND ON NEXT 3145728  MAXSIZE 20971520 ;
--	ALTER SESSION SET CONTAINER = "CDB$ROOT";
--	-- End of tempfile additions.
--	--
--	--     Set #2. RESETLOGS case
--	--
--	-- The following commands will create a new control file and use it
--	-- to open the database.
--	-- Data used by Recovery Manager will be lost.
--	-- The contents of online logs will be lost and all backups will
--	-- be invalidated. Use this only if online logs are damaged.
--	
--	-- After mounting the created controlfile, the following SQL
--	-- statement will place the database in the appropriate
--	-- protection mode:
--	--  ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE
--	
--	STARTUP NOMOUNT
--	CREATE CONTROLFILE REUSE DATABASE "FREE" RESETLOGS  NOARCHIVELOG
--	    MAXLOGFILES 16
--	    MAXLOGMEMBERS 3
--	    MAXDATAFILES 1024
--	    MAXINSTANCES 8
--	    MAXLOGHISTORY 292
--	LOGFILE
--	  GROUP 1 '/opt/oracle/oradata/FREE/redo01.log'  SIZE 200M BLOCKSIZE 512,
--	  GROUP 2 '/opt/oracle/oradata/FREE/redo02.log'  SIZE 200M BLOCKSIZE 512,
--	  GROUP 3 '/opt/oracle/oradata/FREE/redo03.log'  SIZE 200M BLOCKSIZE 512
--	-- STANDBY LOGFILE
--	DATAFILE
--	  '/opt/oracle/oradata/FREE/system01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/system01.dbf',
--	  '/opt/oracle/oradata/FREE/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/users01.dbf',
--	  '/opt/oracle/oradata/FREE/pdbseed/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/system01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/sysaux01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/undotbs01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/users01.dbf',
--	  '/opt/oracle/product/26ai/dbhomeFree/dbs/TS_TIM.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/system01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/sysaux01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/undotbs01.dbf',
--	  '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb01.dbf',
--	  '/opt/oracle/oradata/FREE/FREEPDB1/tim_qdata01.dbf'
--	CHARACTER SET AL32UTF8
--	;
--	
--	-- Commands to re-create incarnation table
--	-- Below log names MUST be changed to existing filenames on
--	-- disk. Any one log file from each branch can be used to
--	-- re-create incarnation records.
--	-- ALTER DATABASE REGISTER LOGFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/arch1_1_1215669386.dbf';
--	-- ALTER DATABASE REGISTER LOGFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/arch1_1_1224024843.dbf';
--	-- Recovery is required if any of the datafiles are restored backups,
--	-- or if the last shutdown was not normal or immediate.
--	RECOVER DATABASE USING BACKUP CONTROLFILE
--	
--	-- Database can now be opened zeroing the online logs.
--	ALTER DATABASE OPEN RESETLOGS;
--	
--	-- Open all the PDBs.
--	ALTER PLUGGABLE DATABASE ALL OPEN;
--	
--	-- Commands to add tempfiles to temporary tablespaces.
--	-- Online tempfiles have complete space information.
--	-- Other tempfiles may require adjustment.
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER SESSION SET CONTAINER = "PDB$SEED";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/pdbseed/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER SESSION SET CONTAINER = "FREEPDB1";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/FREE/FREEPDB1/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER TABLESPACE TS_TIM_TEMP ADD TEMPFILE '/opt/oracle/product/26ai/dbhomeFree/dbs/TS_TIM_TEMP.dbf'
--	     SIZE 5242880  REUSE AUTOEXTEND ON NEXT 3145728  MAXSIZE 20971520 ;
--	ALTER SESSION SET CONTAINER = "TIM_PDB";
--	ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/PDB_TEST/temp01.dbf'
--	     SIZE 20971520  REUSE AUTOEXTEND ON NEXT 67108864  MAXSIZE 32767M;
--	ALTER TABLESPACE TS_TIM_PDB_TEMP ADD TEMPFILE '/opt/oracle/oradata/PDB_TEST/ts_tim_pdb_temp01.dbf'
--	     SIZE 5242880  REUSE AUTOEXTEND ON NEXT 3145728  MAXSIZE 20971520 ;
--	ALTER SESSION SET CONTAINER = "CDB$ROOT";
--	-- End of tempfile additions.
--	--
--	
--	SQL> 


--	10. Определите местоположение файла паролей инстанса.
-- Файл паролей называется orapwFREE или orapwORCL
-- Узнаём ORACLE_HOME
SELECT VALUE FROM V$PARAMETER WHERE NAME = 'spfile';


--	11. Убедитесь в наличии этого файла в операционной системе.
--	HOST ls -la /opt/oracle/product/23c/dbhomeFree/dbs/orapwFREE
--	/opt/oracle/product/26ai/dbhomeFree/dbs
--	sh-4.4$ ls
--	TS_TIM.dbf  TS_TIM_TEMP.dbf  arch1_17_1224024843.dbf  hc_FREE.dat  init.ora  lkFREE  orapwFREE  spfileFREE.ora
--	sh-4.4$ 

--	12. Получите перечень директориев для файлов сообщений и диагностики.
SELECT NAME, VALUE FROM V$DIAG_INFO;


--	13. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), найдите в нем
--	команды переключения журналов которые вы выполняли.
-- Узнаём путь к alert логу
SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Diag Alert';

-- Смотрим log.xml (ищем log switch — переключения журналов)
HOST grep -i "switch" /opt/oracle/diag/rdbms/free/FREE/alert/log.xml | head -30
--	TS_TIM.dbf  TS_TIM_TEMP.dbf  arch1_17_1224024843.dbf  hc_FREE.dat  init.ora  lkFREE  orapwFREE  spfileFREE.ora
--	sh-4.4$ HOST grep -i "switch" /opt/oracle/diag/rdbms/free/FREE/alert/log.xml | head -30
--	sh: HOST: command not found
--	sh-4.4$ sqlplus / as sysdba
--	
--	SQL*Plus: Release 23.26.0.0.0 - Production on Thu Mar 19 16:04:07 2026
--	Version 23.26.0.0.0
--	
--	Copyright (c) 1982, 2025, Oracle.  All rights reserved.
--	
--	
--	Connected to:
--	Oracle AI Database 26ai Free Release 23.26.0.0.0 - Develop, Learn, and Run for Free
--	Version 23.26.0.0.0
--	
--	SQL> HOST grep -i "switch" /opt/oracle/diag/rdbms/free/FREE/alert/log.xml | head -30
--	 <txt>Thread 1 advanced to log sequence 2 (LGWR switch),  current SCN: 2146226
--	 <txt>Thread 1 advanced to log sequence 3 (LGWR switch),  current SCN: 2232929
--	 <txt>Thread 1 advanced to log sequence 4 (LGWR switch),  current SCN: 2291234
--	 <txt>Thread 1 advanced to log sequence 5 (LGWR switch),  current SCN: 2365894
--	 <txt>Thread 1 advanced to log sequence 6 (LGWR switch),  current SCN: 2454933
--	 <txt>Thread 1 advanced to log sequence 7 (LGWR switch),  current SCN: 2532622
--	 <txt>Thread 1 advanced to log sequence 8 (LGWR switch),  current SCN: 2532723
--	 <txt>Thread 1 advanced to log sequence 9 (LGWR switch),  current SCN: 2532734
--	 <txt>Thread 1 advanced to log sequence 10 (LGWR switch),  current SCN: 2532742
--	 <txt>Thread 1 advanced to log sequence 11 (LGWR switch),  current SCN: 2532783
--	 <txt>Thread 1 advanced to log sequence 12 (LGWR switch),  current SCN: 2532791
--	 <txt>Thread 1 advanced to log sequence 13 (LGWR switch),  current SCN: 2532799
--	 <txt>Thread 1 advanced to log sequence 14 (LGWR switch),  current SCN: 2532819
--	 <txt>Thread 1 advanced to log sequence 15 (LGWR switch),  current SCN: 2532826
--	 <txt>Thread 1 advanced to log sequence 16 (LGWR switch),  current SCN: 2532929
--	 <txt>Thread 1 advanced to log sequence 17 (LGWR switch),  current SCN: 2532939
--	 <txt>Thread 1 advanced to log sequence 18 (LGWR switch),  current SCN: 2536368
--	 <txt>Thread 1 advanced to log sequence 19 (LGWR switch),  current SCN: 2642296
--	
--	SQL> 


--	14. Найдите и исследуйте содержимое трейса, в который вы сбросили управляющий файл.
-- После пункта 9 (ALTER DATABASE BACKUP CONTROLFILE TO TRACE)
-- трейс уже создан, узнаём точный путь
SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';

-- Смотрим содержимое — там будет CREATE CONTROLFILE
HOST cat <путь_из_предыдущего_запроса>





