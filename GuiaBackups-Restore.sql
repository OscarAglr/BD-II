
/*
	Para gestionar las copias de seguridad, es recomendable usar un dispositivo de almacenamiento.

	Un dispositivo de almacenamiento no es m�s que un objeto que contiene una ruta, ejemplo: D:\Northwind\Northwind.bak
	La ventaja de estos es que en vez de poner toda la ruta, solo se coloca el nombre del dispositivo.

	Para crear un dispositivo de almacenamiento primero se especifica el tipo: disco, disquete, cinta, etc. Posteriormente
	se le asigna un nombre, por ejemplo 'ubicacionRespaldo'. Por �ltimo se especifica la ruta a la que har� referencia el
	dispositivo.
*/

--Creando dispositivo de almacenamiento
USE [master]
GO
EXECUTE sp_addumpdevice 'disk', 'ubicacionRespaldo', 'D:\Northwind\Northwind.bak'

------------------------------------------------Ayuda con la bas de datos-----------------------------------------------------------------

/*
	En ocasiones ser� necesario saber la ubicaci�n exacta de una base de datos. Al ejecutar el procedimiento correspondiente se obtienen 2
	tablas, de las cuales la segunda tabla en la columna filename nos proporciona la direcci�n f�sica de los archivos .mdf y .ldf de la
	base de datos.
	
	Para ello se utiliza el siguiente procedimiento:
*/

EXECUTE sp_helpdb Northwind

------------------------------------------------Ayuda con la bas de datos-----------------------------------------------------------------

-----------------------------------------------------------BACKUP-------------------------------------------------------------------------

--Copia de seguridad FULL sin dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP DATABASE Northwind TO DISK = 'D:\Northwind\Northwind.bak' WITH NAME = 'Respaldo FULL BD', DESCRIPTION = 'FULL MDF - LDF'

--Copia de seguridad FULL con dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP DATABASE Northwind TO ubicacionRespaldo WITH NAME = 'Respaldo FULL BD', DESCRIPTION = 'FULL MDF - LDF'

--Copia de seguridad DIFFERENTIAL sin dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP DATABASE Northwind TO DISK = 'D:\Northwind\Northwind.bak' WITH NAME = 'Respaldo Diferencial BD', DESCRIPTION = 'Differential MDF - LDF', DIFFERENTIAL

--Copia de seguridad DIFFERENTIAL con dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP DATABASE Northwind TO ubicacionRespaldo WITH NAME = 'Respaldo Diferencial BD', DESCRIPTION = 'Differential MDF - LDF', DIFFERENTIAL

--Copia de seguridad LOG sin dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP LOG Northwind TO DISK = 'D:\Northwind\Northwind.bak' WITH NAME = 'Respaldo del LOG de la BD', DESCRIPTION = 'Respaldo LDF'

--Copia de seguridad LOG con dispositivo de almacenamiento.
USE [Northwind]
GO
BACKUP LOG Northwind TO ubicacionRespaldo WITH NAME = 'Respaldo del LOG de la BD', DESCRIPTION = 'Respaldo LDF'

-----------------------------------------------------------BACKUP-------------------------------------------------------------------------

-----------------------------------------------------------RESTORE------------------------------------------------------------------------

/*
	Cuando se requiere restaurar una base de datos, por lo general se ocupa el archivo .bak, sin embargo, hay distintas maneras de
	hacerlo.

	En el primer caso es cuando la base de datos no existe dentro del servidor. Se debe colocar dentro de la sentencia el nombre de
	la base de datos y la direcci�n del archivo .bak; con esto el gestor entiende que deber� crear una nueva base de datos con el
	nombre especificado y buscar� las copias de seguridad contenidas en el .bak
*/

USE [master]
GO
RESTORE DATABASE Northwind FROM DISK = 'D:\Northwind\Northwind.bak'

--O bien

USE [master]
GO
RESTORE DATABASE Northwind FROM ubicacionRespaldo

