SELECT TOP 3 * FROM Заказы;
PRINT N'Обработано строк: ' + CAST(@@ROWCOUNT AS NVARCHAR);
PRINT N'Версия SQL Server: ' + @@VERSION;
PRINT N'ID процесса: ' + CAST(@@SPID AS NVARCHAR);
PRINT N'Имя сервера: ' + @@SERVERNAME;
PRINT N'Уровень транзакций: ' + CAST(@@TRANCOUNT AS NVARCHAR);
PRINT N'Статус выборки: ' + CAST(@@FETCH_STATUS AS NVARCHAR);
PRINT N'Уровень вложенности: ' + CAST(@@NESTLEVEL AS NVARCHAR);