-- Table creation
CREATE TABLE weather
(
    city    varchar(80),
    temp_lo int,
    temp_hi int,
    prcp    real,
    date    date
);

CREATE TABLE cities
(
    name     varchar(80),
    location point
);

-- Standard insert
INSERT INTO weather
VALUES ('San Francisco', 46, 50, 0.25, '1994-11-27');

INSERT INTO cities
VALUES ('San Francisco', '(-194.0, 53.0)');

-- Explicit insert
INSERT INTO weather (city, temp_lo, temp_hi, prcp, date)
VALUES ('San Francisco', 43, 57, 0.0, '1994-11-29');

INSERT INTO weather (date, city, temp_hi, temp_lo)
VALUES ('1994-11-29', 'Hayward', 54, 37);

-- Selecting
SELECT *
FROM weather;

SELECT city, temp_lo, temp_hi, prcp, date
FROM weather;

SELECT city, (temp_hi + temp_lo) / 2 AS temp_avg, date
FROM weather;

SELECT *
FROM weather
WHERE city = 'San Francisco'
  AND prcp > 0.0;

SELECT *
FROM weather
ORDER BY city;

SELECT *
FROM weather
ORDER BY city, temp_lo;

SELECT DISTINCT city
FROM weather;

SELECT DISTINCT city
FROM weather
ORDER BY city;

-- Joins
SELECT *
FROM weather
         JOIN cities ON city = name;

SELECT city, temp_lo, temp_hi, prcp, date, location
FROM weather
         JOIN cities ON city = name;

SELECT weather.city, weather.temp_lo, weather.temp_hi, weather.prcp, weather.date, cities.location
FROM weather
         JOIN cities ON weather.city = cities.name;

SELECT *
FROM weather,
     cities
WHERE city = name;

SELECT *
FROM weather
         LEFT OUTER JOIN cities ON weather.city = cities.name;

SELECT *
FROM weather
         RIGHT OUTER JOIN cities ON weather.city = cities.name;

SELECT *
FROM weather
         FULL OUTER JOIN cities ON weather.city = cities.name;

SELECT w1.city,
       w1.temp_lo AS low,
       w1.temp_hi AS high,
       w2.city,
       w2.temp_lo AS low,
       w2.temp_hi AS high
FROM weather w1
         JOIN weather w2 ON w1.temp_lo < w2.temp_lo AND w1.temp_hi > w2.temp_hi;

SELECT *
FROM weather w
         JOIN cities c ON w.city = c.name;

-- Aggregates
SELECT max(temp_lo)
FROM weather;

SELECT city
FROM weather
WHERE temp_lo = (SELECT max(temp_lo) FROM weather);

SELECT city, count(*), max(temp_lo)
FROM weather
GROUP BY city;

SELECT city, count(*), max(temp_lo)
FROM weather
GROUP BY city
HAVING max(temp_lo) < 40;

SELECT city, count(*), max(temp_lo)
FROM weather
WHERE city LIKE 'S%'
GROUP BY city;

SELECT city,
       count(*) FILTER ( WHERE temp_lo < 45 ),
       max(temp_lo)
FROM weather
GROUP BY city;

-- Updates
UPDATE weather
SET temp_hi = temp_hi - 2,
    temp_lo = temp_lo - 2
WHERE date > '1994-11-28';

-- Deletions
DELETE
FROM weather
WHERE city = 'Hayward';

-- Views
CREATE VIEW myview AS
SELECT name, temp_lo, temp_hi, prcp, date, location
FROM weather,
     cities
WHERE city = name;

SELECT *
FROM myview;

-- Keys
CREATE TABLE cities_keys
(
    name     varchar(80) primary key,
    location point
);

CREATE TABLE weather_keys
(
    city    varchar(80) references cities_keys (name),
    temp_lo int,
    temp_hi int,
    prcp    real,
    date    date
);

INSERT INTO weather_keys
VALUES ('Berkeley', 45, 53, 0.0, '1994-11-28');
-- Invalid, no key

