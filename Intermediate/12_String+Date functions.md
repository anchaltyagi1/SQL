# SQL Functions

## Introduction

SQL Functions are built-in functions provided by the database to perform operations on data.

Functions help us:

- Manipulate text
- Work with dates
- Perform calculations
- Handle NULL values
- Convert data types
- Create reports and dashboards

Functions are heavily used in:

- Data Analytics
- Business Intelligence
- Reporting
- ETL Processes
- Data Engineering

---

# Types of SQL Functions

1. String Functions
2. Date & Time Functions
3. Numeric Functions
4. Conversion Functions
5. NULL Handling Functions

---

# String Functions

## What are String Functions?

String functions are used to manipulate text values.

Examples:

- Convert text to uppercase
- Convert text to lowercase
- Extract characters
- Join strings
- Replace characters
- Remove spaces

---

# UPPER()

## Purpose

Converts text to uppercase.

### Syntax

```sql
SELECT UPPER(column_name)
FROM table_name;
```

### Example

```sql
SELECT UPPER(employee_name)
FROM employees;
```

Output:

| employee_name |
|--------------|
| JOHN |
| SARAH |
| MIKE |

---

# LOWER()

## Purpose

Converts text to lowercase.

### Syntax

```sql
SELECT LOWER(column_name)
FROM table_name;
```

### Example

```sql
SELECT LOWER(employee_name)
FROM employees;
```

Output:

| employee_name |
|--------------|
| john |
| sarah |
| mike |

---

# LENGTH()

## Purpose

Returns total number of characters.

### Syntax

```sql
SELECT LENGTH(column_name)
FROM table_name;
```

### Example

```sql
SELECT employee_name,
       LENGTH(employee_name)
FROM employees;
```

Output:

| employee_name | length |
|--------------|---------|
| John | 4 |
| Sarah | 5 |

---

# LEN()

Used mainly in SQL Server.

```sql
SELECT LEN(employee_name)
FROM employees;
```

Equivalent to LENGTH().

---

# CONCAT()

## Purpose

Combines multiple strings.

### Syntax

```sql
SELECT CONCAT(value1,value2);
```

### Example

```sql
SELECT CONCAT(first_name,' ',last_name)
AS full_name
FROM employees;
```

Output:

| full_name |
|----------|
| John Smith |
| Sarah Lee |

---

# SUBSTRING()

## Purpose

Extracts part of a string.

### Syntax

```sql
SELECT SUBSTRING(column_name,start,length)
FROM table_name;
```

### Example

```sql
SELECT SUBSTRING('Database',1,4);
```

Output:

```text
Data
```

---

# LEFT()

## Purpose

Returns characters from the left side.

### Syntax

```sql
SELECT LEFT(column_name,n);
```

### Example

```sql
SELECT LEFT('Database',4);
```

Output:

```text
Data
```

---

# RIGHT()

## Purpose

Returns characters from the right side.

### Syntax

```sql
SELECT RIGHT(column_name,n);
```

### Example

```sql
SELECT RIGHT('Database',4);
```

Output:

```text
base
```

---

# REPLACE()

## Purpose

Replaces existing text with new text.

### Syntax

```sql
SELECT REPLACE(text,
               old_value,
               new_value);
```

### Example

```sql
SELECT REPLACE(
'Data Analyst',
'Analyst',
'Engineer'
);
```

Output:

```text
Data Engineer
```

---

# TRIM()

## Purpose

Removes spaces from both sides.

### Example

```sql
SELECT TRIM('   SQL   ');
```

Output:

```text
SQL
```

---

# LTRIM()

## Purpose

Removes spaces from left side.

### Example

```sql
SELECT LTRIM('   SQL');
```

Output:

```text
SQL
```

---

# RTRIM()

## Purpose

Removes spaces from right side.

### Example

```sql
SELECT RTRIM('SQL   ');
```

Output:

```text
SQL
```

---

# String Function Nesting

Functions can be combined.

### Example

```sql
SELECT UPPER(
TRIM(employee_name)
)
FROM employees;
```

Execution:

```text
1. TRIM()
2. UPPER()
```

---

# Real-World String Function Examples

## Standardize Names

```sql
SELECT UPPER(employee_name)
FROM employees;
```

---

## Generate Full Name

```sql
SELECT CONCAT(first_name,
              ' ',
              last_name)
FROM employees;
```

---

## Extract Email Username

```sql
SELECT SUBSTRING(
email,
1,
5
)
FROM employees;
```

