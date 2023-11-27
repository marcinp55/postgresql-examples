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

-- 1075. Project Employees I --
-- https://leetcode.com/problems/project-employees-i/
CREATE TABLE IF NOT EXISTS Project
(
    project_id  int,
    employee_id int
);
CREATE TABLE IF NOT EXISTS Employee
(
    employee_id      int,
    name             varchar(10),
    experience_years int
);
TRUNCATE TABLE Project;
INSERT INTO Project (project_id, employee_id)
VALUES (1, 1);
INSERT INTO Project (project_id, employee_id)
VALUES (1, 2);
INSERT INTO Project (project_id, employee_id)
VALUES (1, 3);
INSERT INTO Project (project_id, employee_id)
VALUES (2, 1);
INSERT INTO Project (project_id, employee_id)
VALUES (2, 4);
TRUNCATE TABLE Employee;
INSERT INTO Employee (employee_id, name, experience_years)
VALUES (1, 'Khaled', 3);
INSERT INTO Employee (employee_id, name, experience_years)
VALUES (2, 'Ali', 2);
INSERT INTO Employee (employee_id, name, experience_years)
VALUES (3, 'John', 1);
INSERT INTO Employee (employee_id, name, experience_years)
VALUES (4, 'Doe', 2);

-- Solution --
-- Write an SQL query that reports the average experience years of all the employees for each project,
-- rounded to 2 digits.
SELECT p.project_id,
       ROUND(AVG(e.experience_years), 2) AS average_years
FROM employee e
         JOIN project p ON e.employee_id = p.employee_id
GROUP BY p.project_id;

DROP TABLE employee;
DROP TABLE project;

-- 1633. Percentage of Users Attended a Contest --
-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/
CREATE TABLE IF NOT EXISTS Users
(
    user_id   int,
    user_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Register
(
    contest_id int,
    user_id    int
);
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, user_name)
VALUES (6, 'Alice');
INSERT INTO Users (user_id, user_name)
VALUES (2, 'Bob');
INSERT INTO Users (user_id, user_name)
VALUES (7, 'Alex');
TRUNCATE TABLE Register;
INSERT INTO Register (contest_id, user_id)
VALUES (215, 6);
INSERT INTO Register (contest_id, user_id)
VALUES (209, 2);
INSERT INTO Register (contest_id, user_id)
VALUES (208, 2);
INSERT INTO Register (contest_id, user_id)
VALUES (210, 6);
INSERT INTO Register (contest_id, user_id)
VALUES (208, 6);
INSERT INTO Register (contest_id, user_id)
VALUES (209, 7);
INSERT INTO Register (contest_id, user_id)
VALUES (209, 6);
INSERT INTO Register (contest_id, user_id)
VALUES (215, 7);
INSERT INTO Register (contest_id, user_id)
VALUES (208, 7);
INSERT INTO Register (contest_id, user_id)
VALUES (210, 2);
INSERT INTO Register (contest_id, user_id)
VALUES (207, 2);
INSERT INTO Register (contest_id, user_id)
VALUES (210, 7);

-- Solution --
-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
-- Return the result table ordered by percentage in descending order.
-- In case of a tie, order it by contest_id in ascending order.
SELECT r.contest_id,
       ROUND((COUNT(r.user_id) / CAST((SELECT COUNT(user_id) FROM users) AS numeric)) * 100, 2) AS percentage
FROM register r
         JOIN users u ON r.user_id = u.user_id
GROUP BY r.contest_id
ORDER BY 2 DESC, r.contest_id;

DROP TABLE register;
DROP TABLE users;

-- 1211. Queries Quality and Percentage --
-- https://leetcode.com/problems/queries-quality-and-percentage/
CREATE TABLE IF NOT EXISTS Queries
(
    query_name varchar(30),
    result     varchar(50),
    position   int,
    rating     int
);
TRUNCATE TABLE Queries;
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'Golden Retriever', 1, 5);
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'German Shepherd', 2, 5);
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'Mule', 200, 1);
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Shirazi', 5, 2);
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Siamese', 3, 3);
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Sphynx', 7, 4);

-- Solution --
-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.
SELECT query_name,
       ROUND(AVG(rating / CAST(position AS numeric)), 2) AS quality,
       ROUND(COUNT(rating) FILTER ( WHERE rating < 3 ) / CAST(COUNT(rating) AS numeric) * 100,
             2)                                          AS poor_query_percentage
FROM queries
GROUP BY query_name;

DROP TABLE queries;

-- 1193. Monthly Transactions I --
-- https://leetcode.com/problems/monthly-transactions-i/
CREATE TYPE state AS ENUM ('approved', 'declined');
CREATE TABLE IF NOT EXISTS Transactions
(
    id         int,
    country    varchar(4),
    state      state,
    amount     int,
    trans_date date
);
TRUNCATE TABLE Transactions;
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES (121, 'US', 'approved', 1000, '2018-12-18');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES (122, 'US', 'declined', 2000, '2018-12-19');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES (123, 'US', 'approved', 2000, '2019-01-01');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES (124, 'DE', 'approved', 2000, '2019-01-07');

