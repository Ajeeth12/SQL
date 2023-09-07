# DATA MART CASE STUDY BY DATA WITH DANNY

 For the Problem Statement and the Data Dictionary please go through this link
 [Case Study 5](https://8weeksqlchallenge.com/case-study-5/)

## 1. Data Cleaning

```sql
  -- Create a new table with cleaned data
  CREATE TABLE data_mart.clean_weekly_sales AS
  SELECT
    TO_DATE("week_date", 'DD/MM/YY') AS week_date,
    EXTRACT(WEEK FROM TO_DATE("week_date", 'DD/MM/YY')) AS week_number,
    EXTRACT(MONTH FROM TO_DATE("week_date", 'DD/MM/YY')) AS month_number,
    CASE
      WHEN "week_date" >= '2020-01-01' AND "week_date" <= '2020-12-31' THEN 2020
      WHEN "week_date" >= '2019-01-01' AND "week_date" <= '2019-12-31' THEN 2019
      ELSE 2018
    END AS calendar_year,
    CASE
      WHEN "segment" = '1' THEN 'Young Adults'
      WHEN "segment" = '2' THEN 'Middle Aged'
      WHEN "segment" IN ('3', '4') THEN 'Retirees'
      ELSE 'unknown'
    END AS age_band,
    CASE
      WHEN LEFT("segment", 1) = 'C' THEN 'Couples'
      WHEN LEFT("segment", 1) = 'F' THEN 'Families'
      ELSE 'unknown'
    END AS demographic,
    COALESCE("segment", 'unknown') AS segment,
    ROUND("sales"::NUMERIC / "transactions", 2) AS avg_transaction
  FROM data_mart.weekly_sales;

```

-------

## 2. Data Exploration

```sql
  
  -- What day of the week is used for each week_date value?
  SELECT week_date, EXTRACT(DOW FROM week_date) AS day_of_week
  FROM data_mart.clean_weekly_sales;
  
  -- What range of week numbers are missing from the dataset?
  SELECT generate_series(MIN(week_number), MAX(week_number)) AS missing_week_numbers
  FROM data_mart.clean_weekly_sales
  EXCEPT
  SELECT week_number
  FROM data_mart.clean_weekly_sales;
  
  -- How many total transactions were there for each year in the dataset?
  SELECT calendar_year, SUM(transactions) AS total_transactions
  FROM data_mart.clean_weekly_sales
  GROUP BY calendar_year;
  
  -- What is the total sales for each region for each month?
  SELECT calendar_year, month_number, region, SUM(sales) AS total_sales
  FROM data_mart.clean_weekly_sales
  GROUP BY calendar_year, month_number, region
  ORDER BY calendar_year, month_number, region;
  
  -- What is the total count of transactions for each platform?
  SELECT platform, SUM(transactions) AS total_transactions
  FROM data_mart.clean_weekly_sales
  GROUP BY platform;
  
  -- What is the percentage of sales for Retail vs Shopify for each month?
  SELECT calendar_year, month_number, platform,
         SUM(sales) / SUM(SUM(sales)) OVER (PARTITION BY calendar_year, month_number) * 100 AS sales_percentage
  FROM data_mart.clean_weekly_sales
  GROUP BY calendar_year, month_number, platform
  ORDER BY calendar_year, month_number, platform;
  
  -- What is the percentage of sales by demographic for each year in the dataset?
  SELECT calendar_year, demographic,
         SUM(sales) / SUM(SUM(sales)) OVER (PARTITION BY calendar_year) * 100 AS sales_percentage
  FROM data_mart.clean_weekly_sales
  GROUP BY calendar_year, demographic
  ORDER BY calendar_year, demographic;
  
  -- Which age_band and demographic values contribute the most to Retail sales?
  SELECT age_band, demographic, SUM(sales) AS total_sales
  FROM data_mart.clean_weekly_sales
  WHERE platform = 'Retail'
  GROUP BY age_band, demographic
  ORDER BY total_sales DESC
  LIMIT 1;
  
  -- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
  -- You can use the avg_transaction column to find the average transaction size for each year.
  SELECT calendar_year, platform, AVG(avg_transaction) AS avg_transaction_size
  FROM data_mart.clean_weekly_sales
  GROUP BY calendar_year, platform;

```
-------


  
