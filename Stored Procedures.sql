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

--SELECT r.studentid, sum(CourseCost), 'COST'
--FROM Course c inner join Offering o
--      on c.CourseId = o.CourseId
--	          inner join Registration r
--	  on o.OfferingCode = r.OfferingCode
--GROUP BY r.studentid
--union
--SELECT studentid, sum(Amount), 'PAY'
--FROM Payment 
--GROUP BY StudentID
--ORDER BY 1
