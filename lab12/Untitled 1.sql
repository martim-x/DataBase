
-- drop table tempNum;
DECLARE @c INT,
        @flag CHAR(1) = 'r';

-- Включаем режим неявной транзакции
SET IMPLICIT_TRANSACTIONS ON;

-- Создаем таблицу и добавляем данные
CREATE TABLE tempNum(num INT);
INSERT INTO tempNum VALUES (1), (2), (3);

-- Считаем количество строк
SET @c = (SELECT COUNT(*) FROM tempNum);

-- Выводим в консоль
PRINT N'Количество строк в таблице tempNum: ' + CAST(@c AS VARCHAR(2));

-- Завершаем транзакцию по условию
IF @flag = 'c'
    COMMIT;
ELSE
    ROLLBACK;

-- Выключаем режим неявной транзакции
SET IMPLICIT_TRANSACTIONS OFF;
