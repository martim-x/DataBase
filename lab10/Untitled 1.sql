-- EXEC sp_helpindex N'Заказчики';
-- EXEC sp_helpindex N'Товары';
-- EXEC sp_helpindex N'Заказы';
-- -- класторизированный индекс
-- drop table #EXPLRE
-- 
-- CREATE TABLE #EXPLRE (
--     id INT PRIMARY KEY,
--     val INT
-- );
-- 
-- DECLARE @I INT = 1;
-- 
-- WHILE @I <= 2000
-- BEGIN
--     INSERT INTO  #EXPLRE(id, val)
--     VALUES (@I, @I);
--     
--     SET @I = @I + 1;
-- END;

-- CHECKPOINT;
-- 
-- DBCC DROPCLEANBUFFERS;
-- SET SHOWPLAN_XML ON;
-- SET STATISTICS TIME ON;


SELECT * from #EXPLRE
-- where val < 1000
where id < 1000
-- 
-- SET SHOWPLAN_XML OFF;
-- SET STATISTICS TIME OFF;