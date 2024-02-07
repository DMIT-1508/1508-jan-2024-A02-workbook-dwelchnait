use MyCompany
go
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
VALUES(3,'Canadian Classic Beef Burger',13.49)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(3,'Canadian Classic Beef Burger',13.49)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(3,'Canadian Classic Beef Burger',13.49)
INSERT INTO Items (ItemNumber, Description, CurrentPrice)
VALUES(3,'Canadian Classic Beef Burger',13.49)
SET IDENTITY_INSERT Items OFF