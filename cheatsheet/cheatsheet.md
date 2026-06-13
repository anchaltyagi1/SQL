# SQL CHEATSHEET (BEGINNER TO ADVANCED)

## Purpose

This file is a quick revision guide covering all major SQL concepts for:

- Data Analyst
- BI Developer
- Analytics Engineer
- SQL Developer
- Data Engineer

Use it for:

✅ Interview Revision

✅ Last Minute Preparation

✅ Daily SQL Practice

---

# SQL QUERY WRITING ORDER

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT/TOP
```

---

# SQL QUERY EXECUTION ORDER

```text
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. LIMIT/TOP
```

---

# BASIC SELECT

```sql
SELECT *
FROM employees;
```

---

# FILTERING

## WHERE

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

---

## BETWEEN

```sql
WHERE salary BETWEEN 30000 AND 50000
```

---

## IN

```sql
WHERE department_id IN (10,20,30)
```

---

## LIKE

```sql
WHERE name LIKE 'A%'
```

### Wildcards

```text
%  → Any number of characters
_  → Single character
```

Examples:

```sql
LIKE 'A%'
LIKE '%A'
LIKE '%A%'
LIKE '_A%'
```

---

## NULL

```sql
WHERE salary IS NULL

WHERE salary IS NOT NULL
```

---

# SORTING

```sql
ORDER BY salary DESC
```

---

# DISTINCT

```sql
SELECT DISTINCT department_id
FROM employees;
```

---

# AGGREGATE FUNCTIONS

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

Example:

```sql
SELECT
COUNT(*) AS total_employees,
SUM(salary) AS total_salary,
AVG(salary) AS avg_salary,
MIN(salary) AS min_salary,
MAX(salary) AS max_salary
FROM employees;
```

---

# GROUP BY

```sql
SELECT department_id,
       AVG(salary)
FROM employees
GROUP BY department_id;
```

---

# HAVING

```sql
SELECT department_id,
       COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

---

# CASE WHEN

```sql
SELECT employee_name,
       CASE
           WHEN salary > 50000
           THEN 'High Salary'
           ELSE 'Low Salary'
       END AS salary_category
FROM employees;
```

---

# STRING FUNCTIONS

```sql
UPPER()
LOWER()
TRIM()
LTRIM()
RTRIM()
LENGTH()/LEN()
SUBSTRING()
REPLACE()
CONCAT()
```

Example:

```sql
SELECT
UPPER(name),
LOWER(name),
SUBSTRING(name,1,3)
FROM employees;
```

---

# DATE FUNCTIONS

## Current Date

```sql
CURRENT_DATE
GETDATE()
```

---

## Extract Year

```sql
YEAR(order_date)
```

---

## Extract Month

```sql
MONTH(order_date)
```

---

## Date Difference

```sql
DATEDIFF(day,start_date,end_date)
```

---

## Add Date

```sql
DATEADD(day,30,order_date)
```

---

# NUMERIC FUNCTIONS

```sql
ROUND()
CEILING()
FLOOR()
ABS()
POWER()
SQRT()
MOD()
```

Example:

```sql
SELECT ROUND(123.456,2);
```

---

# CONVERSION FUNCTIONS

```sql
CAST()
CONVERT()
```

Example:

```sql
SELECT CAST(salary AS INT);
```

---

# NULL FUNCTIONS

## SQL Server

```sql
ISNULL()
```

## MySQL

```sql
IFNULL()
```

## Standard SQL

```sql
COALESCE()
```

Example:

```sql
SELECT COALESCE(salary,0);
```

---

# JOINS

## INNER JOIN

```sql
SELECT *
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
```

---

## LEFT JOIN

```sql
SELECT *
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;
```

---

## RIGHT JOIN

```sql
SELECT *
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;
```

---

## FULL JOIN

```sql
SELECT *
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id;
```

---

## SELF JOIN

```sql
SELECT e.employee_name,
       m.employee_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
```

---

# SUBQUERIES

## Scalar Subquery

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

# EXISTS

```sql
SELECT *
FROM employees e
WHERE EXISTS
(
    SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);
```

---

# CTE

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

# RECURSIVE CTE

```sql
WITH RECURSIVE numbers AS
(
    SELECT 1

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT *
FROM numbers;
```

---

# WINDOW FUNCTIONS

## ROW_NUMBER

```sql
ROW_NUMBER() OVER()
```

