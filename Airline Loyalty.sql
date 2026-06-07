CREATE DATABASE airline_loyalty;
USE airline_loyalty;

CREATE TABLE customer_loyalty_history (
    Loyalty_Number BIGINT,
    Country TEXT,
    Province TEXT,
    City TEXT,
    Postal_Code TEXT,
    Gender TEXT,
    Education TEXT,
    Salary DOUBLE,
    Marital_Status TEXT,
    Loyalty_Card TEXT,
    CLV DOUBLE,
    Enrollment_Type TEXT,
    Enrollment_Year INT,
    Enrollment_Month INT,
    Cancellation_Year INT,
    Cancellation_Month INT
);

CREATE TABLE customer_flight_activity (
    Loyalty_Number BIGINT,
    Year INT,
    Month INT,
    Total_Flights INT,
    Distance INT,
    Points_Accumulated INT,
    Points_Redeemed INT,
    Dollar_Cost_Points_Redeemed DOUBLE
);

LOAD DATA LOCAL INFILE 'C:/Users/divya/Downloads/Airline+Loyalty+Program/Customer Loyalty History.csv'
INTO TABLE customer_loyalty_history
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;

-- Total Number of Customers
SELECT COUNT(*)
FROM customer_loyalty_history;

SELECT * 
FROM customer_loyalty_history
LIMIT 10;

LOAD DATA LOCAL INFILE 'C:/Users/divya/Downloads/Airline+Loyalty+Program/Customer Flight Activity.csv'
INTO TABLE customer_flight_activity
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Total Number of Customers 
SELECT COUNT(*)
FROM customer_flight_activity;

SELECT *
FROM customer_flight_activity
LIMIT 10;

DESCRIBE customer_loyalty_history;

DESCRIBE customer_flight_activity;

-- Check Negative Salaries of Customers
SELECT *
FROM customer_loyalty_history
WHERE salary < 0;

-- Count of Negative Salaries of Cusomers
SELECT COUNT(*)
FROM customer_loyalty_history
WHERE salary < 0;

-- Fix Negative Salaries of Customers
UPDATE customer_loyalty_history
SET salary = null
WHERE salary < 0;

-- Check Null Salaries
SELECT COUNT(*)
FROM customer_loyalty_history
WHERE salary IS NULL;

-- Average Salary of Customers
SELECT ROUND(AVG(Salary),2) AS Avg_Salary
FROM customer_loyalty_history;

-- Customer Status Analysis
SELECT
CASE
WHEN Cancellation_Year = 0 THEN 'Active'
ELSE 'Cancelled'
END AS Customer_Status,
COUNT(*) AS Total_Customers
FROM customer_loyalty_history
GROUP BY Customer_Status;

-- Queyry to check total customers
SELECT COUNT(*) AS Total_customers
FROM customer_loyalty_history;

-- Check Total Flights Book by Customers 
SELECT SUM(Total_flights) AS Total_flights
FROM customer_flight_activity;

-- Total Distance Travelled by Customers
SELECT SUM(distance) AS TOtal_distance
FROM customer_flight_activity;

-- Check Total Reward Points Earn by Customers
SELECT SUM(points_accumulated)
FROM customer_flight_activity;

-- Check Total Rewards Point Redeemed 
SELECT SUM(Points_redeemed)
FROM customer_flight_activity;

-- Customer by Loyalty Card Type
SELECT Loyalty_Card,
COUNT(*) AS Total_Customers
FROM customer_loyalty_history
GROUP BY Loyalty_Card;

-- Average CLV by Lotalty Card
SELECT Loyalty_Card,
ROUND(AVG(CLV),2) AS Avg_CLV
FROM customer_loyalty_history
GROUP BY Loyalty_Card;

-- Total Customers By Gender
SELECT gender,
COUNT(*) AS Total_customers
FROM customer_loyalty_history
GROUP BY gender;

-- Customers By Education
SELECT education,
COUNT(*) AS Total_Customers
FROM customer_loyalty_history
Group BY education;

-- Flights By Month
SELECT Month,
SUM(Total_Flights) AS Total_Flights
FROM customer_flight_activity
GROUP BY Month
ORDER BY Month;

-- Distance By Month
SELECT Month,
SUM(Distance) AS Total_Distance
FROM customer_flight_activity
GROUP BY Month
ORDER BY Month;

-- Top 10 Customers BY Flights
SELECT Loyalty_Number,
SUM(Total_Flights) AS Flights
FROM customer_flight_activity
GROUP BY Loyalty_Number
ORDER BY Flights DESC
LIMIT 10;

-- Monthly Flight Activity Trend
SELECT Month,
SUM(Points_Redeemed) AS Redeemed_Points
FROM customer_flight_activity
GROUP BY Month
ORDER BY Month;

-- % of Redeemed Point 
SELECT
ROUND(
SUM(Points_Redeemed) /
SUM(Points_Accumulated) * 100,2
) AS Redemption_Rate
FROM customer_flight_activity;

-- Total Flights by Loyalty Card
SELECT
c.Loyalty_Card,
SUM(f.Total_Flights) AS Flights
FROM customer_loyalty_history c
JOIN customer_flight_activity f
ON c.Loyalty_Number = f.Loyalty_Number
GROUP BY c.Loyalty_Card;

-- Customer Segmention Based on CLV
SELECT
Loyalty_Number,
CLV,
CASE
WHEN CLV > 8000 THEN 'High Value'
WHEN CLV > 4000 THEN 'Medium Value'
ELSE 'Low Value'
END AS Customer_Segment
FROM customer_loyalty_history;