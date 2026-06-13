# INDEXES IN SQL

## What is an Index?

An Index is a database object that improves the speed of data retrieval operations.

Think of an index in a book.

Without an index:
- You read every page.

With an index:
- You directly jump to the required page.

Similarly, without a database index SQL scans the entire table.

With an index SQL can quickly locate required rows.

---

# Why Use Indexes?

Indexes help:

- Faster SELECT queries
- Faster JOIN operations
- Faster WHERE filtering
- Faster ORDER BY operations
- Faster GROUP BY operations

---

# Without Index

```sql
SELECT *
FROM employees
WHERE employee_id = 100;
```

Database may scan every row.

```text
Table Scan
```

---

# With Index

```sql
CREATE INDEX idx_employee_id
ON employees(employee_id);
```

Now SQL can directly locate matching rows.

```text
Index Seek
```

---

# How Index Works

Most databases use a B-Tree structure.

```text
          Root
         /    \
       Node   Node
      /   \   /  \
   Data Data Data Data
```

Instead of scanning all rows, SQL navigates through the tree.

---

# CLUSTERED INDEX

## Definition

A Clustered Index determines the physical order of data in a table.

The table data itself is stored according to the clustered index.

---

## Example

```sql
CREATE CLUSTERED INDEX idx_employee_id
ON employees(employee_id);
```

---

## Characteristics

- Data stored in sorted order
- Only ONE clustered index per table
- Fast range searches

---

## Example

```sql
SELECT *
FROM employees
WHERE employee_id BETWEEN 100 AND 200;
```

Very efficient with clustered index.

---

# Advantages

- Faster retrieval
- Faster range queries
- Better sorting performance

---

# Disadvantages

- Only one allowed
- Slower INSERT/UPDATE operations

---

# NON-CLUSTERED INDEX

## Definition

Stores index separately from actual table data.

Contains pointers to rows.

---

## Example

```sql
CREATE INDEX idx_employee_name
ON employees(employee_name);
```

---

## Characteristics

- Separate structure
- Multiple allowed
- Contains row locator

---

## Example

```sql
SELECT *
FROM employees
WHERE employee_name = 'John';
```

---

# Advantages

- Multiple indexes allowed
- Faster lookups

---

# Disadvantages

- Uses extra storage
- Slows INSERT/UPDATE/DELETE

---

# CLUSTERED VS NON-CLUSTERED INDEX

| Feature | Clustered | Non-Clustered |
|----------|----------|----------|
| Data Storage | Sorted Data | Separate Structure |
| Count Per Table | One | Multiple |
| Range Queries | Excellent | Good |
| Storage | No Extra Copy | Additional Storage |

---

# COMPOSITE INDEX

Index on multiple columns.

---

## Example

```sql
CREATE INDEX idx_emp_dept_salary
ON employees(department_id, salary);
```

---

## Useful For

```sql
SELECT *
FROM employees
WHERE department_id = 10
AND salary > 50000;
```

---

# LEFTMOST PREFIX RULE

For:

```sql
CREATE INDEX idx_emp
ON employees(department_id, salary);
```

Works efficiently:

```sql
WHERE department_id = 10
```

Works efficiently:

```sql
WHERE department_id = 10
AND salary > 50000
```

May not work efficiently:

```sql
WHERE salary > 50000
```

---

# UNIQUE INDEX

Prevents duplicate values.

---

## Example

```sql
CREATE UNIQUE INDEX idx_email
ON employees(email);
```

---

## Allowed

```text
abc@gmail.com
xyz@gmail.com
```

---

## Not Allowed

```text
abc@gmail.com
abc@gmail.com
```

---

# COVERING INDEX

Contains all columns required by query.

---

## Example

```sql
CREATE INDEX idx_employee
ON employees(department_id)
INCLUDE(employee_name, salary);
```

---

## Query

```sql
SELECT employee_name,
       salary
FROM employees
WHERE department_id = 10;
```

Database can satisfy query using index only.

No table lookup required.

---

# FILTERED INDEX

Indexes only a subset of rows.

---

## Example

```sql
CREATE INDEX idx_active_customers
ON customers(customer_id)
WHERE status = 'Active';
```

---

## Benefits

- Smaller index
- Faster performance
- Less storage

---

# COLUMNSTORE INDEX

Designed for analytics workloads.

Stores data by columns instead of rows.

---

## Traditional Storage

```text
Row 1
Row 2
Row 3
```

---

## Columnstore Storage

