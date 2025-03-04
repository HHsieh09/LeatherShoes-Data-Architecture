--Create a Procedure to Extract Employee Data for Future Ease of Use
IF EXISTS ( SELECT * FROM SYS.OBJECTS
			WHERE OBJECT_ID = OBJECT_ID('ExtractEmployee')
			AND TYPE IN (N'P',N'PC'))
			DROP PROCEDURE ExtractEmployee
GO

CREATE PROCEDURE ExtractEmployee

@LastUpdateDate VARCHAR(10)

AS
BEGIN

SELECT ID EmployeeID, NAME, STORE_ID BranchID, FULL_TIME Fulltime, STATUS Status, MUTI_DUTY MultiDuty 
FROM LOGIN
--WHERE LAST_UPDATE_TIME > @LastUpdateDate

END
GO

--Create a Procedure to Extract Supplier Data for Future Ease of Use
IF EXISTS ( SELECT * FROM SYS.OBJECTS
			WHERE OBJECT_ID = OBJECT_ID('ExtractSupplier')
			AND TYPE IN (N'P',N'PC'))
			DROP PROCEDURE ExtractSupplier
GO

CREATE PROCEDURE ExtractSuppliesir

@LastUpdateDate VARCHAR(10)

AS
BEGIN

SELECT SUPPLY_ID SupplierID, SDESC SupplierName 
FROM SUPPLYMST
--WHERE LAST_UPDATE_TIME > @LastUpdateDate

END
GO