# DATA ANALYST SQL CASE STUDIES

## Introduction

Learning SQL syntax is not enough for Data Analyst interviews.

Interviewers want to know:

- Can you solve business problems?
- Can you translate requirements into SQL?
- Can you explain KPIs and metrics?
- Can you generate insights from data?

This file contains real-world Data Analyst case studies frequently asked in interviews and used in actual projects.

---

# CASE STUDY 1: E-COMMERCE ANALYSIS

## Business Objective

Analyze sales performance, customer behavior, and product performance.

---

## Tables

### customers

| Column |
|----------|
| customer_id |
| customer_name |
| city |
| signup_date |

---

### orders

| Column |
|----------|
| order_id |
| customer_id |
| order_date |
| amount |

---

### order_items

| Column |
|----------|
| order_id |
| product_id |
| quantity |
| price |

---

### products

| Column |
|----------|
| product_id |
| product_name |
| category |

---

## Q1. Total Revenue

### Business Question

How much revenue has the company generated?

### SQL

```sql
SELECT SUM(amount) AS total_revenue
FROM orders;
```

### Business Insight

```text
Measures overall business performance.
```

---

## Q2. Total Orders

```sql
SELECT COUNT(*) AS total_orders
FROM orders;
```

---

## Q3. Average Order Value (AOV)

### Formula

```text
Revenue / Orders
```

### SQL

```sql
SELECT
SUM(amount) / COUNT(order_id) AS average_order_value
FROM orders;
```

### Business Insight

```text
Average customer spend per order.
```

---

## Q4. Top 10 Customers By Revenue

```sql
SELECT customer_id,
       SUM(amount) AS revenue
FROM orders
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;
```

### Business Insight

```text
Identify high-value customers.
```

---

## Q5. Top Selling Products

```sql
SELECT product_id,
       SUM(quantity) AS total_quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY total_quantity_sold DESC;
```

---

## Q6. Revenue By Product

```sql
SELECT product_id,
       SUM(quantity * price) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC;
```

---

## Q7. Revenue By Category

```sql
SELECT p.category,
       SUM(oi.quantity * oi.price) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category;
```

---

## Q8. Repeat Customers

```sql
SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

### Business Insight

```text
Shows customer loyalty.
```

---

# CASE STUDY 2: SALES DASHBOARD ANALYSIS

## Business Objective

Create KPIs for management dashboard.

---

## Common KPIs

- Revenue
- Orders
- Customers
- Profit
- Growth %
- Average Order Value

---

## Q1. Monthly Revenue

```sql
SELECT
YEAR(order_date) AS year,
MONTH(order_date) AS month,
SUM(amount) AS revenue
FROM orders
GROUP BY
YEAR(order_date),
MONTH(order_date)
ORDER BY
year,
month;
```

---

## Q2. Month-over-Month Growth

```sql
WITH monthly_sales AS
(
    SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(amount) AS revenue
    FROM orders
    GROUP BY
    YEAR(order_date),
    MONTH(order_date)
)
SELECT *,
       revenue -
       LAG(revenue)
       OVER
       (
           ORDER BY year,month
       ) AS growth
FROM monthly_sales;
```

---

## Q3. Running Revenue

```sql
SELECT
order_date,
SUM(amount)
OVER
(
    ORDER BY order_date
) AS running_revenue
FROM orders;
```

---

# CASE STUDY 3: CUSTOMER RETENTION ANALYSIS

## Business Objective

Measure customer loyalty.

---

## Q1. New Customers

```sql
SELECT customer_id,
       MIN(order_date) AS first_purchase_date
FROM orders
GROUP BY customer_id;
```

---

## Q2. Repeat Customers

```sql
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

---

## Q3. Customer Retention Rate

### Formula

```text
Retained Customers
/
Total Customers
× 100
```

### SQL

```sql
SELECT
COUNT(DISTINCT CASE
               WHEN total_orders > 1
               THEN customer_id
              END) * 100.0
/
COUNT(DISTINCT customer_id)
AS retention_rate
FROM
(
    SELECT customer_id,
           COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
) t;
```

---

# CASE STUDY 4: MARKETING CAMPAIGN ANALYSIS

## Business Objective

Measure campaign effectiveness.

---

## Tables

### campaigns

### leads

### conversions

---

## Q1. Conversion Rate

### Formula

```text
Conversions / Leads × 100
```

### SQL

```sql
SELECT
COUNT(conversion_id) * 100.0
/
COUNT(lead_id)
AS conversion_rate
FROM campaign_data;
```

---

## Q2. Best Performing Campaign

```sql
SELECT campaign_id,
       COUNT(conversion_id) AS conversions
FROM campaign_data
GROUP BY campaign_id
ORDER BY conversions DESC;
```

---

## Q3. Campaign Revenue

