CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Absenteeism;
DROP TABLE IF EXISTS Personnel1;
DROP TABLE IF EXISTS ExcuseList;

CREATE TABLE Personnel1(
  emp_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(10) NOT NULL
);
INSERT INTO Personnel1 (name) VALUES ("taro"),("jiro"),("saburo");

CREATE TABLE ExcuseList(
  reason_code INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  body VARCHAR(10) NOT NULL
);
INSERT INTO ExcuseList (body) VALUES ("遅刻"),("事故"),("有給"),("病欠");

CREATE TABLE Absenteeism 
(
  emp_id INTEGER NOT NULL, 
  absent_date DATE NOT NULL,
  reason_code Integer NOT NULL,
  severity_points INTEGER NOT NULL,
  CONSTRAINT valid_severity_points
    CHECK ((severity_points BETWEEN 1 AND 4 )),
  PRIMARY KEY (emp_id, absent_date),
  -- 書籍と違って、FOREIGN KEY で外部キーを指定しないと外部キー制約が反映されない（REFERENCES だけではだめ)
  FOREIGN KEY (emp_id) REFERENCES Personnel1 (emp_id), 
  FOREIGN KEY (reason_code) REFERENCES ExcuseList (reason_code)
);
INSERT INTO Absenteeism VALUES
(1,'2021-01-01',1,1),
(1,'2021-01-02',1,1),
(1,'2021-01-03',1,1),
(1,'2021-01-05',1,1),
(1,'2021-02-03',1,1),
(2,'2021-03-03',1,1),
(3,'2021-04-03',1,1);

-- SOLUTION --
ALTER TABLE Absenteeism DROP CONSTRAINT valid_severity_points;
ALTER TABLE Absenteeism ADD CONSTRAINT valid_severity_points
    CHECK ((severity_points BETWEEN 0 AND 4 ));

/* 書籍の構文は使えない。 MySQLでは 副問い合わせに同じテーブルを指定できない
https://dev.mysql.com/doc/refman/5.6/ja/subquery-errors.htmlhttps://dev.mysql.com/doc/refman/5.6/ja/subquery-errors.html
https://paulownia.hatenablog.com/entry/20080219/1203435273

UPDATE Absenteeism 
SET severity_points = 0, reason_code = 4
WHERE EXISTS (
  SELECT * FROM Absenteeism AS A2
  WHERE Absenteeism.emp_id = A2.emp_id
  AND Absenteeism.absent_date = (A2.absent_date + INTERVAL 1 DAY)
);

-- DELETE はこんなかんじにする
DELETE A1 FROM Absenteeism A1, Absenteeism A2
WHERE A1.emp_id = A2.emp_id
  AND A1.absent_date > A2.absent_date
;
*/
UPDATE Absenteeism, (SELECT * FROM Absenteeism) A2
SET Absenteeism.severity_points = 0, Absenteeism.reason_code = 4
WHERE Absenteeism.emp_id = A2.emp_id
  AND Absenteeism.absent_date = (A2.absent_date + INTERVAL 1 DAY);

-- MySQLは自己結合で削除する場合、派生ビューの中(select * FROM (conditions))にテーブルを展開することで自己相関問い合わせを再現できる。
DELETE FROM Absenteeism 
WHERE emp_id IN (
  SELECT * FROM (
    SELECT a1.emp_id FROM Absenteeism AS a1 WHERE a1.emp_id = (
      SELECT a2.emp_id
      FROM Absenteeism AS a2
      WHERE a2.emp_id = a1.emp_id
        AND absent_date
          BETWEEN CURRENT_TIMESTAMP - INTERVAL 365 DAY
              AND CURRENT_TIMESTAMP
      GROUP BY a2.emp_id
      HAVING SUM(a2.severity_points) > 1
    )
  ) AS tmp -- SELECT * FROM () とした場合、名前のないビューは名前を持たせる必要があり、AS <name> が必要になる これは派生ビューと呼ぶ
)
;


\! echo === show Absenteeism table ===\\n;
desc Absenteeism;

\! echo \\n=== show Absenteeism table ===\\n;
SELECT * FROM Absenteeism;
