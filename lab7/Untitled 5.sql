SELECT g.Наименование_товара
FROM Заказы g
WHERE g.Цена_продажи < 100
EXCEPT
SELECT g.Наименование_товара
FROM Заказы g
WHERE g.Цена_продажи >= 100;