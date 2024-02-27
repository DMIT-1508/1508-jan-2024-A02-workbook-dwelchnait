/*
* Aggregates, Group By and Having
*/
use IQSchool
go
SELECT avg(Mark)
FROM Registration
go
SELECT StudentID, avg(Mark), count(offeringcode)
FROM Registration
-- you are NOT ALLOWED to use aggregates on the WHERE cause
-- one CAN STILL filter on non-aggregate attribute PRIOR to the
--		grouping of your results
--WHERE avg(Mark) >= 80

--if your aggregate will include null values the aggregate will not
--		execute correctly
--solution is to filter record that would affect your aggregate out
-- since mark is nullable, use ONLY those records that would have a Mark
WHERE WithdrawYN = 'N' 

GROUP BY StudentID
--to filter a group you will need to use the HAVING clause
-- you may use aggregates or other attributes on this clause
HAVING avg(Mark) >= 80 and count(*) >= 5
go
SELECT OfferingCode, avg(Mark), count(StudentID)
FROM Registration
GROUP BY OfferingCode
go