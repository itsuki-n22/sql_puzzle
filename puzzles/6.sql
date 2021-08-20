CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Hotel;

-- MySQLは CHECK内で 副問い合わせができないので本書の その1の解法はつかえない

-- SOLUTION 2 --
CREATE TABLE Hotel(
room_nbr INTEGER NOT NULL,
occupy_date DATE NOT NULL,
guest_name CHAR(30) NOT NULL,
PRIMARY KEY (room_nbr, occupy_date)
);
INSERT INTO Hotel VALUES (1, '2008-01-01', 'Coe');
INSERT INTO Hotel VALUES (1, '2008-01-03', 'Doe');
INSERT INTO Hotel VALUES (1, '2008-01-01', 'Roe'); -- エラーが出たら成功

-- SOLUTION 3 --
/* 
CREATE TABLE Hotel
(room_nbr INTEGER NOT NULL,
 arrival_date DATE NOT NULL,
 departure_date DATE NOT NULL,
 guest_name CHAR(30) NOT NULL,
    PRIMARY KEY (room_nbr, arrival_date),
    CHECK (departure_date >= arrival_date));

DROP VIEW IF EXISTS HotelStays;
CREATE VIEW HotelStays (room_nbr, arrival_date, departure_date, guest_name)
AS SELECT room_nbr, arrival_date, departure_date, guest_name
FROM Hotel AS H1
WHERE NOT EXISTS (
  SELECT * FROM Hotel AS H2
  WHERE H1.room_nbr = H2.room_nbr
    AND H2.arrival_date < H1.arrival_date
    AND H1.arrival_date < H2.departure_date
) WITH CHECK OPTION;

-- MySQL WITH CHECK OPTION について  WHERE 句内のサブクエリー があると使えない。なのでこの解法は使えない。
-- https://dev.mysql.com/doc/refman/5.6/ja/view-updatability.html

INSERT INTO HotelStays VALUES (1, '2008-01-01', '2008-01-03', 'Coe');
INSERT INTO HotelStays VALUES (1, '2008-01-03', '2008-01-05', 'Doe');
INSERT INTO HotelStays VALUES (1, '2008-01-02', '2008-01-05', 'Roe'); -- エラーが出たら成功
*/ 
-- SHOW TABLE --
\! echo \\n=== show answer ===\\n;
SELECT * FROM Hotel;