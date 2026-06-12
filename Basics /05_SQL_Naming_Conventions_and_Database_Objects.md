# SQL Naming Conventions and Database Objects

## Introduction

Writing SQL queries is not just about getting the correct result. In real-world projects, code should also be easy to read, understand, maintain, and debug. This is where naming conventions and database objects become important.

Naming conventions provide a standard way to name databases, tables, columns, and other objects. Database objects are the structures inside a database that help store, retrieve, manage, and manipulate data efficiently.

---

# SQL Naming Conventions

## Why Naming Conventions Matter?

Good naming conventions:

* Improve readability
* Make maintenance easier
* Reduce confusion
* Help teams collaborate effectively
* Follow industry best practices

---

## Database Naming Convention

Use meaningful names.

✅ Good Examples

```sql
company_db
sales_db
employee_management_db
```

❌ Bad Examples

```sql
db1
test
mydatabase
```

---

## Table Naming Convention

Table names should clearly describe the data being stored.

✅ Good Examples

```sql
employees
customers
orders
products
```

❌ Bad Examples

```sql
emp
tbl1
data
```

---

## Column Naming Convention

Column names should be descriptive.

✅ Good Examples

```sql
employee_id
employee_name
salary
joining_date
```

❌ Bad Examples

```sql
id
name1
x
```

---

## Primary Key Naming Convention

Use:

```sql
employee_id
customer_id
order_id
```

instead of:

```sql
id
eid
cid
```

---

## Foreign Key Naming Convention

Foreign key names should match the referenced primary key.

Example:

```sql
department_id
employee_id
product_id
```

---

## Boolean Column Naming Convention

Use prefixes such as:

```sql
is_active
is_deleted
is_verified
```

---

## SQL Formatting Best Practices

### Use Uppercase for SQL Keywords

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

### Use Proper Indentation

```sql
SELECT employee_id,
       employee_name,
       salary
FROM employees
WHERE salary > 50000;
```

### Avoid Using SELECT *

Instead use:

```sql
SELECT employee_id,
       employee_name
FROM employees;
```

---

# Database Objects

## What are Database Objects?

Database Objects are structures created inside a database to store, manage, retrieve, secure, and manipulate data.

Common Database Objects include:

1. Database
2. Schema
3. Table
4. View
5. Index
6. Stored Procedure
7. Function
8. Trigger

---

# 1. Database

A Database is an organized collection of related data.

Example:

```sql
CREATE DATABASE company_db;
```

A company database may contain employee, customer, sales, and product information.

---

# 2. Schema

A Schema is a logical container that organizes database objects.

Example:

```text
Company_DB
│
├── HR Schema
├── Sales Schema
└── Finance Schema
```

Benefits:

* Better organization
* Improved security
* Easier maintenance

---

# 3. Table

A Table stores data in rows and columns.

Example:

| Employee_ID | Employee_Name | Salary |
| ----------- | ------------- | ------ |
| 101         | John          | 50000  |
| 102         | Sarah         | 60000  |

Example:

```sql
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    salary DECIMAL(10,2)
);
```

---

# 4. View

A View is a virtual table created from a SQL query.

Example:

```sql
CREATE VIEW high_salary_employees AS
SELECT *
FROM employees
WHERE salary > 50000;
```

Benefits:

* Simplifies complex queries
* Improves security
* Promotes code reusability

---

# 5. Index

An Index improves query performance by reducing the amount of data scanned.

Example:

```sql
CREATE INDEX idx_employee_name
ON employees(employee_name);
```

Advantages:

* Faster searches
* Faster filtering
* Improved SELECT performance

Disadvantages:

* Uses additional storage
* Slows INSERT, UPDATE, and DELETE operations

---

# 6. Stored Procedure

A Stored Procedure is a precompiled SQL program stored in the database.

Example:

```sql
CREATE PROCEDURE get_employees()
BEGIN
    SELECT * FROM employees;
END;
```

Benefits:

* Reusable code
* Better performance
* Improved security

---

# 7. Function

A Function is a database object that returns a value.

Example:

```sql
SELECT UPPER('sql');
```

Output:

```text
SQL
```

