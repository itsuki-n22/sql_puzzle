CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Badges;
CREATE TABLE Badges
(badge_nbr INTEGER NOT NULL PRIMARY KEY,
 emp_id INTEGER NOT NULL,
 issued_date DATE NOT NULL,
 badge_status CHAR(1) NOT NULL
    CHECK (badge_status IN ('A', 'I'))
);

INSERT INTO Badges VALUES(100, 1, '2007-01-01', 'I');
INSERT INTO Badges VALUES(200, 1, '2007-02-01', 'I'); 
INSERT INTO Badges VALUES(300, 2, '2007-03-01', 'I'); 
INSERT INTO Badges VALUES(400, 3, '2007-03-01', 'I'); 
INSERT INTO Badges VALUES(500, 3, '2007-04-01', 'I'); 
INSERT INTO Badges VALUES(600, 3, '2007-05-01', 'I'); 
\! echo \\n=== show budges ===\\n;
SELECT * FROM Badges;
-- SOLUTION --
\! echo \\n=== show answer ===\\n;

-- ALTER TABLE Badges ADD CONSTRAINT  -- MySQLではCONSTRAINT 内で ALL は使えない？ SELECTなどを使ってサブクエリも使えないらしい。
--  CHECK (1 <= ALL (SELECT count(*) FROM Badges WHERE badge_status = 'I' GROUP BY emp_id ));
-- ALTER TABLE Badges ADD CONSTRAINT hoge
-- CHECK


-- JOIN を用いた方法: 最新のバッジを emp_idごとにもってくる
/*
UPDATE Badges SET badge_status = 'A'
WHERE badge_nbr IN (
  SELECT * FROM (
    SELECT B1.badge_nbr FROM Badges AS B1 INNER JOIN 
      (SELECT emp_id, MAX(issued_date) AS issued_date FROM Badges GROUP BY emp_id ) AS B2
      ON B1.emp_id = B2.emp_id
      AND B1.issued_date = B2.issued_date
  ) AS tmp
);
*/

-- サブクエリを用いた方法
UPDATE Badges SET badge_status = 'A'
WHERE badge_nbr IN (
  SELECT * FROM(
    SELECT B1.badge_nbr FROM Badges AS B1 
    WHERE B1.issued_date IN (
      SELECT MAX(issued_date) AS issued_date 
      FROM Badges AS B2 WHERE B2.emp_id = B1.emp_id
      GROUP BY emp_id
      ) 
  ) AS tmp2
);

SELECT * FROM Badges;