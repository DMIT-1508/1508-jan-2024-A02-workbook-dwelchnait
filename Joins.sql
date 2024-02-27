/*
* Joins
*/
use IQSchool
go
/*
* can the student name be added to the avg Mark query
*
* Problem 1 student name is in another table
* Will need to add the name to the Group BY clause
*
* the solution
*   on the FROM clause your CAN  specify multiple tables
*   IF you have an attribute that is on your query that
*		contains multiple tables AND that attribute appears on
*       2 or more of the multiple tables, you MUST qualify the
*       table from where that attribute is to be taken
*        syntax   tablename.attribute
*   when doing a join, you will want to "align" the records
*   between the tables using the relation attributes for those
*   tables (a relationship is formed between a primary and foreign
*            key)
*/
SELECT Student.StudentID, LastName, avg(Mark)
FROM Registration join Student 
			on Registration.StudentID = Student.StudentID --inner
--			join thirdtable
--			on relationship expression
-- you are NOT ALLOWED to use aggregates on the WHERE cause
-- one CAN STILL filter on non-aggregate attribute PRIOR to the
--		grouping of your results
--WHERE avg(Mark) >= 80
--any attribute on the SELECT that is NOT part of an aggregate
--   MUST appear on the GROUP BY clause
GROUP BY Student.StudentID, LastName
--to filter a group you will need to use the HAVING clause
-- you may use aggregates or other attributes on this clause
HAVING avg(Mark) >= 80 and count(*) >= 5
ORDER BY LastName
go
SELECT OfferingCode, avg(Mark), count(StudentID)
FROM Registration
GROUP BY OfferingCode
go