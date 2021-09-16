 GO

BEGIN TRAN

EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

EXEC sp_MSforeachtable 'ALTER TABLE ? DISABLE TRIGGER all'
 
--Application data
:r .\data\aspnetprofiles.sql
:r .\data\aspnetroles.sql
:r .\data\aspnetusers.sql
:r .\data\contextvars.sql
:r .\data\interfaces.sql
:r .\data\layouts.sql
:r .\data\menus.sql
:r .\data\modules.sql
:r .\data\navigation_nodes.sql
:r .\data\objects.sql
:r .\data\objects_processes.sql
:r .\data\objects_properties.sql
:r .\data\objects_properties_dependencies.sql
:r .\data\objects_search.sql
:r .\data\objects_search_properties.sql
:r .\data\objects_templates.sql
:r .\data\objects_views.sql
:r .\data\objects_views_properties.sql
:r .\data\pages.sql
:r .\data\pages_modules.sql
:r .\data\plugins.sql
:r .\data\processes.sql
:r .\data\processes_classification.sql
:r .\data\processes_params.sql
:r .\data\scripts_jobs.sql
:r .\data\security_navigation_nodes_roles.sql
:r .\data\security_objects_roles.sql
:r .\data\toolbars.sql
:r .\data\toolbars_buttons.sql


-- MERLOS
:r .\Merlos\Settings.sql
:r .\Merlos\Usuarios.sql
:r .\Merlos\ScriptJobs.sql

/* dejar los origins como tocan */
  UPDATE origins set active=case originid when 2 then 1 else 0 END

 -- detectar diferencias entre las versiones de bbdd
IF (N'$(IsProduct)' = '1') BEGIN
       EXEC pNet_CreateOrUpdateDatabase $(OriginDatabaseName), N'$(CurrentDacVersion)'
END 


EXEC sp_MSforeachtable 'ALTER TABLE ? ENABLE TRIGGER all'

EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'

COMMIT TRANSACTION