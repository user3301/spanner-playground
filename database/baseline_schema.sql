CREATE TABLE Customer (
    CustomerID INT64 NOT NULL,
    CustomerName STRING(20) NOT NULL,
) PRIMARY KEY(CustomerID);

CREATE TABLE Sales (
    SalesID INT64 NOT NULL,
    CustomerID INT64 NOT NULL,
) PRIMARY KEY(SalesID, CustomerID);