/*
	El otro caso es cuando ya existe la base de datos. Es la misma sentencia con la diferencia que se indica que la base de datos
	ser� reemplazada.
*/

USE [master]
GO
RESTORE DATABASE Northwind FROM DISK = 'D:\Northwind\Northwind.bak' WITH REPLACE

--O bien

USE [master]
GO
RESTORE DATABASE Northwind FROM ubicacionRespaldo WITH REPLACE

/*
	Para los siguientes casos, es necesario entender el punto anterior.

	Otro escenario es restaurar la base de datos pero especificando los archivos que se utilizar�n para la recuperaci�n. Dichos
	archivos est�n en el .bak

	Dentro de las siguientes sentencias se estar� utilizando las palabras NORECOVERY y RECOVERY.
		
		1) NORECOVERY:	Indica que la base de datos EST� EN PROCESO DE RESTAURACI�N, por lo tanto, no estar� disponible para su uso.
						es ideal para cuando A�N se est�n seleccionando los archivos para su recuperaci�n.

		2) RECOVERY:	Indica que la base de datos YA ESTAR� RESTAURADA para cuando finalice el proceso de restauraci�n, y por lo tanto,
						podr� utilizarse. Es conveniente utilizar esta palabra para cuando se est� por seleccinar EL �LTIMO archivo para
						su restauraci�n.

	NOTA: Las copias de seguridad deben restaurarse en orden ascendente, es decir, de la m�s vieja a la m�s reciente
*/

USE [master]
GO
RESTORE HEADERONLY FROM ubicacionRespaldo
GO

--Restaurando el FULL primero
USE [master]
GO
RESTORE DATABASE Northwind FROM ubicacionRespaldo WITH FILE = 1, NORECOVERY

--Restaurando el DIFFERENTIAL 
USE [master]
GO
RESTORE DATABASE Northwind FROM ubicacionRespaldo WITH FILE = 2, NORECOVERY

--Restaurando el LOG
USE [master]
GO
RESTORE DATABASE Northwind FROM ubicacionRespaldo WITH FILE = 3, RECOVERY

-----------------------------------------------------------RESTORE------------------------------------------------------------------------

------------------------------------------------Visualizar el archivo BACKUP--------------------------------------------------------------

/*
	Resulta �til visualizar lo que contiene el archivo .bak de cualquier respaldo y m�s a la hora de restaurar una base de datos.

	Dentro del archivo .bak encontramos varias columnas. De las m�s importantes tenemos:
		
		1. BackupName: nombre asignado en la sentencia WITH NAME = '' del BACKUP
		2. BackupDescription: texto ingresado en la sentencia WITH DESCRIPTION = '' del BACKUP
		3. BackupType: el tipo de backup que se hizo. Dentro de los cuales tenemos:
			a)Full: 1
			b)Differential: 5
			c)Log: 2
		4. Position: determina la posici�n del archivo contenido en el .bak y suele ser de mucha utilidad a la hora de restaurar la BD.
		5. DatabaseName: nombre de la base de datos a la que pertenece el archivo.
		6. BackupStartDate: fecha y hora de inicio del backup.
		7. BackupFinishDate: fecha y hora de finalizaci�n del backup.
*/

--Visualizar contenido del archivo .bak sin dispositivo de almacenamiento
RESTORE HEADERONLY FROM DISK = 'D:\Northwind\Northwind.bak'

--Visualizar contenido del archivo .bak con dispositivo de almacenamiento
RESTORE HEADERONLY FROM ubicacionRespaldo

--Visualizar los archivos contenidos dentro de una copia de seguridad.
RESTORE HEADERONLY FROM ubicacionRespaldo					--Visualizando las copias de seguridad, se desea conocer la Position.
RESTORE FILELISTONLY FROM ubicacionRespaldo WITH FILE = 3	--Visalizando los archivos contenidos de la copia de seguridad en la Position 3

------------------------------------------------Visualizar el archivo BACKUP--------------------------------------------------------------