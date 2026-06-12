'''🧾 Standard Tables (we will use throughout)
👤 employees
emp_id
emp_name
department
salary
manager_id
hire_date
  
🏢 departments
dept_id
dept_name
  
🛒 orders
order_id
customer_id
order_date
amount
  
👥 customers
customer_id
customer_name
city
age ''' 

-- 1. Write a SQL query to fetch all records and all columns from the employees table.
  SELECT * FROM employees;

--2. Write a SQL query to fetch only employee names and salaries from the employees table.
SELECT emp_name, salary 
FROM employees;

--3. Write a SQL query to find all employees whose salary is greater than 50,000.
SELECT emp_id, emp_name, salary
FROM employees
WHERE salary > 50000;

--4. Write a SQL query to fetch all employees whose department is 'IT' and salary is greater than 60,000.
SELECT emp_id, emp_name, department, salary
FROM employees
WHERE department = 'IT'
  AND salary > 60000;

--5. Write a SQL query to fetch all employees whose name starts with 'A'.
SELECT emp_id, emp_name
FROM employees
WHERE emp_name LIKE 'A%';

--6 Write a SQL query to find the total number of employees in the employees table.
SELECT COUNT(emp_id) AS total_employees
FROM employees;

--7. Write a SQL query to fetch the highest salary from the employees table.
SELECT MAX(salary) AS max_salary
FROM employees;

--8. Write a SQL query to fetch the second highest salary from the employees table using subquery.
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

--9 Write a SQL query to fetch the second highest salary from the employees table using subquery using limit offset.
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

--10 Write a SQL query to fetch the second highest salary from the employees table using subquery using Window functions.
SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) AS t
WHERE rnk = 2;

--11. Write a SQL query to fetch the top 3 highest salaries from the employees table using any method you prefer (window function preferred).
SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) AS t
WHERE rnk <= 3;

--12. Write a SQL query to find employees who earn more than the average salary of the company.
SELECT emp_id, emp_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--13. Write a SQL query to find the department having the highest average salary.
WITH CTE AS (
    SELECT department,
           AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM CTE
WHERE avg_salary = (SELECT MAX(avg_salary) FROM CTE);

--14. Find employees who have duplicate salaries.
SELECT salary
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

--15.Find employees who have duplicate salaries with full employee details.
SELECT *
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*) > 1
);

--16.Find employees who have duplicate salaries with full employee details using window function.
SELECT emp_id, emp_name, salary
FROM (
    SELECT *,
           COUNT(*) OVER (PARTITION BY salary) AS cnt
    FROM employees
) t
WHERE cnt > 1;

--17. Write a SQL query to find the highest salary in each department using Group by.
SELECT department, MAX(salary)As max_salary
FROM employees
GROUP BY department;

--18. Find highest salary in each department using window function.
SELECT department, salary
FROM (
    SELECT department,
           salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;

--19. Write a SQL query to find the total salary (SUM) for each department.
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department;

--20 Write a SQL query to find the average salary of employees in each department and show only those departments where average salary is greater than 50,000.
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;

--21 Write a SQL query to find the number of employees in each department.
SELECT department, COUNT(*) AS total_count
FROM employees
GROUP BY department;

--21 Write a SQL query to find the number of employees in each department using window function.
SELECT emp_id, department,
       COUNT(*) OVER (PARTITION BY department) AS total_count
FROM employees;

--22 Write a SQL query to find the employees who joined most recently (latest hire_date).
SELECT *
FROM employees
ORDER BY hire_date DESC
LIMIT 1;

--Another method 
SELECT *
FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);

--Window method
SELECT *
FROM (
    SELECT *,
           RANK() OVER (ORDER BY hire_date DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;

--23 Write a SQL query to find the second highest salary in each department.
SELECT department, salary
FROM (
    SELECT department, salary,
           DENSE_RANK() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 2;

--24 Write a SQL query to find the top 2 highest salaries in each department.
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY department 
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk <= 2;

--25 Write a SQL query to find employees who earn more than the average salary of their own department.
SELECT *
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM employees
) t
WHERE salary > dept_avg;


-- Another method 
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department = e.department
);

--26 Write a SQL query to find the highest salary employee in each department along with all their details.
SELECT *
FROM (
    SELECT *,
           MAX(salary) OVER (PARTITION BY department) AS max_salary
    FROM employees
) t
WHERE salary = max_salary;

-- Another method
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;

--27 Write a SQL query to find employees whose salary is in the top 10% of their department.
SELECT *
FROM (
    SELECT *,
           NTILE(10) OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS percentile
    FROM employees
) t
WHERE percentile = 1;




