SELECT
	Наименование,
	Цена
FROM
	Товары
WHERE
	Цена > ANY (
		SELECT
			Цена_продажи
		FROM
			Заказы
	);
	
