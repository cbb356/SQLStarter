--Завдання 1
--Зайдіть до бази даних “MyJoinsDB”, створеного користувачем у попередньому уроці. 
--Проаналізуйте, які типи індексів задані на таблицях, створених у попередньому домашньому завданні.

USE MyJoinsDB
GO

SELECT * FROM sys.indexes
WHERE object_id = (SELECT object_id FROM sys.tables
				   WHERE name = 'Employees');
GO

SELECT * FROM sys.indexes
WHERE object_id = (SELECT object_id FROM sys.tables
				   WHERE name = 'Positions');
GO

SELECT * FROM sys.indexes
WHERE object_id = (SELECT object_id FROM sys.tables
				   WHERE name = 'EmployeeInfo');
GO

--Завдання 2
--Вкажіть свої індекси на таблицях, створених у попередньому домашньому завданні 
--та обґрунтуйте їх необхідність.

/* 
На таблиці Employees автоматично створений кластеризований індекс PK__Employee__7AD04F11A3CBEDAA 
для поля EmployeeId при вказуванні його як PRIMARY KEY.

На таблиці Positions автоматично створений кластеризований індекс PK__Position__60BB9A798722C565 
для поля PositionId при вказуванні його як PRIMARY KEY. Також створений некластеризований індекс 
UQ__Position__7AD04F10BDC1A029 для поля EmployeeId при вказуванні його як FOREIGN KEY 
з унікальними значеннями для з'єднання з таблицею Employees.

На таблиці EmployeeInfo автоматично створений кластеризований індекс PK__Employee__3214EC07055B57AF 
для поля Id при вказуванні його як PRIMARY KEY. Також створений некластеризований індекс 
UQ__Employee__7AD04F107E32DC85 для поля EmployeeId при вказуванні його як FOREIGN KEY 
з унікальними значеннями для з'єднання з таблицею Employees.

Наявні індекси дозволяють впорядкувати таблиці в БД, а також пришвидшити пошук по полях, на яких присутні 
кластеризовані, та некластеризовані індекси
*/

SELECT * FROM Employees
SELECT * FROM Positions
SELECT * FROM EmployeeInfo
GO

--Завдання 3
--Створіть уявлення для таких завдань:

--Необхідно дізнатися контактні дані співробітників (номери телефонів, місце проживання).

CREATE VIEW ContactData
AS SELECT e.[Name], e.Phone, ei.Address
FROM Employees AS e
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId;
GO

SELECT * FROM ContactData;
GO
--Необхідно дізнатися інформацію про дату народження всіх неодружених співробітників 
--та номери телефонів цих працівників.

CREATE VIEW BirthDayNonMarried
AS SELECT e.[Name], ei.BirthDay, e.Phone
FROM Employees AS e
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId
WHERE ei.MaritalStatus <> 'Married';
GO

SELECT * FROM BirthDayNonMarried;
GO

--Необхідно дізнатися інформацію про дату народження всіх співробітників з посадою менеджера 
--та номери телефонів цих співробітників.

CREATE VIEW BirthDayManagers
AS SELECT e.[Name], ei.BirthDay, e.Phone
FROM Employees AS e
JOIN Positions AS p
ON e.EmployeeId = p.EmployeeId
JOIN EmployeeInfo AS ei
ON e.EmployeeId = ei.EmployeeId
WHERE p.Position = 'Manager';
GO

SELECT * FROM BirthDayManagers;
GO

--Завдання 4
--Створити базу даних з ім'ям MyFunkDB.

CREATE DATABASE MyFunkDB
ON
(
	NAME = 'MyFunkDB',
	FILENAME = 'D:\MyFunkDB.mdf', 			
	SIZE = 1MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)
LOG ON
(
	NAME = 'LogMyFunkDB',
	FILENAME = 'D:\MyFunkDB.ldf',
	SIZE = 1MB,
	MAXSIZE = 5MB,
	FILEGROWTH = 1MB
)
COLLATE Cyrillic_General_CI_AS

--Завдання 5
--У цій базі даних створити 3 таблиці,
--У 1-ій містяться імена та номери телефонів співробітників якоїсь компанії
--У 2-й відомості про їхню зарплату, та посади: головний директор, менеджер, робітник.
--У 3-му сімейному становищі, дати народження, де вони проживають.

USE MyFunkDB
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
GO

--Завдання 6
--Створіть функції/процедури для таких завдань:
--Потрібно дізнатися про контактні дані співробітників (номери телефонів, місце проживання).

CREATE FUNCTION ContactDataAll()
RETURNS TABLE
AS
RETURN 
(
	SELECT e.[Name], e.Phone, ei.Address
	FROM Employees AS e
	JOIN EmployeeInfo AS ei
	ON e.EmployeeId = ei.EmployeeId
);
GO

SELECT * FROM dbo.ContactDataAll();
GO

--Потрібно дізнатися інформацію про дату народження всіх неодружених співробітників 
--та номери телефонів цих працівників.

CREATE PROC BirthDayNonMarried
AS 
	SELECT e.[Name], ei.BirthDay, e.Phone
	FROM Employees AS e
	JOIN EmployeeInfo AS ei
	ON e.EmployeeId = ei.EmployeeId
	WHERE ei.MaritalStatus <> 'Married';
GO

EXEC BirthDayNonMarried;
GO

CREATE PROC BirthDayMartialStatusExcluded
	@MartialStatus NVARCHAR(20) 
AS 
	SELECT e.[Name], ei.BirthDay, e.Phone
	FROM Employees AS e
	JOIN EmployeeInfo AS ei
	ON e.EmployeeId = ei.EmployeeId
	WHERE ei.MaritalStatus <> @MartialStatus;
GO

EXEC BirthDayMartialStatusExcluded 'Married';
GO
--Потрібно дізнатися інформацію про дату народження всіх співробітників з посадою менеджера 
--та номери телефонів цих співробітників.

CREATE PROC BirthDayManagers
AS 
BEGIN
	SELECT e.[Name], ei.BirthDay, e.Phone
	FROM Employees AS e
	JOIN Positions AS p
	ON e.EmployeeId = p.EmployeeId
	JOIN EmployeeInfo AS ei
	ON e.EmployeeId = ei.EmployeeId
	WHERE p.Position = 'Manager';
END
GO

EXEC BirthDayManagers;
GO

CREATE FUNCTION BirthDayByPosition(@Position NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT e.[Name], ei.BirthDay, e.Phone
	FROM Employees AS e
	JOIN Positions AS p
	ON e.EmployeeId = p.EmployeeId
	JOIN EmployeeInfo AS ei
	ON e.EmployeeId = ei.EmployeeId
	WHERE p.Position = @Position
);
GO

SELECT * FROM BirthDayByPosition('Manager');
GO