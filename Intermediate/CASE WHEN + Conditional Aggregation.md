# CASE WHEN

## What is CASE WHEN?

CASE WHEN is SQL's version of IF-ELSE logic.

It allows us to create conditional logic inside queries.

Using CASE, we can:

- Categorize data
- Create custom labels
- Perform conditional calculations
- Build dashboard metrics
- Create reports

---

# Why Do We Need CASE WHEN?

Suppose management wants to classify employees based on salary.

| Salary Range | Category |
|-------------|-----------|
| >= 70000 | High Salary |
| >= 50000 | Medium Salary |
| < 50000 | Low Salary |

CASE WHEN helps us create these categories.

---

# CASE WHEN Syntax

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result3
END
```

---

# Basic CASE Example

```sql
SELECT employee_name,
       salary,
       CASE
           WHEN salary >= 70000 THEN 'High Salary'
           WHEN salary >= 50000 THEN 'Medium Salary'
           ELSE 'Low Salary'
       END AS salary_category
FROM employees;
```

Output:

| employee_name | salary | salary_category |
|--------------|---------|----------------|
| John | 50000 | Medium Salary |
| Sarah | 60000 | Medium Salary |
| Mike | 70000 | High Salary |
| Emma | 40000 | Low Salary |

---

# CASE with Department

```sql
SELECT employee_name,
       department,
       CASE
           WHEN department = 'IT' THEN 'Technical Team'
           WHEN department = 'HR' THEN 'Human Resources'
           ELSE 'Other Department'
       END AS department_type
FROM employees;
```

---

# CASE in ORDER BY

Employees can be sorted using custom logic.

```sql
SELECT *
FROM employees
ORDER BY
CASE
    WHEN department = 'IT' THEN 1
    WHEN department = 'HR' THEN 2
    ELSE 3
END;
```

---

# CASE in GROUP BY

```sql
SELECT
CASE
    WHEN salary >= 50000 THEN 'Above 50K'
    ELSE 'Below 50K'
END AS salary_group,
COUNT(*) AS employee_count
FROM employees
GROUP BY
CASE
    WHEN salary >= 50000 THEN 'Above 50K'
    ELSE 'Below 50K'
END;
```

---

# CASE in Aggregate Functions

One of the most powerful uses of CASE.

---

# Conditional SUM

Suppose management wants total salary paid to IT employees.

```sql
SELECT
SUM(
CASE
    WHEN department = 'IT'
    THEN salary
    ELSE 0
END
) AS it_salary
FROM employees;
```

Output:

```text
120000
```

---

# Conditional COUNT

Count IT employees.

```sql
SELECT
COUNT(
CASE
    WHEN department = 'IT'
    THEN 1
END
) AS it_employee_count
FROM employees;
```

Output:

```text
2
```

---

# Better Approach

```sql
SELECT
SUM(
CASE
    WHEN department = 'IT'
    THEN 1
    ELSE 0
END
) AS it_employee_count
FROM employees;
```

---

# Multiple Conditional Counts

```sql
SELECT
SUM(CASE WHEN department = 'IT' THEN 1 ELSE 0 END) AS IT_Count,
SUM(CASE WHEN department = 'HR' THEN 1 ELSE 0 END) AS HR_Count,
SUM(CASE WHEN department = 'Sales' THEN 1 ELSE 0 END) AS Sales_Count
FROM employees;
```

Output:

| IT_Count | HR_Count | Sales_Count |
|----------|-----------|------------|
| 2 | 2 | 1 |

---

# Conditional Aggregation

## What is Conditional Aggregation?

Conditional Aggregation combines:

```text
CASE WHEN
+
Aggregate Functions
```

This is one of the most important SQL interview topics.

---

# Department-wise Salary

```sql
SELECT
SUM(CASE WHEN department='IT' THEN salary ELSE 0 END) AS IT_Salary,
SUM(CASE WHEN department='HR' THEN salary ELSE 0 END) AS HR_Salary,
SUM(CASE WHEN department='Sales' THEN salary ELSE 0 END) AS Sales_Salary
FROM employees;
```

---

# Gender-wise Employee Count

```sql
SELECT
SUM(CASE WHEN gender='Male' THEN 1 ELSE 0 END) AS Male_Count,
SUM(CASE WHEN gender='Female' THEN 1 ELSE 0 END) AS Female_Count
FROM employees;
```

---

# Order Status Dashboard Example

Orders Table

| order_id | status |
|-----------|----------|
| 1 | Delivered |
| 2 | Pending |
| 3 | Cancelled |
| 4 | Delivered |

```sql
SELECT
SUM(CASE WHEN status='Delivered' THEN 1 ELSE 0 END) AS Delivered,
SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) AS Pending,
SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END) AS Cancelled
FROM orders;
```

---

# CASE with AVG

Average salary of IT employees.

```sql
SELECT
AVG(
CASE
    WHEN department='IT'
    THEN salary
END
) AS IT_Average_Salary
FROM employees;
```

---

# Nested CASE

CASE can be written inside another CASE.

```sql
SELECT employee_name,
CASE
    WHEN department='IT' THEN
        CASE
            WHEN salary > 60000
            THEN 'Senior IT'
            ELSE 'Junior IT'
        END
    ELSE 'Non IT'
