# ADVANCED SQL INTERVIEW PROBLEMS

## Introduction

This file contains the most frequently asked SQL interview questions for:

- Data Analyst
- BI Developer
- Analytics Engineer
- SQL Developer
- Data Engineer

The goal is not only to memorize solutions but also to understand the pattern behind each problem.

---

# Problem Solving Framework

Before solving any SQL problem:

### Step 1: Understand Requirement

Ask:

```text
What exactly is being asked?
```

Examples:

- Highest Salary?
- Second Highest Salary?
- Top 3 Per Department?
- Running Total?
- Duplicate Records?

---

### Step 2: Identify SQL Concept

| Requirement | SQL Concept |
|------------|------------|
| Ranking | Window Functions |
| Aggregation | GROUP BY |
| Duplicate Detection | GROUP BY / ROW_NUMBER |
| Consecutive Records | Gaps & Islands |
| Parent Child Data | Self Join |
| Running Calculations | Window Functions |

---

### Step 3: Write Query

### Step 4: Optimize Query

### Step 5: Explain Query

Interviewers often care more about explanation than syntax.

---

# 1. Highest Salary

## Question

Find highest salary from employees table.

### Solution

```sql
SELECT MAX(salary)
FROM employees;
```

---

# 2. Second Highest Salary

## Approach 1

```sql
SELECT MAX(salary)
FROM employees
WHERE salary <
(
    SELECT MAX(salary)
    FROM employees
);
```

---

## Approach 2 (Recommended)

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 2;
```

---

# 3. Nth Highest Salary

Example: 5th Highest Salary

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 5;
```

---

# 4. Top 3 Salaries

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk <= 3;
```

---

# 5. Top N Salary Per Department

## Question

Find top 3 salaries in each department.

### Solution

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk <= 3;
```

---

# 6. Employees Earning More Than Department Average

```sql
SELECT *
FROM employees e
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);
```

---

# 7. Find Duplicate Records

## Question

Find duplicate emails.

### Solution

```sql
SELECT email,
       COUNT(*) AS total_count
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;
```

---

# 8. Remove Duplicate Records

## Question

Delete duplicate rows while keeping one record.

### Solution

```sql
WITH cte AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY email
               ORDER BY employee_id
           ) AS rn
    FROM employees
)
DELETE
FROM cte
WHERE rn > 1;
```

---

# 9. Running Total

## Question

Calculate cumulative salary.

### Solution

```sql
SELECT employee_id,
       salary,
       SUM(salary)
       OVER
       (
           ORDER BY employee_id
       ) AS running_total
FROM employees;
```

---

# Example

| Salary | Running Total |
|----------|----------|
| 1000 | 1000 |
| 2000 | 3000 |
| 3000 | 6000 |

---

# 10. Moving Average

## Question

Calculate rolling average.

### Solution

```sql
SELECT employee_id,
       salary,
       AVG(salary)
       OVER
       (
           ORDER BY employee_id
           ROWS BETWEEN 2 PRECEDING
           AND CURRENT ROW
       ) AS moving_avg
FROM employees;
```

---

# 11. Latest Record Per Customer

## Question

Find latest order for every customer.

### Solution

```sql
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

---

# 12. First Order Per Customer

```sql
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY order_date
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

---

# 13. Customers With No Orders

## Question

Find customers who never placed an order.

### Solution

```sql
SELECT c.*
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

---

# 14. Find Missing IDs

## Example

IDs:

```text
1
2
3
5
6
```

Missing:

```text
4
```

### Solution

```sql
SELECT e1.id + 1 AS missing_id
FROM employees e1
WHERE NOT EXISTS
(
    SELECT 1
    FROM employees e2
    WHERE e2.id = e1.id + 1
);
```

---

# 15. Employee Manager Relationship

## Question

Display employee and manager name.

### Solution

```sql
SELECT e.employee_name,
       m.employee_name AS manager_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
```

---

# Self Join Concept

```text
Employees Table
       ↓
Join With Same Table
       ↓
Manager Information
```

---

# 16. Department With Highest Average Salary

```sql
SELECT *
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary,
           DENSE_RANK() OVER
           (
               ORDER BY AVG(salary) DESC
           ) AS rnk
    FROM employees
    GROUP BY department_id
) t
WHERE rnk = 1;
```

---

# 17. Second Highest Salary Per Department

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 2;
```

---

# 18. Percentage Contribution

## Question