```text
Column A
Column B
Column C
```

---

# Benefits

- Excellent compression
- Faster aggregations
- Ideal for data warehouses

---

# B-TREE STRUCTURE

Most indexes use B-Tree.

Components:

### Root Node

Starting point.

### Intermediate Node

Navigation layer.

### Leaf Node

Actual data references.

---

# INDEX SEEK

Most efficient operation.

```text
Index
 ↓
Target Row
```

---

## Example

```sql
SELECT *
FROM employees
WHERE employee_id = 100;
```

---

# INDEX SCAN

Reads many index entries.

Less efficient.

---

# TABLE SCAN

Reads entire table.

```text
Row 1
Row 2
Row 3
...
Row N
```

Most expensive operation.

---

# CLUSTERED INDEX SCAN

Reads clustered index completely.

Still better than table scan in some cases.

---

# INDEX FRAGMENTATION

Occurs when index pages become disorganized.

---

## Causes

- Frequent inserts
- Frequent updates
- Frequent deletes

---

# REORGANIZE INDEX

Lightweight maintenance.

```sql
ALTER INDEX idx_employee
REORGANIZE;
```

---

# REBUILD INDEX

Complete rebuild.

```sql
ALTER INDEX idx_employee
REBUILD;
```

---

# REBUILD VS REORGANIZE

| Feature | Rebuild | Reorganize |
|----------|----------|----------|
| Speed | Slower | Faster |
| Resource Usage | Higher | Lower |
| Fixes Fragmentation | Completely | Partially |

---

# WHEN NOT TO CREATE INDEXES

Avoid excessive indexing on:

- Small tables
- Frequently updated columns
- Low-selectivity columns

Example:

```sql
gender
```

Only two values.

Poor index candidate.

---

# INDEX SELECTIVITY

Measures uniqueness.

High Selectivity:

```text
Email
Employee_ID
PAN_Number
```

Good for indexing.

---

Low Selectivity:

```text
Gender
Status
Country
```

Usually poor candidates.

---

# INDEX CARDINALITY

Number of unique values.

Higher cardinality usually means better index performance.

---

# COMMON MISTAKES

## Too Many Indexes

Every INSERT/UPDATE/DELETE must update indexes.

---

## Indexing Every Column

Consumes storage and hurts performance.

---

## Ignoring Composite Index Order

Wrong:

```sql
(salary, department_id)
```

When query uses:

```sql
department_id
```

---

# REAL WORLD USE CASES

## Dashboard Queries

```sql
WHERE order_date
```

Index order_date.

---

## Customer Search

```sql
WHERE email
```

Index email.

---

## Reporting

Use covering indexes.

---

## Data Warehouse

Use columnstore indexes.

---

# INTERVIEW QUESTIONS

## What is an Index?

A database object that improves query performance.

---

## Difference Between Clustered and Non-Clustered Index?

Clustered:
- Stores actual data order

Non-Clustered:
- Stores pointers to data

---

## How Many Clustered Indexes Per Table?

One.

---

## How Many Non-Clustered Indexes?

Multiple.

---

## What is a Composite Index?

Index on multiple columns.

---

## What is Leftmost Prefix Rule?

SQL can efficiently use index starting from leftmost column.

---

## What is a Covering Index?

Index contains all columns needed by query.

---

## Difference Between Index Seek and Index Scan?

Seek:
- Direct lookup

Scan:
- Reads many rows

---

## What is Fragmentation?

Disorganization of index pages.

---

## Difference Between Rebuild and Reorganize?

Rebuild recreates entire index.

Reorganize defragments existing index.

---

## Why Can Too Many Indexes Be Bad?

Because writes become slower.

---

# FINAL CHECKLIST

## Index Basics
✅

## Clustered Index
✅

## Non-Clustered Index
✅

## Composite Index
✅

## Unique Index
✅

## Covering Index
✅

## Filtered Index
✅

## Columnstore Index
✅

## B-Tree Structure
✅

## Index Seek
✅

## Index Scan
✅

## Table Scan
✅

## Fragmentation
✅

## Rebuild
✅

## Reorganize
✅

## Selectivity
✅

## Cardinality
✅

## Interview Questions
✅

## Real-World Scenarios
✅

---

# SUMMARY

Indexes are the most important SQL performance feature.

Proper indexing can improve query performance from minutes to milliseconds.

Mastering indexes is essential for:

- Data Analysts
- BI Developers
- SQL Developers
- Data Engineers
- SQL Interviews
