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
DROP Procedure IF EXists ClubMaintenance
go

CREATE PROCEDURE ClubMaintenance(@clubid varchar(10) = null, 
								@clubname varchar(50) = null,
								@type char(1) = null)
AS
DECLARE @error int, @rowcount int
DECLARE @exists bit
DECLARE @errormsg varchar(150)

IF (@clubid is null or @clubname is null or @type is null)
BEGIN
	RAISERROR('You must provide values for clubid, clubname and the type of maintenance (I,U or D)',16,1)
END
ELSE
BEGIN
	IF @type not in ('I', 'U', 'D')
	BEGIN
		RAISERROR('The type of maintenance must be (I,U or D)',16,1)
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 'x'
					FROM Club
					WHERE ClubId = @clubid)
		BEGIN
			SET @exists = 1 --true
		END
		ELSE
		BEGIN
			SET @exists = 0 --false
		END

		IF @type = 'I'
		BEGIN
			--INSERT, clubid should not exist
			IF @exists = 1
			BEGIN
				SET @errormsg ='Clubid ' + @clubid + ' already is on the database. Insert fails'
				RAISERROR(@errormsg,16,1)
			END
			ELSE
			BEGIN
				exec AddClub @clubid,@clubname
			END
		END
		ELSE
		BEGIN
			IF @exists = 0
			BEGIN
				SET @errormsg ='Clubid ' + @clubid + '  not on the database. Update/Delete fails'
				RAISERROR(@errormsg,16,1)
			END
			ELSE
			BEGIN
				IF @type = 'U'
				BEGIN
					exec UpdateClub @clubid,@clubname
				END
				ELSE
				BEGIN
					exec DeleteClub @clubid
				END
			END
		END
	END
END
RETURN
go
exec ClubMaintenance
go
exec ClubMaintenance 'bob1','is your uncle','g'
go
exec ClubMaintenance 'bob1','is your uncle','I'
go
exec ClubMaintenance 'bobisgood','is your good uncle','I'
go
exec ClubMaintenance 'bobbad','is your uncle','U'
go
exec ClubMaintenance 'bobbad','is your uncle','D'
go
exec ClubMaintenance 'bob1','is your cousin','U'
go
exec ClubMaintenance 'bob1','unecessary parameter value','D'
go
--Create a stored procedure called ‘RegisterStudent’ that accepts 
--StudentID and OfferingCode as parameters. 
--If the number of students in that Offering is not greater than the 
--Max Students for that course, add a record to the Registration table 
--and add the cost of the course to the student’s balance. 
--If the registration would cause the Offering to have greater than the 
--MaxStudents raise an error

DROP PROCEDURE IF EXISTS RegisterStudent
go
CREATE PROCEDURE RegisterStudent(@studentid int = null, @offeringcode int = null)
AS
DECLARE @maxSize int,
		@currentSize int,
		@error int,
		@rowcount int

IF (@studentid is null or @offeringcode is null)
BEGIN
	RAISERROR('You must provide values for studentid and offeringcode',16,1)
END
ELSE
BEGIN
	IF not EXISTS (Select 'x' FROM STUDENT WHERE StudentID = @studentid)
	BEGIN
		-- substituting a value for a placehoder in your error message
		-- %i for a number
		-- %s for a string
		--syntax: RAISERROR('some messsage value "%s" is incorrect.',16,1,stringvalue)
		RAISERROR('Student "%i" is not registered in the school',16,1,@studentid)
	END
	ELSE
	BEGIN
		-- one could also validate that the offering code exists
		SELECT @maxSize = MaxStudents
		FROM Course
		WHERE CourseId in (SELECT CourseId
							FROM Offering
							WHERE OfferingCode = @offeringcode)

	    SELECT @currentSize = COUNT(OfferingCode)
		FROM Registration 
		WHERE OfferingCode = @offeringcode
		  AND WithdrawYN != 'Y'

		IF @currentSize = @maxSize
		BEGIN
			RAISERROR('Offering is full',16,1)
		END
		ELSE
		BEGIN
			INSERT INTO Registration(OfferingCode, StudentID, Mark, WithdrawYN)
			VALUES (@offeringcode, @studentid, null, null)
			SELECT @error = @@error, @rowcount = @@ROWCOUNT
			IF @error <> 0
			BEGIN
				RAISERROR('Registration has failed. Student is already registered for the offering',16,1)
			END
			ELSE
			BEGIN
				UPDATE Student
				Set BalanceOwing = BalanceOwing +
							(Select CourseCost
							 FROM Course c inner join Offering o
								on c.CourseId = o.CourseId
							 WHERE o.OfferingCode = @offeringcode)
				WHERE StudentID = @studentid
				SELECT @error = @@error, @rowcount = @@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Update of student outstanding balance has failed.',16,1)
				END
				ELSE
				BEGIN
					IF @rowcount <> 0
					BEGIN
						RAISERROR('No records were update.',16,1)
					END
					ELSE
					BEGIN
						SELECT BalanceOwing
						FROM Student
						WHERE StudentID = @studentid
					END
				END
			END
		END
	END
END
RETURN
go
--dmit1508 change MaxStudents to 25 (allows an entry) Offering 1001
UPDATE Course
SET MaxStudents = 25
WHERE CourseId = 'DMIT1508'
go
--dmit1514 8 change MaxStudents to 8 be full Offering 1000
UPDATE Course
SET MaxStudents = 8
WHERE CourseId = 'DMIT1514'
go
exec RegisterStudent
go
exec RegisterStudent 19999999,1000 -- no student
go
exec RegisterStudent 199912010, 2001 --no offering
go
exec RegisterStudent 199912010, 1000 --full
go
exec RegisterStudent 199912010, 1001 --already registered
go
--good run 
-- old balance 0.00 new balance 675.00 for Joe Petroni
-- Registration record (probably line 15 in a Select) 1001,200522220,NULL,N
exec RegisterStudent 200522220, 1001 
go
--reset data
UPDATE Student
SET BalanceOwing = 0.00
WHERE StudentID = 200522220
go
DELETE Registration
WHERE StudentID = 200522220 and OfferingCode = 1001
go