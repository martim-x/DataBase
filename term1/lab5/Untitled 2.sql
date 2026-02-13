SELECT
	Z.Номер_заказа,
	Z.Наименование_товара,
	Z.Цена_продажи
FROM
	Заказы AS Z
	INNER JOIN (
		SELECT
			Наименование
		FROM
			Товары
		WHERE
			Цена > (
				SELECT
					AVG(Цена)
				FROM
					Товары
			)
	) AS T ON Z.Наименование_товара = T.Наименование;