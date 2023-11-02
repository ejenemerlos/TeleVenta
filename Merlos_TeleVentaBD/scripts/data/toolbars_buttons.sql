

BEGIN TRY

MERGE INTO [ToolBars_Buttons] AS Target
USING (VALUES
  (N'0A3951B5-520E-438F-B1F0-AF122DDF1BAE',N'List toolbar Merlos',NULL,1,N'Separator',N'Toolbar',N'Separator',N'Separator',NULL,1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'29272333-2DC9-4226-9600-AA88D70F8A2C',N'List toolbar Merlos',NULL,21,N'Export',N'Toolbar',N'Export',N'Export',N'document-export',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'424A0A95-9E54-44EC-9B5E-D5F9388DDA69',N'List toolbar Merlos',NULL,0,N'New',N'Toolbar',N'New',N'New',N'document-add',1,NULL,NULL,NULL,N'current',NULL,NULL,1,1)
 ,(N'49844534-288E-47C4-8569-8ABE4DF0737A',N'List toolbar Merlos',NULL,7,N'Filter',N'Toolbar',N'Filter',N'Filter',N'flx-filter',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'49F7E363-58A5-4190-99EA-974D44838DB6',N'List toolbar Merlos',NULL,19,N'Separator',N'Toolbar',N'Print & Export Separator',NULL,NULL,1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'4F40BF8B-390A-4A03-8B01-DE5E79759CF7',N'List toolbar Merlos',NULL,12,N'Separator',N'Toolbar',N'Separator',N'Separator',N'no-icon',0,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'7715720A-9DBA-4D8D-9B74-49EBC7C17F5E',N'List toolbar Merlos',NULL,13,N'Presets',N'Toolbar',N'View Results',N'View Results',N'bullet-tics-list',0,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'786906C2-7299-4E91-A39D-EFA0790D9B9C',N'List toolbar Merlos',NULL,5,N'ObjectMenu',N'Toolbar',N'Processes',N'Processes',N'bullet-list-3',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'85B4964F-5D5B-4D71-83FB-54C8E64A33F7',N'List toolbar Merlos',NULL,8,N'Sort',N'Toolbar',N'Sort',NULL,N'sort-alpha-asc',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'89CD8470-B035-47E1-92D1-35C73A573BDC',N'List toolbar Merlos',NULL,4,N'Templates',N'Toolbar',N'Templates',N'Templates',N'templates',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'8D19AD26-A23E-4334-8D49-1289BEEA6AF3',N'List toolbar Merlos',NULL,21,N'Separator',N'Toolbar',N'Print & Export Separator',NULL,NULL,1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'909A1FBC-54F5-445A-A217-80640D84502B',N'List toolbar Merlos',NULL,9,N'SavedSearches',N'Toolbar',N'Saved Searches',N'Saved Searches',N'heart-o',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'9A99701A-E5B2-4E44-8227-FBE868F411AA',N'List toolbar Merlos',NULL,20,N'Print',N'Toolbar',N'Print',N'Print',N'flx-print',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'a1dd40b9-69e2-4b04-b921-7f8035cb8daa',N'buscarYexportar',NULL,0,N'Filter',N'Toolbar',N'Buscar',NULL,N'search-1',1,NULL,NULL,NULL,N'current',NULL,NULL,0,1)
 ,(N'F4983D61-0596-4AD7-A0C3-C6C2F11F89E1',N'List toolbar Merlos',NULL,6,N'Process',N'Toolbar',N'Configure',N'Configure',N'settings-2',1,N'btnConfig',NULL,N'ConfigureEditView',N'current',NULL,NULL,0,1)
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





