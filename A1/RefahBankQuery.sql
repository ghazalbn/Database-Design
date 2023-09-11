USE [Refah Bank];

/*1*/
SELECT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE Gender = N'مرد' AND Bardasht95 > 25000000

/*2*/
SELECT DISTINCT SenfName
FROM ['500000FamilySample-990402#xlsx$']

/*3*/
SELECT DISTINCT Id, ProvinceName
FROM ['500000FamilySample-990402#xlsx$']
WHERE ProvinceName = N'گیلان' OR ProvinceName = N'خراسان رضوی'
ORDER BY Id DESC

/*4*/
SELECT Id, Sood97-Sood95 AS amount_increased
FROM ['500000FamilySample-990402#xlsx$']
WHERE Sood97>Sood96 AND Sood96 > Sood95
ORDER BY Id

/*5*/
SELECT DISTINCT Daramad_Total_Rials
FROM ['500000FamilySample-990402#xlsx$']
WHERE DATEDIFF(YY, BirthDate, GETDATE()) = 56
ORDER BY Daramad_Total_Rials

/*6*/
SELECT DISTINCT SenfName
FROM ['500000FamilySample-990402#xlsx$']
WHERE SenfName LIKE N'%ش%'

/*7*/
SELECT Id,Gender,CountyName ,
CASE 
WHEN Gender = N'زن' THEN 'Miss/Mrs'
ELSE 'Mr'
END AS ENG_Gender
FROM  ['500000FamilySample-990402#xlsx$']

/*8*/
SELECT DISTINCT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE 
Variz95>Bardasht95
AND Variz96>Bardasht96
AND Variz97>Bardasht97
ORDER BY Id DESC

/*9*/
SELECT Id, CountyName, ABS(Bardasht97-Bardasht96) AS WithdrawDiff96_97
FROM ['500000FamilySample-990402#xlsx$']

SELECT MAX(ABS(Bardasht97-Bardasht96)) AS MaxWithdrawDiff96_97
FROM ['500000FamilySample-990402#xlsx$']

/*10*/
SELECT Id, CountyName, Daramad_Total_Rials, CarPrice_Sum, Cars_Count
FROM ['500000FamilySample-990402#xlsx$']
WHERE CarPrice_Sum IN (SELECT MAX(CarPrice_Sum)
						FROM ['500000FamilySample-990402#xlsx$'])

/*11*/
SELECT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE Cars_Count > (SELECT AVG(Cars_Count)
						FROM ['500000FamilySample-990402#xlsx$'])

/*12*/
SELECT *
FROM ['500000FamilySample-990402#xlsx$']
WHERE Sood97>Sood96 AND Sood97 > (SELECT AVG(Sood97)
						FROM ['500000FamilySample-990402#xlsx$'])
ORDER BY Id






