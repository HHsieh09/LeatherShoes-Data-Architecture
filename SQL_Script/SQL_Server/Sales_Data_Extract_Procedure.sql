--Create a Procedure to Extract Sales Data for Future Ease of Use


IF EXISTS ( SELECT * FROM SYS.OBJECTS
			WHERE OBJECT_ID = OBJECT_ID (N'ExtractSales')
			AND TYPE IN (N'P',N'PC'))
			DROP PROCEDURE ExtractSales
GO

CREATE PROCEDURE ExtractSales

@LastUpdateDate VARCHAR(10),
@LastUpdateTime VARCHAR(10)

AS
BEGIN

	IF OBJECT_ID('LeatherDB#Date_dimension', 'U') IS NOT NULL
	  DROP TABLE #Date_dimension;

	-- 1. Store the Requiring Date Data into a Temporary Table Named #Date_dimension
	BEGIN
	CREATE TABLE #Date_dimension (
		dateid INT NOT NULL PRIMARY KEY,
		fulldate DATE NOT NULL);
	PRINT('Create #Date_dimension Table');

	WITH Numbers AS (
		SELECT 0 AS number
		UNION ALL
		SELECT number + 1
		FROM Numbers
		WHERE number < 100 * 365
	),

	DATE_STAGE AS (SELECT
		DATEADD(day, Numbers.number, '2000-01-01') AS datum,
		Numbers.number AS seq
	FROM Numbers
	) 

	INSERT INTO #Date_dimension
	SELECT cast(seq + 1 AS INTEGER), DATUM 
	FROM
	-- Generate days for the next ~20 years starting from 2011.
	DATE_STAGE
	ORDER BY 1
	OPTION (MAXRECURSION 0);

END

BEGIN
	IF OBJECT_ID('LeatherDB#Date_dimension', 'U') IS NOT NULL
	  DROP TABLE #Date_dimension;

	-- 2. Store the Requiring Time Data into a Temporary Table Named #Time_dimension
	CREATE TABLE #Time_dimension (
		timeid INT NOT NULL PRIMARY KEY,
		fulltime VARCHAR(20) NOT NULL);
	PRINT('Create #Time_dimension Table');

	WITH Numbers AS (
    SELECT 0 AS number
    UNION ALL
    SELECT number + 1
    FROM Numbers
    WHERE number < 24 * 60 * 60 -- 24 hours * 60 minutes * 60 seconds
	)

	INSERT INTO #Time_dimension (timeid, fulltime)
	SELECT
		Numbers.number + 1 AS timeid,
		FORMAT(DATEADD(SECOND, Numbers.number, '00:00:00'), 'HH:mm:ss') AS fulltime
	FROM
		Numbers
	ORDER BY
		timeid
	OPTION (MAXRECURSION 0);

	-- Remember to remove last row
	DELETE FROM #Time_dimension WHERE timeid = 86401; 

END

BEGIN
	-- 3. Store the Requiring Sales Category Data into a Temporary Table Named #SalesCategory
	IF OBJECT_ID('LeatherDB#SalesCategory', 'U') IS NOT NULL
	  DROP TABLE #SalesCategory;

	CREATE TABLE #SalesCategory (
	SalesCategoryID INT NOT NULL PRIMARY KEY,
	SalesCategory VARCHAR(100));
	PRINT('Create #SalesCategory Table');

	INSERT INTO #SalesCategory(SalesCategoryID, SalesCategory) VALUES
	(1, 'Void'),
	(2, 'Exchange'),
	(3, 'Sales'),
	(4, 'Gift');

END

BEGIN
	-- 4. Store the Requiring Product Category Data into a Temporary Table Named #ProductCategory
	IF OBJECT_ID('LeatherDB#ProductCategory', 'U') IS NOT NULL
	  DROP TABLE #ProductCategory;

	CREATE TABLE #ProductCategory (
		ProductCategoryID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ProductCategory VARCHAR(100));
	PRINT('Create #ProductCategory Table');

	INSERT INTO #ProductCategory(ProductCategory)
	SELECT DISTINCT(ProductCategory) FROM SALE_VW;

END

BEGIN
	-- 5. Store the Requiring Size Data into a Temporary Table Named #Size
	IF OBJECT_ID('LeatherDB#Size', 'U') IS NOT NULL
	  DROP TABLE #Size;

	CREATE TABLE #Size (
		SizeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		Size VARCHAR(100));
	PRINT('Create #Size Table');

	INSERT INTO #Size(Size)
	SELECT DISTINCT(Size) FROM SALE_VW;

END

