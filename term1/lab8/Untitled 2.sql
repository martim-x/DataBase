CREATE VIEW [Количество_заказов_по_заказчикам] AS
SELECT 
    z.Заказчик,
    COUNT(*) AS Количество_заказов
FROM Заказы AS z
GROUP BY z.Заказчик;