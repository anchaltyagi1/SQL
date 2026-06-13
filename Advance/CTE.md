# WITH CLAUSE / COMMON TABLE EXPRESSIONS (CTE)

## What is a CTE?

CTE stands for Common Table Expression.

A CTE is a temporary named result set that exists only during the execution of a query.

It helps:
- Improve readability
- Simplify complex queries
- Break large queries into smaller logical steps
- Create recursive queries
- Reuse query results within the same statement

---

# Basic Syntax

```sql
WITH cte_name AS (
    SELECT column1,
           column2
    FROM table_name
)
SELECT *
FROM cte_name;
```

---

# Why Use CTE?

Without CTE:

```sql
SELECT *
FROM (
    SELECT department_id,
           AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
) t;
```

With CTE:

```sql
WITH dept_avg AS (
    SELECT department_id,
           AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT *
FROM dept_avg;
```

Benefits:

- Better readability
- Easier debugging
- Easier maintenance

---

# Simple CTE

## Example

```sql
WITH employee_cte AS (
    SELECT *
    FROM employees
)
SELECT *
FROM employee_cte;
```

---

# CTE With Filtering

```sql
WITH high_salary_employees AS (
    SELECT *
    FROM employees
    WHERE salary > 50000
)
SELECT *
FROM high_salary_employees;
```

---

# CTE With Aggregation

```sql
WITH department_salary AS (
    SELECT department_id,
           AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT *
FROM department_salary;
```

---

# CTE With JOIN

```sql
WITH employee_department AS (
    SELECT e.employee_id,
           e.employee_name,
           d.department_name
    FROM employees e
    JOIN departments d
        ON e.department_id = d.department_id
)
SELECT *
FROM employee_department;
```

---

# Multiple CTEs

Multiple CTEs can be defined together.

```sql
WITH department_avg AS (
    SELECT department_id,
           AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
),
high_paid_employees AS (
    SELECT *
    FROM employees
    WHERE salary > 50000
)
SELECT *
FROM high_paid_employees;
```

---

# Referencing One CTE Inside Another

```sql
WITH department_avg AS (
    SELECT department_id,
           AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
),
above_average AS (
    SELECT e.*
    FROM employees e
    JOIN department_avg d
        ON e.department_id = d.department_id
    WHERE e.salary > d.avg_salary
)
SELECT *
FROM above_average;
```

---

# CTE With Window Functions

Very common in interviews.

```sql
WITH ranked_employees AS (
    SELECT *,
           DENSE_RANK() OVER(
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rnk <= 3;
```

---

# CTE With ROW_NUMBER()

```sql
WITH latest_orders AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
)
SELECT *
FROM latest_orders
WHERE rn = 1;
```

---

# Recursive CTE

One of the most important advanced SQL concepts.

A Recursive CTE references itself.

Used for:

- Employee hierarchy
- Category hierarchy
- Folder structure
- Organizational charts
- Parent-child relationships

---

# Recursive CTE Syntax

```sql
WITH RECURSIVE cte_name AS (

    -- Anchor Query

    SELECT ...

    UNION ALL

    -- Recursive Query

    SELECT ...
    FROM table
    JOIN cte_name
)

SELECT *
FROM cte_name;
```

---

# Employee Hierarchy Example

```sql
WITH RECURSIVE employee_hierarchy AS (

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
           eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh
        ON e.manager_id = eh.employee_id

)

SELECT *
FROM employee_hierarchy;
```

---

# Category Hierarchy Example

```sql
WITH RECURSIVE category_tree AS (

    SELECT category_id,
           category_name,
           parent_category_id
    FROM categories
    WHERE parent_category_id IS NULL

    UNION ALL

    SELECT c.category_id,
           c.category_name,
           c.parent_category_id
    FROM categories c
    JOIN category_tree ct
        ON c.parent_category_id = ct.category_id

)

SELECT *
FROM category_tree;
```

---

# CTE vs Subquery

| Feature | CTE | Subquery |
|----------|----------|----------|
| Readability | High | Medium |
| Reusability | Yes | No |
| Maintenance | Easy | Difficult |
| Complex Queries | Better | Harder |
| Recursive Support | Yes | No |

---

# CTE vs Temporary Table

| Feature | CTE | Temporary Table |
|----------|----------|----------|
| Storage | Memory/Execution | Physical Temp Storage |
| Lifetime | Single Query | Session |
| Reusable | Within Query | Multiple Queries |
| Creation | Easy | Requires CREATE TABLE |

---

# CTE vs View

| Feature | CTE | View |
|----------|----------|----------|
| Permanent | No | Yes |
| Scope | Single Query | Database Object |
| Storage | No | No |
| Reusability | Limited | High |

---

# Real World Use Cases

## Employee Hierarchy

Manager → Employee relationship

---

## Organization Structure