END AS employee_category
FROM employees;
```

---

# CASE vs IF

| CASE | IF |
|---------|---------|
| Standard SQL | Database Specific |
| Portable | Not Portable |
| Preferred in Interviews | Less Preferred |

---

# Common CASE Mistakes

## Forgetting ELSE

```sql
CASE
WHEN salary > 50000 THEN 'High'
END
```

Rows not matching condition return NULL.

Always prefer:

```sql
CASE
WHEN salary > 50000 THEN 'High'
ELSE 'Low'
END
```

---

## Wrong Condition Order

Wrong:

```sql
CASE
WHEN salary > 50000 THEN 'Medium'
WHEN salary > 70000 THEN 'High'
END
```

Salary 80000 becomes Medium.

Correct:

```sql
CASE
WHEN salary > 70000 THEN 'High'
WHEN salary > 50000 THEN 'Medium'
ELSE 'Low'
END
```

---

# Real World Dashboard Examples

## Employee Dashboard

```sql
SELECT
COUNT(*) AS Total_Employees,
SUM(CASE WHEN department='IT' THEN 1 ELSE 0 END) AS IT_Employees,
SUM(CASE WHEN department='HR' THEN 1 ELSE 0 END) AS HR_Employees
FROM employees;
```

---

## Sales Dashboard

```sql
SELECT
SUM(CASE WHEN status='Completed' THEN amount ELSE 0 END) AS Completed_Sales,
SUM(CASE WHEN status='Cancelled' THEN amount ELSE 0 END) AS Cancelled_Sales
FROM orders;
```

---

## Marketing Dashboard

```sql
SELECT
SUM(CASE WHEN channel='Google' THEN revenue ELSE 0 END) AS Google_Revenue,
SUM(CASE WHEN channel='Facebook' THEN revenue ELSE 0 END) AS Facebook_Revenue
FROM campaigns;
```

---

# Frequently Asked Interview Questions

## What is CASE WHEN?

CASE WHEN provides conditional logic in SQL similar to IF-ELSE.

---

## What is Conditional Aggregation?

Using CASE inside aggregate functions such as SUM(), COUNT(), and AVG().

---

## Which Is Better: CASE or IF?

CASE is preferred because it is ANSI SQL standard.

---

## Can CASE Be Used Inside GROUP BY?

Yes.

---

## Can CASE Be Used Inside Aggregate Functions?

Yes.

This is called Conditional Aggregation.

---

# Summary

CASE WHEN is used to apply conditional logic in SQL.

Most Important Concepts:

- CASE WHEN
- ELSE
- Nested CASE
- CASE with GROUP BY
- CASE with ORDER BY
- CASE with Aggregate Functions
- Conditional Aggregation

Conditional Aggregation is one of the most frequently asked SQL interview topics and is heavily used in real-world dashboards and reports.
