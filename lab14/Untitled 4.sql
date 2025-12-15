-- CREATE FUNCTION F_AmountOfProducts
-- (
--     @customer NVARCHAR(40)
-- )
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @result INT;
-- 
--     IF @customer IS NULL
--     BEGIN
--         SELECT @result = COUNT(*) FROM Заказы;
--         RETURN @result;
--     END;
-- 
--     SELECT @result = COUNT(*) 
--     FROM Заказы
--     WHERE Заказчик = @customer;
-- 
--     RETURN @result;
-- END;
-- GO

SELECT dbo.F_AmountOfProducts(N'ТехМаг') AS КоличествоЗаказов;
SELECT dbo.F_AmountOfProducts(NULL) AS Все_Заказы;
