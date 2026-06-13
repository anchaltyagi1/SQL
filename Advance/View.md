# VIEWS IN SQL

## What is a View?

A View is a virtual table based on the result of a SQL query.

A View does not store data physically (except Materialized Views). It stores the query definition and fetches data from underlying tables whenever it is accessed.

---

# Why Use Views?

Views are used for:

- Simplifying complex queries
- Hiding sensitive data
- Providing data security
- Reusing frequently used queries
- Creating abstraction layers

---

# Basic Syntax

```sql
CREATE VIEW view_name AS
SELECT column1,
       column2
FROM table_name;
```

---

# Example

```sql
CREATE VIEW employee_view AS
SELECT employee_id,
       employee_name,
       salary
FROM employees;
```

Use the view:

```sql
SELECT *
FROM employee_view;
```

---

# Simple View

A view based on a single table.

```sql
CREATE VIEW active_customers AS
SELECT customer_id,
       customer_name
FROM customers
WHERE status = 'Active';
```

---

# Complex View

A view created using joins, aggregations, or multiple tables.

```sql
CREATE VIEW employee_department_view AS
SELECT e.employee_name,
       d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
```

---

# View with WHERE Clause

```sql
CREATE VIEW high_salary_employees AS
SELECT *
FROM employees
WHERE salary > 50000;
```

---

# View with Aggregate Function

```sql
CREATE VIEW department_salary_summary AS
SELECT department_id,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;
```

---

# View with JOIN

```sql
CREATE VIEW customer_orders AS
SELECT c.customer_name,
       o.order_id,
       o.order_date
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;
```

---

# Updating Data Through a View

```sql
UPDATE employee_view
SET salary = 60000
WHERE employee_id = 1;
```

Changes are applied to the base table.

---

# Updatable Views

A view is generally updatable when:

- Based on one table
- No GROUP BY
- No DISTINCT
- No Aggregate Functions
- No UNION
- No Window Functions

---

# Non-Updatable Views

Usually not updatable if they contain:

```sql
GROUP BY
DISTINCT
UNION
SUM()
AVG()
COUNT()
JOIN (database dependent)
Window Functions
```

Example:

```sql
CREATE VIEW dept_summary AS
SELECT department_id,
       AVG(salary)
FROM employees
GROUP BY department_id;
```

This view is generally not updatable.

---

# Read-Only View

Some databases allow read-only views.

```sql
CREATE VIEW employee_view AS
SELECT *
FROM employees
WITH READ ONLY;
```

---

# Creating View with Column Aliases

```sql
CREATE VIEW employee_details AS
SELECT employee_id AS id,
       employee_name AS name
FROM employees;
```

---

# Replace View

Replace existing view.

```sql
CREATE OR REPLACE VIEW employee_view AS
SELECT employee_id,
       employee_name
FROM employees;
```

---

# Alter View

```sql
ALTER VIEW employee_view AS
SELECT employee_id,
       employee_name,
       salary
FROM employees;
```

---

# Drop View

```sql
DROP VIEW employee_view;
```

---

# View vs Table

| View | Table |
|--------|--------|
| Virtual | Physical |
| Stores Query | Stores Data |
| Less Storage | Requires Storage |
| Data from Tables | Actual Data |

---

# View vs CTE

| View | CTE |
|--------|--------|
| Permanent Object | Temporary |
| Reusable | Query Specific |
| Stored in Database | Exists During Query |

---

# View vs Temporary Table

| View | Temporary Table |
|--------|--------|
| Virtual | Physical |
| No Data Storage | Stores Data |
| Permanent Definition | Session Based |

---

# Advantages of Views

### Security

Hide sensitive columns.

```sql
CREATE VIEW employee_public AS
SELECT employee_id,
       employee_name
FROM employees;
```

---

### Simplicity

Complex queries can be simplified.

---

### Reusability

Write query once and use multiple times.

---

### Consistency

Business logic remains centralized.

---

# Disadvantages of Views

### Performance Overhead

Complex views may run slowly.

---

### Dependency Issues

Changes in underlying tables may break views.

---

### Limited Update Capability

Not all views are updatable.

---

# Security Use Cases

Hide confidential information.

Instead of:

