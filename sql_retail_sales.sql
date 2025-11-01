-- create database sales_analysis;
use sales_analysis;

-- drop table if exists retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(6),
    age INT,
    category VARCHAR(15),
    quantiy INT NULL,
    price_per_unit DOUBLE,
    cogs FLOAT NULL,
    total_sale INT NULL
);

-- Data Exploration
SELECT 
    *
FROM
    retail_sales
LIMIT 10;

-- Check if data has any null/0 values
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id = 0
        OR gender IS NULL
        OR age = 0
        OR category IS NULL
        OR quantiy = 0
        OR price_per_unit = 0
        OR cogs = 0
        OR total_sale = 0;
        
alter table retail_sales
rename column quantiy to quantity;

-- Delete rows we wont need 
start transaction;
DELETE FROM retail_sales 
WHERE
    transactions_id IN (679 , 746, 1225);

commit;
rollback;

-- Check if correct rows were deleted
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IN (679 , 746, 1225);
SELECT 
    COUNT(*)
FROM
    retail_sales;

-- get average age of male where the category is clothing
SELECT 
    @avg_agem1:=AVG(age)
FROM
    retail_sales
WHERE
    gender = 'male'
        AND category = 'Clothing';

start transaction;
UPDATE retail_sales 
SET 
    age = @avg_agem1
WHERE
    gender = 'male' AND age = 0
        AND category = 'Clothing';

SELECT 
    *
FROM
    retail_sales
WHERE
    gender = 'male' AND age = 0;
commit;
rollback;

-- get average age of male where the category is Beauty
SELECT 
    @avg_agem2:=AVG(age)
FROM
    retail_sales
WHERE
    gender = 'male' AND category = 'Beauty';

start transaction;
UPDATE retail_sales 
SET 
    age = @avg_agem2
WHERE
    gender = 'male' AND age = 0
        AND category = 'Beauty';

SELECT 
    *
FROM
    retail_sales
WHERE
    gender = 'male' AND age = 0;
commit;

rollback;

-- get average age of male where the category is Electronics
SELECT 
    @avg_agem3:=AVG(age)
FROM
    retail_sales
WHERE
    gender = 'male'
        AND category = 'Electronics';

start transaction;
UPDATE retail_sales 
SET 
    age = @avg_agem3
WHERE
    gender = 'male' AND age = 0
        AND category = 'Electronics';

SELECT 
    *
FROM
    retail_sales
WHERE
    gender = 'male' AND age = 0;
commit;
rollback;
-- if age at category = 0 update and set the age to its variable (Check if you can do the above queries using if statement

SELECT 
    @avg_f_age:=AVG(age)
FROM
    retail_sales
WHERE
    category = 'Electronics';
    
start transaction;
UPDATE retail_sales 
SET 
    age = @avg_f_age
WHERE
    age = 0 AND category = 'Electronics';

commit;
rollback;

-- How many sales we have?
SELECT 
    COUNT(*)
FROM
    retail_sales;

-- How many uniuque customers we have ?
SELECT 
    COUNT(DISTINCT customer_id)
FROM
    retail_sales;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
    
-- How mane sales were made on 2022-11-05
SELECT 
    COUNT(*)
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
    
-- Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date LIKE '%2022_11%'
        AND category = 'Clothing'
        AND quantity >= 2;
        
-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS total_sale_per_category
FROM
    retail_sales
GROUP BY category
ORDER BY total_sale_per_category ASC;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    category, AVG(age)
FROM
    retail_sales
WHERE
    category = 'Beauty'
GROUP BY category;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    transactions_id,
    sale_date,
    gender,
    age,
    category,
    total_sale
FROM
    retail_sales
WHERE
    total_sale > 1000
GROUP BY transactions_id;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    gender,
    category,
    COUNT(transactions_id) AS total_number_of_transactions
FROM
    retail_sales
GROUP BY gender , category;

-- Write a SQL query to calculate the average sale for each month. 
create table avg_sale as
SELECT 
    MONTHNAME(sale_date) AS month_name,
    year(sale_date) as `year`,
    avg(total_sale) as average_sale,
    rank() over( partition by year(sale_date) order by avg(total_sale) desc) as rank_month
FROM 
    retail_sales group by month_name, `year`;
SELECT 
    *
FROM
    avg_sale;

-- Find out best selling month in each year
SELECT 
    *
FROM
    avg_sale
WHERE
    rank_month = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    sum(total_sale) as total_sales,
    rank() over(order by sum(total_sale) desc) as top_customers
FROM
    retail_sales
group by customer_id
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS total_customers_in_each_cat
FROM
    retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(sale_time) > 17 THEN 'Evening'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS orders
FROM
    retail_sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');

-- which product category yields the highest profit margins
SELECT 
    category,
    (SUM(total_sale - cogs) / SUM(total_sale) * 100) AS profit_margin_percentage
FROM
    retail_sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;

-- which day of the week has the highest sales
SELECT DISTINCT
    DAYNAME(sale_date) AS days_of_the_week,
    SUM(total_sale) AS sales_per_day
FROM
    retail_sales
GROUP BY days_of_the_week
ORDER BY FIELD(days_of_the_week,
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday');

-- when sales peak during the day
SELECT 
    HOUR(sale_time) AS hour_of_day,
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- understand which age segment spends the most
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 50 THEN '36–50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY age_group
ORDER BY total_sales DESChow spending differs by gender
SELECT 
    gender,
    ROUND(AVG(total_sale), 2) AS avg_sale_per_transaction,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY gender;

-- the top category for male and female shoppers
WITH ranked AS (
    SELECT 
        gender,
        category,
        COUNT(*) AS total_orders,
        RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rank_in_gender
    FROM retail_sales
    GROUP BY gender, category
)
SELECT gender, category, total_orders
FROM ranked
WHERE rank_in_gender = 1;

-- month-over-month sales growth
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sales,
    LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date)) AS prev_month_sales,
    ROUND((SUM(total_sale) - LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date))) /
          LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date)) * 100, 2) AS growth_percent
