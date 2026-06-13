# SQL OPTIMIZATION

## What is SQL Optimization?

SQL Optimization is the process of improving query performance so that queries execute faster and consume fewer resources.

Goals:

- Reduce Execution Time
- Reduce CPU Usage
- Reduce Memory Usage
- Reduce Disk I/O
- Improve Scalability

---

# WHY SQL OPTIMIZATION IS IMPORTANT

Imagine a table with 100 rows.

```sql
SELECT *
FROM employees;
```

Not a problem.

Now imagine:

```text
100 Million Rows
```

Poorly written queries can take minutes or even hours.

Optimized queries can execute in milliseconds.

---

# SQL QUERY WRITING ORDER VS EXECUTION ORDER

One of the most important interview concepts.

Many developers think SQL executes in the same order they write it.

It does not.

---

## Query Example

```sql
SELECT department_id,
       AVG(salary) AS avg_salary
FROM employees
WHERE salary > 30000
GROUP BY department_id
HAVING AVG(salary) > 50000
ORDER BY avg_salary DESC;
```

---

## Writing Order

```text
1. SELECT
2. FROM
3. WHERE
4. GROUP BY
5. HAVING
6. ORDER BY
```

---

## Actual Execution Order

```text
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
```

---

## Detailed Execution

### Step 1

```sql
FROM employees
```

SQL first identifies source table.

---

### Step 2

```sql
WHERE salary > 30000
```

Filters rows.

---

### Step 3

```sql
GROUP BY department_id
```

Groups remaining rows.

---

### Step 4

```sql
HAVING AVG(salary) > 50000
```

Filters groups.

---

### Step 5

```sql
SELECT department_id,
       AVG(salary)
```

Returns required columns.

---

### Step 6

```sql
ORDER BY avg_salary DESC
```

Sorts final output.

---

# COMPLETE EXECUTION ORDER

For complex queries:

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

# QUERY EXECUTION LIFECYCLE

```text
SQL Query
    ↓
Parser
    ↓
Optimizer
    ↓
Execution Plan
    ↓
Execution
    ↓
Result
```

---

# EXECUTION PLAN

## What is an Execution Plan?

An Execution Plan shows how SQL Server executes a query.

It helps identify:

- Table Scans
- Index Scans
- Index Seeks
- Expensive Operations
- Missing Indexes

---

# TABLE SCAN

```sql
SELECT *
FROM employees
WHERE salary = 50000;
```

Without index:

```text
Table Scan
```

SQL reads every row.

Slow on large tables.

---

# INDEX SEEK

```sql
SELECT *
FROM employees
WHERE employee_id = 100;
```

With index:

```text
Index Seek
```

SQL directly finds the required row.

Fastest operation.

---

# INDEX SCAN

```text
Reads many index entries.
```

Better than Table Scan.

Slower than Index Seek.

---

# SARGABILITY

## What is SARGability?

Search Argument Ability.

A query is SARGable if SQL can efficiently use an index.

---

## Non-SARGable Query

```sql
SELECT *
FROM employees
WHERE YEAR(hire_date) = 2025;
```

Problem:

SQL must evaluate YEAR() for every row.

Index becomes ineffective.

---

## SARGable Query

```sql
SELECT *
FROM employees
WHERE hire_date >= '2025-01-01'
AND hire_date < '2026-01-01';
```

Index can be used efficiently.

---

# FUNCTIONS ON COLUMNS

Avoid:

```sql
WHERE UPPER(name) = 'JOHN'
```

Better:

```sql
WHERE name = 'John'
```

Functions often prevent index usage.

---

# SELECT * PROBLEM

Avoid:

```sql
SELECT *
FROM employees;
```

Use:

```sql
SELECT employee_id,
       employee_name
FROM employees;
```

Benefits:

- Less I/O
- Less Memory
- Faster Queries

---

# WHERE VS HAVING

---

## Incorrect Approach

```sql
SELECT department_id,
       COUNT(*)
FROM employees
GROUP BY department_id
HAVING department_id = 10;
```

---

## Better Approach

```sql
SELECT department_id,
       COUNT(*)
FROM employees
WHERE department_id = 10
GROUP BY department_id;
```

Reason:

Filter rows before grouping.

Less work for SQL.

---

# EXISTS VS IN

---

## IN

```sql
SELECT *
FROM employees
WHERE department_id IN
(
    SELECT department_id
    FROM departments
);
```

---

## EXISTS

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

## Interview Rule

Large datasets:

```text
EXISTS
```

often performs better.

---

# EXISTS VS JOIN

Use JOIN when you need columns.

```sql
SELECT e.*,
       d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
```

Use EXISTS when checking existence only.

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

# UNION VS UNION ALL

---

## UNION

```sql
SELECT city FROM customers
UNION
SELECT city FROM suppliers;
```

Removes duplicates.

Extra sorting required.

Slower.

---

## UNION ALL

```sql
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;
```

Keeps duplicates.

Faster.

---

# JOIN OPTIMIZATION

Always join indexed columns.

Good:

```sql
employees.department_id
departments.department_id
```

Indexed joins are significantly faster.

---

# COMPOSITE INDEXES

Example:

```sql
CREATE INDEX idx_emp
ON employees(department_id, salary);
```

