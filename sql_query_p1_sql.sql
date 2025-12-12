--TO Create Database--
--Create Database Database Name
--create Table--
CREATE TABLE retail_sale(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

);

SELECT * FROM retail_sale
LIMIT 100


SELECT 
	COUNT(*)
FROM retail_sale


SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sale



--Data Cleaning

SELECT * FROM retail_sale
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL




DELETE FROM retail_sale
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL

--DATA Exploration

--How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sale

--How many customers?
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sale

--How many categories?
SELECT DISTINCT category FROM retail_sale


--Data Analysis & Business Key Problems & Answers

--My Analysis & Findings
--Q.1 Wite a SQL query to retrieve all columns for sales made on '2022-11-05'?
--Q.2 write SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in month of nov-2022
--Q.3 write a SQL query to Calculate the total sales (total_sale) for each category.
--Q.4 write a SQL query to find the average age of customers who purchased itens from the 'Beauty' category.
--Q.5 write a SQL to find all transactions where the total_sale is greater than 100.
--Q.6 write a SQL to find total number of transactions (transaction_id) made by each gender in each category.
--Q.7 write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
--Q.8 write a SQL query to find the top 5 customers based on the highest total sales.
--Q.9 write a SQL query to find the number of unique customers who purchased items from each category.
--Q.10 write a SQL query to create each shift and number of orders (Example Morning <=12, Afternopon Between 12 & 17, evening >17).


--Q.1 Wite a SQL query to retrieve all columns for sales made on '2022-11-05'?

SELECT * 
FROM retail_sale
WHERE sale_date = '2022-11-05'

--Q.2 write SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in month of nov-2022

SELECT * 
FROM retail_sale 
WHERE category = 'Clothing'
  	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

--Q.3 write a SQL query to Calculate the total sales (total_sale) for each category.

SELECT category,
		SUM(total_sale) AS net_sale,
		COUNT(*) AS total_orders
FROM retail_sale
GROUP BY 1


--Q.4 write a SQL query to find the average age of customers who purchased itens from the 'Beauty' category.

SELECT ROUND(AVG(age)) AS avg_age
FROM retail_sale
WHERE Category = 'Beauty'


--Q.5 write a SQL to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sale
WHERE total_sale > 1000


--Q.6 write a SQL to find total number of transactions (transaction_id) made by each gender in each category.

SELECT category,
	   gender,
	   COUNT(*) AS total_trans
FROM retail_sale
GROUP BY 1 ,2
ORDER BY 1


--Q.7 write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT
	year,
	month,
	avg_sale
FROM
(
   SELECT 
   		EXTRACT(YEAR FROM sale_date) AS year,
   		EXTRACT(MONTH FROM sale_date) AS month,
   		AVG(total_sale) as avg_sale,
   		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
   FROM retail_sale
   GROUP BY 1,2
) AS t1
WHERE rank = 1


--Q.8 write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,
	   SUM(total_sale)
FROM retail_sale
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



--Q.9 write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS count_unique_cs
FROM retail_sale
GROUP BY 1

--Q.10 write a SQL query to create each shift and number of orders (Example Morning <=12, Afternopon Between 12 & 17, evening >17).

--Method-1

SELECT shift,
	   COUNT(*) AS total_orders
FROM 
(
  SELECT *,
	CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternon'
 		 ELSE 'Evening'
	END AS shift
  FROM retail_sale
)AS t2
GROUP BY 1

--Method-2

WITH hourly_sale
AS
(
 SELECT *,
	CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternon'
 		 ELSE 'Evening'
	END AS shift
  FROM retail_sale
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

--End of Project
