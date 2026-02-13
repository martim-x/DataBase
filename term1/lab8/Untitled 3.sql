CREATE VIEW [Дорогие_товары] AS
SELECT 
    Наименование,
    Цена,
    Количество
FROM Товары
WHERE Цена > 500;


-- check option добавить