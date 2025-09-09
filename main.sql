-- M
SELECT * from sales
SELECT * from products
SELECT * from city
SELECT * from customers

-- Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

SELECT city_name,
	   Round(population*0.25) as coffee_consumers
	   from city
	   order by coffee_consumers DESC

-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

SELECT ci.city_name , sum(s.total) as revenue from sales s 
join customers c on c.customer_id = s.customer_id
JOIN city ci on ci.city_id = c.city_id
	where sale_date >= '2023-10-01' and sale_date <= '2023-12-31'
	group by ci.city_name
	ORDER BY 2 desc

 
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?

SELECT p.product_name , count(s.sale_id) as sales_count from sales s 
RIGHT join products p on p.product_id = s.product_id
group by p.product_name
order by 2 desc

-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?

SELECT ci.city_name , sum(s.total) as revenue, count( DISTINCT c.customer_id) as total_customer,
ROUND(sum(s.total)/count(DISTINCT c.customer_id)) as AVG_sales_per_customer
from sales s 
join customers c on c.customer_id = s.customer_id
JOIN city ci on ci.city_id = c.city_id
	group by 1
	ORDER BY 4 desc

-- City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.
WITH
	CITY_TABLE AS (
		SELECT
			CI.CITY_NAME,
			ROUND(CI.POPULATION / 1000000, 2) AS POPLATION_IN_MILLION,
			ROUND(CI.POPULATION * 0.25 / 1000000, 2) AS COFFEE_CONSUMERS_IN_MILLIONS,
			CI.CITY_ID
		FROM
			CITY CI
		ORDER BY
			2 DESC
	),
	CUSTOMER_TABLE AS (
		SELECT
			CI.CITY_ID,
			COUNT(DISTINCT C.CUSTOMER_ID) AS TOTAL_CUSTOMER
		FROM
			CUSTOMERS C
			JOIN CITY CI ON CI.CITY_ID = C.CITY_ID
		GROUP BY
			1
		ORDER BY
			2 DESC
	)

SELECT
	CIT.CITY_NAME,
	CIT.POPLATION_IN_MILLION,
	CIT.COFFEE_CONSUMERS_IN_MILLIONS,
	CTT.TOTAL_CUSTOMER
FROM
	CITY_TABLE CIT
	JOIN CUSTOMER_TABLE CTT ON CIT.CITY_ID = CTT.CITY_ID


-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?



-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
SELECT ci.city_name, count(distinct s.customer_id) as unique_cutomers
from sales s 
join customers c on c.customer_id = s.customer_id
join city ci on ci.city_id = c.city_id
group by 1 order by 2 DESC

-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
WITH
	RENTC AS (
		SELECT
			CC.CITY_ID AS IDD,
			CC.ESTIMATED_RENT AS RENT
		FROM
			CITY CC
	),
	CITYY AS (
		SELECT
			CI.CITY_NAME NAMESS,
			CI.CITY_ID IDS,
			ROUND(
				SUM(S.TOTAL)::"numeric" / (1000 * COUNT(DISTINCT S.CUSTOMER_ID)),
				2
			) AS AVG_SALE_IN_THOUSANDS,
			COUNT(DISTINCT S.CUSTOMER_ID) AS UNIQUE_CUSTOERS
		FROM
			SALES S
			JOIN PRODUCTS P ON P.PRODUCT_ID = S.PRODUCT_ID
			JOIN CUSTOMERS C ON C.CUSTOMER_ID = S.CUSTOMER_ID
			JOIN CITY CI ON CI.CITY_ID = C.CITY_ID
		GROUP BY
			1,
			2
	)
SELECT
	Y.NAMESS AS CITY_NAME,
	Y.AVG_SALE_IN_THOUSANDS,
	ROUND(
		((C.RENT)::"numeric") / ((Y.UNIQUE_CUSTOERS)::"numeric"),
		2
	) AS AVG_RENT_IN_LAKHS
FROM
	CITYY AS Y
	JOIN RENTC AS C ON C.IDD = Y.IDS


-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly). city eise
with monthly_sales as(
SELECT ci.city_name, EXTRACT(month from s.sale_date) as sale_month, 
EXTRACT(year from s.sale_date) as sale_year,
sum(s.total) as total_sale,
lag(sum(s.total)) over(Partition by ci.city_name ) as prev_month_sale
from sales s 
JOIN CUSTOMERS C ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN CITY CI ON CI.CITY_ID = C.CITY_ID
group by 1,2,3  
order by 1,3,2
)
SELECT city_name, sale_month, sale_year, 
ROUND(((total_sale-prev_month_sale)::"numeric"/prev_month_sale::"numeric")*100,2) as sale_growth
from monthly_sales
where prev_month_sale is not null

-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

WITH
	RENTC AS (
		SELECT
			CC.CITY_ID AS IDD,
			CC.ESTIMATED_RENT AS RENT,
			round(cc.population * 0.25/1000000,2) as Coffee_consumer_in_milions
		FROM
			CITY CC	
	),
	CITYY AS (
		SELECT
			CI.CITY_NAME NAMESS,
			CI.CITY_ID IDS, 
			ROUND(
				SUM(S.TOTAL)::"numeric" / (1000 * COUNT(DISTINCT S.CUSTOMER_ID)),
				2
			) AS AVG_SALE_IN_THOUSANDS,
			COUNT(DISTINCT S.CUSTOMER_ID) AS UNIQUE_CUSTOERS,sum(s.total) as total_sale,
			count(distinct s.customer_id) as unique_customer
		FROM
			SALES S
			JOIN PRODUCTS P ON P.PRODUCT_ID = S.PRODUCT_ID
			JOIN CUSTOMERS C ON C.CUSTOMER_ID = S.CUSTOMER_ID
			JOIN CITY CI ON CI.CITY_ID = C.CITY_ID
		GROUP BY
			1,
			2
	)
SELECT
	Y.NAMESS AS CITY_NAME,
	unique_customer, Coffee_consumer_in_milions,
	total_sale,RENT as Total_rent, 
	Y.AVG_SALE_IN_THOUSANDS,
	ROUND(
		((C.RENT)::"numeric") / ((Y.UNIQUE_CUSTOERS)::"numeric"),
		2
	) AS AVG_RENT
FROM
	CITYY AS Y
	JOIN RENTC AS C ON C.IDD = Y.IDS
order by 4 desc limit 5

-- ###########
WITH metrics AS (
  SELECT c.city_name,
         COALESCE(SUM(s.total),0) AS total_sales,
         COUNT(DISTINCT s.customer_id) AS total_customers,
         ROUND(c.population*0.25) AS est_consumers,
         c.estimated_rent
  FROM city c
  LEFT JOIN customers cu ON cu.city_id = c.city_id
  LEFT JOIN sales s ON s.customer_id = cu.customer_id
  GROUP BY c.city_name, c.population, c.estimated_rent
)
SELECT city_name,
       total_sales, total_customers, est_consumers, estimated_rent,
       -- normalized score example
       ( (total_sales / NULLIF(GREATEST(1, (SELECT MAX(total_sales) FROM metrics)),1)) * 0.4
       + (total_customers / NULLIF(GREATEST(1, (SELECT MAX(total_customers) FROM metrics)),1)) * 0.35
       + (est_consumers / NULLIF(GREATEST(1, (SELECT MAX(est_consumers) FROM metrics)),1)) * 0.25
       ) AS market_score
FROM metrics
ORDER BY market_score DESC;
