-- 
-- 
-- -- Количество заказов товара
-- CREATE FUNCTION F_CountOrdersForProduct(@product NVARCHAR(40))
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @r INT;
--     SELECT @r = COUNT(*) FROM Заказы WHERE Наименование_товара = @product;
--     RETURN @r;
-- END;
-- go
-- 
-- -- Количество заказчиков товара
-- CREATE FUNCTION F_CountCustomersForProduct(@product NVARCHAR(40))
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @r INT;
--     SELECT @r = COUNT(DISTINCT Заказчик) 
--     FROM Заказы WHERE Наименование_товара = @product;
--     RETURN @r;
-- END;
-- go
-- 
-- -- Сумма продаж
-- CREATE FUNCTION F_SumSalesForProduct(@product NVARCHAR(40))
-- RETURNS REAL
-- AS
-- BEGIN
--     DECLARE @r REAL;
--     SELECT @r = SUM(Цена_продажи * Количество)
--     FROM Заказы WHERE Наименование_товара = @product;
--     RETURN @r;
-- END;
-- go
-- 
-- -- Количество «крупных» заказов
-- CREATE FUNCTION F_CountBigOrdersForProduct
-- (
--     @product NVARCHAR(40),
--     @minQty INT
-- )
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @r INT;
--     SELECT @r = COUNT(*)
--     FROM Заказы
--     WHERE Наименование_товара = @product
--       AND Количество >= @minQty;
-- 
--     RETURN @r;
-- END;
-- GO


create FUNCTION F_ReportProducts(@minQty INT)
RETURNS @report TABLE
(
    Товар NVARCHAR(40),
    КолВо_Заказов INT,
    КолВо_Заказчиков INT,
    Сумма_Продаж REAL,
    Крупные_Заказы INT
)
AS
BEGIN
    DECLARE cur CURSOR STATIC FOR
    SELECT Наименование FROM Товары;

    DECLARE @p NVARCHAR(40);
    OPEN cur;

    FETCH cur INTO @p;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @report
        SELECT
            @p,
           dbo.F_CountOrdersForProduct(@p),
           dbo.F_CountCustomersForProduct(@p),
           dbo.F_SumSalesForProduct(@p),
           dbo.F_CountBigOrdersForProduct(@p, @minQty);

        FETCH cur INTO @p;
    END;

    RETURN;
END;


go 

SELECT *
FROM dbo.F_ReportProducts(10);

