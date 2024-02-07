use MyCompany
go
-- the DELETE command will remove records from a table
DELETE ItemsOnOrder
DELETE Orders
DELETE Items
DELETE Customers
go
--
--
--  GOOD inserts into the database
--
-- the SET IDENTITY_INSERT is a special command that will allow
--		one to override the IDENTITY of a primary key specifying
--		your own primary key value. 
--	this is useful when wanting to preset the data in your tables
--		and ensure the foreign key values of the "child" table
--		are present as a primary key value on the "parent" table.
--	Note the INSERT statement MUST now list the attributes receiving
--		input values INCLUDING the primary key attribute
SET IDENTITY_INSERT Customers ON
INSERT INTO Customers (CustomerNumber, LastName, FirstName, Phone, City, Province)
VALUES(1,'Ujest','Shirely','780-786-5445','Edmonton','AB')
INSERT INTO Customers (CustomerNumber, LastName, FirstName, Phone, City, Province)
VALUES(2,'Behold','Lowan','548-676-5345','Hinton','AB')
INSERT INTO Customers (CustomerNumber, LastName, FirstName, Phone, City, Province)
VALUES(3,'Kase','Charite','604-286-5555','Fernie','BC')
SET IDENTITY_INSERT Customers OFF
go
SET IDENTITY_INSERT Items ON
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(3,'Canadian Classic Beef Burger',23.49)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(13,'Butter Chicken Curry',26.49)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(32,'Statium Rib Eye Streak',43.89)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(44,'MudSlinger Fudge Pie',11.29)
SET IDENTITY_INSERT Items OFF
go
Alter TABLE Orders Nocheck Constraint CK_Orders_OrderDate
go
SET IDENTITY_INSERT Orders ON
INSERT INTO Orders (OrderNumber, OrderDate, ShippedDate, SubTotal, GST, Total, CustomerNumber)
VALUES(123,'2023-05-23','2023-05-24',64.27,3.21,67.48,2)
INSERT INTO Orders (OrderNumber, OrderDate, ShippedDate, SubTotal, GST, Total, CustomerNumber)
VALUES(721,'2024-01-23','2024-01-26',249.46,12.47,261.93,2)
INSERT INTO Orders (OrderNumber, OrderDate, ShippedDate, SubTotal, GST, Total, CustomerNumber)
VALUES(801,GETDATE(),GETDATE(),43.89,2.19,46.08,1)
SET IDENTITY_INSERT Orders OFF
go
Alter TABLE Orders check Constraint CK_Orders_OrderDate
go
--
-- Note this set of records do NOT need the SET IDENTITY_INSERT
--			because the primary key fields are NOT IDENTITY fields
--		However, the values for the compound primary key MUST
--			exist in the "parent" table as primary key values
--
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(13,123,2,26.49)
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(44,123,1,11.29)
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(13,721,2,26.49)
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(3,721,5,23.49)
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(44,721,7,11.29)
INSERT INTO ItemsOnOrder (ItemNumber,OrderNumber, Quantity, Price)
VALUES(32,801,1,43.89)
go

--
--
-- BAD records caught by check constraints
--
--