Calculate salary contribution percentage.

### Solution

```sql
SELECT employee_id,
       salary,
       ROUND
       (
           salary * 100.0 /
           SUM(salary) OVER(),
           2
       ) AS contribution_pct
FROM employees;
```

---

# 19. Pivot Data

## Convert Rows Into Columns

```sql
SELECT
SUM(CASE WHEN department_id = 10 THEN salary END) AS dept_10,
SUM(CASE WHEN department_id = 20 THEN salary END) AS dept_20,
SUM(CASE WHEN department_id = 30 THEN salary END) AS dept_30
FROM employees;
```

---

# 20. Unpivot Data

## Convert Columns Into Rows

Commonly used in BI and Reporting.

---

# 21. Gaps and Islands

## Most Famous SQL Interview Question

### Use Cases

- Consecutive Login Days
- Consecutive Orders
- Continuous Transactions

---

## Core Concept

```sql
Date - ROW_NUMBER()
```

Used to identify consecutive groups.

---

# 22. Consecutive Login Days

```sql
SELECT *
FROM
(
    SELECT user_id,
           login_date,
           login_date -
           ROW_NUMBER() OVER
           (
               PARTITION BY user_id
               ORDER BY login_date
           ) AS grp
    FROM logins
) t;
```

---

# 23. Rank Employees

```sql
SELECT *,
       RANK() OVER
       (
           ORDER BY salary DESC
       ) AS employee_rank
FROM employees;
```

---

# 24. Dense Rank Employees

```sql
SELECT *,
       DENSE_RANK() OVER
       (
           ORDER BY salary DESC
       ) AS employee_rank
FROM employees;
```

---

# 25. Find Previous Salary

Using LAG()

```sql
SELECT employee_id,
       salary,
       LAG(salary)
       OVER
       (
           ORDER BY employee_id
       ) AS previous_salary
FROM employees;
```

---

# 26. Find Next Salary

Using LEAD()

```sql
SELECT employee_id,
       salary,
       LEAD(salary)
       OVER
       (
           ORDER BY employee_id
       ) AS next_salary
FROM employees;
```

---

# Frequently Asked SQL Patterns

## Ranking Problems

Use:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

---

## Running Calculations

Use:

```sql
SUM() OVER()
AVG() OVER()
```

---

## Previous / Next Row

Use:

```sql
LAG()
LEAD()
```

---

## Group Analysis

Use:

```sql
GROUP BY
HAVING
```

---

## Duplicate Removal

Use:

```sql
ROW_NUMBER()
```

---

# SQL Coding Interview Checklist

## Salary Problems

✅ Highest Salary

✅ Second Highest Salary

✅ Nth Highest Salary

✅ Top N Salaries

---

## Window Functions

✅ ROW_NUMBER

✅ RANK

✅ DENSE_RANK

✅ LAG

✅ LEAD

---

## Joins

✅ Self Join

✅ Left Join

✅ Anti Join

---

## Aggregations

✅ GROUP BY

✅ HAVING

✅ Percentage Contribution

---

## Real Business Problems

✅ Running Total

✅ Moving Average

✅ Latest Record

✅ First Record

✅ Duplicate Records

✅ Missing Values

✅ Gaps And Islands

---

# Interview Tips

### Always Clarify

Ask:

```text
Should duplicates be considered?
```

---

### Explain Your Logic

Interviewers evaluate thought process.

---

### Discuss Alternatives

Example:

```text
Subquery Solution
Window Function Solution
```

---

### Mention Optimization

Example:

```text
Index on employee_id
Index on department_id
```

---
---

# ADDITIONAL ADVANCED SQL INTERVIEW PROBLEMS

These are frequently asked in Data Analyst, BI Developer, Analytics Engineer, Product Analyst, and Data Engineer interviews.

---

# 27. Highest Salary in Each Department

## Question

Find the employee(s) with the highest salary in every department.

### Solution

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 1;
```

### Explanation

```text
PARTITION BY department_id
→ Creates ranking within each department

ORDER BY salary DESC
→ Highest salary gets rank 1

Filter rank = 1
→ Returns highest salary employee(s)
```

---

# 28. Employees Having Same Salary

## Question

Find salaries assigned to multiple employees.

### Solution

```sql
SELECT salary,
       COUNT(*) AS employee_count
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;
```

---

# 29. Departments Having More Than N Employees

## Question

Find departments having more than 5 employees.

### Solution

```sql
SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

