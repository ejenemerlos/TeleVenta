

BEGIN TRY

MERGE INTO [AspNetRoles] AS Target
USING (VALUES
  (N'AdminPortal',N'AdminPortal',0,0,0,1)
 ,(N'Cliente',N'Cliente',0,0,0,1)
 ,(N'Ruta',N'Ruta',0,0,0,1)
 ,(N'Supervisor',N'Supervisor',0,0,0,1)
 ,(N'TeleVenta',N'TeleVenta',0,0,0,1)
 ,(N'Vendedor',N'Vendedor',0,0,0,1)
) AS Source ([Id],[Name],[IsDesigner],[IsAdmin],[Hidden],[OriginId])
ON (Target.[Id] = Source.[Id])
WHEN MATCHED AND (
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL OR 
	NULLIF(Source.[IsDesigner], Target.[IsDesigner]) IS NOT NULL OR NULLIF(Target.[IsDesigner], Source.[IsDesigner]) IS NOT NULL OR 
	NULLIF(Source.[IsAdmin], Target.[IsAdmin]) IS NOT NULL OR NULLIF(Target.[IsAdmin], Source.[IsAdmin]) IS NOT NULL OR 
	NULLIF(Source.[Hidden], Target.[Hidden]) IS NOT NULL OR NULLIF(Target.[Hidden], Source.[Hidden]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Name] = Source.[Name], 
  [IsDesigner] = Source.[IsDesigner], 
  [IsAdmin] = Source.[IsAdmin], 
  [Hidden] = Source.[Hidden], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([Id],[Name],[IsDesigner],[IsAdmin],[Hidden],[OriginId])
 VALUES(Source.[Id],Source.[Name],Source.[IsDesigner],Source.[IsAdmin],Source.[Hidden],Source.[OriginId])
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





