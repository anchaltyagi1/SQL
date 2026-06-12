# DML (Data Manipulation Language)

## Introduction

DML stands for **Data Manipulation Language**.

DML commands are used to insert, update, delete, and manipulate data stored inside database tables.

Unlike DDL commands, which work on the structure of database objects, DML commands work on the actual records stored in those objects.

DML is one of the most frequently used categories of SQL commands because data is continuously added, modified, and removed in real-world applications.

---

## Why Do We Need DML?

DML helps us:

- Add new records
- Modify existing records
- Remove records
- Copy data between tables
- Manage business data efficiently

Without DML, a database would contain only empty tables.

---

# DML Commands

The most commonly used DML commands are:

1. INSERT
2. UPDATE
3. DELETE

---

# 1. INSERT Command

## What is INSERT?

The INSERT command is used to add new records into a table.

---

## INSERT Complete Row

### Syntax

```sql
INSERT INTO table_name
VALUES(value1, value2, value3);
```

### Example

```sql
INSERT INTO employees
VALUES(101, 'John', 50000);
```

### Result

| employee_id | employee_name | salary |
|------------|---------------|---------|
| 101 | John | 50000 |

---

## INSERT Into Specific Columns

### Syntax

```sql
INSERT INTO table_name
(column1, column2)
VALUES(value1, value2);
```

### Example

```sql
INSERT INTO employees
(employee_id, employee_name)
VALUES(102, 'Sarah');
```

### Why Use This?

- Not all columns require values
- Some columns have DEFAULT values
- AUTO_INCREMENT columns are automatically populated

---

## INSERT Multiple Rows

### Syntax

```sql
INSERT INTO table_name
VALUES
(value1, value2),
(value3, value4);
```

### Example

```sql
INSERT INTO employees
VALUES
(103,'Mike',60000),
(104,'Emma',70000);
```

### Benefits

- Faster execution
- Cleaner code
- Reduces multiple INSERT statements

---

## INSERT NULL Values

### Example

```sql
INSERT INTO employees
VALUES(105,'David',NULL);
```

### When Used?

When a column allows NULL values and information is not available.

---

## INSERT Using DEFAULT Values

### Example

```sql
INSERT INTO employees(employee_name)
VALUES('Alex');
```

If other columns have DEFAULT values, the database automatically inserts them.

---

## INSERT INTO SELECT

Used to copy data from one table to another.

### Syntax

```sql
INSERT INTO target_table
SELECT *
FROM source_table;
```

### Example

```sql
INSERT INTO employee_backup
SELECT *
FROM employees;
```

### Uses

- Backup creation
- Data migration
- Archiving historical records

---

# Common INSERT Mistakes

## Wrong Number of Values

### Incorrect

```sql
INSERT INTO employees
VALUES(101,'John');
```

If the table contains three columns, SQL throws an error.

---

## Wrong Data Type

### Incorrect

```sql
INSERT INTO employees
VALUES('ABC','John',50000);
```

If employee_id is INT, insertion fails.

---

## Duplicate Primary Key

### Incorrect

```sql
INSERT INTO employees
VALUES(101,'John',50000);

INSERT INTO employees
VALUES(101,'Sarah',60000);
```

### Problem

Primary Key values must be unique.

---

# 2. UPDATE Command

## What is UPDATE?

The UPDATE command modifies existing records.

---

## Update Single Row

### Syntax

```sql
UPDATE table_name
SET column_name = value
WHERE condition;
```

### Example

```sql
UPDATE employees
SET salary = 60000
WHERE employee_id = 101;
```

---

## Update Multiple Columns

### Example

```sql
UPDATE employees
SET employee_name = 'John Smith',
    salary = 65000
WHERE employee_id = 101;
```

---

## Update Multiple Rows

### Example

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
```

### What Happens?

All employees in the IT department receive a 10% salary increase.

---

## Update Using CASE

### Example

```sql
UPDATE employees
SET salary =
CASE
    WHEN department = 'IT' THEN salary * 1.20
    WHEN department = 'HR' THEN salary * 1.10
    ELSE salary
