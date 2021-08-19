CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Foobar;
CREATE TABLE Foobar
(str VARCHAR(6) NOT NULL 
  CONSTRAINT str_constraint
  --  CHECK ( str REGEXP '[a-z]+')  -- alphabet を含む
  --  CHECK ( str RLIKE '^[a-zA-Z]+$') -- 全て alpabet
  --  CHECK ( UCASE(str) = LCASE(str) ) -- 全て alphabet でない # これはなぜか使えない。。。
  --  CHECK ( str REGEXP '[^a-z]' ) -- 全て alphabet でない
);

-- 正常データ
-- INSERT INTO Foobar VALUES('');    --Oracleでは正常だが、MySQL, PostgreSQLではエラーと見なされる
INSERT INTO Foobar VALUES('a');
INSERT INTO Foobar VALUES('A');
INSERT INTO Foobar VALUES('aA');
INSERT INTO Foobar VALUES('abcdef');
INSERT INTO Foobar VALUES('ABCDEF');
INSERT INTO Foobar VALUES('AbCdEf');

-- エラーデータ
-- INSERT INTO Foobar VALUES(NULL);
-- INSERT INTO Foobar VALUES('a1aaaa');
-- INSERT INTO Foobar VALUES('ceeg0d');
-- INSERT INTO Foobar VALUES('Aあ');
-- INSERT INTO Foobar VALUES('123456');
INSERT INTO Foobar VALUES('s23');
INSERT INTO Foobar VALUES('1a3456');
INSERT INTO Foobar VALUES('N23456');

SELECT * FROM Foobar;