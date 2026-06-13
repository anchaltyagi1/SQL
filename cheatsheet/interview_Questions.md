# SQL 50 REAL INTERVIEW ASSESSMENTS

## Introduction

This file contains real SQL assessments commonly asked in:

- Data Analyst Interviews
- BI Developer Interviews
- Analytics Engineer Interviews
- SQL Developer Interviews
- Data Engineer Interviews

Each assessment includes:

- Business Problem
- SQL Solution
- Explanation
- Interview Discussion

---

# SECTION 1: BASIC SQL ASSESSMENTS (1–10)

---

# Assessment 1: Employees Earning More Than 50,000

## Business Problem

Find employees whose salary is greater than 50,000.

### SQL

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

### Concepts Tested

- SELECT
- WHERE

### Interview Follow-up

How would you find employees earning between 50,000 and 100,000?

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 50000 AND 100000;
```

---

# Assessment 2: Employees From Specific Departments

## Business Problem

Find employees working in departments 10, 20, and 30.

### SQL

```sql
SELECT *
FROM employees
WHERE department_id IN (10,20,30);
```

### Concepts Tested

- IN Operator

### Alternative

```sql
WHERE department_id = 10
OR department_id = 20
OR department_id = 30;
```

---

# Assessment 3: Employees Whose Name Starts With A

## Business Problem

Find all employees whose names start with letter A.

### SQL

```sql
SELECT *
FROM employees
WHERE employee_name LIKE 'A%';
```

### Concepts Tested

- LIKE
- Wildcards

### Wildcard Quick Notes

```text
A%      Starts with A
%A      Ends with A
%A%     Contains A
_A%     Second character A
```

---

# Assessment 4: Count Total Employees

## Business Problem

Find total employees in the organization.

### SQL

```sql
SELECT COUNT(*) AS total_employees
FROM employees;
```

### Concepts Tested

- COUNT()

### Difference

```sql
COUNT(*)
COUNT(column_name)
```

Interview favorite question.

---

# Assessment 5: Department Wise Employee Count

## Business Problem

Find employee count in each department.

### SQL

```sql
SELECT department_id,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department_id;
```

### Concepts Tested

- GROUP BY
- Aggregation

---

# Assessment 6: Departments Having More Than 5 Employees

## Business Problem

Find departments with more than 5 employees.

### SQL

```sql
SELECT department_id,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

### Concepts Tested

- HAVING
- GROUP BY

### Interview Question

Difference between:

```sql
WHERE
HAVING
```

Answer:

```text
WHERE filters rows

HAVING filters groups
```

---

# Assessment 7: Highest Salary

## Business Problem

Find highest salary.

### SQL

```sql
SELECT MAX(salary) AS highest_salary
FROM employees;
```

### Concepts Tested

- MAX()

---

# Assessment 8: Average Salary By Department

## Business Problem

Find average salary in each department.

### SQL

```sql
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;
```

### Concepts Tested

- AVG()
- GROUP BY

---

# Assessment 9: Sort Employees By Salary

## Business Problem

Display employees from highest salary to lowest salary.

### SQL

```sql
SELECT *
FROM employees
ORDER BY salary DESC;
```

### Concepts Tested

- ORDER BY

### Variations

```sql
ORDER BY salary ASC

ORDER BY salary DESC
```

---

# Assessment 10: Top 5 Highest Paid Employees

## Business Problem

Find top 5 highest-paid employees.

### MySQL / PostgreSQL

```sql
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

### SQL Server

```sql
SELECT TOP 5 *
FROM employees
ORDER BY salary DESC;
```

### Concepts Tested

- ORDER BY
- LIMIT
- TOP

---

# SECTION 1 SUMMARY

Topics Covered:

✅ SELECT

✅ WHERE

✅ IN

✅ BETWEEN

✅ LIKE

✅ COUNT

✅ SUM

✅ AVG

✅ MIN

✅ MAX

✅ GROUP BY

✅ HAVING

✅ ORDER BY

✅ LIMIT

These are the most common SQL screening round questions.

---

# INTERVIEWER EXPECTATIONS

For these questions, interviewers expect:

1. Correct SQL Syntax
2. Proper Filtering Logic
3. Understanding of Aggregations
4. Understanding of GROUP BY
5. Understanding of HAVING
6. Understanding of Query Execution Order

Remember:

SQL Writing Order

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
```

