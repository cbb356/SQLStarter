--	Завдання 1
--	Створіть БД з ім'ям HomeWork, 
--	у якій створіть таблицю Product з колонками: 
--	ProductId, Name, ProductNumber, Cost, Count, SellStartDate.

--	У таблицю Product запишіть 10 записів про товари:
--	Name               ProductNum    Cost     Count   SellStartDate
--	Корона             AK-53818         5$        50        08/15/2011
--	Мілка              AM-51122         6.1$      50        07/15/2011
--	Оленка             AA-52211         2.5$      20        06/15/2011
--	Snickers           BS-32118         2.8$      50        08/15/2011
--	Snickers           BSL-3818         5$        100       08/20/2011
--	Bounty              BB-38218         3$        100       08/01/2011
--	Nuts                 BN-37818         3$        100       08/21/2011
--	Mars                 BM-3618           2.5$      50        08/24/2011
--	Світоч             AS-54181         5$        100       08/12/2011
--	Світоч             AS-54182         5$        100       08/12/2011


CREATE DATABASE HomeWork
ON
(
	NAME = 'HomeWork',
	FILENAME = 'D:\HomeWork.mdf', 			
	SIZE = 10MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 10MB
)
LOG ON
(
	NAME = 'LogHomeWork',
	FILENAME = 'D:\HomeWork.ldf',
	SIZE = 5MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
COLLATE Cyrillic_General_CI_AS

USE HomeWork
GO

CREATE TABLE Product
(
	ProductId smallint IDENTITY NOT NULL,
	[Name] varchar(50) NOT NULL,
	ProductNumber varchar(10) NULL,
	Cost money NULL,
	[Count] integer NULL,
	SellStartDate date NULL
)
GO

INSERT INTO Product
([Name], ProductNumber, Cost, [Count], SellStartDate)
VALUES
('Корона', 'AK-53818', '$5', 50, '08/15/2011'),
('Мілка', 'AM-51122', '$6.1', 50, '07/15/2011'),
('Оленка', 'AA-52211', '$2.5', 20, '06/15/2011'),
('Snickers', 'BS-32118', '$2.8', 50, '08/15/2011'),
('Snickers', 'BSL-3818', '$5', 100, '08/20/2011'),
('Bounty', 'BB-38218', '$3', 100, '08/01/2011'),
('Nuts', 'BN-37818', '$3', 100, '08/21/2011'),
('Mars', 'BM-3618', '$2.5', 50, '08/24/2011'),
('Світоч', 'AS-54181', '$5', 100, '08/12/2011'),
('Світоч', 'AS-54182', '$5', 100, '08/12/2011');
GO

--	Завдання 2
--	Зробіть вибірку для продукції, кількість якої більше 59 шт.
--	Зробіть вибірку для продукції, ціна якої більше 3$ та надійшли на продаж з 20/08/2011.


SELECT *
FROM Product
WHERE [Count] > 59;
GO

SELECT *
FROM Product
WHERE Cost > 3 AND SellStartDate >= '08/20/2011';
GO

-- Завдання 3
-- Шоколад Світоч подорожчав на 25 центів, змініть запис.

UPDATE Product
SET Cost = '$5.25'
WHERE [Name] = 'Світоч';
GO

SELECT *
FROM Product