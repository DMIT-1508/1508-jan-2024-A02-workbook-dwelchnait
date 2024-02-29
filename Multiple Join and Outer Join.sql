use IQSchool
go
--2. Select	the average mark for each course. Display the CourseName and 
-- the average mark

--what is the needed data for this query
-- coursename  in Course
-- average(mark) in the Registration

--problem  Course   does not have a relationship with Registration
--however Course does have a relationship to Offering which has a relationship to
--		Registration
--  pk -> fk pk -> fk
--  Course <-> Offering <-> Registration
--  coursename                 mark

--default for a join is an inner join although we do not need to type the word inner
SELECT CourseName, avg(mark) 'Average'
FROM Course c inner join Offering o
			on c.CourseId = o.CourseId
			  join Registration r
			on o.OfferingCode = r.OfferingCode
GROUP BY CourseName


--1. Select All position descriptions and the staff ID's that are in those positions
SELECT p.PositionDescription, s.StaffId
FROM Staff s Right Outer join Position p 
	on p.PositionID = s.PositionID
ORDER BY 1  -- attributes can be indicated by position number on your select

--Select the Position Description and the count of how many staff are in those 
-- positions. 
--Return the count for ALL (each,every) positions.
SELECT p.PositionDescription, count(s.Staffid)
FROM Position p Left Outer join Staff s 
	on p.PositionID = s.PositionID
GROUP BY p.PositionDescription