CEO → VP → Manager → Employee

---

## Product Categories

Electronics
→ Mobile
→ Laptop

---

## Folder Structures

Root Folder
→ Child Folder
→ Sub Folder

---

## Multi-Step Analytics

Breaking large analytical queries into logical parts.

---

# Performance Considerations

## Advantages

- Improves readability
- Easier debugging
- Easier maintenance
- Better organization

---

## Important Note

CTEs are not always faster.

Query optimizer decides execution plan.

In some databases:

- CTE may be materialized
- CTE may be inlined

Performance depends on database engine.

---

# Common Mistakes

## Missing Alias

Wrong:

```sql
WITH (
    SELECT *
    FROM employees
)
```

Correct:

```sql
WITH employee_cte AS (
    SELECT *
    FROM employees
)
```

---

## Infinite Recursive CTE

Wrong recursion can create infinite loops.

Always define proper stopping conditions.

---

## Using CTE When Simple Query Is Enough

Avoid unnecessary complexity.

---

# Most Asked Interview Questions

## What is a CTE?

A Common Table Expression is a temporary named result set used within a query.

---

## Why use CTE?

- Better readability
- Easier maintenance
- Complex query simplification

---

## What is Recursive CTE?

A CTE that references itself.

Used for hierarchical data.

---

## Difference Between CTE and Subquery?

CTE:
- Reusable
- Readable
- Supports recursion

Subquery:
- Nested
- Less readable
- No recursion

---

## Difference Between CTE and Temporary Table?

CTE:
- Exists only during query execution

Temporary Table:
- Exists during session

---

## Can Multiple CTEs Be Used?

Yes.

Multiple CTEs can be defined in the same WITH clause.

---

## Is CTE Faster Than Subquery?

Not necessarily.

Performance depends on query optimizer and database engine.

---

# Advanced Interview Questions

## Find Top 3 Salaries Using CTE

```sql
WITH ranked_employees AS (
    SELECT *,
           DENSE_RANK() OVER(
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rnk <= 3;
```

---

## Find Latest Order Per Customer

```sql
WITH latest_orders AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
)
SELECT *
FROM latest_orders
WHERE rn = 1;
```

---

# Summary

Topics Covered:

✅ What is CTE

✅ Simple CTE

✅ Multiple CTEs

✅ CTE With JOIN

✅ CTE With Aggregation

✅ CTE With Window Functions

✅ Recursive CTE

✅ Employee Hierarchy

✅ Category Hierarchy

✅ CTE vs Subquery

✅ CTE vs View

✅ CTE vs Temporary Table

✅ Performance Considerations

✅ Common Mistakes

✅ Interview Questions

---

# ADVANCED RECURSIVE CTE CONCEPTS

This section covers advanced Recursive CTE concepts frequently asked in SQL interviews and used in real-world hierarchical data processing.

---

# NON-RECURSIVE VS RECURSIVE CTE

## Non-Recursive CTE

Used for simplifying queries.

```sql
WITH department_avg AS (
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT *
FROM department_avg;
```

### Characteristics

- Does not reference itself
- Used for readability
- Used for breaking complex queries

---

## Recursive CTE

References itself.

```sql
WITH RECURSIVE employee_tree AS (
    ...
)
SELECT *
FROM employee_tree;
```

### Characteristics

- References itself
- Used for hierarchy traversal
- Used for tree structures

---

# RECURSIVE CTE STRUCTURE

Every Recursive CTE contains two parts:

## 1. Anchor Query

Starting point of recursion.

```sql
SELECT employee_id,
       manager_id
FROM employees
WHERE manager_id IS NULL
```

---

## 2. Recursive Query

Executes repeatedly.

```sql
SELECT e.employee_id,
       e.manager_id
FROM employees e
JOIN employee_tree et
    ON e.manager_id = et.employee_id
```

---

## Complete Example

```sql
WITH RECURSIVE employee_tree AS (

    -- Anchor Query

    SELECT employee_id,
           employee_name,
           manager_id
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive Query

    SELECT e.employee_id,
           e.employee_name,
           e.manager_id
    FROM employees e
    JOIN employee_tree et
        ON e.manager_id = et.employee_id

)
SELECT *
FROM employee_tree;
```

---

# UNION VS UNION ALL IN RECURSIVE CTE

Most Recursive CTEs use:

```sql
UNION ALL
```

instead of:

```sql
UNION
```

### Why?

UNION:
- Removes duplicates
- Extra sorting
- Slower

UNION ALL:
- Keeps duplicates
- Faster
- Preferred in recursion

---

# RECURSION LEVEL TRACKING

Used to identify hierarchy depth.

```sql
WITH RECURSIVE employee_tree AS (

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
           et.level + 1
    FROM employees e
    JOIN employee_tree et
        ON e.manager_id = et.employee_id

)
SELECT *
FROM employee_tree;
```

