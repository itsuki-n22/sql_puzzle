CREATE DATABASE IF NOT EXISTS sql_puzzle;
use sql_puzzle;

DROP TABLE IF EXISTS Procs;
DROP VIEW IF EXISTS Events;
DROP VIEW IF EXISTS ConcurrentProcs;

CREATE TABLE Procs (
  proc_id INTEGER NOT NULL,
  anest_name VARCHAR(10) NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL
);
INSERT INTO Procs VALUES 
(10,'Baker', '08:00', '11:00'),
(20,'Baker', '09:00', '13:00'),
(30,'Dow',   '09:00', '15:30'),
(40,'Dow',   '08:00', '13:30'),
(50,'Dow',   '10:00', '11:30'),
(60,'Dow',   '12:30', '13:30'),
(70,'Dow',   '13:30', '14:30'),
(80,'Dow',   '18:00', '19:00');

\! echo \\n=== show Procs table ===\\n;
desc Procs;
\! echo \\n=== show Procs dataset ===\\n;
SELECT * FROM Procs;
-- SOLUTION 1 --
/*
1. まず図にして視覚的に理解する
2. 時間単位で区切るか、proc_idごとで区切るか考える。今回はproc_idごとに見た方が少ない区分で終わりそうなのでproc_idで見る
3. proc_idごとに同時手術数を調べたい。手術ごとにその手術が始まる前にはじまった手術の数をカウントすればいい。
*/

CREATE VIEW Events (proc_id, comparison_proc, anset_name, event_time, event_type) AS (
  SELECT P1.proc_id, P2.proc_id, P1.anest_name, P2.start_time, +1
  FROM Procs AS P1, Procs AS P2
  WHERE P1.anest_name = P2.anest_name
    AND NOT (P2.end_time <= P1.start_time OR P2.start_time >= P1.end_time)
  UNION
  SELECT P1.proc_id, P2.proc_id, P1.anest_name, P2.end_time, -1 AS event_type
  FROM Procs AS P1, Procs AS P2
  WHERE P1.anest_name = P2.anest_name
    AND NOT (P2.end_time <= P1.start_time OR P2.start_time >= P1.end_time)
); -- Procs で掛け持ちが発生している手術の 開始時間と終了時間を羅列している

\! echo \\n=== show Events dataset ===\\n;
SELECT * FROM Events;

CREATE VIEW ConcurrentProcs  AS (
SELECT E1.proc_id, E1.event_time, (
  SELECT SUM(E2.event_type)
    FROM Events AS E2
   WHERE E2.proc_id = E1.proc_id
     AND E2.event_time < E1.event_time
) AS instantaneous_count
  FROM Events AS E1
 ORDER BY E1.proc_id, E1.event_time
);

\! echo \\n=== show ConcurrentProcs dataset ===\\n;
SELECT * FROM ConcurrentProcs;

\! echo \\n=== show answer ===\\n;
SELECT proc_id, MAX(instantaneous_count)
  FROM ConcurrentProcs
  GROUP BY proc_id;