END;
```

### Why Use CASE?

Different updates can be applied to different groups of rows.

---

## Update Using Subquery

### Example

```sql
UPDATE employees
SET salary =
(
    SELECT AVG(salary)
    FROM employees
)
WHERE employee_id = 101;
```

---

# Common UPDATE Mistakes

## Forgetting WHERE Clause

### Dangerous

```sql
UPDATE employees
SET salary = 100000;
```

### Result

Every row gets updated.

Before:

| employee_id | salary |
|------------|---------|
| 101 | 50000 |
| 102 | 60000 |

After:

| employee_id | salary |
|------------|---------|
| 101 | 100000 |
| 102 | 100000 |

This is one of the most common production issues.

---

# 3. DELETE Command

## What is DELETE?

DELETE removes records from a table.

---

## Delete Specific Rows

### Syntax

```sql
DELETE FROM table_name
WHERE condition;
```

### Example

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

---

## Delete Multiple Rows

### Example

```sql
DELETE FROM employees
WHERE salary < 50000;
```

Deletes all employees earning less than 50000.

---

## Delete All Rows

### Example

```sql
DELETE FROM employees;
```

### Result

All rows are removed.

The table structure remains intact.

---

## Delete Using Subquery

### Example

```sql
DELETE FROM employees
WHERE department_id IN
(
    SELECT department_id
    FROM departments
    WHERE location = 'Delhi'
);
```

---

# Common DELETE Mistakes

## Forgetting WHERE Clause

### Dangerous

```sql
DELETE FROM employees;
```

### Result

Every row is deleted.

The table remains but all data is lost.

---

# Important Concepts

## Safe Update Mode (MySQL)

MySQL may block commands such as:

```sql
UPDATE employees
SET salary = 100000;
```

or

```sql
DELETE FROM employees;
```

without a WHERE clause.

### Why?

To prevent accidental data loss.

---

## Auto Commit

Many databases automatically commit DML operations after execution.

Others require:

```sql
COMMIT;
```

to permanently save changes.

---

## Rollback Support

DML operations usually support rollback.

### Example

```sql
DELETE FROM employees
WHERE employee_id = 101;

ROLLBACK;
```

If changes are not committed, they can be undone.

---

# INSERT vs UPDATE

| INSERT | UPDATE |
|----------|----------|
| Adds new rows | Modifies existing rows |
| Creates records | Changes records |
| Uses VALUES | Uses SET |

---

# DELETE vs TRUNCATE

| Feature | DELETE | TRUNCATE |
|----------|----------|----------|
| Command Type | DML | DDL |
| WHERE Clause | Yes | No |
| Specific Rows | Yes | No |
| Deletes All Rows | Yes | Yes |
| Rollback | Usually Yes | Depends on DBMS |
| Faster | No | Yes |
| Auto Increment Reset | No | Usually Yes |

---

# DML vs DDL

| DML | DDL |
|----------|----------|
| Works on data | Works on structure |
| INSERT | CREATE |
| UPDATE | ALTER |
| DELETE | DROP |

---

# Real-World Examples

## New Employee Joins

```sql
INSERT INTO employees
VALUES(106,'Michael',75000);
```

---

## Employee Gets Promotion

```sql
UPDATE employees
SET salary = 85000
WHERE employee_id = 106;
```

---

## Employee Leaves Company

```sql
DELETE FROM employees
WHERE employee_id = 106;
```

---

# Best Practices

## Always Specify Column Names During INSERT

### Recommended

```sql
INSERT INTO employees
(employee_id, employee_name, salary)
VALUES(101,'John',50000);
```

### Why?

If table structure changes, the query will continue to work correctly.

---

## Always Use WHERE With UPDATE

### Recommended

```sql
UPDATE employees
SET salary = 60000
WHERE employee_id = 101;
```

---

## Always Use WHERE With DELETE

### Recommended

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

---

## Verify Data Before Deleting

Use SELECT first.

```sql
SELECT *
FROM employees
WHERE employee_id = 101;
```

Then run DELETE.

---

# Frequently Asked Interview Questions

## What is DML?

DML (Data Manipulation Language) is used to insert, update, and delete data stored in database tables.

---

## Name DML Commands.

- INSERT
- UPDATE
- DELETE

---

## What is the Difference Between DML and DDL?

DML works on data.

DDL works on database structure.

---

## What is the Difference Between INSERT and UPDATE?

INSERT adds new records.

UPDATE modifies existing records.

---

## What Happens If WHERE Clause Is Omitted In UPDATE?

All rows are updated.

---

## What Happens If WHERE Clause Is Omitted In DELETE?

All rows are deleted.

---

## What is INSERT INTO SELECT?

It copies data from one table to another table.

---

## Difference Between DELETE and TRUNCATE?

DELETE removes selected rows and supports WHERE.

TRUNCATE removes all rows and does not support WHERE.

---

## Can DELETE Be Rolled Back?

In most DBMS systems, yes, if the transaction has not been committed.

---

# Summary

DML (Data Manipulation Language) is used to manage the data stored inside database tables.

The primary DML commands are:

- INSERT → Add records
- UPDATE → Modify records
- DELETE → Remove records

These commands are used daily in real-world applications and are among the most frequently asked SQL interview topics.

# Important Points

## INSERT IGNORE (MySQL)

The `INSERT IGNORE` statement is used to skip rows that cause errors instead of stopping the entire query execution.

### Syntax

```sql
INSERT IGNORE INTO employees
VALUES(101,'John',50000);
```

### Why Use It?

Suppose a record with the same Primary Key already exists.

```sql
INSERT INTO employees
VALUES(101,'John',50000);
```

Output:

```text
ERROR: Duplicate Entry
```

Using `INSERT IGNORE` prevents the error and skips the problematic row.

### Use Cases

- Bulk data loading
- Data migration
- Importing CSV files
- Handling duplicate records

---

## REPLACE Statement (MySQL)

The `REPLACE` statement works like a combination of:

```text
DELETE + INSERT
```

### Syntax

```sql
REPLACE INTO table_name
VALUES(value1, value2, value3);
```

### Example

```sql
REPLACE INTO employees
VALUES(101,'John',60000);
```

### What Happens?

If employee_id = 101 already exists:

1. Existing row is deleted.
2. New row is inserted.

### Use Cases

- Replacing outdated records
- Data synchronization
- Refreshing data

### Important Note

REPLACE does not perform an UPDATE.

It deletes the existing row and inserts a completely new row.

---

## UPDATE with ORDER BY and LIMIT

MySQL allows UPDATE with ORDER BY and LIMIT.

### Example

```sql
UPDATE employees
SET salary = salary * 1.10
ORDER BY salary DESC
LIMIT 5;
```

### What Happens?

Only the top 5 employees with the highest salary are updated.

### Use Cases

- Incremental updates
- Controlled modifications
- Testing updates safely

---

## DELETE with LIMIT

MySQL allows deleting a limited number of rows.

### Example

```sql
DELETE FROM employees
LIMIT 10;
```

### What Happens?

Only 10 rows are deleted.

### Use Cases

- Batch deletion
- Removing records gradually
- Large table maintenance

---

## DELETE vs TRUNCATE vs DROP

| Feature | DELETE | TRUNCATE | DROP |
|----------|----------|----------|----------|
| Category | DML | DDL | DDL |
| Deletes Data | Yes | Yes | Yes |
| Deletes Structure | No | No | Yes |
| WHERE Clause Allowed | Yes | No | No |
| Specific Rows | Yes | No | No |
| Table Exists After Execution | Yes | Yes | No |
| Rollback Support | Usually Yes | Depends on DBMS | No |
| Faster | No | Yes | Fastest |

### Interview Tip

This is one of the most frequently asked SQL interview questions.

---

## Transaction Awareness

Before executing large UPDATE or DELETE statements, always verify the affected records.

### Recommended Approach

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

Then execute:

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
```