---

## RANK

```sql
RANK() OVER()
```

---

## DENSE_RANK

```sql
DENSE_RANK() OVER()
```

---

## LAG

```sql
LAG(salary)
OVER(ORDER BY employee_id)
```

---

## LEAD

```sql
LEAD(salary)
OVER(ORDER BY employee_id)
```

---

# RUNNING TOTAL

```sql
SELECT salary,
       SUM(salary)
       OVER
       (
           ORDER BY employee_id
       )
FROM employees;
```

---

# MOVING AVERAGE

```sql
AVG(salary)
OVER
(
ORDER BY employee_id
ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW
)
```

---

# VIEW

## Create View

```sql
CREATE VIEW employee_view AS
SELECT *
FROM employees;
```

---

# INDEX

## Create Index

```sql
CREATE INDEX idx_emp
ON employees(employee_id);
```

---

# STORED PROCEDURE

```sql
CREATE PROCEDURE GetEmployees
AS
BEGIN
    SELECT *
    FROM employees;
END;
```

Execute:

```sql
EXEC GetEmployees;
```

---

# FUNCTION

```sql
CREATE FUNCTION GetBonus
(
    @salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @salary * 0.10;
END;
```

---

# TRIGGER

```sql
CREATE TRIGGER trg_insert
ON employees
AFTER INSERT
AS
BEGIN
    PRINT 'Inserted';
END;
```

---

# SQL OPTIMIZATION

## Avoid

```sql
SELECT *
```

---

## Use Proper Indexes

```sql
CREATE INDEX idx_customer
ON orders(customer_id);
```

---

## Use WHERE Before HAVING

Bad:

```sql
HAVING department_id = 10
```

Good:

```sql
WHERE department_id = 10
```

---

## Prefer UNION ALL

```sql
UNION ALL
```

over

```sql
UNION
```

when duplicates are not important.

---

## SARGABLE QUERY

Bad:

```sql
WHERE YEAR(order_date)=2025
```

Good:

```sql
WHERE order_date >= '2025-01-01'
AND order_date < '2026-01-01'
```

---

# TOP SQL INTERVIEW QUESTIONS

## Salary Problems

```text
Highest Salary
Nth Highest Salary
Top N Salary
Top N Per Department
```

---

## Window Function Problems

```text
Running Total
Moving Average
Ranking
Previous Row
Next Row
```

---

## Joins

```text
Employee Manager
Customers Without Orders
Matching Records
```

---

## Data Cleaning

```text
Duplicates
Null Values
Missing IDs
```

---

## Analytics

```text
MoM Growth
YoY Growth
Retention
Funnel Analysis
Cohort Analysis
```

---

# MOST IMPORTANT FUNCTIONS

## Aggregate

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

---

## String

```sql
UPPER()
LOWER()
TRIM()
SUBSTRING()
REPLACE()
CONCAT()
```

---

## Date

```sql
YEAR()
MONTH()
DATEDIFF()
DATEADD()
```

---

## Window

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
```

---

# SQL INTERVIEW MEMORY SHEET

## Ranking

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

---

## Previous Row

```sql
LAG()
```

---

## Next Row

```sql
LEAD()
```

---

## Running Total

```sql
SUM() OVER()
```

---

## Moving Average

```sql
AVG() OVER()
```

---

## Consecutive Records

```sql
Gaps and Islands
```

---

## Hierarchy

```sql
Recursive CTE
```

---

## Duplicate Removal

```sql
ROW_NUMBER()
```

---

# FINAL SQL ROADMAP

## Basics

✅ SELECT

✅ WHERE

✅ ORDER BY

✅ GROUP BY

✅ HAVING

---

## Intermediate

✅ String Functions

✅ Date Functions

✅ Numeric Functions

✅ Conversion Functions

✅ NULL Functions

---

## Advanced

✅ Joins

✅ Subqueries

✅ Window Functions

✅ CTE

✅ Views

✅ Indexes

✅ Procedures

✅ Triggers

---

## Expert

✅ Optimization

✅ Analytics Problems

✅ Data Engineering Patterns

✅ Product Analytics Patterns

---

# FINAL SUMMARY

If you understand every section in this cheatsheet and can solve the problems from the Advanced SQL Interview Problems file, you are well prepared for most SQL interviews across Data Analyst, BI Developer, Analytics Engineer, SQL Developer, and Data Engineer roles.
