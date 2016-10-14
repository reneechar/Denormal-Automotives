\c rchar

DROP USER IF EXISTS normal_user;

CREATE USER normal_user;

DROP DATABASE IF EXISTS normal_cars;

CREATE DATABASE normal_cars OWNER normal_user;

\c normal_cars


-- create denormal
\i scripts/denormal_data.sql;


--create unique make ids to add to model table
CREATE TABLE make (
  ma_title text,
  ma_code text,
  id serial PRIMARY KEY -- PK
);

CREATE TABLE model (
  mo_title text,
  mo_code text,
  year integer,
  make_id serial REFERENCES make(id), -- FK
  id serial PRIMARY KEY
);

-- insert rows into make table
INSERT INTO make
SELECT DISTINCT make_title, make_code
FROM car_models;

-- insert rows into model table
-- need to join data from car_models table and make table

-- USING SUBQUERIES
-- INSERT INTO model
--   SELECT model_title, model_code, year, id
--   FROM
--     (SELECT car_models.model_title, car_models.model_code, car_models.year, make.id
--       FROM make, car_models
--       WHERE make.ma_title = car_models.make_title) AS temp;

-- USING INNER JOIN
INSERT INTO model
  SELECT model_title, model_code, year, id
  FROM
    (SELECT
      car_models.model_code,
      car_models.model_title,
      car_models.make_title,
      car_models.year,
      make.ma_title,
      make.id
      FROM
        car_models
        INNER JOIN make ON car_models.make_title = make.ma_title
          ORDER BY car_models.year) AS joined_table;

-- SELECT ma_title
-- FROM make;

-- SELECT COUNT(ma_title)
-- FROM make;


SELECT DISTINCT mo_title
  FROM
    (SELECT
      make.ma_code,
      make.id,
      model.make_id,
      model.mo_title
      FROM
        make
        INNER JOIN model ON make.id = model.make_id) AS normal_table
    WHERE ma_code = 'VOLKS';

SELECT DISTINCT ma_code, mo_code, mo_title, year
  FROM
    (SELECT
      make.ma_code,
      model.mo_code,
      model.mo_title,
      model.year
      FROM
        make
        INNER JOIN model ON make.id = model.make_id) AS normal_table2
      WHERE ma_code = 'LAM';

SELECT COUNT(*)
  FROM (
    SELECT DISTINCT ma_code, mo_code, mo_title, year
      FROM
        (SELECT
          make.ma_code,
          model.mo_code,
          model.mo_title,
          model.year
          FROM
            make
            INNER JOIN model ON make.id = model.make_id) AS normal_table2
          WHERE ma_code = 'LAM') AS SOMETHING;


SELECT
  make.ma_code,
  make.ma_title,
  model.mo_code,
  model.mo_title,
  model.year
  FROM
    make
    INNER JOIN model ON make.id = model.make_id
  WHERE year BETWEEN 2010 AND 2015;

SELECT COUNT(*)
  FROM
    (SELECT
      make.ma_code,
      make.ma_title,
      model.mo_code,
      model.mo_title,
      model.year
      FROM
        make
        INNER JOIN model ON make.id = model.make_id) AS normal_table3
      WHERE year BETWEEN 2010 AND 2015;