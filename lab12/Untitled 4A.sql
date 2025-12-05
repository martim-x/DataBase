-- A
set transaction isolation level READ UNCOMMITTED
begin tran;
select count(*) from Товары

-- commit tran;