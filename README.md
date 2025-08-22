# SQL-Data-Analysis-Portfolio-Project_Retail_Sales
This project analyzes a retail sales dataset using SQL. It covers data cleaning, schema creation, and business-driven queries to extract insights such as customer behavior, sales performance, and time-based trends.

## 🧱 Table Schema
```sql
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
📥 Data Import
sql
COPY (
    transactions_id, sale_date, sale_time, customer_id, gender, age,
    category, quantiy, price_per_unit, cogs, total_sale
)
FROM 'D:/SQL - Retail Sales Analysis_utf.csv'
DELIMITER ','
CSV HEADER;
🧹 Data Cleaning
Checked for nulls across all columns

Removed incomplete rows

Verified row count post-cleaning

📊 Business Questions & SQL Solutions
#	Question	Summary
Q1	Sales on a specific date	Filtered by sale_date = '2022-11-05'
Q2	Clothing sales >10 units in Nov	Used TO_CHAR and filters
Q3	Total sales by category	GROUP BY category
Q4	Avg age for Beauty buyers	WHERE category = 'Beauty'
Q5	High-value transactions	WHERE total_sale > 1000
Q6	Transactions by gender/category	GROUP BY gender, category
Q7	Avg monthly sales + best month	RANK() over CTE
Q8	Top 5 customers by sales	RANK() over SUM(total_sale)
Q9	Unique customers per category	COUNT(DISTINCT customer_id)
Q10	Shift-wise order count	EXTRACT(HOUR) + CASE logic
📈 Key Insights
Clothing and Beauty categories dominate high-value sales

Afternoon shift sees the highest order volume

Top 5 customers contribute significantly to revenue

🔧 Tools Used
PostgreSQL

SQL Window Functions

CTEs

Data Cleaning via SQL