Common Functions:

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
UPPER()
LOWER()
ROUND()
```

---

# 8. Trigger

A Trigger is a database object that automatically executes when a specified event occurs.

Events:

* INSERT
* UPDATE
* DELETE

Example:

```sql
CREATE TRIGGER employee_log
AFTER INSERT
ON employees
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES ('New Employee Added');
END;
```

Uses:

* Auditing
* Logging
* Data validation

---

# Frequently Asked Interview Questions

### What is the difference between a Table and a View?

| Table                  | View                        |
| ---------------------- | --------------------------- |
| Stores data physically | Virtual table               |
| Occupies storage       | Depends on underlying table |
| Independent            | Depends on table            |

---

### What is an Index?

An Index is a database object that improves query performance by allowing faster data retrieval.

---

### What is a Trigger?

A Trigger is a database object that automatically executes when INSERT, UPDATE, or DELETE operations occur.

---

### What is the purpose of a Schema?

A Schema helps organize database objects and improves security and manageability.

---

# Important Points

## CREATE DATABASE IF NOT EXISTS

The `IF NOT EXISTS` clause prevents an error if the database already exists.

### Syntax

```sql
CREATE DATABASE IF NOT EXISTS company_db;
```

### Why Use It?

Without `IF NOT EXISTS`:

```sql
CREATE DATABASE company_db;
```

If the database already exists, MySQL will throw an error.

Using `IF NOT EXISTS` makes scripts safer and reusable.

---

## CREATE TABLE IF NOT EXISTS

The `IF NOT EXISTS` clause prevents an error if the table already exists.

### Syntax

```sql
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100)
);
```

### Why Use It?

When running scripts multiple times, table creation may fail if the table already exists.

Using `IF NOT EXISTS` prevents unnecessary errors.

---

## DROP TABLE IF EXISTS

The `IF EXISTS` clause prevents an error if the table does not exist.

### Syntax

```sql
DROP TABLE IF EXISTS employees;
```

### Why Use It?

Without `IF EXISTS`:

```sql
DROP TABLE employees;
```

MySQL generates an error if the table is not present.

Using `IF EXISTS` makes scripts safer.

---

## SHOW DATABASES

Displays all databases available in the database server.

### Syntax

```sql
SHOW DATABASES;
```

### Example Output

```text
company_db
sales_db
hr_db
inventory_db
```

### Why Is It Useful?

* Verify database creation
* View available databases
* Navigate between databases

---

## SHOW TABLES

Displays all tables inside the currently selected database.

### Syntax

```sql
SHOW TABLES;
```

### Example Output

```text
employees
departments
customers
orders
```

### Why Is It Useful?

* Verify table creation
* View available tables
* Explore database structure

---

## DESCRIBE TABLE

Displays the structure of a table.

### Syntax

```sql
DESC employees;
```

or

```sql
DESCRIBE employees;
```

### Example Output

| Field         | Type          | Null | Key |
| ------------- | ------------- | ---- | --- |
| employee_id   | int           | NO   | PRI |
| employee_name | varchar(100)  | NO   |     |
| salary        | decimal(10,2) | YES  |     |

### Why Is It Useful?

It helps developers quickly understand:

* Column names
* Data types
* Constraints
* Primary keys
* NULL settings

---

## Additional ALTER TABLE Operations

### Add Column

```sql
ALTER TABLE employees
ADD department VARCHAR(50);
```

Used when a new column is required.

---

### Modify Column

```sql
ALTER TABLE employees
MODIFY salary DECIMAL(15,2);
```

Used when changing a column's data type or size.

---

### Rename Column

```sql
ALTER TABLE employees
RENAME COLUMN employee_name TO full_name;
```

Used when column names need improvement or business requirements change.

---

### Drop Column

```sql
ALTER TABLE employees
DROP COLUMN department;
```

Used when a column is no longer needed.

⚠️ Warning: All data stored in the column will be permanently lost.

---

### Add Constraint

```sql
ALTER TABLE employees
ADD CONSTRAINT pk_employee
PRIMARY KEY(employee_id);
```

Used when constraints were not defined during table creation.

---

## Best Practices

### Always Use Meaningful Names

✅ Good

```sql
employees
customers
orders
```

❌ Bad

```sql
table1
data
test
```

---

### Use IF EXISTS and IF NOT EXISTS

These clauses make scripts safer and prevent unnecessary errors.

---

### Verify Before DROP

Before executing:

```sql
DROP TABLE employees;
```

Always ensure the table is no longer needed.

DROP commands can permanently remove data and structure.

---

### Use DESCRIBE Frequently

Before writing queries on an unfamiliar table:

```sql
DESC employees;
```

This helps understand the table structure and avoid mistakes.

---

## Quick Revision

| Command         | Purpose                |
| --------------- | ---------------------- |
| CREATE DATABASE | Creates a database     |
| CREATE TABLE    | Creates a table        |
| ALTER TABLE     | Modifies a table       |
| RENAME TABLE    | Renames a table        |
| TRUNCATE TABLE  | Removes all rows       |
| DROP TABLE      | Removes table and data |
| DROP DATABASE   | Removes database       |
| SHOW DATABASES  | Lists databases        |
| SHOW TABLES     | Lists tables           |
| DESCRIBE        | Shows table structure  |
