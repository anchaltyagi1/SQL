# Basic SQL Querying Concepts

## Introduction

After learning DDL, DML, DCL, TCL, and DQL, the next step is learning how to retrieve and filter data.

These SQL clauses are used daily by Data Analysts, Data Engineers, BI Developers, and Data Scientists.

In this chapter, we will cover:

* SELECT
* WHERE
* DISTINCT
* ALIAS
* ORDER BY
* LIMIT
* IN
* BETWEEN
* LIKE
* IS NULL
* IS NOT NULL

For all examples, consider the following table:

| employee_id | employee_name | department | salary | city   |
| ----------- | ------------- | ---------- | ------ | ------ |
| 101         | John          | IT         | 50000  | Delhi  |
| 102         | Sarah         | HR         | 60000  | Mumbai |
| 103         | Mike          | IT         | 70000  | Delhi  |
| 104         | Emma          | Sales      | NULL   | Pune   |

---

# SELECT Statement

## What is SELECT?

The SELECT statement is used to retrieve data from a table.

### Syntax

```sql
SELECT column_name
FROM table_name;
```

### Example

```sql
SELECT employee_name
FROM employees;
```

### Retrieve Multiple Columns

```sql
SELECT employee_name,
       salary
FROM employees;
```

### Retrieve All Columns

```sql
SELECT *
FROM employees;
```

### Best Practice

Avoid using:

```sql
SELECT *
FROM employees;
```

in production because it retrieves unnecessary data.

---

# WHERE Clause

## What is WHERE?

The WHERE clause is used to filter records based on a condition.

### Syntax

```sql
SELECT *
FROM table_name
WHERE condition;
```

### Example

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

### Output

Returns only IT employees.

---

## Comparison Operators

### Equal To

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

### Not Equal To

```sql
SELECT *
FROM employees
WHERE department <> 'IT';
```

or

```sql
SELECT *
FROM employees
WHERE department != 'IT';
```

### Greater Than

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

### Less Than

```sql
SELECT *
FROM employees
WHERE salary < 50000;
```

### Greater Than or Equal To

```sql
SELECT *
FROM employees
WHERE salary >= 50000;
```

### Less Than or Equal To

```sql
SELECT *
FROM employees
WHERE salary <= 50000;
```

---

## Logical Operators

### AND

```sql
SELECT *
FROM employees
WHERE department = 'IT'
AND city = 'Delhi';
```

Both conditions must be true.

---

### OR

```sql
SELECT *
FROM employees
WHERE city = 'Delhi'
OR city = 'Mumbai';
```

At least one condition must be true.

---

### NOT

```sql
SELECT *
FROM employees
WHERE NOT department = 'IT';
```

Returns all non-IT employees.

---

# DISTINCT

## What is DISTINCT?

DISTINCT removes duplicate values from the result set.

### Syntax

```sql
SELECT DISTINCT column_name
FROM table_name;
```

### Example

```sql
SELECT DISTINCT department
FROM employees;
```

### Output

```text
IT
HR
Sales
```

Duplicate IT values are removed.

---

## DISTINCT on Multiple Columns

```sql
SELECT DISTINCT department,
                city
FROM employees;
```

Distinct works on the combination of columns.

---

## Common Mistake

Many people think DISTINCT works on a single column only.

Actually:

```sql
SELECT DISTINCT department,
                city
FROM employees;
```

checks uniqueness across both columns together.

---

# Alias (AS)

## What is an Alias?

An alias is a temporary name given to a column or table.

### Syntax

```sql
SELECT column_name AS alias_name
FROM table_name;
```

### Example

```sql
SELECT employee_name AS Employee_Name
FROM employees;
```

### Output

```text
Employee_Name
```

instead of:

```text
employee_name
```

---

## Alias Without AS

```sql
SELECT employee_name Employee_Name
FROM employees;
```

Also valid.

---

## Table Alias

```sql
SELECT e.employee_name,
       e.salary
FROM employees e;
```

### Benefits

* Shorter queries
* Easier joins
* Better readability

---

# ORDER BY

## What is ORDER BY?

ORDER BY is used to sort records.

### Syntax

```sql
SELECT *
FROM table_name
ORDER BY column_name;
```

---

## Ascending Order (Default)

```sql
SELECT *
FROM employees
ORDER BY salary;
```

or

```sql
SELECT *
FROM employees
ORDER BY salary ASC;
```

Lowest salary first.

---

## Descending Order

```sql
SELECT *
FROM employees
ORDER BY salary DESC;
```

Highest salary first.

