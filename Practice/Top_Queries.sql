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


