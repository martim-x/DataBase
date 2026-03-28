ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = freepdb1;

--	1 Определите общий размер области SGA.
SELECT sum(bytes) AS total_sga_bytes FROM v$sgainfo


--	2 Определите текущие размеры основных пулов SGA.
SELECT * FROM v$sgainfo


--	3 Определите размеры гранулы для каждого пула.
SELECT * FROM v$sgainfo
WHERE name = 'Granule Size'


--	4 Определите объем доступной свободной памяти в SGA.
SELECT bytes AS free_sga_memory_bytes
FROM v$sgainfo
WHERE name = 'Free SGA Memory Available';


--	5 Определите максимальный и целевой размер области SGA.
SELECT name, value
FROM v$parameter
WHERE name IN ('sga_max_size', 'sga_target')
ORDER BY name;


--	6 Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
SELECT * FROM v$buffer_pool
ORDER BY name;



--	7 Создайте таблицу, которая будет помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
CREATE TABLE t_keep (
  id NUMBER,
  txt VARCHAR2(100)
)
STORAGE (BUFFER_POOL KEEP);

INSERT INTO t_keep VALUES (1, 'KEEP');
COMMIT;

SELECT segment_name, segment_type, tablespace_name, bytes
FROM user_segments
WHERE segment_name = 'T_KEEP';

SELECT table_name, buffer_pool
FROM user_tables
WHERE table_name = 'T_KEEP';


--	8 Создайте таблицу, которая будет кэшироваться в пуле DEFAULT.	Продемонстрируйте сегмент таблицы.
CREATE TABLE t_default (
  id NUMBER,
  txt VARCHAR2(100)
)
STORAGE (BUFFER_POOL DEFAULT);

INSERT INTO t_default VALUES (1, 'DEFAULT');
COMMIT;

SELECT segment_name, segment_type, tablespace_name, bytes
FROM user_segments
WHERE segment_name = 'T_DEFAULT';

SELECT table_name, buffer_pool
FROM user_tables
WHERE table_name = 'T_DEFAULT';


--	9 Найдите размер буфера журналов повтора.
SELECT name, bytes
FROM v$sgainfo
WHERE name = 'Redo Buffers';


--	10 Найдите размер свободной памяти в большом пуле.
SELECT bytes AS free_memory_large_pool
FROM v$sgastat
WHERE pool = 'large pool'
  AND name = 'free memory';


--	11 Определите режимы текущих соединений с инстансом (dedicated, shared).
SELECT server, COUNT(*) cnt
FROM v$session
GROUP BY server
ORDER BY server;


--	12 Получите полный список работающих в настоящее время фоновых процессов.
SELECT DISTINCT p.pname
FROM v$session s
JOIN v$process p ON p.addr = s.paddr
WHERE s.type = 'BACKGROUND'
ORDER BY p.pname;


--	13 Получите список работающих в настоящее время серверных процессов.
SELECT p.spid, s.sid, s.serial#, s.username, s.server, s.program
FROM v$session s
LEFT JOIN v$process p ON p.addr = s.paddr
WHERE s.type <> 'BACKGROUND'
  AND s.username IS NOT NULL
ORDER BY s.sid;


--	14 Определите, сколько процессов DBWn работает в настоящий момент.
SELECT COUNT(*) AS dbwn_count
FROM v$process
WHERE pname LIKE 'DBW%';

SELECT pname, spid, program
FROM v$process
WHERE pname LIKE 'DBW%'
ORDER BY pname;


--	15 Определите сервисы (точки подключения экземпляра).
SELECT name, network_name
FROM v$active_services
ORDER BY name;


--	16 Получите известные вам параметры диспетчеров.
SELECT name, value
FROM v$parameter
WHERE name IN (
  'dispatchers',
  'max_dispatchers',
  'shared_servers',
  'max_shared_servers',
  'local_listener',
  'remote_listener'
)
ORDER BY name;


--	17 Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.



--	18 Продемонстрируйте и поясните содержимое файла LISTENER.ORA.
--	LISTENER =
--	  (DESCRIPTION_LIST =
--	    (DESCRIPTION =
--	      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_FREE))
--	      (ADDRESS = (PROTOCOL = TCP)(HOST=)(PORT = 1521))
--	    )
--	  )
--	
--	DEFAULT_SERVICE_LISTENER = FREE


--	19 Запустите утилиту lsnrctl и поясните ее основные команды.
--	start — запустить listener.
--	stop — остановить listener.
--	status — показать состояние listener.
--	reload — перечитать конфигурацию.
--	services — показать службы, обслуживаемые listener.
--	version — показать версию.
--	help — справка.


--	20 Получите список служб инстанса, обслуживаемых процессом LISTENER.
--	LSNRCTL> services
--	Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC_FOR_FREE)))
--	Services Summary...
--	Service "49b7fcb1a6a30d64e0636402000a4e1a" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "DEDICATED" established:0 refused:0 state:ready
--	         LOCAL SERVER
--	Service "4bb7e2bc76c301e7e063020011ac7f2f" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "DEDICATED" established:0 refused:0 state:ready
--	         LOCAL SERVER
--	Service "FREE" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "DEDICATED" established:0 refused:0 state:ready
--	         LOCAL SERVER
--	Service "FREEXDB" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "D000" established:0 refused:0 current:0 max:1022 state:ready
--	         DISPATCHER <machine: 9a043543db2d, pid: 164>
--	         (ADDRESS=(PROTOCOL=tcp)(HOST=9a043543db2d)(PORT=39575))
--	Service "freepdb1" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "DEDICATED" established:0 refused:0 state:ready
--	         LOCAL SERVER
--	Service "tim_pdb" has 1 instance(s).
--	  Instance "FREE", status READY, has 1 handler(s) for this service...
--	    Handler(s):
--	      "DEDICATED" established:0 refused:0 state:ready
--	         LOCAL SERVER
--	The command completed successfully
--	LSNRCTL> 


--	PMON, SMON, DBWn, LGWR, CKPT, ARCn, MMON, LREG, CJQ0.	
--	PMON — очищает после упавших сессий, освобождает ресурсы.
--	SMON — выполняет служебное восстановление экземпляра.
--	DBWn — пишет грязные блоки из buffer cache на диск.
--	LGWR — пишет redo из redo buffer в online redo log.
--	CKPT — координирует checkpoint.
--	ARCn — архивирует заполненные redo logs.
--	MMON / MMNL — собирают статистику и мониторинг.
--	LREG — регистрирует сервисы у listener’а.
--	CJQ0 — управляет очередью job’ов.


