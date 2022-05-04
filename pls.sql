--- Email
Create procedure MailRecaudacion
 as
 -- Mandar email
  Exec Msdb.dbo.sp_send_dbmail
 @Profile_name= 'Administraciòn de SQL SERVER',
 @recipients='basesdedatos.uni@gmail.com',
 @body ='ReporteRecaudaciones.xls',
 @Subject = 'Informe de Recaudacion Mensual',
 @query= 'Execute RepositorioBD.dbo.ActualizaRecaudacion',
 @attach_query_result_as_file = 1,
 @query_attachment_filename = 'Reporte de recaudaciones AdventureWorks.xls'
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