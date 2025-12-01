CREATE TABLE Orders
(
	OrderId INT PRIMARY KEY IDENTITY NOT NULL,
	CustomerId INT NOT NULL,
	OrderDate DATE NOT NULL
);
GO

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(101, '2023-11-01'),
(101, '2023-11-03'),
(102, '2023-11-02'),
(102, '2023-11-02'),
(103, '2023-11-05'),
(104, '2023-11-01'),
(104, '2023-11-07');
GO


SELECT *
FROM Orders AS ord1
WHERE ord1.OrderDate = 
(SELECT MIN(OrderDate) 
FROM Orders AS ord2
WHERE ord2.CustomerID = ord1.CustomerID)

SELECT OrderID, CustomerID, OrderDate
FROM (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC, OrderID ASC) AS rn
    FROM [Orders]
) t
WHERE rn = 1;
