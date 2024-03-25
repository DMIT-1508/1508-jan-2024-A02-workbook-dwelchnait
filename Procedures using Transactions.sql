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
		IF not EXISTS (Select 'x' FROM Offering WHERE OfferingCode = @offeringcode)
		BEGIN
			-- substituting a value for a placehoder in your error message
			-- %i for a number
			-- %s for a string
			--syntax: RAISERROR('some messsage value "%s" is incorrect.',16,1,stringvalue)
			RAISERROR('Offering Code "%i" is not on file',16,1,@offeringcode)
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
				--at this point validation of incoming parameters
				--	and business rules have been completed
				--the data is deem valid to continue
				--the first physical change to the database
				--	will happen on the first DML statment
				--THIS IS THE BEGINNING OF THE LUW
				--ONCE the transaction has been started
				--EITHER a ROLLBACK or COMMIT MUST be eventually executed
				BEGIN TRANSACTION
				INSERT INTO Registration(OfferingCode, StudentID, Mark, WithdrawYN)
				VALUES (@offeringcode, @studentid, null, null)
				SELECT @error = @@error, @rowcount = @@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Registration has failed. Student is already registered for the offering',16,1)
					ROLLBACK TRANSACTION --terminate the current transaction
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
						ROLLBACK TRANSACTION --terminate the current transaction

					END
					ELSE
					BEGIN
						IF @rowcount = 0
						BEGIN
							RAISERROR('No records were update.',16,1)
							ROLLBACK TRANSACTION --terminate the current transaction
						END
						ELSE
						BEGIN
							COMMIT TRANSACTION
							SELECT BalanceOwing
							FROM Student
							WHERE StudentID = @studentid
						END -- update changed a record
					END --update attempted
				END  --student registered in offerring
			END -- max size full
		END ---EOF OFFERING
	END --EOF STUDENT
END --EOF PARAM
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
GO

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

--Create a procedure called ‘StudentPaymentTransaction’  that 
--accepts Student ID and paymentamount as parameters. 
--Add the payment to the payment table and adjust the students 
--balance owing to reflect the payment.
--payment was with MasterCard (4)

DROP PROCEDURE IF EXISTS StudentPaymentTransaction
go
CREATE PROCEDURE StudentPaymentTransaction(@studentid int = null,
								           @payment smallmoney = null)
AS
DECLARE @maxSize int,
		@currentSize int,
		@error int,
		@rowcount int,
		@tempPaymentId int

IF (@studentid is null or @payment is null)
BEGIN
	RAISERROR('You must provide values for studentid and payment',16,1)
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
		IF @payment < 0
		BEGIN
			-- substituting a value for a placehoder in your error message
			-- %i for a number
			-- %s for a string
			--syntax: RAISERROR('some messsage value "%s" is incorrect.',16,1,stringvalue)
			RAISERROR('Payment must be a valid positive number',16,1)
		END
		ELSE
		BEGIN
		--since the payment table does NOT have an identity pkey
		--manufacture the next available pkey value
			SELECT @tempPaymentId = MAX(PaymentID) + 1 FROM Payment
			BEGIN TRANSACTION
			INSERT INTO Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
			VALUES(@tempPaymentId, GETDATE(),@payment, 4, @studentid)
			SELECT @error = @@ERROR, @rowcount =@@ROWCOUNT
			IF @error <> 0
			BEGIN
				RAISERROR('Payment was not saved',16,1)
				ROLLBACK TRANSACTION
			END
			ELSE
			BEGIN
				UPDATE Student
				SET BalanceOwing = BalanceOwing - @payment
				WHERE StudentID = @studentid
				SELECT @error = @@ERROR, @rowcount =@@ROWCOUNT
				IF @error <> 0
				BEGIN
					RAISERROR('Student balance not updated, failed',16,1)
					ROLLBACK TRANSACTION
				END
				ELSE
				BEGIN
					IF @rowcount = 0
					BEGIN
						RAISERROR('Student balance not changed',16,1)
						ROLLBACK TRANSACTION
					END
					ELSE
					BEGIN
						--everything is assumed successful at this point in time
						COMMIT TRANSACTION
					END
				END
			END
		END ---EOF payment
	END --EOF STUDENT
END --EOF PARAM
RETURN
exec StudentPaymentTransaction
go
exec StudentPaymentTransaction 19999999,1000 -- no student
go
exec StudentPaymentTransaction 199912010, -100 --no bad payment
GO
exec StudentPaymentTransaction 200522220, 700.00 
go