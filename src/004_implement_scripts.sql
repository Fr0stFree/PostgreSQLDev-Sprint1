-- 1. Напишите запрос, который выведет процент моделей машин, у которых нет параметра gasoline_consumption.
SELECT
    (1 - ROUND(COUNT(gc.consumption)::NUMERIC / COUNT(c.model), 2)) * 100 AS nulls_percentage_gasoline_consumption
FROM car_shop.cars AS c
LEFT JOIN car_shop.gasoline_consumption AS gc ON gc.car_id = c.id;

-- 2. Напишите запрос, который покажет название бренда и среднюю цену его автомобилей в разбивке по всем
-- годам с учётом скидки. Итоговый результат отсортируйте по названию бренда и году в восходящем порядке.
-- Среднюю цену округлите до второго знака после запятой.
SELECT 
    b.name,
    EXTRACT(YEAR FROM p.purchased_at) AS year_sold,
    ROUND(AVG(p.cost), 2) AS average_cost
FROM car_shop.brands AS b
JOIN car_shop.cars AS c ON b.id = c.brand_id
JOIN car_shop.purchases AS p ON p.car_id = c.id
GROUP BY b.name, year_sold
ORDER BY b.name ASC, year_sold ASC;

-- 3. Посчитайте среднюю цену всех автомобилей с разбивкой по месяцам в 2022 году с учётом скидки.
-- Результат отсортируйте по месяцам в восходящем порядке. 
-- Среднюю цену округлите до второго знака после запятой.
SELECT
    EXTRACT(MONTH FROM p.purchased_at) AS month,
    EXTRACT(YEAR FROM p.purchased_at) AS year,
    ROUND(AVG(p.cost), 2) AS average_cost
FROM car_shop.cars AS c
JOIN car_shop.purchases AS p ON c.id = p.car_id
WHERE EXTRACT(YEAR FROM p.purchased_at) = 2022
GROUP BY month, year
ORDER BY month ASC;

-- 4. Используя функцию STRING_AGG, напишите запрос, который выведет список купленных машин у
-- каждого пользователя через запятую. Пользователь может купить две одинаковые машины — это нормально.
-- Название машины покажите полное, с названием бренда — например: Tesla Model 3.Отсортируйте по
-- имени пользователя в восходящем порядке. Сортировка внутри самой строки с машинами не нужна.
SELECT
    cu.name,
    STRING_AGG(CONCAT(b.name, ' ', c.model), ', ')
FROM car_shop.customers AS cu
JOIN car_shop.purchases AS p ON p.customer_id = cu.id
JOIN car_shop.cars AS c ON p.car_id = c.id
JOIN car_shop.brands AS b ON b.id = c.brand_id
GROUP BY cu.name
ORDER BY cu.name;

-- 5. Напишите запрос, который вернёт самую большую и самую маленькую цену продажи автомобиля
-- с разбивкой по стране без учёта скидки. Цена в колонке price дана с учётом скидки.
SELECT
    co.name AS brand_origin,
    MAX(ROUND(cost / (1 - discount::REAL/100)::NUMERIC, 2)) AS price_max,
    MIN(ROUND(cost / (1 - discount::REAL/100)::NUMERIC, 2)) AS price_min
FROM car_shop.purchases AS p
JOIN car_shop.cars AS c ON c.id = p.car_id
JOIN car_shop.brands AS b ON b.id = c.brand_id
JOIN car_shop.countries AS co ON co.id = b.country_id
GROUP BY brand_origin;

-- 6. Напишите запрос, который покажет количество всех пользователей из США.
-- Это пользователи, у которых номер телефона начинается на +1.
SELECT COUNT(*) AS persons_from_usa_count
FROM car_shop.customers
WHERE phone LIKE '+1%';
