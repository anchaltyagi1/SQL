# 🪟 WINDOW FUNCTIONS IN SQL (COMPLETE GUIDE)

## 📌 What are Window Functions?

Window functions perform calculations across a set of rows related to the current row without collapsing the result set.

Unlike GROUP BY:
- GROUP BY reduces rows
- Window Functions keep all rows

Window functions are heavily used in:
- Data Analytics
- Business Intelligence
- Financial Reporting
- Data Engineering
- SQL Interviews

---

# WINDOW FUNCTION SYNTAX

```sql
SELECT column_name,
       window_function() OVER (
           PARTITION BY column_name
           ORDER BY column_name
       )
FROM table_name;
```

---

# COMPONENTS OF WINDOW FUNCTIONS

## OVER()

Defines the window of rows.

```sql
SELECT salary,
       AVG(salary) OVER()
FROM employees;
```

---

## PARTITION BY

Splits data into groups before calculation.

```sql
SELECT employee_name,
       department_id,
       salary,
       RANK() OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS dept_rank
FROM employees;
```

### Example

Without PARTITION BY:

| Employee | Salary | Rank |
|-----------|---------|------|
| A | 10000 | 1 |
| B | 9000 | 2 |
| C | 8000 | 3 |

With PARTITION BY department:

Ranking starts again for each department.

---

## ORDER BY

Defines sequence of rows within the window.

```sql
SELECT employee_name,
       salary,
       ROW_NUMBER() OVER(
           ORDER BY salary DESC
       ) AS rn
FROM employees;
```

---

# RANKING FUNCTIONS

---

## ROW_NUMBER()

Assigns unique sequential numbers.

```sql
SELECT employee_name,
       salary,
       ROW_NUMBER() OVER(
           ORDER BY salary DESC
       ) AS rn
FROM employees;
```

### Example

| Salary | ROW_NUMBER |
|---------|------------|
| 100 | 1 |
| 90 | 2 |
| 90 | 3 |
| 80 | 4 |

### Use Cases

- Remove duplicates
- Top N records
- Pagination

---

## RANK()

Assigns same rank to ties and skips next rank.

```sql
SELECT employee_name,
       salary,
       RANK() OVER(
           ORDER BY salary DESC
       ) AS rnk
FROM employees;
```

### Example

| Salary | Rank |
|---------|------|
| 100 | 1 |
| 90 | 2 |
| 90 | 2 |
| 80 | 4 |

---

## DENSE_RANK()

Assigns same rank to ties without gaps.

```sql
SELECT employee_name,
       salary,
       DENSE_RANK() OVER(
           ORDER BY salary DESC
       ) AS drnk
FROM employees;
```

### Example

| Salary | Dense Rank |
|---------|------------|
| 100 | 1 |
| 90 | 2 |
| 90 | 2 |
| 80 | 3 |

---

## ROW_NUMBER vs RANK vs DENSE_RANK

| Function | Duplicate Rank | Gap |
|-----------|---------------|-----|
| ROW_NUMBER | No | No |
| RANK | Yes | Yes |
| DENSE_RANK | Yes | No |

---

# AGGREGATE WINDOW FUNCTIONS

---

## SUM()

### Total Sum

```sql
SELECT employee_name,
       salary,
       SUM(salary) OVER() AS total_salary
FROM employees;
```

---

## Running Total

```sql
SELECT order_date,
       sales,
       SUM(sales) OVER(
           ORDER BY order_date
       ) AS running_total
FROM sales;
```

---

## AVG()

```sql
SELECT employee_name,
       salary,
       AVG(salary) OVER() AS avg_salary
FROM employees;
```

---

## Running Average

```sql
SELECT order_date,
       sales,
       AVG(sales) OVER(
           ORDER BY order_date
       ) AS running_avg
FROM sales;
```

---

## COUNT()

```sql
SELECT employee_name,
       COUNT(*) OVER() AS total_employees
FROM employees;
```

---

## Running Count

```sql
SELECT order_date,
       COUNT(*) OVER(
           ORDER BY order_date
       ) AS running_count
FROM orders;
```

---

## MIN()

```sql
SELECT employee_name,
       salary,
       MIN(salary) OVER() AS min_salary
FROM employees;
```

