CREATE PROCEDURE InsertProduct
    @Name NVARCHAR(40),
    @Price REAL,
    @Quantity INT,
    @Customer NVARCHAR(40)
AS
BEGIN
    DECLARE @rc INT = 1;

    BEGIN TRY
        INSERT INTO Товары (Наименование, Цена, Количество)
        VALUES (@Name, @Price, @Quantity);

        INSERT INTO Заказы (Номер_заказа, Наименование_товара, Цена_продажи, Количество, Дата_поставки, Заказчик)
        VALUES (NEWID(), @Name, @Price, @Quantity, GETDATE(), @Customer);

        RETURN 1; -- успешно
    END TRY
    BEGIN CATCH
        PRINT 'Номер ошибки: ' + CAST(ERROR_NUMBER() AS NVARCHAR(6));
        PRINT 'Сообщение: ' + ERROR_MESSAGE();
        PRINT 'Уровень: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(6));
        PRINT 'Меткa: ' + CAST(ERROR_STATE() AS NVARCHAR(8));
        PRINT 'Номер строки: ' + CAST(ERROR_LINE() AS NVARCHAR(8));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Имя процедуры: ' + ERROR_PROCEDURE();

        RETURN -1; -- ошибка
    END CATCH
END;
GO



DECLARE @Status INT;
EXEC @Status = InsertProduct @Name = N'Тестовый товар', @Price = 123, @Quantity = 10, @Customer = N'Луч';
PRINT 'Статус процедуры InsertProduct: ' + CAST(@Status AS NVARCHAR(5));
