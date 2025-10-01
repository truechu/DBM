/*** Christian Uquhart
//*** CSC 351 Database Managment Systems
//*** 30 Sept 2025
//*** Assignment 2 & Practice using the import wizard & finding data */

CREATE DATABASE IF NOT EXISTS hw2_db;
USE hw2_db;

-- Drop existing tables if re-running
DROP TABLE IF EXISTS serves;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS foods;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS chefs;

-- Chefs table
CREATE TABLE chefs (
  chefID INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialty VARCHAR(50)
);

-- Restaurants table
CREATE TABLE restaurants (
  restID INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(100)
);

-- Works table (which chef works at which restaurant)
CREATE TABLE works (
  chefID INT,
  restID INT,
  PRIMARY KEY (chefID, restID),
  FOREIGN KEY (chefID) REFERENCES chefs(chefID),
  FOREIGN KEY (restID) REFERENCES restaurants(restID)
);

-- Foods table
CREATE TABLE foods (
  foodID INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(50) NOT NULL,
  price DECIMAL(8,2) NOT NULL
);

-- Serves table (which restaurant sold which food and when)
CREATE TABLE serves (
  restID INT,
  foodID INT,
  date_sold DATE NOT NULL,
  PRIMARY KEY (restID, foodID, date_sold),
  FOREIGN KEY (restID) REFERENCES restaurants(restID),
  FOREIGN KEY (foodID) REFERENCES foods(foodID)
);

-- Assumes tables chefs, restaurants, works, foods, serves already exist and CSVs have been imported.

-- Problem 1 – Average Price of Foods at Each Restaurant
SELECT restaurants.name, AVG(foods.price)
FROM restaurants, serves, foods
WHERE restaurants.restID = serves.restID
  AND serves.foodID = foods.foodID
GROUP BY restaurants.name;

-- Problem 2 – Maximum Food Price at Each Restaurant
SELECT restaurants.name, MAX(foods.price)
FROM restaurants, serves, foods
WHERE restaurants.restID = serves.restID
  AND serves.foodID = foods.foodID
GROUP BY restaurants.name;

-- Problem 3 – Count of Different Food Types Served at Each Restaurant
SELECT restaurants.name, COUNT(DISTINCT foods.type)
FROM restaurants, serves, foods
WHERE restaurants.restID = serves.restID
  AND serves.foodID = foods.foodID
GROUP BY restaurants.name;

-- Problem 4 – Average Price of Foods Served by Each Chef
SELECT chefs.name, AVG(foods.price)
FROM chefs, works, serves, foods
WHERE chefs.chefID = works.chefID
  AND works.restID = serves.restID
  AND serves.foodID = foods.foodID
GROUP BY chefs.name;

-- Problem 5 – Restaurant with the Highest Average Food Price
SELECT restaurants.name, AVG(foods.price) AS avg_price
FROM restaurants, serves, foods
WHERE restaurants.restID = serves.restID
  AND serves.foodID = foods.foodID
GROUP BY restaurants.name
ORDER BY avg_price DESC
LIMIT 1;
