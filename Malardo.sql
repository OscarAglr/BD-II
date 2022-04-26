Select * from Employees

Use Northwind
GO

create procedure MostrarClientes
as
Select * from Customers
GO

create procedure MostrarProductos
as
Select * from Products
GO

CREATE LOGIN NorthwindAdmin
with password = 'sistemas666'
GO

SP_ADDUSER NorthwindAdmin, NorthwindAdmin
GO
SP_HELPLOGINS SA
GO

Create database Juanito

use Juanito
GO
SP_ADDUSER NorthwindAdmin, Northwind
GO

USE Northwind
GO

REVOKE EXECUTE ON MostrarClientes to NorthwindAdmin
GO

REVOKE EXECUTE ON MostrarProductos to NorthwindAdmin
GO

Revoke Select on Customers to NorthwindAdmin
GO

REVOKE Select on Customers(CompanyName, ContactName, Address, City) to NorthwindAdmin
GO

Grant Create table to NorthwindAdmin
GO

REVOKE CREATE TABLE TO NORTHWINDADMIN
DROP TABLE Northwind.NorthwindAdmin.ChistesDePepito
GO
REVOKE SELECT ON SCHEMA :: dbo
TO NORTHWINDADMIN
GO

GRANT SELECT ON EMPLOYEES TO NORTHWINDADMIN
GO

/*
GRANT (SELECT, INSERT, UPDATE, CREATE, ALTER)
ON (TABLE PROCEDURE FUNCTION RULE VIEW)
*/

-- investigar roles de servidor y roles de bases de datos