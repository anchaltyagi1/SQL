-- Database created
CREATE DATABASE Ecommerce;

-- Switch to Ecommerce database
USE Ecommerce;

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(50),
    Country VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Retrieve all records from the Customers table
SELECT * FROM Customers;

-- Retrieve all records from the Products table
SELECT * FROM Products;
