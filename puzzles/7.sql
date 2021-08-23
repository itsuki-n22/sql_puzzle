CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Succession;
DROP TABLE IF EXISTS Portfolios;
/* -- これが初期のテーブル
CREATE TABLE Portfolios(
file_id INTEGER NOT NULL PRIMARY KEY,
issue_date DATE NOT NULL,
superseded_fileid INTEGER NOT NULL,
supersedes_fileid INTEGER NOT NULL,
FOREIGN KEY (superseded_fileid) REFERENCES Portfolios(file_id),
FOREIGN KEY (supersedes_fileid) REFERENCES Portfolios(file_id)
);
*/
-- INSERT INTO Portfolios VALUES (1,'20200101',1,1);
-- INSERT INTO Portfolios VALUES (2,'20200101',1,2);
-- INSERT INTO Portfolios VALUES (3,'20200101',2,3);

-- SOLUTION --
CREATE TABLE Portfolios(
file_id INTEGER NOT NULL PRIMARY KEY,
stuff CHAR(15) NOT NULL
);

INSERT INTO Portfolios VALUES
(222, 'a'),
(223, 'b'),
(224, 'c'),
(225, 'd'),
(322, 'e'),
(323, 'f'),
(324, 'g'),
(325, 'h'),
(999, 'i');

CREATE TABLE Succession(
  chain INTEGER NOT NULL,
  next INTEGER NOT NULL,
  file_id INTEGER NOT NULL,
  suc_date DATE NOT NULL,
  PRIMARY KEY(chain, next),
  FOREIGN KEY(file_id) REFERENCES Portfolios(file_id)
);

INSERT INTO Succession VALUES
(1, 0, 222, '20200101'),
(1, 1, 223, '20200102'),
(1, 2, 224, '20200104'),
(1, 3, 225, '20200101'),
(1, 4, 999, '20200121'),
(2, 0, 322, '20200101'),
(2, 1, 323, '20200107'),
(2, 2, 324, '20200101'),
(2, 3, 322, '20200109'),
(2, 4, 323, '20200111'),
(2, 5, 999, '20200121');

\! echo \\n=== show answer ===\\n;
SELECT DISTINCT P1.file_id, stuff, suc_date
FROM Portfolios AS P1, Succession AS S1
WHERE P1.file_id = S1.file_id
AND next = (SELECT MAX(next)
            FROM Succession AS S2
            WHERE S1.chain = S2.chain);

desc Portfolios;
desc Succession;
SELECT * FROM Succession INNER JOIN Portfolios USING(file_id); -- USING()のかっこを忘れがち
/* -- 本の回答
SELECT * FROM Succession AS S1, Portfolios AS P1
WHERE S1.file_id = P1.file_id
ORDER BY chain, next;
*/

SELECT S1.file_id, " superseded ", S2.file_id, " ON ", S1.suc_date
FROM Succession AS S1, Succession AS S2
WHERE S1.chain = S2.chain
  AND S1.next = S2.next + 1
  AND S1.file_id = 324;

SELECT * FROM Portfolios;