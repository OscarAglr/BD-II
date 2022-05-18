Use Northwind
go

Create view DimCustomers 
as
Select * from Customers
GO
CREATE VIEW DimEmployees
as
Select * from Employees
go
CREATE VIEW DimShipper
as
Select * from Shippers
GO
CREATE VIEW DimDate
as
Select distinct OrderDate as DateID,
YEAR(OrderDate) as A�o, 
MONTH(OrderDate) as NoMes,
DATENAME(WEEKDAY, OrderDate) as [Nombre del d�a],
DAY (OrderDate) as NoD�a, 
DATEPART(QQ, Orderdate) as Trimestre,
datepart(WEEKDAY, Orderdate) as D�aSemana
from Orders
GO

Select 
CustomerID, EmployeeID, ShipVia, o.OrderID, o.orderdate,
count(distinct o.OrderID) as Cantidad,
round(sum(od.quantity * od.unitprice ), 2) as Subtotal,
round(sum(od.quantity * od.unitprice * od.discount), 2) as Descuento,
round(sum(od.quantity * od.unitprice *(1- od.discount)), 2) as Total
from Orders o
inner join [Order Details] od
on od.OrderID = o.OrderID
group by CustomerID, EmployeeID, ShipVia, o.orderdate, o.orderid