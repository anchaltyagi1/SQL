# TRIGGERS IN SQL

## What is a Trigger?

A Trigger is a special type of stored program that automatically executes when a specific event occurs on a table or database.

Triggers are automatically fired when:

- INSERT
- UPDATE
- DELETE
- CREATE
- ALTER
- DROP

operations occur.

---

# Why Use Triggers?

Triggers are used for:

- Audit Logging
- Data Validation
- Business Rules Enforcement
- Tracking Changes
- Automatic Updates
- Security Monitoring

---

# How Trigger Works

```text
User Action
     ↓
INSERT / UPDATE / DELETE
     ↓
Trigger Fires Automatically
     ↓
Action Performed
```

---

# Types of Triggers

## DML Triggers

Triggered by:

- INSERT
- UPDATE
- DELETE

---

## DDL Triggers

Triggered by:

- CREATE
- ALTER
- DROP

---

## Database Triggers

Triggered by database-level events.

---

# AFTER TRIGGER

Runs after the event occurs.

---

## Example

```sql
CREATE TRIGGER trg_after_insert
ON employees
AFTER INSERT
AS
BEGIN
    PRINT 'Employee Added';
END;
```

---

## Insert Data

```sql
INSERT INTO employees
VALUES (101, 'John', 50000);
```

Output:

```text
Employee Added
```

---

# AFTER UPDATE TRIGGER

```sql
CREATE TRIGGER trg_after_update
ON employees
AFTER UPDATE
AS
BEGIN
    PRINT 'Employee Updated';
END;
```

---

# AFTER DELETE TRIGGER

```sql
CREATE TRIGGER trg_after_delete
ON employees
AFTER DELETE
AS
BEGIN
    PRINT 'Employee Deleted';
END;
```

---

# INSTEAD OF TRIGGER

Executes instead of actual action.

---

## Example

```sql
CREATE TRIGGER trg_instead_delete
ON employees
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Deletion Not Allowed';
END;
```

---

## Delete Attempt

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

Output:

```text
Deletion Not Allowed
```

Record remains in table.

---

# BEFORE TRIGGER

Supported in databases like MySQL, PostgreSQL, Oracle.

Runs before operation executes.

---

## Example

```sql
CREATE TRIGGER trg_before_insert
BEFORE INSERT
ON employees
FOR EACH ROW
BEGIN
    SET NEW.salary = IFNULL(NEW.salary,0);
END;
```

---

# INSERT TRIGGER

Automatically executes when data is inserted.

```sql
CREATE TRIGGER trg_insert
ON employees
AFTER INSERT
AS
BEGIN
    PRINT 'New Record Inserted';
END;
```

---

# UPDATE TRIGGER

```sql
CREATE TRIGGER trg_update
ON employees
AFTER UPDATE
AS
BEGIN
    PRINT 'Record Updated';
END;
```

---

# DELETE TRIGGER

```sql
CREATE TRIGGER trg_delete
ON employees
AFTER DELETE
AS
BEGIN
    PRINT 'Record Deleted';
END;
```

---

# AUDIT LOGGING USING TRIGGERS

One of the most common use cases.

---

## Audit Table

```sql
CREATE TABLE employee_audit
(
    employee_id INT,
    action_type VARCHAR(20),
    action_date DATETIME
);
```

---

## Audit Trigger

```sql
CREATE TRIGGER trg_employee_audit
ON employees
AFTER INSERT
AS
BEGIN
    INSERT INTO employee_audit
    (
        employee_id,
        action_type,
        action_date
    )
    SELECT employee_id,
           'INSERT',
           GETDATE()
    FROM inserted;
END;
```

---

# INSERTED AND DELETED TABLES

SQL Server provides special logical tables.

---

## INSERTED

Contains newly inserted rows.

```sql
SELECT *
FROM inserted;
```

---

## DELETED

Contains deleted rows.

```sql
SELECT *
FROM deleted;
```

---

# Track Salary Changes

```sql
CREATE TRIGGER trg_salary_audit
ON employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO salary_audit
    (
        employee_id,
        old_salary,
        new_salary
    )
    SELECT d.employee_id,
           d.salary,
           i.salary
    FROM deleted d
    JOIN inserted i
    ON d.employee_id = i.employee_id;
END;
```

---

# DDL TRIGGERS

