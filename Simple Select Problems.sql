use IQSchool
go

-- Select all the information from the club table
SELECT clubid, clubname
FROM Club

--a short form to access all attributes of the From
--DO NOT USE in the course
SELECT *
FROM Club

--Select the FirstNames and LastNames of all the students
SELECT FirstName, LastName
FROM Student

--so by default the report column header is the name of the
--	attribute
--this can be alter to a different column header using the "as"
--	modifier on the selected attribute
--Select all the CourseId and CourseName of all the coureses. 
--	Use the column aliases of Course ID and Course Name
--The "as" is optional for changing the column name.
--However, if by accident you use attribute WITHOUT a separating
--	comma (,); then; what you believe should be a column because
--	of the column attribute will actually be considered the new
--	alisas column name

SELECT CourseId as 'Course ID', CourseName 'Course Name'
FROM Course

--Filtering: WHERE Clause
--Select all the course information for courseID 'DMIT1001'
SELECT CourseId, CourseName, CourseHours, MaxStudents, CourseCost
FROM Course
WHERE CourseId = 'DMIT1001'

--Select the Staff names who have positionID of 3
--here we are concatenating the first and last names together
SELECT LastName + ', ' + FirstName as 'Staff'
FROM Staff
WHERE PositionID = 3

--select the CourseNames and hours whos CourseHours are less than 96
--order by hours most to least and alphabetically by coursename
SELECT CourseName, CourseHours
FROM Course
WHERE CourseHours < 96
ORDER BY CourseHours desc, CourseName asc

--Select the studentID's, OfferingCode and mark 
--where the Mark is between 70 and 80
SELECT StudentID, OfferingCode, Mark
FROM Registration
--WHERE Mark >= 70 and Mark <= 80
WHERE Mark between 70 and 80

--Select the studentID's, Offering Code and mark where the Mark 
--is between 70 and 80 and the OfferingCode is 1001 or 1009
SELECT StudentID, OfferingCode, Mark
FROM Registration
WHERE Mark between 70 and 80
  --and (OfferingCode = 1001 or OfferingCode = 1009)
  and (OfferingCode in (1001,1009))

--Select the students first and last names who have last names 
--starting with S
SELECT FirstName, LastName
FROM Student
WHERE LastName like 'S%'

--Select Coursenames whose CourseID  have a 1 as the fifth 
--character
SELECT CourseName--, CourseId
FROM Course
WHERE CourseId like '____1%'

--Select the CourseID's and Coursenames where the CourseName 
--contains the word 'programming'
SELECT CourseName--, CourseId
FROM Course
WHERE CourseName like '%programming%'

--Select all the ClubNames who start with N or C
SELECT ClubID,ClubName
FROM Club
WHERE ClubName like '[NC]%'

--Select Student Names, Street Address and City where the 
--LastName is only 3 letters long
--order alphabetically by the student's city then lastname 
SELECT FirstName, LastName, StreetAddress, City
FROM Student
WHERE LastName like '___'
ORDER BY city, LastName

--Select all the StudentID's where the Amount < 500 OR 
--the PaymentTypeID is 5
SELECT StudentID --, Amount, PaymentTypeID
FROM Payment
WHERE Amount < 500 
   or PaymentTypeID = 5
