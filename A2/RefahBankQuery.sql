USE [Refah Bank];

/*1*/
WITH Increase
AS
(SELECT B.Id, B.MandehAkhar95 - B.MandehAval95 AS Amount
FROM ['500000FamilySample-990402#xlsx$'] B
WHERE Gender = N'زن'
)

SELECT Id, Amount
FROM Increase
WHERE Amount = (SELECT MAX(Amount)
			FROM Increase)

/*2*/
SELECT AVG(Sood95) AS AVG_Sood95
FROM ['500000FamilySample-990402#xlsx$'] 
GROUP BY IsTamin_Karfarma

SELECT AVG(Sood95) AS AVG_Sood95
FROM ['500000FamilySample-990402#xlsx$'] 
GROUP BY IsBimarkhas

SELECT AVG(Sood95) AS AVG_Sood95
FROM ['500000FamilySample-990402#xlsx$'] 
GROUP BY IsBimePardaz_Sandoghha


/*3*/
SELECT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE Variz97 != 0
ORDER BY (Variz96/ (SELECT AVG(Variz96) 
					FROM ['500000FamilySample-990402#xlsx$']))
					/(Variz97/ (SELECT AVG(Variz97) 
					FROM ['500000FamilySample-990402#xlsx$'])) 
SELECT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE Variz97 = 0


/*4*/
SELECT COUNT(*)
FROM ['500000FamilySample-990402#xlsx$']
WHERE IsBimePardaz_Sandoghha = 1 AND Daramad_Total_Rials > 1000000


/*5*/
--حجم زیادی داشت--
--ابتدا باید خانم های با شرایط مربوطه را مرتب کرده و 100 تای اول را بگیریم--
--سپس مردان با این شرایط را میگیریم--
---این دو را باهم جوین میزنیم--
--بر حسب اختلاف مورد نظر مرتب میکنیم--
--کمترین اختلاف را برمیداریم---
WITH Ladies AS 
(SELECT W.Id, W.MandehAkhar97
FROM ['500000FamilySample-990402#xlsx$'] W
WHERE Gender = N'زن')
, Gentlemen AS 
(SELECT Id, MandehAval97
FROM ['500000FamilySample-990402#xlsx$']
WHERE Gender = N'مرد')

SELECT TOP (100) L.Id, G.Id
FROM Ladies L CROSS JOIN Gentlemen G
ORDER BY L.MandehAkhar97 DESC, ABS(L.MandehAkhar97 - G.MandehAval97)



/*6*/
WITH Daramad AS 
(SELECT Id, Daramad_Total_Rials
FROM ['500000FamilySample-990402#xlsx$']
WHERE SenfName = N'مشاوره املاک و مستغلات')

SELECT Id
FROM Daramad
WHERE Daramad_Total_Rials = (SELECT MAX(Daramad_Total_Rials)
							FROM Daramad)


/*7*/
WITH BirthPackages
AS
(SELECT Id,
		CASE
		WHEN  1920 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1925
				THEN -6
		WHEN  1925 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1930
				THEN -5
		WHEN  1930 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1935
				THEN -4
		WHEN  1935 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1940
				THEN -3
		WHEN  1940 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1945
				THEN -2
		WHEN  1945 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1950
				THEN -1
		WHEN  1950 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1955
				THEN 0
		WHEN  1955 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1960
				THEN 1
		WHEN  1960 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1965
				THEN 2
		WHEN  1965 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1970
				THEN 3
		WHEN  1970 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1975
				THEN 4
		WHEN  1975 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1980
				THEN 5
		WHEN  1980 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1985
				THEN 6
		WHEN  1985 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1990
				THEN 7
		WHEN  1990 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 1995
				THEN 8
		WHEN  1995 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 2000
				THEN 9
		WHEN  2000 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 2005
				THEN 10
		WHEN  2005 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 2010
				THEN 11
		WHEN  2010 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 2015
				THEN 12
		WHEN  2015 <= YEAR(A.BirthDate) AND  YEAR(A.BirthDate) < 2020
				THEN 13
		ELSE 14
	   END AS Birthdate_Package
FROM ['500000FamilySample-990402#xlsx$'] A)

SELECT AVG(A.Sood95 + A.Sood96 + A.Sood97)
FROM BirthPackages B INNER JOIN ['500000FamilySample-990402#xlsx$'] A
					ON B.Id = A.Id
GROUP BY B.Birthdate_Package
ORDER BY B.Birthdate_Package
