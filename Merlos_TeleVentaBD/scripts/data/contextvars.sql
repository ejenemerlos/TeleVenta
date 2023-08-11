

BEGIN TRY

MERGE INTO [ContextVars] AS Target
USING (VALUES
  (N'CodigoEmpresa',N'select top 1 Empresa FROM Configuracion_SQL',0,N'DataConnectionString',1)
 ,(N'DIAS_ENTRE',N'select DIAS_ENTRE from vDatosEmpresa where CODIGO=(select EMPRESA collate Modern_Spanish_CI_AI from Configuracion_SQL)
',0,N'DataConnectionString',1)
 ,(N'Ejercicio',N'select top 1 EJERCICIO FROM Configuracion_SQL',0,N'DataConnectionString',1)
 ,(N'EWtrabajaPeso',N'select peso from [vConfigEW] where empresa=(select top 1 Empresa collate Modern_Spanish_CS_AI FROM Configuracion_SQL)
',0,N'DataConnectionString',1)
 ,(N'MesesConsumo',N'select top 1 MesesConsumo from Configuracion_SQL',0,N'DataConnectionString',1)
 ,(N'NombreEmpresa',N'select top 1 NOMBRE_EMPRESA FROM Configuracion_SQL',0,N'DataConnectionString',1)
 ,(N'TeleVentaVersion',N'SELECT SettingValue FROM Settings where SettingName=''AutoUpdateLastVersion''',0,N'ConfConnectionString',1)
 ,(N'TVSerie',N'select top 1 TVSerie from Configuracion_SQL',0,N'DataConnectionString',1)
 ,(N'usuariosTV',N'select RoleId, Email, UserName, Reference, Name, SurName from AspNetUsers for JSON AUTO',0,N'ConfConnectionString',1)
) AS Source ([VarName],[VarSQL],[Order],[ConnStringId],[OriginId])
ON (Target.[VarName] = Source.[VarName])
WHEN MATCHED AND (
	NULLIF(Source.[VarSQL], Target.[VarSQL]) IS NOT NULL OR NULLIF(Target.[VarSQL], Source.[VarSQL]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringId], Target.[ConnStringId]) IS NOT NULL OR NULLIF(Target.[ConnStringId], Source.[ConnStringId]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [VarSQL] = Source.[VarSQL], 
  [Order] = Source.[Order], 
  [ConnStringId] = Source.[ConnStringId], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([VarName],[VarSQL],[Order],[ConnStringId],[OriginId])
 VALUES(Source.[VarName],Source.[VarSQL],Source.[Order],Source.[ConnStringId],Source.[OriginId])
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





