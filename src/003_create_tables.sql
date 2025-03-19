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
    name VARCHAR(100) NOT NULL CHECK (LENGTH(name) > 0),
    phone VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(phone) > 0)
);

INSERT INTO customers (name, phone)
    SELECT DISTINCT person_name, phone
    FROM sales;

CREATE TABLE car_shop.cars (
    id SERIAL PRIMARY KEY,
    brand_id INTEGER REFERENCES brands(id) ON DELETE CASCADE,
    model VARCHAR(100) NOT NULL UNIQUE CHECK (LENGTH(model) > 0)
);

INSERT INTO cars (brand_id, model)
    SELECT DISTINCT
        b.id,
        SPLIT_PART(SUBSTR(auto, LENGTH(SPLIT_PART(auto, ' ', 1)) + 2), ',', 1) AS model
    FROM sales
    JOIN brands AS b ON b.name = SPLIT_PART(auto, ' ', 1);

CREATE TABLE car_shop.gasoline_consumption (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id) ON DELETE CASCADE UNIQUE,
    consumption DECIMAL(5, 2) NOT NULL CHECK (consumption > 0)
);

INSERT INTO gasoline_consumption (car_id, consumption)
    SELECT DISTINCT
        c.id,
        s.gasoline_consumption
    FROM sales AS s
    JOIN cars AS c ON c.model = SPLIT_PART(SUBSTR(s.auto, LENGTH(SPLIT_PART(s.auto, ' ', 1)) + 2), ',', 1)
    WHERE gasoline_consumption IS NOT NULL;

CREATE TABLE car_shop.purchases (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id) ON DELETE SET NULL,
    customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL,
    discount INTEGER NOT NULL DEFAULT 0 CHECK (discount >= 0),
    purchased_at DATE NOT NULL DEFAULT CURRENT_DATE,
    cost DECIMAL(7, 2) NOT NULL CHECK (cost >= 0),
    car_color VARCHAR(20) NOT NULL CHECK (LENGTH(car_color) > 0)
);

INSERT INTO purchases (car_id, customer_id, discount, purchased_at, cost, car_color)
    SELECT
        c.id,
        cu.id,
        discount,
        date,
        price,
        LTRIM(SPLIT_PART(s.auto, ',', 2)) AS color
    FROM sales AS s
    JOIN cars AS c ON c.model = SPLIT_PART(SUBSTR(s.auto, LENGTH(SPLIT_PART(s.auto, ' ', 1)) + 2), ',', 1)
    JOIN customers AS cu USING (phone);
