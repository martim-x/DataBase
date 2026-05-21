--	1. Добавьте в таблицу TEACHERS два столбца BIRTHDAY и SALARY, заполните их
--	значениями.
SELECT * FROM teacher;

ALTER TABLE TEACHER ADD (
	birthday DATE,
	salary NUMERIC(10,2)
)

BEGIN
  FOR r IN (
    SELECT ROWID rid
    FROM TEACHER FOR UPDATE
  ) LOOP
    UPDATE TEACHER
    SET BIRTHDAY = DATE '1960-01-01'
                    + TRUNC(DBMS_RANDOM.VALUE(0, 365*35)),
        SALARY   = 1500 + TRUNC(DBMS_RANDOM.VALUE(0, 31)) * 50
    WHERE ROWID = r.rid;
  END LOOP;

  COMMIT;
END;


--	2. Получите список преподавателей в виде Фамилия И.О. для преподавателей, родившихся в
--	понедельник.
SELECT
    REGEXP_SUBSTR(TEACHER_NAME, '^[^ ]+') || ' ' ||
    SUBSTR(REGEXP_SUBSTR(TEACHER_NAME, '[^ ]+', 1, 2), 1, 1) || '.' ||
    SUBSTR(REGEXP_SUBSTR(TEACHER_NAME, '[^ ]+', 1, 3), 1, 1) || '.' AS FIO
FROM TEACHER
WHERE TRIM(TO_CHAR(BIRTHDAY, 'DAY', 'NLS_DATE_LANGUAGE=RUSSIAN')) = 'ПОНЕДЕЛЬНИК';


--	3. Создайте представление, в котором поместите список преподавателей, которые родились
--	в следующем месяце и выведите их даты рождения в формате «DD/MM/YYYY».
CREATE OR REPLACE VIEW V_TEACHERS_NEXT_MONTH AS
SELECT
    TEACHER,
    TEACHER_NAME,
    TO_CHAR(BIRTHDAY, 'DD/MM/YYYY') AS BIRTHDAY_FMT
FROM TEACHER
WHERE EXTRACT(MONTH FROM BIRTHDAY) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 1));

SELECT * FROM V_TEACHERS_NEXT_MONTH;

--	4. Создайте представление, в котором поместите количество преподавателей, которые
--	родились в каждом месяце, название месяца указать словом.
CREATE OR REPLACE VIEW V_TEACHERS_BY_BIRTH_MONTH AS
SELECT
    TO_CHAR(BIRTHDAY, 'FMMonth', 'NLS_DATE_LANGUAGE=RUSSIAN') AS MONTH_NAME,
    COUNT(*) AS TEACHERS_COUNT
FROM TEACHER
GROUP BY EXTRACT(MONTH FROM BIRTHDAY),
         TO_CHAR(BIRTHDAY, 'FMMonth', 'NLS_DATE_LANGUAGE=RUSSIAN')
ORDER BY EXTRACT(MONTH FROM BIRTHDAY);

SELECT * FROM V_TEACHERS_BY_BIRTH_MONTH;


--	5. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей с
--	указанием, сколько лет исполняется.
DECLARE
    CURSOR c_anniversary IS
        SELECT
            TEACHER_NAME,
            EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, 12)) - EXTRACT(YEAR FROM BIRTHDAY) AS AGE_NEXT_YEAR
        FROM TEACHER
        WHERE MOD(EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, 12)) - EXTRACT(YEAR FROM BIRTHDAY), 5) = 0;

BEGIN
    FOR r IN c_anniversary LOOP
        DBMS_OUTPUT.PUT_LINE(r.TEACHER_NAME || ' - ' || r.AGE_NEXT_YEAR);
    END LOOP;
END;


--	6. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до
--	целых, вывести средние итоговые значения для каждого факультета и для всех
--	факультетов в целом.
DECLARE
    CURSOR c_avg IS
        SELECT
            F.FACULTY,
            P.PULPIT,
            FLOOR(AVG(T.SALARY)) AS AVG_SALARY
        FROM TEACHER T
        JOIN PULPIT P ON T.PULPIT = P.PULPIT
        JOIN FACULTY F ON P.FACULTY = F.FACULTY
        GROUP BY ROLLUP(F.FACULTY, P.PULPIT)
        ORDER BY F.FACULTY, P.PULPIT;

BEGIN
    FOR r IN c_avg LOOP
        IF r.FACULTY IS NOT NULL AND r.PULPIT IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Факультет: ' || r.FACULTY ||
                                 ', Кафедра: ' || r.PULPIT ||
                                 ', Средняя ЗП: ' || r.AVG_SALARY);
        ELSIF r.FACULTY IS NOT NULL AND r.PULPIT IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Факультет: ' || r.FACULTY ||
                                 ', ИТОГО по факультету: ' || r.AVG_SALARY);
        ELSE
            DBMS_OUTPUT.PUT_LINE('ИТОГО по всем факультетам: ' || r.AVG_SALARY);
        END IF;
    END LOOP;
END;



--	7. Создать неименованный блок для расчета результата деления двух переменных. Добавить
--	обработку ситуации с делением на 0 через исключение ZERO_DIVIDE. Сгенерировать
--	пользовательскую ошибку при значении делителя 0.
DECLARE
    v_a NUMBER := 10;
    v_b NUMBER := 0;
    v_c NUMBER;
BEGIN
    IF v_b = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Деление на 0 запрещено');
    END IF;

    v_c := v_a / v_b;
    DBMS_OUTPUT.PUT_LINE('Результат = ' || v_c);

EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Возникло ZERO_DIVIDE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
END;


--	8. Создать неименованный блок с командой SELECT…INTO для выбора наименования
--	преподавателя по заданному коду. Добавить обработку исключения NO_DATA_FOUND с
--	выводом информации 'Преподаватель не найден!'. Проверить, что произойдет при
--	переопределении исключения.
DECLARE
    v_teacher_code TEACHER.TEACHER%TYPE := 'СМЛВ';
    v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
    SELECT TEACHER_NAME
    INTO v_teacher_name
    FROM TEACHER
    WHERE TEACHER = v_teacher_code;

    DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Преподаватель не найден');
END;


--	9. Создать основной и вложенный блок. Объявить в них исключения с разными именами,
--	связать с кодом ошибки -20 001 с помощью PRAGMA EXCEPTION_INIT. Сгенерировать
--	исключение во вложенном блоке, обработать его в основном. Проверить ситуацию, когда
--	исключения не связаны с кодом ошибки и имеют одинаковое наименование.
DECLARE
    e_main EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_main, -20001);
BEGIN
    BEGIN
        RAISE_APPLICATION_ERROR(-20001, 'Ошибка из вложенного блока');
    END;

EXCEPTION
    WHEN e_main THEN
        DBMS_OUTPUT.PUT_LINE('Исключение обработано в основном блоке');
END;


--	10. Проверить, генерируются ли исключение NO_DATA_FOUND в команде SELECT…INTO
--	в PL/SQL блоке с использованием групповых функций, например MAX.
DECLARE
    v_max_salary NUMBER;
BEGIN
    SELECT MAX(SALARY)
    INTO v_max_salary
    FROM TEACHER
    WHERE TEACHER = 'СМЛВ';

    IF v_max_salary IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('MAX вернул NULL, исключение NO_DATA_FOUND не возникло');
    ELSE
        DBMS_OUTPUT.PUT_LINE('MAX = ' || v_max_salary);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
END;







