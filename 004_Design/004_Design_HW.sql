--Завдання 2
--Створити базу даних максимальною розмірністю 100 МБ, передбачається, 
--що буде використовуватися близько 30 МБ. Введіть усі необхідні налаштування. 
--Журнал транзакцій має бути розташований на іншому фізичному диску (якщо є). 


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

--Завдання 3
--Нормалізуйте дану таблицю:
--ПІБ						Взвод	Зброя	Зброю видав
--Петров В.А.,оф.205		222		АК-47	Буров О.С., майор
--Петров В.А.,оф.205		222		Глок20	Рыбаков Н.Г., майор
--Лодарів П.С.,оф.221		232		АК-74	Деребанов В.Я., підполковник
--Лодарів П.С.,оф.221		232		Глок20	Рибаков Н.Г., майор
--Леонт'єв К.В., оф.201		212		АК-47	Буров О.С., майор
--Леонт'єв К.В., оф.201		212		Глок20	Рибаков Н.Г., майор
--Духів Р.М.				200		АК-47	Буров О.С., майор

CREATE DATABASE ArmoryDB
ON
(
	NAME = 'ArmoryDB',
	FILENAME = 'D:\ArmoryDB.mdf', 			
	SIZE = 1MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)
LOG ON
(
	NAME = 'LogArmoryDB',
	FILENAME = 'D:\ArmoryDB.ldf',
	SIZE = 1MB,
	MAXSIZE = 5MB,
	FILEGROWTH = 1MB
)
COLLATE Cyrillic_General_CI_AS

USE ArmoryDB
GO

CREATE TABLE Soldiers
(
	SoldierId INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL, 
	[Of] NVARCHAR(10),
	Platoon INT NOT NULL
);
GO

CREATE TABLE Weapons
(
	WeaponId INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(20) NOT NULL
);
GO

CREATE TABLE WeaponProviders
(
	ProviderId INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL, 
	[Rank] NVARCHAR(20) NOT NULL
);
GO

CREATE TABLE WeaponDistribution
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Soldier INT FOREIGN KEY REFERENCES Soldiers(SoldierId) NOT NULL, 
	Weapon INT FOREIGN KEY REFERENCES Weapons(WeaponId) NOT NULL,
	[Provider] INT FOREIGN KEY REFERENCES WeaponProviders(ProviderId) NOT NULL
);
GO

INSERT INTO Soldiers
([Name], [Of], Platoon)
VALUES
('Петров В.А.', '205', 222),
('Лодарів П.С.', '221', 232),
('Леонт''єв К.В.', '201', 212),
('Духів Р.М.', NULL, 200)
GO

INSERT INTO Weapons
VALUES
('АК-47'),
('Глок20'),
('АК-74')
GO

INSERT INTO WeaponProviders
([Name], [Rank])
VALUES
('Буров О.С.', 'майор'),
('Рибаков Н.Г.', 'майор'),
('Деребанов В.Я.', 'підполковник')
GO

INSERT INTO WeaponDistribution
(Soldier, Weapon, [Provider])
VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 3),
(2, 2, 2),
(3, 1, 1),
(3, 2, 2),
(4, 1, 1)
GO

SELECT * FROM Soldiers
SELECT * FROM Weapons
SELECT * FROM WeaponProviders
SELECT * FROM WeaponDistribution