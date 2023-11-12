-- 1661. Average Time of Process per Machine
-- https://leetcode.com/problems/average-time-of-process-per-machine/
CREATE TYPE activity_type AS ENUM ('start', 'end');

CREATE TABLE IF NOT EXISTS Activity
(
    machine_id    int,
    process_id    int,
    activity_type activity_type,
    timestamp     float
);

TRUNCATE TABLE Activity;
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '0', 'start', '0.712');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '0', 'end', '1.52');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '1', 'start', '3.14');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '1', 'end', '4.12');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '0', 'start', '0.55');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '0', 'end', '1.55');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '1', 'start', '0.43');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '1', 'end', '1.42');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '0', 'start', '4.1');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '0', 'end', '4.512');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '1', 'start', '2.5');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '1', 'end', '5');

-- Solution --
SELECT a1.machine_id,
       ROUND(CAST(AVG(a2.timestamp - a1.timestamp) AS numeric), 3) AS "processing_time"
FROM Activity a1
         JOIN Activity a2 ON a1.machine_id = a2.machine_id AND a1.process_id = a2.process_id
WHERE a1.activity_type = 'start'
  AND a2.activity_type = 'end'
GROUP BY a1.machine_id;

DROP TABLE Activity;

-- 577. Employee Bonus --
-- https://leetcode.com/problems/employee-bonus
CREATE TABLE IF NOT EXISTS Employee
(
    empId      int,
    name       varchar(255),
    supervisor int,
    salary     int
);
CREATE TABLE IF NOT EXISTS Bonus
(
    empId int,
    bonus int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES (3, 'Brad', NULL, 4000);
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES (1, 'John', 3, 1000);
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES (2, 'Dan', 3, 2000);
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES (4, 'Thomas', 3, 4000);
TRUNCATE TABLE Bonus;
INSERT INTO Bonus (empId, bonus)
VALUES (2, 500);
INSERT INTO Bonus (empId, bonus)
VALUES (4, 2000);

-- Solution --
SELECT name, b.bonus
FROM Employee e
         LEFT JOIN bonus b ON e.empId = b.empId
WHERE b.bonus < 1000
   OR b.bonus IS NULL;

DROP TABLE bonus;
DROP TABLE employee;

-- 1280. Students and Examinations
-- https://leetcode.com/problems/students-and-examinations/
CREATE TABLE IF NOT EXISTS Students
(
    student_id   int,
    student_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Subjects
(
    subject_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Examinations
(
    student_id   int,
    subject_name varchar(20)
);
TRUNCATE TABLE Students;
INSERT INTO Students (student_id, student_name)
VALUES (1, 'Alice');
INSERT INTO Students (student_id, student_name)
VALUES (2, 'Bob');
INSERT INTO Students (student_id, student_name)
VALUES (13, 'John');
INSERT INTO Students (student_id, student_name)
VALUES (6, 'Alex');
TRUNCATE TABLE Subjects;
INSERT INTO Subjects (subject_name)
VALUES ('Math');
INSERT INTO Subjects (subject_name)
VALUES ('Physics');
INSERT INTO Subjects (subject_name)
VALUES ('Programming');
TRUNCATE TABLE Examinations;
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES (2, 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES (13, 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES (13, 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES (13, 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES (2, 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Math');

-- Solution --
SELECT sd.student_id,
       sd.student_name,
       sb.subject_name,
       (SELECT COUNT(student_id)
        FROM examinations e
        WHERE e.student_id = sd.student_id AND e.subject_name = sb.subject_name) AS attended_exams
FROM subjects sb
         CROSS JOIN students sd
ORDER BY sd.student_id, sb.subject_name;