SQL Execution Order

```text
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```
# SECTION 2: JOINS ASSESSMENTS (11–20)

## Introduction

Joins are among the most frequently tested SQL topics.

Interviewers use join questions to evaluate:

- Data relationships
- Business understanding
- Query writing ability
- Real-world problem solving

---

# Assessment 11: Employee and Department Details

## Business Problem

Display employee name along with department name.

### Tables

employees

| employee_id | employee_name | department_id |
|------------|------------|------------|

departments

| department_id | department_name |
|------------|------------|

### SQL

```sql
SELECT
e.employee_id,
e.employee_name,
d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
```

### Concepts Tested

- INNER JOIN
- Primary Key
- Foreign Key

---

# Assessment 12: Customers With Orders

## Business Problem

Display customers who placed at least one order.

### SQL

```sql
SELECT DISTINCT
c.customer_id,
c.customer_name
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```

### Concepts Tested

- INNER JOIN
- DISTINCT

---

# Assessment 13: Customers Without Orders

## Business Problem

Find customers who never placed an order.

### SQL

```sql
SELECT
c.customer_id,
c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

### Concepts Tested

- LEFT JOIN
- NULL Filtering
- Anti Join Pattern

### Interview Favorite

Very commonly asked.

---

# Assessment 14: All Customers and Orders

## Business Problem

Display all customers whether they ordered or not.

### SQL

```sql
SELECT
c.customer_id,
c.customer_name,
o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Concepts Tested

- LEFT JOIN

---

# Assessment 15: Departments Without Employees

## Business Problem

Find departments with no employees.

### SQL

```sql
SELECT
d.department_id,
d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;
```

### Concepts Tested

- LEFT JOIN
- Anti Join

---

# Assessment 16: Employee Manager Relationship

## Business Problem

Display employee name and manager name.

### SQL

```sql
SELECT
e.employee_name,
m.employee_name AS manager_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
```

### Concepts Tested

- SELF JOIN

### Table Structure

```text
employees

employee_id
employee_name
manager_id
```

---

# Assessment 17: Find Employees Reporting To Manager 101

### SQL

```sql
SELECT *
FROM employees
WHERE manager_id = 101;
```

### Concepts Tested

- Hierarchical Data

---

# Assessment 18: Full Customer and Order Data

## Business Problem

Display all customers and all orders.

### SQL

```sql
SELECT *
FROM customers c
FULL OUTER JOIN orders o
ON c.customer_id = o.customer_id;
```

### Concepts Tested

- FULL OUTER JOIN

### Returns

```text
Matched Records
+
Customers Without Orders
+
Orders Without Customers
```

---

# Assessment 19: Semi Join

## Business Problem

Find customers having orders.

### SQL

```sql
SELECT *
FROM customers c
WHERE EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### Concepts Tested

- EXISTS
- Semi Join

### Why EXISTS?

```text
Stops searching after first match.

Often faster than JOIN.
```

---

# Assessment 20: Anti Join Using NOT EXISTS

## Business Problem

Find customers without orders.

### SQL

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### Concepts Tested

- NOT EXISTS
- Anti Join

### Alternative

```sql
LEFT JOIN
+
IS NULL
```

---

# COMMON JOIN INTERVIEW QUESTIONS

## Difference Between INNER and LEFT JOIN

### INNER JOIN

Returns only matching rows.

```text
A ∩ B
```

### LEFT JOIN

Returns all rows from left table.

```text
A
+
Matching Rows From B
```

---

## Difference Between WHERE and ON

### ON

Used for join condition.

```sql
ON e.department_id=d.department_id
```

### WHERE

Used for filtering.

```sql
WHERE salary > 50000
```

---

## EXISTS vs IN

### EXISTS

```sql
WHERE EXISTS(...)
```

Best for:

```text
Large Datasets
Correlated Queries
```

---

### IN

```sql
WHERE department_id IN (...)
```

Best for:

```text
Small Lists
Simple Queries
```

---

## LEFT JOIN + IS NULL

Pattern:

```sql
SELECT *
FROM A
LEFT JOIN B
ON A.id = B.id
WHERE B.id IS NULL;
```

Meaning:

```text
Records present in A
but missing in B
```

---

# JOINS SUMMARY

## Joins Covered

✅ INNER JOIN

✅ LEFT JOIN

✅ RIGHT JOIN

✅ FULL JOIN

✅ SELF JOIN

✅ SEMI JOIN

✅ ANTI JOIN

---

## Real Business Questions Covered

✅ Customers With Orders

✅ Customers Without Orders

✅ Departments Without Employees

✅ Employee Manager Hierarchy

✅ Matching Records

✅ Missing Records

---

# INTERVIEW TIPS

When interviewer says:

### "Show matching records"

Think:

```sql
INNER JOIN
```

---

### "Show all records from left table"

Think:

```sql
LEFT JOIN
```

---

### "Show records not present"

Think:

```sql
LEFT JOIN + IS NULL

