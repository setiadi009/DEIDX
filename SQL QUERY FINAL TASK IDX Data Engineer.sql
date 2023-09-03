CREATE DATABASE Staging_dwh

USE Staging_dwh

CREATE TABLE DimCustomer (
	CustomerId int NOT NULL,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	Age int NOT NULL,
	Gender varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	NoHp varchar(50) NOT NULL,
	CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId)
	)

CREATE TABLE DimProduct (
	ProductId int NOT NULL,
	ProductName varchar(255) NOT NULL,
	ProductCategory varchar(255) NOT NULL,
	ProductUnitPrice int NULL,
	CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId)
	)

CREATE TABLE DimStatusOrder(
	StatusId int NOT NULL,
	StatusOrder varchar (50) NOT NULL,
	StatusOrderDesc varchar(50) NOT NULL,
	CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusId)
	)

CREATE TABLE FactSalesOrder (
    OrderId int NOT NULL,
    CustomerId int NOT NULL,
    ProductId int NOT NULL,
    StatusId int NOT NULL,
    Quantity int NOT NULL,
    Amount int NOT NULL,
    OrderDate date NOT NULL,
    CONSTRAINT PK_FactSales PRIMARY KEY (OrderId),
    CONSTRAINT FK_DimSalesCustomer FOREIGN KEY (CustomerId) REFERENCES DimCustomer (CustomerId),
    CONSTRAINT FK_DimSalesProduct FOREIGN KEY (ProductId) REFERENCES DimProduct (ProductId),
    CONSTRAINT FK_DimSalesStatus FOREIGN KEY (StatusId) REFERENCES DimStatusOrder (StatusId)
);

ALTER TABLE DimCustomer
ALTER COLUMN LastName varchar(50) NULL

SELECT * FROM DimCustomer
SELECT * FROM DimProduct
SELECT * FROM DimStatusOrder
SELECT * FROM FactSalesOrder;

CREATE PROCEDURE summary_order_status
	(@StatusID int)
AS
BEGIN
    SELECT
        f.OrderId AS OrderID,
        c.FirstName AS CustomerName,
        p.ProductName AS ProductName,
        f.Quantity AS Quantity,
        s.StatusOrder AS StatusOrder
    FROM
        FactSalesOrder f
    INNER JOIN
        DimCustomer c ON f.CustomerId = c.CustomerId
    INNER JOIN
        DimProduct p ON f.ProductId = p.ProductId
    INNER JOIN
        DimStatusOrder s ON f.StatusId = s.StatusId
    WHERE
        s.StatusId = @StatusID;
END;

EXEC summary_order_status 3