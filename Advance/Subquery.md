# 🧠 SUBQUERIES IN SQL (COMPLETE GUIDE)

## 📌 What is a Subquery?
A subquery is a query written inside another query.
It is also called a nested query.

It is used to:
- Break complex logic
- Filter data dynamically
- Compare aggregated results
- Build step-by-step logic

---

# 🧩 1. SIMPLE SUBQUERY (WHERE)

## Definition
Subquery used in WHERE clause for filtering.

## Example: Employees earning above average salary

SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

---

## Use Case
- Compare individual values with aggregated values

---

# 🧩 2. SUBQUERY IN SELECT

## Definition
Subquery used to generate a derived column.

## Example: Show salary and average salary

SELECT name,
       salary,
       (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees;

---

## Use Case
- Add calculated metrics in output

---

# 🧩 3. SUBQUERY IN FROM (DERIVED TABLE)

## Definition
Subquery used as a temporary table.

## Example: Department-wise average salary

SELECT department_id, avg_salary
FROM (
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg;

---

## Use Case
- Break complex aggregation into steps

---

# 🧩 4. CORRELATED SUBQUERY

## Definition
Inner query depends on outer query.

## Example: Employees earning above department average

SELECT e1.*
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

---

## Use Case
- Row-by-row comparison

---

# 🧩 5. EXISTS SUBQUERY

## Definition
Checks if rows exist in subquery result.

## Example

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);

---

## Use Case
- Fast existence check
- Alternative to INNER JOIN

---

# 🧩 6. NOT EXISTS SUBQUERY

## Example: Employees without department

SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);

---

## Use Case
- Finding missing or unmatched records

---

# 🧩 7. MULTI-ROW SUBQUERY (IN)

## Example

SELECT *
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
);

---

## Use Case
- Filter based on list of values

---

# 🧩 8. SCALAR SUBQUERY

Returns single value.

SELECT (
    SELECT MAX(salary)
    FROM employees
) AS max_salary;

---

# ⚡ 9. SUBQUERY IN HAVING

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

---

# 🔄 10. UPDATE USING SUBQUERY

UPDATE employees
SET salary = salary * 1.1
WHERE department_id = (
    SELECT department_id
    FROM departments
    WHERE department_name = 'Sales'
);

---

# ❌ 11. DELETE USING SUBQUERY

DELETE FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location = 'Old City'
);

---

# ⚡ IMPORTANT CONCEPTS

## 1. SUBQUERY vs JOIN

Subquery:
- Easier to write
- Used for step-by-step logic
- Can be slower

JOIN:
- Faster in most cases
- Better for large datasets

---

## 2. IN vs EXISTS

IN:
- Works with list of values

EXISTS:
- Checks existence
- More efficient for large datasets

---

## 3. CORRELATED SUBQUERY

- Executes row by row
- Slower than normal subquery
- Used for comparisons within groups

---

# 🧠 INTERVIEW QUESTIONS WITH ANSWERS

---

## 1. What is a subquery?

A query inside another query used to return intermediate results.

---

## 2. Difference between subquery and JOIN?

Subquery:
- Nested structure
- Easier for logic breakdown

JOIN:
- Combines tables directly
- More efficient in most cases

---

## 3. What is correlated subquery?

A subquery that depends on outer query values and runs row-by-row.

---

## 4. Difference between IN and EXISTS?

IN:
- Checks against list of values

EXISTS:
- Checks if rows exist
- Faster in large datasets

---

## 5. Why use subqueries?

- To break complex problems
- To filter dynamically
- To compare aggregated results

---

# 📌 REAL WORLD USE CASES

- Salary comparisons within departments
- Finding top performers
- Detecting missing relationships
- Customer order validation
- Data quality checks

---

# 🚀 SUMMARY

Subqueries are essential for:
- Filtering
- Aggregation logic
- Existence checks
- Complex query breakdown

They are a core part of SQL interviews and analytics work.
