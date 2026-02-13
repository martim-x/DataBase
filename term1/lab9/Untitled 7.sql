CREATE TABLE #АнализТоваров 
(
    ID INT IDENTITY(1,1),
    Наименование_товара NVARCHAR(40),
    Средняя_цена REAL,
    Общее_количество INT
);

DECLARE @i INT = 1;
DECLARE @max_id INT = (SELECT COUNT(DISTINCT Наименование_товара) FROM Заказы);

WHILE @i <= @max_id
BEGIN
    INSERT INTO #АнализТоваров (Наименование_товара, Средняя_цена, Общее_количество)
    SELECT 
        Наименование_товара,
        AVG(Цена_продажи),
        SUM(Количество)
    FROM Заказы 
    GROUP BY Наименование_товара
    ORDER BY Наименование_товара
    OFFSET @i-1 ROWS FETCH NEXT 1 ROWS ONLY;
    
    SET @i = @i + 1;
END;

SELECT * FROM #АнализТоваров;
DROP TABLE #АнализТоваров;