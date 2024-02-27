use IQSchool
go
-- Views

--BENEFITS
--Some common uses for SQL views are:
--•	simplifying data retrieval from complex queries
--•	hiding the underlying table structure
--•	controlling access to data for different users

--Views are virtual tables created by other selects

--to drop a VIEW
DROP VIEW StudentAverages
go
--syntax CREATE VIEW viewname AS
CREATE VIEW StudentAverages
as
SELECT s.StudentID, 
		LastName + ',' + FirstName 'Student', 
		avg(Mark) 'Average', 
		count(offeringcode) 'CourseCount'
FROM Registration r Join Student s
         ON r.StudentID = s.StudentID
WHERE WithdrawYN = 'N' 
GROUP BY s.StudentID,LastName + ',' + FirstName
HAVING count(*) >= 5
go

--use a stored VIEW within the database
SELECT Student,Average
FROM StudentAverages
go