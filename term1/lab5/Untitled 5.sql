SELECT
	Наименование_фирмы
FROM
	Заказчики AS C
WHERE
	NOT EXISTS (
		SELECT
			*
		FROM
			Заказы AS Z
		WHERE
			Z.Заказчик = C.Наименование_фирмы
	);