CREATE TABLE FACULTY
(
    FACULTY      VARCHAR2(100)      NOT NULL,
    FACULTY_NAME VARCHAR2(100),
    CONSTRAINT PK_FACULTY PRIMARY KEY (FACULTY)
);

SELECT * FROM pulpit;
CREATE TABLE PULPIT
(
    PULPIT      VARCHAR2(100)      NOT NULL,
    PULPIT_NAME VARCHAR2(200),
    FACULTY     VARCHAR2(100)      NOT NULL,
    CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY (FACULTY)
        REFERENCES FACULTY (FACULTY),
    CONSTRAINT PK_PULPIT PRIMARY KEY (PULPIT)
);

CREATE TABLE TEACHER
(
    TEACHER      VARCHAR2(100)      NOT NULL,
    TEACHER_NAME VARCHAR2(100),
    PULPIT       VARCHAR2(100)      NOT NULL,
    CONSTRAINT PK_TEACHER PRIMARY KEY (TEACHER),
    CONSTRAINT FK_TEACHER_PULPIT FOREIGN KEY (PULPIT)
        REFERENCES PULPIT (PULPIT)
);

CREATE TABLE SUBJECT
(
    SUBJECT      VARCHAR2(100)      NOT NULL,
    SUBJECT_NAME VARCHAR2(100) 	NOT NULL,
    PULPIT       VARCHAR2(100)      NOT NULL,
    CONSTRAINT PK_SUBJECT PRIMARY KEY (SUBJECT),
    CONSTRAINT FK_SUBJECT_PULPIT FOREIGN KEY (PULPIT)
        REFERENCES PULPIT (PULPIT)
);

CREATE TABLE AUDITORIUM_TYPE
(
    AUDITORIUM_TYPE     VARCHAR2(100)
        CONSTRAINT AUDITORIUM_TYPE_PK PRIMARY KEY,
    AUDITORIUM_TYPENAME VARCHAR2(100)
        CONSTRAINT AUDITORIUM_TYPENAME_NOT_NULL NOT NULL
);

CREATE TABLE AUDITORIUM
(
    AUDITORIUM          VARCHAR2(100) PRIMARY KEY,
    AUDITORIUM_NAME     VARCHAR2(200),       
    AUDITORIUM_CAPACITY NUMBER(5),            
    AUDITORIUM_TYPE     VARCHAR2(100) NOT NULL
        REFERENCES AUDITORIUM_TYPE (AUDITORIUM_TYPE)
);

--	SQLCODE — числовой код ошибки
--	SQLERRM — текст сообщения
--	
--	SQL%ROWCOUNT — сколько строк затронуто
--	SQL%FOUND / SQL%NOTFOUND — были ли строки
--	SQL%ISOPEN — для неявного курсора всегда FALSE

--	%TYPE — тип переменной = типу столбца
--	%ROWTYPE — запись (record) = всей строке таблицы/курсора




DECLARE
	v_faculty_name faculty.faculty_name%TYPE;
BEGIN
	SELECT faculty_name
	INTO v_faculty_name
	FROM faculty 
	WHERE faculty LIKE '%Х%';

	dbms_output.put_line('Имя факультета: '|| v_faculty_name);
	EXCEPTION
		WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
			dbms_output.put_line('Ошибка: ' || SQLCODE ||'; ' ||SQLERRM);
		
END;





--	Неявные курсоры
--	1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой.
DECLARE
    v_faculty_name FACULTY.FACULTY_NAME%TYPE;
BEGIN
    SELECT FACULTY_NAME
    INTO   v_faculty_name
    FROM   FACULTY
    WHERE  FACULTY = 'ЛХФ';   -- код существующего факультета

    DBMS_OUTPUT.PUT_LINE('Название факультета: ' || v_faculty_name);
END;


--	2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной
--	выборкой. Используйте конструкцию WHEN OTHERS секции исключений и встроенную
--	функции SQLERRM, SQLCODE для диагностирования неточной выборки.
DECLARE
    v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
    SELECT TEACHER_NAME
    INTO   v_teacher_name
    FROM   TEACHER
    WHERE  PULPIT = 'ИСиТ';  -- может быть много / 0

    DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Нет преподавателей на кафедре ISIT');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Слишком много преподавателей на кафедре ISIT');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Другая ошибка: ' || SQLCODE || ' - ' || SQLERRM);
END;

SELECT * from subject;

