# DQL (Data Query Language)

## Introduction

DQL stands for **Data Query Language**.

DQL is used to retrieve data from a database. It allows users to fetch, view, analyze, and report data stored in tables.

Unlike DDL, DML, DCL, and TCL, DQL does not modify the database structure or data. It only retrieves information.

DQL is one of the most frequently used SQL categories because almost every business report, dashboard, analysis, and application depends on retrieving data.

---

# Why Do We Need DQL?

DQL helps us:

- Retrieve records from tables
- Analyze business data
- Generate reports
- Create dashboards
- Answer business questions
- Filter data
- Sort data
- Aggregate data

Without DQL, data stored inside a database cannot be viewed or analyzed.

---

# DQL Command

The primary command in DQL is:

```sql
SELECT
```

Almost every SQL query starts with the SELECT statement.

---

# SQL Categories Overview

| Category | Full Form | Purpose | Commands |
|-----------|------------|----------|----------|
| DDL | Data Definition Language | Define database structure | CREATE, ALTER, DROP, TRUNCATE |
| DML | Data Manipulation Language | Modify data | INSERT, UPDATE, DELETE |
| DCL | Data Control Language | Control permissions | GRANT, REVOKE |
| TCL | Transaction Control Language | Manage transactions | COMMIT, ROLLBACK, SAVEPOINT |
| DQL | Data Query Language | Retrieve data | SELECT |

---

# What Can We Do Using DQL?

Using DQL we can:

- View all records
- View specific columns
- Filter records
- Sort records
- Find duplicates
- Calculate totals
- Calculate averages
- Generate reports
- Perform data analysis

---

# Basic Example

## Employees Table

| employee_id | employee_name | salary |
|------------|---------------|---------|
| 101 | John | 50000 |
| 102 | Sarah | 60000 |
| 103 | Mike | 70000 |

---

## Retrieve All Data

```sql
SELECT *
FROM employees;
```

### Output

| employee_id | employee_name | salary |
|------------|---------------|---------|
| 101 | John | 50000 |
| 102 | Sarah | 60000 |
| 103 | Mike | 70000 |

---

## Retrieve Specific Columns

```sql
SELECT employee_name,
       salary
FROM employees;
```

### Output

| employee_name | salary |
|---------------|---------|
| John | 50000 |
| Sarah | 60000 |
| Mike | 70000 |

---

# Why is DQL Important?

DQL is the foundation of:

- Data Analysis
- Business Intelligence
- Reporting
- Dashboard Development
- Data Engineering
- Data Science

Most SQL queries written in real-world projects use SELECT statements.

---

# Real-World Examples

## Find Total Employees

```sql
SELECT COUNT(*)
FROM employees;
```

---

## Find Highest Salary

```sql
SELECT MAX(salary)
FROM employees;
```

---

## Find Lowest Salary

```sql
SELECT MIN(salary)
FROM employees;
```

---

## Find Average Salary

```sql
SELECT AVG(salary)
FROM employees;
```

---

## Find Total Salary Expense

```sql
SELECT SUM(salary)
FROM employees;
```

---

## Find Employees From IT Department

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

---

## Generate Department Report

```sql
SELECT department,
       AVG(salary)
FROM employees
GROUP BY department;
```

---

# Advantages of DQL

- Fast data retrieval
- Easy report generation
- Supports data analysis
- Helps in decision making
- Works with large datasets
- Forms the foundation of SQL querying

---

# Limitations of DQL

DQL only retrieves data.

It cannot:

- Create tables
- Modify tables
- Insert records
- Update records
- Delete records

These tasks are performed using DDL and DML commands.

---

# Common Mistakes

## Using SELECT * Unnecessarily

### Not Recommended

```sql
SELECT *
FROM employees;
```

### Why?

Problems:

- Retrieves unnecessary columns
- Slower performance
- Increased network traffic
- Security concerns

### Better Approach

```sql
SELECT employee_id,
       employee_name
FROM employees;
```

---

## Retrieving More Data Than Needed

### Example

```sql
SELECT *
FROM employees;
```

when only one column is required.

### Better

```sql
SELECT employee_name
FROM employees;
```

---

## Ignoring Filters

### Example

```sql
SELECT *
FROM employees;
```

### Better

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

Filtering reduces unnecessary data retrieval.

---

# Best Practices

## Select Only Required Columns

### Recommended

```sql
SELECT employee_name,
       salary
FROM employees;
```

---

## Use Meaningful Aliases

### Example

```sql
SELECT employee_name AS Employee_Name
FROM employees;
```

---

## Apply Filters Whenever Possible

### Example

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

---

## Avoid Unnecessary Data Retrieval

Retrieve only the data required for analysis.

---

# DQL in Data Analytics

Data Analysts use DQL to:

- Create reports
- Build dashboards
- Analyze trends
- Measure KPIs
- Find business insights

Examples:

### Monthly Sales Report

```sql
SELECT month,
       SUM(sales_amount)
FROM sales
GROUP BY month;
```

---

### Top Performing Products

```sql
SELECT product_name,
       SUM(sales_amount)
FROM sales
GROUP BY product_name;
```

---

### Customer Analysis

```sql
SELECT customer_id,
       COUNT(*)
FROM orders
GROUP BY customer_id;
```

---

# Frequently Asked Interview Questions

## What is DQL?

DQL (Data Query Language) is used to retrieve data from a database.

---

## Which Command Belongs to DQL?

```sql
SELECT
```

---

## Is SELECT a DML Command?

No.

SELECT belongs to DQL because it retrieves data rather than modifying it.

---

## Difference Between DML and DQL

| DML | DQL |
|----------|----------|
| Modifies data | Retrieves data |
| INSERT | SELECT |
| UPDATE | SELECT |
| DELETE | SELECT |

---

## Why is SELECT the Most Important SQL Command?

Because almost all SQL reporting, analysis, dashboarding, and querying operations begin with SELECT.

---

## Can DQL Modify Data?

No.

DQL can only retrieve data.

---

## What is the Main Purpose of DQL?

To retrieve, analyze, and report data stored in database tables.

---

# Summary

DQL (Data Query Language) is used to retrieve and analyze data stored inside database tables.

The primary DQL command is:

```sql
SELECT
```

DQL forms the foundation of SQL querying and is heavily used in reporting, analytics, business intelligence, data engineering, and data science projects.
UNCTIONS
