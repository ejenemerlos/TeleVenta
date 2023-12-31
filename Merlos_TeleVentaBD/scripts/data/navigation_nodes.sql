﻿

BEGIN TRY

MERGE INTO [Navigation_Nodes] AS Target
USING (VALUES
  (N'A5754908-A03E-4AAB-9599-1349B27C3264',N'25A4B4D5-44AE-4CF1-8733-568F00F31520',8,N'Usuarios',N'users1',N'Usuarios',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'sysUsers',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'9A816DE2-430A-436B-B7F1-145F90BF016B',N'FDEDCC20-B3A2-4B6E-850E-8DA95BEBA68F',0,N'Indicencias Clientes',N'accepted-2',N'Indicencias Clientes',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'IncidenciasClientes',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,1)
 ,(N'71AD8462-F7F7-4FA4-ACE0-3500CE66EC3C',N'1AE97859-B18F-49B0-8E8D-88AE0E51D881',0,N'Llamadas',N'telecommunication',N'Llamadas',N'page',NULL,NULL,N'current',NULL,NULL,N'TV_Listados',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'B87F546F-2907-4B51-9DAF-3AA9402D89E9',N'FDEDCC20-B3A2-4B6E-850E-8DA95BEBA68F',1,N'Indicencias Artículos',N'accepted-2',N'Indicencias Artículos',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'IncidenciasArticulos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,1)
 ,(N'D7405F0D-D42A-4835-8FCD-425121C88EB4',N'25A4B4D5-44AE-4CF1-8733-568F00F31520',7,N'Informes',N'reports',N'Informes',N'group',NULL,NULL,N'current',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'FA4AC7F8-E4DE-45AA-AB17-4C460755C120',N'1AE97859-B18F-49B0-8E8D-88AE0E51D881',0,N'Ventas',N'fa-money',N'Ventas',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'ListadosVentas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'3A3737A4-429D-431F-8D15-68704D180F61',N'FDEDCC20-B3A2-4B6E-850E-8DA95BEBA68F',2,N'Gestores',N'customer-service-1',N'Gestores',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'gestores',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'0C84E448-7232-4639-97A2-804F4F015FCC',N'25A4B4D5-44AE-4CF1-8733-568F00F31520',3,N'TeleVenta',N'monitor',N'Pantalla de tele venta',N'page',NULL,NULL,N'current',NULL,NULL,N'TeleVenta',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'1AE97859-B18F-49B0-8E8D-88AE0E51D881',N'D7405F0D-D42A-4835-8FCD-425121C88EB4',0,N'Listados',N'bullet-list',N'Listados',N'text',NULL,NULL,N'current',NULL,NULL,N'TV_Listados',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'D6F70F7E-5E45-4624-83B3-8CD40AE5B975',N'D7405F0D-D42A-4835-8FCD-425121C88EB4',0,N'Incidencias Clientes',N'accepted-2',N'Incidencias Clientes',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'inciCLIs',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'FDEDCC20-B3A2-4B6E-850E-8DA95BEBA68F',N'25A4B4D5-44AE-4CF1-8733-568F00F31520',5,N'Mantenimientos',N'arrow-head-51',N'Mantenimientos',N'group',NULL,NULL,N'current',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'92278553-2437-4FF0-8B8D-96F6FCB61E09',N'D7405F0D-D42A-4835-8FCD-425121C88EB4',0,N'Incidencias Artículos',N'accepted-2',N'Incidencias Artículos',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'inciARTs',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'29666E86-8BF7-4F89-8957-AE0A244184A2',N'FDEDCC20-B3A2-4B6E-850E-8DA95BEBA68F',0,N'Artículos',N'articles',N'Artículos',N'page',NULL,NULL,N'current',NULL,N'list',N'Merlos_ClientesArticulos',NULL,NULL,NULL,N'Merlos_Cliente_Articulos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'1809B7D3-199E-4C92-8495-F3D02D576BE0',N'502DC12A-C032-407C-AD4E-372A476E7309',0,N'v.{{TeleVentaVersion}}',N'noicon',N'v.{{TeleVentaVersion}}',N'page',NULL,NULL,N'current',NULL,NULL,N'Merlos_Version',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
 ,(N'2AE0631F-9562-4CC6-A2DE-FCCCF28C7168',N'25A4B4D5-44AE-4CF1-8733-568F00F31520',4,N'Clientes',N'clients',N'Clientes',N'object',NULL,NULL,N'current',NULL,N'list',NULL,NULL,NULL,NULL,N'Clientes',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,NULL,NULL,NULL,1)
) AS Source ([NodeId],[ParentNodeId],[Order],[Title],[IconName],[Descrip],[TypeId],[Params],[Url],[TargetId],[ProcessName],[PageTypeId],[PageName],[ReportName],[HelpId],[ReportWhere],[ObjectName],[ObjectWhere],[Defaults],[SQLSentence],[SQLConStringId],[WebComponent],[TableName],[BadgeClass],[BadgeSQL],[BadgeConStringId],[BadgeRefresh],[Enabled],[cssClass],[SQLEnabledDescrip],[SQLEnabled],[ConnStringId],[OriginId])
ON (Target.[NodeId] = Source.[NodeId])
WHEN MATCHED AND (
	NULLIF(Source.[ParentNodeId], Target.[ParentNodeId]) IS NOT NULL OR NULLIF(Target.[ParentNodeId], Source.[ParentNodeId]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[Title], Target.[Title]) IS NOT NULL OR NULLIF(Target.[Title], Source.[Title]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[Params], Target.[Params]) IS NOT NULL OR NULLIF(Target.[Params], Source.[Params]) IS NOT NULL OR 
	NULLIF(Source.[Url], Target.[Url]) IS NOT NULL OR NULLIF(Target.[Url], Source.[Url]) IS NOT NULL OR 
	NULLIF(Source.[TargetId], Target.[TargetId]) IS NOT NULL OR NULLIF(Target.[TargetId], Source.[TargetId]) IS NOT NULL OR 
	NULLIF(Source.[ProcessName], Target.[ProcessName]) IS NOT NULL OR NULLIF(Target.[ProcessName], Source.[ProcessName]) IS NOT NULL OR 
	NULLIF(Source.[PageTypeId], Target.[PageTypeId]) IS NOT NULL OR NULLIF(Target.[PageTypeId], Source.[PageTypeId]) IS NOT NULL OR 
	NULLIF(Source.[PageName], Target.[PageName]) IS NOT NULL OR NULLIF(Target.[PageName], Source.[PageName]) IS NOT NULL OR 
	NULLIF(Source.[ReportName], Target.[ReportName]) IS NOT NULL OR NULLIF(Target.[ReportName], Source.[ReportName]) IS NOT NULL OR 
	NULLIF(Source.[HelpId], Target.[HelpId]) IS NOT NULL OR NULLIF(Target.[HelpId], Source.[HelpId]) IS NOT NULL OR 
	NULLIF(Source.[ReportWhere], Target.[ReportWhere]) IS NOT NULL OR NULLIF(Target.[ReportWhere], Source.[ReportWhere]) IS NOT NULL OR 
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[ObjectWhere], Target.[ObjectWhere]) IS NOT NULL OR NULLIF(Target.[ObjectWhere], Source.[ObjectWhere]) IS NOT NULL OR 
	NULLIF(Source.[Defaults], Target.[Defaults]) IS NOT NULL OR NULLIF(Target.[Defaults], Source.[Defaults]) IS NOT NULL OR 
	NULLIF(Source.[SQLSentence], Target.[SQLSentence]) IS NOT NULL OR NULLIF(Target.[SQLSentence], Source.[SQLSentence]) IS NOT NULL OR 
	NULLIF(Source.[SQLConStringId], Target.[SQLConStringId]) IS NOT NULL OR NULLIF(Target.[SQLConStringId], Source.[SQLConStringId]) IS NOT NULL OR 
	NULLIF(Source.[WebComponent], Target.[WebComponent]) IS NOT NULL OR NULLIF(Target.[WebComponent], Source.[WebComponent]) IS NOT NULL OR 
	NULLIF(Source.[TableName], Target.[TableName]) IS NOT NULL OR NULLIF(Target.[TableName], Source.[TableName]) IS NOT NULL OR 
	NULLIF(Source.[BadgeClass], Target.[BadgeClass]) IS NOT NULL OR NULLIF(Target.[BadgeClass], Source.[BadgeClass]) IS NOT NULL OR 
	NULLIF(Source.[BadgeSQL], Target.[BadgeSQL]) IS NOT NULL OR NULLIF(Target.[BadgeSQL], Source.[BadgeSQL]) IS NOT NULL OR 
	NULLIF(Source.[BadgeConStringId], Target.[BadgeConStringId]) IS NOT NULL OR NULLIF(Target.[BadgeConStringId], Source.[BadgeConStringId]) IS NOT NULL OR 
	NULLIF(Source.[BadgeRefresh], Target.[BadgeRefresh]) IS NOT NULL OR NULLIF(Target.[BadgeRefresh], Source.[BadgeRefresh]) IS NOT NULL OR 
	NULLIF(Source.[Enabled], Target.[Enabled]) IS NOT NULL OR NULLIF(Target.[Enabled], Source.[Enabled]) IS NOT NULL OR 
	NULLIF(Source.[cssClass], Target.[cssClass]) IS NOT NULL OR NULLIF(Target.[cssClass], Source.[cssClass]) IS NOT NULL OR 
	NULLIF(Source.[SQLEnabledDescrip], Target.[SQLEnabledDescrip]) IS NOT NULL OR NULLIF(Target.[SQLEnabledDescrip], Source.[SQLEnabledDescrip]) IS NOT NULL OR 
	NULLIF(Source.[SQLEnabled], Target.[SQLEnabled]) IS NOT NULL OR NULLIF(Target.[SQLEnabled], Source.[SQLEnabled]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringId], Target.[ConnStringId]) IS NOT NULL OR NULLIF(Target.[ConnStringId], Source.[ConnStringId]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ParentNodeId] = Source.[ParentNodeId], 
  [Order] = Source.[Order], 
  [Title] = Source.[Title], 
  [IconName] = Source.[IconName], 
  [Descrip] = Source.[Descrip], 
  [TypeId] = Source.[TypeId], 
  [Params] = Source.[Params], 
  [Url] = Source.[Url], 
  [TargetId] = Source.[TargetId], 
  [ProcessName] = Source.[ProcessName], 
  [PageTypeId] = Source.[PageTypeId], 
  [PageName] = Source.[PageName], 
  [ReportName] = Source.[ReportName], 
  [HelpId] = Source.[HelpId], 
  [ReportWhere] = Source.[ReportWhere], 
  [ObjectName] = Source.[ObjectName], 
  [ObjectWhere] = Source.[ObjectWhere], 
  [Defaults] = Source.[Defaults], 
  [SQLSentence] = Source.[SQLSentence], 
  [SQLConStringId] = Source.[SQLConStringId], 
  [WebComponent] = Source.[WebComponent], 
  [TableName] = Source.[TableName], 
  [BadgeClass] = Source.[BadgeClass], 
  [BadgeSQL] = Source.[BadgeSQL], 
  [BadgeConStringId] = Source.[BadgeConStringId], 
  [BadgeRefresh] = Source.[BadgeRefresh], 
  [Enabled] = Source.[Enabled], 
  [cssClass] = Source.[cssClass], 
  [SQLEnabledDescrip] = Source.[SQLEnabledDescrip], 
  [SQLEnabled] = Source.[SQLEnabled], 
  [ConnStringId] = Source.[ConnStringId], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([NodeId],[ParentNodeId],[Order],[Title],[IconName],[Descrip],[TypeId],[Params],[Url],[TargetId],[ProcessName],[PageTypeId],[PageName],[ReportName],[HelpId],[ReportWhere],[ObjectName],[ObjectWhere],[Defaults],[SQLSentence],[SQLConStringId],[WebComponent],[TableName],[BadgeClass],[BadgeSQL],[BadgeConStringId],[BadgeRefresh],[Enabled],[cssClass],[SQLEnabledDescrip],[SQLEnabled],[ConnStringId],[OriginId])
 VALUES(Source.[NodeId],Source.[ParentNodeId],Source.[Order],Source.[Title],Source.[IconName],Source.[Descrip],Source.[TypeId],Source.[Params],Source.[Url],Source.[TargetId],Source.[ProcessName],Source.[PageTypeId],Source.[PageName],Source.[ReportName],Source.[HelpId],Source.[ReportWhere],Source.[ObjectName],Source.[ObjectWhere],Source.[Defaults],Source.[SQLSentence],Source.[SQLConStringId],Source.[WebComponent],Source.[TableName],Source.[BadgeClass],Source.[BadgeSQL],Source.[BadgeConStringId],Source.[BadgeRefresh],Source.[Enabled],Source.[cssClass],Source.[SQLEnabledDescrip],Source.[SQLEnabled],Source.[ConnStringId],Source.[OriginId])
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