---

## MAX()

```sql
SELECT employee_name,
       salary,
       MAX(salary) OVER() AS max_salary
FROM employees;
```

---

# NAVIGATION FUNCTIONS

---

## LAG()

Returns previous row value.

```sql
SELECT month,
       sales,
       LAG(sales) OVER(
           ORDER BY month
       ) AS previous_month_sales
FROM sales;
```

### Use Cases

- Month-over-month analysis
- Trend analysis

---

## LEAD()

Returns next row value.

```sql
SELECT month,
       sales,
       LEAD(sales) OVER(
           ORDER BY month
       ) AS next_month_sales
FROM sales;
```

---

## FIRST_VALUE()

Returns first value from the window.

```sql
SELECT employee_id,
       salary,
       FIRST_VALUE(salary) OVER(
           ORDER BY salary DESC
       ) AS highest_salary
FROM employees;
```

---

## LAST_VALUE()

Returns last value from the window.

```sql
SELECT employee_id,
       salary,
       LAST_VALUE(salary) OVER(
           ORDER BY salary
           ROWS BETWEEN UNBOUNDED PRECEDING
           AND UNBOUNDED FOLLOWING
       ) AS highest_salary
FROM employees;
```

### Interview Trap

Without proper frame definition,
LAST_VALUE() may return unexpected results.

---

## NTH_VALUE()

Returns nth value from window.

```sql
SELECT employee_id,
       salary,
       NTH_VALUE(salary,3) OVER(
           ORDER BY salary DESC
       ) AS third_highest_salary
FROM employees;
```

---

# DISTRIBUTION FUNCTIONS

---

## NTILE()

Divides rows into buckets.

```sql
SELECT employee_id,
       salary,
       NTILE(4) OVER(
           ORDER BY salary DESC
       ) AS quartile
FROM employees;
```

### Use Cases

- Quartile analysis
- Customer segmentation

---

## PERCENT_RANK()

Returns relative ranking percentage.

```sql
SELECT employee_id,
       salary,
       PERCENT_RANK() OVER(
           ORDER BY salary
       ) AS pct_rank
FROM employees;
```

---

## CUME_DIST()

Returns cumulative distribution.

```sql
SELECT employee_id,
       salary,
       CUME_DIST() OVER(
           ORDER BY salary
       ) AS cumulative_distribution
FROM employees;
```

---

# WINDOW FRAMES

Window frame defines which rows participate in calculation.

---

## ROWS BETWEEN

Uses physical row positions.

```sql
ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW
```

### Example

```sql
SELECT month,
       sales,
       AVG(sales) OVER(
           ORDER BY month
           ROWS BETWEEN 2 PRECEDING
           AND CURRENT ROW
       ) AS moving_average
FROM sales;
```

---

## RANGE BETWEEN

Uses value ranges instead of row counts.

```sql
RANGE BETWEEN 100 PRECEDING
AND CURRENT ROW
```

---

## ROWS vs RANGE

| Feature | ROWS | RANGE |
|----------|-------|--------|
| Based On | Physical Rows | Values |
| Performance | Faster | Can be slower |
| Usage | Running calculations | Value-based calculations |

---

# IMPORTANT CONCEPTS

---

## GROUP BY vs WINDOW FUNCTIONS

| Feature | GROUP BY | WINDOW FUNCTION |
|----------|----------|----------------|
| Row Count | Reduced | Preserved |
| Detail Level | Lost | Maintained |
| Analytics | Limited | Advanced |

---

## PARTITION BY vs GROUP BY

GROUP BY:
- Aggregates rows

PARTITION BY:
- Creates groups for calculation
- Keeps rows intact

---

# MOST ASKED INTERVIEW PROBLEMS

---

## Second Highest Salary

```sql
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER(
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 2;
```

---

## Third Highest Salary

```sql
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER(
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 3;
```

---

## Top 3 Salaries Per Department

```sql
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER(
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk <= 3;
```

---

## Remove Duplicates

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY email
               ORDER BY customer_id
           ) AS rn
    FROM customers
) t
WHERE rn = 1;
```

---

## Latest Record Per Customer

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

---

## Running Total

```sql
SELECT order_date,
       sales,
       SUM(sales) OVER(
           ORDER BY order_date
       ) AS running_total