### Why?

This helps prevent accidental updates or deletions.

---

## SQL Execution Flow for UPDATE

Example:

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
```

### Execution Order

```text
1. Identify table
2. Apply WHERE condition
3. Find matching rows
4. Update matching rows
5. Commit changes
```

---

## SQL Execution Flow for DELETE

Example:

```sql
DELETE FROM employees
WHERE salary < 30000;
```

### Execution Order

```text
1. Identify table
2. Apply WHERE condition
3. Find matching rows
4. Delete matching rows
5. Commit changes
```

---

## Data Integrity Best Practices

Before performing INSERT operations:

- Verify datatypes
- Verify NOT NULL columns
- Verify Primary Key uniqueness
- Verify Foreign Key references
- Validate incoming data

### Example

```sql
INSERT INTO orders
VALUES(101,999);
```

If customer 999 does not exist:

```text
Foreign Key Constraint Error
```

---

## Production Safety Rules

### Never Run UPDATE Without Verification

Dangerous:

```sql
UPDATE employees
SET salary = 100000;
```

Safer Approach:

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

Then:

```sql
UPDATE employees
SET salary = 100000
WHERE department = 'IT';
```

---

### Never Run DELETE Without Verification

Dangerous:

```sql
DELETE FROM employees;
```

Safer Approach:

```sql
SELECT *
FROM employees
WHERE employee_id = 101;
```

Then:

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

---

## Quick Revision

| Command | Purpose |
|----------|----------|
| INSERT | Add new rows |
| UPDATE | Modify existing rows |
| DELETE | Remove rows |
| INSERT INTO SELECT | Copy data from one table to another |
| INSERT IGNORE | Skip duplicate errors |
| REPLACE | Replace existing rows |
| DELETE LIMIT | Delete limited rows |
| UPDATE LIMIT | Update limited rows |

---

## Key Takeaways

- INSERT adds new records.
- UPDATE modifies existing records.
- DELETE removes records.
- Always use WHERE when performing UPDATE or DELETE operations.
- Verify affected records before making changes.
- Use transactions whenever possible for safer data manipulation.
- Understand DELETE, TRUNCATE, and DROP thoroughly for interviews.
- Follow data integrity rules to avoid constraint violations.
