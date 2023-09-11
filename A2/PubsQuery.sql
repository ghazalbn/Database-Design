USE pubs;

--Section 1--

/*1*/
WITH PubEmp
AS
(SELECT E.pub_id, COUNT(E.pub_id) AS EmpCount
FROM employee E
GROUP BY E.pub_id
)

SELECT P.pub_name, PE.EmpCount
FROM PubEmp PE INNER JOIN publishers P
				ON PE.pub_id = P.pub_id
WHERE 
PE.EmpCount = (SELECT MAX(EmpCount) 
				FROM PubEmp) 

/*2*/
WITH AthSales AS
(SELECT TOP 10 TA.au_id, COUNT(*) AS TotalSales
FROM sales S INNER JOIN titles T
			ON S.title_id = T.title_id
			INNER JOIN titleauthor TA
			ON T.title_id = TA.title_id
			INNER JOIN authors A
			ON A.au_id = TA.au_id
GROUP BY TA.au_id
ORDER BY COUNT(*) DESC) 

SELECT A.au_fname + ' ' + A.au_lname AS FullName, [AS].TotalSales
FROM AthSales [AS] INNER JOIN authors A
					ON [AS].au_id = A.au_id

/*3*/
WITH BookTypes AS 
(SELECT T.type, COUNT(T.type) AS SalesCount
FROM sales S INNER JOIN titles T
			ON S.title_id = T.title_id
GROUP BY T.type       
)
SELECT type AS PoplularType
FROM BookTypes
WHERE SalesCount = (SELECT MAX(SalesCount)
					FROM BookTypes)

/*4*/
WITH EmpJobs AS
(SELECT E.job_id, COUNT(*) AS JobCount
FROM publishers P INNER JOIN employee E
			ON P.pub_id = E.pub_id
GROUP BY E.job_id
) 
SELECT J.job_desc
FROM EmpJobs EJ INNER JOIN jobs J
				ON EJ.job_id = J.job_id
WHERE EJ.JobCount = (SELECT MAX(JobCount)
					FROM EmpJobs)

/*5*/ 
WITH StoreSale AS
(SELECT S.stor_id, COUNT(*) AS SalesCount
FROM sales S 
GROUP BY S.stor_id
) 
SELECT S.stor_id, S.stor_name
FROM StoreSale SS INNER JOIN stores S
					ON SS.stor_id = S.stor_id
WHERE SS.SalesCount = (SELECT MAX(SalesCount)
					FROM StoreSale)

--Section 2--


/*1*/ 
--برای هر کتاب، نام نویسنده آن، نام ناشر آن و تعداد کتابهای منتشر شده تحت آن انتشارات را نمایش دهد--
CREATE VIEW BooksInformation AS
WITH PubBooks AS
(SELECT pub_id, COUNT(*) AS Pub_BookCount
FROM titles
GROUP BY pub_id
)
SELECT title, A.au_fname + ' ' + A.au_lname AS au_name, P.pub_name, PB.Pub_BookCount
From titles T INNER JOIN publishers P 
				ON T.pub_id = P.pub_id
				INNER JOIN PubBooks PB
				ON PB.pub_id = P.pub_id
				INNER JOIN titleauthor TA
				ON T.title_id = TA.title_id
				INNER JOIN authors A
				ON A.au_id = TA.au_id


SELECT * FROM BooksInformation

/*2*/
CREATE VIEW LowPriceBooks AS
SELECT title, price 
From titles
Where price <= (Select AVG(price)
					From titles)

SELECT * FROM LowPriceBooks



--Section 3--


/*1*/ 
CREATE FUNCTION Pub_Authors
(
@pub NVARCHAR(30)
)
RETURNS TABLE
AS
RETURN
SELECT DISTINCT A.au_fname + ' ' + A.au_lname AS Author_Name
FROM publishers P INNER JOIN titles T
				ON P.pub_id = T.pub_id
				INNER JOIN titleauthor TA
				ON TA.title_id = T.title_id 
				INNER JOIN authors A
				ON A.au_id = TA.au_id 			
WHERE P.pub_name = @pub

GO


SELECT *
FROM dbo.Pub_Authors('New Moon Books')


/*2*/
CREATE FUNCTION Emp_Job
(
@pub_id INT,
@job_id INT
)
RETURNS TABLE
AS
RETURN
SELECT DISTINCT E.fname, E.lname
FROM employee E	INNER JOIN publishers P
				ON E.pub_id = P.pub_id
				INNER JOIN jobs J
				ON E.job_id = J.job_id
WHERE P.pub_id = @pub_id AND J.job_id = @job_id

GO

SELECT *
FROM dbo.Emp_Job(0736, 5)
ORDER BY lname


/*3*/
CREATE FUNCTION Author_Pubs
(
@author NVARCHAR(30)
)
RETURNS TABLE
AS
RETURN
WITH PubBooks AS
(SELECT T.pub_id, A.au_id, COUNT(*) AS Auth_Pub_BookCount
FROM titles T INNER JOIN titleauthor TA
			ON T.title_id = TA.title_id
			INNER JOIN authors A
			ON A.au_id = TA.au_id
GROUP BY A.au_id, T.pub_id)

SELECT P.pub_name, PB.Auth_Pub_BookCount
FROM PubBooks PB INNER JOIN publishers P
				ON PB.pub_id = P.pub_id
				INNER JOIN authors A
				ON PB.au_id = A.au_id
WHERE A.au_fname= @author

GO
SELECT *
FROM dbo.Author_Pubs('Marjorie')