CREATE PROCEDURE InsertTwoProducts
    @Name1 NVARCHAR(40),
    @Price1 REAL,
    @Qty1 INT,
    @Name2 NVARCHAR(40),
    @Price2 REAL,
    @Qty2 INT
AS
BEGIN
    DECLARE @rc INT = 1;

    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRAN;

            -- первая вставка
            INSERT INTO Товары (Наименование, Цена, Количество)
            VALUES (@Name1, @Price1, @Qty1);

            -- вложенная транзакция для второй вставки
            BEGIN TRAN;
                INSERT INTO Товары (Наименование, Цена, Количество)
                VALUES (@Name2, @Price2, @Qty2);
            COMMIT TRAN;

        COMMIT TRAN;
        RETURN 1;
    END TRY
    BEGIN CATCH
        PRINT 'Номер ошибки: ' + CAST(ERROR_NUMBER() AS NVARCHAR(6));
        PRINT 'Сообщение: ' + ERROR_MESSAGE();
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        RETURN -1;
    END CATCH
END;
GO


DECLARE @InsertTwoStatus INT;
EXEC @InsertTwoStatus = InsertTwoProducts 
    @Name1 = N'Товар 1', @Price1 = 50, @Qty1 = 5, 
    @Name2 = N'Товар 2', @Price2 = 75, @Qty2 = 3;