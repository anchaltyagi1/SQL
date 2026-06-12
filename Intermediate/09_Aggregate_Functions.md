# Data Aggregation and Grouping

## Introduction

In real-world projects, we rarely need individual records. Most of the time, businesses want summarized information such as:

- Total Sales
- Average Salary
- Number of Customers
- Highest Revenue Product
- Monthly Profit
- Department-wise Employee Count

SQL provides Aggregate Functions, GROUP BY, HAVING, and CASE WHEN to perform such analysis.

These concepts are heavily used in:

- Data Analytics
- Business Intelligence
- Dashboard Development
- Reporting
- Data Engineering
- SQL Interviews

---

# Aggregate Functions

## What are Aggregate Functions?

Aggregate functions perform calculations on multiple rows and return a single result.

### Example Table

| employee_id | employee_name | department | salary |
|------------|---------------|------------|---------|
| 101 | John | IT | 50000 |
| 102 | Sarah | HR | 60000 |
| 103 | Mike | IT | 70000 |
| 104 | Emma | Sales | 40000 |

---

# Types of Aggregate Functions

1. COUNT()
2. SUM()
3. AVG()
4. MIN()
5. MAX()

---

# COUNT()

## What is COUNT()?

COUNT() returns the number of rows.

### Syntax

```sql
SELECT COUNT(*)
FROM employees;
```

### Output

```text
4
```

---

## COUNT(*)

Counts every row including NULL values.

```sql
SELECT COUNT(*)
FROM employees;
```

### Result

```text
4
```

---

## COUNT(column_name)

Counts only non-NULL values.

Example:

| employee_id | bonus |
|------------|--------|
| 101 | 5000 |
| 102 | NULL |
| 103 | 3000 |
| 104 | NULL |

```sql
SELECT COUNT(bonus)
FROM employees;
```

Output:

```text
2
```

---

## COUNT(DISTINCT)

Counts unique values.

### Example

| department |
|------------|
| IT |
| IT |
| HR |
| Sales |

```sql
SELECT COUNT(DISTINCT department)
FROM employees;
```

Output:

```text
3
```

---

# SUM()

## What is SUM()?

SUM() calculates the total of a numeric column.

### Syntax

```sql
SELECT SUM(column_name)
FROM table_name;
```

### Example

```sql
SELECT SUM(salary)
FROM employees;
```

Calculation:

```text
50000 + 60000 + 70000 + 40000
```

Output:

```text
220000
```

---

# AVG()

## What is AVG()?

AVG() calculates the average value.

### Syntax

```sql
SELECT AVG(salary)
FROM employees;
```

Calculation:

```text
220000 / 4
```

Output:

```text
55000
```

---

# MIN()

## What is MIN()?

Returns the smallest value.

### Example

```sql
SELECT MIN(salary)
FROM employees;
```

Output:

```text
40000
```

---

# MAX()

## What is MAX()?

Returns the largest value.

### Example

```sql
SELECT MAX(salary)
FROM employees;
```

Output:

```text
70000
```

---

# Multiple Aggregate Functions Together

```sql
SELECT
COUNT(*) AS Total_Employees,
SUM(salary) AS Total_Salary,
AVG(salary) AS Average_Salary,
MIN(salary) AS Minimum_Salary,
MAX(salary) AS Maximum_Salary
FROM employees;
```

Output:

| Total_Employees | Total_Salary | Average_Salary | Minimum_Salary | Maximum_Salary |
|---------------|--------------|----------------|----------------|----------------|
| 4 | 220000 | 55000 | 40000 | 70000 |

---

# NULL Behavior in Aggregate Functions

## Example

| salary |
|---------|
| 50000 |
| 60000 |
| NULL |
| 40000 |

### COUNT(*)

```sql
SELECT COUNT(*)
FROM employees;
```

Output:

```text
4
```

---

### COUNT(salary)

```sql
SELECT COUNT(salary)
FROM employees;
```

Output:

```text
3
```

---

### SUM(salary)

```sql
SELECT SUM(salary)
FROM employees;
```

Output:

```text
150000
```

NULL values are ignored.

---

### AVG(salary)

```sql
SELECT AVG(salary)
FROM employees;
```

Calculation:

```text
(50000 + 60000 + 40000) / 3
```

Output:

```text
50000
```

NULL values are ignored.

---

# Aggregate Functions vs Normal Functions

| Aggregate Function | Normal Function |
|-------------------|----------------|
| Works on multiple rows | Works on one value |
| Returns single result | Returns result per row |
| SUM() | UPPER() |
| AVG() | LOWER() |
| COUNT() | LENGTH() |

---

# Real-World Examples

## Total Revenue

```sql
SELECT SUM(revenue)
FROM sales;
```

---

## Total Customers

```sql
SELECT COUNT(*)
FROM customers;
```

---

## Average Order Value

```sql
SELECT AVG(order_amount)
FROM orders;
```

---

## Highest Sale

```sql
SELECT MAX(order_amount)
FROM orders;
```

---

## Lowest Sale

```sql
SELECT MIN(order_amount)
FROM orders;
```

---

# Common Mistakes

## Using SUM on Text Columns

Wrong:

```sql
SELECT SUM(employee_name)
FROM employees;
```

SUM works only with numeric values.

---

## Confusing COUNT(*) and COUNT(column)

```sql
COUNT(*)
```

Counts all rows.

```sql
COUNT(column_name)
```

Counts only non-NULL values.

---

## Ignoring NULL Values

Aggregate functions usually ignore NULL values.

Always verify your data before calculating averages or totals.

---

# Frequently Asked Interview Questions

## What is an Aggregate Function?

An aggregate function performs calculations on multiple rows and returns a single value.

---

## Name Common Aggregate Functions.

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

---

## Difference Between COUNT(*) and COUNT(column)?

COUNT(*) counts all rows.

COUNT(column) counts only non-NULL values.

---

## Does AVG Ignore NULL Values?

Yes.

AVG ignores NULL values.

---

## Can Aggregate Functions Be Used on Text Columns?

Generally no.

SUM and AVG require numeric data.

---

# Summary

Aggregate Functions are used to summarize data.

Most commonly used functions are:

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

These functions form the foundation of reporting, dashboards, GROUP BY, HAVING, and advanced SQL analytics.
