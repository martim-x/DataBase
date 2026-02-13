ALTER PROCEDURE GetOrders
    @Customer NVARCHAR(40),
    @OrderCount INT OUTPUT
AS
BEGIN
    -- получаем все заказы для конкретного заказчика
    SELECT * FROM Заказы WHERE Заказчик = @Customer;

    -- записываем количество в OUTPUT
    SET @OrderCount = @@ROWCOUNT;

    -- выводим в консоль
    PRINT N'Количество заказов для заказчика ' + @Customer + ': ' + CAST(@OrderCount AS NVARCHAR(10));

    -- возвращаем общее количество всех заказов
    RETURN (SELECT COUNT(*) FROM Заказы);
END;
GO

DECLARE @Count INT;
DECLARE @Total INT;
EXEC @Total = GetOrders @Customer = N'ТехМаг', @OrderCount = @Count OUTPUT;
PRINT N'Количество заказов для заказчика: ' + CAST(@Count AS NVARCHAR(10));
PRINT N'Общее количество заказов: ' + CAST(@Total AS NVARCHAR(10));