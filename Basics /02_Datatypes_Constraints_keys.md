# Data Types, Constraints and Keys in SQL

Before creating a table, it is important to understand Data Types, Constraints, and Keys because they define how data is stored, validated, and related within a database.

---

# 1. Data Types

A Data Type specifies the type of value that can be stored in a column.

Think of a data type as a rule that determines what kind of data is allowed.

Example:

```sql
CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2)
);
```

Here:

* emp_id stores integers.
* emp_name stores text.
* salary stores decimal values.

---

## Why Data Types are Important?

1. Ensure data accuracy.
2. Save storage space.
3. Improve query performance.
4. Prevent invalid data entry.

---

# Types of Data Types

## A. Numeric Data Types

Used to store numbers.

### INT

Stores whole numbers.

```sql
emp_id INT
```

Examples:

```text
101
250
5000
```

---

### BIGINT

Stores very large integers.

```sql
population BIGINT
```

Example:

```text
9876543210
```

---

### SMALLINT

Stores smaller integer values.

```sql
age SMALLINT
```

---

### DECIMAL(p,s)

Stores exact decimal values.

p = Precision (total digits)

s = Scale (digits after decimal)

```sql
salary DECIMAL(10,2)
```

Example:

```text
50000.75
1200.50
```

---

### FLOAT

Stores approximate decimal values.

```sql
price FLOAT
```

Used when slight precision loss is acceptable.

---

# B. Character/String Data Types

Used to store text.

---

### CHAR(n)

Fixed-length string.

```sql
gender CHAR(1)
```

Example:

```text
M
F
```

If CHAR(10) stores "John", remaining space is padded.

---

### VARCHAR(n)

Variable-length string.

```sql
name VARCHAR(50)
```

Example:

```text
John
Anchal Tyagi
```

Most commonly used string data type.

---

### TEXT

Used for large text data.

```sql
comments TEXT
```

Example:

```text
Customer feedback
Product reviews
Descriptions
```

---

# C. Date and Time Data Types

---

### DATE

Stores only date.

```sql
dob DATE
```

Example:

```text
2025-06-12
```

---

### TIME

Stores only time.

```sql
login_time TIME
```

Example:

```text
15:30:45
```

---

### DATETIME

Stores date and time.

```sql
created_at DATETIME
```

Example:

```text
2025-06-12 15:30:45
```

---

### TIMESTAMP

Stores date and time and updates automatically.

Used for audit columns.

```sql
created_at TIMESTAMP
```

---

# D. Boolean Data Type

Stores TRUE or FALSE values.

```sql
is_active BOOLEAN
```

Example:

```text
TRUE
FALSE
```

In MySQL:

```text
TRUE = 1
FALSE = 0
```

---

# 2. Constraints

Constraints are rules applied to columns to maintain data integrity and accuracy.

Without constraints, users can insert invalid data.

---

## Why Constraints?

Constraints help:

* Maintain data quality
* Avoid duplicate records
* Prevent invalid entries
* Maintain relationships

---

# Types of Constraints

## NOT NULL

Prevents NULL values.

```sql
CREATE TABLE employees(
    emp_id INT,
    emp_name VARCHAR(50) NOT NULL
);
```

Valid:

```text
John
```

Invalid:

```text
NULL
```

---

## UNIQUE

Prevents duplicate values.

```sql
email VARCHAR(100) UNIQUE
```

Valid:

```text
abc@gmail.com
xyz@gmail.com
```

Invalid:

```text
abc@gmail.com
abc@gmail.com
```

---

## PRIMARY KEY

Uniquely identifies each record.

Properties:

* Unique
* Not Null
* One Primary Key per table

```sql
emp_id INT PRIMARY KEY
```

Example:

| Emp_ID | Name  |
| ------ | ----- |
| 1      | John  |
| 2      | Sarah |

Invalid:

| Emp_ID | Name  |
| ------ | ----- |
| 1      | John  |
| 1      | Sarah |

---

## FOREIGN KEY

Creates relationships between tables.

Example:

Department Table

