--	1. Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

CREATE TABLE EMP (
    EMP_ID      NUMBER         PRIMARY KEY,
    FULL_NAME   VARCHAR2(100)  NOT NULL,
    DEPT_NAME   VARCHAR2(50)   NOT NULL,
    SALARY      NUMBER(10,2)   NOT NULL,
    HIRE_DATE   DATE           NOT NULL,
    IS_ACTIVE   CHAR(1)        DEFAULT 'Y' CHECK (IS_ACTIVE IN ('Y','N')),
    VALID_FROM  DATE           DEFAULT SYSDATE NOT NULL,
    VALID_TO    DATE
);

CREATE TABLE EMP_AUDIT (
    OPERATIONDATE  DATE,
    OPERATIONTYPE  VARCHAR2(20),
    TRIGGERNAME    VARCHAR2(100),
    DATA           VARCHAR2(4000)
);

CREATE OR REPLACE VIEW EMP_V AS
SELECT EMP_ID, FULL_NAME, DEPT_NAME, SALARY, HIRE_DATE, IS_ACTIVE
FROM EMP
WHERE VALID_TO IS NULL;


--	2. Заполните таблицу данными (10 шт.).
INSERT INTO EMP (EMP_ID, FULL_NAME, DEPT_NAME, SALARY, HIRE_DATE, IS_ACTIVE, VALID_FROM, VALID_TO)
VALUES (1, 'Ivan Petrov', 'IT', 2500, DATE '2023-01-10', 'Y', SYSDATE, NULL);

INSERT INTO EMP VALUES (2, 'Anna Sidorova', 'HR',        1800, DATE '2022-05-14', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (3, 'Pavel Smirnov', 'Sales',     2100, DATE '2021-09-01', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (4, 'Elena Kozlova', 'IT',        3200, DATE '2020-11-20', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (5, 'Sergey Orlov',  'Finance',   2800, DATE '2019-07-03', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (6, 'Olga Romanova', 'Marketing', 2300, DATE '2023-03-11', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (7, 'Dmitry Ivanov','IT',        3500, DATE '2018-12-25', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (8, 'Maria Lebedeva','Support',  1700, DATE '2024-02-01', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (9, 'Andrey Morozov','Logistics',1900, DATE '2022-08-18', 'Y', SYSDATE, NULL);
INSERT INTO EMP VALUES (11,'Natalia','HRкккк',      3070, DATE '2021-04-09', 'Y', SYSDATE, NULL);

COMMIT;


--	3. Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE.
--	Этот и все последующие триггеры должны выдавать сообщение на серверную консоль
--	(DMS_OUTPUT) со своим собственным именем.

CREATE OR REPLACE TRIGGER EMP_BS_IUD
BEFORE INSERT OR UPDATE OR DELETE ON EMP
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_BS_IUD (BEFORE STATEMENT)');

    IF INSERTING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'INSERT', 'EMP_BS_IUD', 'BEFORE STATEMENT');
    ELSIF UPDATING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'UPDATE', 'EMP_BS_IUD', 'BEFORE STATEMENT');
    ELSIF DELETING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'DELETE', 'EMP_BS_IUD', 'BEFORE STATEMENT');
    END IF;
END;


--	4. Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
CREATE OR REPLACE TRIGGER EMP_BR_IUD
BEFORE INSERT OR UPDATE OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_BR_IUD (BEFORE ROW)');

    IF INSERTING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'INSERT',
            'EMP_BR_IUD',
            'NEW: EMP_ID=' || :NEW.EMP_ID ||
            ', FULL_NAME=' || :NEW.FULL_NAME ||
            ', DEPT_NAME=' || :NEW.DEPT_NAME ||
            ', SALARY=' || :NEW.SALARY
        );
    ELSIF UPDATING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'UPDATE',
            'EMP_BR_IUD',
            'OLD: EMP_ID=' || :OLD.EMP_ID ||
            ', FULL_NAME=' || :OLD.FULL_NAME ||
            ', SALARY=' || :OLD.SALARY ||
            ' | NEW: EMP_ID=' || :NEW.EMP_ID ||
            ', FULL_NAME=' || :NEW.FULL_NAME ||
            ', SALARY=' || :NEW.SALARY
        );
    ELSIF DELETING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'DELETE',
            'EMP_BR_IUD',
            'OLD: EMP_ID=' || :OLD.EMP_ID ||
            ', FULL_NAME=' || :OLD.FULL_NAME ||
            ', DEPT_NAME=' || :OLD.DEPT_NAME ||
            ', SALARY=' || :OLD.SALARY
        );
    END IF;
END;


--	5. Примените предикаты INSERTING, UPDATING и DELETING.


--	6. Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и
--	UPDATE.
CREATE OR REPLACE TRIGGER EMP_AS_IUD
AFTER INSERT OR UPDATE OR DELETE ON EMP
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_AS_IUD (AFTER STATEMENT)');

    IF INSERTING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'INSERT', 'EMP_AS_IUD', 'AFTER STATEMENT');
    ELSIF UPDATING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'UPDATE', 'EMP_AS_IUD', 'AFTER STATEMENT');
    ELSIF DELETING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (SYSDATE, 'DELETE', 'EMP_AS_IUD', 'AFTER STATEMENT');
    END IF;