Works well for:

```sql
WHERE department_id = 10
AND salary > 50000
```

---

# LEFTMOST PREFIX RULE

Index:

```sql
(department_id, salary)
```

Works efficiently:

```sql
WHERE department_id = 10
```

Works efficiently:

```sql
WHERE department_id = 10
AND salary > 50000
```

Not optimal:

```sql
WHERE salary > 50000
```

---

# CTE VS TEMP TABLE

## CTE

```sql
WITH emp_cte AS
(
    SELECT *
    FROM employees
)
SELECT *
FROM emp_cte;
```

Best for readability.

---

## Temp Table

```sql
CREATE TABLE #employees
(
    employee_id INT
);
```

Best for:

- Large datasets
- Repeated use
- Complex transformations

---

# CURSOR VS SET-BASED PROCESSING

Avoid:

```text
Cursor
```

Because it processes rows one at a time.

Prefer:

```text
Set-Based Queries
```

SQL is designed for set operations.

---

# INDEX FRAGMENTATION

Occurs when index pages become disorganized.

Caused by:

- INSERT
- UPDATE
- DELETE

operations.

---

# REBUILD VS REORGANIZE

## Reorganize

```sql
ALTER INDEX idx_employee
REORGANIZE;
```

Lightweight maintenance.

---

## Rebuild

```sql
ALTER INDEX idx_employee
REBUILD;
```

Creates fresh index structure.

More resource intensive.

---

# CARDINALITY

Number of unique values in a column.

Example:

```text
Employee_ID
```

High Cardinality.

---

Example:

```text
Gender
```

Low Cardinality.

---

# SELECTIVITY

Measures uniqueness.

High Selectivity:

```text
Email
Employee_ID
PAN_Number
```

Excellent index candidates.

---

Low Selectivity:

```text
Gender
Status
```

Usually poor index candidates.

---

# PARTITIONING

Large tables can be divided into smaller logical pieces.

Example:

```text
Sales_2023
Sales_2024
Sales_2025
```

Benefits:

- Faster Queries
- Easier Maintenance
- Better Scalability

---

# COMMON PERFORMANCE KILLERS

❌ SELECT *

❌ Missing Indexes

❌ Too Many Indexes

❌ Functions on Indexed Columns

❌ Unnecessary DISTINCT

❌ Leading Wildcards

```sql
LIKE '%John'
```

❌ Nested Cursors

❌ Table Scans on Large Tables

---

# QUERY TUNING CHECKLIST

Before optimizing:

### Check Execution Plan

### Check Missing Indexes

### Avoid SELECT *

### Filter Early

### Use WHERE Before HAVING

### Use EXISTS for Large Datasets

### Avoid Functions on Indexed Columns

### Maintain Indexes

### Review Table Scans

### Use Proper Join Conditions

---

# REAL-WORLD EXAMPLE

## Slow Query

```sql
SELECT *
FROM orders
WHERE YEAR(order_date) = 2025;
```

Problem:

- Function on indexed column
- Table Scan likely

---

## Optimized Query

```sql
SELECT order_id,
       order_date
FROM orders
WHERE order_date >= '2025-01-01'
AND order_date < '2026-01-01';
```

Benefits:

- Uses Index
- Faster Execution
- Less I/O

---

# INTERVIEW QUESTIONS

## What is SQL Optimization?

Improving query performance while reducing resource usage.

---

## What is an Execution Plan?

A blueprint showing how SQL executes a query.

---

## Difference Between Index Seek and Table Scan?

Index Seek:
- Direct lookup

Table Scan:
- Reads entire table

---

## What is SARGability?

Writing queries that allow efficient index usage.

---

## Why Avoid SELECT *?

Returns unnecessary data and increases I/O.

---

## EXISTS vs IN?

EXISTS often performs better on large datasets.

---

## UNION vs UNION ALL?

UNION ALL is faster because duplicates are not removed.

---

## Difference Between WHERE and HAVING?

WHERE filters rows.

HAVING filters groups.

---

## What is Cardinality?

Number of unique values in a column.

---

## What is Selectivity?

Measure of uniqueness.

Higher selectivity usually means better indexing performance.

---

## What is Partitioning?

Dividing large tables into smaller manageable pieces.

---

# FINAL CHECKLIST

✅ Query Writing Order

✅ Query Execution Order

✅ Execution Plans

✅ Table Scan

✅ Index Scan

✅ Index Seek

✅ SARGability

✅ EXISTS vs IN

✅ EXISTS vs JOIN

✅ WHERE vs HAVING

✅ UNION vs UNION ALL

✅ Join Optimization

✅ Composite Indexes

✅ Leftmost Prefix Rule

✅ CTE vs Temp Table

✅ Cardinality

✅ Selectivity

✅ Partitioning

✅ Index Fragmentation

✅ Rebuild vs Reorganize

✅ Query Tuning Checklist

✅ Interview Questions

---

# SUMMARY

SQL Optimization is about writing efficient queries and helping the database engine do less work.

Key areas to master:

- Execution Plans
- Index Usage
- SARGability
- Query Rewriting
- Join Optimization
- Partitioning
- Statistics and Index Maintenance

These topics are heavily asked in Data Analyst, BI Developer, SQL Developer, and Data Engineer interviews.
