﻿

BEGIN TRY

MERGE INTO [Pages_Modules] AS Target
USING (VALUES
  (N'8462DB46-6433-4DED-854E-E390DC933587',N'Clientes_Listado',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Cliente_Acciones',N'TopPosition',NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Cliente_Datos',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Cliente_Incidencias',N'TopPosition',NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Cliente_Pedidos',N'TopPosition',NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Contactos',N'TopPosition',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'Merlos_Clientes_Articulos',N'TopPosition',NULL,7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'TV_Recibos_Pendientes',N'TopPosition',NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'usuariosTV',N'TopPosition',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'C408D692-F571-40FF-8C6F-79C80314E7C2',N'inciCLIlistado',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'Merlos_ClientesArticulos',N'Merlos_Clientes_Articulos_Masivo',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'Merlos_Version',N'Merlos_Version',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'syspage-generic-controlpanel',N'Configuracion',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_Cliente',N'TopLeftPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_Llamadas',N'TopRightPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_LlamadasTV',N'TopPosition',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_OpcionesLlamada',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_Pedido',N'TopPosition',NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TeleVenta',N'TV_UltimosPedidos',N'BottomPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TV_Listados',N'Merlos_Listados',N'TopPosition',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
 ,(N'TV_Listados',N'MI_ListadosLlamadas',N'TopPosition',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
) AS Source ([PageName],[ModuleName],[LayoutPositionId],[RelationWhere],[Order],[SQlEnabled],[SQLEnabledDescrip],[Title],[IconName],[HeaderClass],[ModuleClass],[ConnStringID],[OriginId])
ON (Target.[PageName] = Source.[PageName] AND Target.[ModuleName] = Source.[ModuleName])
WHEN MATCHED AND (
	NULLIF(Source.[LayoutPositionId], Target.[LayoutPositionId]) IS NOT NULL OR NULLIF(Target.[LayoutPositionId], Source.[LayoutPositionId]) IS NOT NULL OR 
	NULLIF(Source.[RelationWhere], Target.[RelationWhere]) IS NOT NULL OR NULLIF(Target.[RelationWhere], Source.[RelationWhere]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[SQlEnabled], Target.[SQlEnabled]) IS NOT NULL OR NULLIF(Target.[SQlEnabled], Source.[SQlEnabled]) IS NOT NULL OR 
	NULLIF(Source.[SQLEnabledDescrip], Target.[SQLEnabledDescrip]) IS NOT NULL OR NULLIF(Target.[SQLEnabledDescrip], Source.[SQLEnabledDescrip]) IS NOT NULL OR 
	NULLIF(Source.[Title], Target.[Title]) IS NOT NULL OR NULLIF(Target.[Title], Source.[Title]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[HeaderClass], Target.[HeaderClass]) IS NOT NULL OR NULLIF(Target.[HeaderClass], Source.[HeaderClass]) IS NOT NULL OR 
	NULLIF(Source.[ModuleClass], Target.[ModuleClass]) IS NOT NULL OR NULLIF(Target.[ModuleClass], Source.[ModuleClass]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringID], Target.[ConnStringID]) IS NOT NULL OR NULLIF(Target.[ConnStringID], Source.[ConnStringID]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [LayoutPositionId] = Source.[LayoutPositionId], 
  [RelationWhere] = Source.[RelationWhere], 
  [Order] = Source.[Order], 
  [SQlEnabled] = Source.[SQlEnabled], 
  [SQLEnabledDescrip] = Source.[SQLEnabledDescrip], 
  [Title] = Source.[Title], 
  [IconName] = Source.[IconName], 
  [HeaderClass] = Source.[HeaderClass], 
  [ModuleClass] = Source.[ModuleClass], 
  [ConnStringID] = Source.[ConnStringID], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PageName],[ModuleName],[LayoutPositionId],[RelationWhere],[Order],[SQlEnabled],[SQLEnabledDescrip],[Title],[IconName],[HeaderClass],[ModuleClass],[ConnStringID],[OriginId])
 VALUES(Source.[PageName],Source.[ModuleName],Source.[LayoutPositionId],Source.[RelationWhere],Source.[Order],Source.[SQlEnabled],Source.[SQLEnabledDescrip],Source.[Title],Source.[IconName],Source.[HeaderClass],Source.[ModuleClass],Source.[ConnStringID],Source.[OriginId])
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





