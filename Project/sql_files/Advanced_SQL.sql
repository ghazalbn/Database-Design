

 --functions--

CREATE FUNCTION get_std_by_ssn(
@ssn as char(11))
RETURNS TABLE
RETURN
	SELECT *
     FROM Student s
	WHERE s.SSN=@ssn

select * FROM get_std_by_ssn('22687214329')




CREATE FUNCTION sum_of_payment()
RETURNS TABLE
RETURN
	SELECT sum(SalaryPeyment.Amount) as total
     FROM SalaryPeyment 

select * FROM sum_of_payment()




CREATE FUNCTION expirience(@num as integer)
RETURNS TABLE
RETURN
SELECT FName, LName, DATEDIFF(MM, R.R_Date, GETDATE()) AS Exprience
FROM Training_Staff TF INNER JOIN Registration R
				ON R.RG_Code = TF.RG_ID
				INNER JOIN Teacher T
				ON T.TS_ID = TF.TS_ID
WHERE DATEDIFF(MM, R.R_Date, GETDATE()) > @num;
select * FROM expirience(3)





 --PROCEDURE--

CREATE PROCEDURE show_all_stds_phone_no
AS
SELECT prefix = CASE S.Gender
WHEN 'w' THEN 'Miss/Mrs '
ELSE 'Mr '
END ,
S.FName + ' ' + S.LName as fullname,
S.PhoneNo
FROM Student S INNER JOIN Registration R
				ON S.RG_ID = R.RG_Code

EXEC show_all_stds_phone_no;



CREATE PROCEDURE add_admin(@fnam as varchar(100),@lnam as varchar(100),@usr as varchar(100),@pass as varchar(100),@phno as char(11))
AS
begin
Insert Into Admin ( 
	FName ,
	LName,
	UserName ,
	Pass ,
	PhoneNo)
	 VALUES (@fnam, @lnam, @usr,@pass ,@phno);
	
end
EXECUTE add_admin
   @fnam = 'melika'
  ,@lnam = 'nobakhtian'
  ,@usr = 'melika'
  ,@pass='1234'
  ,@phno ='0912123456'
 



CREATE PROCEDURE upcomming_Exams
AS
begin
SELECT e.Class_ID,e.Exam_Date,e.Exam_Time,e.Exam_Type, DATEDIFF(DAY, GETDATE(),e.Exam_Date) AS date_number_to_exam,GETDATE() as today
FROM Exam e 
WHERE DATEDIFF(day,e.Exam_Date, GETDATE()) <= 0 
order by DATEDIFF(DAY, GETDATE(),e.Exam_Date)
end
EXECUTE upcomming_Exams;





 --views--

CREATE VIEW Teacher_Salary
AS
SELECT TF.TS_ID, TF.FName + ' ' + TF.LName AS FullName, S.Amount AS Salary
FROM Training_Staff TF INNER JOIN SalaryPeyment S
ON S.SP_Code = TF.SP_ID
INNER JOIN Teacher T
ON T.TS_ID = TF.TS_ID


CREATE VIEW Officer_Salary AS
SELECT TF.TS_ID, TF.FName + ' ' + TF.LName AS FullName, S.Amount AS Salary
FROM Training_Staff TF INNER JOIN SalaryPeyment S
ON S.SP_Code = TF.SP_ID
INNER JOIN Officer F
ON F.TS_ID = TF.TS_ID



SELECT *
FROM Officer_Salary


SELECT *
FROM Teacher_Salary


SELECT *
FROM Teacher_Salary
WHERE Salary < 7000000


SELECT T.SSN, TS.FullName, T.Gender, TS.Salary
FROM Teacher_Salary TS INNER JOIN Training_Staff T
ON T.TS_ID = TS.TS_ID
WHERE Salary > 6500000





