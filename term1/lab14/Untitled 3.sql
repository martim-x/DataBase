-- CREATE FUNCTION F_OrdersFiltered
-- (
--     @product NVARCHAR(40),
--     @minPrice REAL
-- )
-- RETURNS @result TABLE
-- (
--     Номер_заказа NVARCHAR(20),
--     Наименование_товара NVARCHAR(40),
--     Цена_продажи REAL,
--     Количество INT,
--     Заказчик NVARCHAR(40)
-- )
-- AS
-- BEGIN
--     INSERT INTO @result
--     SELECT
--         Номер_заказа,
--         Наименование_товара,
--         Цена_продажи,
--         Количество,
--         Заказчик
--     FROM Заказы
--     WHERE Наименование_товара = ISNULL(@product, Наименование_товара)
--       AND Цена_продажи >= ISNULL(@minPrice, Цена_продажи);
-- 
--     RETURN;
-- END;
-- GO

SELECT * FROM dbo.F_OrdersFiltered(NULL, NULL);
SELECT * FROM dbo.F_OrdersFiltered(N'Монитор', NULL);
SELECT * FROM dbo.F_OrdersFiltered(NULL, 100);
SELECT * FROM dbo.F_OrdersFiltered(N'Монитор', 100);