---

# 30. Find Odd and Even Records

## Odd Records

```sql
SELECT *
FROM employees
WHERE employee_id % 2 = 1;
```

## Even Records

```sql
SELECT *
FROM employees
WHERE employee_id % 2 = 0;
```

### Explanation

```text
Odd Number → Remainder = 1
Even Number → Remainder = 0
```

---

# 31. Swap Values in a Column

## Question

Swap Male and Female values.

### Solution

```sql
UPDATE employees
SET gender =
CASE
    WHEN gender = 'M' THEN 'F'
    WHEN gender = 'F' THEN 'M'
END;
```

---

# 32. Employees Joined in Last 30 Days

## PostgreSQL / MySQL

```sql
SELECT *
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '30 DAY';
```

## SQL Server

```sql
SELECT *
FROM employees
WHERE hire_date >= DATEADD(DAY,-30,GETDATE());
```

---

# 33. Month-over-Month Growth (MoM)

## Question

Calculate monthly revenue growth.

### Solution

```sql
SELECT month,
       revenue,
       revenue -
       LAG(revenue)
       OVER(ORDER BY month) AS growth
FROM sales;
```

### Explanation

```text
Current Month Revenue
-
Previous Month Revenue
=
Growth
```

---

# 34. Year-over-Year Growth (YoY)

### Solution

```sql
SELECT year,
       revenue,
       revenue -
       LAG(revenue)
       OVER(ORDER BY year) AS yoy_growth
FROM sales;
```

---

# 35. Running Difference

## Question

Find salary difference from previous employee.

### Solution

```sql
SELECT employee_id,
       salary,
       salary -
       LAG(salary)
       OVER(ORDER BY employee_id) AS salary_difference
FROM employees;
```

---

# 36. Median Salary

## Question

Find median salary.

### Solution

```sql
SELECT PERCENTILE_CONT(0.5)
WITHIN GROUP
(
    ORDER BY salary
)
OVER() AS median_salary
FROM employees;
```

### Explanation

```text
50th Percentile = Median
```

---

# 37. Consecutive Duplicate Values

## Question

Identify repeated consecutive values.

### Example

```text
A
A
B
B
B
C
```

### Solution

```sql
SELECT id,
       value,
       LAG(value)
       OVER(ORDER BY id) AS previous_value
FROM records;
```

---

# 38. Gap Between Transactions

## Question

Find gap between consecutive transactions.

### Solution

```sql
SELECT transaction_id,
       transaction_date,
       DATEDIFF
       (
           DAY,
           LAG(transaction_date)
           OVER(ORDER BY transaction_date),
           transaction_date
       ) AS gap_days
FROM transactions;
```

---

# 39. First and Last Transaction Per Customer

## First Transaction

```sql
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY transaction_date
           ) AS rn
    FROM transactions
) t
WHERE rn = 1;
```

## Last Transaction

```sql
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY transaction_date DESC
           ) AS rn
    FROM transactions
) t
WHERE rn = 1;
```

---

# 40. Top Selling Product

### Solution

```sql
SELECT product_id,
       SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales DESC;
```

### Top Product Only

```sql
SELECT product_id,
       SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 1;
```

---

# 41. Employee Hierarchy (Recursive CTE)

## Question

Display complete reporting hierarchy.

### Solution

```sql
WITH RECURSIVE employee_hierarchy AS
(
    SELECT employee_id,
           employee_name,
           manager_id,
           1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id,
           e.employee_name,
           e.manager_id,
           h.level + 1
    FROM employees e
    JOIN employee_hierarchy h
    ON e.manager_id = h.employee_id
)
SELECT *
FROM employee_hierarchy;
```

### Explanation

```text
CEO
 ↓
Manager
 ↓
Employee
 ↓
Subordinate
```

---

# 42. Generate Numbers 1 to 100

### Solution

```sql
WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 100
)
SELECT *
FROM numbers;
```

---

# 43. Customer Retention Analysis

## Question

Find customers who made repeat purchases.

### Solution

```sql
SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

### Business Meaning

```text
Customer purchased more than once.
```

---

# 44. Funnel Analysis

## Example Funnel

```text
Visit
 ↓
Signup
 ↓