OR

NOT EXISTS
```

---

### "Employee Manager Relationship"

Think:

```sql
SELF JOIN
```

# SECTION 3: SUBQUERIES & CTE ASSESSMENTS (21–30)

## Introduction

This section covers some of the most frequently asked SQL interview questions.

Interviewers use these questions to evaluate:

- Problem-solving ability
- Query decomposition skills
- Understanding of nested logic
- Knowledge of CTEs and recursive queries

---

# Assessment 21: Employees Earning More Than Company Average

## Business Problem

Find employees whose salary is higher than the company average salary.

### SQL

```sql
SELECT *
FROM employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
);
```

### Concepts Tested

- Scalar Subquery
- Aggregate Functions

### Interview Follow-up

Difference between:

```sql
Subquery

vs

Window Function
```

---

# Assessment 22: Employees Earning More Than Department Average

## Business Problem

Find employees earning more than their department average.

### SQL

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

### Concepts Tested

- Correlated Subquery

### Why Correlated?

```text
Inner query depends on outer query.
```

---

# Assessment 23: Department With Highest Average Salary

## Business Problem

Find department with highest average salary.

### SQL

```sql
SELECT department_id
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) t
ORDER BY avg_salary DESC
LIMIT 1;
```

### Concepts Tested

- Derived Table
- Aggregation

---

# Assessment 24: Find Duplicate Emails

## Business Problem

Find duplicate email addresses.

### SQL

```sql
SELECT email,
       COUNT(*) AS total_count
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;
```

### Concepts Tested

- GROUP BY
- HAVING

---

# Assessment 25: Remove Duplicate Records

## Business Problem

Keep one record and remove duplicates.

### SQL

```sql
WITH duplicate_cte AS
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
FROM duplicate_cte
WHERE rn > 1;
```

### Concepts Tested

- CTE
- ROW_NUMBER()

---

# Assessment 26: Second Highest Salary

## Business Problem

Find second highest salary.

### Solution 1

```sql
SELECT MAX(salary)
FROM employees
WHERE salary <
(
    SELECT MAX(salary)
    FROM employees
);
```

### Solution 2

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

### Concepts Tested

- Subqueries
- Window Functions

---

# Assessment 27: Nth Highest Salary

## Business Problem

Find 5th highest salary.

### SQL

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

### Concepts Tested

- DENSE_RANK()

---

# Assessment 28: Customers Who Placed Orders

## Business Problem

Display customers with at least one order.

### SQL

```sql
SELECT *
FROM customers c
WHERE EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### Concepts Tested

- EXISTS

---

# Assessment 29: Customers Who Never Ordered

## Business Problem

Display customers without orders.

### SQL

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### Concepts Tested

- NOT EXISTS

---

# Assessment 30: Employee Hierarchy (Recursive CTE)

## Business Problem

Display complete reporting hierarchy.

### SQL

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

### Concepts Tested

- Recursive CTE
- Hierarchical Data

### Example Output

```text
CEO
 ├── Manager A
 │     ├── Employee 1
 │     └── Employee 2
 │
 └── Manager B
       ├── Employee 3
       └── Employee 4
```

---

# CTE CHEATSHEET

## Basic CTE

```sql
WITH emp_cte AS
(
    SELECT *
    FROM employees
)
SELECT *
FROM emp_cte;
```

---

## Multiple CTEs

```sql
WITH cte1 AS
(
    ...
),
cte2 AS
(
    ...
)
SELECT *
FROM cte2;
```

