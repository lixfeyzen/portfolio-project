# Data Source

Dataset name: UCI Online Retail Dataset

The dataset contains retail transaction records with invoice numbers, product codes, product descriptions, quantities, invoice dates, unit prices, customer IDs, and countries.

Raw records used in this project: 541,909 transaction rows

Main fields:
InvoiceNo  
StockCode  
Description  
Quantity  
InvoiceDate  
UnitPrice  
CustomerID  
Country

The raw dataset was treated as operational data, not as a clean reporting table. Data quality checks were performed before building reporting views and dashboards.

Recommended raw table name in SQL Server:
`dbo.Online_Retail_Raw`

Recommended database name:
`Retail_Analytics_Portfolio`

The raw dataset is public. In the portfolio package, the dataset itself is not included to keep the repository lighter and easier to share.
