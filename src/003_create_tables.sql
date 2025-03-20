CREATE TABLE car_shop.countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL CHECK(LENGTH(name) > 0)
);

INSERT INTO car_shop.countries (name)
    SELECT DISTINCT brand_origin
    FROM raw_data.sales
    WHERE brand_origin IS NOT NULL;

CREATE TABLE car_shop.brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(name) > 0),
    country_id INTEGER REFERENCES car_shop.countries(id) ON DELETE SET NULL
);

INSERT INTO car_shop.brands (name, country_id)
    SELECT
        DISTINCT SPLIT_PART(s.auto, ' ', 1) AS name,
        c.id
    FROM raw_data.sales AS s
    LEFT JOIN car_shop.countries AS c ON c.name = s.brand_origin;

CREATE TABLE car_shop.colors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

INSERT INTO car_shop.colors (name)
    SELECT DISTINCT LTRIM(SPLIT_PART(s.auto, ',', 2))
    FROM raw_data.sales AS s;

CREATE TABLE car_shop.customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK (LENGTH(name) > 0),
    phone VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(phone) > 0)
);

INSERT INTO car_shop.customers (name, phone)
    SELECT DISTINCT person_name, phone
    FROM raw_data.sales;

CREATE TABLE car_shop.cars (
    id SERIAL PRIMARY KEY,
    brand_id INTEGER REFERENCES car_shop.brands(id) ON DELETE CASCADE,
    model VARCHAR(100) NOT NULL UNIQUE CHECK (LENGTH(model) > 0)
);

INSERT INTO car_shop.cars (brand_id, model)
    SELECT DISTINCT
        b.id,
        SPLIT_PART(SUBSTR(auto, LENGTH(SPLIT_PART(s.auto, ' ', 1)) + 2), ',', 1) AS model
    FROM raw_data.sales AS s
    JOIN car_shop.brands AS b ON b.name = SPLIT_PART(s.auto, ' ', 1);

CREATE TABLE car_shop.gasoline_consumption (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES car_shop.cars(id) ON DELETE CASCADE UNIQUE,
    consumption DECIMAL(5, 2) NOT NULL CHECK (consumption > 0)
);

INSERT INTO car_shop.gasoline_consumption (car_id, consumption)
    SELECT DISTINCT
        c.id,
        s.gasoline_consumption
    FROM raw_data.sales AS s
    JOIN car_shop.cars AS c ON c.model = SPLIT_PART(SUBSTR(s.auto, LENGTH(SPLIT_PART(s.auto, ' ', 1)) + 2), ',', 1)
    WHERE s.gasoline_consumption IS NOT NULL;

CREATE TABLE car_shop.purchases (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES car_shop.cars(id) ON DELETE SET NULL,
    customer_id INTEGER REFERENCES car_shop.customers(id) ON DELETE SET NULL,
    discount INTEGER NOT NULL DEFAULT 0 CHECK (discount >= 0),
    purchased_at DATE NOT NULL DEFAULT CURRENT_DATE,
    cost DECIMAL(7, 2) NOT NULL CHECK (cost >= 0),
    color_id INTEGER NOT NULL REFERENCES car_shop.colors (id)
);

INSERT INTO car_shop.purchases (car_id, customer_id, discount, purchased_at, cost, color_id)
    SELECT
        c.id,
        cu.id,
        s.discount,
        s.date,
        s.price,
        co.id
    FROM raw_data.sales AS s
    JOIN car_shop.cars AS c ON c.model = SPLIT_PART(SUBSTR(s.auto, LENGTH(SPLIT_PART(s.auto, ' ', 1)) + 2), ',', 1)
    JOIN car_shop.customers AS cu USING (phone)
    JOIN car_shop.colors AS co ON co.name = LTRIM(SPLIT_PART(s.auto, ',', 2));