FROM retail_sales
GROUP BY year, month;

-- Average order value per customer
SELECT customer_id, ROUND(AVG(total_sale),2) AS avg_order_value
FROM retail_sales
GROUP BY customer_id
ORDER BY avg_order_value DESC
LIMIT 5;

-- Category contribution to total sales (%)
SELECT 
    category,
    ROUND(SUM(total_sale) / (SELECT SUM(total_sale) FROM retail_sales) * 100, 2) AS percent_contribution
FROM retail_sales
GROUP BY category
ORDER BY percent_contribution DESC;

-- get the procr that is suspiciously high or zero.
SELECT 
    *
FROM
    retail_sales
WHERE
    price_per_unit = (SELECT 
            MAX(price_per_unit)
        FROM
            retail_sales)
        OR price_per_unit = (SELECT 
            MIN(price_per_unit)
        FROM
            retail_sales);

-- VIEWS

-- Contains only valid, cleaned sales data (filters out nulls, zeros, or invalid entries)
CREATE VIEW v_clean_sales AS
    SELECT 
        *
    FROM
        retail_sales; 

-- Adds a derived column (shift: Morning / Afternoon / Evening) based on sale_time
CREATE or replace VIEW v_sales_with_shift AS
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN HOUR(sale_time) > 17 THEN 'Evening'
            ELSE 'Evening'
        END AS shift
    FROM
        retail_sales;
 
-- Total and average sales per category.
-- Helps analyze product performance.
CREATE OR REPLACE VIEW v_category_sales_summary AS
    SELECT 
        category,
        count(*) as total_orders,
        SUM(total_sale) AS total_sales,
        round(AVG(total_sale), 2) AS average_sales_per_category
    FROM
        retail_sales
    GROUP BY category;

SELECT 
    *
FROM
    v_category_sales_summary;

-- Monthly total and average sales, grouped by year and month.
-- Supports trend and growth analysis.
CREATE OR REPLACE VIEW v_monthly_sales AS
    SELECT 
        YEAR(sale_date) year,
        MONTHNAME(sale_date) AS months,
        SUM(total_sale) AS total_sales,
        ROUND(AVG(total_sale), 2) AS average_sales
    FROM
        retail_sales
    GROUP BY YEAR(sale_date) , MONTHNAME(sale_date);

SELECT 
    *
FROM
    v_monthly_sales;

-- Shows best-performing month per year (based on total sales or rank).
CREATE OR REPLACE VIEW v_best_selling_month AS
with monthly_sales as (
    SELECT 
        YEAR(sale_date) AS year,
        MONTHNAME(sale_date) AS months,
        sum(total_sale) as total_sales
       from retail_sales group by YEAR(sale_date), MONTHNAME(sale_date)
)
select year, months, total_sales,  rank() over(partition by year order by total_sales desc) as sale_performance_per_year from monthly_sales;

SELECT 
    *
FROM
    v_best_selling_month
WHERE
    sale_performance_per_year = 1;
 
 -- Top customers ranked by total purchase amount.
CREATE OR REPLACE VIEW v_top_customers AS
with customer_sales as (
    SELECT 
        customer_id,
        sum(total_sale) as total_sales,
        count(*) as total_orders
    FROM
        retail_sales group by customer_id
)
select customer_id, total_orders, total_sales, rank() over(order by total_sales desc) as customer_sales_rank from customer_sales;

SELECT 
    *
FROM
    v_top_customers;

-- Sales and transaction counts grouped by gender and category.
-- Useful for behavioral segmentation.
CREATE OR REPLACE VIEW v_gender_category_performance AS
    SELECT 
        gender,
        category,
        COUNT(transactions_id) AS transactions,
        sum(total_sale) as total_sales
    FROM
        retail_sales
    GROUP BY gender , category;

SELECT 
    *
FROM
    v_gender_category_performance;

