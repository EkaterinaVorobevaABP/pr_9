--Практическая 9
--1. Проверить наличие геопространственных данных в базе данных.
--2. Создать временную таблицу с координатами долготы и широты для каждого клиента
CREATE TEMP TABLE customer_points AS (
SELECT
customer_id,
point(longitude, latitude) AS lng_lat_point
FROM customers
WHERE longitude IS NOT NULL
AND latitude IS NOT NULL
);

SELECT * FROM customer_points;

--3. Создать аналогичную таблицу для каждого дилерского центра.
SELECT * FROM customer_points;
CREATE TEMP TABLE dealership_points AS (
SELECT
dealership_id,
point(longitude, latitude) AS lng_lat_point
FROM dealerships
);
SELECT * FROM dealership_points;
--4. Соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого
--дилерского центра (в киллометрах).

CREATE TEMP TABLE customer_dealership_distance AS (
SELECT
customer_id,
dealership_id,
c.lng_lat_point <@> d.lng_lat_point AS distance
FROM customer_points c
CROSS JOIN dealership_points d
);
SELECT * FROM customer_dealership_distance

--5. Определить ближайший дилерский центр для каждого клиента.

CREATE TEMP TABLE closest_dealerships AS (
SELECT DISTINCT ON (customer_id)
customer_id,
dealership_id,
distance
FROM customer_dealership_distance
ORDER BY customer_id, distance
);
SELECT * FROM closest_dealerships;
--6. Провести выгрузку полученного результата из временной таблицы в CSV.
--7. Построить карту клиентов и сервисных центров в облачной визуализации Yandex
--DataLence.
--8. Удалить временные таблицы.
-- 8. Удаление временных таблиц
DROP TABLE IF EXISTS customer_points;
DROP TABLE IF EXISTS dealership_points;
DROP TABLE IF EXISTS customer_dealership_distance;
DROP TABLE IF EXISTS closest_dealerships;