FROM sales;
```

---

# PERFORMANCE CONSIDERATIONS

## Why Window Functions Can Be Expensive

They require:
- Sorting
- Partitioning
- Memory usage

---

## Optimization Tips

### Index ORDER BY columns

### Index PARTITION BY columns

### Filter rows before applying window functions

### Avoid unnecessary calculations

### Use only required columns

Avoid:

```sql
SELECT *
```

Prefer:

```sql
SELECT employee_id,
       salary
```

---

# INTERVIEW QUESTIONS WITH ANSWERS

## What are Window Functions?

Functions that perform calculations across related rows while preserving row-level detail.

---

## Difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?

ROW_NUMBER:
- Unique numbering

RANK:
- Same rank for ties
- Skips numbers

DENSE_RANK:
- Same rank for ties
- No gaps

---

## Difference between GROUP BY and Window Functions?

GROUP BY:
- Reduces rows

Window Functions:
- Keep rows

---

## What is PARTITION BY?

Creates logical groups for calculations while preserving rows.

---

## What are LAG and LEAD?

LAG:
- Previous row value

LEAD:
- Next row value

---

## Why are Window Functions important?

They solve:
- Ranking
- Running totals
- Trend analysis
- Time-series analytics
- Top-N problems

---

# SUMMARY

Window Functions are among the most important SQL concepts.

Topics Covered:

✅ OVER()

✅ PARTITION BY

✅ ORDER BY

✅ ROW_NUMBER()

✅ RANK()

✅ DENSE_RANK()

✅ SUM()

✅ AVG()

✅ COUNT()

✅ MIN()

✅ MAX()

✅ LAG()

✅ LEAD()

✅ FIRST_VALUE()

✅ LAST_VALUE()

✅ NTH_VALUE()

✅ NTILE()

✅ PERCENT_RANK()

✅ CUME_DIST()

✅ ROWS BETWEEN

✅ RANGE BETWEEN

✅ Running Totals

✅ Moving Averages

✅ Top-N Problems

✅ Duplicate Removal

✅ Performance Optimization

---

# ADVANCED WINDOW FUNCTION CONCEPTS

These concepts are less common than ROW_NUMBER(), RANK(), and LAG(), but are frequently used in real-world analytics and advanced SQL interviews.

---

# 1. WINDOW NAMING (WINDOW CLAUSE)

Instead of repeating the same window definition multiple times, we can create a named window.

## Example

```sql
SELECT employee_name,
       salary,
       RANK() OVER w AS rnk,
       AVG(salary) OVER w AS avg_salary
FROM employees
WINDOW w AS (
    PARTITION BY department_id
    ORDER BY salary DESC
);
```

## Benefits

- Improves readability
- Avoids repeating logic
- Easier maintenance

---

# 2. MULTIPLE WINDOW FUNCTIONS IN SAME QUERY

Multiple window functions can be used together.

## Example

```sql
SELECT employee_name,
       salary,
       ROW_NUMBER() OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS rn,
       AVG(salary) OVER(
           PARTITION BY department_id
       ) AS dept_avg
FROM employees;
```

## Interview Question

Can multiple window functions be used in one query?

### Answer

Yes. Each window function is calculated independently.

---

# 3. PERCENTAGE CONTRIBUTION ANALYSIS

Used heavily in dashboards.

## Example

```sql
SELECT employee_name,
       salary,
       ROUND(
           salary * 100.0 /
           SUM(salary) OVER(),
           2
       ) AS salary_percentage
FROM employees;
```

## Use Cases

- Revenue contribution
- Profit contribution
- Product sales contribution

---

# 4. DIFFERENCE FROM PREVIOUS ROW

Using LAG().

## Example

```sql
SELECT month,
       sales,
       sales -
       LAG(sales) OVER(
           ORDER BY month
       ) AS difference
FROM sales;
```

## Output

| Month | Sales | Difference |
|---------|---------|------------|
| Jan | 100 | NULL |
| Feb | 120 | 20 |
| Mar | 110 | -10 |

---

# 5. PERCENTAGE GROWTH ANALYSIS

Very common in interviews.

## Example

```sql
SELECT month,
       sales,
       ROUND(
           (
               sales -
               LAG(sales) OVER(
                   ORDER BY month
               )
           ) * 100.0 /
           LAG(sales) OVER(
               ORDER BY month
           ),
           2
       ) AS growth_percentage
