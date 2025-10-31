SELECT 
    Наименование_товара,
    Цена_продажи,
    CASE 
        WHEN Цена_продажи < 50 THEN N'Дешевый'
        WHEN Цена_продажи BETWEEN 50 AND 200 THEN N'Средний'
        WHEN Цена_продажи BETWEEN 201 AND 500 THEN N'Дорогой'
        ELSE N'Очень дорогой'
    END AS N'Категория цены',
    Количество
FROM Заказы
ORDER BY Цена_продажи DESC;