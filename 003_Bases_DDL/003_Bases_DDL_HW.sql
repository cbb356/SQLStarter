--Завдання 1
--Створіть базу даних максимальною розмірністю 100 МБ, передбачається, 
--що буде використовуватися близько 30 МБ. Введіть усі необхідні налаштування. 
--Журнал транзакцій має бути розташований на іншому фізичному диску (якщо такий є).

CREATE DATABASE MyDB
ON
(
	NAME = 'MyDB',
	FILENAME = 'D:\MyDB.mdf', 			
	SIZE = 30MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 10MB
)
LOG ON
(
	NAME = 'LogMyDB',
	FILENAME = 'E:\MyDB.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 10MB
)
COLLATE Cyrillic_General_CI_AS

--Завдання 2
--Спроектуйте базу даних для оптового складу, 
--який має постачальники товарів, персонал, постійні замовники. Поля таблиць продумати самостійно.

CREATE DATABASE WarehouseDB
ON
(
	NAME = 'WarehouseDB',
	FILENAME = 'D:\WarehouseDB.mdf', 			
	SIZE = 10MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 10MB
)
LOG ON
(
	NAME = 'LogWarehouseDB',
	FILENAME = 'D:\WarehouseDB.ldf',
	SIZE = 5MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
COLLATE Cyrillic_General_CI_AS

USE WarehouseDB
GO

CREATE TABLE Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(25) NOT NULL, 
	LastName NVARCHAR(25) NOT NULL,
	Position NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    BirthDate DATE,
    HireDate DATE NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Suppliers
(
	SupplierId INT PRIMARY KEY IDENTITY NOT NULL,  
	SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
	City NVARCHAR(25),
    [Address] NVARCHAR(100),
	EmployeeId INT FOREIGN KEY REFERENCES Employees(EmployeeId)
);
GO

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
	City NVARCHAR(25),
    [Address] NVARCHAR(100),
	EmployeeId INT FOREIGN KEY REFERENCES Employees(EmployeeId)
);
GO

INSERT INTO Employees
(FirstName, LastName, Position, Phone, Email, BirthDate, HireDate)
VALUES
('John', 'Doe', 'Manager', '+1234567890', 'jdoe@company.com', '1990-08-15', '2019-12-14'),
('Robert', 'Smith', 'IT Specialist', '+15559876543', 'rsmith@company.com', '1992-11-10', '2020-05-15'),
('Mary', 'Shelly', 'Worker', '+2345678901', 'mshelly@company.com', '1998-05-09', '2022-04-12');
GO

INSERT INTO Suppliers
(SupplierName, ContactName, Phone, Email, City, [Address], EmployeeId)
VALUES
('Global Tech Supplies', 'Michael Scott', '+15554445555', 'contact@gts.com', 'New York', '100 Business St', 1),
('Fresh Foods Inc.', 'Linda Paulson', '+15556667777', 'sales@freshfoods.com', 'Chicago', '45 North Ave', 2),
('Office Essentials Co.', 'David Lee', '+15558889999', 'info@officeessentials.net', 'Los Angeles', '789 Supply Rd', 1);
GO

INSERT INTO Customers
(CustomerName, ContactName, Phone, Email, City, [Address], EmployeeId)
VALUES
('Acme Retail Group', 'Sarah Connor', '+15550001111', 'purchasing@acmeretail.com', 'Dallas', '500 Main Blvd', 3),
('Beta Manufacturing', 'Tom Hanks', '+15552223333', 't.hanks@beta.net', 'Houston', '22 Production Way', 2),
('City Hall Services', 'Jane Goodall', '+15554446666', 'jgoodall@cityhall.gov', 'Miami', '345 Civic Center', 3);
GO