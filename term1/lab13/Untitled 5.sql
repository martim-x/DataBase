-- alter PROCEDURE OrdersReport
--     @Customer NVARCHAR(40)
-- AS
-- BEGIN
--     DECLARE @OrderName NVARCHAR(40), @Report NVARCHAR(MAX) = '', @Count INT = 0;
-- 
--     BEGIN TRY
--         DECLARE OrdersCursor CURSOR FOR
--         SELECT Наименование_товара FROM Заказы WHERE Заказчик = @Customer;
-- 
--         IF NOT EXISTS (SELECT 1 FROM Заказы WHERE Заказчик = @Customer)
--             RAISERROR(N'Заказчик не найден', 11, 1);
-- 
--         OPEN OrdersCursor;
--         FETCH NEXT FROM OrdersCursor INTO @OrderName;
-- 
--         WHILE @@FETCH_STATUS = 0
--         BEGIN
--             SET @Report = RTRIM(@OrderName) + ', ' + @Report;
--             SET @Count = @Count + 1;
--             FETCH NEXT FROM OrdersCursor INTO @OrderName;
--         END;
-- 
--         CLOSE OrdersCursor;
--         DEALLOCATE OrdersCursor;
-- 
--         PRINT N'Заказы заказчика ' + @Customer + ': ' + @Report;
--         RETURN @Count;
--     END TRY
--     BEGIN CATCH
--         PRINT N'Ошибка в параметрах';
--         IF ERROR_PROCEDURE() IS NOT NULL
--             PRINT N'Имя процедуры: ' + ERROR_PROCEDURE();
--         RETURN -1;
--     END CATCH
-- END;
-- GO


DECLARE @ReportCount INT;

EXEC @ReportCount = OrdersReport @Customer = N'ТехМаг1';
PRINT N'Количество заказов в отчете: ' + CAST(@ReportCount AS NVARCHAR(5));