| Dept_ID | Department |
| ------- | ---------- |
| 1       | IT         |
| 2       | HR         |

Employee Table

| Emp_ID | Name | Dept_ID |
| ------ | ---- | ------- |
| 101    | John | 1       |

```sql
FOREIGN KEY (dept_id)
REFERENCES departments(dept_id)
```

---

## CHECK

Validates values based on conditions.

```sql
age INT CHECK(age >= 18)
```

Valid:

```text
20
25
30
```

Invalid:

```text
15
```

---

## DEFAULT

Assigns default values.

```sql
status VARCHAR(20)
DEFAULT 'Active'
```

If no value is inserted:

```text
Active
```

is stored automatically.

---

## AUTO_INCREMENT

Automatically generates numbers.

```sql
emp_id INT AUTO_INCREMENT
```

Inserted values:

```text
1
2
3
4
5
```

No need to provide IDs manually.

---

# 3. Keys

Keys help uniquely identify records and establish relationships between tables.

Keys are one of the most important SQL interview topics.

---

# Why Do We Need Keys?

Keys help:

* Identify records uniquely
* Prevent duplicates
* Create relationships
* Improve data integrity

---

# Types of Keys

## Super Key

A column or combination of columns that uniquely identifies rows.

Example:

| Emp_ID | Email                                   |
| ------ | --------------------------------------- |
| 101    | [john@gmail.com](mailto:john@gmail.com) |

Possible Super Keys:

```text
Emp_ID
Email
Emp_ID + Email
```

---

## Candidate Key

A minimal Super Key.

Example:

```text
Emp_ID
Email
```

Both uniquely identify records.

Both are Candidate Keys.

---

## Primary Key

A Candidate Key selected to uniquely identify records.

Example:

```sql
emp_id INT PRIMARY KEY
```

Characteristics:

* Unique
* Not Null
* One per table

---

## Alternate Key

Candidate Keys not selected as Primary Key.

Example:

```text
Primary Key = Emp_ID

Alternate Key = Email
```

---

## Composite Key

Primary Key consisting of multiple columns.

Example:

```sql
PRIMARY KEY(emp_id, project_id)
```

Used when one column alone cannot uniquely identify records.

---

## Foreign Key

Creates relationship between tables.

Example:

```sql
FOREIGN KEY(dept_id)
REFERENCES departments(dept_id)
```

Maintains Referential Integrity.

---

## Unique Key

Ensures uniqueness but allows NULL values.

```sql
email VARCHAR(100) UNIQUE
```

Difference:

| Feature         | Primary Key | Unique Key |
| --------------- | ----------- | ---------- |
| Unique          | Yes         | Yes        |
| NULL Allowed    | No          | Yes        |
| Count per Table | One         | Multiple   |

---

# Primary Key vs Foreign Key

| Primary Key              | Foreign Key          |
| ------------------------ | -------------------- |
| Uniquely identifies rows | Creates relationship |
| Must be unique           | Can have duplicates  |
| Cannot be NULL           | Can be NULL          |
| One per table            | Multiple allowed     |

---

# Interview Questions

### What is the difference between CHAR and VARCHAR?

CHAR:

* Fixed length
* Faster
* Wastes storage

VARCHAR:

* Variable length
* Saves storage
* Most commonly used

---

### What is the difference between PRIMARY KEY and UNIQUE KEY?

Primary Key:

* Unique
* Not Null

Unique Key:

* Unique
* Can contain NULL

---

### Can a table have multiple Primary Keys?

No.

A table can have only one Primary Key.

---

### Can a table have multiple Foreign Keys?

Yes.

---

### Can a Foreign Key contain NULL values?

Yes.

---

### Which data type is used for salary?

```sql
DECIMAL(10,2)
```

because salary requires exact precision.

---

# Key Takeaways

* Data Types define what kind of data can be stored.
* Constraints enforce business rules and data integrity.
* Keys uniquely identify records and create relationships.
* Primary Key and Foreign Key are the foundation of relational databases.
* Data Types, Constraints, and Keys are among the most frequently asked SQL interview topics.