CREATE VIEW Student_Information AS
SELECT S.SSN, S.FName + ' ' + S.LName AS FullName, R.R_Date, HC.HC_Name, HC.HC_Address, CL.Class_Date, E.Exam_Date, C.Theory_Exam_Result,CL.Class_Type,E.Exam_Type
FROM Student S INNER JOIN Cardex C
ON S.Student_ID = C.Student_ID
INNER JOIN EnrollClass EC
ON S.Student_ID = EC.Student_ID
INNER JOIN Class CL
ON EC.Class_ID = CL.Class_ID
INNER JOIN TakeExam TE
ON S.Student_ID = TE.Student_ID
INNER JOIN EXAM E
ON TE.Exam_ID = E.EXAM_ID
INNER JOIN Health_Center HC
ON S.HC_ID = HC.HC_ID
INNER JOIN Registration R
ON S.RG_ID = R.RG_Code
WHERE CL.Class_Type = 'practical' AND E.Exam_Type = 'practical'

SELECT *
FROM Student_Information





--Materalized views--

CREATE VIEW dbo.Student_Exam
WITH SCHEMABINDING
AS
SELECT S.SSN, S.LName, Theory_Exam = CASE C.Theory_Exam_Result
WHEN 'P' THEN '+'
WHEN 'F' THEN '-'
ELSE 'nothing'
END,
Practical_Exam = CASE C.Theory_Exam_Result
WHEN 'P' THEN '+'
WHEN 'F' THEN '-'
ELSE 'nothing'
END
FROM dbo.Student S INNER JOIN dbo.Cardex C
				ON S.Student_ID = C.Student_ID
CREATE UNIQUE CLUSTERED INDEX
SEIndex
ON Student_Exam(SSN)


SELECT *
FROM Student_Exam




CREATE VIEW dbo.v_classStudent
WITH SCHEMABINDING
AS
SELECT C.Class_ID, C.Class_Type, C.Class_Date, TS.LName AS TeacherLName, S.Student_ID, S.FName + ' ' + S.LName AS StudentName
FROM dbo.Class C INNER JOIN dbo.Training_Staff TS
ON C.Teacher_ID = TS.TS_ID
INNER JOIN dbo.EnrollClass EC
ON C.Class_ID = EC.Class_ID
INNER JOIN dbo.Student S
ON EC.Student_ID = S.Student_ID
CREATE UNIQUE CLUSTERED INDEX
CSIndex
ON v_classStudent(Class_ID, Student_ID)


SELECT *
FROM dbo.v_classStudent
ORDER BY Class_ID




CREATE VIEW dbo.Student_TraningStaffs
WITH SCHEMABINDING
AS
SELECT S.Student_ID, S.FName + ' ' + S.LName AS StudentName, TS.TS_ID, TS.FName + ' ' + TS.LName AS TraningStaffLName
FROM dbo.Student S INNER JOIN dbo.EnrollClass EC
ON S.Student_ID = EC.Student_ID
INNER JOIN dbo.Class C
ON EC.Class_ID = C.Class_ID
INNER JOIN dbo.Training_Staff TS
ON TS.TS_ID = C.Teacher_ID
UNION
SELECT S.Student_ID, S.FName + ' ' + S.LName AS StudentName, TS.TS_ID, TS.FName + ' ' + TS.LName AS TraningStaffLName
FROM dbo.Student S INNER JOIN dbo.TakeExam TE
ON S.Student_ID = TE.Student_ID
INNER JOIN dbo.EXAM E
ON TE.Exam_ID = E.EXAM_ID
INNER JOIN dbo.Training_Staff TS
ON TS.TS_ID = E.Officer_ID



SELECT *
FROM Student_TraningStaffs
ORDER BY StudentName




--Normalization--

--Health Center--


Alter Table Health_Center
Drop Column HC_Address, Region;

CREATE TABLE HAddress(
	Address_ID INT PRIMARY KEY identity(1, 1) NOT NULL,
	HC_Address varchar(255),
	Region varchar(100) NOT NULL
)

ALTER TABLE Health_Center
ADD AddressID int FOREIGN KEY REFERENCES HAddress(Address_ID)
