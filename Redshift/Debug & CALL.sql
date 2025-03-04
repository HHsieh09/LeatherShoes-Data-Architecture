--Debug the Errors by Querying the Necessary Information
SELECT Start_Time, Column_Name, Error_Code, Error_Message FROM sys_load_error_detail
ORDER BY Start_Time DESC;


--Call Procdures to Possess a Fully Functional Database
CALL Createtables();
CALL CopyDatabase();


--Query to Check if the Data Loaded Successfully
select * from fact_sales
order by salesid;
select * from fact_accounting;
select * from dim_employee;
select * from dim_time;
select * from dim_supplier;
select * from dim_paymentmethod;
select * from dim_date;
select * from dim_color;
select * from dim_branch;
select * from dim_accountingtype;
select * from Dim_SalesCategory;
select * from dim_size;
select * from dim_ProductCategory;