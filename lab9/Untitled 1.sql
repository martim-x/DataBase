DECLARE 
    @char_var CHAR(10) = N'Test',
    @varchar_var VARCHAR(20) = N'Variable',
    @date_var DATE = GETDATE(),
    @time_var TIME = CAST(GETDATE() AS TIME),
    @int_var INT,
    @smallint_var SMALLINT,
    @tinyint_var TINYINT,
    @numeric_var NUMERIC(12,5);

SET @int_var = 100;
SELECT @smallint_var = 50, @tinyint_var = 10, @numeric_var = 12345.67890;

SELECT 
    @char_var AS CharVar,
    @varchar_var AS VarcharVar,
    @date_var AS DateVar,
    @time_var AS TimeVar;

PRINT N'Int: ' + CAST(@int_var AS VARCHAR);
PRINT N'SmallInt: ' + CAST(@smallint_var AS VARCHAR);
PRINT N'TinyInt: ' + CAST(@tinyint_var AS VARCHAR);
PRINT N'Numeric: ' + CAST(@numeric_var AS VARCHAR);