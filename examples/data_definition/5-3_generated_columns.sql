CREATE TABLE people
(
    height_cm numeric,
    height_in numeric GENERATED ALWAYS AS ( height_cm / 2.54 ) STORED
);

INSERT INTO people
VALUES (180);

INSERT INTO people
VALUES (160);

SELECT *
FROM people;

DROP TABLE people;
