USE Northwind;

/*1*/
WITH OrderPrice AS 
( SELECT OrderID, Avg(UnitPrice) AS PriceAvg
FROM [Order Details]
GROUP BY OrderID
),
CustomerData AS 
( SELECT CompanyName, CustomerID
 FROM Customers
),
TotalItems AS
( SELECT AVG(UnitPrice) as TotalAvg
FROM Products
)

SELECT  C.* , (OP.PriceAvg - T.TotalAvg)/T.TotalAvg as BoughtAvg_TotalAvg  --چون میخواهیم ببینیم کمتر بوده یا بیشتر، قدر مطلق نمیگذاریم--
FROM TotalItems T , CustomerData C INNER JOIN Orders O
					ON O.CustomerID = C.CustomerID 
					INNER JOIN OrderPrice OP
					ON OP.OrderID = O.OrderID


/*2*/
SELECT P.ProductID, P.ProductName
FROM Products P
WHERE P.ProductID IN ( SELECT TOP (10) ProductID
					FROM [Order Details]
					GROUP BY ProductID
					ORDER BY COUNT(*) DESC
					)


/*3*/
WITH CountryCount
AS
(SELECT C.Country AS Country, COUNT(C.Country) AS BoughtCount
FROM Customers C INNER JOIN Orders O
				ON C.CustomerID = O.CustomerID 
				INNER JOIN [Order Details] OD
				ON OD.OrderID = O.OrderID
GROUP BY C.Country
)

SELECT Country , BoughtCount
FROM CountryCount
WHERE 
BoughtCount = (SELECT MAX(BoughtCount) 
				FROM CountryCount) 
OR 
BoughtCount = (SELECT MIN(BoughtCount) 
				FROM CountryCount)


/*4*/
WITH Cooperation
AS
(SELECT EmployeeID, ShipVia, COUNT(*) AS CooperationCount
FROM Orders
GROUP BY EmployeeID, ShipVia
)

SELECT E.FirstName, E.LastName, S.CompanyName
FROM Cooperation C INNER JOIN Employees E
					ON C.EmployeeID = E.EmployeeID
					INNER JOIN Shippers S
					ON C.ShipVia = S.ShipperID
WHERE C.CooperationCount = (SELECT MAX(CooperationCount) 
							FROM Cooperation) 


/*5*/
SELECT C.Country AS Country, COUNT(C.Country) AS BoughtCount
FROM Customers C INNER JOIN Orders O
				ON C.CustomerID = O.CustomerID 
				INNER JOIN [Order Details] OD
				ON OD.OrderID = O.OrderID
GROUP BY C.Country
ORDER BY COUNT(C.Country)

/*6*/
WITH OrderPrice AS (SELECT OrderID, SUM(UnitPrice*Quantity) AS TotalPrice 
						FROM [Order Details]
						GROUP BY OrderID)

SELECT TOP 1 C.Region AS MaxOrdersCostRegionID, SUM(P.TotalPrice) AS OrdersCost
						FROM Orders O INNER JOIN OrderPrice P
										ON O.OrderID = P.OrderID
										INNER JOIN Customers C
										ON O.CustomerID = C.CustomerID
						WHERE C.Region IS NOT NULL
						GROUP BY C.Region
						ORDER BY OrdersCost DESC


/*SELECT RegionID, TotalPurchases
FROM RegionOrders
WHERE TotalPurchases = (SELECT MAX(TotalPurchases) 
						FROM RegionOrders
						WHERE RegionID IS NOT NULL)*/


/*7*/
WITH PurchaseSum AS( SELECT C.CustomerID, SUM(OD.UnitPrice*OD.Quantity*(1-Discount)) AS TotalCost
FROM Customers C INNER JOIN Orders O
				ON C.CustomerID = O.CustomerID 
				INNER JOIN [Order Details] OD
				ON OD.OrderID=O.OrderID
GROUP BY C.CustomerID
)

SELECT C.CustomerID, C.ContactName, PS.TotalCost, 
		(PS.TotalCost - (SELECT AVG((OD.UnitPrice*OD.Quantity)*(1-Discount)) 
						FROM [Order Details] OD)) AS CostDiff
FROM Customers C INNER JOIN PurchaseSum PS
									ON C.CustomerID = PS.CustomerID

/*8*/
WITH Discounts AS (SELECT O.CustomerID, COUNT(*) AS DiscountCount
						FROM [Order Details] OD INNER JOIN Orders O
												ON O.OrderID = OD.OrderID
						WHERE OD.Discount != 0
						GROUP BY O.CustomerID)
SELECT C.CustomerID, C.ContactName, D.DiscountCount
FROM Discounts D INNER JOIN Customers C
				ON D.CustomerID = C.CustomerID
WHERE D.DiscountCount = (SELECT MAX(DiscountCount) 
						FROM Discounts) 


/*9 KAMEL NIST*/
WITH Country AS (SELECT O.ShipCountry, COUNT(*) AS CountryNumber
				FROM Orders O
				GROUP BY O.ShipCountry)
SELECT *
FROM Country
WHERE CountryNumber = (SELECT MAX(CountryNumber)
						FROM Country)


/*10*/
CREATE FUNCTION PR_Information 
( 
@CID NCHAR(5)
)
RETURNS TABLE
AS
RETURN
(SELECT P.ProductName, P.UnitPrice, S.CompanyName, S.ContactName
FROM Orders O INNER JOIN [Order Details] OD
				ON O.OrderID = OD.OrderID
				INNER JOIN Products P
				ON OD.ProductID = P.ProductID
				INNER JOIN Suppliers S
				ON P.SupplierID = S.SupplierID
WHERE O.CustomerID = @CID)

GO

 SELECT * FROM dbo.PR_Information('ALFKI')


/*11*/
CREATE VIEW EMP_Information
AS 
SELECT LOWER(E.FirstName + ' ' + E.LastName) AS full_name, E.BirthDate, E.Region, O.OrderID,
		CAST(O.OrderDate AS DATE) AS OrderDate, C.Phone AS Customer_Phone,
		CASE
		WHEN  5 < DATEDIFF(DAY,O.ShippedDate, O.RequiredDate) AND DATEDIFF(DAY,O.ShippedDate,O.RequiredDate) < 10
				THEN 0.10 *((UnitPrice*Quantity) * (1-Discount))
		WHEN  10 < DATEDIFF( DAY,O.ShippedDate,O.RequiredDate) AND  DATEDIFF(DAY,O.ShippedDate,O.RequiredDate) < 15
				THEN 0.20 *((UnitPrice*Quantity) * (1-Discount))
		WHEN DATEDIFF(DAY,O.ShippedDate,O.RequiredDate) > 15 
				THEN 0.30 *((UnitPrice*Quantity) * (1-Discount))
		ELSE 0
	   END AS Penalty
FROM Employees E INNER JOIN Orders O
ON O.EmployeeID = E.EmployeeID 
INNER JOIN [Order Details] OD
ON OD.OrderID = O.OrderID
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID


SELECT * FROM EMP_Information




