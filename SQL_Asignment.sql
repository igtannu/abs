USE AdventureWorks2017

--1. Display the number of records in the [SalesPerson] table. (Schema(s) involved: Sales)
SELECT Count(*) As "Number of Records"
FROM Sales.SalesPerson;

--2. Select both the FirstName and LastName of records from the Person table where the 
--    FirstName begins with the letter ‘B’. (Schema(s) involved: Person)
SELECT FirstName,LastName
FROM Person.Person 
WHERE FirstName LIKE 'B%';

--3. Display the Name and Color of the Product with the maximum weight. (Schema(s) involved: Production.Product)
SELECT Name, Color , weight AS "Maximum Weight"
FROM Production.Product
WHERE Weight=(SELECT MAX(Weight) FROM Production.Product)

--4. Display Description and MaxQty fields from the SpecialOffer table. Some of the MaxQty values are NULL, 
--    in this case display the value 0.00 instead. (Schema(s) involved: Sales. SpecialOffer)
SELECT Description, ISNULL(MaxQty,0.00)
AS MaxQty FROM Sales.SpecialOffer;

--5. Display the overall Average of the [CurrencyRate].[AverageRate] values for the exchange rate ‘USD’ to ‘GBP’ 
--    for the year 2011 i.e. FromCurrencyCode = ‘USD’ and ToCurrencyCode = ‘GBP’. Note: The field [CurrencyRate].[AverageRate] 
--     is defined as 'Average exchange rate for the day.' (Schema(s) involved: Sales.CurrencyRate)
SELECT AVG(AverageRate) 
AS 'Average exchange rate for the day'
FROM Sales.CurrencyRate
WHERE (FromCurrencyCode='USD' AND ToCurrencyCode='GBP') AND year(ModifiedDate)=2011

--6. Display the FirstName and LastName of records from the Person table where FirstName contains the letters ‘ss’.Display an 
--  additional column with sequential numbers for each row returned beginning at integer 1. (Schema(s) involved: Person)
SELECT ROW_NUMBER() 
OVER (ORDER BY FirstName ASC) 
AS Number,FirstName,LastName
FROM Person.Person
WHERE FirstName like '%ss%';

--7.Sales people receive various commission rates that belong to 1 of 4 bands. (Schema(s) involved: Sales)
--    CommissionPct	Commission Band
--      0.00          Band 0
--     Up To 1%	      Band 1
--     Up To 1.5%     Band 2
--    Greater 1.5%	  Band 3
--Display the [SalesPersonID] with an additional column entitled ‘Commission Band’ indicating the appropriate band as above.
--select * from Sales.SalesPerson
SELECT BusinessEntityID AS SalesPersonID,CommissionPct,
'Commission Band'= CASE WHEN CommissionPct=0 THEN 'Band 0'
                        WHEN CommissionPct>0 AND CommissionPct<=0.01 THEN 'Band 1'
						WHEN CommissionPct>0.01 AND CommissionPct<=0.015 THEN 'Band 2'
						WHEN CommissionPct>0.015 THEN 'Band 3' END
                        FROM Sales.SalesPerson
						ORDER BY CommissionPct

--8. Display the ProductId of the product with the second largest stock level. (Schema(s) involved: Production.Product)
SELECT ProductID,SafetyStockLevel From Production.Product 
WHERE SafetyStockLevel=(Select MAX(SafetyStockLevel) FROM Production.Product 
WHERE SafetyStockLevel not in (SELECT MAX(SafetyStockLevel) FROM Production.Product))

--9. Show the most recent five orders that were purchased from account numbers that have spent
--    more than $70,000 with AdventureWorks. (Schema(s) involved: Sales.SalesOrderHeader)
SELECT TOP 5 SalesOrderID ,OrderDate,AccountNumber, TotalDue As "TotalDue > 70000"
FROM Sales.SalesOrderHeader
--WHERE TotalDue>70000
ORDER BY OrderDate DESC

SELECT * FROM Sales.SalesOrderHeader

SELECT TOP 5 SalesOrderID,OrderDate ,  AccountNumber,SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY AccountNumber, OrderDate, SalesOrderID
--HAVING SUM(TotalDue) > 70000
ORDER BY OrderDate DESC;

--10. Create a stored procedure that accepts the name of a product and display its ID, number,
--   and availability. (Use the AdventureWorks database) (Schema(s) involved: Production.Product).

--Created procedure of Product name
Go
CREATE PROCEDURE Product @Name VARCHAR(50) --Here name of product is given by user input
 AS
 BEGIN
 SELECT ProductID,Name, ProductNumber,SafetyStockLevel --showing 4 following columns 
 FROM Production.Product
 WHERE Name=@Name
 END;    -- End of procedure

 SELECT Name AS "Following Products are Present" From Production.Product --To show what products are Avialabel

 Go                                    -- Execute Procedure for following Products (change name of product in '------')
 EXEC [dbo].[Product] @Name='Down Tube'
 EXEC [dbo].[Product] @Name='Chain'

 