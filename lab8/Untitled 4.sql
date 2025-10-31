CREATE VIEW [Товары_дешевле_средней] AS
SELECT 
    Наименование,
    Цена,
    Количество
FROM Товары
WHERE Цена < (SELECT AVG(Цена) FROM Товары)
WITH CHECK OPTION;

