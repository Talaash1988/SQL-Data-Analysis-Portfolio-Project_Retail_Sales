
-- STEP 1: Create Table
CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(5),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- STEP 2: Import CSV Data
COPY (
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantiy,
    price_per_unit,
    cogs,
    total_sale
)
FROM 'D:\SQL - Retail Sales Analysis_utf .csv'
DELIMITER ','
CSV HEADER;

-- STEP 3: Initial Exploration
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;

-- STEP 4: Null Check & Data Cleaning
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- STEP 5: Basic Metrics
SELECT SUM(quantiy * price_per_unit) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) AS customer_id FROM retail_sales;
SELECT COUNT(DISTINCT category) AS unique_catgegory FROM retail_sales;

-- STEP 6: Business Questions & Analysis

-- Q1: Sales on a Specific Date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Clothing Sales >10 Units in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
  AND quantiy = 4;

-- Q3: Total Sales by Category
SELECT 
    category,
    SUM(total_sale) AS Total_Sales,
    COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category
ORDER BY SUM(total_sale) DESC;

-- Q4: Average Age of Beauty Buyers
SELECT CAST(AVG(age) AS DECIMAL(10,2)) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: High-Value Transactions
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Transactions by Gender & Category
SELECT 
    category,
    gender,
    COUNT(*) AS no_of_Transections
FROM retail_sales
GROUP BY gender, category
ORDER BY category;

-- Q7: Best Selling Month by Year
WITH CTE_Best_Selling_Month AS (
    SELECT
        TO_CHAR(sale_date, 'YYYY') AS sales_year,
        TO_CHAR(sale_date, 'Mon') AS sale_month,
        CAST(AVG(total_sale) AS DECIMAL(10,2)) AS Average_Sales,
        RANK() OVER (
            PARTITION BY TO_CHAR(sale_date, 'YYYY')
            ORDER BY AVG(total_sale) DESC
        ) AS Best_Selling_Month_rnk
    FROM retail_sales
    GROUP BY 1, 2
)
SELECT *
FROM CTE_Best_Selling_Month
WHERE Best_Selling_Month_rnk = 1;

-- Q8: Top 5 Customers by Sales
WITH cte_top_5_cust AS (
    SELECT 
        customer_id,
        SUM(total_sale) AS sales_total,
        RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rnk
    FROM retail_sales
    GROUP BY customer_id
)
SELECT 
    customer_id,
    sales_total,
    rnk
FROM cte_top_5_cust
WHERE rnk <= 5;

-- Q9: Unique Customers per Category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Shift-Wise Order Distribution
WITH CTE_Shift_Wise_Orders AS (
    SELECT 
        transactions_id,
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Working_shift
    FROM retail_sales
)
SELECT 
    Working_shift,
    COUNT(transactions_id) AS no_of_orders
FROM CTE_Shift_Wise_Orders
GROUP BY Working_shift;

-- STEP 7: Insights & Conclusions

-- 🔍 Insights:
-- 1. Clothing and Beauty categories generate the highest revenue.
-- 2. Afternoon shift records the most transactions, indicating peak shopping hours.
-- 3. Top 5 customers contribute disproportionately to total sales—ideal for loyalty targeting.
-- 4. November shows strong sales performance, especially in Clothing.
-- 5. Beauty category attracts younger customers on average.
-- 6. Gender-based purchasing patterns vary significantly across categories.

-- ✅ Conclusions:
-- - The business can optimize staffing during afternoon hours to handle peak demand.
-- - Marketing efforts should focus on high-value customers and top-selling months.
-- - Product segmentation by age and gender can improve personalization.
-- - Further analysis with time-series and visual dashboards (Power BI or Python) can enhance decision-making.












