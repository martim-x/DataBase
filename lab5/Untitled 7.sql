SELECT
	Наименование,
	Цена
FROM
	Товары
WHERE
	Цена >= ALL (
		SELECT
			Цена_продажи
		FROM
			Заказы
	);