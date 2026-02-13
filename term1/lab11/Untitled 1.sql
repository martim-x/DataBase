-- Формируем список всех заказанных товаров в одну строку через запятую
DECLARE @товар nvarchar(40), @результат nvarchar(1000) = N'';

DECLARE товары_курсор CURSOR FOR 
SELECT DISTINCT Наименование_товара 
FROM Заказы 
ORDER BY Наименование_товара;

OPEN товары_курсор;
FETCH товары_курсор INTO @товар;

WHILE @@FETCH_STATUS = 0
BEGIN
	set @результат = RTRIM(@товар)+ ' ' + @результат;
-- 	set @результат = LEFT(@товар, 1)+ ' ' + @результат;
    FETCH товары_курсор INTO @товар;
END;
print @результат
CLOSE товары_курсор;
DEALLOCATE товары_курсор;