---

## Recursive CTE

```sql
WITH RECURSIVE cte_name AS
(
    Anchor Query

    UNION ALL

    Recursive Query
)
SELECT *
FROM cte_name;
```

---

# SUBQUERY CHEATSHEET

## Scalar Subquery

Returns:

```text
Single Value
```

Example:

```sql
SELECT *
FROM employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
);
```

---

## Correlated Subquery

Returns:

```text
Depends on outer query
```

Example:

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

## EXISTS

Returns:

```text
TRUE / FALSE
```

---

## NOT EXISTS

Returns:

```text
Missing Records
```

---

# INTERVIEW FAVORITES

Most frequently asked questions from this section:

✅ Second Highest Salary

✅ Nth Highest Salary

✅ Employees Above Average Salary

✅ Department Average Salary

✅ Duplicate Records

✅ Remove Duplicates

✅ EXISTS

✅ NOT EXISTS

✅ Recursive CTE

✅ Employee Hierarchy

---

# INTERVIEW TIPS

When interviewer says:

### "More than average"

Think:

```sql
Subquery
```

---

### "Duplicate Records"

Think:

```sql
GROUP BY
HAVING

or

ROW_NUMBER()
```

---

### "Nth Highest"

Think:

```sql
DENSE_RANK()
```

---

### "Hierarchy"

Think:

```sql
Recursive CTE
```

---

# SECTION 4: WINDOW FUNCTION ASSESSMENTS (31–40)

## Introduction

Window Functions are among the most important topics in modern SQL interviews.

Interviewers ask them because they help solve:

- Ranking Problems
- Running Totals
- Trend Analysis
- Time-Series Analysis
- Product Analytics Problems
- Data Engineering Problems

---

# WINDOW FUNCTION SYNTAX

```sql
function_name()
OVER
(
    PARTITION BY column_name
    ORDER BY column_name
)
```

---

# Assessment 31: Assign Row Numbers

## Business Problem

Assign a unique sequence number to every employee.

### SQL

```sql
SELECT employee_id,
       employee_name,
       ROW_NUMBER()
       OVER
       (
           ORDER BY employee_id
       ) AS row_num
FROM employees;
```

### Output Example

```text
1
2
3
4
5
```

### Concepts Tested

- ROW_NUMBER()

---

# Assessment 32: Rank Employees By Salary

## Business Problem

Rank employees by salary.

### SQL

```sql
SELECT employee_name,
       salary,
       RANK()
       OVER
       (
           ORDER BY salary DESC
       ) AS salary_rank
FROM employees;
```

### Example

```text
Salary

100000  Rank 1
90000   Rank 2
90000   Rank 2
80000   Rank 4
```

### Concepts Tested

- RANK()

---

# Assessment 33: Dense Rank Employees

## Business Problem

Rank employees without skipping ranks.

### SQL

```sql
SELECT employee_name,
       salary,
       DENSE_RANK()
       OVER
       (
           ORDER BY salary DESC
       ) AS salary_rank
FROM employees;
```

### Example

```text
Salary

100000 Rank 1
90000  Rank 2
90000  Rank 2
80000  Rank 3
```

### Concepts Tested

- DENSE_RANK()

---

# Assessment 34: Top 3 Salaries Per Department

## Business Problem

Find top 3 salaries in each department.

### SQL

```sql
SELECT *
FROM
(
    SELECT *,
           DENSE_RANK()
           OVER
           (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk <= 3;
```

### Concepts Tested

- PARTITION BY
- DENSE_RANK()

### Interview Favorite

Extremely common.

---

# Assessment 35: Previous Salary

## Business Problem

Show employee salary and previous employee salary.

### SQL

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

### Concepts Tested

- LAG()

---

# Assessment 36: Next Salary

## Business Problem

Show employee salary and next employee salary.

### SQL

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

### Concepts Tested

- LEAD()

---

# Assessment 37: Running Total

## Business Problem

Calculate cumulative revenue.

### SQL

```sql
SELECT order_date,
       amount,
       SUM(amount)
       OVER
       (
           ORDER BY order_date
       ) AS running_total
FROM orders;
```

### Example

```text
100
250
400
650
```

### Concepts Tested

- SUM() OVER()

---

# Assessment 38: Moving Average