---

## Example Output

| Employee | Level |
|-----------|---------|
| CEO | 1 |
| Manager | 2 |
| Team Lead | 3 |
| Employee | 4 |

---

# PATH BUILDING

Shows complete hierarchy path.

```sql
WITH RECURSIVE employee_tree AS (

    SELECT employee_id,
           employee_name,
           manager_id,
           CAST(employee_name AS VARCHAR(500)) AS hierarchy_path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id,
           e.employee_name,
           e.manager_id,
           CONCAT(
               et.hierarchy_path,
               ' -> ',
               e.employee_name
           )
    FROM employees e
    JOIN employee_tree et
        ON e.manager_id = et.employee_id

)
SELECT *
FROM employee_tree;
```

---

## Example Output

```text
CEO
CEO -> Manager
CEO -> Manager -> Team Lead
CEO -> Manager -> Team Lead -> Employee
```

---

# CYCLE DETECTION

A cycle occurs when recursion loops forever.

Example:

```text
A -> B
B -> C
C -> A
```

This creates infinite recursion.

---

## Prevention Techniques

- Proper data validation
- Maximum recursion limits
- Cycle detection mechanisms

---

# TERMINATION CONDITION

Recursive CTE stops when:

- No new rows are produced
- Maximum recursion depth is reached

Without a termination condition, recursion may continue indefinitely.

---

# MAXRECURSION (SQL SERVER)

Limits recursion depth.

```sql
WITH employee_tree AS (
    ...
)
SELECT *
FROM employee_tree
OPTION (MAXRECURSION 100);
```

---

## Benefits

- Prevents infinite loops
- Improves safety
- Easier debugging

---

# GENERATE NUMBERS USING RECURSIVE CTE

Popular interview question.

```sql
WITH RECURSIVE numbers AS (

    SELECT 1 AS num

    UNION ALL

    SELECT num + 1
    FROM numbers
    WHERE num < 10

)
SELECT *
FROM numbers;
```

---

## Output

```text
1
2
3
4
5
6
7
8
9
10
```

---

# GENERATE CALENDAR DATES

Very useful in analytics.

```sql
WITH RECURSIVE calendar_dates AS (

    SELECT DATE '2025-01-01' AS dt

    UNION ALL

    SELECT dt + INTERVAL '1 DAY'
    FROM calendar_dates
    WHERE dt < DATE '2025-12-31'

)
SELECT *
FROM calendar_dates;
```

---

## Use Cases

- Date dimensions
- Missing date detection
- Time-series analysis

---

# RECURSIVE CTE PERFORMANCE CONSIDERATIONS

## Advantages

- Elegant hierarchy processing
- Eliminates procedural loops
- Easier maintenance

---

## Disadvantages

- Can be memory intensive
- Can become slow for deep recursion
- Risk of infinite loops

---

## Best Practices

- Always define stopping condition
- Use UNION ALL when possible
- Limit recursion depth
- Avoid unnecessary columns

---

# ADVANCED INTERVIEW QUESTIONS

## What is the difference between Recursive and Non-Recursive CTE?

Recursive:
- References itself

Non-Recursive:
- Does not reference itself

---

## What are Anchor Query and Recursive Query?

Anchor Query:
- Starting point

Recursive Query:
- Repeated execution until termination

---

## Why is UNION ALL preferred in Recursive CTE?

Because it avoids duplicate elimination and improves performance.

---

## How does recursion stop?

When:
- No new rows are returned
- Maximum recursion limit is reached

---

## What is MAXRECURSION?

A SQL Server option that limits recursion depth.

---

## What are common use cases of Recursive CTE?

- Employee hierarchy
- Organization charts
- Category trees
- Folder structures
- Calendar generation

---

# FINAL RECURSIVE CTE CHECKLIST

## Basic CTE
✅

## Multiple CTEs
✅

## CTE with JOIN
✅

## CTE with Aggregation
✅

## CTE with Window Functions
✅

## Recursive CTE
✅

## Employee Hierarchy
✅

## Category Hierarchy
✅

## Anchor Query
✅

## Recursive Query
✅

## Level Tracking
✅

## Path Building
✅

## Cycle Detection
✅

## Termination Conditions
✅

## MAXRECURSION
✅

## Number Generation
✅

## Calendar Generation
✅

## Performance Considerations
✅

## Interview Questions
✅

---

# SUMMARY

Recursive CTEs are one of the most powerful SQL features for handling hierarchical and recursive data structures.

Mastering Recursive CTEs helps solve:
- Hierarchies
- Tree Structures
- Organizational Reporting
- Calendar Generation
- Advanced SQL Interview Problems

✅ Advanced Interview Problems

CTEs are one of the most important SQL concepts for writing clean, maintainable, and advanced SQL queries.