Purchase
```

### Solution

```sql
SELECT
COUNT(DISTINCT visitor_id) AS visitors,
COUNT(DISTINCT signup_id) AS signups,
COUNT(DISTINCT customer_id) AS purchasers
FROM funnel_data;
```

### Business Use

```text
Measure conversion rates between stages.
```

---

# 45. Cohort Analysis

## Question

Track customer behavior over time.

### Example

```text
January Customers
     ↓
How many returned in February?
```

Commonly used in:

- Product Analytics
- Marketing Analytics
- Subscription Businesses

---

# MOST IMPORTANT INTERVIEW PATTERNS

## Ranking

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

---

## Previous / Next Row

```sql
LAG()
LEAD()
```

---

## Running Calculations

```sql
SUM() OVER()
AVG() OVER()
```

---

## Hierarchies

```sql
Recursive CTE
```

---

## Duplicate Handling

```sql
ROW_NUMBER()
GROUP BY
HAVING
```

---

# FINAL ADVANCED SQL CHECKLIST

## Salary Problems

✅ Highest Salary

✅ Nth Highest Salary

✅ Highest Salary Per Department

✅ Second Highest Salary Per Department

---

## Window Functions

✅ ROW_NUMBER

✅ RANK

✅ DENSE_RANK

✅ LAG

✅ LEAD

---

## Running Calculations

✅ Running Total

✅ Moving Average

✅ Running Difference

---

## Business Analytics Problems

✅ Retention Analysis

✅ Funnel Analysis

✅ Cohort Analysis

✅ MoM Growth

✅ YoY Growth

---

## Hierarchy Problems

✅ Employee Hierarchy

✅ Recursive CTE

---

## Data Cleaning Problems

✅ Duplicate Records

✅ Remove Duplicates

✅ Missing Values

---

## Advanced SQL Patterns

✅ Gaps and Islands

✅ Consecutive Records

✅ Median

✅ Transaction Gaps

✅ Pivot

✅ Unpivot

---
---

# 46. Sessionization

## Question

Group user activities into sessions.

### Example

```text
User A

10:00
10:05
10:10

Gap > 30 Minutes

11:00
11:05
```

Expected:

```text
Session 1
Session 2
```

### Solution

```sql
WITH session_data AS
(
    SELECT *,
           CASE
               WHEN TIMESTAMPDIFF
               (
                   MINUTE,
                   LAG(event_time)
                   OVER
                   (
                       PARTITION BY user_id
                       ORDER BY event_time
                   ),
                   event_time
               ) > 30
               OR LAG(event_time)
               OVER
               (
                   PARTITION BY user_id
                   ORDER BY event_time
               ) IS NULL
               THEN 1
               ELSE 0
           END AS new_session
    FROM user_activity
)
SELECT *
FROM session_data;
```

### Business Use Cases

- Website Analytics
- Mobile App Analytics
- Product Analytics

---

# 47. Market Basket Analysis

## Question

Find products frequently purchased together.

### Solution

```sql
SELECT a.product_id AS product_1,
       b.product_id AS product_2,
       COUNT(*) AS purchase_frequency
FROM sales a
JOIN sales b
ON a.order_id = b.order_id
AND a.product_id < b.product_id
GROUP BY
    a.product_id,
    b.product_id
ORDER BY purchase_frequency DESC;
```

### Business Use Cases

```text
Amazon Recommendations

People who bought:
Laptop

Also bought:
Mouse
Keyboard
```

---

# 48. Pareto Analysis (80/20 Rule)

## Question

Identify customers contributing most revenue.

### Solution

```sql
WITH revenue_data AS
(
    SELECT customer_id,
           revenue,
           SUM(revenue)
           OVER
           (
               ORDER BY revenue DESC
           ) AS running_revenue,
           SUM(revenue)
           OVER() AS total_revenue
    FROM customer_sales
)
SELECT *,
       ROUND
       (
           running_revenue * 100.0 /
           total_revenue,
           2
       ) AS cumulative_percentage
FROM revenue_data;
```

### Business Meaning

```text
20% Customers
Generate
80% Revenue
```

---

# 49. Data Reconciliation

## Question

Find records existing in one table but missing in another.

### Solution

```sql
SELECT *
FROM source_table s
LEFT JOIN target_table t
ON s.id = t.id
WHERE t.id IS NULL;
```

### Use Cases

- ETL Validation
- Data Migration
- Data Warehouse Testing

---

# 50. Data Quality Checks

## Null Check

```sql
SELECT *
FROM employees
WHERE salary IS NULL;
```

---

## Duplicate Check

```sql
SELECT employee_id,
       COUNT(*)
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;
```

---

## Invalid Data Check

```sql
SELECT *
FROM employees
WHERE salary < 0;
```

---

## Future Date Check

```sql
SELECT *
FROM employees
WHERE hire_date > CURRENT_DATE;
```

---

### Business Use Cases

```text
ETL Validation