## Business Problem

Calculate 3-day moving average.

### SQL

```sql
SELECT order_date,
       amount,
       AVG(amount)
       OVER
       (
           ORDER BY order_date
           ROWS BETWEEN 2 PRECEDING
           AND CURRENT ROW
       ) AS moving_avg
FROM orders;
```

### Concepts Tested

- Window Frame

---

# Assessment 39: Latest Record Per Customer

## Business Problem

Find latest order for every customer.

### SQL

```sql
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER()
           OVER
           (
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

### Concepts Tested

- ROW_NUMBER()
- Latest Record Pattern

### Interview Favorite

Very frequently asked.

---

# Assessment 40: Gap Between Transactions

## Business Problem

Calculate days between transactions.

### SQL

```sql
SELECT customer_id,
       transaction_date,
       DATEDIFF
       (
           transaction_date,
           LAG(transaction_date)
           OVER
           (
               PARTITION BY customer_id
               ORDER BY transaction_date
           )
       ) AS gap_days
FROM transactions;
```

### Concepts Tested

- LAG()
- Date Analysis

### Business Use Cases

```text
Customer Activity

Retention Analysis

Subscription Analytics
```

---

# WINDOW FUNCTION CHEATSHEET

## ROW_NUMBER()

Assigns unique numbers.

```sql
ROW_NUMBER()
OVER()
```

---

## RANK()

Duplicate values share rank.

Rank gaps exist.

```sql
RANK()
OVER()
```

---

## DENSE_RANK()

Duplicate values share rank.

No gaps.

```sql
DENSE_RANK()
OVER()
```

---

## LAG()

Previous row.

```sql
LAG(column)
OVER()
```

---

## LEAD()

Next row.

```sql
LEAD(column)
OVER()
```

---

## Running Total

```sql
SUM(column)
OVER()
```

---

## Running Average

```sql
AVG(column)
OVER()
```

---

# MOST COMMON INTERVIEW QUESTIONS

## Ranking Problems

Think:

```sql
ROW_NUMBER()

RANK()

DENSE_RANK()
```

---

## Previous Row

Think:

```sql
LAG()
```

---

## Next Row

Think:

```sql
LEAD()
```

---

## Running Revenue

Think:

```sql
SUM()
OVER()
```

---

## Latest Record

Think:

```sql
ROW_NUMBER()
PARTITION BY
ORDER BY DESC
```

---

## Top N Per Group

Think:

```sql
DENSE_RANK()
PARTITION BY
```

---

# INTERVIEW TIPS

### Highest Salary

Can use:

```sql
MAX()
```

or

```sql
DENSE_RANK()
```

---

### Second Highest Salary

Think:

```sql
DENSE_RANK() = 2
```

---

### Top 3 Per Department

Think:

```sql
PARTITION BY department_id
```

---

### Running Total

Think:

```sql
SUM() OVER()
```

---

### Consecutive Records

Think:

```sql
LAG()

