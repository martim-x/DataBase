BEGIN TRY
    BEGIN TRAN

    -- Пример вставки/удаления товаров
    DELETE FROM Товары WHERE Наименование = N'Блендер';
--	   демонстрация catch
--     DELETE FROM Товары WHERE Наименование = 'Блендер';
    INSERT INTO Товары VALUES (N'Блендер', 60, 10);
    INSERT INTO Товары VALUES (N'Мышка', 120, 52);

    COMMIT TRAN
END TRY
BEGIN CATCH
    DECLARE @msg NVARCHAR(4000);
    
    -- Определяем ошибку
    IF ERROR_NUMBER() = 2627 AND PATINDEX('%PK__Товары__%', ERROR_MESSAGE()) > 0
        SET @msg = N'Дублирование товара';
    ELSE
        SET @msg = N'Неизвестная ошибка: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N' - ' + ERROR_MESSAGE();

    PRINT @msg;

    -- Откат транзакции, если она еще открыта
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;
END CATCH;