---

## Multiple Column Sorting

```sql
SELECT *
FROM employees
ORDER BY department,
         salary DESC;
```

First sorts by department.

Then sorts salary within each department.

---

# LIMIT

## What is LIMIT?

LIMIT restricts the number of rows returned.

### Syntax

```sql
SELECT *
FROM table_name
LIMIT number;
```

### Example

```sql
SELECT *
FROM employees
LIMIT 3;
```

Returns only 3 rows.

---

## Top N Records

```sql
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

Returns top 5 highest-paid employees.

---

## Pagination

```sql
SELECT *
FROM employees
LIMIT 10 OFFSET 20;
```

Returns rows 21–30.

---

# IN Operator

## What is IN?

IN is used when checking multiple values.

### Example

```sql
SELECT *
FROM employees
WHERE city IN ('Delhi','Mumbai');
```

Equivalent to:

```sql
SELECT *
FROM employees
WHERE city='Delhi'
OR city='Mumbai';
```

---

## NOT IN

```sql
SELECT *
FROM employees
WHERE city NOT IN ('Delhi','Mumbai');
```

---

# BETWEEN Operator

## What is BETWEEN?

BETWEEN is used to filter a range of values.

### Example

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 50000 AND 70000;
```

Includes:

```text
50000
60000
70000
```

BETWEEN is inclusive.

---

## Date Range Example

```sql
SELECT *
FROM orders
WHERE order_date
BETWEEN '2025-01-01'
AND '2025-12-31';
```

---

# LIKE Operator

## What is LIKE?

LIKE is used for pattern matching.

---

## Starts With

```sql
SELECT *
FROM employees
WHERE employee_name LIKE 'J%';
```

Matches:

```text
John
Jack
James
```

---

## Ends With

```sql
SELECT *
FROM employees
WHERE employee_name LIKE '%n';
```

Matches:

```text
John
Ryan
```

---

## Contains

```sql
SELECT *
FROM employees
WHERE employee_name LIKE '%oh%';
```

Matches:

```text
John
```

---

## Single Character Wildcard

```sql
SELECT *
FROM employees
WHERE employee_name LIKE '_ohn';
```

Matches:

```text
John
```

### Wildcards

| Symbol | Meaning                  |
| ------ | ------------------------ |
| %      | Any number of characters |
| _      | Single character         |

---

# IS NULL

## What is NULL?

NULL means:

* Missing value
* Unknown value
* Not available

It does not mean:

* Zero
* Empty string

---

## Find NULL Values

```sql
SELECT *
FROM employees
WHERE salary IS NULL;
```

Returns employees with missing salary.

---

# IS NOT NULL

Used to find rows containing actual values.

### Example

```sql
SELECT *
FROM employees
WHERE salary IS NOT NULL;
```

Returns employees whose salary exists.

---

# Common Mistakes

## Using = NULL

Incorrect:

```sql
SELECT *
FROM employees
WHERE salary = NULL;
```

Correct:

```sql
SELECT *
FROM employees
WHERE salary IS NULL;
```

---

## Using DISTINCT Unnecessarily

DISTINCT requires extra processing.

Use it only when duplicates must be removed.

---

## Forgetting ORDER BY with LIMIT

Incorrect:

```sql
SELECT *
FROM employees
LIMIT 5;
```

Not necessarily top 5 records.

Correct:

```sql
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

---

# Frequently Asked Interview Questions

## Difference Between WHERE and HAVING?

WHERE filters rows before aggregation.

HAVING filters groups after aggregation.

---

## Difference Between DISTINCT and GROUP BY?

DISTINCT removes duplicates.

GROUP BY creates groups for aggregation.

---

## Difference Between LIKE and IN?

LIKE performs pattern matching.

IN checks exact values.

---

## Is BETWEEN Inclusive?

Yes.

```sql
BETWEEN 10 AND 20
```

includes both 10 and 20.

---

## Difference Between NULL and 0?

NULL = Missing value

0 = Actual value

---

## Difference Between % and _ in LIKE?

% → Multiple characters

_ → Single character

---

# Summary

This chapter introduced the most important SQL querying concepts:

* SELECT
* WHERE
* DISTINCT
* ALIAS
* ORDER BY
* LIMIT
* IN
* BETWEEN
* LIKE
* IS NULL
* IS NOT NULL

These concepts form the foundation of SQL querying and are heavily used before moving to:

* Aggregate Functions
* GROUP BY
* HAVING
* CASE WHEN
* JOINS
* Subqueries
* Window Functions
