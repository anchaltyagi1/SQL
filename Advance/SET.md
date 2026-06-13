# SET OPERATIONS IN SQL (COMPLETE GUIDE)

## 📌 What are Set Operations?

Set Operations are used to combine the results of two or more SELECT statements.

They are based on mathematical set theory.

Set Operations allow us to:
- Combine datasets
- Compare datasets
- Find common records
- Find missing records
- Perform data validation
- Remove duplicates

---

# TYPES OF SET OPERATIONS

1. UNION
2. UNION ALL
3. INTERSECT
4. EXCEPT / MINUS

---

# RULES FOR SET OPERATIONS

Before using any Set Operation:

## Rule 1: Same Number of Columns

✅ Correct

```sql
SELECT employee_id, employee_name
FROM employees

UNION

SELECT customer_id, customer_name
FROM customers;
```

❌ Incorrect

```sql
SELECT employee_id
FROM employees

UNION

SELECT customer_id, customer_name
FROM customers;
```

---

## Rule 2: Compatible Data Types

✅ Correct

```sql
SELECT employee_id
FROM employees

UNION

SELECT customer_id
FROM customers;
```

---

## Rule 3: Column Names Come From First Query

```sql
SELECT employee_id AS id
FROM employees

UNION

SELECT customer_id
FROM customers;
```

Output column name:

```text
id
```

---

# UNION

## Definition

Combines results from multiple queries and removes duplicates.

---

## Syntax

```sql
SELECT column_name
FROM table1

UNION

SELECT column_name
FROM table2;
```

---

## Example

```sql
SELECT city
FROM customers

UNION

SELECT city
FROM suppliers;
```

---

## Example Output

Table 1

```text
Delhi
Mumbai
Pune
```

Table 2

```text
Mumbai
Bangalore
```

Result

```text
Delhi
Mumbai
Pune
Bangalore
```

Duplicate Mumbai removed.

---

## Internal Working

1. Combine data
2. Sort data
3. Remove duplicates
4. Return final result

---

## Advantages

- Removes duplicates automatically
- Cleaner result

---

## Disadvantages

- Slower than UNION ALL
- Requires duplicate elimination

---

# UNION ALL

## Definition

Combines results and keeps duplicates.

---

## Syntax

```sql
SELECT column_name
FROM table1

UNION ALL

SELECT column_name
FROM table2;
```

---

## Example

```sql
SELECT city
FROM customers

UNION ALL

SELECT city
FROM suppliers;
```

---

## Result

```text
Delhi
Mumbai
Pune
Mumbai
Bangalore
```

Duplicate Mumbai remains.

---

## Internal Working

1. Combine data
2. Return result

No sorting.

No duplicate removal.

---

## Advantages

- Faster
- Better performance
- No sorting overhead

---

## Disadvantages

- Duplicates remain

---

# UNION vs UNION ALL

| Feature | UNION | UNION ALL |
|----------|----------|----------|
| Duplicate Removal | Yes | No |
| Sorting Required | Yes | No |
| Faster | No | Yes |
| Memory Usage | Higher | Lower |
| Most Common in Production | No | Yes |

---

# INTERSECT

## Definition

Returns only common rows from both queries.

---

## Syntax

```sql
SELECT column_name
FROM table1

INTERSECT

SELECT column_name
FROM table2;
```

---

## Example

```sql
SELECT city
FROM customers

INTERSECT

SELECT city
FROM suppliers;
```

---

## Result

```text
Mumbai
```

Only common values returned.

---

## Use Cases

- Common customers
- Common products
- Data validation
- Matching records

---

# INTERSECT vs INNER JOIN

## INTERSECT

Returns common values.

```sql
SELECT city
FROM customers

INTERSECT

SELECT city
FROM suppliers;
```

---

## INNER JOIN

Returns matching rows.

```sql
SELECT *
FROM customers c
INNER JOIN suppliers s
ON c.city = s.city;
```

---

## Difference

| Feature | INTERSECT | INNER JOIN |
|----------|----------|----------|
| Output | Common values | Full matching rows |
| Duplicate Handling | Removes duplicates | Keeps matches |
| Simplicity | Easier | More flexible |

---

# EXCEPT

## Definition

Returns rows from first query that do not exist in second query.

---

## Syntax

```sql
SELECT column_name
FROM table1

EXCEPT

SELECT column_name
FROM table2;
```

