-- Демонстрация локального курсора (виден только в текущем пакете)
-- PRINT N'=== ЛОКАЛЬНЫЙ КУРСОР ===';
-- 
-- DECLARE локальный_курсор CURSOR LOCAL FOR 
-- SELECT TOP 3 Наименование, Цена FROM Товары;
-- 
-- OPEN локальный_курсор;
-- DECLARE @название nvarchar(40), @цена real;
-- FETCH локальный_курсор INTO @название, @цена;
-- 
-- WHILE @@FETCH_STATUS = 0
-- BEGIN
--     PRINT N'Локальный: ' + @название + ' - ' + CAST(@цена AS nvarchar(10));
--     FETCH локальный_курсор INTO @название, @цена;
-- END;
-- 
-- CLOSE локальный_курсор;
-- -- DEALLOCATE локальный_курсор;
-- GO
-- 
-- 
-- OPEN локальный_курсор;
-- DECLARE @название nvarchar(40), @цена real;
-- FETCH локальный_курсор INTO @название, @цена;
-- 
-- WHILE @@FETCH_STATUS = 0
-- BEGIN
--     PRINT N'Локальный: ' + @название + ' - ' + CAST(@цена AS nvarchar(10));
--     FETCH локальный_курсор INTO @название, @цена;
-- END;
-- CLOSE локальный_курсор;
-- go

-- Попытка использовать локальный курсор в новом пакете вызовет ошибку

-- if глобальный_курсор == -3
-- DEALLOCATE глобальный_курсор;
-- PRINT N'=== ГЛОБАЛЬНЫЙ КУРСОР ===';
-- 
DECLARE глобальный_курсор CURSOR GLOBAL FOR 
SELECT TOP 3 Наименование_фирмы, Адрес FROM Заказчики;

OPEN глобальный_курсор;
DECLARE @фирма nvarchar(40), @адрес nvarchar(100);
FETCH глобальный_курсор INTO @фирма, @адрес;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Глобальный: ' + @фирма + ' - ' + ISNULL(@адрес, 'нет адреса');
    FETCH глобальный_курсор INTO @фирма, @адрес;
END;

CLOSE глобальный_курсор;



go
OPEN глобальный_курсор;
DECLARE @фирма nvarchar(40), @адрес nvarchar(100);
FETCH глобальный_курсор INTO @фирма, @адрес;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'Глобальный: ' + @фирма + ' - ' + ISNULL(@адрес, 'нет адреса');
    FETCH глобальный_курсор INTO @фирма, @адрес;
END;

CLOSE глобальный_курсор;



