-- CREATE TABLE #result_test (
--     x float 
-- );

-- DECLARE 
--     @a float = 6.0 * POWER(10, -4),  
--     @b float = 3.0,  
--     @c int = 2,
--     @x float; 

-- WHILE @b <= 4.0
-- BEGIN
--     SET @c = 2; 
    
  
--     WHILE @c <= 8
--     BEGIN 
--         IF @c >= 5
--         BEGIN
--             SET @x = POWER(@a, 2) + POWER((@b + 4), 1.0/@c); 
--         END
--         ELSE 
--         BEGIN
--             SET @x = ABS(@a - @c) / LOG(@b) / LOG(2); 
--         END
        
--         INSERT INTO #result_test (x)
--         VALUES (@x);  
        
--         SET @c = @c + 1; 
--     END
    
--     SET @b = @b + 0.2;  
-- END

-- SELECT * FROM #result_test;



DECLARE 
    @a INT = 2,
    @b INT = 3,
    @x FLOAT,
    @y FLOAT,
    @t FLOAT = 1.5, 
    @z FLOAT;

SET @x = TAN(@a * @a + 1);

IF 3 * @x < @a * @b
    SET @y = 7 * @a + @x;
ELSE
    SET @y = COS(@a);

IF @t > @x
    SET @z = POWER(SIN(@t), 2);
ELSE IF @t < @x
    SET @z = 4 * (@t + @x);
ELSE
    SET @z = 1 - EXP(@x - 2);

SELECT 
    @a AS a,
    @b AS b, 
    @t AS t,
    @x AS x,
    @y AS y,
    @z AS z;