---

## Example

```sql
SELECT city
FROM customers

EXCEPT

SELECT city
FROM suppliers;
```

---

## Result

```text
Delhi
Pune
```

Rows present in first query only.

---

# MINUS

Oracle uses MINUS instead of EXCEPT.

```sql
SELECT city
FROM customers

MINUS

SELECT city
FROM suppliers;
```

---

# EXCEPT vs NOT EXISTS

## EXCEPT

```sql
SELECT city
FROM customers

EXCEPT

SELECT city
FROM suppliers;
```

---

## NOT EXISTS

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM suppliers s
    WHERE s.city = c.city
);
```

---

## Difference

| Feature | EXCEPT | NOT EXISTS |
|----------|----------|----------|
| Simplicity | Easy | Flexible |
| Multiple Conditions | Limited | Excellent |
| Readability | High | Medium |

---

# ORDER BY WITH SET OPERATIONS

ORDER BY can be used only at the end.

---

## Correct

```sql
SELECT city
FROM customers

UNION

SELECT city
FROM suppliers

ORDER BY city;
```

---

## Incorrect

```sql
SELECT city
FROM customers
ORDER BY city

UNION

SELECT city
FROM suppliers;
```

---

# SET OPERATIONS WITH MULTIPLE QUERIES

```sql
SELECT city
FROM customers

UNION

SELECT city
FROM suppliers

UNION

SELECT city
FROM employees;
```

---

# SET OPERATIONS WITH AGGREGATION

```sql
SELECT department_id,
       COUNT(*)
FROM employees
GROUP BY department_id

UNION

SELECT department_id,
       COUNT(*)
FROM contractors
GROUP BY department_id;
```

---

# REAL-WORLD USE CASES

---

## Customer Analysis

Combine customers from multiple systems.

```sql
SELECT customer_email
FROM crm_customers

UNION

SELECT customer_email
FROM website_customers;
```

---

## Product Analysis

Find common products.

```sql
SELECT product_id
FROM online_store

INTERSECT

SELECT product_id
FROM physical_store;
```

---

## Data Validation

Find missing records.

```sql
SELECT employee_id
FROM payroll

EXCEPT

SELECT employee_id
FROM employees;
```

---

## Duplicate Analysis

```sql
SELECT email
FROM source_a

UNION ALL

SELECT email
FROM source_b;
```

---

# PERFORMANCE CONSIDERATIONS

---

## UNION

Slower because:

- Sorts data
- Removes duplicates

---

## UNION ALL

Fastest option.

Recommended when duplicates are acceptable.

---

## INTERSECT

May require:

- Sorting
- Hash matching

Can be expensive on large datasets.

---

## EXCEPT

May require:

- Sorting
- Comparison operations

Performance depends on indexing.

---

# COMMON MISTAKES

---

## Different Number Of Columns

Wrong:

```sql
SELECT employee_id
FROM employees

UNION

SELECT customer_id,
       customer_name
FROM customers;
```

---

## Incompatible Data Types

Wrong:

```sql
SELECT employee_name
FROM employees

UNION

SELECT order_date
FROM orders;
```

---

## ORDER BY In Wrong Position

Wrong:

```sql
SELECT city
FROM customers
ORDER BY city

UNION

SELECT city
FROM suppliers;
```

---

# INTERVIEW QUESTIONS

---

## What is a Set Operation?

A SQL operation used to combine or compare results from multiple SELECT statements.

---

## Difference Between UNION and UNION ALL?

UNION:
- Removes duplicates

UNION ALL:
- Keeps duplicates

---

## Why Is UNION ALL Faster?

Because it does not sort or remove duplicates.

---

## Difference Between INTERSECT and INNER JOIN?

INTERSECT:
- Returns common values

INNER JOIN:
- Returns matching rows

---

## Difference Between EXCEPT and NOT EXISTS?

EXCEPT:
- Easier syntax

NOT EXISTS:
- More flexible

---

## Can Column Names Be Different?

Yes.

Only the number and compatibility of columns matter.

---

## Can Data Types Be Different?

They must be compatible.

---

## Which Set Operation Is Fastest?

UNION ALL

Because it performs no duplicate elimination.

---

# ADVANCED INTERVIEW PROBLEMS

---

## Find Common Customers

```sql
SELECT customer_id
FROM online_customers

