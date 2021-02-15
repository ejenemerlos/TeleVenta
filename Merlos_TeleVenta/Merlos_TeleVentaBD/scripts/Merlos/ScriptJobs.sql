-- Script para Lanzar configuración del Portal 
-- Nota: los ScriptsJobs de actualización se deben crear en cada actualización.
--              No se pueden hacer Updates (Ahora).
--              por lo que después de ejecutar su código lo eliminamos.
if exists (select  Descrip from [Scripts_Jobs] where Descrip='MI_ControlVersion') BEGIN delete [Scripts_Jobs] where Descrip='MI_ControlVersion'  END
ELSE BEGIN
    INSERT INTO [dbo].[Scripts_Jobs]
           ([ScriptId]
           ,[Descrip]
           ,[Notes]
           ,[CreationDate]
           ,[State]
           ,[Script]
           ,[ConnStringId]
           ,[ExecuteOrder]
           ,[StartDate]
           ,[EndDate]
           ,[ErrorMessage]
           ,[OriginId])
     VALUES
           (  'MERLOSCsj-db29-4fc7-be2c-ab69fb5e0621'
			, 'MI_ControlVersion'
			, 'Regenera el contenido de la base de datos de DATOS. Vistas, procedimientos, etc.'
			, getdate()
			, 'P'
			, ' declare    @EJERCICIO varchar(4) = (select EJERCICIO from Configuracion_SQL)
				            , @GESTION varchar(6) = (select GESTION from Configuracion_SQL)
				            , @LETRA char(2) = (select LETRA from Configuracion_SQL)
				            , @COMUN varchar(8) = (select COMUN from Configuracion_SQL)
				            , @CAMPOS varchar(8) = (select CAMPOS from Configuracion_SQL)

                if @EJERCICIO<>'''' and @GESTION<>'''' and @LETRA<>'''' and @COMUN<>''''  BEGIN
		                exec pConfigBBDD   ''reconfigurar'',''todo'',@EJERCICIO, @GESTION, @LETRA, @COMUN, @CAMPOS
                END
            '
            , 'DataConnectionString'
            ,1
            , getdate()
            , getdate()
            ,NULL
            ,1
		   )
END