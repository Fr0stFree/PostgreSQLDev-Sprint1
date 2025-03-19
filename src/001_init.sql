CREATE DATABASE sprint_1;

CREATE SCHEMA raw_data;

CREATE SCHEMA car_shop;

ALTER ROLE postgres SET search_path TO car_shop, raw_data, public;
