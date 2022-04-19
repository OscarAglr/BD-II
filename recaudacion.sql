-- CREAR BD REPOSITORIO
CREATE DATABASE Repositorio
GO

-- Crear las tablas recaudacion y detalle de recaudacion

USE Repositorio
GO

CREATE TABLE Recaudacion(
IDRecaudacion int primary key identity(1,1),
Fecha date,
Año int,
Mes nvarchar(15),
CantidadOrdenes int,
SubTotal float,
Descuento float,
Impuesto float, 
Total float
)
GO
CREATE TABLE Detalle_Recaudacion(
IDRecaudacion int not null,
IDEmpleado int not null,
CantidadOrdenes int,
SubTotal float,
Descuento float,
Impuesto float, 
Total float
)
GO

ALTER TABLE Recaudacion
ADD  NombreBD NVARCHAR(100)

ALTER TABLE Detalle_Recaudacion
add primary key (IDRecaudacion, IDEmpleado)

ALTER TABLE Detalle_Recaudacion
ADD FOREIGN KEY (IDRecaudacion) REFERENCES Recaudacion(IDRecaudacion)

USE Northwind
GO
SELECT * FROM Orders where YEAR(OrderDate) = 2022
go

UPDATE ORDERS SET OrderDate = DATEADD(YEAR, 24, OrderDate) 
WHERE MONTH(OrderDate) = 5 AND YEAR(ORDERDATE) = 1998
GO

UPDATE ORDERS SET OrderDate = DATEADD(MONTH, -2, OrderDate) 
WHERE YEAR(ORDERDATE) = 2022
GO

CREATE PROCEDURE ACTUALIZAR_RECAUDACION01
AS
Select GETDATE() as Fecha,
YEAR(o.OrderDate) AS Año,
DATENAME(MONTH, o.OrderDate) AS Mes,
COUNT(distinct o.OrderID) As CantidadOrdenes,
sum(od.UnitPrice * od.Quantity ) as SubTotal, 
Round(sum(od.UnitPrice * od.Quantity * od.Discount), 2) as Descuento ,
SUM(distinct o.Freight) AS Impuesto,
Round(sum(od.UnitPrice * od.Quantity * (1-od.Discount)), 2) + SUM(distinct o.Freight) as Total,
'Northwind' As NombreBD
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] od
ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = MONTH(GETDATE()) - 1
AND YEAR(O.OrderDate) = YEAR(GETDATE())
GROUP BY YEAR(o.OrderDate), DATENAME(MONTH, o.OrderDate)
GO

USE Repositorio
GO

CREATE PROCEDURE ACTUALIZAR_RECAUDACION01
AS
Select GETDATE() as Fecha,
YEAR(o.OrderDate) AS Año,
DATENAME(MONTH, o.OrderDate) AS Mes,
COUNT(distinct o.OrderID) As CantidadOrdenes,
sum(od.UnitPrice * od.Quantity ) as SubTotal, 
Round(sum(od.UnitPrice * od.Quantity * od.Discount), 2) as Descuento ,
SUM(distinct o.Freight) AS Impuesto,
Round(sum(od.UnitPrice * od.Quantity * (1-od.Discount)), 2) + SUM(distinct o.Freight) as Total,
'Northwind' As NombreBD
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] od
ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = MONTH(GETDATE()) - 1
AND YEAR(O.OrderDate) = YEAR(GETDATE())
GROUP BY YEAR(o.OrderDate), DATENAME(MONTH, o.OrderDate)
GO

INSERT INTO Recaudacion
EXEC ACTUALIZAR_RECAUDACION01

SELECT * FROM Recaudacion

EXEC msdb.dbo.sp_send_dbmail
@recipients = 'basesdedatos.uni@gmail.com',
@Subject = 'Hola bro',
@query = 'Execute Repositorio.dbo.ACTUALIZAR_RECAUDACION01',
@attach_query_result_as_file = 1