END;


--	7. Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
CREATE OR REPLACE TRIGGER EMP_AR_IUD
AFTER INSERT OR UPDATE OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_AR_IUD (AFTER ROW)');

    IF INSERTING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'INSERT',
            'EMP_AR_IUD',
            'NEW: EMP_ID=' || :NEW.EMP_ID ||
            ', FULL_NAME=' || :NEW.FULL_NAME
        );
    ELSIF UPDATING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'UPDATE',
            'EMP_AR_IUD',
            'OLD SALARY=' || :OLD.SALARY ||
            ', NEW SALARY=' || :NEW.SALARY
        );
    ELSIF DELETING THEN
        INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        VALUES (
            SYSDATE,
            'DELETE',
            'EMP_AR_IUD',
            'OLD: EMP_ID=' || :OLD.EMP_ID ||
            ', FULL_NAME=' || :OLD.FULL_NAME
        );
    END IF;
END;


--	8. Создайте таблицу с именем AUDIT. Таблица должна содержать поля: OperationDate,
--	OperationType (операция вставки, обновления и удаления), TriggerName(имя триггера),
--	Data (строка со значениями полей до и после операции).


--	9. Измените все триггеры таким образом, чтобы они регистрировали все операции с
--	исходной таблицей в таблице AUDIT.


--	10. Выполните операцию, нарушающую целостность таблицы по первичному ключу.
--	Выясните, зарегистрировал ли триггер это событие. Объясните результат.
INSERT INTO EMP (EMP_ID, FULL_NAME, DEPT_NAME, SALARY, HIRE_DATE, IS_ACTIVE, VALID_FROM, VALID_TO)
VALUES (1, 'Duplicate Key', 'IT', 9999, DATE '2025-01-01', 'Y', SYSDATE, NULL);


--	11. Удалите (drop) исходную таблицу. Объясните результат. Добавьте триггер, запрещающий
--	удаление исходной таблицы.
DROP TABLE EMP CASCADE CONSTRAINTS;



CREATE OR REPLACE TRIGGER EMP_NO_DROP
BEFORE DROP ON SCHEMA
BEGIN
    IF ORA_DICT_OBJ_TYPE = 'TABLE'
       AND ORA_DICT_OBJ_NAME = 'EMP' THEN
        RAISE_APPLICATION_ERROR(-20001, 'DROP TABLE EMP is forbidden');
    END IF;
END;

DROP TABLE EMP CASCADE CONSTRAINTS;
-- ORA-20001: DROP TABLE EMP is forbidden


