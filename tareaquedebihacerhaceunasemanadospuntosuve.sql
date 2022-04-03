Restore database Neptuno from disk = 'C:\Backups\Neptuno.bak'
with recovery,
file = 16,
MOVE 'Neptuno_DATA' TO 'C:\Backups\Neptuno.mdf',
MOVE 'Extension_I' TO 'C:\Backups\Extension_I.ndf',
MOVE 'Extensión_II' TO 'C:\Backups\Extension_II.ndf',
MOVE 'Neptuno_log' TO 'C:\Backups\Neptuno_log.ldf'

restore headeronly from disk =  'C:\Backups\Neptuno.bak'
use master
use Neptuno 

restore filelistonly from disk = 'C:\Backups\Neptuno.bak'
with file = 16
restore filelistonly from disk = 'C:\Backups\Neptuno.bak'
with file = 17

Select * from Pedidos