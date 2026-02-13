-- некласторизированный индекс
-- drop table #EXPLRE
-- -- 
-- CREATE TABLE #EXPLRE (
--     id INT,
--     val INT,
-- 	buffer INT
-- );

-- Создаем некластеризованный неуникальный составной индекс
-- CREATE NONCLUSTERED INDEX IX_EXPLRE_Composite ON #EXPLRE(id, val);

-- ;WITH Numbers AS (
--     SELECT 1 AS num
--     UNION ALL
--     SELECT num + 1
--     FROM Numbers
--     WHERE num < 20000
-- )
-- INSERT INTO #EXPLRE (id, val, buffer)
-- SELECT num, num, num
-- FROM Numbers
-- OPTION (MAXRECURSION 0); --из за 20 000 повторов

-- CHECKPOINT;


-- SET STATISTICS TIME ON;
-- SET SHOWPLAN_XML ON;
-- 
SELECT id,val from #EXPLRE
where id < 10000
-- 
-- SET SHOWPLAN_XML OFF;
-- SET STATISTICS TIME OFF;