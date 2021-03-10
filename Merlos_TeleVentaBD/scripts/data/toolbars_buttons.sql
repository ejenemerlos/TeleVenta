

BEGIN TRY

MERGE INTO [ToolBars_Buttons] AS Target
USING (VALUES
  (N'a1dd40b9-69e2-4b04-b921-7f8035cb8daa',N'buscarYexportar',NULL,0,N'Filter',N'Toolbar',N'Buscar',NULL,N'search-1',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
) AS Source ([ButtonId],[ToolbarName],[ParentButtonId],[Order],[TypeId],[PositionId],[Text],[Tooltip],[IconName],[HideText],[CssClass],[SQlSentence],[ProcessName],[TargetId],[ReportName],[HelpId],[Disabled],[OriginId])
ON (Target.[ButtonId] = Source.[ButtonId])
WHEN MATCHED AND (
	NULLIF(Source.[ToolbarName], Target.[ToolbarName]) IS NOT NULL OR NULLIF(Target.[ToolbarName], Source.[ToolbarName]) IS NOT NULL OR 
	NULLIF(Source.[ParentButtonId], Target.[ParentButtonId]) IS NOT NULL OR NULLIF(Target.[ParentButtonId], Source.[ParentButtonId]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[PositionId], Target.[PositionId]) IS NOT NULL OR NULLIF(Target.[PositionId], Source.[PositionId]) IS NOT NULL OR 
	NULLIF(Source.[Text], Target.[Text]) IS NOT NULL OR NULLIF(Target.[Text], Source.[Text]) IS NOT NULL OR 
	NULLIF(Source.[Tooltip], Target.[Tooltip]) IS NOT NULL OR NULLIF(Target.[Tooltip], Source.[Tooltip]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[HideText], Target.[HideText]) IS NOT NULL OR NULLIF(Target.[HideText], Source.[HideText]) IS NOT NULL OR 
	NULLIF(Source.[CssClass], Target.[CssClass]) IS NOT NULL OR NULLIF(Target.[CssClass], Source.[CssClass]) IS NOT NULL OR 
	NULLIF(Source.[SQlSentence], Target.[SQlSentence]) IS NOT NULL OR NULLIF(Target.[SQlSentence], Source.[SQlSentence]) IS NOT NULL OR 
	NULLIF(Source.[ProcessName], Target.[ProcessName]) IS NOT NULL OR NULLIF(Target.[ProcessName], Source.[ProcessName]) IS NOT NULL OR 
	NULLIF(Source.[TargetId], Target.[TargetId]) IS NOT NULL OR NULLIF(Target.[TargetId], Source.[TargetId]) IS NOT NULL OR 
	NULLIF(Source.[ReportName], Target.[ReportName]) IS NOT NULL OR NULLIF(Target.[ReportName], Source.[ReportName]) IS NOT NULL OR 
	NULLIF(Source.[HelpId], Target.[HelpId]) IS NOT NULL OR NULLIF(Target.[HelpId], Source.[HelpId]) IS NOT NULL OR 
	NULLIF(Source.[Disabled], Target.[Disabled]) IS NOT NULL OR NULLIF(Target.[Disabled], Source.[Disabled]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ToolbarName] = Source.[ToolbarName], 
  [ParentButtonId] = Source.[ParentButtonId], 
  [Order] = Source.[Order], 
  [TypeId] = Source.[TypeId], 
  [PositionId] = Source.[PositionId], 
  [Text] = Source.[Text], 
  [Tooltip] = Source.[Tooltip], 
  [IconName] = Source.[IconName], 
  [HideText] = Source.[HideText], 
  [CssClass] = Source.[CssClass], 
  [SQlSentence] = Source.[SQlSentence], 
  [ProcessName] = Source.[ProcessName], 
  [TargetId] = Source.[TargetId], 
  [ReportName] = Source.[ReportName], 
  [HelpId] = Source.[HelpId], 
  [Disabled] = Source.[Disabled], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ButtonId],[ToolbarName],[ParentButtonId],[Order],[TypeId],[PositionId],[Text],[Tooltip],[IconName],[HideText],[CssClass],[SQlSentence],[ProcessName],[TargetId],[ReportName],[HelpId],[Disabled],[OriginId])
 VALUES(Source.[ButtonId],Source.[ToolbarName],Source.[ParentButtonId],Source.[Order],Source.[TypeId],Source.[PositionId],Source.[Text],Source.[Tooltip],Source.[IconName],Source.[HideText],Source.[CssClass],Source.[SQlSentence],Source.[ProcessName],Source.[TargetId],Source.[ReportName],Source.[HelpId],Source.[Disabled],Source.[OriginId])
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