-- Transactions
CREATE TABLE branches
(
    name    varchar(80) primary key,
    balance real
);

CREATE TABLE accounts
(
    name        varchar(80),
    balance     real,
    branch_name varchar(80) references branches (name)
);

INSERT INTO branches
VALUES ('Main', 200.00);

INSERT INTO accounts
VALUES ('Alice', 100.00, 'Main');

INSERT INTO accounts
VALUES ('Bob', 100.00, 'Main');

BEGIN;
UPDATE accounts
SET balance = balance - 100.00
WHERE name = 'Alice';

UPDATE branches
SET balance = balance - 100.00
WHERE name = (SELECT branch_name FROM accounts WHERE name = 'Alice');

UPDATE accounts
SET balance = balance + 100.00
WHERE name = 'Bob';

UPDATE branches
SET balance = balance + 100.00
WHERE name = (SELECT branch_name FROM accounts WHERE name = 'Bob');
COMMIT;

INSERT INTO accounts
VALUES ('Wally', 200.00, 'Main');

BEGIN;
UPDATE accounts
SET balance = balance - 100.00
WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts
SET balance = balance + 100.00
WHERE name = 'Bob';
ROLLBACK TO my_savepoint;
UPDATE accounts
SET balance = balance + 100.00
WHERE name = 'Wally';
COMMIT;

-- Window functions
CREATE TABLE emp_salary
(
    dep_name varchar(80),
    emp_no   int,
    salary   int
);

INSERT INTO emp_salary
VALUES ('sales', 1, 5000);

INSERT INTO emp_salary
VALUES ('personnel', 2, 3900);

INSERT INTO emp_salary
VALUES ('sales', 3, 4800);

INSERT INTO emp_salary
VALUES ('sales', 4, 4800);

INSERT INTO emp_salary
VALUES ('personnel', 5, 3500);

INSERT INTO emp_salary
VALUES ('develop', 7, 4200);

INSERT INTO emp_salary
VALUES ('develop', 8, 6000);

INSERT INTO emp_salary
VALUES ('develop', 9, 4500);

INSERT INTO emp_salary
VALUES ('develop', 10, 5200);

INSERT INTO emp_salary
VALUES ('develop', 11, 5200);

SELECT dep_name,
       emp_no,
       salary,
       avg(salary) OVER (PARTITION BY dep_name)
FROM emp_salary;

SELECT dep_name,
       emp_no,
       salary,
       rank() OVER (PARTITION BY dep_name ORDER BY salary)
FROM emp_salary;

SELECT salary, sum(salary) OVER ()
FROM emp_salary;

SELECT salary, sum(salary) OVER (ORDER BY salary)
FROM emp_salary;

ALTER TABLE emp_salary
    ADD COLUMN enroll_date date DEFAULT '2023-11-04';

SELECT dep_name, emp_no, salary, enroll_date, pos
FROM (SELECT dep_name,
             emp_no,
             salary,
             enroll_date,
             rank() OVER (PARTITION BY dep_name ORDER BY salary DESC, emp_no) AS pos
      FROM emp_salary) AS ss
WHERE pos < 3;

SELECT sum(salary) OVER w,
       avg(salary) OVER w,
       dep_name,
       salary
FROM emp_salary
WINDOW w AS (PARTITION BY dep_name ORDER BY salary DESC);

-- Inheritance
CREATE TABLE cities_inh
(
    name       text,
    population real,
    elevation  int
);

CREATE TABLE capitals_inh
(
    state char(2) UNIQUE NOT NULL
) INHERITS (cities_inh);

INSERT INTO cities_inh
VALUES ('Mariposa', 123, 1953);

INSERT INTO cities_inh
VALUES ('Madison', 321, 845);

INSERT INTO capitals_inh
VALUES ('Las Vegas', 111, 2174, 'NV');

SELECT name, elevation
FROM cities_inh
WHERE elevation > 900;

SELECT name, elevation
FROM ONLY cities_inh
WHERE elevation > 900;

SELECT name, elevation
FROM ONLY capitals_inh
WHERE elevation > 900;