-- Solution --
-- Write an SQL query to find for each month and country, the number of transactions
-- and their total amount, the number of approved transactions and their total amount.
SELECT TO_CHAR(t.trans_date, 'YYYY-MM')                                 AS month,
       t.country,
       COUNT(*)                                                         AS trans_count,
       COUNT(*) FILTER ( WHERE t.state = 'approved' )                   AS approved_count,
       SUM(t.amount)                                                    AS trans_total_amount,
       COALESCE(SUM(t.amount) FILTER ( WHERE t.state = 'approved' ), 0) AS approved_total_amount
FROM Transactions t
GROUP BY 1, t.country;

DROP TABLE transactions;
DROP TYPE state;

-- 1174. Immediate Food Delivery II --
-- https://leetcode.com/problems/immediate-food-delivery-ii/
CREATE TABLE IF NOT EXISTS Delivery
(
    delivery_id                 int,
    customer_id                 int,
    order_date                  date,
    customer_pref_delivery_date date
);
TRUNCATE TABLE Delivery;
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (1, 1, '2019-08-01', '2019-08-02');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (2, 2, '2019-08-02', '2019-08-02');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (3, 1, '2019-08-11', '2019-08-12');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (4, 3, '2019-08-24', '2019-08-24');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (5, 3, '2019-08-21', '2019-08-22');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (6, 2, '2019-08-11', '2019-08-13');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES (7, 4, '2019-08-09', '2019-08-09');

-- Solution --
-- If the customer's preferred delivery date is the same as the order date, then the order is
-- called immediate; otherwise, it is called scheduled.
-- The first order of a customer is the order with the earliest order date that the customer made.
-- It is guaranteed that a customer has precisely one first order.
-- Write a solution to find the percentage of immediate orders in the first orders of all customers,
-- rounded to 2 decimal places.
WITH order_types AS (SELECT customer_id,
                            CASE
                                WHEN MIN(order_date) = MIN(customer_pref_delivery_date) THEN 'immediate'
                                ELSE 'scheduled'
                                END AS order_type
                     FROM delivery
                     GROUP BY customer_id)
SELECT ROUND(COUNT(*) FILTER ( WHERE order_type = 'immediate' ) / CAST(COUNT(*) AS numeric) * 100,
             2) AS immediate_percentage
FROM order_types;

DROP TABLE delivery;

-- 550. Game Play Analysis IV --
-- https://leetcode.com/problems/game-play-analysis-iv/
CREATE TABLE IF NOT EXISTS Activity
(
    player_id    int,
    device_id    int,
    event_date   date,
    games_played int
);
TRUNCATE TABLE Activity;
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (1, 2, '2016-03-01', 5);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (1, 2, '2016-03-02', 6);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (2, 3, '2017-06-25', 1);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (3, 1, '2016-03-02', 0);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (3, 4, '2018-07-03', 5);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (4, 5, '2018-07-03', 5);
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES (4, 5, '2018-07-04', 15);

-- Solution --
-- Write a solution to report the fraction of players that logged in again on the day
-- after the day they first logged in, rounded to 2 decimal places.
-- In other words, you need to count the number of players that logged in for at least
-- two consecutive days starting from their first login date,
-- then divide that number by the total number of players.
WITH player_min_dates AS (SELECT a.player_id,
                                 MIN(a.event_date) AS min_event_date
                          FROM activity a
                          GROUP BY a.player_id),
     all_players_count AS (SELECT COUNT(DISTINCT a.player_id)
                           FROM activity a)
SELECT ROUND(COUNT(DISTINCT a1.player_id) / CAST((SELECT * FROM all_players_count) AS numeric), 2) AS fraction
FROM activity a1
         JOIN player_min_dates p ON a1.player_id = p.player_id
         JOIN activity a2 ON a1.player_id = a2.player_id AND a2.event_date = p.min_event_date + 1;

DROP TABLE activity;

-- 2356. Number of Unique Subjects Taught by Each Teacher --
-- https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/
CREATE TABLE IF NOT EXISTS Teacher
(
    teacher_id int,
    subject_id int,
    dept_id    int
);
TRUNCATE TABLE Teacher;
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (1, 2, 3);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (1, 2, 4);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (1, 3, 3);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (2, 1, 1);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (2, 2, 1);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (2, 3, 1);
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES (2, 4, 1);

-- Solution --
-- Write a solution to calculate the number of unique subjects each teacher teaches in the university. --
SELECT t.teacher_id,
       COUNT(DISTINCT t.subject_id) AS cnt
FROM teacher t
GROUP BY t.teacher_id;

DROP TABLE teacher;

-- 1141. User Activity for the Past 30 Days I --
-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/
CREATE TYPE activity_type AS enum ('open_session', 'end_session', 'scroll_down', 'send_message');
CREATE TABLE IF NOT EXISTS Activity
(
    user_id       int,
    session_id    int,
    activity_date date,
    activity_type activity_type
);
TRUNCATE TABLE Activity;
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (1, 1, '2019-07-20', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (1, 1, '2019-07-20', 'scroll_down');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (1, 1, '2019-07-20', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (2, 4, '2019-07-20', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (2, 4, '2019-07-21', 'send_message');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (2, 4, '2019-07-21', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (3, 2, '2019-07-21', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (3, 2, '2019-07-21', 'send_message');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (3, 2, '2019-07-21', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (4, 3, '2019-06-25', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES (4, 3, '2019-06-25', 'end_session');

-- Solution --
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively.
-- A user was active on someday if they made at least one activity on that day.

