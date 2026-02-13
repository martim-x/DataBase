-- create FUNCTION F_CountOrdersByCustomer
-- (
--     @customer NVARCHAR(40)
-- )
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @result INT;
-- 
--     SELECT @result = COUNT(*)
--     FROM Заказы
--     WHERE Заказчик = @customer;
-- 
--     RETURN @result;
-- END;
-- go
-- 
-- SELECT dbo.F_CountOrdersByCustomer(N'ТехМаг');


alter FUNCTION F_CountOrdersByCustomer
(
    @customer NVARCHAR(40),
    @minPrice REAL
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    SELECT @result = COUNT(*)
    FROM Заказы
    WHERE Заказчик = @customer
      AND Цена_продажи >= ISNULL(@minPrice, Цена_продажи);

    RETURN @result;
END;
GO

SELECT dbo.F_CountOrdersByCustomer(N'ТехМаг', 100);
SELECT dbo.F_CountOrdersByCustomer(N'Техмаг', NULL);
