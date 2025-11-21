-- SELECT 
--     LEFT(Наименование_фирмы, 1) AS Первая_буква,
--     *
-- FROM Заказчики;
-- 

-- Запрос для поиска заказов за прошлый месяц
-- DECLARE @TargetMonth DATE = '2025-10-01';
-- 
-- SELECT 
--     Номер_заказа AS OrderID,
--     Наименование_товара AS ProductName,
--     Цена_продажи AS Price,
--     Количество AS Quantity,
--     Дата_поставки AS OrderDate,
--     Заказчик AS CustomerName,
--     DATEDIFF(DAY, 
--              Дата_поставки,  -- От даты заказа
--              @TargetMonth) AS Дней_до_указанного_месяца  -- До целевого месяца
-- FROM Заказы
-- WHERE Дата_поставки >= DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @TargetMonth), 0))
--   AND Дата_поставки < DATEADD(MONTH, DATEDIFF(MONTH, 0, @TargetMonth), 0)
-- ORDER BY Дата_поставки;

-- Запрос для определения дня недели с рекордным количеством заказов
WITH OrderCounts AS (
    SELECT 
        DATENAME(WEEKDAY, Дата_поставки) AS День_недели,
        DATEPART(WEEKDAY, Дата_поставки) AS Номер_дня_недели,
        COUNT(*) AS Количество_заказов
    FROM Заказы
    GROUP BY DATENAME(WEEKDAY, Дата_поставки), DATEPART(WEEKDAY, Дата_поставки)
)
SELECT TOP 1
    День_недели,
    Количество_заказов
FROM OrderCounts
ORDER BY Количество_заказов DESC, Номер_дня_недели;