INTERSECT

SELECT customer_id
FROM store_customers;
```

---

## Find Missing Employees

```sql
SELECT employee_id
FROM employees

EXCEPT

SELECT employee_id
FROM payroll;
```

---

## Merge Data Sources

```sql
SELECT customer_email
FROM crm

UNION

SELECT customer_email
FROM website;
```

---

# FINAL CHECKLIST

## UNION
✅

## UNION ALL
✅

## INTERSECT
✅

## EXCEPT
✅

## MINUS
✅

## Rules of Set Operations
✅

## UNION vs UNION ALL
✅

## INTERSECT vs INNER JOIN
✅

## EXCEPT vs NOT EXISTS
✅

## ORDER BY Usage
✅

## Performance Considerations
✅

## Common Mistakes
✅

## Real-World Use Cases
✅

## Interview Questions
✅

## Advanced Problems
✅

---

# SUMMARY

Set Operations are essential SQL tools used to combine, compare, and validate datasets.

Key Takeaways:

- Use UNION when duplicates should be removed.
- Use UNION ALL when performance is important.
- Use INTERSECT to find common records.
- Use EXCEPT/MINUS to find missing records.

---

# ADVANCED SET OPERATION CONCEPTS

This section covers advanced concepts, edge cases, database-specific behavior, performance considerations, and interview questions related to SQL Set Operations.

---

# DATA TYPE COMPATIBILITY

For Set Operations to work, corresponding columns must have compatible data types.

---

## Valid Example

```sql
SELECT employee_id
FROM employees

UNION

SELECT customer_id
FROM customers;
```

Both columns are numeric.

---

## Invalid Example

```sql
SELECT employee_name
FROM employees

UNION

SELECT order_date
FROM orders;
```

String and date data types may not be compatible.

---

# COLUMN NAME RULE

Output column names always come from the first SELECT statement.

---

## Example

```sql
SELECT employee_id AS id
FROM employees

UNION

SELECT customer_id
FROM customers;
```

Output:

```text
id
```

The alias from the first query becomes the final column name.

---

# OPERATOR PRECEDENCE

When combining multiple Set Operations, operator precedence may affect results.

Using parentheses improves readability and avoids confusion.

---

## Example

```sql
(
    SELECT city
    FROM customers

    UNION

    SELECT city
    FROM suppliers
)

INTERSECT

SELECT city
FROM employees;
```

---

# USING PARENTHESES

Parentheses help explicitly control execution order.

---

## Example

```sql
(
    SELECT product_id
    FROM online_store

    UNION

    SELECT product_id
    FROM retail_store
)

EXCEPT

SELECT product_id
FROM discontinued_products;
```

---

# NULL HANDLING IN SET OPERATIONS

Many SQL developers overlook NULL behavior.

---

## Table A

```text
NULL
Delhi
```

---

## Table B

```text
NULL
Mumbai
```

---

## UNION Result

```text
NULL
Delhi
Mumbai
```

Only one NULL appears because UNION removes duplicates.

---

## UNION ALL Result

```text
NULL
NULL
Delhi
Mumbai
```

All NULL values are retained.

---

# DISTINCT VS UNION

These are often confused.

---

## DISTINCT

Removes duplicates within a single result set.

```sql
SELECT DISTINCT city
FROM customers;
```

---

## UNION

Removes duplicates across multiple result sets.

```sql
SELECT city
FROM customers

UNION

SELECT city
FROM suppliers;
```

---

# UNION ALL + GROUP BY OPTIMIZATION

Advanced performance technique.

Sometimes using UNION ALL followed by GROUP BY may perform better than UNION on large datasets.

---

## Example

```sql
SELECT city
FROM (
    SELECT city
    FROM customers

    UNION ALL

    SELECT city
    FROM suppliers
) t
GROUP BY city;
```

---

## Why?

UNION:
- Performs duplicate elimination internally

UNION ALL + GROUP BY:
- Gives optimizer more flexibility in some databases

Always test using execution plans.

---

# DATABASE SUPPORT DIFFERENCES

| Database | UNION | UNION ALL | INTERSECT | EXCEPT |
|-----------|---------|---------|---------|---------|
| MySQL | Yes | Yes | Version dependent | Version dependent |
| PostgreSQL | Yes | Yes | Yes | Yes |
| SQL Server | Yes | Yes | Yes | Yes |
| Oracle | Yes | Yes | Yes | Uses MINUS |

---

# SET OPERATIONS VS JOINS

Very common interview topic.

---

## Set Operations

Combine result sets vertically.

```text
Table A

