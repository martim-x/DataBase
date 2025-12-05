DECLARE @stage NVARCHAR(20);
SET @stage = N'Начало';

BEGIN TRY
    BEGIN TRAN

    -- Удаляем старый товар
    DELETE FROM Товары WHERE Наименование = N'Стул обыкновенный';
    SET @stage = N'Контрольная точка 1';
    SAVE TRAN @stage;

    -- Вставка нового товара
    INSERT INTO Товары VALUES (N'Стул обыкновенный', 10, 80);
    SET @stage = N'Контрольная точка 2';
    SAVE TRAN @stage;

    INSERT INTO Товары VALUES (N'Бленyдер', 50, 90);

    COMMIT TRAN
    PRINT N'Транзакция успешно завершена';
END TRY
BEGIN CATCH
    DECLARE @msg NVARCHAR(4000);

    -- Определяем тип ошибки
    IF ERROR_NUMBER() = 2627 AND PATINDEX('%PK__Товары__%', ERROR_MESSAGE()) > 0
        SET @msg = N'Ошибка: дублирование товара';
    ELSE IF ERROR_NUMBER() = 547 AND PATINDEX('%FK__Товары__%', ERROR_MESSAGE()) > 0
        SET @msg = N'Ошибка: нарушение внешнего ключа';
    ELSE
        SET @msg = N'Неизвестная ошибка: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + N' - ' + ERROR_MESSAGE();

    PRINT @msg;
    PRINT N'Произошла ошибка на стадии: ' + @stage;

    -- Откат к контрольной точке
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRAN @stage;
        PRINT N'Откат к контрольной точке выполнен: ' + @stage;
        COMMIT TRAN; -- фиксируем изменения до контрольной точки
    END
END CATCH;