Data Quality Monitoring

Reporting Accuracy
```

---

# 51. Change Data Capture (CDC)

## Question

Identify inserted, updated, and deleted records.

### New Records

```sql
SELECT *
FROM new_table n
LEFT JOIN old_table o
ON n.id = o.id
WHERE o.id IS NULL;
```

---

### Deleted Records

```sql
SELECT *
FROM old_table o
LEFT JOIN new_table n
ON o.id = n.id
WHERE n.id IS NULL;
```

---

### Updated Records

```sql
SELECT *
FROM new_table n
JOIN old_table o
ON n.id = o.id
WHERE n.salary <> o.salary;
```

### Use Cases

- Incremental Loading
- Data Pipelines
- Data Warehousing

---

# 52. Slowly Changing Dimensions (SCD)

## SCD Type 1

Overwrite old value.

### Example

```text
Old City = Delhi

New City = Mumbai
```

Result:

```text
Mumbai
```

Old value lost.

---

## SCD Type 2

Maintain history.

### Example

| Customer | City | Start Date | End Date |
|----------|------|------------|----------|
| 101 | Delhi | 2023-01-01 | 2024-06-30 |
| 101 | Mumbai | 2024-07-01 | NULL |

### Benefits

```text
Complete Historical Tracking
```

### Common Data Engineering Question

Difference between:

```text
SCD Type 1
vs
SCD Type 2
```

---

# 53. Event Stream Analysis

## Question

Calculate time between events.

### Solution

```sql
SELECT user_id,
       event_time,
       TIMESTAMPDIFF
       (
           MINUTE,
           LAG(event_time)
           OVER
           (
               PARTITION BY user_id
               ORDER BY event_time
           ),
           event_time
       ) AS gap_minutes
FROM events;
```

---

## Use Cases

- User Journey Analysis
- Product Analytics
- Clickstream Analysis

---

# 54. SQL Business Case Studies

## E-Commerce

### Questions

- Top Selling Products
- Repeat Customers
- Average Order Value
- Customer Lifetime Value

---

## Banking

### Questions

- Monthly Balance
- Transaction Monitoring
- Fraud Detection

---

## HR Analytics

### Questions

- Employee Attrition
- Salary Trends
- Department Analysis

---

## Marketing Analytics

### Questions

- Campaign ROI
- Customer Retention
- Funnel Conversion

---

# ADVANCED INTERVIEW TIPS

## When You See Ranking

Think:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

---

## When You See Previous Row

Think:

```sql
LAG()
```

---

## When You See Next Row

Think:

```sql
LEAD()
```

---

## When You See Running Calculation

Think:

```sql
SUM() OVER()
AVG() OVER()
```

---

## When You See Hierarchy

Think:

```sql
Recursive CTE
```

---

## When You See Consecutive Records

Think:

```sql
Gaps and Islands
```

---

# ULTIMATE SQL INTERVIEW CHECKLIST

## Window Functions

✅ ROW_NUMBER

✅ RANK

✅ DENSE_RANK

✅ LAG

✅ LEAD

---

## Joins

✅ Inner Join

✅ Left Join

✅ Right Join

✅ Full Join

✅ Self Join

---

## Advanced SQL

✅ CTE

✅ Recursive CTE

✅ Views

✅ Triggers

✅ Stored Procedures

---

## Analytics Problems

✅ Running Total

✅ Moving Average

✅ Retention Analysis

✅ Funnel Analysis

✅ Cohort Analysis

---

## Data Engineering Problems

✅ CDC

✅ SCD

✅ Reconciliation

✅ Data Quality Checks

---

## Product Analytics Problems

✅ Sessionization

✅ Event Analysis

✅ Funnel Analysis


# FINAL SUMMARY

These problems cover most SQL interview rounds.

Master these patterns:

- Ranking
- Window Functions
- Joins
- Aggregations
- Running Totals
- Duplicate Handling
- Gaps & Islands

If you can solve these independently, you are well prepared for SQL interviews in Data Analyst, BI Developer, Analytics Engineer, SQL Developer, and Data Engineer roles.
