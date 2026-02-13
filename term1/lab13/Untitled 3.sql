CREATE PROCEDURE OrdersTempTable
AS
BEGIN
    -- создаём временную таблицу
    CREATE TABLE #TempOrders
    (
        Номер_заказа NVARCHAR(20),
        Наименование_товара NVARCHAR(40),
        Количество INT,
        Цена_продажи REAL,
        Заказчик NVARCHAR(40)
    );

    -- вставляем данные из основной таблицы Заказы
    INSERT INTO #TempOrders
    SELECT Номер_заказа, Наименование_товара, Количество, Цена_продажи, Заказчик
    FROM Заказы;

    -- выводим все строки из временной таблицы
    SELECT * FROM #TempOrders;

    -- удаляем временную таблицу автоматически при завершении процедуры
END;
GO

EXEC OrdersTempTable;