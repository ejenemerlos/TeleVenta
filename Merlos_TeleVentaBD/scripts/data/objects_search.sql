

BEGIN TRY

MERGE INTO [Objects_Search] AS Target
USING (VALUES
  (N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Clientes',N'Cliente',0,0,N'Text',1,NULL,N'( EXISTS (
 SELECT * FROM vClientes FlxTblFilter 

 WHERE ( [vClientes].[Código Cliente]  LIKE {~@Param1|0|52|FindString~} 
 or  [vClientes].[NOMBRE]  LIKE {~@Param2|0|82|FindString~} 
 or  [vClientes].[RCOMERCIAL]  LIKE {~@Param3|22|52|FindString~} 
 or  [vClientes].[CIF]  LIKE {~@Param4|22|17|FindString~} 
 or  [vClientes].[DIRECCION]  LIKE {~@Param5|0|42|FindString~} 
 or  [vClientes].[CP]  LIKE {~@Param6|22|12|FindString~} 
 or  [vClientes].[POBLACION]  LIKE {~@Param7|22|32|FindString~} 
 or  [vClientes].[provincia]  LIKE {~@Param8|22|32|FindString~} 
)
 AND  [vClientes].[CODIGO] = [FlxTblFilter].[CODIGO] 

))
',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedidos',N'Pedidos',0,0,N'Text',1,NULL,N'( EXISTS (
 SELECT * FROM vPedidos FlxTblFilter 

 WHERE ( [vPedidos].[LETRA]  LIKE {~@Param1|22|4|FindString~} 
 or  CONVERT(varchar,[vPedidos].[sqlFecha]) Like {~@Param2|16|200|FindString~} 
 or  [vPedidos].[FECHA]  LIKE {~@Param3|0|12|FindString~} 
 or  [vPedidos].[USUARIO]  LIKE {~@Param4|22|27|FindString~} 
 or  [vPedidos].[nDireccion]  LIKE {~@Param5|22|82|FindString~} 
 or  [vPedidos].[nVendedor]  LIKE {~@Param6|22|32|FindString~} 
 or  [vPedidos].[nCliente]  LIKE {~@Param7|22|82|FindString~} 
 or  [vPedidos].[numero]  LIKE {~@Param8|22|12|FindString~} 
)
 AND  [vPedidos].[IDPEDIDO] = [FlxTblFilter].[IDPEDIDO] 

))
',1)
 ,(N'C70909D0-5749-4A5E-9043-6473BB71CBC4',N'inciCLIs',N'inciCLI',0,0,N'Properties',1,NULL,NULL,1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciARTs',N'inciArts',0,0,N'Properties',1,NULL,NULL,1)
) AS Source ([SearchId],[ObjectName],[Name],[Generic],[IsDefault],[Type],[Order],[UserId],[SQLSentence],[OriginId])
ON (Target.[SearchId] = Source.[SearchId])
WHEN MATCHED AND (
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL OR 
	NULLIF(Source.[Generic], Target.[Generic]) IS NOT NULL OR NULLIF(Target.[Generic], Source.[Generic]) IS NOT NULL OR 
	NULLIF(Source.[IsDefault], Target.[IsDefault]) IS NOT NULL OR NULLIF(Target.[IsDefault], Source.[IsDefault]) IS NOT NULL OR 
	NULLIF(Source.[Type], Target.[Type]) IS NOT NULL OR NULLIF(Target.[Type], Source.[Type]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[UserId], Target.[UserId]) IS NOT NULL OR NULLIF(Target.[UserId], Source.[UserId]) IS NOT NULL OR 
	NULLIF(Source.[SQLSentence], Target.[SQLSentence]) IS NOT NULL OR NULLIF(Target.[SQLSentence], Source.[SQLSentence]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ObjectName] = Source.[ObjectName], 
  [Name] = Source.[Name], 
  [Generic] = Source.[Generic], 
  [IsDefault] = Source.[IsDefault], 
  [Type] = Source.[Type], 
  [Order] = Source.[Order], 
  [UserId] = Source.[UserId], 
  [SQLSentence] = Source.[SQLSentence], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([SearchId],[ObjectName],[Name],[Generic],[IsDefault],[Type],[Order],[UserId],[SQLSentence],[OriginId])
 VALUES(Source.[SearchId],Source.[ObjectName],Source.[Name],Source.[Generic],Source.[IsDefault],Source.[Type],Source.[Order],Source.[UserId],Source.[SQLSentence],Source.[OriginId])
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





