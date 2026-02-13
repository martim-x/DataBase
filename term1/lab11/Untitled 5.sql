-- Курсор с применением CURRENT OF для UPDATE и DELETE
PRINT N'=== ПРИМЕНЕНИЕ CURRENT OF ДЛЯ UPDATE И DELETE ===';

-- Используем существующего заказчика с заказами
DECLARE @тестовый_заказчик nvarchar(40);
SELECT TOP 1 @тестовый_заказчик = Заказчик FROM Заказы;
PRINT N'Используем заказчика: ' + @тестовый_заказчик;

DECLARE @номер nvarchar(20), @товар nvarchar(40), @количество int;
DECLARE текущий_курсор CURSOR LOCAL DYNAMIC SCROLL FOR 
SELECT Номер_заказа, Наименование_товара, Количество 
FROM Заказы 
WHERE Заказчик = @тестовый_заказчик
FOR UPDATE;

OPEN текущий_курсор;

PRINT N'Исходные данные:';
FETCH FIRST FROM текущий_курсор INTO @номер, @товар, @количество;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Исходно: ' + @номер + ' - ' + @товар + ' - ' + CAST(@количество AS nvarchar(10));
    FETCH NEXT FROM текущий_курсор INTO @номер, @товар, @количество;
END;

-- Возвращаемся к началу
FETCH FIRST FROM текущий_курсор;

-- Удаляем первую строку с помощью CURRENT OF
FETCH NEXT FROM текущий_курсор INTO @номер, @товар, @количество;
IF @@FETCH_STATUS = 0
BEGIN
    PRINT N'Удаляем заказ: ' + @номер;
    DELETE FROM Заказы WHERE CURRENT OF текущий_курсор;
    PRINT N'Заказ удален с помощью CURRENT OF';
END;

-- Переходим к следующей строке и обновляем с помощью CURRENT OF
FETCH NEXT FROM текущий_курсор INTO @номер, @товар, @количество;
IF @@FETCH_STATUS = 0
BEGIN
    PRINT N'Обновляем заказ: ' + @номер + ' (увеличиваем количество на 5)';
    UPDATE Заказы SET Количество = Количество + 5 WHERE CURRENT OF текущий_курсор;
    PRINT N'Заказ обновлен с помощью CURRENT OF';
END;

CLOSE текущий_курсор;
DEALLOCATE текущий_курсор;

PRINT N'=== РЕЗУЛЬТАТЫ ОПЕРАЦИЙ ===';
SELECT Номер_заказа, Наименование_товара, Количество 
FROM Заказы 
WHERE Заказчик = @тестовый_заказчик;