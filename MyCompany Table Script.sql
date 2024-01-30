-- the command to create a database is: CREATE DATABASE databasename
-- CREATE DATABASE MyCompany


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

-- you can drop tables within a create table script so that
--		the create script will runs without errors
-- order of dropping is IMPORTANT
-- foreign key tables MUST be dropped BEFORE the primary key table
--    referred to as child before parent
drop table ItemsOnOrder
drop table Items
drop table Orders
drop table Customers
go

-- tables MUST be created in the order of parent to child
--		thus primary keys NEED to exist BEFORE they can be used
--		as a foreign key
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
-- it is foreign keys that form the relationships between
--		tables
-- a foreign key on a table needs a constraint to indicate
--		that it is the field which the DBMS is to use
--		in managing FKey relationships
CREATE TABLE Orders
(
	OrderNumber int IDENTITY (5,1) NOT NULL
		CONSTRAINT PK_Orders_OrderNumber primary key,
	OrderDate datetime NOT NULL,
	SubTotal money NOT NULL,
	GST money NOT NULL,
	Total money NOT NULL,
	CustomerNumber int NOT NULL
		CONSTRAINT FK_OrdersCustomers_CustomerNumber foreign key
			references Customers(CustomerNumber)
)
go
CREATE TABLE Items
(
	ItemNumber int IDENTITY (1,1) NOT NULL
		CONSTRAINT PK_Items_ItemNumber primary key,
	Description varchar(150) NOT NULL,
	CurrentPrice money NOT NULL
)
go
-- this is a table with a compound primary key
-- the foreign keys point to the parent tables
-- the CONSTRAINT that will define the primary key
--		of this table is done as a table constraint
-- the CONSTRAINT on the foreign key is a column constraint
-- the difference between a column constraint and a table
--		constraint is that a column constraint refers ONLY
--		to the column the where constraint is attached; whereas
--		a table constraint MAY referred to multiple columns
--		and is coded at the end of the table definition

CREATE TABLE ItemsOnOrder
(
	ItemNumber int NOT NULL
		CONSTRAINT FK_ItemsOnOrderItems_ItemNumber foreign key
			references Items(ItemNumber),
	OrderNumber int NOT NULL
		CONSTRAINT FK_ItemsOnOrderOrders_OrderNumber foreign key
			references Orders(OrderNumber),
	Quantity int NOT NULL,
	Price money NOT NULL,
	Amount money NOT NULL,
	CONSTRAINT PK_ItemsOnOrder_ItemNumberOrderNumber
		primary key (ItemNumber,OrderNumber)
)
go