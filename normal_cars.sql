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
  title text,
  code text,
  id serial PRIMARY KEY -- PK
);

CREATE TABLE model (
  title text,
  code text,
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

-- SELECT car_models.model_title, car_models.model_code, car_models.year, make.id
-- FROM make, car_models
-- WHERE title = make_title;


-- INSERT INTO model
--   SELECT (model_title, model_code, year, model.make_id)
--   FROM
--     (SELECT car_models.model_title, car_models.model_code, car_models.year, make.id
--       FROM make, car_models
--       WHERE make.title = car_models.make_title) AS temp;

--USING INNER JOIN


INSERT INTO model
  SELECT model_title, model_code, year, id
  FROM
    (SELECT
      car_models.model_code,
      car_models.model_title,
      car_models.make_title,
      car_models.year,
      make.title,
      make.id
      FROM
        car_models
        INNER JOIN make ON car_models.make_title = make.title
          ORDER BY car_models.year) AS joinedTable;


SELECT * FROM model;


-- SELECT * FROM model;
-- SELECT COUNT(*) FROM make;
-- SELECT COUNT(*) FROM model;