BEGIN
	-- 6. Store the Requiring Size Data into a Temporary Table Named #Size
	IF OBJECT_ID('LeatherDB#PaymentMethod', 'U') IS NOT NULL
	  DROP TABLE #PaymentMethod;

	CREATE TABLE #PaymentMethod (
		PaymentMethodiD INT NOT NULL PRIMARY KEY,
		PaymentMethod VARCHAR(100));
	PRINT('Create #PaymentMethod Table');

	INSERT INTO #PaymentMethod (PaymentMethodID, PaymentMethod) VALUES
	(1, 'Secret1'),
	(2, 'Secret2'),
	(3, 'Secret3'),
	(4, 'Secret4'),
	(5, 'Secret5'),
	(6, 'Secret6'),
	(7, 'Secret7'),
	(8, 'Secret8'),
	(9, 'Secret9'),
	(10, 'Secret10'),
	(11, 'Secret11'),
	(12, 'Secret12'),
	(13, 'Secret13'),
	(14, 'Secret14'),
	(15, 'Secret15'),
	(16, 'Secret16'),
	(17, 'Secret17'),
	(18, 'Secret18'),
	(19, 'Secret19'),
	(20, 'Secret20'),
	(21, 'Secret21'),
	(22, 'Secret22'),
	(23, 'Secret23'),
	(24, 'Secret24'),
	(25, 'Secret25'),
	(26, 'Secret26'),
	(27, 'Secret27'),
	(28, 'Secret28'),
	(29, 'Secret29'),
	(30, 'Secret30'),
	(31, 'Secret31'),
	(32, 'Secret32'),
	(33, 'Secret33'),
	(34, 'Secret34'),
	(35, 'Secret35');

END

BEGIN
	-- 7. Store the Requiring Size Data into a Temporary Table Named #Size
	IF OBJECT_ID('LeatherDB#PaymentMethod', 'U') IS NOT NULL
	  DROP TABLE #PaymentMethod;

	CREATE TABLE #SalesIntegrate (
	SalesID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	SoldBranchID VARCHAR(50),
	SalesPersonID VARCHAR(100),
	CreatedDateID INT,
	UpdatedDateID INT,
	OrderDateID INT,
	OrderTimeID INT,
	SizeID INT,
	ColorID VARCHAR(10),
	SupplierID VARCHAR(10),
	PaymentMethodID INT,
	SalesCategoryID INT,
	ProductCategoryID INT,
	SKUNO VARCHAR(20),
	QuantitySold FLOAT,
	SalePrice FLOAT ,
	COST FLOAT, --PLUSIZE
	Total_Revenue FLOAT, --(Quantity_Sold * Sale_Price)
	Profit FLOAT, --(Total_Revenue - Cost)
	);

	INSERT INTO #SalesIntegrate(SoldBranchID, SalesPersonID, CreatedDateID, UpdatedDateID, OrderDateID, OrderTimeID, SizeID, ColorID,
							SupplierID, PaymentMethodID, SalesCategoryID, ProductCategoryID, SKUNO, QuantitySold,
							SalePrice, COST, Total_Revenue, Profit)
	SELECT SS.SoldBranchID, SS.SalesPersonID, DD1.DateID CreatedDateID, DD2.DateID UpdatedDateID, DD3.DateID OrderDateID, TD.Timeid OrderTimeID, SZ.SizeID, SS.ColorID,
		SupplierID, PM.PaymentMethodID, SC.SalesCategoryID, PC.ProductCategoryID, SS.SKUNO, SS.QuantitySold, SS.SalePrice, SS.COST, SS.Total_Revenue, SS.Profit
	FROM (
	SELECT S.Branch SoldBranchID, UPPER(S.Employee) SalesPersonID, 
		CONVERT(DATE, CONVERT(VARCHAR(8), GETDATE(), 112)) CreatedDate, CONVERT(DATE, CONVERT(VARCHAR(8), GETDATE(), 112)) UpdatedDate, 
		S.Date OrderDate , S.Time OrderTime, S.Color ColorID, 
		SUBSTRING(S.SKUNO, 7, 2) SupplierID, S.PaymentMethod2 PaymentMethod, S.SalesCategory2 SalesCategory, S.ProductCategory2 ProductCategory, S.SKUNO SKUNO, S.�ؤo Size, S.Quantity QuantitySold, S.Sub SalePrice, P.COST1 COST, 
		ROUND((S.Quantity * S.Sub),2) Total_Revenue, ROUND(((S.Quantity * S.Sub) - P.COST1),2) Profit 
	FROM SALE_VW S
	JOIN PLUSIZE P ON S.SKUNO = P.SKUNO 
	) SS
	JOIN #date_dimension DD1 ON SS.CreatedDate = DD1.fulldate
	JOIN #date_dimension DD2 ON SS.UpdatedDate = DD2.fulldate
	JOIN #date_dimension DD3 ON SS.OrderDate = DD3.fulldate
	JOIN #time_dimension TD ON SS.OrderTime = TD.fulltime
	JOIN #SalesCategory SC ON SS.SalesCategory = SC.SalesCategory
	JOIN #ProductCategory PC ON SS.ProductCategory = PC.ProductCategory
	JOIN #PaymentMethod PM ON SS.PaymentMethod = PM.PaymentMethod
	JOIN #Size SZ ON SS.Size = SZ.Size
	ORDER BY OrderDate, OrderTime;
	--Since the server is located in other countries, you have to use the date in same time zone of the country in the WHERE clause
	--WHERE S.Date > @LastUpdateDate AND S.Time > @LastUpdateTime

END

END;
GO


-------------------------------------


SELECT * FROM #Date_dimension;
SELECT * FROM #Time_dimension;
SELECT * FROM #SalesCategory;
SELECT * FROM #ProductCategory;
SELECT * FROM #Size;
SELECT * FROM #PaymentMethod;


-------------------------------------



DROP TABLE #Time_dimension;
DROP TABLE #SalesCategory;
DROP TABLE #ProductCategory;
DROP TABLE #Size;
DROP TABLE #PaymentMethod;
DROP TABLE #SalesIntegrate;


-------------------------------------