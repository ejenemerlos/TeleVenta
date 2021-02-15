

BEGIN TRY

MERGE INTO [AspNetProfiles] AS Target
USING (VALUES
  (N'Ruta',N'Ruta',N'es-ES',N'webdefault',N'mobiledefault',N'Ruta',NULL,1)
 ,(N'Supervisor',N'Supervisor',N'es-ES',N'webdefault',N'mobiledefault',N'Supervisor',NULL,1)
 ,(N'Vendedor',N'Vendedor',N'es-ES',N'webdefault',N'mobiledefault',N'Vendedor',NULL,1)
) AS Source ([ProfileName],[Descrip],[CultureId],[WebInterfaceName],[MobileInterfaceName],[StartupPageName],[MailAccountId],[OriginId])
ON (Target.[ProfileName] = Source.[ProfileName])
WHEN MATCHED AND (
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[CultureId], Target.[CultureId]) IS NOT NULL OR NULLIF(Target.[CultureId], Source.[CultureId]) IS NOT NULL OR 
	NULLIF(Source.[WebInterfaceName], Target.[WebInterfaceName]) IS NOT NULL OR NULLIF(Target.[WebInterfaceName], Source.[WebInterfaceName]) IS NOT NULL OR 
	NULLIF(Source.[MobileInterfaceName], Target.[MobileInterfaceName]) IS NOT NULL OR NULLIF(Target.[MobileInterfaceName], Source.[MobileInterfaceName]) IS NOT NULL OR 
	NULLIF(Source.[StartupPageName], Target.[StartupPageName]) IS NOT NULL OR NULLIF(Target.[StartupPageName], Source.[StartupPageName]) IS NOT NULL OR 
	NULLIF(Source.[MailAccountId], Target.[MailAccountId]) IS NOT NULL OR NULLIF(Target.[MailAccountId], Source.[MailAccountId]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Descrip] = Source.[Descrip], 
  [CultureId] = Source.[CultureId], 
  [WebInterfaceName] = Source.[WebInterfaceName], 
  [MobileInterfaceName] = Source.[MobileInterfaceName], 
  [StartupPageName] = Source.[StartupPageName], 
  [MailAccountId] = Source.[MailAccountId], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ProfileName],[Descrip],[CultureId],[WebInterfaceName],[MobileInterfaceName],[StartupPageName],[MailAccountId],[OriginId])
 VALUES(Source.[ProfileName],Source.[Descrip],Source.[CultureId],Source.[WebInterfaceName],Source.[MobileInterfaceName],Source.[StartupPageName],Source.[MailAccountId],Source.[OriginId])
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





