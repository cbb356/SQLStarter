USE MyDB
GO

CREATE TABLE Employee
(
	Id smallint IDENTITY NOT NULL,
	FirstName Varchar(20) NOT NULL,
	LastName Varchar(20) NULL,
	PhoneNumber Varchar(12) NULL
)
GO

CREATE TABLE WorkInfo
(
	Id smallint IDENTITY NOT NULL,
	Salary Money NOT NULL,
	Position Varchar(50) NOT NULL
)
GO

CREATE TABLE PersonalInfo
(
	Id smallint IDENTITY NOT NULL,
	MaritalStatus Varchar(20) NOT NULL,
	BirthDay Date NOT NULL,
	Address Varchar(50) NOT NULL
)
GO