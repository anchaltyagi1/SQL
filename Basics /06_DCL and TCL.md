# DCL and TCL Commands

## Introduction

SQL commands are divided into different categories based on their purpose.

So far, we have covered:

- DDL (Data Definition Language)
- DML (Data Manipulation Language)

The next categories are:

- DCL (Data Control Language)
- TCL (Transaction Control Language)

These commands help manage database security and transactions.

---

# DCL (Data Control Language)

## What is DCL?

DCL stands for **Data Control Language**.

DCL commands are used to control access and permissions on database objects.

They help database administrators decide:

- Who can access data
- What operations users can perform
- Which tables users can access

---

## Why Do We Need DCL?

In real-world applications:

- Not every user should have full access.
- Sensitive data must be protected.
- Different users require different permissions.

Example:

| User | Permission |
|--------|--------|
| HR Manager | Employee Data |
| Sales Manager | Sales Data |
| Developer | Read Only |
| DBA | Full Access |

---

# DCL Commands

The main DCL commands are:

1. GRANT
2. REVOKE

---

# 1. GRANT Command

## What is GRANT?

The GRANT command is used to provide permissions to users.

### Syntax

```sql
GRANT permission
ON object_name
TO user_name;
```

---

## Grant SELECT Permission

### Example

```sql
GRANT SELECT
ON employees
TO john;
```

### What Happens?

User `john` can now read data from the employees table.

---

## Grant Multiple Permissions

### Example

```sql
GRANT SELECT, INSERT, UPDATE
ON employees
TO john;
```

### Permissions Granted

- Read data
- Insert data
- Update data

---

## Grant All Privileges

### Example

```sql
GRANT ALL PRIVILEGES
ON employees
TO john;
```

### What Happens?

User receives all permissions on the table.

---

## Common Privileges

| Privilege | Description |
|------------|------------|
| SELECT | Read data |
| INSERT | Add data |
| UPDATE | Modify data |
| DELETE | Remove data |
| ALL PRIVILEGES | Full access |

---

# 2. REVOKE Command

## What is REVOKE?

The REVOKE command removes previously granted permissions.

### Syntax

```sql
REVOKE permission
ON object_name
FROM user_name;
```

---

## Revoke SELECT Permission

### Example

```sql
REVOKE SELECT
ON employees
FROM john;
```

### What Happens?

User can no longer view data from the employees table.

---

## Revoke Multiple Permissions

### Example

```sql
REVOKE INSERT, UPDATE
ON employees
FROM john;
```

---

## Why Use REVOKE?

- Security management
- Removing unnecessary access
- Following least privilege principle

---

# DCL Best Practices

## Principle of Least Privilege

Give users only the permissions they actually need.

### Good

```sql
GRANT SELECT
ON employees
TO analyst;
```

### Bad

```sql
GRANT ALL PRIVILEGES
ON employees
TO analyst;
```

---

## Regular Permission Reviews

Review user access periodically.

Remove permissions that are no longer required.

---

# TCL (Transaction Control Language)

## What is TCL?

TCL stands for **Transaction Control Language**.

TCL commands manage transactions in a database.

A transaction is a group of SQL statements executed as a single unit of work.

---

## What is a Transaction?

Example:

Transfer ₹1000 from Account A to Account B.

### Step 1

```sql
UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;
```

### Step 2

```sql
UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;
```

Both statements must succeed.

If one fails, neither change should be saved.

This is called a transaction.

---

# TCL Commands

The main TCL commands are:

1. COMMIT
2. ROLLBACK
3. SAVEPOINT

---

# 1. COMMIT

## What is COMMIT?

COMMIT permanently saves changes made during a transaction.

### Syntax

```sql
COMMIT;
```

### Example

```sql
UPDATE employees
SET salary = 70000
WHERE employee_id = 101;

COMMIT;
```

### What Happens?

Changes become permanent.

---

# 2. ROLLBACK

## What is ROLLBACK?

ROLLBACK cancels changes made during a transaction.

### Syntax

```sql
ROLLBACK;
```

### Example

```sql
UPDATE employees
SET salary = 70000
WHERE employee_id = 101;

ROLLBACK;
```

### What Happens?

Salary returns to its original value.

---

# 3. SAVEPOINT

## What is SAVEPOINT?

SAVEPOINT creates a checkpoint inside a transaction.

### Syntax

```sql
SAVEPOINT savepoint_name;
```

---

## Example

```sql
UPDATE employees
SET salary = 60000
WHERE employee_id = 101;

SAVEPOINT sp1;

UPDATE employees
SET salary = 70000
WHERE employee_id = 102;
```

---

## Rollback to Savepoint

```sql
ROLLBACK TO sp1;
```

### What Happens?

Changes after `sp1` are removed.

Changes before `sp1` remain.

---

# Transaction Flow

```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE employee_id = 101;

SAVEPOINT sp1;

UPDATE employees
SET salary = 70000
WHERE employee_id = 102;

COMMIT;
```

---

# ACID Properties

Transactions follow ACID properties.

## A – Atomicity

Either all operations succeed or none succeed.

---

## C – Consistency

Database remains valid before and after transaction.

---

## I – Isolation

Transactions do not interfere with each other.

---

## D – Durability

Committed changes remain permanently saved.

---

# COMMIT vs ROLLBACK

| COMMIT | ROLLBACK |
|----------|----------|
| Saves changes | Cancels changes |
| Permanent | Reverts changes |
| Cannot undo after commit | Can undo before commit |

---

# SAVEPOINT vs ROLLBACK

| SAVEPOINT | ROLLBACK |
|------------|------------|
| Creates checkpoint | Reverts transaction |
| Partial rollback possible | Complete rollback |
| Used within transaction | Used to undo changes |

---

# Common Mistakes

## Forgetting COMMIT

```sql
UPDATE employees
SET salary = 60000
WHERE employee_id = 101;
```

Changes may not be permanently saved.

---

## Committing Too Early

```sql
COMMIT;
```

After COMMIT, ROLLBACK cannot undo changes.

---

## Not Using SAVEPOINT

Large transactions become difficult to manage.

SAVEPOINT allows partial rollback.

---

# Frequently Asked Interview Questions

## What is DCL?

DCL (Data Control Language) manages permissions and access control.

---

## Name DCL Commands.

- GRANT
- REVOKE

---

## What is TCL?

TCL (Transaction Control Language) manages database transactions.

---

## Name TCL Commands.

- COMMIT
- ROLLBACK
- SAVEPOINT

---

## What is a Transaction?

A transaction is a group of SQL statements executed as a single unit of work.

---

## What is COMMIT?

COMMIT permanently saves changes.

---

## What is ROLLBACK?

ROLLBACK undoes uncommitted changes.

---

## What is SAVEPOINT?

SAVEPOINT creates a checkpoint inside a transaction.

---

## What are ACID Properties?

- Atomicity
- Consistency
- Isolation
- Durability

---

# Summary

- DCL controls database permissions.
- GRANT provides access.
- REVOKE removes access.
- TCL manages transactions.
- COMMIT saves changes.
- ROLLBACK undoes changes.
- SAVEPOINT allows partial rollback.
- Transactions follow ACID properties.
