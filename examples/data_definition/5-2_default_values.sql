CREATE TABLE products
(
    product_no integer,
    name       text,
    price      numeric DEFAULT 9.99
);

INSERT INTO products
VALUES (1, 'scooter', 3.14);

INSERT INTO products
VALUES (2, 'car');

SELECT *
FROM products;

-- Serials --
CREATE SEQUENCE products_1_product_no_seq AS integer;

CREATE TABLE products_1
(
    product_no integer UNIQUE NOT NULL DEFAULT nextval('products_1_product_no_seq'),
    name       text,
    price      numeric
);

ALTER SEQUENCE products_1_product_no_seq OWNED BY products_1.product_no;

INSERT INTO products_1
VALUES (DEFAULT, 'scooter', 3.14);

SELECT *
FROM products_1;

CREATE TABLE products_2 (
    product_no SERIAL,
    name text,
    price numeric
);

INSERT INTO products_2
VALUES (DEFAULT, 'scooter', 9.15);

SELECT * FROM products_2;

DROP TABLE products;
DROP TABLE products_1;
DROP TABLE products_2;
