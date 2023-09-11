USE Northwind;

/*1*/
SELECT Phone
FROM Suppliers
WHERE ContactName LIKE 'M%';

/*2*/
SELECT C.CustomerID , C.ContactName , O.OrderID
FROM Customers C ,Orders O
WHERE C.CustomerID=O.CustomerID

/*3*/
SELECT DATEDIFF(YY, BirthDate, HireDate) AS HireAge, FirstName, LastName, HireDate, BirthDate
FROM Employees

/*4*/
SELECT CustomerID, COUNT(CustomerID)
FROM Orders 
GROUP BY CustomerID

/*5*/
SELECT DISTINCT EmployeeID, FirstName, LastName
FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID
					FROM Orders
					GROUP BY EmployeeID
					HAVING COUNT(EmployeeID) > 2)

/*6*/
SELECT EmployeeID, FirstName, LastName
FROM Employees
EXCEPT
SELECT EmployeeID, FirstName, LastName
FROM Employees
WHERE Title = 'Sales Representative'

/*7*/
WITH OrderPrice AS (SELECT OrderID, SUM(UnitPrice*Quantity) AS TotalPrice 
						FROM [Order Details]
						GROUP BY OrderID)

SELECT DISTINCT C.Address, C.ContactName, OP.TotalPrice, O.OrderID, C.CustomerID
FROM Orders O, OrderPrice OP, Customers C
WHERE C.CustomerID = O.CustomerID 
		AND O.OrderID = OP.OrderID 
		AND OP.TotalPrice > 6000

/*8*/
WITH OrderPrice AS (SELECT OrderID, SUM(UnitPrice*Quantity) AS TotalPrice 
						FROM [Order Details]
						GROUP BY OrderID)
,CustomerOrders AS (SELECT O.CustomerID, SUM(TotalPrice) AS TotalCost 
						FROM OrderPrice OP INNER JOIN Orders O
							ON OP.OrderID = O.OrderID
						GROUP BY CustomerID)

SELECT DISTINCT C.Country, C.ContactName, CO.TotalCost
FROM CustomerOrders CO INNER JOIN Customers C
	ON CO.CustomerID = C.CustomerID
GROUP BY C.Country, C.ContactName, CO.TotalCost