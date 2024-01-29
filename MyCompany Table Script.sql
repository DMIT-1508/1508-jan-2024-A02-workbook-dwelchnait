-- the use command will indicate which item to use
--    at this point in time
-- use databasename, will switch to the named database

-- the file that contains the commands that you wish
--    to execute as a series of commands is called
--    a script

-- some commands within sql script file MUST be executed
--		on their own
-- script commands can be place inside an area called
--		a batch

-- sql executes batch(es)
-- to get sql to execute a batch use the go command
use MyCompany
go

-- each create table MUST be in its own batch
CREATE TABLE Customers
(
	CustomerNumber int IDENTITY (1,1) NOT NULL
		CONSTRAINT PK_Customers_CustomerNumber primary key,
	LastName varchar(50) NOT NULL,
	FirstName varchar(20) NOT NULL,
	Phone varchar(14) NULL
)
go
