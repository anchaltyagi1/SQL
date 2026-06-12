# SQL Introduction

## What is Data?

Data is a collection of raw facts and figures.

Examples:

* Customer Name = John
* Age = 25
* Salary = 50000

By itself, data has little meaning. After processing and analysis, data becomes useful information.

---

## What is a Database?

A Database is an organized collection of data stored electronically.

Example:

Customer Table

| Customer_ID | Name  | City   |
| ----------- | ----- | ------ |
| 101         | John  | Delhi  |
| 102         | Sarah | Mumbai |
| 103         | Mike  | Pune   |

A database helps store and retrieve data efficiently.

---

## Why Do We Need Databases?

Imagine a company storing customer information in Excel files.

Problems:

* Duplicate records
* Data inconsistency
* Difficult searching
* Security issues
* No relationship between files
* Difficult reporting

To overcome these problems, databases were introduced.

---

# File System vs Database System

Before databases, organizations stored data in files.

Example:

employees.xlsx

departments.xlsx

salaries.xlsx

Managing data through files creates many issues.

| File System                 | Database System             |
| --------------------------- | --------------------------- |
| Data redundancy is high     | Data redundancy is low      |
| Duplicate records exist     | Duplicate records minimized |
| Poor security               | Better security             |
| Difficult data retrieval    | Fast data retrieval         |
| No relationship management  | Relationships supported     |
| Difficult backup            | Easy backup and recovery    |
| Data inconsistency possible | Better data consistency     |
| Limited scalability         | Highly scalable             |

Example:

Suppose employee details are stored in three separate Excel files.

If employee address changes:

* Need to update all files manually.
* Risk of inconsistent data.

In databases:

* Update once.
* Changes reflect everywhere.

---

# What is DBMS?

DBMS stands for Database Management System.

It is software used to create, manage, and maintain databases.

Examples:

* MySQL
* Oracle
* SQL Server
* PostgreSQL
* SQLite

Functions of DBMS:

* Store data
* Retrieve data
* Update data
* Delete data
* Manage security
* Backup and recovery

---

# What is RDBMS?

RDBMS stands for Relational Database Management System.

It stores data in the form of tables.

A table consists of:

* Rows (Records)
* Columns (Fields)

Example:

Employee Table

| Emp_ID | Name  | Department |
| ------ | ----- | ---------- |
| 101    | John  | IT         |
| 102    | Sarah | HR         |

Department Table

| Dept_ID | Department |
| ------- | ---------- |
| 1       | IT         |
| 2       | HR         |

Both tables can be related using keys.

This relationship is the reason it is called a Relational Database.

---

# Why is it Called a Relational Database?

Because tables are connected through relationships.

Example:

Employee Table

| Emp_ID | Name  | Dept_ID |
| ------ | ----- | ------- |
| 101    | John  | 1       |
| 102    | Sarah | 2       |

Department Table

| Dept_ID | Department |
| ------- | ---------- |
| 1       | IT         |
| 2       | HR         |

Dept_ID links both tables.

Using relationships:

* Data duplication reduces
* Storage improves
* Maintenance becomes easier

---

# What is SQL?

SQL stands for Structured Query Language.

It is the standard language used to communicate with relational databases.

Using SQL we can:

* Create databases
* Create tables
* Insert records
* Retrieve data
* Update records
* Delete records
* Manage permissions
* Perform analysis

SQL is not case-sensitive.

Example:

```sql
SELECT * FROM employees;
```

and

```sql
select * from employees;
```

Both are valid.

---

# Types of SQL Commands

## 1. DDL (Data Definition Language)

Used to define database structure.

Commands:

* CREATE
* ALTER
* DROP
* TRUNCATE
* RENAME

---

## 2. DML (Data Manipulation Language)

Used to modify data.

Commands:

* INSERT
* UPDATE
* DELETE

---

## 3. DQL (Data Query Language)

Used to retrieve data.

Command:

* SELECT

---

## 4. DCL (Data Control Language)

Used to control user access.

Commands:

* GRANT
* REVOKE

---

## 5. TCL (Transaction Control Language)

Used to manage transactions.

Commands:

* COMMIT
* ROLLBACK
* SAVEPOINT

---

# Popular Databases

* MySQL
* PostgreSQL
* SQL Server
* Oracle
* SQLite
* MariaDB

---

# Why SQL is Important for Data Professionals?

SQL is the most demanded skill for:

* Data Analyst
* Business Analyst
* Data Engineer
* Data Scientist
* BI Developer
* Database Administrator

Almost every company stores data in databases, making SQL one of the most important tools for data analysis and reporting.

---

# Key Takeaways

* Data is stored inside databases.
* Databases solve problems of file systems.
* DBMS manages databases.
* RDBMS stores data in related tables.
* SQL is used to communicate with databases.
* SQL is the foundation of all data-related roles.