--	3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS
--	секции исключений для диагностирования неточной выборки.
DECLARE
    v_subject_code SUBJECT.SUBJECT%TYPE;
BEGIN
    SELECT SUBJECT
    INTO   v_subject_code
    FROM   SUBJECT
    WHERE  PULPIT = 'ИСиТ';  -- может быть несколько
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS: найдено больше одной дисциплины "Математика"');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' - ' || SQLERRM);
END;


--	4. Разработайте АБ, демонстрирующий возникновение и обработку исключения
--	NO_DATA_FOUND. Разработайте АБ, демонстрирующий применение атрибутов
--	неявного курсора.
DECLARE
    v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
    SELECT TEACHER_NAME
    INTO   v_teacher_name
    FROM   TEACHER
    WHERE  TEACHER = 'NO_SUCH_TEACHER';

    DBMS_OUTPUT.PUT_LINE('Преподаватель: ' || v_teacher_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Исключение NO_DATA_FOUND: преподаватель не найден');
END;


BEGIN
    UPDATE AUDITORIUM
    SET    AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY + 5
    WHERE  AUDITORIUM_TYPE = 'LEC';

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Обновлено строк: ' || SQL%ROWCOUNT);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ни одна аудитория не обновлена');
    END IF;

    DBMS_OUTPUT.PUT_LINE('SQL%ISOPEN = ' ||
        CASE WHEN SQL%ISOPEN THEN 'TRUE' ELSE 'FALSE' END);
END;


--	5. Разработайте АБ, демонстрирующий применение операторов INSERT, UPDATE,
--	DELETE, вызывающие нарушение целостности в базе данных. Обработайте исключения.
BEGIN
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    VALUES('T_BAD', 'Неверный препод', 'NO_SUCH_PULPIT');  -- нет такой кафедры

    DBMS_OUTPUT.PUT_LINE('Преподаватель вставлен');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при INSERT TEACHER: ' ||
                             SQLCODE || ' - ' || SQLERRM);
END;



BEGIN
    UPDATE TEACHER
    SET    PULPIT = 'NO_SUCH_PULPIT'   
    WHERE  ROWNUM = 1;                

    DBMS_OUTPUT.PUT_LINE('Преподаватель обновлён');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при UPDATE TEACHER: ' ||
                             SQLCODE || ' - ' || SQLERRM);
END;


BEGIN
  
    DELETE FROM FACULTY
    WHERE  FACULTY = 'ЛХФ'; 

    DBMS_OUTPUT.PUT_LINE('Факультет удалён');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при DELETE FACULTY: ' ||
                             SQLCODE || ' - ' || SQLERRM);
END;


--	Явные курсоры
--	6. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением явного
--	курсора LOOP-цикла. Считанные данные должны быть записаны в переменные,
--	объявленные с применением опции %TYPE.
DECLARE
    CURSOR c_teacher IS
        SELECT TEACHER, TEACHER_NAME, PULPIT
        FROM   TEACHER;

    v_teacher      TEACHER.TEACHER%TYPE;
    v_teacher_name TEACHER.TEACHER_NAME%TYPE;
    v_pulpit       TEACHER.PULPIT%TYPE;
BEGIN
    OPEN c_teacher;
    LOOP
        FETCH c_teacher INTO v_teacher, v_teacher_name, v_pulpit;
        EXIT WHEN c_teacher%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'TEACHER=' || v_teacher ||
            ', NAME=' || v_teacher_name ||
            ', PULPIT=' || v_pulpit
        );
    END LOOP;
    CLOSE c_teacher;
END;


--	7. Создайте АБ, распечатывающий таблицу SUBJECT с применением явного курсора
--	иWHILE-цикла. Считанные данные должны быть записаны в запись (RECORD),
--	объявленную с применением опции %ROWTYPE.
DECLARE
    CURSOR c_subject IS
        SELECT *
        FROM   SUBJECT;

    v_subj_rec SUBJECT%ROWTYPE;
BEGIN
    OPEN c_subject;

    FETCH c_subject INTO v_subj_rec;
    WHILE c_subject%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(
            'SUBJECT=' || v_subj_rec.SUBJECT ||
            ', NAME=' || v_subj_rec.SUBJECT_NAME ||
            ', PULPIT=' || v_subj_rec.PULPIT
        );

        FETCH c_subject INTO v_subj_rec;
    END LOOP;

    CLOSE c_subject;
END;


