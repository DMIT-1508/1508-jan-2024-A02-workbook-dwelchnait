use IQSchool

--DELETE

--Purpose 
-- used to remove one or more rows from a table
--DOES NOT reset the IDENTITY pkey to the original initial value IF
--   you delete all rows from the table
--To reset the IDENTITY pkey to the first original value you MUST
--	drop your table
--you CANNOT delete a parent row of its table if there are child record(s)
--	existing on the foreign key table
 ---
 -- syntax  DELETE [from] tablename
 --         [WHERE condition]

 INSERT INTO Position (PositionID, PositionDescription)
 VAlUES(10, 'President')

 DELETE Position
 WHERE PositionDescription = 'President'
