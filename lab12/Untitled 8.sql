BEGIN TRAN OuterTran;

BEGIN TRAN InnerTran;

INSERT INTO Товары VALUES (N'Вложенный товар', 10, 50);

SELECT * FROM Товары WHERE Наименование = N'Вложенный товар';

COMMIT TRAN InnerTran; 

ROLLBACK TRAN OuterTran; -- откатывает ВСЁ, включая вложенную транзакцию



SELECT * FROM Товары WHERE Наименование = N'Вложенный товар';


