-- DISABLE TRIGGER ALL ON DATABASE;


DECLARE @hdoc INT;
DECLARE @xmlData NVARCHAR(MAX) = 
N'<товары>
    <товар Наименование="Тест1" Цена="10" Количество="5"/>
    <товар Наименование="Тест2" Цена="20" Количество="10"/>
    <товар Наименование="Тест3" Цена="30" Количество="15"/>
</товары>';

EXEC sp_xml_preparedocument @hdoc OUTPUT, @xmlData;

INSERT INTO Товары (Наименование, Цена, Количество)
SELECT [Наименование], [Цена], [Количество]
FROM OPENXML(@hdoc, N'/товары/товар', 0)
WITH (
    Наименование NVARCHAR(40) N'@Наименование',
    Цена REAL N'@Цена',
    Количество INT N'@Количество'
);

EXEC sp_xml_removedocument @hdoc;

-- Проверка вставки
SELECT * FROM Товары WHERE Наименование LIKE N'Тест%';
