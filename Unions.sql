use IQSchool
go

--UNION the joining of query outputs into one output

-- by default UNION removes duplicate display rows from the output
-- use the modifier ALL (UNION ALL) to include duplicates


--syntax
--      SELECT
--        UNION [ALL]
--      SELECT
--        [UNION....]

-- rules
-- the number of columns on EACH SELECT must be the same
-- the datatype of each column between the SELECTs must be of the same type (vertical)
-- ONLY one ORDER BY is allowed for the UNION and it MUST be placed on
--     LAST query

-- create a list of all student in alpabetically order by lastname
SELECT LastName, FirstName,  StudentID, 'Student'
FROM Student
--ORDER BY LastName

UNION 
-- create a list of all staff in alpabetically order by lastname
SELECT LastName, FirstName, StaffID, LastName + ', ' + FirstName
FROM Staff
ORDER BY LastName