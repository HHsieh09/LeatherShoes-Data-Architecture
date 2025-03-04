CREATE OR REPLACE Procedure Createtables()
LANGUAGE plpgsql
AS $$
	
BEGIN

	--Create Time Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_time')
	THEN
		CREATE TABLE Dim_Time (
		TimeID INT NOT NULL PRIMARY KEY,
		FullTime TIME,
		HourOfDay SMALLINT,
		MinuteOfHour SMALLINT,
		SecondOfMinute SMALLINT,
		AmPm CHAR(2),
		TimeOfDayCategory VARCHAR(20)
		);
		RAISE NOTICE 'Created Dim_Time Table';
	ELSE
		RAISE NOTICE 'Dim_Time Table Exists';
	END IF;

	
	--Create Date Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_date')
	THEN
		CREATE TABLE Dim_Date (
		DateID INT NOT NULL PRIMARY KEY,
		FullDate DATE,
		AUFormatDate CHAR(10),
		USFormatDate CHAR(10),
		YearNumber SMALLINT,
		YearWeekNumber SMALLINT,
		YearDayNumber SMALLINT,
		AUFiscalYearNumber  SMALLINT,
		USFiscalYearNumber  SMALLINT,
		QTRNumber           SMALLINT,
		AUFiscalQTRNumber   SMALLINT,
		USFiscalQTRNumber   SMALLINT,
		MonthNumber         SMALLINT,
		MonthName           CHAR(9), 
		MonthDayNumber      SMALLINT, 
		WeekDayNumber       SMALLINT,
		DayName             CHAR(9), 
		DayIsWeekday        SMALLINT,  
		DayIsLastOfMonth    SMALLINT
		);
		RAISE NOTICE 'Created Dim_Date Table';
	ELSE
		RAISE NOTICE 'Dim_Date Table Exists';
	END IF;

	
	--Create Accounting Type Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_accountingtype')
	THEN
		CREATE TABLE Dim_AccountingType (
		AccountingTypeID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
		AccountingType VARCHAR(50)
		);
		RAISE NOTICE 'Created Dim_AccountingType Tables';
	ELSE
		RAISE NOTICE 'Dim_AccountingType Table Exists';
	END IF;

	
	--Create Employee Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_employee')
	THEN
		CREATE TABLE Dim_Employee (
		EmployeeID VARCHAR(100) NOT NULL PRIMARY KEY,
		Name VARCHAR(255),
		BranchID VARCHAR(50),
		FullTime VARCHAR(50),
		Status VARCHAR(50),
		MultiDuty VARCHAR(50)
		 );
		RAISE NOTICE 'Created Dim_Employee Tables';
	ELSE
		RAISE NOTICE 'Dim_Employee Table Exists';
	END IF;

	
	--Create Branch Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_branch')
	THEN
		CREATE TABLE Dim_Branch (
		BranchID VARCHAR(50) NOT NULL PRIMARY KEY,
		BranchName VARCHAR(255),
		Location VARCHAR(255),
		StoreType VARCHAR(50)
		 );
		RAISE NOTICE 'Created Dim_Branch Tables';
	ELSE
		RAISE NOTICE 'Dim_Branch Table Exists';
	END IF;

	
	--Create Supplier Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_supplier')
	THEN
		CREATE TABLE Dim_Supplier (
		SupplierID VARCHAR(10) NOT NULL PRIMARY KEY,
		SupplierName VARCHAR(255)
		 );
		RAISE NOTICE 'Created Dim_Supplier Tables';
	ELSE
		RAISE NOTICE 'Dim_Supplier Table Exists';
	END IF;


	--Create Size Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_size')
	THEN
		CREATE TABLE Dim_Size (
		SizeID INT NOT NULL PRIMARY KEY,
		Size VARCHAR(100)
		 );
		RAISE NOTICE 'Created Dim_Size Tables';
	ELSE
		RAISE NOTICE 'Dim_Size Table Exists';
	END IF;


	--Create Color Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_color')
	THEN
		CREATE TABLE Dim_Color (
		ColorID VARCHAR(50) NOT NULL PRIMARY KEY,
		ColorName VARCHAR(255)
		 );
		RAISE NOTICE 'Created Dim_Color Tables';
	ELSE
		RAISE NOTICE 'Dim_Color Table Exists';
	END IF;


	--Create Payment Method Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_paymentmethod')
	THEN
		CREATE TABLE Dim_PaymentMethod (
		PaymentMethodID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
		PaymentMethod VARCHAR(100)
		 );
		RAISE NOTICE 'Created Dim_PaymentMethod Tables';
	ELSE
		RAISE NOTICE 'Dim_PaymentMethod Table Exists';
	END IF;


	--Create Sales Category Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_salescategory')
	THEN
		CREATE TABLE Dim_SalesCategory (
		SalesCategoryID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
		SalesCategory VARCHAR(100)
		 );
		RAISE NOTICE 'Created Dim_SalesCategory Tables';
	ELSE
		RAISE NOTICE 'Dim_SalesCategory Table Exists';
	END IF;

	
	--Create Product Category Dimension Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'dim_productcategory')
	THEN
		CREATE TABLE Dim_ProductCategory (
		ProductCategoryID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
		ProductCategory VARCHAR(100)
		 );
		RAISE NOTICE 'Created Dim_ProductCategory Tables';
	ELSE
		RAISE NOTICE 'Dim_ProductCategory Table Exists';
	END IF;


	--Create Accounting Fact Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'fact_accounting')
	THEN
		CREATE TABLE Fact_Accounting (
		AccountingID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
		BranchID VARCHAR(50),
		EmployeeID VARCHAR(100),
		DateID INT,
		AccountingTypeID INT,
		Amount FLOAT,
		CONSTRAINT fk_Accounting_Branch FOREIGN KEY (BranchID) REFERENCES Dim_Branch (BranchID),
		CONSTRAINT fk_Accounting_Employee FOREIGN KEY (EmployeeID) REFERENCES Dim_Employee (EmployeeID),
		CONSTRAINT fk_Accounting_Date FOREIGN KEY (DateID) REFERENCES Dim_Date (DateID),
		CONSTRAINT fk_Accounting_AccountingType FOREIGN KEY (AccountingTypeID) REFERENCES Dim_AccountingType (AccountingTypeID)
		 );
		RAISE NOTICE 'Created Fact_Accounting Tables';
	ELSE
		RAISE NOTICE 'Fact_Accounting Table Exists';
	END IF;


	--Create Sales Fact Table
	IF NOT EXISTS (SELECT * FROM pg_tables WHERE schemaname = 'public' AND tablename = 'fact_sales')
	THEN
		CREATE TABLE Fact_Sales (
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
		QuantitySold INT,
		SalePrice FLOAT ,
		Cost FLOAT, --PLUSIZE
		TotalRevenue FLOAT, --(Quantity_Sold * Sale_Price)
		Profit FLOAT, --(Total_Revenue - Cost)
		CONSTRAINT fk_Sales_SoldBranch FOREIGN KEY (SoldBranchID) REFERENCES Dim_Branch (BranchID),
		CONSTRAINT fk_Sales_SalesPerson FOREIGN KEY (SalesPersonID) REFERENCES Dim_Employee (EmployeeID),
		CONSTRAINT fk_Sales_CreatedDate FOREIGN KEY (CreatedDateID) REFERENCES Dim_Date (DateID),
		CONSTRAINT fk_Sales_UpdatedDate FOREIGN KEY (UpdatedDateID) REFERENCES Dim_Date (DateID),
		CONSTRAINT fk_Sales_OrderDate FOREIGN KEY (OrderDateID) REFERENCES Dim_Date (DateID),
		CONSTRAINT fk_Sales_OrderTime FOREIGN KEY (OrderTimeID) REFERENCES Dim_Time (TimeID),
		CONSTRAINT fk_Sales_Size FOREIGN KEY (SizeID) REFERENCES Dim_Size (SizeID),
		CONSTRAINT fk_Sales_Color FOREIGN KEY (ColorID) REFERENCES Dim_Color (ColorID),
		CONSTRAINT fk_Sales_Supplier FOREIGN KEY (SupplierID) REFERENCES Dim_Supplier (SupplierID),
		CONSTRAINT fk_Sales_PaymentMethod FOREIGN KEY (PaymentMethodID) REFERENCES Dim_PaymentMethod (PaymentMethodID),
		CONSTRAINT fk_Sales_SalesCategory FOREIGN KEY (SalesCategoryID) REFERENCES Dim_SalesCategory (SalesCategoryID),
		CONSTRAINT fk_Sales_ProductCategory FOREIGN KEY (ProductCategoryID) REFERENCES Dim_ProductCategory (ProductCategoryID)
		 );
		RAISE NOTICE 'Created Fact_Sales Tables';
	ELSE
		RAISE NOTICE 'Fact_Sales Table Exists';
	END IF;
	
END;
$$