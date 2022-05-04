-- Crear la BD Repositorio
Create database RepositorioBD
go
-- Crear las tablase Recaudación y detalle de Recaudación

Use RepositorioBD
go
Create table Recaudacion
(IdRecaudacion int primary key identity(1,1),
 NombreBD varchar(50),
 Fecha date,
 Año int, 
 Mes varchar(15),
 CantidadOrdenes int,
 SubTotal float,
 Descuento float,
 Impuesto float,
 Total float)
go
Create table DetalleRecaudacion
(IdRecaudacion int not null,
 IdEmpleado int not null,
 CantidadOrdenes int,
 SubTotal float,
 Descuento float,
 Impuesto float,
 Total float)
 go

use RepositorioBD
GO
-- Northwind
/*Procedimiento almacenado que añade los datos de las bases de datos 
Northwind, Neptuno y Adventures a la base de datos RepositorioBD */
alter procedure ActualizaRecaudacion
 as
 BEGIN

 -- Northwind
 Declare @ID int
  Select 
 'Northwind' as NorthwindBD,
 getdate() as Fecha,
  year(Orderdate) as Año,
 datename(month, orderdate) as Mes,
 count(Distinct O.OrderID) as Cantidad,
 Sum(od.Quantity * od.UnitPrice) as SubTotal,
 Sum(od.Quantity * od.UnitPrice * od.Discount) as Descuento,
 sum(Distinct o.Freight) as ImpuestoEnvío,
 Sum((od.Quantity * od.UnitPrice) * (1- od.Discount))
 +sum(Distinct o.Freight) Total
 -----------------------------------------
 from Northwind.dbo.Orders o
 inner join Northwind.dbo.[Order Details] od
 on od.OrderID = o.OrderId
 where year(Orderdate) = year(getdate())
 and month(Orderdate) = month(getdate()) -1
 Group by 
 year(Orderdate),
 datename(month, orderdate)
 ----------------------------------------------------------------
 Insert into Recaudacion 
  Select 
 'Northwind' as NorthwindBD,
 getdate() as Fecha,
  year(Orderdate) as Año,
 datename(month, orderdate) as Mes,
 count(Distinct O.OrderID) as Cantidad,
 Sum(od.Quantity * od.UnitPrice) as SubTotal,
 Sum(od.Quantity * od.UnitPrice * od.Discount) as Descuento,
 sum(Distinct o.Freight) as ImpuestoEnvío,
 Sum((od.Quantity * od.UnitPrice) * (1- od.Discount))
 +sum(Distinct o.Freight) Total
 -----------------------------------------
 from Northwind.dbo.Orders o
 inner join Northwind.dbo.[Order Details] od
 on od.OrderID = o.OrderId
 where year(Orderdate) = year(getdate())
 and month(Orderdate) = month(getdate()) -1
 Group by 
 year(Orderdate),
 datename(month, orderdate)
 ---------------------------
 

 Set @ID = (Select @@IDENTITY)
 Select @ID as IDInsertado
 Insert into DetalleRecaudacion
 Select 
 @ID,
 o.EmployeeID as IDEmpleado,
  count(Distinct O.OrderID) as Cantidad,
 Sum(od.Quantity * od.UnitPrice) as SubTotal,
 Sum(od.Quantity * od.UnitPrice * od.Discount) as Descuento,
 sum(Distinct o.Freight) as ImpuestoEnvío,
 Sum((od.Quantity * od.UnitPrice) * (1- od.Discount))
 +sum(Distinct o.Freight) Total
 -----------------------------------------
 from Northwind.dbo.Orders o
 inner join Northwind.dbo.[Order Details] od
 on od.OrderID = o.OrderId
 where year(Orderdate) = year(getdate())
 and month(Orderdate) = month(getdate()) -1
 Group by 
 year(Orderdate),
 datename(month, orderdate),
 o.EmployeeID

 Select * from Recaudacion where year(Fecha) = year(getdate())
 and month(Fecha) = month(getdate())  and NombreBD = 'Northwind'

 Select * from DetalleRecaudacion where IdRecaudacion = @ID

 -- Neptuno
 Insert into Recaudacion
 Select 'Neptuno' as NombreBD, 
 GETDATE() as Fecha,
 year(p.FechaPedido) as Año,
 datename(month, p.FechaPedido) as Mes,
 count (distinct p.IdPedido) as Cantidad,
 sum(d.preciounidad * d.cantidad) as SubTotal,
 sum(d.preciounidad * d.cantidad * d.descuento) as Descuento,
 sum(d.preciounidad * d.cantidad * (1 - d.descuento) * 0.15) as Impuesto,
 sum(d.preciounidad * d.cantidad * (1 - d.descuento) * 1.15) as Total
 from Neptuno.dbo.Pedidos p
 inner join Neptuno.dbo.detallesdepedidos d
 on p.IdPedido = d.idpedido
 where MONTH(p.FechaPedido) = MONTH(GETDATE()) - 1 
 and YEAR(p.FechaPedido) = YEAR(GETDATE())
 group by YEAR(p.FechaPedido), datename(month, p.FechaPedido) 
