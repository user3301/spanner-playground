select * from Customer 
where CustomerID in (select CustomerID from Sales where SalesID = 10000)

select * from Customer
left join Sales on Customer.CustomerID = Sales.CustomerID
where Sales.SalesID = 10000