--	8. Создайте АБ, распечатывающий следующие списки аудиторий: все аудитории (таблица
--	AUDITORIUM) с вместимостью меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше.
--	Примените курсор с параметрами и три способа организации цикла по строкам курсора.
DECLARE
    CURSOR c_aud(p_min NUMBER, p_max NUMBER) IS
        SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY
        FROM   AUDITORIUM
        WHERE  AUDITORIUM_CAPACITY BETWEEN p_min AND p_max
        ORDER  BY AUDITORIUM_CAPACITY;

    v_aud_code    AUDITORIUM.AUDITORIUM%TYPE;
    v_aud_name    AUDITORIUM.AUDITORIUM_NAME%TYPE;
    v_capacity    AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

    v_rec AUDITORIUM%ROWTYPE;
BEGIN
    -- 1) LOOP: вместимость < 20
    DBMS_OUTPUT.PUT_LINE('Аудитории с вместимостью < 20:');

    OPEN c_aud(0, 19);
    LOOP
        FETCH c_aud INTO v_aud_code, v_aud_name, v_capacity;
        EXIT WHEN c_aud%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_aud_code || ' ' || v_capacity);
    END LOOP;
    CLOSE c_aud;

    -- 2) WHILE: 21–30
    DBMS_OUTPUT.PUT_LINE('Аудитории 21–30 мест:');

    OPEN c_aud(21, 30);
    FETCH c_aud INTO v_aud_code, v_aud_name, v_capacity;
    WHILE c_aud%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(v_aud_code || ' ' || v_capacity);
        FETCH c_aud INTO v_aud_code, v_aud_name, v_capacity;
    END LOOP;
    CLOSE c_aud;

    -- 3) FOR: 31–60, 61–80, 81+
    DBMS_OUTPUT.PUT_LINE('Аудитории 31–60 мест:');
    FOR r IN c_aud(31, 60) LOOP
        DBMS_OUTPUT.PUT_LINE(r.AUDITORIUM || ' ' || r.AUDITORIUM_CAPACITY);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Аудитории 61–80 мест:');
    FOR r IN c_aud(61, 80) LOOP
        DBMS_OUTPUT.PUT_LINE(r.AUDITORIUM || ' ' || r.AUDITORIUM_CAPACITY);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Аудитории 81 и выше:');
    FOR r IN c_aud(81, 10000) LOOP
        DBMS_OUTPUT.PUT_LINE(r.AUDITORIUM || ' ' || r.AUDITORIUM_CAPACITY);
    END LOOP;
END;


--	9. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor.
--	Продемонстрируйте ее применение для курсора c параметрами.
DECLARE
    v_cur SYS_REFCURSOR;
    v_aud AUDITORIUM%ROWTYPE;

    v_min_cap NUMBER := 40;
BEGIN
    OPEN v_cur FOR
        SELECT *
        FROM   AUDITORIUM
        WHERE  AUDITORIUM_CAPACITY >= v_min_cap;

    LOOP
        FETCH v_cur INTO v_aud;
        EXIT WHEN v_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_aud.AUDITORIUM || ' ' ||
            v_aud.AUDITORIUM_CAPACITY
        );
    END LOOP;

    CLOSE v_cur;
END;



--	10. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM)
--	вместимостью от 40 до 80 на 10%. Используйте явный курсор с параметрами, цикл FOR,
--	конструкцию UPDATE CURRENT OF.

DECLARE
    CURSOR c_aud(p_min NUMBER, p_max NUMBER) IS
        SELECT AUDITORIUM, AUDITORIUM_CAPACITY
        FROM   AUDITORIUM
        WHERE  AUDITORIUM_CAPACITY BETWEEN p_min AND p_max
        FOR UPDATE;  -- важный момент: FOR UPDATE нужен для CURRENT OF
BEGIN
    FOR r IN c_aud(40, 80) LOOP
        UPDATE AUDITORIUM
        SET    AUDITORIUM_CAPACITY = ROUND(r.AUDITORIUM_CAPACITY * 0.9)
        WHERE  CURRENT OF c_aud;

        DBMS_OUTPUT.PUT_LINE(
            'Аудитория ' || r.AUDITORIUM ||
            ': ' || r.AUDITORIUM_CAPACITY ||
            ' -> ' || ROUND(r.AUDITORIUM_CAPACITY * 0.9)
        );
    END LOOP;
END;





BEGIN
	dbms_output.put_line(' ');
END;

















