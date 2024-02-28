--SubQuery

--it is a query within a query

--why

-- there will be times when you need to determine some data before being
--	able to process other data that relies on the first piece(s) of data
use IQSchool
go

--1. Select the Payment dates and payment amount for all payments that were Cash

--what is the problem
--Payment has an attribute called PaymentTypeID
--I have NO IDEA the the ID is for Cash

--I could 
-- a) do  a join because PaymentTypeID is fkey
-- Payment uses an alias for the table name whereas
-- PaymentType has no alias
SELECT PaymentDate, Amount
FROM Payment p join PaymentType
		on p.PaymentTypeID = PaymentType.PaymentTypeID
WHERE PaymentTypeDescription = 'Cash'

-- b) use a subquery to find the PaymentTypeID and use it on the WHERE
SELECT PaymentDate, Amount
FROM Payment
WHERE PaymentTypeID in (SELECT PaymentTypeID
						FROM PaymentType
						WHERE PaymentTypeDescription = 'Cash')

--2. Select The Student ID's of all the Students that are in the 
--'Association of Computing Machinery' club
SELECT s.StudentID, LastName + ', ' + FirstName 'Name'
FROM Activity a join Student s
		on a.StudentID = s.StudentID
WHERE ClubId in (SELECT ClubId
				FROM Club
				WHERE ClubName ='Association of Computing Machinery')

				
--3. Select All the instructional Staff full names that have not taught the course 1001.
SELECT LastName + ', ' + FirstName 'Name'
FROM Staff
WHERE StaffID not in (SELECT DISTINCT StaffID
				  FROM Offering
				  WHERE CourseId in (SELECT CourseId
				                         FROM Course
										 WHERE CourseId like '____1001'))
   and PositionId in (SELECT PositionID
					  FROM Position
					  WHERE PositionDescription like '%Instr%')