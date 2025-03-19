CREATE TABLE raw_data.sales (
    id INTEGER PRIMARY KEY,
    auto TEXT,
    gasoline_consumption REAL,
    price REAL,
    date DATE,
    person_name TEXT,
    phone TEXT,
    discount INTEGER,
    brand_origin TEXT
);

COPY raw_data.sales FROM '/cars.csv' NULL 'null' DELIMITER ',' CSV HEADER;
