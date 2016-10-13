\c rchar;

DROP USER IF EXISTS denormal_user;

CREATE USER denormal_user;

DROP DATABASE IF EXISTS denormal_cars;

CREATE DATABASE denormal_cars OWNER denormal_user;

\c denormal_cars;

\i scripts/denormal_data.sql;

\dS car_models;

SELECT DISTINCT make_title
FROM car_models;

SELECT COUNT(*)
FROM (SELECT DISTINCT make_title
FROM car_models) AS temp;

SELECT DISTINCT (model_title)
FROM car_models
WHERE make_code = 'VOLKS';

SELECT COUNT(*)
FROM (SELECT DISTINCT (model_title)
FROM car_models
WHERE make_code = 'VOLKS') AS temp1;

SELECT make_code,model_code, model_title, year
FROM car_models
WHERE make_code = 'LAM';

SELECT COUNT(*)
FROM (SELECT make_code,model_code, model_title, year
FROM car_models
WHERE make_code = 'LAM') AS temp2;

SELECT *
FROM car_models
WHERE year >= 2010 AND year <= 2015;

SELECT COUNT(*)
FROM car_models
WHERE year >= 2010 AND year <= 2015;
