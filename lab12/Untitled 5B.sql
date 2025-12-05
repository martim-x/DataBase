-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

begin tran;
insert into Товары values
(N'Тест2', 21111, 21111);

commit tran;