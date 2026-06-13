# 🪟 SQL Window Functions — Complete Guide

> A comprehensive reference covering every window function concept, syntax, use cases, and interview Q&A — written for data analyst roles.

---

## 📋 Table of Contents

1. [What is a Window Function?](#1-what-is-a-window-function)
2. [Window Function Syntax](#2-window-function-syntax)
3. [PARTITION BY](#3-partition-by)
4. [ORDER BY inside OVER()](#4-order-by-inside-over)
5. [Frame Clause (ROWS vs RANGE)](#5-frame-clause-rows-vs-range)
6. [Ranking Functions](#6-ranking-functions)
   - ROW_NUMBER
   - RANK
   - DENSE_RANK
   - NTILE
7. [Aggregate Window Functions](#7-aggregate-window-functions)
   - SUM, AVG, COUNT, MIN, MAX
8. [Value / Offset Functions](#8-value--offset-functions)
   - LAG
   - LEAD
   - FIRST_VALUE
   - LAST_VALUE
   - NTH_VALUE
9. [Named Windows (WINDOW clause)](#9-named-windows-window-clause)
10. [Window Functions vs GROUP BY](#10-window-functions-vs-group-by)
11. [Common Patterns & Real-World Examples](#11-common-patterns--real-world-examples)
12. [Performance Tips](#12-performance-tips)
13. [Interview Questions & Answers](#13-interview-questions--answers)

---

## 1. What is a Window Function?

A **window function** performs a calculation across a **set of rows that are related to the current row** — without collapsing them into a single output row (unlike `GROUP BY`).

The "window" refers to the **frame of rows** visible to the function for each row being computed.

### Key Characteristics

| Feature | Window Function | GROUP BY Aggregate |
|---|---|---|
| Collapses rows? | ❌ No | ✅ Yes |
| Access to individual rows? | ✅ Yes | ❌ No |
| Can use original columns alongside? | ✅ Yes | ❌ No (unless in GROUP BY) |
| Returns one row per original row? | ✅ Yes | ❌ No |

### Example Setup — `sales` Table

```sql
CREATE TABLE sales (
    sale_id     INT,
    rep_name    VARCHAR(50),
    region      VARCHAR(50),
    sale_date   DATE,
    amount      DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1,  'Alice',   'North', '2024-01-05', 5000),
(2,  'Bob',     'North', '2024-01-10', 3000),
(3,  'Carol',   'South', '2024-01-07', 7000),
(4,  'Dave',    'South', '2024-01-12', 4500),
(5,  'Alice',   'North', '2024-02-03', 6000),
(6,  'Bob',     'North', '2024-02-14', 2000),
(7,  'Carol',   'South', '2024-02-09', 8000),
(8,  'Dave',    'South', '2024-02-22', 5500),
(9,  'Eve',     'East',  '2024-01-15', 9000),
(10, 'Frank',   'East',  '2024-02-18', 4000);
```

---

## 2. Window Function Syntax

```sql
function_name(expression)
OVER (
    [PARTITION BY partition_expression, ...]
    [ORDER BY sort_expression [ASC | DESC], ...]
    [frame_clause]
)
```

### Parts of `OVER()`

| Clause | Required? | Purpose |
|---|---|---|
| `PARTITION BY` | Optional | Divides rows into groups (like GROUP BY but without collapsing) |
| `ORDER BY` | Optional (required for some functions) | Determines row order within the partition |
| `frame_clause` | Optional | Defines which rows within the partition are included in the calculation |

### Minimal Examples

```sql
-- No PARTITION BY, no ORDER BY → entire table is one window
SELECT sale_id, amount,
       SUM(amount) OVER() AS grand_total
FROM sales;

-- With PARTITION BY only → total per region
SELECT sale_id, region, amount,
       SUM(amount) OVER(PARTITION BY region) AS region_total
FROM sales;

-- With PARTITION BY + ORDER BY → running total per region
SELECT sale_id, region, amount,
       SUM(amount) OVER(PARTITION BY region ORDER BY sale_date) AS running_total
FROM sales;
```

---

## 3. PARTITION BY

`PARTITION BY` splits the result set into **independent windows/partitions**. The window function is applied separately within each partition.

### Without PARTITION BY

```sql
-- Grand total repeated for every row
SELECT rep_name, amount,
       SUM(amount) OVER() AS grand_total
FROM sales;
```

| rep_name | amount | grand_total |
|---|---|---|
| Alice | 5000 | 54000 |
| Bob | 3000 | 54000 |
| Carol | 7000 | 54000 |
| ... | ... | 54000 |

### With PARTITION BY region

```sql
SELECT rep_name, region, amount,
       SUM(amount) OVER(PARTITION BY region) AS region_total
FROM sales;
```

| rep_name | region | amount | region_total |
|---|---|---|---|
| Alice | North | 5000 | 16000 |
| Bob | North | 3000 | 16000 |
| Alice | North | 6000 | 16000 |
| Bob | North | 2000 | 16000 |
| Carol | South | 7000 | 25000 |
| Dave | South | 4500 | 25000 |
| ... | ... | ... | ... |

> ✅ **Key Insight:** Rows are NOT collapsed. Each row retains its original columns plus the computed window value.

### Multiple PARTITION BY Columns

```sql
-- Partition by region AND year
SELECT rep_name, region, YEAR(sale_date) AS yr, amount,
       SUM(amount) OVER(PARTITION BY region, YEAR(sale_date)) AS region_year_total
FROM sales;
```

---

## 4. ORDER BY inside OVER()

When `ORDER BY` is used inside `OVER()`, the window function sees rows **up to and including the current row** (default frame becomes `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`).

This is the foundation of **running/cumulative calculations**.

```sql
-- Running total of sales per rep, ordered by date
SELECT rep_name, sale_date, amount,
       SUM(amount) OVER(PARTITION BY rep_name ORDER BY sale_date) AS running_total
FROM sales;
```

| rep_name | sale_date | amount | running_total |
|---|---|---|---|
| Alice | 2024-01-05 | 5000 | 5000 |
| Alice | 2024-02-03 | 6000 | 11000 |
| Bob | 2024-01-10 | 3000 | 3000 |
| Bob | 2024-02-14 | 2000 | 5000 |

> ⚠️ **Warning:** `ORDER BY` inside `OVER()` is NOT the same as `ORDER BY` in the outer query. The outer ORDER BY sorts final output; the inner one defines the window frame.

---

## 5. Frame Clause (ROWS vs RANGE)

The frame clause defines the **sliding window** of rows used for the calculation relative to the current row.

### Syntax

```sql
{ ROWS | RANGE } BETWEEN frame_start AND frame_end
```

### Frame Boundaries

| Boundary | Meaning |
|---|---|
| `UNBOUNDED PRECEDING` | From the very first row of the partition |
| `N PRECEDING` | N rows before the current row |
| `CURRENT ROW` | The current row |
| `N FOLLOWING` | N rows after the current row |
| `UNBOUNDED FOLLOWING` | Up to the very last row of the partition |

### ROWS vs RANGE

| | ROWS | RANGE |
|---|---|---|
| Based on | Physical row position | Logical value range |
| Handles ties? | Each row is independent | Ties share the same frame |
| Most common for | Sliding windows, moving averages | Default with ORDER BY |

```sql
-- ROWS: strictly 3 physical rows (current + 2 preceding)
SELECT sale_date, amount,
       AVG(amount) OVER(ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM sales;

-- RANGE: includes all rows with the same ORDER BY value as current row
SELECT sale_date, amount,
       SUM(amount) OVER(ORDER BY sale_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
FROM sales;
```

### Common Frame Patterns

```sql
-- Running total from start of partition
SUM(amount) OVER(PARTITION BY region ORDER BY sale_date
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

-- 3-month rolling average
AVG(amount) OVER(ORDER BY sale_date
                 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- Entire partition (same as no frame clause without ORDER BY)
SUM(amount) OVER(PARTITION BY region
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

-- Future-looking: current row + next 2 rows
SUM(amount) OVER(ORDER BY sale_date
                 ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
```

---

## 6. Ranking Functions

Ranking functions assign a **rank or position number** to each row within a partition.

> All ranking functions require `ORDER BY` inside `OVER()`.

---

### 6.1 ROW_NUMBER()

Assigns a **unique sequential integer** to every row. No ties — even if two rows have identical values, they get different numbers.

```sql
SELECT rep_name, region, amount,
       ROW_NUMBER() OVER(PARTITION BY region ORDER BY amount DESC) AS row_num
FROM sales;
```

| rep_name | region | amount | row_num |
|---|---|---|---|
| Alice | North | 6000 | 1 |
| Alice | North | 5000 | 2 |
| Bob | North | 3000 | 3 |
| Bob | North | 2000 | 4 |
| Carol | South | 8000 | 1 |
| Carol | South | 7000 | 2 |

**Use Cases:**
- Deduplicate rows (keep only row_num = 1 per group)
- Pagination (WHERE row_num BETWEEN 1 AND 10)
- Select top-N per group

**Classic Deduplication Pattern:**
```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY rep_name ORDER BY sale_date DESC) AS rn
    FROM sales
)
SELECT * FROM ranked WHERE rn = 1;  -- Latest sale per rep
```

---

### 6.2 RANK()

Assigns rank with **gaps after ties**. Rows with equal values get the same rank; the next rank skips numbers equal to the number of tied rows.

```sql
SELECT rep_name, amount,
       RANK() OVER(ORDER BY amount DESC) AS rnk
FROM sales;
```

| rep_name | amount | rnk |
|---|---|---|
| Eve | 9000 | 1 |
| Carol | 8000 | 2 |
| Carol | 8000 | 2 |
| Alice | 6000 | 4 |  ← skips 3 because two rows tied at rank 2

**Use Cases:**
- Competition rankings where tied entries share a rank
- Olympic-style leaderboards

---

### 6.3 DENSE_RANK()

Like RANK() but **no gaps** after ties.

```sql
SELECT rep_name, amount,
       RANK()       OVER(ORDER BY amount DESC) AS rnk,
       DENSE_RANK() OVER(ORDER BY amount DESC) AS dense_rnk
FROM sales;
```

| rep_name | amount | rnk | dense_rnk |
|---|---|---|---|
| Eve | 9000 | 1 | 1 |
| Carol | 8000 | 2 | 2 |
| Carol | 8000 | 2 | 2 |
| Alice | 6000 | 4 | 3 |  ← no gap

**Use Cases:**
- Finding Nth distinct rank (e.g., "second highest salary")
- Percentile groupings

**Find 2nd Highest Sale per Region:**
```sql
WITH ranked AS (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY region ORDER BY amount DESC) AS dr
    FROM sales
)
SELECT * FROM ranked WHERE dr = 2;
```

---

### 6.4 NTILE(n)

Divides rows into **n equal buckets** and assigns each row a bucket number (1 to n).

```sql
SELECT rep_name, amount,
       NTILE(4) OVER(ORDER BY amount DESC) AS quartile
FROM sales;
```

| rep_name | amount | quartile |
|---|---|---|
| Eve | 9000 | 1 |
| Carol | 8000 | 1 |
| Carol | 7000 | 1 |
| Alice | 6000 | 2 |
| Dave | 5500 | 2 |
| Alice | 5000 | 3 |
| Dave | 4500 | 3 |
| Frank | 4000 | 4 |
| Bob | 3000 | 4 |
| Bob | 2000 | 4 |

> If rows don't divide evenly, earlier buckets get one extra row.

**Use Cases:**
- Creating quartiles, deciles, percentile bands
- Customer segmentation (top 25%, bottom 25%)

---

### Ranking Functions: Side-by-Side Comparison

```sql
SELECT rep_name, amount,
       ROW_NUMBER() OVER(ORDER BY amount DESC) AS row_num,
       RANK()       OVER(ORDER BY amount DESC) AS rnk,
       DENSE_RANK() OVER(ORDER BY amount DESC) AS dense_rnk,
       NTILE(4)     OVER(ORDER BY amount DESC) AS quartile
FROM sales;
```

| rep_name | amount | row_num | rnk | dense_rnk | quartile |
|---|---|---|---|---|---|
| Eve | 9000 | 1 | 1 | 1 | 1 |
| Carol (Feb) | 8000 | 2 | 2 | 2 | 1 |
| Carol (Jan) | 7000 | 3 | 3 | 3 | 1 |
| Alice (Feb) | 6000 | 4 | 4 | 4 | 2 |
| Dave (Feb) | 5500 | 5 | 5 | 5 | 2 |
| Alice (Jan) | 5000 | 6 | 6 | 6 | 3 |
| Dave (Jan) | 4500 | 7 | 7 | 7 | 3 |
| Frank | 4000 | 8 | 8 | 8 | 4 |
| Bob (Jan) | 3000 | 9 | 9 | 9 | 4 |
| Bob (Feb) | 2000 | 10 | 10 | 10 | 4 |

---

## 7. Aggregate Window Functions

Standard aggregate functions (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`) become window functions when used with `OVER()`.

### 7.1 SUM()

```sql
-- Running total per region
SELECT rep_name, region, sale_date, amount,
       SUM(amount) OVER(PARTITION BY region ORDER BY sale_date) AS running_total,
       SUM(amount) OVER(PARTITION BY region)                    AS region_grand_total
FROM sales
ORDER BY region, sale_date;
```

### 7.2 AVG()

```sql
-- Each sale vs regional average
SELECT rep_name, region, amount,
       AVG(amount) OVER(PARTITION BY region)              AS region_avg,
       amount - AVG(amount) OVER(PARTITION BY region)     AS diff_from_avg,
       ROUND(amount / AVG(amount) OVER(PARTITION BY region) * 100, 1) AS pct_of_avg
FROM sales;
```

### 7.3 COUNT()

```sql
-- How many sales has each rep made so far (running count)
SELECT rep_name, sale_date, amount,
       COUNT(*) OVER(PARTITION BY rep_name ORDER BY sale_date) AS running_count,
       COUNT(*) OVER(PARTITION BY rep_name)                    AS total_sales_by_rep
FROM sales;
```

### 7.4 MIN() and MAX()

```sql
-- Highest and lowest sale in each region
SELECT rep_name, region, amount,
       MIN(amount) OVER(PARTITION BY region) AS region_min,
       MAX(amount) OVER(PARTITION BY region) AS region_max,
       MAX(amount) OVER()                    AS overall_max
FROM sales;
```

### Percentage of Total Pattern

```sql
-- Each rep's contribution to their region's total
SELECT rep_name, region, amount,
       SUM(amount) OVER(PARTITION BY region) AS region_total,
       ROUND(amount * 100.0 / SUM(amount) OVER(PARTITION BY region), 2) AS pct_of_region
FROM sales;
```

---

## 8. Value / Offset Functions

These functions access **other rows' values** relative to the current row without a self-join.

---

### 8.1 LAG()

Returns the value from a **previous row** within the partition.

```sql
LAG(expression [, offset [, default]]) OVER(PARTITION BY ... ORDER BY ...)
```

- `offset` = how many rows back (default: 1)
- `default` = value if no previous row exists (default: NULL)

```sql
-- Month-over-month change per rep
SELECT rep_name, sale_date, amount,
       LAG(amount, 1, 0) OVER(PARTITION BY rep_name ORDER BY sale_date)       AS prev_amount,
       amount - LAG(amount, 1, 0) OVER(PARTITION BY rep_name ORDER BY sale_date) AS mom_change
FROM sales;
```

| rep_name | sale_date | amount | prev_amount | mom_change |
|---|---|---|---|---|
| Alice | 2024-01-05 | 5000 | 0 | 5000 |
| Alice | 2024-02-03 | 6000 | 5000 | 1000 |
| Bob | 2024-01-10 | 3000 | 0 | 3000 |
| Bob | 2024-02-14 | 2000 | 3000 | -1000 |

---

### 8.2 LEAD()

Returns the value from a **following row** within the partition.

```sql
LEAD(expression [, offset [, default]]) OVER(PARTITION BY ... ORDER BY ...)
```

```sql
-- Preview next sale amount for each rep
SELECT rep_name, sale_date, amount,
       LEAD(amount, 1) OVER(PARTITION BY rep_name ORDER BY sale_date) AS next_amount,
       LEAD(sale_date, 1) OVER(PARTITION BY rep_name ORDER BY sale_date) AS next_sale_date
FROM sales;
```

**Days until next sale:**
```sql
SELECT rep_name, sale_date,
       LEAD(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date) AS next_date,
       DATEDIFF(
           LEAD(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date),
           sale_date
       ) AS days_until_next_sale
FROM sales;
```

---

### 8.3 FIRST_VALUE()

Returns the value from the **first row** in the window frame.

```sql
SELECT rep_name, region, sale_date, amount,
       FIRST_VALUE(amount) OVER(PARTITION BY rep_name ORDER BY sale_date) AS first_sale_amount,
       FIRST_VALUE(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date) AS first_sale_date
FROM sales;
```

> ⚠️ **Important:** Without an explicit frame clause, FIRST_VALUE uses the default frame (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`), which is usually fine for this function.

---

### 8.4 LAST_VALUE()

Returns the value from the **last row** in the window frame.

```sql
-- ⚠️ LAST_VALUE pitfall: default frame ends at CURRENT ROW, not partition end!
-- You MUST extend the frame to get true last value

SELECT rep_name, sale_date, amount,
       LAST_VALUE(amount) OVER(
           PARTITION BY rep_name
           ORDER BY sale_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- ← CRITICAL
       ) AS last_sale_amount
FROM sales;
```

> ⚠️ This is one of the **most common interview trap questions**. Without `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`, LAST_VALUE just returns the current row's value (since default frame ends at CURRENT ROW).

---

### 8.5 NTH_VALUE()

Returns the value from the **Nth row** in the window frame.

```sql
-- 2nd highest sale per region
SELECT rep_name, region, amount,
       NTH_VALUE(amount, 2) OVER(
           PARTITION BY region
           ORDER BY amount DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS second_highest_sale
FROM sales;
```

> Note: `NTH_VALUE` is available in MySQL 8.0+, PostgreSQL, and SQL Server. Not available in older MySQL versions.

---

### Offset Functions Summary

| Function | Direction | Returns |
|---|---|---|
| `LAG(col, n)` | Backward | Value n rows before current |
| `LEAD(col, n)` | Forward | Value n rows after current |
| `FIRST_VALUE(col)` | Start | First value in frame |
| `LAST_VALUE(col)` | End | Last value in frame (needs full frame!) |
| `NTH_VALUE(col, n)` | Nth position | Value at Nth row in frame |

---

## 9. Named Windows (WINDOW clause)

If you use the same window definition multiple times, define it once with `WINDOW` to avoid repetition.

```sql
-- Without WINDOW clause — repetitive
SELECT rep_name, amount,
       SUM(amount)  OVER(PARTITION BY region ORDER BY sale_date) AS running_sum,
       AVG(amount)  OVER(PARTITION BY region ORDER BY sale_date) AS running_avg,
       COUNT(*)     OVER(PARTITION BY region ORDER BY sale_date) AS running_count,
       MAX(amount)  OVER(PARTITION BY region ORDER BY sale_date) AS running_max
FROM sales;

-- With WINDOW clause — clean and DRY
SELECT rep_name, amount,
       SUM(amount)  OVER w AS running_sum,
       AVG(amount)  OVER w AS running_avg,
       COUNT(*)     OVER w AS running_count,
       MAX(amount)  OVER w AS running_max
FROM sales
WINDOW w AS (PARTITION BY region ORDER BY sale_date);
```

> ✅ Supported in MySQL 8.0+, PostgreSQL, and MariaDB 10.2+.

---

## 10. Window Functions vs GROUP BY

This is a **critical conceptual difference** often tested in interviews.

```sql
-- GROUP BY: one row per region, individual data LOST
SELECT region,
       SUM(amount)  AS total,
       AVG(amount)  AS avg_sale,
       COUNT(*)     AS num_sales
FROM sales
GROUP BY region;
```

| region | total | avg_sale | num_sales |
|---|---|---|---|
| East | 13000 | 6500 | 2 |
| North | 16000 | 4000 | 4 |
| South | 25000 | 6250 | 4 |

```sql
-- Window Function: original rows preserved, aggregates added as new columns
SELECT rep_name, region, amount,
       SUM(amount) OVER(PARTITION BY region) AS region_total,
       AVG(amount) OVER(PARTITION BY region) AS region_avg,
       COUNT(*)    OVER(PARTITION BY region) AS region_count
FROM sales;
```

| rep_name | region | amount | region_total | region_avg | region_count |
|---|---|---|---|---|---|
| Alice | North | 5000 | 16000 | 4000 | 4 |
| Bob | North | 3000 | 16000 | 4000 | 4 |
| Alice | North | 6000 | 16000 | 4000 | 4 |
| ... | ... | ... | ... | ... | ... |

### Combining Both

```sql
-- First aggregate with GROUP BY, then apply window on top
WITH monthly_sales AS (
    SELECT region,
           DATE_FORMAT(sale_date, '%Y-%m') AS month,
           SUM(amount) AS monthly_total
    FROM sales
    GROUP BY region, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT region, month, monthly_total,
       SUM(monthly_total) OVER(PARTITION BY region ORDER BY month) AS cumulative_total,
       LAG(monthly_total) OVER(PARTITION BY region ORDER BY month) AS prev_month_total
FROM monthly_sales;
```

---

## 11. Common Patterns & Real-World Examples

### Pattern 1: Top-N Per Group

```sql
-- Top 2 sales reps per region by total sales
WITH rep_totals AS (
    SELECT rep_name, region, SUM(amount) AS total_sales
    FROM sales
    GROUP BY rep_name, region
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY region ORDER BY total_sales DESC) AS dr
    FROM rep_totals
)
SELECT * FROM ranked WHERE dr <= 2;
```

### Pattern 2: Remove Duplicates (Keep Latest)

```sql
-- Keep only the most recent sale record per rep
WITH deduped AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY rep_name ORDER BY sale_date DESC) AS rn
    FROM sales
)
SELECT sale_id, rep_name, region, sale_date, amount
FROM deduped
WHERE rn = 1;
```

### Pattern 3: Running Total / Cumulative Sum

```sql
SELECT rep_name, sale_date, amount,
       SUM(amount) OVER(PARTITION BY rep_name ORDER BY sale_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sales
FROM sales;
```

### Pattern 4: Moving Average (3-period)

```sql
SELECT sale_date, amount,
       ROUND(AVG(amount) OVER(ORDER BY sale_date
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3
FROM sales
ORDER BY sale_date;
```

### Pattern 5: Percent Rank & Percentile

```sql
SELECT rep_name, amount,
       PERCENT_RANK() OVER(ORDER BY amount)                              AS pct_rank,
       CUME_DIST()    OVER(ORDER BY amount)                              AS cume_dist,
       ROUND(PERCENT_RANK() OVER(ORDER BY amount) * 100, 1)             AS percentile
FROM sales;
```

> - `PERCENT_RANK()` = (rank - 1) / (total rows - 1). Range: 0 to 1.
> - `CUME_DIST()` = number of rows ≤ current / total rows. Range: > 0 to 1.

### Pattern 6: Year-over-Year Comparison

```sql
WITH yearly AS (
    SELECT rep_name,
           YEAR(sale_date) AS yr,
           SUM(amount) AS total
    FROM sales
    GROUP BY rep_name, YEAR(sale_date)
)
SELECT rep_name, yr, total,
       LAG(total) OVER(PARTITION BY rep_name ORDER BY yr) AS prev_year_total,
       ROUND((total - LAG(total) OVER(PARTITION BY rep_name ORDER BY yr))
             / LAG(total) OVER(PARTITION BY rep_name ORDER BY yr) * 100, 1) AS yoy_pct_change
FROM yearly;
```

### Pattern 7: Gap Detection (Sessions / Events)

```sql
-- Detect if there's a gap of more than 30 days between sales
SELECT rep_name, sale_date,
       LAG(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date) AS prev_date,
       DATEDIFF(sale_date, LAG(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date)) AS gap_days,
       CASE WHEN DATEDIFF(sale_date,
                          LAG(sale_date) OVER(PARTITION BY rep_name ORDER BY sale_date)) > 30
            THEN 'Gap Detected' ELSE 'Normal' END AS status
FROM sales;
```

### Pattern 8: Cumulative Distribution / ABC Analysis

```sql
WITH rep_totals AS (
    SELECT rep_name, SUM(amount) AS total_sales
    FROM sales
    GROUP BY rep_name
),
classified AS (
    SELECT rep_name, total_sales,
           SUM(total_sales) OVER(ORDER BY total_sales DESC) AS cumulative_sales,
           SUM(total_sales) OVER()                          AS grand_total
    FROM rep_totals
)
SELECT rep_name, total_sales,
       ROUND(cumulative_sales * 100.0 / grand_total, 1) AS cumulative_pct,
       CASE
           WHEN cumulative_sales * 1.0 / grand_total <= 0.7 THEN 'A'
           WHEN cumulative_sales * 1.0 / grand_total <= 0.9 THEN 'B'
           ELSE 'C'
       END AS abc_category
FROM classified
ORDER BY total_sales DESC;
```

---

## 12. Performance Tips

1. **Limit partitions wisely** — Avoid `PARTITION BY` on high-cardinality columns with small groups; the overhead may not be worth it.

2. **Indexing helps** — Window functions with `ORDER BY` inside `OVER()` benefit from indexes on those columns, especially on large tables.

3. **Use CTEs to avoid recalculation** — If you use the same window expression multiple times, compute it once in a CTE.

4. **Prefer ROWS over RANGE** — `ROWS` is generally faster because `RANGE` needs to handle tie-checking.

5. **Filter before windowing** — Apply `WHERE` clauses in a subquery or CTE before the window function to reduce the dataset.

6. **Avoid window functions in WHERE** — You cannot use window function results in `WHERE` directly; use a subquery or CTE.

```sql
-- ❌ WRONG — cannot use window function in WHERE
SELECT * FROM sales
WHERE ROW_NUMBER() OVER(PARTITION BY region ORDER BY amount DESC) = 1;

-- ✅ CORRECT — wrap in CTE or subquery
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY region ORDER BY amount DESC) AS rn
    FROM sales
)
SELECT * FROM ranked WHERE rn = 1;
```

---

## 13. Interview Questions & Answers

---

### 🔹 Conceptual Questions

---

**Q1. What is a window function and how is it different from GROUP BY?**

**Answer:**
A window function performs a calculation across a set of rows related to the current row, defined by the `OVER()` clause. Unlike `GROUP BY`, window functions do **not collapse rows** — every original row is preserved in the output, with the computed value added as a new column.

With `GROUP BY`, if you want a per-customer total, you lose all individual order data. With a window function, you can have both the individual order row AND the customer-level total in the same result set.

```sql
-- GROUP BY collapses
SELECT customer_id, SUM(order_amount) AS total FROM orders GROUP BY customer_id;

-- Window function preserves individual rows
SELECT order_id, customer_id, order_amount,
       SUM(order_amount) OVER(PARTITION BY customer_id) AS customer_total
FROM orders;
```

---

**Q2. What are the three main clauses inside OVER() and what does each do?**

**Answer:**
- `PARTITION BY`: Divides the result set into independent partitions (like GROUP BY but without collapsing). The window function resets for each partition.
- `ORDER BY`: Defines the order of rows within each partition. This also activates the default frame (`RANGE UNBOUNDED PRECEDING TO CURRENT ROW`), enabling running calculations.
- **Frame clause** (`ROWS`/`RANGE BETWEEN`): Specifies which rows within the partition are included in the calculation relative to the current row. Without `ORDER BY`, the default frame is the entire partition.

---

**Q3. What is the difference between ROW_NUMBER, RANK, and DENSE_RANK?**

**Answer:**
All three assign numbers to rows ordered within a partition, but differ in how they handle ties:

| Function | Ties get same rank? | Gaps after ties? | Always unique? |
|---|---|---|---|
| `ROW_NUMBER()` | ❌ No | N/A | ✅ Yes |
| `RANK()` | ✅ Yes | ✅ Yes | ❌ No |
| `DENSE_RANK()` | ✅ Yes | ❌ No | ❌ No |

Example with scores 100, 90, 90, 80:
- ROW_NUMBER: 1, 2, 3, 4
- RANK: 1, 2, 2, 4
- DENSE_RANK: 1, 2, 2, 3

Use `ROW_NUMBER` for deduplication, `RANK` for competition rankings with gaps, `DENSE_RANK` to find the Nth distinct value.

---

**Q4. What is the difference between LAG and LEAD?**

**Answer:**
Both are offset functions that access values from other rows in the partition:
- `LAG(col, n)` — looks **backward** (previous rows), returning the value n rows before the current row.
- `LEAD(col, n)` — looks **forward** (following rows), returning the value n rows after the current row.

Both accept an optional third argument as the default value when no such row exists (e.g., first row has no LAG, last row has no LEAD).

```sql
-- Compare current sale with previous and next
SELECT sale_date, amount,
       LAG(amount)  OVER(ORDER BY sale_date) AS prev_sale,
       LEAD(amount) OVER(ORDER BY sale_date) AS next_sale
FROM sales;
```

---

**Q5. What is the common pitfall with LAST_VALUE()?**

**Answer:**
`LAST_VALUE()` has a default frame of `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. This means for any given row, the "last" value in the frame IS the current row itself. So `LAST_VALUE()` appears to always return the current row's value, which confuses many people.

To get the true last value in the partition, you must explicitly set the frame:
```sql
LAST_VALUE(col) OVER(
    PARTITION BY ...
    ORDER BY ...
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```
This is one of the most commonly asked trap questions in SQL interviews.

---

**Q6. What is PARTITION BY vs GROUP BY?**

**Answer:**

| | GROUP BY | PARTITION BY |
|---|---|---|
| Collapses rows? | ✅ Yes | ❌ No |
| Used with | Aggregates in SELECT | Window functions in OVER() |
| Can include non-grouped columns? | ❌ No | ✅ Yes |
| Purpose | Summarize data | Define computation scope while keeping rows |

`PARTITION BY` is conceptually "GROUP BY that doesn't collapse" — it tells the window function which rows form the calculation group for each row.

---

**Q7. Can you use a window function in a WHERE clause?**

**Answer:**
No. Window functions are evaluated **after** WHERE, GROUP BY, and HAVING in the SQL execution order. You cannot reference a window function result in a WHERE clause directly.

The solution is to wrap the query in a subquery or CTE and filter on the outer query:

```sql
-- ❌ INVALID
SELECT * FROM employees
WHERE ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC) <= 3;

-- ✅ VALID
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

---

**Q8. What is PERCENT_RANK() and CUME_DIST()?**

**Answer:**
Both are distribution window functions:

- `PERCENT_RANK()` = `(rank - 1) / (total_rows - 1)` — tells you the **relative rank** as a percentage. A value of 0 is the lowest, 1 is the highest.
- `CUME_DIST()` = `(number of rows ≤ current row) / total_rows` — gives the **cumulative distribution**. Always > 0 and ≤ 1.

```sql
SELECT name, salary,
       ROUND(PERCENT_RANK() OVER(ORDER BY salary) * 100, 1) AS percentile_rank,
       ROUND(CUME_DIST()    OVER(ORDER BY salary) * 100, 1) AS cume_dist_pct
FROM employees;
```

A salary with `CUME_DIST() = 0.75` means 75% of employees earn that salary or less.

---

**Q9. What is NTILE() and when would you use it?**

**Answer:**
`NTILE(n)` distributes rows into `n` equal-sized buckets and assigns each row a bucket number (1 through n). If the rows don't divide evenly, the first few buckets get one extra row.

Practical uses:
- Creating quartiles (`NTILE(4)`), deciles (`NTILE(10)`), or percentile bands
- Customer segmentation: "top 25% spenders" = `NTILE(4) = 1` (ordered by spend DESC)
- Distributing workload evenly across n teams

```sql
-- Label customers as High/Mid/Low spenders
SELECT customer_id, total_spend,
       NTILE(3) OVER(ORDER BY total_spend DESC) AS tier,
       CASE NTILE(3) OVER(ORDER BY total_spend DESC)
           WHEN 1 THEN 'High'
           WHEN 2 THEN 'Mid'
           WHEN 3 THEN 'Low'
       END AS segment
FROM customer_summary;
```

---

**Q10. What is the ROWS vs RANGE difference in the frame clause?**

**Answer:**
Both define the window frame but differ in how they interpret boundaries:

- `ROWS`: Uses **physical row positions**. `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` always means exactly 2 rows before, regardless of values.
- `RANGE`: Uses **logical value ranges**. For `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, tied rows (same ORDER BY value) are all treated as "current."

`ROWS` is more predictable and often preferred for moving averages. `RANGE` handles ties differently and is the default when you use `ORDER BY` without a frame clause.

```sql
-- ROWS: strictly the previous 2 physical rows + current
AVG(amount) OVER(ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- RANGE: includes all rows with the same sale_date as current
AVG(amount) OVER(ORDER BY sale_date RANGE BETWEEN 2 PRECEDING AND CURRENT ROW)
-- Note: RANGE with numeric offsets requires numeric ORDER BY in some databases
```

---

### 🔹 Scenario / Coding Questions

---

**Q11. Write a query to find the top 3 employees by salary in each department.**

```sql
WITH ranked AS (
    SELECT employee_id, name, department, salary,
           DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dr
    FROM employees
)
SELECT employee_id, name, department, salary
FROM ranked
WHERE dr <= 3;
```

*Use DENSE_RANK (not ROW_NUMBER) so that tied salaries are both included. Use ROW_NUMBER if you strictly want exactly 3 rows per department.*

---

**Q12. Write a query to calculate month-over-month revenue growth percentage.**

```sql
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(revenue) AS total_revenue
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
growth AS (
    SELECT month, total_revenue,
           LAG(total_revenue) OVER(ORDER BY month) AS prev_month_revenue
    FROM monthly
)
SELECT month, total_revenue, prev_month_revenue,
       ROUND((total_revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2) AS mom_growth_pct
FROM growth
ORDER BY month;
```

---

**Q13. How would you remove duplicate rows keeping only the latest record per customer?**

```sql
WITH deduped AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY created_at DESC) AS rn
    FROM customers
)
SELECT customer_id, name, email, created_at
FROM deduped
WHERE rn = 1;
```

*Partition by the unique entity (customer_id), order by the timestamp descending, and keep rn = 1.*

---

**Q14. Calculate a 7-day moving average of daily sales.**

```sql
SELECT sale_date,
       daily_sales,
       ROUND(
           AVG(daily_sales) OVER(
               ORDER BY sale_date
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
           ), 2
       ) AS moving_avg_7d
FROM daily_sales_summary
ORDER BY sale_date;
```

*Use `ROWS` (not `RANGE`) for a strict 7-row window regardless of date gaps.*

---

**Q15. Find employees who earn more than the average salary of their department.**

```sql
SELECT employee_id, name, department, salary,
       ROUND(AVG(salary) OVER(PARTITION BY department), 2) AS dept_avg
FROM employees
WHERE salary > AVG(salary) OVER(PARTITION BY department);  -- ❌ This won't work!
```

The above is invalid. Correct approach:

```sql
WITH dept_avg AS (
    SELECT *,
           AVG(salary) OVER(PARTITION BY department) AS dept_avg_salary
    FROM employees
)
SELECT employee_id, name, department, salary, dept_avg_salary
FROM dept_avg
WHERE salary > dept_avg_salary;
```

---

**Q16. What does this query return? (Tricky question)**

```sql
SELECT name, salary,
       LAST_VALUE(name) OVER(ORDER BY salary DESC) AS last_name
FROM employees;
```

**Answer:** This does NOT return the employee with the lowest salary (as one might expect). Since no explicit frame is set, the default is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. So for each row, `LAST_VALUE` returns the **current row's own name**, not the last row in the full partition. This catches many candidates off-guard.

Fix:
```sql
SELECT name, salary,
       LAST_VALUE(name) OVER(
           ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS lowest_paid_employee
FROM employees;
```

---

**Q17. Explain the SQL execution order and how window functions fit in.**

**Answer:** Standard SQL execution order:

1. `FROM` / `JOIN`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. **Window functions** ← evaluated here, after grouping
6. `SELECT`
7. `DISTINCT`
8. `ORDER BY`
9. `LIMIT` / `OFFSET`

This is why:
- Window functions **cannot** be used in `WHERE` or `HAVING`
- Window functions **can** see grouped rows (they run after GROUP BY)
- You can reference window function aliases in `ORDER BY` but not in `WHERE`

---

**Q18. Write a query to calculate each product's sales as a percentage of its category's total sales.**

```sql
SELECT product_id,
       product_name,
       category,
       sales_amount,
       SUM(sales_amount) OVER(PARTITION BY category) AS category_total,
       ROUND(sales_amount * 100.0 / SUM(sales_amount) OVER(PARTITION BY category), 2) AS pct_of_category
FROM product_sales
ORDER BY category, pct_of_category DESC;
```

---

**Q19. What is the difference between FIRST_VALUE and MIN()?**

**Answer:**
- `MIN()` returns the minimum value in the partition/frame — the smallest value regardless of row position.
- `FIRST_VALUE()` returns the value of a specified column from the **first row in the ordered frame** — this could be any column, not just the one you're ordering by.

```sql
SELECT product, sale_date, amount,
       MIN(amount)        OVER(PARTITION BY product) AS min_sale,       -- smallest amount
       FIRST_VALUE(amount) OVER(PARTITION BY product ORDER BY sale_date) AS first_sale_amt -- amount of the earliest sale
FROM sales;
-- These can return different values!
-- MIN = 2000, FIRST_VALUE = amount on the earliest date (which might be 5000)
```

---

**Q20. When would you use a window function instead of a self-join?**

**Answer:**
Window functions (especially LAG/LEAD) replace self-joins that compare a row to adjacent rows. Self-joins are verbose, harder to read, and often slower.

```sql
-- Self-join approach (older, verbose)
SELECT a.sale_date, a.amount,
       b.amount AS prev_amount
FROM sales a
LEFT JOIN sales b
    ON b.sale_date = (
        SELECT MAX(sale_date) FROM sales WHERE sale_date < a.sale_date
    );

-- Window function approach (modern, clean)
SELECT sale_date, amount,
       LAG(amount) OVER(ORDER BY sale_date) AS prev_amount
FROM sales;
```

Window functions are cleaner, more readable, and typically more performant for these patterns.

---

## 📌 Quick Reference Cheat Sheet

```sql
-- ═══════════════════════════════════════════
--  RANKING
-- ═══════════════════════════════════════════
ROW_NUMBER() OVER(PARTITION BY col ORDER BY col)   -- Unique sequential number
RANK()       OVER(PARTITION BY col ORDER BY col)   -- Rank with gaps on ties
DENSE_RANK() OVER(PARTITION BY col ORDER BY col)   -- Rank without gaps
NTILE(4)     OVER(ORDER BY col)                    -- Quartile/bucket number

-- ═══════════════════════════════════════════
--  AGGREGATES
-- ═══════════════════════════════════════════
SUM(col)   OVER(PARTITION BY p ORDER BY o)  -- Running total
AVG(col)   OVER(PARTITION BY p)             -- Group average (no ORDER BY = whole partition)
COUNT(*)   OVER(PARTITION BY p ORDER BY o)  -- Running count
MIN/MAX(col) OVER(PARTITION BY p)           -- Group min/max

-- ═══════════════════════════════════════════
--  OFFSET / VALUE
-- ═══════════════════════════════════════════
LAG(col, 1, 0)  OVER(PARTITION BY p ORDER BY o)   -- Previous row value (default 0)
LEAD(col, 1)    OVER(PARTITION BY p ORDER BY o)   -- Next row value
FIRST_VALUE(col) OVER(PARTITION BY p ORDER BY o)  -- First value in frame
LAST_VALUE(col)  OVER(PARTITION BY p ORDER BY o   -- Last value — must extend frame!
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
NTH_VALUE(col, 2) OVER(PARTITION BY p ORDER BY o  -- 2nd value in frame
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

-- ═══════════════════════════════════════════
--  DISTRIBUTION
-- ═══════════════════════════════════════════
PERCENT_RANK() OVER(ORDER BY col)  -- Relative rank 0 to 1
CUME_DIST()    OVER(ORDER BY col)  -- Cumulative distribution > 0 to 1

-- ═══════════════════════════════════════════
--  FRAME PATTERNS
-- ═══════════════════════════════════════════
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW      -- Running total
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW              -- 3-row moving window
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- Whole partition
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING      -- From current to end

-- ═══════════════════════════════════════════
--  COMMON PATTERNS
-- ═══════════════════════════════════════════
-- Top N per group
WITH r AS (SELECT *, DENSE_RANK() OVER(PARTITION BY grp ORDER BY val DESC) dr FROM t)
SELECT * FROM r WHERE dr <= N;

-- Deduplication (keep latest)
WITH r AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY ts DESC) rn FROM t)
SELECT * FROM r WHERE rn = 1;

-- % of group total
col * 100.0 / SUM(col) OVER(PARTITION BY grp)

-- Month-over-month change
col - LAG(col) OVER(PARTITION BY grp ORDER BY date)
```

---

*Last updated: 2024 | Covers MySQL 8.0+, PostgreSQL, SQL Server*
