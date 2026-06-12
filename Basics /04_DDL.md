# DDL (Data Definition Language)

## Introduction

DDL stands for **Data Definition Language**.

DDL commands are used to create, modify, rename, and delete database objects such as databases, tables, views, indexes, and schemas.

Unlike DML commands, which work with the actual data stored in tables, DDL commands work with the **structure (schema)** of the database.

Whenever we need to create a database, create a table, modify columns, or delete a table, we use DDL commands.

---

## Why Do We Need DDL?

DDL helps us:

* Create databases
* Create tables
* Modify table structures
* Add or remove columns
* Rename database objects
* Delete database objects
* Define the schema of a database

Without DDL commands, it would not be possible to design or maintain a database structure.

---

# DDL Commands

The most commonly used DDL commands are:

1. CREATE
2. ALTER
3. RENAME
4. TRUNCATE
5. DROP

---

# 1. CREATE Command

The CREATE command is used to create new database objects.

Examples of objects that can be created:

* Database
* Table
* View
* Index
* Procedure
* Function

---

## CREATE DATABASE

The CREATE DATABASE command creates a new database.

### Syntax

```sql
CREATE DATABASE database_name;
```

### Example

```sql
CREATE DATABASE company_db;
```

### What Happens?

A new database named `company_db` is created in the database system.

---

## USE DATABASE

Before creating tables, we must select the database.

### Syntax

```sql
USE database_name;
```

### Example

```sql
USE company_db;
```

Now all operations will be performed inside `company_db`.

---

## CREATE TABLE

The CREATE TABLE command creates a new table.

### Syntax

```sql
CREATE TABLE table_name (
    column_name datatype,
    column_name datatype
);
```

### Example

```sql
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(100),
    salary DECIMAL(10,2)
);
```

### Explanation

| Column        | Data Type     | Purpose              |
| ------------- | ------------- | -------------------- |
| employee_id   | INT           | Stores employee ID   |
| employee_name | VARCHAR(100)  | Stores employee name |
| salary        | DECIMAL(10,2) | Stores salary        |

---

## CREATE TABLE with Constraints

In real-world projects, tables usually contain constraints.

### Example

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2),
    joining_date DATE
);
```

### Explanation

* PRIMARY KEY uniquely identifies records.
* NOT NULL prevents empty values.
* UNIQUE prevents duplicate values.

---

## CREATE TABLE with AUTO_INCREMENT

### Example

```sql
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100)
);
```

### Why Use AUTO_INCREMENT?

Without AUTO_INCREMENT:

```sql
INSERT INTO employees
VALUES (1,'John');