--------------------------------------------

 Set @ID = (Select @@IDENTITY)
 Insert into DetalleRecaudacion
 Select 
 @ID AS ID,
 p.IdEmpleado as IDEmpleado,
 count (distinct p.IdPedido) as Cantidad,
 sum(d.preciounidad * d.cantidad) as SubTotal,
 sum(d.preciounidad * d.cantidad * d.descuento) as Descuento,
 sum(d.preciounidad * d.cantidad * (1 - d.descuento) * 0.15) as Impuesto,
 sum(d.preciounidad * d.cantidad * (1 - d.descuento) * 1.15) as Total
 from Neptuno.dbo.Pedidos p
 inner join Neptuno.dbo.detallesdepedidos d
 on p.IdPedido = d.idpedido
 where MONTH(p.FechaPedido) = MONTH(GETDATE()) - 1 
 and YEAR(p.FechaPedido) = YEAR(GETDATE())
 group by p.IdEmpleado, YEAR(p.FechaPedido), datename(month, p.FechaPedido) 


  Select * from Recaudacion where year(Fecha) = year(getdate())
 and month(Fecha) = month(getdate()) and NombreBD = 'Neptuno'

 Select * from DetalleRecaudacion where IdRecaudacion = @ID
 -- AdventureWorks

 Insert into Recaudacion
	Select
	'AdventureWorks' as NombreBD,
	GETDATE() as Fecha,
	YEAR(OrderDate) as Año,
	DATENAME(MONTH, Orderdate) as Mes,
	COUNT(Distinct o.SalesOrderID) as CantidadOrdenes,
	SUM(od.OrderQty*od.UnitPrice) as Subtotal,
	SUM(od.OrderQty*od.UnitPrice*od.UnitPriceDiscount) as Descuento,
	SUM(Distinct o.Freight) as ImpuestoEnvío,
	SUM((od.OrderQty*od.UnitPrice)*(1-od.UnitPriceDiscount))+SUM(Distinct o.Freight) as Total
	---------------------------------------------------------------
	from AdventureWorks.Sales.SalesOrderHeader o
	inner join AdventureWorks.Sales.SalesOrderDetail od
	on od.SalesOrderID = o.SalesOrderID
		where YEAR(OrderDate) = YEAR(GETDATE())
		and MONTH(OrderDate) = MONTH(GETDATE())-1
		group by  YEAR(OrderDate) ,DATENAME(MONTH, Orderdate)


 --------------------------------------------------
	 Select * from Recaudacion where year(Fecha) = year(getdate())
 and month(Fecha) = month(getdate()) and NombreBD = 'AdventureWorks'
 END
GO

exec ActualizaRecaudacion

Select * from Recaudacion

--- Email
use RepositorioBD
Create procedure MailRecaudacion
 as
 -- Mandar email
  Exec RepositorioBD.dbo.ActualizaRecaudacion
 GO

-- Plan de mantenimiento
Use msdb
GO
EXEC dbo.sp_add_job  
    @job_name = N'Recaudaciones' ;  
GO 

EXEC dbo.sp_add_jobstep  
    @job_name = N'Recaudaciones',  
    @step_name = N'Recaudaciones Bases de datos',  
    @command = N'Exec ActualizaRecaudacion' ,
    @retry_attempts = 1,  
    @retry_interval = 1 ;  
GO  

EXEC dbo.sp_add_jobstep  
    @job_name = N'Recaudaciones',  
    @step_name = N'EmailRecaudaciones',  
    @command = N'Exec MailRecaudacion' ,
    @retry_attempts = 1,  
    @retry_interval = 1 ;  
GO  

EXEC dbo.sp_add_schedule  
    @schedule_name = N'SchedRecaudacion',  
    @freq_type = 16,
	@freq_interval = 1,
	@freq_recurrence_factor = 1,
    @active_start_time = 000000 ;  
USE msdb ;  
GO 

EXEC sp_attach_schedule  
   @job_name = N'tareabd',  
   @schedule_name = N'SchedRecaudacion';  
GO 