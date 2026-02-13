CREATE VIEW [Топ_5_товаров_по_цене] AS
SELECT TOP 5 
    Наименование,
    Цена,
    Количество
FROM Товары
ORDER BY Цена DESC;