```sql
SELECT *
FROM employees;
```

Use:

```sql
CREATE VIEW employee_public AS
SELECT employee_id,
       employee_name,
       department_id
FROM employees;
```

Users cannot access salary information.

---

# Real-World Use Cases

## Dashboard Layer

```text
Dashboard
    ↓
Views
    ↓
Base Tables
```

---

## Reporting

Create business-friendly views.

---

## Data Security

Expose only required columns.

---

## Data Abstraction

Hide complex joins from end users.

---

# Performance Considerations

Views do not store data.

Every time a view is executed:

```text
View Query
      ↓
Underlying Tables
      ↓
Result
```

Performance depends on:

- Query complexity
- Table size
- Indexes
- Database optimizer

---

# Common Mistakes

## Using SELECT *

Avoid:

```sql
CREATE VIEW employee_view AS
SELECT *
FROM employees;
```

Prefer:

```sql
CREATE VIEW employee_view AS
SELECT employee_id,
       employee_name
FROM employees;
```

---

## Deeply Nested Views

View on top of View on top of View.

Can reduce performance and readability.

---

## Assuming Views Improve Performance

Regular Views do not improve performance.

They only simplify queries.

---

# Interview Questions

## What is a View?

A View is a virtual table based on a SQL query.

---

## Does a View Store Data?

Regular View: No

Materialized View: Yes

---

## Difference Between View and Table?

View stores query definition.

Table stores actual data.

---

## Difference Between View and CTE?

View is permanent.

CTE exists only during query execution.

---

## Can We Update Data Through a View?

Yes, if the view is updatable.

---

## Why Use Views?

- Security
- Simplicity
- Reusability
- Abstraction

---

## Can Views Improve Performance?

Normally no.

Only Materialized Views or Indexed Views can improve performance.

---

## What Happens If Base Table Is Dropped?

The View becomes invalid or unusable.

---

# Advanced Interview Questions

## Can a View Be Created on Another View?

Yes.

```sql
CREATE VIEW view2 AS
SELECT *
FROM view1;
```

---

## Can We Use JOIN in a View?

Yes.

---

## Can We Create Index on a View?

In some databases (e.g., SQL Server Indexed Views).

---

## Can a View Contain Aggregate Functions?

Yes.

But it usually becomes non-updatable.

---

# Best Practices

✅ Use meaningful view names

✅ Avoid SELECT *

✅ Use views for security

✅ Keep views simple

✅ Document business logic

✅ Avoid excessive nested views

---

# Final Checklist

## Basics

✅ What is a View

✅ Syntax

✅ Simple View

✅ Complex View

---

## Operations

✅ Create View

✅ Replace View

✅ Alter View

✅ Drop View

---

## Types

✅ Simple View

✅ Complex View

✅ Read Only View

✅ Updatable View

---

## Comparisons

✅ View vs Table

✅ View vs CTE

✅ View vs Temp Table

---

## Security

✅ Hide Sensitive Columns

✅ Controlled Data Access

---

## Performance

✅ Considerations

✅ Limitations

---

## Interview Preparation

✅ Frequently Asked Questions

✅ Advanced Questions

---

# Summary

Views are one of the most commonly used database objects in SQL.

They help:
- Simplify complex queries
- Improve security
- Reuse business logic
- Provide abstraction for reporting and dashboards

Views are heavily used in Data Analyst, BI Developer, Analytics Engineer, and Data Engineer projects.

---

# MATERIALIZED VIEWS

## What is a Materialized View?

A Materialized View stores the result of a query physically on disk.

Unlike a regular View, it stores actual data.

---

## Regular View

```text
View
 ↓
Runs Query Every Time
 ↓
Fetches Latest Data
```

---

## Materialized View

```text
Materialized View
 ↓
Stores Query Result
 ↓
Returns Stored Data
```

---

# Syntax

```sql
CREATE MATERIALIZED VIEW sales_summary AS
SELECT product_id,
       SUM(amount) AS total_sales
FROM sales
GROUP BY product_id;
```

---

# Query Materialized View

```sql
SELECT *
FROM sales_summary;
```

---

# Refresh Materialized View

Since data is stored physically, it must be refreshed.

