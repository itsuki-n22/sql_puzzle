CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;
DROP TABLE IF EXISTS FiscalYearTable1;
CREATE TABLE FiscalYearTable1 
(
  fiscal_year INTEGER NOT NULL PRIMARY KEY,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  
  CONSTRAINT valid_start_date
    CHECK ((EXTRACT(YEAR FROM start_date) = fiscal_year - 1)
      AND (EXTRACT(MONTH FROM start_date) = 10)
      AND (EXTRACT(Day FROM start_date) = 01)),
  CONSTRAINT valid_end_date
    CHECK ((EXTRACT(YEAR FROM end_date) = fiscal_year)
      AND (EXTRACT(MONTH FROM end_date) = 09)
      AND (EXTRACT(Day FROM end_date) = 30)),
  CONSTRAINT check_interval
    CHECK ((end_date - INTERVAL 365 DAY = start_date)
      OR (end_date - INTERVAL 364 DAY = start_date)
    ) -- INTERVAL 関数は +-と 時間単位が必須になる
);

\! echo === show FiscalYearTable1 table ===\\n;
desc FiscalYearTable1;

-- CHECK関数は mysql 8 系でしか使えない。 5系はsyntaxエラーにならないが無視される。