-- Calculates profit margin percentage for each category.
CREATE OR REPLACE VIEW v_profit_margin_by_category AS
SELECT 
    category,
    SUM(total_sale) AS total_sales,
    SUM(total_sale - cogs) AS total_profit,
    ROUND((SUM(total_sale - cogs) / SUM(total_sale)) * 100, 2) AS profit_margin_percent
FROM v_clean_sales
GROUP BY category
ORDER BY profit_margin_percent DESC;

SELECT 
    *
FROM
    v_profit_margin_by_category;
        
-- Sales aggregated by age range (e.g., 18–25, 26–35, etc.)
CREATE OR REPLACE VIEW v_age_group_sales AS
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 50 THEN '36–50'
        ELSE '50+'
    END AS age_group,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(total_sale) AS total_sales,
    ROUND(AVG(total_sale), 2) AS avg_sale
FROM v_clean_sales
GROUP BY age_group
ORDER BY total_sales DESC;

SELECT 
    *
FROM
    v_age_group_sales;

-- Total sales grouped by day of week (Monday–Sunday).
CREATE OR REPLACE VIEW v_sales_by_day AS
SELECT 
    DAYNAME(sale_date) AS day_of_week,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM v_clean_sales
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT 
    *
FROM
    v_sales_by_day;

-- Month-over-month sales growth using window functions
CREATE OR REPLACE VIEW v_monthly_growth AS
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month_number,
    MONTHNAME(sale_date) AS month_name,
    SUM(total_sale) AS total_sales,
    LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date)) AS prev_month_sales,
    ROUND(
        (SUM(total_sale) - LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date))) /
        LAG(SUM(total_sale)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date)) * 100,
        2
    ) AS growth_percent
FROM v_clean_sales
GROUP BY year, month_number, month_name;
    
SELECT 
    *
FROM
    v_monthly_growth;

-- Each customer’s total orders, total spend, and average order value.
CREATE OR REPLACE VIEW v_customer_summary AS
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    SUM(total_sale) AS total_spent,
    ROUND(AVG(total_sale), 2) AS avg_order_value
FROM v_clean_sales
GROUP BY customer_id
ORDER BY total_spent DESC;

SELECT 
    *
FROM
    v_customer_summary;

-- Each category’s % contribution to total sales
CREATE OR REPLACE VIEW v_category_contribution AS
    SELECT 
        category,
        SUM(total_sale) AS total_sales,
        ROUND(SUM(total_sale) / (SELECT 
                        SUM(total_sale)
                    FROM
                        v_clean_sales) * 100,
                2) AS percent_contribution
    FROM
        v_clean_sales
    GROUP BY category
    ORDER BY percent_contribution DESC;

SELECT 
    *
FROM
    v_category_contribution;

-- Compares total and average spending between genders
CREATE OR REPLACE VIEW v_gender_spending_comparison AS
    SELECT 
        gender,
        COUNT(*) AS total_orders,
        ROUND(AVG(total_sale), 2) AS avg_sale_per_order,
        SUM(total_sale) AS total_sales
    FROM
        v_clean_sales
    GROUP BY gender
    ORDER BY total_sales DESC;

SELECT 
    *
FROM
    v_gender_spending_comparison;

-- Lists rows failing constraints (age, price, etc.) like a quality audit table
CREATE OR REPLACE VIEW v_data_quality_issues AS
    SELECT 
        transactions_id,
        CASE
            WHEN age NOT BETWEEN 10 AND 100 THEN 'Invalid age'
            WHEN price_per_unit <= 0 THEN 'Invalid price'
            WHEN quantity <= 0 THEN 'Invalid quantity'
            WHEN total_sale <= 0 THEN 'Invalid total sale'
            ELSE 'Valid'
        END AS issue_type
    FROM
        retail_sales
    WHERE
        age NOT BETWEEN 10 AND 100
            OR price_per_unit <= 0
            OR quantity <= 0
            OR total_sale <= 0;

SELECT 
    *
FROM
    v_data_quality_issues;

-- Combines top KPIs: total sales, top category, best month, top customer, and profit margin
CREATE OR REPLACE VIEW v_kpi_dashboard AS
    SELECT 
        (SELECT 
                SUM(total_sale)
            FROM
                v_clean_sales) AS total_sales,
        (SELECT 
                COUNT(DISTINCT customer_id)
            FROM
                v_clean_sales) AS unique_customers,
        (SELECT 
                category
            FROM
                v_category_sales_summary
            LIMIT 1) AS top_category,
        (SELECT 
                months
            FROM
                v_monthly_sales
            ORDER BY total_sales DESC
            LIMIT 1) AS best_month,
        (SELECT 
                customer_id
            FROM
                v_top_customers
            ORDER BY total_sales DESC
            LIMIT 1) AS top_customer,
        (SELECT 
                ROUND(AVG(profit_margin_percent), 2)
            FROM
                v_profit_margin_by_category) AS avg_profit_margin;
    
SELECT 
    *
FROM
    v_kpi_dashboard;