LEAD()
```

---

# WINDOW FUNCTIONS SUMMARY

Covered:

✅ ROW_NUMBER()

✅ RANK()

✅ DENSE_RANK()

✅ LAG()

✅ LEAD()

✅ Running Totals

✅ Moving Average

✅ Latest Record

✅ Gap Analysis

✅ Top N Per Group

---
# SECTION 5: REAL BUSINESS ASSESSMENTS (41–50)

## Introduction

This final section focuses on REAL-WORLD SQL PROBLEMS used in:

- Data Analyst Interviews
- Product Analytics
- Data Engineering Interviews
- BI Dashboard Roles

These are scenario-based problems.

---

# Assessment 41: Retention Analysis

## Business Problem

Find how many customers returned after their first purchase.

### SQL

```sql
WITH first_purchase AS
(
    SELECT customer_id,
           MIN(order_date) AS first_date
    FROM orders
    GROUP BY customer_id
)
SELECT COUNT(DISTINCT o.customer_id) AS retained_customers
FROM orders o
JOIN first_purchase f
ON o.customer_id = f.customer_id
WHERE o.order_date > f.first_date;
```

### Concepts Tested

- CTE
- Join
- Retention logic

---

# Assessment 42: Monthly Retention Rate

## Business Problem

Find monthly retention rate of customers.

### SQL

```sql
SELECT
MONTH(order_date) AS month,
COUNT(DISTINCT customer_id) AS active_customers
FROM orders
GROUP BY MONTH(order_date);
```

### Concept

- Time-based grouping

---

# Assessment 43: Cohort Analysis (Basic)

## Business Problem

Group customers by first purchase month.

### SQL

```sql
WITH cohort AS
(
    SELECT customer_id,
           MIN(order_date) AS cohort_month
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM cohort;
```

### Concepts Tested

- Cohort logic
- CTE

---

# Assessment 44: Funnel Analysis

## Business Problem

Measure user journey from visit → signup → purchase.

### SQL

```sql
SELECT
COUNT(DISTINCT visitor_id) AS visits,
COUNT(DISTINCT signup_id) AS signups,
COUNT(DISTINCT customer_id) AS purchases
FROM funnel_data;
```

### Conversion Rate

```sql
SELECT
COUNT(DISTINCT customer_id) * 100.0 /
COUNT(DISTINCT visitor_id) AS conversion_rate
FROM funnel_data;
```

---

# Assessment 45: Drop-off Analysis

## Business Problem

Find users who did not complete purchase.

### SQL

```sql
SELECT *
FROM funnel_data
WHERE customer_id IS NULL;
```

### Business Insight

```text
Identifies leakage in funnel.
```

---

# Assessment 46: Revenue Growth (MoM)

## Business Problem

Calculate month-over-month revenue growth.

### SQL

```sql
WITH monthly_revenue AS
(
    SELECT
    MONTH(order_date) AS month,
    SUM(amount) AS revenue
    FROM orders
    GROUP BY MONTH(order_date)
)
SELECT month,
       revenue,
       revenue -
       LAG(revenue)
       OVER (ORDER BY month) AS growth
FROM monthly_revenue;
```

---

# Assessment 47: Customer Lifetime Value (CLV)

## Business Problem

Estimate customer value.

### Formula

```text
CLV =
AOV × Purchase Frequency × Lifespan
```

### SQL (Simplified)

```sql
SELECT customer_id,
       SUM(amount) AS lifetime_value
FROM orders
GROUP BY customer_id;
```

---

# Assessment 48: Data Quality Check

## Business Problem

Find invalid or missing data.

### SQL

```sql
SELECT *
FROM employees
WHERE salary IS NULL
   OR salary < 0;
```

### Duplicate Check

```sql
SELECT employee_id,
       COUNT(*)
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;
```

---

# Assessment 49: Change Data Capture (CDC)

## Business Problem

Find new, updated, and deleted records.

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
WHERE n.value <> o.value;
```

---

# Assessment 50: Slowly Changing Dimension (SCD Type 2)

## Business Problem

Track historical changes in customer data.

### SQL

```sql
SELECT customer_id,
       city,
       start_date,
       end_date
FROM customer_history;
```

### Concept

- Maintain history instead of overwriting

---

# FINAL SQL INTERVIEW SUMMARY

## BASIC SKILLS

- SELECT
- WHERE
- GROUP BY
- HAVING

---

## INTERMEDIATE SKILLS

- JOINS
- SUBQUERIES
- CTE
- AGGREGATES

---

## ADVANCED SKILLS

- WINDOW FUNCTIONS
- RANKING
- RUNNING TOTAL

---

## EXPERT LEVEL

- RETENTION ANALYSIS
- COHORT ANALYSIS
- FUNNEL ANALYSIS
- CDC
- SCD

---

# FINAL INTERVIEW READINESS CHECKLIST

You are ready if you can:

✅ Write SQL without help

✅ Solve business problems

✅ Explain metrics

✅ Handle joins & window functions

✅ Build KPIs

---

# COMPLETE SQL MASTERY PATH

✔ Basics SQL

✔ Intermediate SQL

✔ Joins

✔ Subqueries

✔ Window Functions

✔ CTEs

✔ Advanced Analytics

✔ Real Business Case Studies

✔ Interview Assessments (50 Questions)

---

# FINAL MESSAGE

If you understand and can solve all 50 assessments in this file, you are fully prepared for:

- Data Analyst Interviews
- BI Developer Interviews
- Analytics Engineer Roles
- SQL Developer Roles
- Data Engineering SQL Rounds

