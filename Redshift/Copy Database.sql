CREATE OR REPLACE Procedure CopyDatabase()
LANGUAGE plpgsql
AS $$

BEGIN

    --Copy Accounting Type Dimension Table
    COPY Dim_AccountingType
    FROM 's3://leathershoesproject/processed/Dim_AccountingType.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Payment Method Dimension Table
    COPY Dim_PaymentMethod
    FROM 's3://leathershoesproject/processed/Dim_PaymentMethod.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Branch Dimension Table
    COPY Dim_Branch
    FROM 's3://leathershoesproject/processed/Dim_Branch.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Color Dimension Table
    COPY Dim_Color
    FROM 's3://leathershoesproject/processed/Dim_Color.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Employee Dimension Table
    COPY Dim_Employee
    FROM 's3://leathershoesproject/processed/Dim_Employee.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Supplier Dimension Table
    COPY Dim_Supplier
    FROM 's3://leathershoesproject/processed/Dim_Supplier.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Date Dimension Table
    COPY Dim_Date
    FROM 's3://leathershoesproject/processed/Dim_Date.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    DATEFORMAT 'MM/DD/YYYY'
    IGNOREHEADER 1
    removequotes;

    --Copy Product Category Dimension Table
    COPY Dim_ProductCategory
    FROM 's3://leathershoesproject/processed/Dim_ProductCategory.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Sales Category Dimension Table
    COPY Dim_SalesCategory
    FROM 's3://leathershoesproject/processed/Dim_SalesCategory.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Size Dimension Table
    COPY Dim_Size
    FROM 's3://leathershoesproject/processed/Dim_Size.csv'
    iam_role 'arn:aws:iam::40.....'
    FILLRECORD
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Time Dimension Table
    COPY Dim_Time
    FROM 's3://leathershoesproject/processed/Dim_Time.csv'
    iam_role 'arn:aws:iam::40.....'
    FILLRECORD
    delimiter ','
    IGNOREHEADER 1
    removequotes;

    --Copy Sales Fact Table
    COPY Fact_Sales
    FROM 's3://leathershoesproject/processed/Fact_Sales.csv'
    iam_role 'arn:aws:iam::40.....'
    delimiter ','
    IGNOREHEADER 1
    removequotes;


END;
$$