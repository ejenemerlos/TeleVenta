

BEGIN TRY

MERGE INTO [Scripts_Jobs] AS Target
USING (VALUES
  (N'MERLOSCsj-db29-4fc7-be2c-ab69fb5e0621',N'MI_ControlVersion',N'Regenera el contenido de la base de datos de DATOS. Vistas, procedimientos, etc.','2021-10-05T08:52:00',N'S',N' declare    @EJERCICIO varchar(4) = (select EJERCICIO from Configuracion_SQL)
				            , @GESTION varchar(6) = (select GESTION from Configuracion_SQL)
				            , @LETRA char(2) = (select LETRA from Configuracion_SQL)
				            , @COMUN varchar(8) = (select COMUN from Configuracion_SQL)
				            , @CAMPOS varchar(8) = (select CAMPOS from Configuracion_SQL)

                if @EJERCICIO<>'''' and @GESTION<>'''' and @LETRA<>'''' and @COMUN<>''''  BEGIN
		                exec pConfigBBDD   ''reconfigurar'',''todo'',@EJERCICIO, @GESTION, @LETRA, @COMUN, @CAMPOS
                END
            ',N'DataConnectionString',1,'2021-10-14T16:31:00','2021-10-14T16:31:00',NULL,1)
) AS Source ([ScriptId],[Descrip],[Notes],[CreationDate],[State],[Script],[ConnStringId],[ExecuteOrder],[StartDate],[EndDate],[ErrorMessage],[OriginId])
ON (Target.[ScriptId] = Source.[ScriptId])
WHEN MATCHED AND (
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[Notes], Target.[Notes]) IS NOT NULL OR NULLIF(Target.[Notes], Source.[Notes]) IS NOT NULL OR 
	NULLIF(Source.[CreationDate], Target.[CreationDate]) IS NOT NULL OR NULLIF(Target.[CreationDate], Source.[CreationDate]) IS NOT NULL OR 
	NULLIF(Source.[State], Target.[State]) IS NOT NULL OR NULLIF(Target.[State], Source.[State]) IS NOT NULL OR 
	NULLIF(Source.[Script], Target.[Script]) IS NOT NULL OR NULLIF(Target.[Script], Source.[Script]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringId], Target.[ConnStringId]) IS NOT NULL OR NULLIF(Target.[ConnStringId], Source.[ConnStringId]) IS NOT NULL OR 
	NULLIF(Source.[ExecuteOrder], Target.[ExecuteOrder]) IS NOT NULL OR NULLIF(Target.[ExecuteOrder], Source.[ExecuteOrder]) IS NOT NULL OR 
	NULLIF(Source.[StartDate], Target.[StartDate]) IS NOT NULL OR NULLIF(Target.[StartDate], Source.[StartDate]) IS NOT NULL OR 
	NULLIF(Source.[EndDate], Target.[EndDate]) IS NOT NULL OR NULLIF(Target.[EndDate], Source.[EndDate]) IS NOT NULL OR 
	NULLIF(Source.[ErrorMessage], Target.[ErrorMessage]) IS NOT NULL OR NULLIF(Target.[ErrorMessage], Source.[ErrorMessage]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Descrip] = Source.[Descrip], 
  [Notes] = Source.[Notes], 
  [CreationDate] = Source.[CreationDate], 
  [State] = Source.[State], 
  [Script] = Source.[Script], 
  [ConnStringId] = Source.[ConnStringId], 
  [ExecuteOrder] = Source.[ExecuteOrder], 
  [StartDate] = Source.[StartDate], 
  [EndDate] = Source.[EndDate], 
  [ErrorMessage] = Source.[ErrorMessage], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ScriptId],[Descrip],[Notes],[CreationDate],[State],[Script],[ConnStringId],[ExecuteOrder],[StartDate],[EndDate],[ErrorMessage],[OriginId])
 VALUES(Source.[ScriptId],Source.[Descrip],Source.[Notes],Source.[CreationDate],Source.[State],Source.[Script],Source.[ConnStringId],Source.[ExecuteOrder],Source.[StartDate],Source.[EndDate],Source.[ErrorMessage],Source.[OriginId])
WHEN NOT MATCHED BY SOURCE AND TARGET.OriginId = 1 THEN 
 DELETE
;
END TRY
BEGIN CATCH
    DECLARE @ERRORNUMBER	INT,@ERRORMSG		VARCHAR(MAX),@ERRORSTATE		INT
    SELECT @ERRORNUMBER = 50000 + ERROR_NUMBER(),@ERRORMSG = ERROR_MESSAGE(), @ERRORSTATE = ERROR_STATE();
    THROW @ERRORNUMBER, @ERRORMSG, @ERRORSTATE
END CATCH
GO





