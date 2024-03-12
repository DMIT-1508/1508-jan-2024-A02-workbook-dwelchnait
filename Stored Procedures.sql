use IQSchool
go

--Create a stored procedure called StudentClubCount. 
--It will accept a clubID as a parameter. 
--If the count of students in that club is greater than 2 
--print ‘A successful club!’. If the count is not greater than 2 
--print ‘Needs more members!’.

--quite often your procedure is referred to as a proc
DROP PROCEDURE StudentClubCount
go

CREATE PROCEDURE StudentClubCount(@clubid varchar(10))
AS
-- setup a local variable for the code
--DECLARE @clubid varchar(10) --commented because made a parameter
DECLARE @studentCount int

-- give the variable a value via the SET
--SET @clubid = 'CSS' -- commented because the value will be passed into the proc

-- give the variable a value using a query
-- this query is producing an aggregate value
-- HOWEVER the filtering is NOT on the agggregate value
-- THEREFORE the WHERE is used instead of the GROUP BY/HAVING
SELECT @studentCount = count(*)
FROM Activity
WHERE ClubId = @clubid

IF @studentCount > 2
BEGIN
	PRINT 'A successful club!'
END
ELSE
BEGIN
	PRINT 'Needs more members!'
END
RETURN
go
--to execute a proc use the EXECUTE procedureName (EXECUTE --> EXEC)
--exec StudentClubCount 'CSS'
--go


--Create a stored procedure called BalanceOrNoBalance. 
--It will accept a studentID as a parameter. Each course has a cost. 
--If the total of the costs for the courses the student is registered 
--in is more than the total of the payments that student has made, 
--then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ School!’
--Do Not use the BalanceOwing field in your solution.

DROP PROCEDURE BalanceOrNoBalance
go
CREATE PROCEDURE BalanceOrNoBalance (@studentid int)
AS
DECLARE @totalTuition money,
        @totalPayments money

SELECT @totalTuition = sum(CourseCost)
FROM Course c inner join Offering o
      on c.CourseId = o.CourseId
	          inner join Registration r
	  on o.OfferingCode = r.OfferingCode
WHERE r.StudentID = @studentid

SELECT @totalPayments = sum(Amount)
FROM Payment 
WHERE StudentID = @studentid

IF @totalTuition > @totalPayments
BEGIN
	PRINT 'balance owing!'
END
ELSE
BEGIN
	PRINT 'Paid in full! Welcome to IQ School!'
END

RETURN
go

exec BalanceOrNoBalance 200495500
go

--Create a stored procedure called ‘DoubleOrNothin’. 
--It will accept a student’s first name and last name as parameters. 
--If the student’s name already is in the table, 
--then print ‘We already have a student with the name firstname lastname!’ 
--Otherwise print ‘Welcome firstname lastname!’

DROP PROCEDURE DoubleOrNothin
go

CREATE PROCEDURE DoubleOrNothin(@firstname varchar(25), @lastname varchar(35))
AS
--the IF EXISTS does not actually allow for seeing the returned data
--it checks to see if any row is returned (true) or not (false)
--On this particular test the * is allowed in the SELECT
IF EXISTS(SELECT * FROM Student WHERE FirstName = @firstname AND LastName = @lastname)
BEGIN
	PRINT 'We already have a student with the name ' + @firstname + ' ' + @lastname
END
ELSE
BEGIN
	PRINT 'Welcome ' + @firstname + ' ' + @lastname
END
RETURN
go
exec DoubleOrNothin 'Don','Welch'
exec DoubleOrNothin 'Joe','Cool'
go

--Create a procedure called ‘StaffRewards’. 
--It will accept a staff ID as a parameter. 
--If the number of classes the staff member has ever taught is 
--  between 0 and 10 print ‘Well done!’, 
--if it is between 11 and 20 print ‘Exceptional effort!’, 
--if the number is greater than 20 print ‘Totally Awesome Dude!’


DROP PROCEDURE StaffRewards
go

CREATE PROCEDURE StaffRewards(@staffid int)
AS
DECLARE @count int
SELECT @count = Count(*)
FROM Offering
WHERE StaffID = @staffid
IF (@count = 0)
BEGIN
	print 'You have taught nothing'
END
ELSE
BEGIN
	IF (@count < 5)
	BEGIN
		print 'Well done!'
	END
	ELSE 
	BEGIN
		IF (@count < 10)
		BEGIN
			print 'Exceptional effort!'
		END
		ELSE
		BEGIN
			print 'Totally Awesome Dude!'
		END
	END
END
RETURN
go

exec StaffRewards 3
go

--Create a stored procedure called “HonorCoursesForTerm” to select all the course names 
--that have average >80% in a specified semester. The semester will be given at execution time.

DROP PROCEDURE HonorCoursesForTerm
go
CREATE PROCEDURE HonorCoursesForTerm(@semestercode char(5))
AS
SELECT CourseName, avg(Mark)
FROM Course c inner join Offering o
       on c.CourseId = o.CourseId
	          inner join Registration r
	   on o.OfferingCode = r.OfferingCode
WHERE SemesterCode like @semestercode + '%'
GROUP BY c.CourseID, CourseName
HAVING avg(Mark) > 80
RETURN
go
exec HonorCoursesForTerm 'A200'
go