Table B

↓

Combined Rows
```

---

## Joins

Combine tables horizontally.

```text
Table A + Table B

↓

Combined Columns
```

---

## UNION Example

```sql
SELECT employee_name
FROM employees

UNION

SELECT customer_name
FROM customers;
```

---

## JOIN Example

```sql
SELECT *
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
```

---

# WHEN TO USE EACH SET OPERATION

---

## UNION

Use when:

- Duplicates must be removed
- Clean combined result required

---

## UNION ALL

Use when:

- Performance matters
- Duplicates are acceptable

---

## INTERSECT

Use when:

- Finding common records
- Comparing datasets

---

## EXCEPT

Use when:

- Finding missing records
- Data reconciliation
- Data validation

---

# ADVANCED REAL-WORLD USE CASES

---

## Customer Master Creation

```sql
SELECT email
FROM crm_customers

UNION

SELECT email
FROM website_customers;
```

---

## Product Availability Analysis

```sql
SELECT product_id
FROM online_inventory

INTERSECT

SELECT product_id
FROM warehouse_inventory;
```

---

## Missing Employee Detection

```sql
SELECT employee_id
FROM employees

EXCEPT

SELECT employee_id
FROM payroll;
```

---

## Duplicate Detection

```sql
SELECT email
FROM source_a

UNION ALL

SELECT email
FROM source_b;
```

---

# ADVANCED INTERVIEW QUESTIONS

---

## Why is UNION slower than UNION ALL?

UNION removes duplicates, requiring additional sorting or hashing operations.

UNION ALL simply concatenates results.

---

## Can NULL values participate in Set Operations?

Yes.

UNION treats duplicate NULLs as duplicates.

UNION ALL keeps all NULL values.

---

## What determines output column names?

Column names are taken from the first SELECT statement.

---

## Difference Between Set Operations and Joins?

Set Operations:
- Combine rows

Joins:
- Combine columns

---

## Why is UNION ALL preferred in production systems?

Because it avoids duplicate elimination and generally performs better.

---

## Can ORDER BY be used inside every SELECT statement?

Generally no.

ORDER BY should be applied once at the end of the complete Set Operation query.

---

# COMMON INTERVIEW SCENARIOS

---

## Find Common Customers

```sql
SELECT customer_id
FROM online_customers

INTERSECT

SELECT customer_id
FROM store_customers;
```

---

## Find Missing Employees

```sql
SELECT employee_id
FROM employees

EXCEPT

SELECT employee_id
FROM payroll;
```

---

## Merge Multiple Sources

```sql
SELECT email
FROM crm

UNION

SELECT email
FROM website

UNION

SELECT email
FROM mobile_app;
```

---

# FINAL ADVANCED CHECKLIST

## Core Operations

✅ UNION

✅ UNION ALL

✅ INTERSECT

✅ EXCEPT

✅ MINUS

---

## Rules

✅ Same Number of Columns

✅ Compatible Data Types

✅ Column Name Rule

---

## Advanced Concepts

✅ NULL Handling

✅ Operator Precedence

✅ Parentheses

✅ DISTINCT vs UNION

✅ Database Differences

---

## Comparisons

✅ UNION vs UNION ALL

✅ INTERSECT vs INNER JOIN

✅ EXCEPT vs NOT EXISTS

✅ Set Operations vs Joins

---

## Performance

✅ Optimization Tips

✅ UNION ALL Strategy

✅ Execution Considerations

---

## Interview Preparation

✅ Interview Questions

✅ Real-World Use Cases

✅ Advanced Scenarios

---

# SUMMARY

Set Operations are essential for combining, comparing, validating, and reconciling datasets.

Mastering Set Operations helps in:

- Data Analysis
- Data Engineering
- Reporting
- Data Validation
- SQL Interviews
- Production Data Pipelines

Understanding when to use UNION, UNION ALL, INTERSECT, and EXCEPT is a key skill for advanced SQL development.
- Understand performance differences for interviews and real-world projects.

Mastering Set Operations is an important step toward Advanced SQL proficiency.
