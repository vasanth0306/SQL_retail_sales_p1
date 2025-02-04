-- SQL project p1
-- create TABLE
CREATE TABLE retail_sales(
	transactions_id	int,
	sale_date date,	
	sale_time time,	
	customer_id INT,
	gender VARCHAR(15),	
	age int,	
	category varchar(15),	
	quantiy int,
	price_per_unit float,
	cogs float,	
	total_sale float
);
select * 
from retail_sales
limit 10;

select count(*)
from retail_sales;

SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;
--
DELETE FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;

-- To check how many categories
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis and Business Problems and Answers
-- Q1. Write sql query to retreive all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT 
	*
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
	category, 
	SUM(total_sale),
	COUNT(*) AS total_order
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
	category,
	gender,
	COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY category;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
	year,
	month,
	avg_sale
FROM
(SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2) AS t1
WHERE rank = 1;
-- ORDER BY 1,3 DESC;
--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT DISTINCT
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY 1;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sales
AS
(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sales
GROUP BY shift;

-- End of Project