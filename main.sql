CREATE DATABASE sprint_1;

CREATE SCHEMA raw_data;
CREATE SCHEMA car_shop;
SET search_path TO car_shop, raw_data, public;

CREATE TABLE raw_data.sales (
    id                   INTEGER PRIMARY KEY,
    auto                 TEXT,
    gasoline_consumption REAL,
    price                REAL,
    date                 DATE,
    person_name          TEXT,
    phone                TEXT,
    discount             INTEGER,
    brand_origin         TEXT
);

COPY raw_data.sales FROM '/cars.csv' NULL 'null' DELIMITER ',' CSV HEADER;

CREATE TABLE car_shop.brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(name) > 0),
    origin VARCHAR(50) CHECK (LENGTH(origin) > 0)
);

INSERT INTO brands (name, origin)
    SELECT
        DISTINCT SPLIT_PART(auto, ' ', 1) AS name,
        brand_origin AS origin
    FROM sales;

CREATE TABLE car_shop.customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL CHECK (LENGTH(first_name) > 0),
    last_name VARCHAR(50) NOT NULL CHECK (LENGTH(last_name) > 0),
    phone VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(phone) > 0)
);

INSERT INTO customers (first_name, last_name, phone)
    SELECT DISTINCT
        SPLIT_PART(person_name, ' ', 1) AS first_name,
        -- TODO: fix the last name
        SPLIT_PART(person_name, ' ', 2) AS last_name,
        phone
    FROM sales;

CREATE TABLE car_shop.cars (
    id SERIAL PRIMARY KEY,
    brand_id INTEGER REFERENCES brands(id) ON DELETE CASCADE,
    model VARCHAR(100) NOT NULL UNIQUE CHECK (LENGTH(model) > 0)
);


CREATE TABLE car_shop.purchases (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id) ON DELETE SET NULL,
    customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL,
    discount INTEGER NOT NULL DEFAULT 0 CHECK (discount >= 0),
    purchased_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cost DECIMAL(7, 2) NOT NULL CHECK (cost >= 0),
    car_color VARCHAR(20) NOT NULL CHECK (LENGTH(car_color) > 0)
);

CREATE TABLE car_shop.gasoline_consumption (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id) ON DELETE CASCADE UNIQUE,
    consumption DECIMAL(5, 2) NOT NULL CHECK (consumption > 0)
);
