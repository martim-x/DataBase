SELECT 
    CASE 
        WHEN Цена_продажи < 50 THEN N'цена < 50'
        WHEN Цена_продажи BETWEEN 50 AND 100 THEN N'цена от 50 до 100'
        ELSE N'цена > 100'
    END AS [Пределы цен],
    COUNT(*) AS [Количество сделанных заказов]
FROM Заказы
GROUP BY 
    CASE 
        WHEN Цена_продажи < 50 THEN N'цена < 50'
        WHEN Цена_продажи BETWEEN 50 AND 100 THEN N'цена от 50 до 100'
        ELSE N'цена > 100'
    END
ORDER BY --CASE [Цена продажи]
    MIN(Цена_продажи);
-- 	        WHEN N'цена < 50' then 1
-- 	        WHEN N'цена от 50 до 100' then 2
-- 	        when N'цена > 100' then 3
-- 			else then 0
-- 	    END