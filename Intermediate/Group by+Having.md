# GROUP BY

## What is GROUP BY?

The GROUP BY clause is used to group rows that have the same values in one or more columns.

Instead of analyzing individual rows, GROUP BY helps us analyze data at a summary level.

### Example

Employee Table

| employee_id | employee_name | department | salary |
|------------|---------------|------------|---------|
| 101 | John | IT | 50000 |
| 102 | Sarah | HR | 60000 |
| 103 | Mike | IT | 70000 |
| 104 | Emma | Sales | 40000 |
| 105 | David | HR | 50000 |

Suppose management asks:

> How many employees are present in each department?

GROUP BY helps answer this.

---

# Why Do We Need GROUP BY?

Without GROUP BY:

```sql
SELECT COUNT(*)
FROM employees;
```

Output:

```text
5
```

This gives total employees.

But if we want department-wise counts:

```sql
SELECT department,
       COUNT(*)
FROM employees
GROUP BY department;
```

Output:

| department | count |
|------------|--------|
| IT | 2 |
| HR | 2 |
| Sales | 1 |

---

# GROUP BY Syntax

```sql
SELECT column_name,
       aggregate_function(column_name)
FROM table_name
GROUP BY column_name;
```

---

# Count Employees by Department

```sql
SELECT department,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department;
```

Output:

| department | employee_count |
|------------|----------------|
| IT | 2 |
| HR | 2 |
| Sales | 1 |

---

# Department-wise Salary

```sql
SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department;
```

Output:

| department | total_salary |
|------------|--------------|
| IT | 120000 |
| HR | 110000 |
| Sales | 40000 |

---

# Department-wise Average Salary

```sql
SELECT department,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

---

# Department-wise Highest Salary

```sql
SELECT department,
       MAX(salary) AS highest_salary
FROM employees
GROUP BY department;
```

---

# Department-wise Lowest Salary

```sql
SELECT department,
       MIN(salary) AS lowest_salary
FROM employees
GROUP BY department;
```

---

# GROUP BY Multiple Columns

Employee Table

| department | city | salary |
|------------|------|---------|
| IT | Delhi | 50000 |
| IT | Mumbai | 70000 |
| HR | Delhi | 60000 |
| HR | Mumbai | 50000 |

```sql
SELECT department,
       city,
       COUNT(*)
FROM employees
GROUP BY department,
         city;
```

Output:

| department | city | count |
|------------|------|--------|
| IT | Delhi | 1 |
| IT | Mumbai | 1 |
| HR | Delhi | 1 |
| HR | Mumbai | 1 |

---

# Important Rule of GROUP BY

Wrong:

```sql
SELECT department,
       employee_name,
       COUNT(*)
FROM employees
GROUP BY department;
```

Error:

```text
employee_name is neither grouped nor aggregated
```

Correct:

```sql
SELECT department,
       COUNT(*)
FROM employees
GROUP BY department;
```

---

# GROUP BY Execution Order

Query:

```sql
SELECT department,
       COUNT(*)
FROM employees
GROUP BY department;
```

Logical Execution:

```text
1. FROM
2. GROUP BY
3. Aggregate Functions
4. SELECT
```

---

# HAVING Clause

## What is HAVING?

HAVING is used to filter groups after GROUP BY.

WHERE filters rows.

HAVING filters groups.

---

# Why HAVING Exists?

Suppose we want departments having more than one employee.

Wrong:

```sql
SELECT department,
       COUNT(*)
FROM employees
WHERE COUNT(*) > 1
GROUP BY department;
```

Error.

Aggregate functions cannot be used in WHERE.

---

Correct:

```sql
SELECT department,
       COUNT(*)
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;
```

Output:

| department | count |
|------------|--------|
| IT | 2 |
| HR | 2 |

---

# HAVING Syntax

```sql
SELECT column_name,
       aggregate_function()
FROM table_name
GROUP BY column_name
HAVING condition;
```

---

# Departments Having More Than 2 Employees

```sql
SELECT department,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 2;
```

---

# Departments Having Total Salary Greater Than 100000

```sql
SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 100000;
```

---

# Departments Having Average Salary Above 55000

```sql
SELECT department,
       AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 55000;
```

---

# WHERE vs HAVING

| WHERE | HAVING |
|---------|---------|
| Filters rows | Filters groups |
| Executes before GROUP BY | Executes after GROUP BY |
| Cannot use aggregate functions | Can use aggregate functions |
| Faster | Usually slower |

---

# WHERE + HAVING Together

```sql
SELECT department,
       COUNT(*)
FROM employees
WHERE salary > 40000
GROUP BY department
HAVING COUNT(*) > 1;
```

Execution:

```text
1. FROM
2. WHERE
3. GROUP BY
4. Aggregate Functions
5. HAVING
6. SELECT
```

---

# Common GROUP BY Mistakes

## Selecting Non-Grouped Columns

Wrong:

```sql
SELECT department,
       employee_name
FROM employees
GROUP BY department;
```

---

## Forgetting GROUP BY

Wrong:

```sql
SELECT department,
       COUNT(*)
FROM employees;
```

---

## Using HAVING Instead of WHERE

Wrong:

```sql
SELECT *
FROM employees
HAVING salary > 50000;
```

Use WHERE for row filtering.

---

# Frequently Asked Interview Questions

## Difference Between WHERE and HAVING?

WHERE filters rows.

HAVING filters groups.

---

## Can HAVING Be Used Without GROUP BY?

Yes, but rarely used.

---

## Which Executes First?

```text
WHERE → GROUP BY → HAVING
```

---

## Can Aggregate Functions Be Used in WHERE?

No.

Use HAVING instead.

---

## What Happens If GROUP BY Is Missing?

Aggregate calculations may fail or produce incorrect results depending on DBMS.

---

# Summary

GROUP BY is used to create groups of rows.

HAVING is used to filter those groups.

Key Concepts:

- GROUP BY
- Single Column Grouping
- Multiple Column Grouping
- Aggregate Functions
- HAVING
- WHERE vs HAVING
- Execution Order
