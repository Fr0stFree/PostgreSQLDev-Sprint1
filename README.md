# Автосалон «Врум-Бум»

## Описание проекта.

«Врум-Бум» — прославившаяся сеть салонов легковых автомобилей — стремительно набирает обороты. Их карманный слоган 
«Если вы слышите Врум, значит уже Бум!» стал знаком качества, который привлекает тысячи покупателей ежедневно.
Сеть предоставляет широкий выбор машин от экономкласса до люксовых спорткаров и обслуживает всю страну.

Однако их быстрый рост привел к непредвиденным трудностям: с каждым новым салоном становится все сложнее
управлять огромным объёмом данных о продажах, поставках, запасах и клиентах. Вся эта информация сейчас хранится в
сыром, неструктурированном виде, что сильно затрудняет работу.

Ваша задача — нормализовать и структурировать существующие сырые данные, а потом написать несколько запросов для
получения информации из БД. Для этого перенесите сырые данные в PostgreSQL. Вы можете выполнить работу в любом
удобном для вас клиенте. Результатом станет набор SQL-команд, объединённых в единый скрипт.

## Задания

### Задание 1
Напишите запрос, который выведет процент моделей машин, у которых нет параметра gasoline_consumption

### Задание 2
Напишите запрос, который покажет название бренда и среднюю цену его автомобилей в разбивке по всем годам с учётом
скидки. Итоговый результат отсортируйте по названию бренда и году в восходящем порядке.
Среднюю цену округлите до второго знака после запятой.

### Задание 3
Посчитайте среднюю цену всех автомобилей с разбивкой по месяцам в 2022 году с учётом скидки. Результат отсортируйте по 
месяцам в восходящем порядке. Среднюю цену округлите до второго знака после запятой.

### Задание 4
Используя функцию `STRING_AGG`, напишите запрос, который выведет список купленных машин у каждого пользователя через
запятую. Пользователь может купить две одинаковые машины — это нормально. Название машины покажите полное,
с названием бренда — например: Tesla Model 3. Отсортируйте по имени пользователя в восходящем порядке.
Сортировка внутри самой строки с машинами не нужна.

### Задание 5
Напишите запрос, который вернёт самую большую и самую маленькую цену продажи автомобиля с разбивкой по стране без 
учёта скидки. Цена в колонке price дана с учётом скидки.

### Задание 6
Напишите запрос, который покажет количество всех пользователей из США.
Это пользователи, у которых номер телефона начинается на +1.