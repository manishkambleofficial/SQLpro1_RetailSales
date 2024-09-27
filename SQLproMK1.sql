-- Drop the table if it exists (use caution)
DROP TABLE IF EXISTS RETAILSALES;

-- Create the RetailSales table
CREATE TABLE RetailSales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- View the first 10 records in the RetailSales table
SELECT * FROM RETAILSALES
LIMIT 10;

-- Count total records in the RetailSales table
SELECT COUNT(*) FROM RETAILSALES;

-- Check for records with NULL values in any critical columns
SELECT * FROM retailsales
WHERE
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- Delete records with NULL values in any critical columns
DELETE FROM retailsales
WHERE
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- Data Exploration Questions

-- 1. How many sales do we have?
SELECT COUNT(*) AS total_sale FROM retailsales;

-- 2. How many customers do we have?
SELECT COUNT(customer_id) AS totalCustomers FROM retailsales;

-- 3. How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS uniqueCustomers FROM retailsales;

-- 4. How many categories do we have?
SELECT DISTINCT(category) FROM retailsales;

-- Data Analysis Business Problems

-- 1. Retrieve all columns for sales made on 2022-11-05
SELECT *
FROM retailsales
WHERE sale_date = '2022-11-05';

-- 2. Retrieve all transactions where the category is clothing and quantity sold is more than 10 in November 2022
SELECT *
FROM retailsales
WHERE category = 'clothing'
    AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
    AND quantity > 10;

-- 3. Calculate the total sales for each category
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retailsales
GROUP BY category;

-- 4. Find the average age of customers who purchased items from the beauty category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retailsales
WHERE category = 'Beauty';

-- 5. Find all transactions where the total sale is greater than 1000
SELECT *
FROM RETAILSALES
WHERE total_sale > 1000;

-- 6. Find the total number of transactions made by each gender in each category
SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retailsales
GROUP BY category, gender
ORDER BY category;

-- 7. Calculate the average sale for each month and find the best-selling month in each year
SELECT 
    Year,
    Month,
    avgsale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS Year,
        EXTRACT(MONTH FROM sale_date) AS Month,
        AVG(total_sale) AS avgsale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM RETAILSALES
    GROUP BY Year, Month
) AS T1
WHERE rank = 1;

-- 8. Find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sale
FROM retailsales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category
SELECT
    category,
    COUNT(DISTINCT customer_id) AS distinctCustomers
FROM retailsales
GROUP BY category;

-- 10. Create each shift and count the number of orders (Morning, Afternoon, Evening)
WITH HourlySales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Shift
    FROM retailsales
)
SELECT
    Shift,
    COUNT(*) AS total_orders
FROM HourlySales
GROUP BY Shift;

-- End of Project Mk1