FROM sales;
```

## Use Cases

- Month-over-month growth
- Quarter-over-quarter growth
- Year-over-year growth

---

# 6. GROWTH FROM FIRST VALUE

Compare current value with first value.

## Example

```sql
SELECT month,
       sales,
       sales -
       FIRST_VALUE(sales) OVER(
           ORDER BY month
       ) AS growth_from_start
FROM sales;
```

---

# 7. CTE + WINDOW FUNCTION

Extremely common in interviews.

## Example

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

## Use Case

Top N analysis.

---

# 8. QUALIFY CLAUSE

Supported in Snowflake and BigQuery.

Allows filtering directly on window functions.

## Traditional Approach

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rn
    FROM employees
) t
WHERE rn = 1;
```

## QUALIFY Approach

```sql
SELECT *
FROM employees
QUALIFY ROW_NUMBER() OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) = 1;
```

## Benefits

- Cleaner syntax
- Less nesting

---

# COMMON WINDOW FUNCTION MISTAKES

---

## Mistake 1: Forgetting ORDER BY

```sql
ROW_NUMBER() OVER()
```

This may produce inconsistent results.

Always provide ORDER BY when sequence matters.

---

## Mistake 2: Incorrect LAST_VALUE()

Wrong:

```sql
LAST_VALUE(salary) OVER(
    ORDER BY salary
)
```

Correct:

```sql
LAST_VALUE(salary) OVER(
    ORDER BY salary
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND UNBOUNDED FOLLOWING
)
```

---

## Mistake 3: Using RANK Instead of DENSE_RANK

For Nth highest salary questions:

Preferred:

```sql
DENSE_RANK()
```

Reason:
- No rank gaps
- Easier filtering

---

# ADVANCED INTERVIEW QUESTIONS

## Q1. Difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?

ROW_NUMBER:
- Unique numbering

RANK:
- Same rank for ties
- Skips next rank

DENSE_RANK:
- Same rank for ties
- No gaps

---

## Q2. Why use PARTITION BY?

To perform calculations separately within groups.

---

## Q3. What is the difference between ROWS and RANGE?

ROWS:
- Uses physical row positions

RANGE:
- Uses value ranges

---

## Q4. What is QUALIFY?

A clause used to filter results of window functions directly.

---

## Q5. Why are window functions preferred in analytics?

Because they:
- Preserve row-level detail
- Support rankings
- Support running totals
- Support trend analysis

---

# FINAL CHECKLIST

## Ranking Functions

- ROW_NUMBER() ✅
- RANK() ✅
- DENSE_RANK() ✅

## Navigation Functions

- LAG() ✅
- LEAD() ✅
- FIRST_VALUE() ✅
- LAST_VALUE() ✅
- NTH_VALUE() ✅

## Aggregate Window Functions

- SUM() ✅
- AVG() ✅
- COUNT() ✅
- MIN() ✅
- MAX() ✅

## Distribution Functions

- NTILE() ✅
- PERCENT_RANK() ✅
- CUME_DIST() ✅

## Window Concepts

- OVER() ✅
- PARTITION BY ✅
- ORDER BY ✅
- ROWS BETWEEN ✅
- RANGE BETWEEN ✅
- WINDOW Clause ✅
- QUALIFY Clause ✅

## Real-World Problems

- Running Total ✅
- Moving Average ✅
- Top N Analysis ✅
- Duplicate Removal ✅
- Growth Analysis ✅
- Percentage Contribution ✅

---

# SUMMARY

Window Functions are one of the most important SQL topics for Data Analysts, BI Developers, Data Engineers, Analytics Engineers, and SQL Interviews.

Mastering Window Functions enables:
- Advanced Reporting
- Trend Analysis
- Ranking Problems
- Time-Series Analytics
- Dashboard Development
- Interview Problem Solving

✅ Interview Questions & Answers

Mastering Window Functions is a major step toward Advanced SQL proficiency.
