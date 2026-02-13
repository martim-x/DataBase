create view [Заказы с ценой продажи выше средней] as
select 
	z.Заказчик,
	z.Цена_продажи,
from Заказы as z
where z.Цена_продажи > (select AVG(zz.Цена_продажи) from Заказы as zz)