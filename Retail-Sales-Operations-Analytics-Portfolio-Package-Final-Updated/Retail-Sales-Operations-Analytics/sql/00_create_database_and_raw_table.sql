/* 
Retail Sales & Operations Analytics
00_create_database_and_raw_table.sql

Purpose:
Create the portfolio database and a raw table structure for the UCI Online Retail CSV.

Note:
If the CSV has already been imported through SSMS Import Flat File Wizard,
you do not need to run the CREATE TABLE section again.
*/

IF DB_ID('Retail_Analytics_Portfolio') IS NULL
BEGIN
    CREATE DATABASE Retail_Analytics_Portfolio;
END;
GO

USE Retail_Analytics_Portfolio;
GO

IF OBJECT_ID('dbo.Online_Retail_Raw', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Online_Retail_Raw (
        InvoiceNo   NVARCHAR(20)  NULL,
        StockCode   NVARCHAR(50)  NULL,
        Description NVARCHAR(255) NULL,
        Quantity    INT           NULL,
        InvoiceDate NVARCHAR(30)  NULL,
        UnitPrice   NVARCHAR(30)  NULL,
        CustomerID  NVARCHAR(20)  NULL,
        Country     NVARCHAR(100) NULL
    );
END;
GO
