-- the count is used in 3 verison
-- count(*) count the number of rows regardless of data presents
-- count(attribute) count the number of rows containing data
-- count(distinct attribute) count the number of unique values 
--       of the attribute

SELECT	count(*) as '# of Students',
		sum(Mark) as 'Sum of Marks',
		avg(Mark) as 'Average Mark',
		max(Mark) as 'Highest Grade',
		min(Mark) as 'Lowest Grade'
FROM Registration
WHERE OfferingCode = 1001
go
SELECT sum(amount)
FROM Payment
WHERE StudentID =200495500
go
-- count, min and max work on both numeric and alpha numberic data
-- sum and average required numeric data
SELECT count(DISTINCT Province)
FROM Student
go
SELECT StudentID, avg(Mark)
FROM Registration
GROUP BY StudentID
go
SELECT OfferingCode, avg(Mark), count(StudentID)
FROM Registration
GROUP BY OfferingCode
go

--string functions
SELECT firstname from Student
where Len(firstname) = 3
go
SELECT firstname FROM Student	
WHERE FirstName like '___'
go

SELECT len(RTRIM('    front and back spaces     '))
go
SELECT	len(LTRIM('    front and back spaces     '))
go
SELECT	len(LTRIM(RTRIM('    front and back spaces     ')))
go