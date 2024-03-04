--Insert

--PUrpose
--is to add a record(s) to a table

--Knowledge
-- type of primary key
-- IF NON-IDENTITY you MUST supply the pkey value
-- IF an IDENTITY you DO NOT normally supply the pkey
--         the pkey is generated by the system
--         the generation of the value is dependent on the (seed, increment)
--     OPTIONALLY: you CAN supply the pkey value using a special technique
--                 that turns off the identity generation , allows the insert,
--                 then turns on the identity generation again.
--                 (see an example for the data for MyCompany)

--Single record
--adding a record to Staff
-- Staff has a NON-IDENTITY pKey
--ARE the table columns required?
-- NO
--  the columns are optional ,however, if you omit the columns the order
--		the values MUST match the order of the columns on the table
-- If columns supplied
--  the order of the values on the insert MUST match the order of the
--      columns as specified on the INSERT command

--Are values required?
--  Any column that has a default CAN be omitted from the list and NO values
--      is supplied, in which case, the default is activated
--  Any column that is nullable can have a value of null used if there is no
--      data to be supplied
-- Value datatype MUST match the table attribute datatype

--COURSE STANDARDS
-- You WILL supplied a list of column being used for the insert

use IQSchool
go

INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID ) 
VALUES (11, 'Don', 'Welch', '1986-01-06',null,4,null )
go
INSERT INTO Staff ( DateReleased, StaffID, DateHired, PositionID,  FirstName, LastName,LoginID ) 
VALUES (null, 12,'1986-01-06', 5,'Shirley', 'Ujest', null )

INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID ) 
VALUES (13, 'Pat', 'Downe', '1986-01-06',null, 
          (SELECT PositionID FROM Position WHERE PositionDescription = 'Assistant Dean' ),null )
go
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID ) 
VALUES (14, 'Jerry', 'Kan', '1986-01-06',null,4,null),
        (15, 'Lowan', 'Behold', '2003-05-06',null, 5,null)
go
INSERT INTO Staff (StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID ) 
VALUES (14, 'bad', 'pkey', '1986-01-06',null,4,null),
        (16, 'good', 'pkey', '2003-05-06',null, 5,null)
go
use MyCompany
go
--use the Items table
--this has an IDENTITY pkey
-- you DO NOT include the pkey fields as an insert value
-- REMEMBER the system will generate the pkey value for you on successful insertion

-- IF your insertion was NOT work, the pkey value could still have be assigned to
--    the system as if in use. This will in effect, create HOLES within your pkey
--    list of values.
INSERT INTO Items (Description, CurrentPrice)
VALUES('Baby Back Ribs, Full Rack', 27.89)
INSERT INTO Items (Description, CurrentPrice)
VALUES('Baby Back Ribs, Half Rack', -17.89)
INSERT INTO Items (Description, CurrentPrice)
VALUES('Pork Ribs, Full Rack', 27.89)