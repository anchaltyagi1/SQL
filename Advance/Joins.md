# JOINS IN SQL (COMPLETE GUIDE)

## What is JOIN?
JOIN is used to combine rows from two or more tables based on a related column.

Example:
employees table + departments table → joined using department_id

---

# 1. INNER JOIN

## Definition
Returns only matching rows from both tables.

## Query
SELECT e.emp_id, e.name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

## Result
Only employees who have a valid department match.

---

# 2. LEFT JOIN

## Definition
Returns all rows from LEFT table + matching rows from RIGHT table.
Non-matching rows show NULL.

## Query
SELECT e.emp_id, e.name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

## Result
All employees including those without departments.

---

# 3. RIGHT JOIN

## Definition
Returns all rows from RIGHT table + matching rows from LEFT table.

## Query
SELECT e.emp_id, e.name, d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;

## Result
All departments including those with no employees.

---

# 4. FULL OUTER JOIN

## Definition
Returns all rows from both tables.
Matches where possible, otherwise NULL.

## Query
SELECT e.emp_id, e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id;

## Result
All employees and all departments including unmatched rows.

---

# 5. CROSS JOIN

## Definition
Returns Cartesian product (all possible combinations).

## Query
SELECT e.name, d.department_name
FROM employees e
CROSS JOIN departments d;

## Result
Every employee combined with every department.

---

# 6. SELF JOIN

## Definition
A table joined with itself.

Used for hierarchical relationships like employee-manager.

## Query
SELECT e1.emp_id, e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.emp_id;

---

# IMPORTANT CONCEPTS

## 1. ON vs WHERE

- ON → defines relationship between tables
- WHERE → filters final result

Example:
SELECT *
FROM A
JOIN B ON A.id = B.id
WHERE A.age > 25;

ON is for joining condition, WHERE is for filtering.

---

## 2. NULL behavior in JOIN

- INNER JOIN removes non-matching rows
- LEFT JOIN keeps left rows even if right side is NULL

---

## 3. MULTIPLE JOINS

SELECT e.name, d.department_name, l.location_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

Used when data is spread across multiple tables.

---

# INTERVIEW QUESTIONS WITH ANSWERS

---

## 1. Difference between INNER JOIN and LEFT JOIN?

INNER JOIN:
- Returns only matching records from both tables

LEFT JOIN:
- Returns all records from left table + matching from right
- Non-matching rows show NULL

---

## 2. Why do NULLs appear in LEFT JOIN?

Because LEFT JOIN keeps all rows from left table.
If no match exists in right table, SQL fills NULL.

---

## 3. What is SELF JOIN used for?

SELF JOIN is used when a table relates to itself.

Example:
Employee → Manager relationship in same table.

---

## 4. Difference between ON and WHERE in JOIN?

ON:
- Used to define join condition

WHERE:
- Used to filter final result

Important:
Using WHERE on LEFT JOIN can turn it into INNER JOIN.

---

## 5. What is CROSS JOIN used for?

CROSS JOIN returns all possible combinations of rows.

Use cases:
- Combinations
- Testing data
- Product variations

---

## 6. Why use LEFT JOIN instead of INNER JOIN?

LEFT JOIN is used when we want:
- All records from main table
- Even if no matching data exists in other table

---

## REAL WORLD USE CASES

- Employee and department mapping
- Order and customer analysis
- Sales dashboards
- Hierarchical data (manager structure)
- Multi-table reporting systems

---

# SUMMARY

JOINS are one of the MOST IMPORTANT SQL topics.

Mastering JOINS = strong foundation for SQL interviews.

# 🔗 ADVANCED JOINS IN SQL

This file covers advanced join concepts used in real-world data engineering, analytics, and interview scenarios.

Covered topics:
- Anti Join
- Semi Join (EXISTS)
- Non-Equi Join
- Advanced Self Join patterns
- Join Performance Concepts
- Multiple Join strategy

---

# ❌ 1. ANTI JOIN

## Definition
Returns rows from left table that do NOT have a match in right table.

---

## Example (Employees without department)

SELECT e.*
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

---

## Use Case
- Find missing relationships
- Unmapped records
- Data quality checks

---

# 🟢 2. SEMI JOIN (EXISTS)

## Definition
Returns rows from first table if a match exists in second table.
(No duplicate rows returned)

---

## Example

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
);

---

## Use Case
- Faster alternative to INNER JOIN in some cases
- Existence checks
- Filtering valid records

---

# 🔁 3. NON-EQUI JOIN

## Definition
Join condition is NOT based on equality (=)
Uses operators like BETWEEN, <, >

---

## Example (Salary band mapping)

SELECT e.name, s.grade
FROM employees e
JOIN salary_grade s
ON e.salary BETWEEN s.min_salary AND s.max_salary;

---

## Use Case
- Salary grading
- Range-based mapping
- Price segmentation

---

# 🧠 4. ADVANCED SELF JOIN PATTERNS

## Definition
Joining a table with itself for hierarchical or comparison logic.

---

## Example (Employee → Manager mapping)

SELECT e1.name AS employee,
       e2.name AS manager
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.emp_id;

---

## Use Case
- Organizational hierarchy
- Reporting structure
- Parent-child relationships

---

# ⚡ 5. JOIN PERFORMANCE CONCEPTS

## Key Points

### 1. Indexing
- Always index join keys for faster execution

### 2. Filtering early
- Use WHERE before joining large datasets when possible

### 3. Avoid unnecessary columns
- Select only required fields

### 4. Prefer INNER JOIN when possible
- It reduces dataset size early

---

## Example Optimization Idea

Instead of:
SELECT *

Use:
SELECT emp_id, name

---

# 🔗 6. MULTIPLE JOINS

## Definition
Joining more than two tables in a single query.

---

## Example

SELECT e.name,
       d.department_name,
       l.location_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
JOIN locations l
    ON d.location_id = l.location_id;

---

## Use Case
- Real business reporting
- Dashboard data preparation
- Multi-source analytics

---

# 🧾 SUMMARY

Advanced JOIN concepts improve:
- Query performance
- Data accuracy
- Real-world analytics capability

---

# 🎯 INTERVIEW IMPORTANCE

- INNER/LEFT JOIN → VERY HIGH
- SELF JOIN → HIGH
- ANTI JOIN / EXISTS → HIGH
- NON-EQUI JOIN → MEDIUM
- PERFORMANCE CONCEPTS → HIGH
