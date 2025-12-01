--Завдання 1
--Створіть базу даних з ім'ям MyJoinsDB. 


CREATE DATABASE MyJoinsDB
ON
(
	NAME = 'MyJoinsDB',
	FILENAME = 'D:\MyJoinsDB.mdf', 			
	SIZE = 1MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)
LOG ON
(
	NAME = 'LogMyJoinsDB',
	FILENAME = 'D:\MyJoinsDB.ldf',
	SIZE = 1MB,
	MAXSIZE = 5MB,
	FILEGROWTH = 1MB
)
COLLATE Cyrillic_General_CI_AS

--Завдання 2
--У цій базі даних створіть 3 таблиці,
--У 1-й таблиці містяться імена та номери телефонів співробітників компанії.
--У 2-й таблиці містяться відомості про зарплату та посади співробітників: 
--головний директор, менеджер, робітник.
--У 3-й таблиці міститься інформація про сімейний стан, дату народження, та місце проживання.

USE MyJoinsDB
GO

CREATE TABLE Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL, 
	Phone NVARCHAR(15) NOT NULL
);
GO

CREATE TABLE Positions
(
	PositionId INT PRIMARY KEY IDENTITY NOT NULL,
	Position NVARCHAR(50) NOT NULL,
	Salary MONEY NOT NULL,
	EmployeeId INT UNIQUE FOREIGN KEY REFERENCES Employees(EmployeeId) NOT NULL
);
GO

CREATE TABLE EmployeeInfo
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	MaritalStatus NVARCHAR(20) NOT NULL,
	BirthDay DATE NOT NULL,
	Address VARCHAR(50) NOT NULL,
	EmployeeId INT UNIQUE FOREIGN KEY REFERENCES Employees(EmployeeId) NOT NULL

);
GO

INSERT INTO Employees
([Name], Phone)
VALUES
('John Doe', '1234567890'),
('Mary Shelly', '1234567891'),
('Michael Johnson', '1234567892')
GO

INSERT INTO Positions
(Position, Salary, EmployeeId)
VALUES
('Director', '$10000', 1),
('Manager', '$5000', 2),
('Worker', '$2000', 3)
GO

INSERT INTO EmployeeInfo
(MaritalStatus, BirthDay, Address, EmployeeId)
VALUES
('Married', '1990-05-12', 'New York, 100 Business St', 1),
('Divorced', '1999-08-26', 'Los Angeles, 789 Supply Rd', 2),
('Single', '2002-03-15', 'Chicago, 45 North Ave', 3)
GO

SELECT * FROM Employees
SELECT * FROM Positions
SELECT * FROM EmployeeInfo

--Завдання 3
--Зробіть вибірку за допомогою JOIN's для таких завдань:
--1) Отримайте контактні дані співробітників (номери телефонів, місце проживання).

SELECT e.[Name], e.Phone, ei.Address
FROM Employees AS e
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId;
GO

--2) Отримайте інформацію про дату народження всіх неодружених співробітників та їх номери.

SELECT e.[Name], ei.BirthDay, e.Phone
FROM Employees AS e
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId
WHERE ei.MaritalStatus <> 'Married';
GO

--3) Отримайте інформацію про всіх менеджерів компанії: дату народження та номер телефону.

SELECT e.[Name], ei.BirthDay, e.Phone
FROM Employees AS e
JOIN Positions AS p
ON e.EmployeeId = p.EmployeeId
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId
WHERE p.Position = 'Manager';
GO