--	12. Удалите (drop) таблицу AUDIT. Просмотрите состояние триггеров с помощью SQL-
--	DEVELOPER. Объясните результат. Измените триггеры.
DROP TABLE EMP_AUDIT CASCADE CONSTRAINTS;



CREATE TABLE EMP_AUDIT (
    OPERATIONDATE  DATE,
    OPERATIONTYPE  VARCHAR2(20),
    TRIGGERNAME    VARCHAR2(100),
    DATA           VARCHAR2(4000)
);

ALTER TRIGGER EMP_BS_IUD COMPILE;
ALTER TRIGGER EMP_BR_IUD COMPILE;
ALTER TRIGGER EMP_AS_IUD COMPILE;
ALTER TRIGGER EMP_AR_IUD COMPILE;
ALTER TRIGGER EMP_IOU_V COMPILE;



--	13. Создайте представление над исходной таблицей. Разработайте INSTEAD OF UPDATE-
--	триггер. Триггер должен добавлять новую строку в таблицу, а старую помечать как
--	недействительную.
CREATE OR REPLACE TRIGGER EMP_IOU_V
INSTEAD OF UPDATE ON EMP_V
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_IOU_V (INSTEAD OF UPDATE)');

    -- пометить старую версию
    UPDATE EMP
    SET VALID_TO = SYSDATE,
        IS_ACTIVE = 'N'
    WHERE EMP_ID = :OLD.EMP_ID
      AND VALID_TO IS NULL;

    -- добавить новую версию
    INSERT INTO EMP (
        EMP_ID, FULL_NAME, DEPT_NAME, SALARY,
        HIRE_DATE, IS_ACTIVE, VALID_FROM, VALID_TO
    )
    VALUES (
        :NEW.EMP_ID,
        :NEW.FULL_NAME,
        :NEW.DEPT_NAME,
        :NEW.SALARY,
        :NEW.HIRE_DATE,
        'Y',
        SYSDATE,
        NULL
    );

    INSERT INTO EMP_AUDIT(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
    VALUES (
        SYSDATE,
        'INSTEAD OF UPDATE',
        'EMP_IOU_V',
        'OLD EMP_ID=' || :OLD.EMP_ID || ' -> new version inserted'
    );
END;


UPDATE EMP_V
SET SALARY = 5000,
    FULL_NAME = 'Ivan Petrov Updated'
WHERE EMP_ID = 1;

COMMIT;

SELECT EMP_ID, FULL_NAME, SALARY, IS_ACTIVE, VALID_FROM, VALID_TO
FROM EMP
WHERE EMP_ID = 1
ORDER BY VALID_FROM;


--	14. Продемонстрируйте, в каком порядке выполняются триггеры.
SET SERVEROUTPUT ON;

UPDATE EMP
SET SALARY = SALARY + 50
WHERE EMP_ID IN (2, 3);


--	15. Создайте несколько триггеров одного типа, реагирующих на одно и то же событие, и
--	покажите, в каком порядке они выполняются. Измените порядок выполнения этих
--	триггеров.
CREATE OR REPLACE TRIGGER EMP_ORDER_A
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_ORDER_A');
END;


CREATE OR REPLACE TRIGGER EMP_ORDER_B
AFTER UPDATE ON EMP
FOR EACH ROW
FOLLOWS EMP_ORDER_A
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_ORDER_B');
END;




UPDATE EMP
SET SALARY = SALARY + 10
WHERE EMP_ID = 2;















































CREATE OR REPLACE TRIGGER my_custom_tr AFTER INSERT ON emp
BEGIN
IF inserting THEN
	dbms_output.put_line('trigger is active');
END IF;
END;

INSERT INTO EMP VALUES (55, 'Maria Lebedeva','Support',  1700, DATE '2024-02-01', 'Y', SYSDATE, NULL);