```sql
SELECT campaign_id,
       SUM(revenue) AS total_revenue
FROM campaign_data
GROUP BY campaign_id;
```

---

# CASE STUDY 5: PRODUCT ANALYTICS

## Business Objective

Understand user behavior.

---

## Funnel Analysis

```text
Visitors
    ↓
Signup
    ↓
Purchase
```

---

## Q1. Funnel Numbers

```sql
SELECT
COUNT(DISTINCT visitor_id) AS visitors,
COUNT(DISTINCT signup_id) AS signups,
COUNT(DISTINCT customer_id) AS purchases
FROM funnel_data;
```

---

## Q2. Purchase Conversion Rate

```sql
SELECT
COUNT(DISTINCT customer_id) * 100.0
/
COUNT(DISTINCT visitor_id)
AS conversion_rate
FROM funnel_data;
```

---

## Q3. Drop-off Analysis

### Formula

```text
Visitors - Purchasers
```

Used to identify funnel leakage.

---

# CASE STUDY 6: HR ANALYTICS

## Business Objective

Analyze workforce data.

---

## Q1. Average Salary By Department

```sql
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;
```

---

## Q2. Highest Paying Department

```sql
SELECT department_id,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC;
```

---

## Q3. Attrition Analysis

```sql
SELECT department_id,
       COUNT(*) AS resigned_employees
FROM employees
WHERE status = 'Resigned'
GROUP BY department_id;
```

---

## Q4. Headcount By Department

```sql
SELECT department_id,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department_id;
```

---

# CASE STUDY 7: BANKING ANALYTICS

## Business Objective

Analyze customer transactions.

---

## Q1. Monthly Transaction Volume

```sql
SELECT
YEAR(transaction_date) AS year,
MONTH(transaction_date) AS month,
SUM(amount) AS total_amount
FROM transactions
GROUP BY
YEAR(transaction_date),
MONTH(transaction_date);
```

---

## Q2. Top Customers

```sql
SELECT customer_id,
       SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY customer_id
ORDER BY total_transaction_amount DESC;
```

---

## Q3. High Value Transactions

```sql
SELECT *
FROM transactions
WHERE amount > 100000;
```

### Business Use

```text
Fraud Monitoring
Risk Analysis
```

---

# CASE STUDY 8: INVENTORY ANALYTICS

## Business Objective

Track stock movement.

---

## Q1. Low Stock Products

```sql
SELECT *
FROM products
WHERE stock_quantity < 10;
```

---

## Q2. Fast Moving Products

```sql
SELECT product_id,
       SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales DESC;
```

---

## Q3. Slow Moving Products

```sql
SELECT product_id,
       SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales ASC;
```

---

# COMMON DATA ANALYST METRICS

## Revenue

```sql
SUM(revenue)
```

---

## Profit

```sql
SUM(revenue - cost)
```

---

## Average Order Value

```sql
SUM(revenue)
/ COUNT(order_id)
```

---

## Conversion Rate

```sql
Conversions
/
Visitors
× 100
```

---

## Retention Rate

```sql
Retained Customers
/
Total Customers
× 100
```

---

## Churn Rate

```sql
Lost Customers
/
Total Customers
× 100
```

---

## Customer Lifetime Value (CLV)

```text
Average Order Value
×
Purchase Frequency
×
Customer Lifespan
```

---

# INTERVIEW QUESTIONS BASED ON CASE STUDIES

## E-Commerce

1. Top Products By Revenue
2. Top Customers
3. Repeat Customers
4. Revenue Trend
5. Category Performance

---

## Marketing

1. Conversion Rate
2. Campaign ROI
3. Best Campaign
4. Lead Quality Analysis

---

## Product Analytics

1. Funnel Analysis
2. Session Analysis
3. Retention Analysis
4. User Engagement

---

## HR Analytics

1. Attrition Rate
2. Salary Analysis
3. Department Performance

---

## Banking

1. Fraud Detection
2. High Value Customers
3. Transaction Trends

---

# DATA ANALYST INTERVIEW FRAMEWORK

When solving business problems:

### Step 1

Understand KPI

```text
Revenue?
Retention?
Conversion?
Profit?
```

---

### Step 2

Identify Tables

```text
Fact Tables
Dimension Tables
```

---

### Step 3

Write SQL

```text
Joins
Aggregations
Window Functions
```

---

### Step 4

Generate Insights

Example:

```text
Revenue increased 15%

Top 10 customers contribute 40% revenue

Retention dropped 8%
```

---

# FINAL SUMMARY

A Data Analyst is expected to:

✅ Write SQL Queries

✅ Build KPIs

✅ Analyze Business Performance

✅ Explain Metrics

✅ Generate Insights

✅ Communicate Findings

Mastering these case studies prepares you for real-world analytics projects and Data Analyst interviews.
