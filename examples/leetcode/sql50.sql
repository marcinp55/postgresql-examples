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
DROP TYPE activity_type;

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

-- 1280. Students and Examinations --
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
        WHERE e.student_id = sd.student_id
          AND e.subject_name = sb.subject_name) AS attended_exams
FROM subjects sb
         CROSS JOIN students sd
ORDER BY sd.student_id, sb.subject_name;

DROP TABLE subjects;
DROP TABLE examinations;
DROP TABLE students;

-- 570. Managers with at Least 5 Direct Reports --
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports
CREATE TABLE IF NOT EXISTS Employee
(
    id         int,
    name       varchar(255),
    department varchar(255),
    managerId  int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, name, department, managerId)
VALUES (101, 'John', 'A', NULL);
INSERT INTO Employee (id, name, department, managerId)
VALUES (102, 'Dan', 'A', 101);
INSERT INTO Employee (id, name, department, managerId)
VALUES (103, 'James', 'A', 101);
INSERT INTO Employee (id, name, department, managerId)
VALUES (104, 'Amy', 'A', 101);
INSERT INTO Employee (id, name, department, managerId)
VALUES (105, 'Anne', 'A', 101);
INSERT INTO Employee (id, name, department, managerId)
VALUES (106, 'Ron', 'B', 101);
INSERT INTO Employee (id, name, department, managerId)
VALUES (107, 'John', 'B', NULL);
INSERT INTO Employee (id, name, department, managerId)
VALUES (102, 'Dan', 'A', 107);
INSERT INTO Employee (id, name, department, managerId)
VALUES (103, 'James', 'A', 107);
INSERT INTO Employee (id, name, department, managerId)
VALUES (104, 'Amy', 'A', 107);
INSERT INTO Employee (id, name, department, managerId)
VALUES (105, 'Anne', 'A', 107);
INSERT INTO Employee (id, name, department, managerId)
VALUES (106, 'Ron', 'B', 107);


-- Solution --
SELECT e1.name
FROM employee e1
         JOIN employee e2 ON e1.id = e2.managerId
GROUP BY e1.id, e1.name
HAVING COUNT(*) >= 5;

DROP TABLE employee;

-- 1934. Confirmation Rate --
-- https://leetcode.com/problems/confirmation-rate/
CREATE TYPE confirmations_action AS ENUM ('confirmed', 'timeout');
CREATE TABLE IF NOT EXISTS Signups
(
    user_id    int,
    time_stamp timestamp
);
CREATE TABLE IF NOT EXISTS Confirmations
(
    user_id    int,
    time_stamp timestamp,
    action     confirmations_action
);
TRUNCATE TABLE Signups;
INSERT INTO Signups (user_id, time_stamp)
VALUES (3, '2020-03-21 10:16:13');
INSERT INTO Signups (user_id, time_stamp)
VALUES (7, '2020-01-04 13:57:59');
INSERT INTO Signups (user_id, time_stamp)
VALUES (2, '2020-07-29 23:09:44');
INSERT INTO Signups (user_id, time_stamp)
VALUES (6, '2020-12-09 10:39:37');
TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (3, '2021-01-06 03:30:46', 'timeout');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (3, '2021-07-14 14:00:00', 'timeout');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (3, '2021-07-14 14:00:00', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (7, '2021-06-12 11:57:29', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (7, '2021-06-13 12:58:28', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (7, '2021-06-14 13:59:27', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (2, '2021-01-22 00:00:00', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES (2, '2021-02-28 23:59:59', 'timeout');

-- Solution --

SELECT user_id,
       ROUND(
                   (SELECT CAST(COUNT(*) AS numeric)
                    FROM confirmations c
                    WHERE c.user_id = s.user_id
                      AND action = 'confirmed')
                   /
                   (SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE CAST(COUNT(*) AS numeric) END
                    FROM confirmations c
                    WHERE c.user_id = s.user_id),
                   2) AS confirmation_rate
FROM signups s
GROUP BY user_id;

DROP TABLE confirmations;
DROP TABLE signups;
DROP TYPE confirmations_action;

-- 620. Not Boring Movies --
-- https://leetcode.com/problems/not-boring-movies/
CREATE TABLE IF NOT EXISTS cinema
(
    id          int,
    movie       varchar(255),
    description varchar(255),
    rating      numeric(2, 1)
);
TRUNCATE TABLE cinema;
INSERT INTO cinema (id, movie, description, rating)
VALUES (1, 'War', 'Great 3D', 8.9);
INSERT INTO cinema (id, movie, description, rating)
VALUES (2, 'Science', 'Fiction', 8.5);
INSERT INTO cinema (id, movie, description, rating)
VALUES (3, 'Irish', 'boring', 6.2);
INSERT INTO cinema (id, movie, description, rating)
VALUES (4, 'Ice Song', 'Fantasy', 8.6);
INSERT INTO cinema (id, movie, description, rating)
VALUES (5, 'House Card', 'Interesting', 9.1);

-- Solution --

SELECT *
FROM cinema
WHERE id % 2 <> 0
  AND description <> 'boring'
ORDER BY rating DESC;

DROP TABLE cinema;

-- 1251. Average Selling Price --
-- https://leetcode.com/problems/average-selling-price/
CREATE TABLE IF NOT EXISTS Prices
(
    product_id int,
    start_date date,
    end_date   date,
    price      int
);
CREATE TABLE IF NOT EXISTS UnitsSold
(
    product_id    int,
    purchase_date date,
    units         int
);
TRUNCATE TABLE Prices;
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES (1, '2019-02-17', '2019-02-28', 5);
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES (1, '2019-03-01', '2019-03-22', 20);
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES (2, '2019-02-01', '2019-02-20', 15);
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES (2, '2019-02-21', '2019-03-31', 30);
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES (3, '2019-02-21', '2019-03-31', 30);
TRUNCATE TABLE UnitsSold;
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES (1, '2019-02-25', 100);
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES (1, '2019-03-01', 15);
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES (2, '2019-02-10', 200);
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES (2, '2019-03-22', 30);

-- Solution --
-- Write a solution to find the average selling price for each product.
-- average_price should be rounded to 2 decimal places.
SELECT p.product_id,
       COALESCE(ROUND(SUM(p.price * u.units) / SUM(CAST(units AS numeric)), 2), 0) AS average_price
FROM unitssold u
         RIGHT JOIN prices p ON u.product_id = p.product_id AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

DROP TABLE prices;
DROP TABLE unitssold;
