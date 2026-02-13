-- Анализ фрагментации и обслуживание
-- DROP TABLE #EXPLRE;
-- 
-- CREATE TABLE #EXPLRE (
--     id INT PRIMARY KEY,
--     val INT,
--     description NVARCHAR(100)
-- );
-- 
-- 1. Создаем начальные данные
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


-- исскуственно повышаем фрагментацию
-- ;WITH Numbers AS (
--     SELECT 10001 AS num
--     UNION ALL
--     SELECT num + 1
--     FROM Numbers
--     WHERE num < 20000
-- )
-- INSERT INTO #EXPLRE (id, val, description)
-- SELECT 
--     num,
--     num,
--     'Описание_' + CAST(num AS NVARCHAR(10))
-- FROM Numbers
-- OPTION (MAXRECURSION 0);

-- UPDATE #EXPLRE SET val = 30000 - val WHERE id BETWEEN 0 AND 30000;

-- 
-- Создаем индекс для анализа
-- CREATE NONCLUSTERED INDEX IX_EXPLRE_Frag ON #EXPLRE(val);
-- 
--  Проверяем фрагментацию
SELECT 
    i.name AS [Индекс],
    ips.avg_fragmentation_in_percent AS [Фрагментация ДО (%)]
FROM tempdb.sys.dm_db_index_physical_stats(
    DB_ID('tempdb'),
    OBJECT_ID('tempdb..#EXPLRE'),
    NULL, NULL, NULL
) ips
JOIN tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id;
--
-- 
-- 
--  Реорганизация индекса
-- ALTER INDEX IX_EXPLRE_Frag ON #EXPLRE REORGANIZE;
-- 

-- 
-- Перестройка индекса
-- ALTER INDEX IX_EXPLRE_Frag ON #EXPLRE REBUILD;
