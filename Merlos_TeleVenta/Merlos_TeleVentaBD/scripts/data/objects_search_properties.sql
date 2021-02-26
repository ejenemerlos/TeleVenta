

BEGIN TRY

MERGE INTO [Objects_Search_Properties] AS Target
USING (VALUES
  (N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'CIF',N'Cliente',2,3,N'CIF',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'Código Cliente',N'Cliente',2,0,N'Código Cliente',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'CP',N'Cliente',2,5,N'CP',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'DIRECCION',N'Cliente',2,4,N'DIRECCION',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'NOMBRE',N'Cliente',2,1,N'NOMBRE',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'POBLACION',N'Cliente',2,6,N'POBLACION',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'provincia',N'Cliente',2,7,N'provincia',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'RCOMERCIAL',N'Cliente',2,2,N'RCOMERCIAL',N'text',1)
 ,(N'C70909D0-5749-4A5E-9043-6473BB71CBC4',N'inciCLI',N'cliente',N'inciCLI',2,2,N'cliente',N'text',1)
 ,(N'C70909D0-5749-4A5E-9043-6473BB71CBC4',N'inciCLI',N'FechaInsertUpdate',N'inciCLI',2,3,N'FechaInsertUpdate',N'date-range',1)
 ,(N'C70909D0-5749-4A5E-9043-6473BB71CBC4',N'inciCLI',N'gestor',N'inciCLI',2,0,N'gestor',N'text',1)
 ,(N'C70909D0-5749-4A5E-9043-6473BB71CBC4',N'inciCLI',N'incidencia',N'inciCLI',2,1,N'incidencia',N'text',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'articulo',N'inciART',2,3,N'articulo',N'text',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'cliente',N'inciART',2,2,N'cliente',N'text',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'Fecha',N'inciART',2,4,N'Fecha',N'date-range',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'gestor',N'inciART',2,0,N'gestor',N'text',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'incidencia',N'inciART',2,1,N'incidencia',N'text',1)
 ,(N'1F2FD612-2541-4E30-AD70-A9219B157348',N'inciART',N'pedido',N'inciART',2,5,N'pedido',N'text',1)
) AS Source ([SearchId],[ObjectName],[PropertyName],[ObjectPath],[Size],[Order],[Label],[PropertySearchType],[OriginId])
ON (Target.[SearchId] = Source.[SearchId] AND Target.[ObjectName] = Source.[ObjectName] AND Target.[PropertyName] = Source.[PropertyName])
WHEN MATCHED AND (
	NULLIF(Source.[ObjectPath], Target.[ObjectPath]) IS NOT NULL OR NULLIF(Target.[ObjectPath], Source.[ObjectPath]) IS NOT NULL OR 
	NULLIF(Source.[Size], Target.[Size]) IS NOT NULL OR NULLIF(Target.[Size], Source.[Size]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[Label], Target.[Label]) IS NOT NULL OR NULLIF(Target.[Label], Source.[Label]) IS NOT NULL OR 
	NULLIF(Source.[PropertySearchType], Target.[PropertySearchType]) IS NOT NULL OR NULLIF(Target.[PropertySearchType], Source.[PropertySearchType]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ObjectPath] = Source.[ObjectPath], 
  [Size] = Source.[Size], 
  [Order] = Source.[Order], 
  [Label] = Source.[Label], 
  [PropertySearchType] = Source.[PropertySearchType], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([SearchId],[ObjectName],[PropertyName],[ObjectPath],[Size],[Order],[Label],[PropertySearchType],[OriginId])
 VALUES(Source.[SearchId],Source.[ObjectName],Source.[PropertyName],Source.[ObjectPath],Source.[Size],Source.[Order],Source.[Label],Source.[PropertySearchType],Source.[OriginId])
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





