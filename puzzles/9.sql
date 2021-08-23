CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Restaurant;
DROP VIEW IF EXISTS Lastseat;
DROP VIEW IF EXISTS Firstseat;

CREATE TABLE Restaurant( seat INTEGER );

/*
DROP PROCEDURE IF EXISTS dorepeat;
delimiter //
CREATE PROCEDURE dorepeat(p1 INT)
BEGIN
  SET @x = 0;
  REPEAT
    INSERT INTO Restaurant VALUES(@x);
    SET @x = @x + 1;
  UNTIL @x > p1 END REPEAT;
END
//
CALL dorepeat(1);
*/

\! echo \\n=== show answer ===\\n;
-- SOLUTION 1 --
/*
UPDATE Restaurant
SET seat = -seat
WHERE seat = 5;

SELECT * FROM Restaurant;
*/

-- SOLUTION 2,3 --

CREATE VIEW Firstseat (seat)
AS SELECT (seat + 1)
     FROM Restaurant
    WHERE (seat + 1) NOT IN (SELECT seat FROM Restaurant)
      AND (seat + 1) < 101;

CREATE VIEW Lastseat (seat)
AS SELECT (seat - 1)
     FROM Restaurant
    WHERE (seat - 1) NOT IN (SELECT seat FROM Restaurant)
      AND (seat - 1) > 0;

INSERT INTO Restaurant VALUES (0);
INSERT INTO Restaurant VALUES (5);
INSERT INTO Restaurant VALUES (20);
INSERT INTO Restaurant VALUES (101);

SELECT F1.seat AS start, L1.seat AS finish, ((L1.seat - F1.seat) + 1) AS available
FROM Firstseat AS F1, Lastseat AS L1
WHERE L1.seat = (SELECT MIN(L2.seat)
  FROM Lastseat AS L2
 WHERE F1.seat <= L2.seat
);


SELECT * FROM Restaurant;
