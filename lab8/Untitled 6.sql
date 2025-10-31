ALTER VIEW [dbo].[Заказы с ценой продажи выше средней]
WITH SCHEMABINDING
AS
SELECT 
    z.Заказчик,
    COUNT(*) AS Количество_заказов
FROM dbo.Заказы AS z
GROUP BY z.Заказчик;