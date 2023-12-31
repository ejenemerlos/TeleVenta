﻿

BEGIN TRY

MERGE INTO [Plugins] AS Target
USING (VALUES
  (N'58A32411-E9CE-4B33-ADCB-3A3BABCB4476',N'~/Merlos/css/flatpickr.min.css',N'flatpickr',100,1,1,1,1)
 ,(N'B3D31361-C087-4726-BCC5-878986C2A58A',N'~/Merlos/js/Televenta.js',N'Televenta',100,0,1,1,1)
 ,(N'44D4DCAC-9D87-43A9-9B37-8E6E605F3D32',N'~/Merlos/js/flatpickr.js',N'Flatpickr',100,0,1,1,1)
 ,(N'B46FC1F2-2D35-4FBC-8BEE-AFA94EA102FD',N'~/Merlos/js/MI_JS.js',N'MI_JS.js',100,0,1,1,1)
 ,(N'A400CAA3-F083-4EE5-A44D-E2B3E0F443EF',N'~/Merlos/js/flatpickr_es.js',N'flatpickr es',100,0,1,1,1)
 ,(N'FFC676D0-600A-48F9-99FC-EC49DC748829',N'~/Merlos/css/MI_CSS.css',N'MI_CSS.css',100,1,1,1,1)
) AS Source ([PluginId],[Path],[Descrip],[Order],[typeId],[Bundle],[Enabled],[OriginId])
ON (Target.[PluginId] = Source.[PluginId])
WHEN MATCHED AND (
	NULLIF(Source.[Path], Target.[Path]) IS NOT NULL OR NULLIF(Target.[Path], Source.[Path]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[typeId], Target.[typeId]) IS NOT NULL OR NULLIF(Target.[typeId], Source.[typeId]) IS NOT NULL OR 
	NULLIF(Source.[Bundle], Target.[Bundle]) IS NOT NULL OR NULLIF(Target.[Bundle], Source.[Bundle]) IS NOT NULL OR 
	NULLIF(Source.[Enabled], Target.[Enabled]) IS NOT NULL OR NULLIF(Target.[Enabled], Source.[Enabled]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Path] = Source.[Path], 
  [Descrip] = Source.[Descrip], 
  [Order] = Source.[Order], 
  [typeId] = Source.[typeId], 
  [Bundle] = Source.[Bundle], 
  [Enabled] = Source.[Enabled], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PluginId],[Path],[Descrip],[Order],[typeId],[Bundle],[Enabled],[OriginId])
 VALUES(Source.[PluginId],Source.[Path],Source.[Descrip],Source.[Order],Source.[typeId],Source.[Bundle],Source.[Enabled],Source.[OriginId])
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





