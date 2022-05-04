
/*
	Ejemplo práctico: Restaurar Neptuno.
	Pista: Restaurar hasta el archivo 16
*/

/*
	Se tiene el archivo Backup_DATABASES.bak que contiene todas las copias de seguridad de Neptuno y otras bases de datos,
	con lo cual, se deben escoger con cuidado los archivos a considerar para la restauración de Neptuno.

	Primero se visualizan las copias de seguridad.
*/
RESTORE HEADERONLY FROM DISK = 'D:\Backup_DATABASES.bak'

/*
	El orden a seguir es encontrar la copia de seguridad FULL más reciente. En este caso es el archivo 2.

	Se deben visualizar los archivos contenidos dentro de esa copia de seguridad:
*/

RESTORE FILELISTONLY FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 2

/*
	Se detectan que los archivos ya traen una ruta la cual SQL Server tomará como referencia para buscar dichos archivos.
	En el 99% de los casos, estas rutas no van a existir en la máquina con la que se está trabajando, por lo que, se recomienda
	mover los archivos de ser necesario.

	Para esto deben irse a la ruta:
		Disco local (C:) -> Archivos de Programas -> Microsoft SQL Server -> Instancia de SQL Server (por lo general comienza con MSSQL) ->
		MSSQL -> DATA

	Es donde SQL Server guarda los archivos mdf, ldf, y los que existan, de todas las bases de datos (por lo general).

	Ya que apenas se comienza a restaurar Neptuno, se debe tener cuidado de utilizar NORECOVERY en vez de RECOVERY.

	NOTA:	Fijarse bien en los nombres de los archivos tanto en LogicalName como al final de la ruta contenida en PhysicalName,
			hasta una tilde puede marcar la diferencia.
*/

RESTORE DATABASE Neptuno FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 2,
MOVE 'Neptuno_DATA' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno_log.ldf',
NORECOVERY

/*
	Posteriormente se busca la copia del DIFFERENTIAL más reciente. En este caso es el archivo 10.
*/

RESTORE DATABASE Neptuno FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 10,
MOVE 'Neptuno_DATA' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno_log.ldf',
NORECOVERY

/*
	Por último, el archivo 16. Ya que este es el archivo objetivo, cómodamente se puede utilizar RECOVERY
*/

RESTORE DATABASE Neptuno FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 16,
MOVE 'Neptuno_DATA' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno_log.ldf',
RECOVERY

/*
	A este punto debió marcarte un error, puesto que los archivos LOG no coinciden. El archivo 16 es una copia solamente del LOG
	y dicha copia no coincide con la que se hizo con el diferencial (archivo 10).

	En estos casos se recomienda buscar la copia de seguridad anterior y del mismo tipo (en este caso, del LOG). Puesto que el archivo 15
	tambíen es una copia del LOG, intentamos con ese.

	Ojo con los NORECOVERY y RECOVERY. Acá no hemos terminado.
*/

RESTORE DATABASE Neptuno FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 15,
MOVE 'Neptuno_DATA' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno_log.ldf',
NORECOVERY

/*
	Ahora si debería permitirnos restaurar la 16 (final)
*/

RESTORE DATABASE Neptuno FROM DISK = 'D:\Backup_DATABASES.bak' WITH FILE = 16,
MOVE 'Neptuno_DATA' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Neptuno_log.ldf',
RECOVERY

--Comprobación
SELECT * FROM Neptuno.dbo.Pedidos