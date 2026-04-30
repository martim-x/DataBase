CREATE TABLE FACULTY
(
    FACULTY      VARCHAR2(100)      NOT NULL,
    FACULTY_NAME VARCHAR2(100),
    CONSTRAINT PK_FACULTY PRIMARY KEY (FACULTY)
);

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


DELETE FROM FACULTY;

INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ИДиП',  'Издателькое дело и полиграфия');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ХТиТ',  'Химическая технология и техника');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ЛХФ',   'Лесохозяйственный факультет');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ИЭФ',   'Инженерно-экономический факультет');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ТТЛП',  'Технология и техника лесной промышленности');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ТОВ',   'Технология органических веществ');


INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ИСиТ',   'Иформационный систем и технологий ',                          'ИДиП');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ПОиСОИ','Полиграфического оборудования и систем обработки информации ','ИДиП');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЛВ',    'Лесоводства',                                                  'ЛХФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ОВ',    'Охотоведения',                                                 'ЛХФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЛУ',    'Лесоустройства',                                               'ЛХФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЛЗиДВ', 'Лесозащиты и древесиноведения',                                'ЛХФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЛПиСПС','Ландшафтного проектирования и садово-паркового строительства', 'ЛХФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ТЛ',    'Транспорта леса',                                              'ТТЛП');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЛМиЛЗ', 'Лесных машин и технологии лесозаготовок',                      'ТТЛП');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ОХ',    'Органической химии',                                           'ТОВ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ТНХСиППМ','Технологии нефтехимического синтеза и переработки полимерных материалов','ТОВ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ТНВиОХТ','Технологии неорганических веществ и общей химической технологии','ХТиТ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ХТЭПиМЭЕ','Химии, технологии электрохимических производств и материалов электронной техники','ХТиТ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('ЭТиМ',  'экономической теории и маркетинга',                           'ИЭФ');
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('МиЭП',  'Менеджмента и экономики природопользования',                  'ИЭФ');


DELETE FROM TEACHER;

INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('СМЛВ',    'Смелов Владимир Владиславович',             'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('АКНВЧ',   'Акунович Станислав Иванович',               'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('КЛСНВ',   'Колесников Леонид Валерьевич',              'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ГРМН',    'Герман Олег Витольдович',                    'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЛЩНК',    'Лащенко Анатолий Пвалович',                 'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('БРКВЧ',   'Бракович Андрей Игорьевич',                  'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ДДК',     'Дедко Александр Аркадьевич',                 'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('КБЛ',     'Кабайло Александр Серафимович',              'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('УРБ',     'Урбанович Павел Павлович',                    'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('РМНК',    'Романенко Дмитрий Михайлович',               'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ПСТВЛВ',  'Пустовалова Наталия Николаевна',             'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('?',       'Неизвестный',                                'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ГРН',     'Гурин Николай Иванович',                      'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЖЛК',     'Жиляк Надежда Александровна',                'ИСиТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('БРТШВЧ',  'Барташевич Святослав Александрович',         'ПОиСОИ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЮДНКВ',   'Юденков Виктор Степанович',                  'ПОиСОИ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('БРНВСК',  'Барановский Станислав Иванович',             'ЭТиМ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('НВРВ',    'Неверов Александр Васильевич',               'МиЭП');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('РВКЧ',    'Ровкач Андрей Иванович',                     'ОВ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ДМДК',    'Демидко Марина Николаевна',                  'ЛПиСПС');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('МШКВСК',  'Машковский Владимир Петрович',               'ЛУ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЛБХ',     'Лабоха Константин Валентинович',             'ЛВ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЗВГЦВ',   'Звягинцев Вячеслав Борисович',               'ЛЗиДВ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('БЗБРДВ',  'Безбородов Владимир Степанович',             'ОХ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ПРКПЧК',  'Прокопчук Николай Романович',                'ТНХСиППМ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('НСКВЦ',   'Насковец Михаил Трофимович',                 'ТЛ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('МХВ',     'Мохов Сергей Петрович',                      'ЛМиЛЗ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЕЩНК',    'Ещенко Людмила Семеновна',                   'ТНВиОХТ');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('ЖРСК',    'Жарский Иван Михайлович',                    'ХТЭПиМЭЕ');


DELETE FROM SUBJECT;

INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('СУБД',   'Системы управления базами данных',                    'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('БД',     'Базы данных',                                         'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ИНФ',    'Информацтонные технологии',                           'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ОАиП',   'Основы алгоритмизации и программирования',            'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ПЗ',     'Представление знаний в компьютерных системах',        'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ПСП',    'Пограммирование сетевых приложений',                  'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('МСОИ',   'Моделирование систем обработки информации',           'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ПИС',    'Проектирование информационных систем',                'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('КГ',     'Компьютерная геометрия ',                             'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ПМАПЛ',  'Полиграфические машины, автоматы и поточные линии',   'ПОиСОИ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('КМС',    'Компьютерные мультимедийные системы',                 'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ОПП',    'Организация полиграфического производства',           'ПОиСОИ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ДМ',     'Дискретная матеатика',                                'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('МП',     'Математисеское программирование',                     'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ЛЭВМ',   'Логические основы ЭВМ',                               'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ООП',    'Объектно-ориентированное программирование',           'ИСиТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ЭП',     'Экономика природопользования',                        'МиЭП');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ЭТ',     'Экономическая теория',                                'ЭТиМ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('БЛЗиПсOO','Биология лесных зверей и птиц с осн. охотов.',      'ОВ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ОСПиЛПХ','Основы садовопаркового и лесопаркового хозяйства',   'ЛПиСПС');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ИГ',     'Инженерная геодезия ',                                'ЛУ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ЛВ',     'Лесоводство',                                         'ЛЗиДВ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ОХ',     'Органическая химия',                                  'ОХ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ТРИ',    'Технология резиновых изделий',                        'ТНХСиППМ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ВТЛ',    'Водный транспорт леса',                               'ТЛ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ТиОЛ',   'Технология и оборудование лесозаготовок',             'ЛМиЛЗ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ТОПИ',   'Технология обогащения полезных ископаемых ',          'ТНВиОХТ');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('ПЭХ',    'Прикладная электрохимия',                             'ХТЭПиМЭЕ');


DELETE FROM AUDITORIUM_TYPE;

INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('ЛК',    'Лекционная');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('ЛБ-К',  'Компьютерный класс');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('ЛК-К',  'Лекционная с уст. компьютерами');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('ЛБ-X',  'Химическая лаборатория');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('ЛБ-СК', 'Спец. компьютерный класс');

DELETE FROM AUDITORIUM;

INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('206-1', '206-1', 'ЛБ-К', 15);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('301-1', '301-1', 'ЛБ-К', 15);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('236-1', '236-1', 'ЛК',   60);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('313-1', '313-1', 'ЛК',   60);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('324-1', '324-1', 'ЛК',   50);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('413-1', '413-1', 'ЛБ-К', 15);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('423-1', '423-1', 'ЛБ-К', 90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('408-2', '408-2', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('103-4', '103-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('105-4', '105-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('107-4', '107-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('110-4', '110-4', 'ЛК',   30);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('111-4', '111-4', 'ЛК',   30);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('114-4', '114-4', 'ЛК-К', 90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('132-4', '132-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('02Б-4', '02Б-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('229-4', '229-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('304-4', '304-4', 'ЛБ-К', 90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('314-4', '314-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('320-4', '320-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('429-4', '429-4', 'ЛК',   90);
INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
VALUES ('?',     '???',   'ЛК',   90);

DROP TABLE AUDITORIUM_TYPE;
DROP TABLE FACULTY;
DROP TABLE PULPIT;
DROP TABLE TEACHER;
DROP TABLE SUBJECT;
DROP TABLE AUDITORIUM;


SELECT * FROM AUDITORIUM_TYPE;
SELECT * FROM FACULTY;
SELECT * FROM PULPIT;
SELECT * FROM TEACHER;
SELECT * FROM SUBJECT;
SELECT * FROM AUDITORIUM;


--	1. Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов.
BEGIN
    NULL;
END;


--	2. Разработайте АБ, выводящий «Hello World!».
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World!');
END;


--	3. Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
BEGIN
    DBMS_OUTPUT.PUT_LINE('Спецсимволы и разделители PL/SQL:');
    DBMS_OUTPUT.PUT_LINE('() [] {} ; , . : '' "');
    DBMS_OUTPUT.PUT_LINE('+ - * / = <> <= >= != ||');
END;


--	4. Разработайте скрипт, позволяющий просмотреть все ключевые слова PL/SQL.
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ключевые слова PL/SQL:');
    DBMS_OUTPUT.PUT_LINE('DECLARE, BEGIN, END, EXCEPTION');
    DBMS_OUTPUT.PUT_LINE('IF, THEN, ELSIF, ELSE');
    DBMS_OUTPUT.PUT_LINE('CASE, WHEN, LOOP, WHILE, FOR, EXIT');
    DBMS_OUTPUT.PUT_LINE('FUNCTION, PROCEDURE, RETURN');
    DBMS_OUTPUT.PUT_LINE('CURSOR, OPEN, FETCH, CLOSE');
END;


--	5. Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
DECLARE
--  объявление и инициализацию целых number-переменных;
	v_int1 NUMBER := 17;
    v_int2 NUMBER := 5;

    v_sum NUMBER;
    v_sub NUMBER;
    v_mul NUMBER;
    v_div NUMBER;
    v_mod NUMBER;
--	объявление и инициализацию number-переменных с фиксированной точкой;
    v_num_fixed NUMBER(8,2) := 123.45;
    v_num_fixed2 NUMBER(8,2) := 67.89;
--	объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
    v_num_round1 NUMBER(6,-1) := 123.45;
    v_num_round2 NUMBER(6,-2) := 987.65;
--	объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
    v_exp1 NUMBER := 1.25E3;
    v_exp2 NUMBER := 9.1E-2;
--	объявление и инициализацию переменных типа даты;
    v_date1 DATE := SYSDATE;
    v_date2 DATE := TO_DATE('2026-01-01', 'YYYY-MM-DD');
--	объявление и инициализацию символьных переменных различной семантики;
    v_char CHAR(10) := 'ABC';
    v_varchar VARCHAR2(50) := 'Oracle PL/SQL';
    v_nchar NCHAR(10) := N'Тест';
    v_nvarchar NVARCHAR2(50) := N'Привет Oracle';
--	объявление и инициализацию BOOLEAN-переменных.
    v_bool1 BOOLEAN := TRUE;
    v_bool2 BOOLEAN := FALSE;
BEGIN
--  арифметические действия над двумя целыми number-переменных, включая деление с остатком;
    v_sum := v_int1 + v_int2;
    v_sub := v_int1 - v_int2;
    v_mul := v_int1 * v_int2;
    v_div := v_int1 / v_int2;
    v_mod := MOD(v_int1, v_int2);

    DBMS_OUTPUT.PUT_LINE('Целые числа: ' || v_int1 || ', ' || v_int2);
    DBMS_OUTPUT.PUT_LINE('Сумма = ' || v_sum);
    DBMS_OUTPUT.PUT_LINE('Разность = ' || v_sub);
    DBMS_OUTPUT.PUT_LINE('Умножение = ' || v_mul);
    DBMS_OUTPUT.PUT_LINE('Деление = ' || v_div);
    DBMS_OUTPUT.PUT_LINE('Остаток = ' || v_mod);

    DBMS_OUTPUT.PUT_LINE('NUMBER(8,2): ' || v_num_fixed || ', ' || v_num_fixed2);
    DBMS_OUTPUT.PUT_LINE('Отрицательный масштаб: ' || v_num_round1 || ', ' || v_num_round2);

    DBMS_OUTPUT.PUT_LINE('Числа с E: ' || v_exp1 || ', ' || v_exp2);

    DBMS_OUTPUT.PUT_LINE('Дата 1: ' || TO_CHAR(v_date1, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('Дата 2: ' || TO_CHAR(v_date2, 'YYYY-MM-DD'));

    DBMS_OUTPUT.PUT_LINE('CHAR: ' || v_char);
    DBMS_OUTPUT.PUT_LINE('VARCHAR2: ' || v_varchar);
    DBMS_OUTPUT.PUT_LINE('NCHAR: ' || v_nchar);
    DBMS_OUTPUT.PUT_LINE('NVARCHAR2: ' || v_nvarchar);

    IF v_bool1 AND NOT v_bool2 THEN
        DBMS_OUTPUT.PUT_LINE('BOOLEAN работает: TRUE AND NOT FALSE = TRUE');
    END IF;
END;


--	6. Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте возможные операции с константами.
DECLARE
    c_name   CONSTANT VARCHAR2(20) := 'Oracle';
    c_code   CONSTANT CHAR(3) := 'DB1';
    c_num    CONSTANT NUMBER := 100;
    v_result NUMBER;
BEGIN
    v_result := c_num * 2;
    DBMS_OUTPUT.PUT_LINE('Константа VARCHAR2: ' || c_name);
    DBMS_OUTPUT.PUT_LINE('Константа CHAR: ' || c_code);
    DBMS_OUTPUT.PUT_LINE('Константа NUMBER * 2 = ' || v_result);
END;


--	7. Разработайте АБ, содержащий объявления переменной с опцией %TYPE. Продемонстрируйте действие опции.
DECLARE
    v_faculty_name FACULTY.FACULTY_NAME%TYPE;
    v_faculty_code FACULTY.FACULTY%TYPE;
BEGIN
    SELECT FACULTY_NAME, FACULTY
    INTO v_faculty_name, v_faculty_code
    FROM FACULTY
    WHERE FACULTY = 'FIT';

    DBMS_OUTPUT.PUT_LINE('FACULTY code = ' || v_faculty_code);
    DBMS_OUTPUT.PUT_LINE('FACULTY name = ' || v_faculty_name);
END;


--	8. Разработайте АБ, содержащий объявления переменной с опцией %ROWTYPE. Продемонстрируйте действие опции.
DECLARE
    v_teacher_row TEACHER%ROWTYPE;
BEGIN
    SELECT *
    INTO v_teacher_row
    FROM TEACHER
    WHERE TEACHER = 'TCH001';

    DBMS_OUTPUT.PUT_LINE('Teacher ID = ' || v_teacher_row.TEACHER_ID);
    DBMS_OUTPUT.PUT_LINE('Teacher code = ' || v_teacher_row.TEACHER);
    DBMS_OUTPUT.PUT_LINE('Teacher name = ' || v_teacher_row.TEACHER_NAME);
    DBMS_OUTPUT.PUT_LINE('Pulpit ID = ' || v_teacher_row.PULPIT_ID);
END;
			

--	9. Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
DECLARE
    v_capacity NUMBER := 30;
BEGIN
    IF v_capacity > 50 THEN
        DBMS_OUTPUT.PUT_LINE('IF: большая аудитория');
    END IF;

    IF v_capacity >= 30 THEN
        DBMS_OUTPUT.PUT_LINE('IF ELSE: вместимость >= 30');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IF ELSE: вместимость < 30');
    END IF;

    IF v_capacity < 20 THEN
        DBMS_OUTPUT.PUT_LINE('Малая аудитория');
    ELSIF v_capacity BETWEEN 20 AND 50 THEN
        DBMS_OUTPUT.PUT_LINE('Средняя аудитория');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Большая аудитория');
    END IF;
END;


--	10. Разработайте АБ, демонстрирующий работу оператора CASE.
DECLARE
    v_type_code VARCHAR2(10) := 'LAB';
BEGIN
    CASE v_type_code
        WHEN 'LEC'  THEN DBMS_OUTPUT.PUT_LINE('Лекционная аудитория');
        WHEN 'LAB'  THEN DBMS_OUTPUT.PUT_LINE('Лаборатория');
        WHEN 'COMP' THEN DBMS_OUTPUT.PUT_LINE('Компьютерный класс');
        ELSE DBMS_OUTPUT.PUT_LINE('Другой тип');
    END CASE;
END;


--	11. Разработайте АБ, демонстрирующий работу оператора LOOP.
DECLARE
    i NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('LOOP i=' || i);
        i := i + 1;
        EXIT WHEN i > 5;
    END LOOP;
END;


--	12. Разработайте АБ, демонстрирующий работу оператора WHILE.
DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE('WHILE i=' || i);
        i := i + 1;
    END LOOP;
END;


--	13. Разработайте АБ, демонстрирующий работу оператора FOR.
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR i=' || i);
    END LOOP;

    FOR i IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR REVERSE i=' || i);
    END LOOP;
END;


SET serveroutput ON;
























































