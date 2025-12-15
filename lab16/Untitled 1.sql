DECLARE @Customer NVARCHAR(40) = N'ТехМаг';
DECLARE @xmlReport NVARCHAR(MAX);

-- Формируем XML PATH
SELECT Наименование_товара AS N'Товар'
FROM Заказы
WHERE Заказчик = @Customer
FOR XML PATH(N'Заказ'), ROOT(N'Заказы'), TYPE
