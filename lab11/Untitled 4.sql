-- Демонстрация различных опций FETCH с SCROLL-курсором
PRINT N'=== SCROLL-КУРСОР ===';

DECLARE @номер_строки int, @название nvarchar(40), @заказчик nvarchar(40);
DECLARE scroll_курсор CURSOR LOCAL SCROLL FOR 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Наименование_товара) AS Номер_строки,
    Наименование_товара,
    Заказчик
FROM Заказы 
ORDER BY Наименование_товара;

OPEN scroll_курсор;

-- 1. FIRST - первая строка
FETCH FIRST FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'FIRST: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 2. NEXT - следующая строка
FETCH NEXT FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'NEXT: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 3. PRIOR - предыдущая строка
FETCH PRIOR FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'PRIOR: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 4. LAST - последняя строка
FETCH LAST FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'LAST: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 5. ABSOLUTE 3 - третья строка от начала
FETCH ABSOLUTE 3 FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'ABSOLUTE 3: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 6. ABSOLUTE -2 - вторая строка от конца
FETCH ABSOLUTE -2 FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'ABSOLUTE -2: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 7. RELATIVE 2 - две строки вперед от текущей
FETCH RELATIVE 2 FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'RELATIVE 2: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

-- 8. RELATIVE -1 - одна строка назад от текущей
FETCH RELATIVE -1 FROM scroll_курсор INTO @номер_строки, @название, @заказчик;
PRINT N'RELATIVE -1: Строка ' + CAST(@номер_строки AS nvarchar(3)) + ' - ' + RTRIM(@название) + ' (' + @заказчик + ')';

CLOSE scroll_курсор;
DEALLOCATE scroll_курсор;

PRINT N'=== ВСЕ ОПЦИИ FETCH ПРОДЕМОНСТРИРОВАНЫ ===';