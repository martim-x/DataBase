-- FILLFACTOR
-- DROP TABLE #EXPLRE;
-- 
-- CREATE TABLE #EXPLRE (
--     id INT PRIMARY KEY,
--     val INT,
--     description NVARCHAR(100)
-- );
-- 
-- 
-- ;WITH Numbers AS (
--     SELECT 1 AS num
--     UNION ALL
--     SELECT num + 1
--     FROM Numbers
--     WHERE num < 10000
-- )
-- INSERT INTO #EXPLRE (id, val, description)
-- SELECT 
--     num,
--     num,
--     'Описание_' + CAST(num AS NVARCHAR(10))
-- FROM Numbers
-- OPTION (MAXRECURSION 0);
-- -- 
-- Создаем индекс с FILLFACTOR = 65
-- drop index IX_EXPLRE_FillFactor on #EXPLRE
-- CREATE NONCLUSTERED INDEX IX_EXPLRE_FillFactor ON #EXPLRE(val) WITH (FILLFACTOR = 65);
-- CREATE NONCLUSTERED INDEX IX_EXPLRE_FillFactor ON #EXPLRE(val);


-- Проверяем фрагментацию и страницы
SELECT 
    i.name AS [Индекс],
    ips.avg_fragmentation_in_percent AS [Фрагментация (%)],
    ips.page_count AS [Количество страниц]
FROM tempdb.sys.dm_db_index_physical_stats(
    DB_ID('tempdb'),
    OBJECT_ID('tempdb..#EXPLRE'),
    NULL, NULL, NULL
) ips
JOIN tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id;

-- Тестовый запрос
-- CHECKPOINT;
-- DBCC DROPCLEANBUFFERS;
-- SET STATISTICS TIME ON;
-- SET SHOWPLAN_XML ON;
-- 
-- SELECT * FROM #EXPLRE WHERE val BETWEEN 1000 AND 3000;
-- 
-- SET SHOWPLAN_XML OFF;
-- SET STATISTICS TIME OFF;



-- Изменили 50% данных
-- 
-- Команда, которая вызовет фрагментацию через UPDATE val
-- UPDATE #EXPLRE SET val = 30000 - val WHERE id BETWEEN  0 AND 15000;
--