USE msdb ;  
GO  
-- Creando el job
EXEC dbo.sp_add_job  
    @job_name = N'prueba1' ;  
GO  
-- se añade el step
declare @lol nvarchar(max)

set @lol = N'Backup database Consultorio to disk = ''C:\Backups\consultorio.bak'''

EXEC sp_add_jobstep  
    @job_name = N'prueba1',  
    @step_name = N'crear backup full',  
    @command = @lol ,
    @retry_attempts = 1,  
    @retry_interval = 1 ;  
GO  
-- se crea calendario de ejecucion
EXEC dbo.sp_add_schedule  
    @schedule_name = N'sched03',  
    @freq_type = 8,
	@freq_interval = 1,
	@freq_recurrence_factor = 1,
    @active_start_time = 134100 ;  
USE msdb ;  
GO  
-- se agrega calendario de ejecucion al job
EXEC sp_attach_schedule  
   @job_name = N'prueba1',  
   @schedule_name = N'sched02';  
GO  
-- si
EXEC dbo.sp_add_jobserver  
    @job_name = N'prueba1';  
GO

Backup database Consultorio to disk = 'C:\Backups\consultorio.bak'