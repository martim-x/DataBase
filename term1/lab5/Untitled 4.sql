SELECT
	Наименование_товара,
	Количество,
	Цена_продажи
FROM
	Заказы AS Z1
WHERE
	Количество = (
		SELECT
			TOP 1 Z2.Количество
		FROM
			Заказы AS Z2
		WHERE
			Z2.Наименование_товара = Z1.Наименование_товара
		ORDER BY
			Z2.Количество DESC
	)
ORDER BY
	Количество DESC;