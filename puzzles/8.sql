CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS PrinterControl;
/*
CREATE TABLE PrinterControl(
  name_start CHAR(8) NOT NULL,
  name_end CHAR(8) NOT NULL,
  printer_name CHAR(4) NOT NULL,
  memo CHAR(40)
);
INSERT INTO PrinterControl VALUES( 'chacha', 'chacha', 'LPT1', '一階のプリンタ' );
INSERT INTO PrinterControl VALUES( 'lee'   , 'lee'   , 'LPT2', '二階のプリンタ' ); 
INSERT INTO PrinterControl VALUES( 'thomas', 'thomas', 'LPT3', '三階のプリンタ' ); 
INSERT INTO PrinterControl VALUES( 'a',   'mzzzzzzz' , 'LPT4', '共有プリンタ #1' ); 
INSERT INTO PrinterControl VALUES( 'n',   'zzzzzzzz' , 'LPT5', '共有プリンタ #2' ); 

\! echo \\n=== show answer ===\\n;
-- SOLUTION 1 --
SELECT MIN(printer_name) FROM PrinterControl
WHERE 'chacha' BETWEEN  name_start AND name_end;
*/

-- SOLUTION 2 --
CREATE TABLE PrinterControl
(user_id CHAR(10), -- NULLは空きプリンタを意味する
  printer_name CHAR(4) NOT NULL PRIMARY KEY,
  printer_description CHAR(40) NOT NULL);

INSERT INTO PrinterControl VALUES( 'chacha',  'LPT1',  '一階のプリンタ');
INSERT INTO PrinterControl VALUES( 'lee'   ,  'LPT2',  '二階のプリンタ'); 
INSERT INTO PrinterControl VALUES( 'thomas',  'LPT3',  '三階のプリンタ' );
INSERT INTO PrinterControl VALUES( NULL    ,  'LPT4',  '共有プリンタ' );
INSERT INTO PrinterControl VALUES( NULL    ,  'LPT5',  '共有プリンタ' );

SELECT COALESCE(MIN(printer_name),(
  SELECT MIN(printer_name) FROM PrinterControl AS P2
  WHERE user_id IS NULL))
FROM PrinterControl AS P1
WHERE user_id = "acha";

-- SOLUTION 3 --

SET @id = 'zee';
SELECT COALESCE(MIN(printer_name),(
  SELECT DISTINCT CASE
    WHEN @id < 'n'
    THEN 'LPT4'
    ELSE 'LTP5' END
   FROM PrinterControl AS P2
  WHERE user_id IS NULL))
FROM PrinterControl AS P1
WHERE user_id = @id;
