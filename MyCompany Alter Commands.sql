-- Investigate the Alter Table Command

-- Add an mailing address  to the Customer table

ALTER TABLE Customers ADD City varchar(50) NULL

ALTER TABLE Customers ADD Province char(2) NULL
	CONSTRAINT CK_Customers_Province 
		CHECK(Province in ('BC', 'AB', 'SK', 'MN'))

ALTER TABLE Items ADD CONSTRAINT CK_Items_CurrentPrice
		CHECK (CurrentPrice >= 0.00)

ALTER TABLE Customers ADD 
	CONSTRAINT DF_Customers_Province DEFAULT 'AB' for Province

ALTER TABLE ItemsOnOrder DROP COLUMN Amount

-- Indexes
--basically normally applied to foreign keys
--the ON is the table that contains the foreign key
CREATE nonclustered INDEX IX_OrdersCustomers_CustomerNumber
	ON Orders(CustomerNumber)

--drop index IX_OrdersCustomers_CustomerNumber on Customers

--create  a foreign key index on a part of a compound key

CREATE nonclustered INDEX IX_ItemsOnOrdersItems_ItemNumber
	ON ItemsOnOrder(ItemNumber)