```sql
REFRESH MATERIALIZED VIEW sales_summary;
```

---

# Types of Refresh

## Complete Refresh

Rebuilds entire Materialized View.

```sql
REFRESH MATERIALIZED VIEW sales_summary;
```

---

## Fast Refresh

Only changed records are refreshed.

Faster than complete refresh.

---

## Incremental Refresh

Updates only modified portions.

Used in large databases.

---

# Advantages

- Faster reporting
- Faster aggregations
- Reduces load on base tables
- Improves dashboard performance

---

# Disadvantages

- Requires storage
- Refresh overhead
- Data may become stale

---

# Real World Use Cases

## Dashboard Reporting

```text
Dashboard
    ↓
Materialized View
    ↓
Sales Table
```

---

## Monthly Sales Summary

```sql
CREATE MATERIALIZED VIEW monthly_sales AS
SELECT month,
       SUM(sales_amount)
FROM sales
GROUP BY month;
```

---

# VIEW VS MATERIALIZED VIEW

| View | Materialized View |
|--------|--------|
| Virtual | Physical |
| No Data Storage | Stores Data |
| Always Latest | Requires Refresh |
| Slower Reads | Faster Reads |

---

# INDEXED VIEWS (SQL SERVER)

## What is an Indexed View?

An Indexed View is a View that has an index.

SQL Server stores indexed view results physically.

---

# Create Indexed View

```sql
CREATE VIEW sales_view
WITH SCHEMABINDING
AS
SELECT product_id,
       COUNT_BIG(*) AS total_count
FROM dbo.sales
GROUP BY product_id;
```

---

# Create Index

```sql
CREATE UNIQUE CLUSTERED INDEX idx_sales
ON sales_view(product_id);
```

---

# Why SCHEMABINDING?

Prevents changes to underlying tables that could break the view.

---

# Advantages

- Faster reporting
- Faster aggregation queries
- Precomputed results

---

# Disadvantages

- Extra storage
- Slower INSERT/UPDATE/DELETE
- Additional maintenance

---

# Indexed View Use Cases

## Reporting Systems

```text
Fact Table
      ↓
Indexed View
      ↓
Dashboard
```

---

## Large Aggregations

```sql
SELECT product_id,
       SUM(amount)
FROM sales
GROUP BY product_id;
```

Frequently used aggregations benefit from Indexed Views.

---

# VIEW VS INDEXED VIEW

| View | Indexed View |
|--------|--------|
| Virtual | Physical |
| No Index | Has Index |
| No Storage | Uses Storage |
| Slower Reads | Faster Reads |

---

# MATERIALIZED VIEW VS INDEXED VIEW

| Materialized View | Indexed View |
|------------------|--------------|
| Oracle/PostgreSQL Common | SQL Server Common |
| Refresh Required | Maintained by Index |
| Stores Data | Stores Indexed Data |

---

# INTERVIEW QUESTIONS

## What is a Materialized View?

A Materialized View physically stores query results.

---

## Difference Between View and Materialized View?

View:
- Virtual

Materialized View:
- Physical

---

## Why Are Materialized Views Faster?

Because query results are already stored.

---

## What is an Indexed View?

A View with an index that stores precomputed results.

---

## Why Use SCHEMABINDING?

To prevent changes to underlying tables.

---

## Can Indexed Views Improve Performance?

Yes.

Especially for:
- Aggregations
- Reporting
- Dashboard Queries

---

# FINAL VIEWS CHECKLIST

## Basic Views
✅

## Complex Views
✅

## Updatable Views
✅

## Read Only Views
✅

## Security Views
✅

## View Operations
✅

## Materialized Views
✅

## Refresh Types
✅

## Indexed Views
✅

## SCHEMABINDING
✅

## Comparisons
✅

## Performance Considerations
✅

## Real World Use Cases
✅

## Interview Questions
✅

---

# SUMMARY

Views are one of the most important database objects in SQL.

Types Covered:

- Regular Views
- Updatable Views
- Read Only Views
- Materialized Views
- Indexed Views

Mastering Views is important for:
- Data Analyst Interviews
- BI Developer Roles
- Data Engineering
- Reporting Systems
- Dashboard Development
