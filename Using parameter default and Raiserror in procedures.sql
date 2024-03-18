use IQSchool
go

-- all parameters in this solution will have a default of null
-- all parameters will be checked to see if a value was passed
--		if no value was passed; raise an error with an appropriate message
-- all DML statements will be check for successful execution
--		if there is a error; raise an error with an appropriate message
--      if there is no error AND no alteration to the database;
--			raise an error with an appropriate message

--Create a stored procedure called ‘AddClub’ 
--to add a new club record.

-- fields? ClubId and ClubName
-- Note: ClubId is the pkey BUT it is not an identity
--		 Therefore we must supply the ClubId

DROP Procedure IF EXists AddClub
go

CREATE PROCEDURE AddClub(@clubid varchar(10) = null, 
						 @clubname varchar(50) = null)
AS
-- declare any local variables that are not parameters
DECLARE @error int, @rowcount int

-- check that values have been passed to the procedure
IF (@clubid is null or @clubname is null)
BEGIN
	--you might do a PRINT but this does not go the the calling
	--		application
	RAISERROR('You must provide values for both clubid and clubname',16,1)
END
ELSE
BEGIN
	--code the DML statement to add a record to the database
	--this is a transaction: it is an implied transaction
	--this transaction will either work or fail
	--this transaction DOES NOT need the BEGIN TRANS/ROLLBACK/COMMIT
	--		as it is affecting only one table, one record
	INSERT INTO Club(ClubId, ClubName)
	VALUES(@clubid,@clubname)

	--the @@error and @@rowcount is the result of the insert
	--		NOT the result of the SELECT

	SELECT @error = @@error, @rowcount = @@rowcount 

	--check the success of your dml command
	--the global variable
	--		@@error indicates your success: 0 is good
	--      @@rowcount inicates the number of rows affected
	IF @error != 0
	BEGIN
		RAISERROR('Insert to Club table failed.',16,1)
	END
	ELSE
	BEGIN
		-- since the insert will either work (1 row affected) or
		--		abort (@@error some value besides 0)
		--therefore no @@rowcount test is needed
		--HOWEVER, if you do wish to do a row count test than:
		IF @ROWCOUNT = 0
		BEGIN
			RAISERROR('Data was not inserted into the table.',16,1)
		END
	END
END
RETURN
go

exec AddClub --should be an error
go

exec AddClub 'bob'

go

exec AddClub 'bob1', 'is your uncle'
go

--Create a stored procedure called ‘DeleteClub’ to delete a club record.
DROP PROCEDURE IF EXISTS DeleteClub
go
CREATE PROCEDURE DeleteClub (@clubid varchar(10) = null)
AS
DECLARE @error int, @rowcount int
IF @clubid is null
BEGIN
	RAISERROR('You must supplied the clubid to remove',16,1)
END
ELSE
BEGIN
	DELETE Club
	where ClubId = @clubid

	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

	IF @error != 0
	BEGIN
		RAISERROR('Club removal has failed.',16,1)
	END
	ELSE
	BEGIN
		-- on the Delete if there is no system problem you
		--		need to check if anything was actually deleted
		-- your filter on the dml may not have found anything
		--		to delete
		-- NOTE: this situation does NOT cause an abort.
		-- Instead: it is considered a valid delete but no records affected
		IF @rowcount = 0
		BEGIN
			RAISERROR('Club removal has failed. Club id not found',16,1)
		END
	END
END
RETURN
go

exec DeleteClub 
go
exec DeleteClub 'Mary'
go
exec DeleteClub 'bob'
go

--Create a stored procedure called ‘Updateclub’ to update a club record. 
--Do not update the primary key!

DROP Procedure IF EXists UpdateClub
go

CREATE PROCEDURE UpdateClub(@clubid varchar(10) = null, 
						 @clubname varchar(50) = null)
AS
DECLARE @error int, @rowcount int

IF (@clubid is null or @clubname is null)
BEGIN
	RAISERROR('You must provide values for both clubid and clubname',16,1)
END
ELSE
BEGIN
	--one could test to see it the clubid is currently on the table
	--	before actually attempting the update
	--one coult also do a business rule: Club names need to be unique
	IF not EXISTS (SELECT 'x' FROM Club Where ClubId = @clubid)
	BEGIN
		RAISERROR('Club id does not exist on the table.',16,1)
	END
	ELSE
	BEGIN
		UPDATE Club
		SET ClubName = @clubname
		WHERE ClubId = @clubid

		SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
		IF @error != 0
		BEGIN
			RAISERROR('Club update has failed.',16,1)
		END
		ELSE
		BEGIN
			IF @rowcount = 0
			BEGIN
				RAISERROR('Club update has not alter any rows on the table.',16,1)
			END
		END

	END
END
RETURN
go

exec UpdateClub
go
exec UpdateClub 'bob', 'is your aunt'
go
exec UpdateClub 'bob1', 'this time it worked'
go

--Create a stored procedure called ‘ClubMaintenance’. 
--It will accept parameters for both ClubID and ClubName as well as a 
--parameter to indicate if it is an insert, update or delete. 
--This parameter will be ‘I’, ‘U’ or ‘D’.  
--Insert, update, or delete a record accordingly. 
--Focus on making your code as efficient and maintainable as possible


--Create a stored procedure called ‘RegisterStudent’ that accepts 
--StudentID and OfferingCode as parameters. 
--If the number of students in that Offering is not greater than the 
--Max Students for that course, add a record to the Registration table 
--and add the cost of the course to the student’s balance. 
--If the registration would cause the Offering to have greater than the 
--MaxStudents raise an error