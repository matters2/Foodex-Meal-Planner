CREATE DATABASE foodex;

CREATE TABLE week_planner (
  id SERIAL PRIMARY KEY,
  day_of_week TEXT,
  breakfast TEXT,
  lunch TEXT,
  dinner TEXT
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    password_digest TEXT
  );

INSERT INTO week_planner (day_of_week) VALUES ('Monday');
INSERT INTO week_planner (day_of_week) VALUES ('Tuesday');
INSERT INTO week_planner (day_of_week) VALUES ('Wednesday');
INSERT INTO week_planner (day_of_week) VALUES ('Thursday');
INSERT INTO week_planner (day_of_week) VALUES ('Friday');
INSERT INTO week_planner (day_of_week) VALUES ('Saturday');
INSERT INTO week_planner (day_of_week) VALUES ('Sunday');

CREATE TABLE meal_details (
    id SERIAL PRIMARY KEY,
    label TEXT,
    uri TEXT
  );