Triggered by schema changes.

---

## Example

```sql
CREATE TRIGGER trg_create_table
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    PRINT 'Table Created';
END;
```

---

# Prevent Table Deletion

```sql
CREATE TRIGGER trg_prevent_drop
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    PRINT 'Dropping Tables Not Allowed';
    ROLLBACK;
END;
```

---

# Nested Triggers

Trigger fires another trigger.

```text
Trigger A
     ↓
Trigger B
```

Can create complexity.

Use carefully.

---

# Recursive Triggers

A trigger updates same table causing itself to execute again.

```text
Trigger
 ↓
Update
 ↓
Trigger
 ↓
Update
```

Can cause infinite loops.

---

# Enable Trigger

```sql
ENABLE TRIGGER trg_employee_audit
ON employees;
```

---

# Disable Trigger

```sql
DISABLE TRIGGER trg_employee_audit
ON employees;
```

---

# Drop Trigger

```sql
DROP TRIGGER trg_employee_audit;
```

---

# Trigger vs Stored Procedure

| Trigger | Procedure |
|----------|-----------|
| Automatic | Manual Execution |
| Event Driven | User Driven |
| No EXEC Needed | EXEC Required |
| Fires Automatically | Called Explicitly |

---

# Trigger vs Constraint

| Trigger | Constraint |
|----------|-----------|
| Complex Rules | Simple Validation |
| Flexible | Faster |
| More Logic | Less Logic |

---

# Advantages of Triggers

### Automation

No manual execution needed.

---

### Data Integrity

Enforces business rules.

---

### Auditing

Tracks data changes automatically.

---

### Security

Monitors unauthorized activities.

---

# Disadvantages of Triggers

### Hidden Logic

Harder to debug.

---

### Performance Impact

Runs automatically on every event.

---

### Complexity

Nested triggers can become difficult to manage.

---

# Real World Use Cases

## Audit Logging

```text
Employee Updated
       ↓
Trigger
       ↓
Audit Table
```

---

## Salary Change Tracking

Track old and new salary.

---

## Prevent Deletion

Protect critical records.

---

## Data Validation

Validate values before insert.

---

# Common Interview Questions

## What is a Trigger?

A database object that automatically executes when an event occurs.

---

## Types of Triggers?

- BEFORE
- AFTER
- INSTEAD OF
- DML
- DDL

---

## Difference Between Trigger and Procedure?

Trigger executes automatically.

Procedure executes manually.

---

## What are INSERTED and DELETED Tables?

Special logical tables available inside triggers.

---

## What is an Audit Trigger?

A trigger used to track changes in data.

---

## Can Triggers Affect Performance?

Yes.

Poorly designed triggers can slow down operations.

---

## What is a Recursive Trigger?

A trigger that calls itself repeatedly.

---

## What is a Nested Trigger?

A trigger that causes another trigger to execute.

---

# Advanced Interview Questions

## Why Are Triggers Considered Dangerous?

Because logic is hidden and may impact performance.

---

## When Should Triggers Be Avoided?

When application code or constraints can handle the requirement more clearly.

---

## Can Multiple Triggers Exist on Same Table?

Yes.

Multiple triggers can exist for INSERT, UPDATE, and DELETE.

---

## What Happens If Trigger Fails?

Entire transaction may fail and rollback.

---

# Best Practices

✅ Keep triggers simple

✅ Avoid long-running operations

✅ Use for auditing

✅ Document trigger logic

✅ Test performance impact

✅ Avoid recursive triggers

---

# FINAL CHECKLIST

## Trigger Basics
✅

## DML Triggers
✅

## DDL Triggers
✅

## BEFORE Trigger
✅

## AFTER Trigger
✅

## INSTEAD OF Trigger
✅

## Audit Logging
✅

## Inserted Table
✅

## Deleted Table
✅

## Nested Triggers
✅

## Recursive Triggers
✅

## Enable/Disable Trigger
✅

## Drop Trigger
✅

## Comparisons
✅

## Real-World Use Cases
✅

## Interview Questions
✅

---

# SUMMARY

Triggers automatically execute when database events occur.

Common uses:

- Audit Logging
- Change Tracking
- Data Validation
- Security Monitoring
- Business Rule Enforcement

Triggers are powerful but should be used carefully because they can affect performance and make debugging more difficult.
