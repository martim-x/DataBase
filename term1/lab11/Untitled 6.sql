PRINT N'=== ЗАКАЗЫ, ПОДПАДАЮЩИЕ ПОД УСЛОВИЕ (Количество > 3) ===';

DECLARE cur CURSOR LOCAL FOR
SELECT 
    З.Номер_заказа,
    З.Наименование_товара,
    З.Количество,
    З.Заказчик,
    Т.Цена,
    ЗК.Адрес
FROM Заказы З
JOIN Товары Т ON З.Наименование_товара = Т.Наименование
JOIN Заказчики ЗК ON З.Заказчик = ЗК.Наименование_фирмы
WHERE З.Количество > 3;

OPEN cur;

DECLARE 
    @id nvarchar(20),
    @товар nvarchar(40),
    @кол int,
    @заказчик nvarchar(40),
    @цена real,
    @адрес nvarchar(100);

FETCH NEXT FROM cur INTO @id, @товар, @кол, @заказчик, @цена, @адрес;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Найден заказ: ' 
        + @id + N' | ' 
        + @товар + N' | Кол-во: ' + CAST(@кол AS nvarchar(10))
        + N' | Заказчик: ' + @заказчик
        + N' | Цена: ' + CAST(@цена AS nvarchar(20))
        + N' | Адрес: ' + @адрес;

    FETCH NEXT FROM cur INTO @id, @товар, @кол, @заказчик, @цена, @адрес;
END;

CLOSE cur;
DEALLOCATE cur;

PRINT N'=== ОБРАБОТКА ЗАКОНЧЕНА ===';



---------------------------------------------------------
-- ЗАДАНИЕ 2 — увеличение количества по ID
---------------------------------------------------------

DECLARE @id_ nvarchar(20) = 'Z001';

PRINT N'=== ПОИСК ЗАКАЗА ДЛЯ ОБНОВЛЕНИЯ ===';

DECLARE cur2 CURSOR LOCAL FOR
SELECT Номер_заказа, Наименование_товара, Количество
FROM Заказы
WHERE Номер_заказа = @id_;

OPEN cur2;

DECLARE
    @id2 nvarchar(20),
    @товар2 nvarchar(40),
    @кол2 int;

FETCH NEXT FROM cur2 INTO @id2, @товар2, @кол2;

IF @@FETCH_STATUS <> 0
BEGIN
    PRINT N'Заказ не найден';
    CLOSE cur2;
    DEALLOCATE cur2;
    RETURN;
END;

PRINT N'До обновления: Заказ ' + @id2 
    + N' | ' + @товар2 
    + N' | Количество: ' + CAST(@кол2 AS nvarchar(10));

-- Увеличиваем количество
UPDATE Заказы
SET Количество = @кол2 + 1
WHERE Номер_заказа = @id2;

PRINT N'Количество увеличено на 1';

CLOSE cur2;
DEALLOCATE cur2;



---------------------------------------------------------
-- Чтение нового значения курсором cur3
---------------------------------------------------------

DECLARE cur3 CURSOR LOCAL FOR
SELECT Номер_заказа, Наименование_товара, Количество
FROM Заказы
WHERE Номер_заказа = @id_;

OPEN cur3;

DECLARE
    @id3 nvarchar(20),
    @товар3 nvarchar(40),
    @кол3 int;

FETCH NEXT FROM cur3 INTO @id3, @товар3, @кол3;

PRINT N'После обновления: Заказ ' + @id3
    + N' | ' + @товар3
    + N' | Количество: ' + CAST(@кол3 AS nvarchar(10));

CLOSE cur3;
DEALLOCATE cur3;

PRINT N'=== ОБНОВЛЕНИЕ ЗАВЕРШЕНО ===';