---

# Common String Function Mistakes

## Forgetting Character Positions

Wrong:

```sql
SELECT SUBSTRING(
'Database',
0,
4
);
```

Some databases start positions at 1.

---

## Ignoring Spaces

```sql
SELECT employee_name
FROM employees;
```

May contain unwanted spaces.

Better:

```sql
SELECT TRIM(employee_name)
FROM employees;
```

---

# Date & Time Functions

## What are Date Functions?

Date functions help work with:

- Dates
- Time
- Timestamps
- Date Calculations

These are heavily used in:

- Sales Reports
- Revenue Analysis
- Customer Analytics
- KPI Dashboards

---

# CURRENT_DATE

Returns current date.

### Example

```sql
SELECT CURRENT_DATE;
```

Output:

```text
2026-06-12
```

---

# CURRENT_TIME

Returns current time.

### Example

```sql
SELECT CURRENT_TIME;
```

Output:

```text
14:30:45
```

---

# CURRENT_TIMESTAMP

Returns date and time together.

### Example

```sql
SELECT CURRENT_TIMESTAMP;
```

Output:

```text
2026-06-12 14:30:45
```

---

# NOW()

Most commonly used in MySQL.

### Example

```sql
SELECT NOW();
```

Output:

```text
2026-06-12 14:30:45
```

---

# YEAR()

Extracts year.

### Example

```sql
SELECT YEAR('2025-08-15');
```

Output:

```text
2025
```

---

# MONTH()

Extracts month.

### Example

```sql
SELECT MONTH('2025-08-15');
```

Output:

```text
8
```

---

# DAY()

Extracts day.

### Example

```sql
SELECT DAY('2025-08-15');
```

Output:

```text
15
```

---

# EXTRACT()

Extracts a specific date part.

### Syntax

```sql
SELECT EXTRACT(
YEAR FROM order_date
)
FROM orders;
```

---

# DATE_ADD()

Adds time to a date.

### Example

```sql
SELECT DATE_ADD(
CURRENT_DATE,
INTERVAL 7 DAY
);
```

Output:

```text
Date after 7 days
```

---

# DATE_SUB()

Subtracts time from a date.

### Example

```sql
SELECT DATE_SUB(
CURRENT_DATE,
INTERVAL 7 DAY
);
```

Output:

```text
Date before 7 days
```

---

# DATEDIFF()

Returns difference between dates.

### Example

```sql
SELECT DATEDIFF(
'2025-12-31',
'2025-01-01'
);
```

Output:

```text
364
```

---

# Real-World Date Function Examples

## Orders This Year

```sql
SELECT *
FROM orders
WHERE YEAR(order_date)=2025;
```

---

## Last 30 Days Orders

```sql
SELECT *
FROM orders
WHERE order_date >=
DATE_SUB(
CURRENT_DATE,
INTERVAL 30 DAY
);
```

---

## Customer Age

```sql
SELECT
DATEDIFF(
CURRENT_DATE,
dob
)/365
AS age
FROM customers;
```

---

# Common Date Function Mistakes

## Comparing Date as Text

Wrong:

```sql
SELECT *
FROM orders
WHERE order_date='01-01-2025';
```

Use proper date format.

```sql
SELECT *
FROM orders
WHERE order_date='2025-01-01';
```

---

# Frequently Asked Interview Questions

## Difference Between LENGTH() and LEN()?

LENGTH() is common in MySQL.

LEN() is common in SQL Server.

---

## Difference Between TRIM(), LTRIM(), RTRIM()?

TRIM() → Both sides

LTRIM() → Left side only

RTRIM() → Right side only

---

## Difference Between CURRENT_DATE and NOW()?

CURRENT_DATE returns only date.

NOW() returns date and time.

---

## Difference Between YEAR() and EXTRACT(YEAR)?

Both extract year.

EXTRACT is more flexible and ANSI SQL compliant.

---

# Summary

In this chapter we covered:

## String Functions

- UPPER()
- LOWER()
- LENGTH()
- LEN()
- CONCAT()
- SUBSTRING()
- LEFT()
- RIGHT()
- REPLACE()
- TRIM()
- LTRIM()
- RTRIM()

## Date Functions

- CURRENT_DATE
- CURRENT_TIME
- CURRENT_TIMESTAMP
- NOW()
- YEAR()
- MONTH()
- DAY()
- EXTRACT()
- DATE_ADD()
- DATE_SUB()
- DATEDIFF()
