BEGIN TRY
    INSERT INTO Товары (Наименование, Цена, Количество) 
    VALUES (N'Стол', 100, 5);
END TRY
BEGIN CATCH
    PRINT N'=== ОБРАБОТКА ОШИБКИ ===';
    PRINT N'Код ошибки: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT N'Сообщение: ' + ERROR_MESSAGE();
    PRINT N'Строка ошибки: ' + CAST(ERROR_LINE() AS NVARCHAR);
    PRINT N'Уровень серьезности: ' + CAST(ERROR_SEVERITY() AS NVARCHAR);
    PRINT N'Состояние: ' + CAST(ERROR_STATE() AS NVARCHAR);
END CATCH;

BEGIN TRY
    INSERT INTO Заказы (Номер_заказа, Наименование_товара, Цена_продажи, Количество, Дата_поставки, Заказчик)
    VALUES (999, N'НесуществующийТовар', 100, 1, GETDATE(), N'Луч');
END TRY
BEGIN CATCH
    PRINT N'=== ОШИБКА ВНЕШНЕГО КЛЮЧА ===';
    PRINT N'Сообщение: ' + ERROR_MESSAGE();
END CATCH;