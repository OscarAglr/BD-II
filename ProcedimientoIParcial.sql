Use Northwind
Go
alter procedure RecaudacionCercana
as
begin
	declare @avg as float

	set @avg = (Select round(AVG(a.Recaudacion), 2) from(
		Select MONTH(o.OrderDate) as Mes, YEAR(o.OrderDate) as Año, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as Recaudacion
		from Orders o
		inner join [Order Details] od
		on o.OrderID = od.OrderID
		group by YEAR(o.OrderDate), MONTH(o.OrderDate)
	) a
	where a.Año = YEAR(Getdate()) - 1)

	declare @nearest as float

	set @nearest  = (
	Select top 1 Recaudacion from(
		Select MONTH(o.OrderDate) as Mes, YEAR(o.OrderDate) as Año, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as Recaudacion
		from Orders o
		inner join [Order Details] od
		on o.OrderID = od.OrderID
		group by YEAR(o.OrderDate), MONTH(o.OrderDate)
	) a
	where a.Año = YEAR(Getdate()) - 1
	group by a.recaudacion
	order by ABS(@avg - a.Recaudacion) asc
	)
	
	declare @nmonth as int

	set @nmonth = (
	Select top 1 Mes from(
		Select MONTH(o.OrderDate) as Mes, YEAR(o.OrderDate) as Año, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as Recaudacion
		from Orders o
		inner join [Order Details] od
		on o.OrderID = od.OrderID
		group by YEAR(o.OrderDate), MONTH(o.OrderDate)
	) a where Recaudacion = @nearest and a.Año = YEAR(Getdate()) - 1
	)

	select YEAR(getdate()) -1 as Año, @nmonth as Mes, DateName( month , DateAdd( month , @nmonth , -1 ) ) as [Nombre del mes], 
	@avg as [Recaudación promedio], round(@nearest, 2) as [Recaudación más cercana]
end
go
Update Orders
set OrderDate = DATEadd(YEAR, +24, OrderDate)
go
Select * from Orders
go

Use msdb
go
alter procedure MailRecaudacion
 as
 -- Mandar email
  Exec Msdb.dbo.sp_send_dbmail
 @Profile_name= 'DBA',
 @recipients='basesdedatos.uni@gmail.com',
 @body ='ReporteRecaudaciones.xls',
 @Subject = 'Oscar Aguilar',
 @query= 'Execute Northwind.dbo.RecaudacionCercana',
 @attach_query_result_as_file = 1
GO
exec RecaudacionCercana
go
exec MailRecaudacion