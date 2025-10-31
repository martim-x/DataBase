SELECT g.Наименование_товара
FROM Заказы g
WHERE g.Цена_продажи <= 55
INTERSECT
SELECT g.Наименование_товара
FROM Заказы g
WHERE g.Цена_продажи >= 55;