INSERT INTO employees
VALUES (2,'Sarah');
```

We must manually manage IDs.

With AUTO_INCREMENT:

```sql
INSERT INTO employees(employee_name)
VALUES ('John');
```

The database automatically generates IDs.

---

# 2. ALTER Command

The ALTER command is used to modify an existing table structure.

Business requirements often change, and ALTER allows us to update the table without recreating it.

### Common Uses

* Add columns
* Modify columns
* Rename columns
* Remove columns

---

## ALTER TABLE ADD COLUMN

Adds a new column to an existing table.

### Syntax

```sql
ALTER TABLE table_name
ADD column_name datatype;
```

### Example

```sql
ALTER TABLE employees
ADD department VARCHAR(50);
```

### Before

| employee_id | employee_name |
| ----------- | ------------- |

### After

| employee_id | employee_name | department |
| ----------- | ------------- | ---------- |

---

## ALTER TABLE MODIFY COLUMN

Changes the data type or definition of an existing column.

### Example

```sql
ALTER TABLE employees
MODIFY salary DECIMAL(15,2);
```

### Why?

Suppose salary values increase and the current size becomes insufficient.

---

## ALTER TABLE RENAME COLUMN

Renames an existing column.

### Example

```sql
ALTER TABLE employees
RENAME COLUMN employee_name TO full_name;
```

### Before

```text
employee_name
```

### After

```text
full_name
```

---

## ALTER TABLE DROP COLUMN

Removes a column from the table.

### Example

```sql
ALTER TABLE employees
DROP COLUMN department;
```

### Warning

Once a column is dropped, all data stored in that column is lost.

---

# 3. RENAME Command

The RENAME command is used to rename database objects.

---

## Rename Table

### Syntax

```sql
RENAME TABLE old_table_name
TO new_table_name;
```

### Example

```sql
RENAME TABLE employees
TO employee_details;
```

### Why?

The new table name may better represent the business requirement.

---

# 4. TRUNCATE Command

The TRUNCATE command removes all rows from a table.

### Syntax

```sql
TRUNCATE TABLE employees;
```

### Example

Before:

| employee_id | employee_name |
| ----------- | ------------- |
| 1           | John          |
| 2           | Sarah         |

After:

| employee_id | employee_name |
| ----------- | ------------- |

The table still exists, but all rows are removed.

---

## Characteristics of TRUNCATE

* Removes all rows
* Table structure remains
* WHERE clause cannot be used
* Faster than DELETE
* Resets AUTO_INCREMENT in MySQL

---

## Why Is TRUNCATE Faster?

DELETE removes rows one by one.

TRUNCATE removes all rows at once.

Therefore, TRUNCATE is usually much faster.

---

# 5. DROP Command

The DROP command permanently removes a database object.

---

## DROP TABLE

### Syntax

```sql
DROP TABLE table_name;
```

### Example

```sql
DROP TABLE employees;
```

### What Happens?

* Table structure is removed.
* All data is removed.
* The table no longer exists.

---

## DROP DATABASE

### Syntax

```sql
DROP DATABASE database_name;
```

### Example

```sql
DROP DATABASE company_db;
```

### What Happens?

The entire database and everything inside it are permanently deleted.

---

# CREATE vs ALTER

| CREATE                    | ALTER                       |
| ------------------------- | --------------------------- |
| Creates a new object      | Modifies an existing object |
| Used for initial creation | Used after creation         |
| Object must not exist     | Object must already exist   |

---

# DROP vs TRUNCATE

| Feature                      | DROP | TRUNCATE |
| ---------------------------- | ---- | -------- |
| Removes Data                 | Yes  | Yes      |
| Removes Structure            | Yes  | No       |
| Table Exists After Execution | No   | Yes      |
| Can Be Reused                | No   | Yes      |

---

# Common Mistakes

## Forgetting to Select Database

### Incorrect

```sql
CREATE TABLE employees (
    id INT
);
```

The table may be created in the wrong database.

### Correct

```sql
USE company_db;

CREATE TABLE employees (
    id INT
);
```

---

## Accidentally Dropping a Table

### Dangerous

```sql
DROP TABLE employees;
```

Always verify before executing DROP commands because recovery may not be possible.

---

## Using TRUNCATE Instead of DELETE

### Incorrect Scenario

```sql
TRUNCATE TABLE employees;
```

All rows will be removed.

If only specific rows should be deleted:

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

---

# Frequently Asked Interview Questions

## What is DDL?

DDL (Data Definition Language) is used to create, modify, rename, and delete database structures.

---

## Name the DDL Commands.

* CREATE
* ALTER
* RENAME
* TRUNCATE
* DROP

---

## What is the Difference Between CREATE and ALTER?

CREATE is used to create a new database object.

ALTER is used to modify an existing database object.

---

## What is the Difference Between DROP and TRUNCATE?

DROP removes both structure and data.

TRUNCATE removes only data while keeping the structure intact.

---

## Can We Use WHERE with TRUNCATE?

No.

```sql
TRUNCATE TABLE employees;
```

TRUNCATE always removes all rows.

---

## Which Is Faster: DELETE or TRUNCATE?

TRUNCATE is generally faster because it removes all rows at once rather than deleting rows individually.

---

# Summary

DDL (Data Definition Language) is used to define and manage database structures.

The main DDL commands are:

* CREATE → Creates new objects
* ALTER → Modifies existing objects
* RENAME → Renames objects
* TRUNCATE → Removes all rows while keeping the structure
* DROP → Permanently removes objects

DDL commands form the foundation of database design and are among the most frequently asked topics in SQL interviews.
