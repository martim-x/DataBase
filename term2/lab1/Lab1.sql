--task 10

CREATE TABLE ExtendedUser(
    id NUMBER(3) GENERATED ALWAYS AS IDENTITY ( START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name VARCHAR2(50)
);
COMMIT;

--task 11-12
INSERT
	INTO
	ExtendedUser(name)
VALUES ('Tim');

COMMIT;

INSERT
	INTO
	ExtendedUser(name)
VALUES ('Tom');

COMMIT ;

INSERT
	INTO
	ExtendedUser(name)
VALUES ('Bob');

COMMIT;

SELECT
	*
FROM
	ExtendedUser;
COMMIT;

--task 13
UPDATE ExtendedUser SET name='NEW NAME' WHERE name='Tim';
COMMIT;

--task 14
SELECT
	name,
	count(*) AS reps
FROM
	EXTENDEDUSER e
GROUP BY
	name
HAVING
	count(*) > 2

--task 15
DELETE
FROM
	EXTENDEDUSER
WHERE
	name = 'Tim';
ROLLBACK;


-- task 16
CREATE TABLE SearchHistory(
    history_id NUMBER(5) GENERATED ALWAYS AS IDENTITY ( START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    user_id NUMBER(3),
    search_text VARCHAR2(100),
    search_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_user FOREIGN KEY (user_id)
        REFERENCES ExtendedUser(id)
);

COMMIT;


INSERT
	INTO
	SearchHistory( user_id, search_text)
VALUES ( 4,
'Oracle tutorial');

COMMIT;

INSERT
	INTO
	SearchHistory( user_id, search_text)
VALUES ( 3,
'DBeaver setup');

COMMIT;

INSERT
	INTO
	SearchHistory( user_id, search_text)
VALUES ( 2,
'SQL joins examples');

COMMIT;


SELECT * FROM SearchHistory;
COMMIT;

--task 17
SELECT
	e.NAME,
	count(s.HISTORY_ID) AS total_queries
FROM
	EXTENDEDUSER e
JOIN SEARCHHISTORY s ON
	s.USER_ID = e.ID
GROUP BY
	e.name


SELECT
	e.NAME,
	count(s.HISTORY_ID) AS total_queries
FROM
	EXTENDEDUSER e
LEFT JOIN SEARCHHISTORY s ON
	s.USER_ID = e.ID
GROUP BY
	e.name

--task 18
--DROP TABLE system.EXTENDEDUSER 
--DROP TABLE system.SEARCHHISTORY 





