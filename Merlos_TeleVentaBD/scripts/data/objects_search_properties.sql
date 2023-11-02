

BEGIN TRY

MERGE INTO [Objects_Search_Properties] AS Target
USING (VALUES
  (N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'cliente',N'ListadoLlamadas',2,1,N'Cliente',N'text',1)
 ,(N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'fecha',N'ListadoLlamadas',2,3,N'Desde',N'text',1)
 ,(N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'gestor',N'ListadoLlamadas',2,2,N'Gestor',N'text',1)
 ,(N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'hasta',N'ListadoLlamadas',2,4,N'Hasta',N'text',1)
 ,(N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'horario',N'ListadoLlamadas',2,5,N'Horario',N'text',1)
 ,(N'302F15D5-17EB-48F6-AA74-26E32C15D4E3',N'ListadoLlamadas',N'nombreListado',N'ListadoLlamadas',2,0,N'Listado',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'cliente',N'ExportarListadoTV',2,0,N'Cliente',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'completado',N'ExportarListadoTV',2,8,N'Completado',N'number',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'horario',N'ExportarListadoTV',2,2,N'Horario',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'importe',N'ExportarListadoTV',2,7,N'Importe',N'number',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'pedido',N'ExportarListadoTV',2,4,N'Pedido',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'RCOMERCIAL',N'ExportarListadoTV',2,1,N'Nombre Cliente',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'serie',N'ExportarListadoTV',2,5,N'Serie',N'text',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'subtotal',N'ExportarListadoTV',2,6,N'Subtotal',N'number',1)
 ,(N'3341E759-D561-46BF-991A-3A4CA21C768E',N'ExportarListadoTV',N'TELEFONO',N'ExportarListadoTV',2,3,N'Telefono',N'text',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'clientes',N'ListadoVenta',2,3,N'Clientes',N'number',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'fecha',N'ListadoVenta',2,1,N'Fecha',N'text',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'importe',N'ListadoVenta',2,7,N'Importe',N'number',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'llamadas',N'ListadoVenta',2,4,N'Llamadas',N'number',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'nombre',N'ListadoVenta',2,2,N'Nombre',N'text',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'pedidos',N'ListadoVenta',2,5,N'Pedidos',N'number',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'subtotal',N'ListadoVenta',2,6,N'Subtotal',N'number',1)
 ,(N'1E5A5B69-56A8-4E6B-AC38-3E5E0FE7D44F',N'ListadoVenta',N'usuario',N'ListadoVenta',2,0,N'Usuario',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'CIF',N'Cliente',2,3,N'CIF',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'Código Cliente',N'Cliente',2,0,N'Código Cliente',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'CP',N'Cliente',2,5,N'CP',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'DIRECCION',N'Cliente',2,4,N'DIRECCION',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'NOMBRE',N'Cliente',2,1,N'NOMBRE',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'POBLACION',N'Cliente',2,6,N'POBLACION',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'provincia',N'Cliente',2,7,N'provincia',N'text',1)
 ,(N'BBEDC13A-57C3-4352-8A90-4C93A3904ED8',N'Cliente',N'RCOMERCIAL',N'Cliente',2,2,N'RCOMERCIAL',N'text',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'cliente',N'inciCLI',2,2,N'cliente',N'text',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'FechaInsertUpdate',N'inciCLI',2,5,N'FechaInsertUpdate',N'date-range',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'gestor',N'inciCLI',2,0,N'gestor',N'text',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'incidencia',N'inciCLI',2,4,N'incidencia',N'text',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'pedido',N'inciCLI',2,3,N'pedido',N'text',1)
 ,(N'F662F27A-71AF-4CE3-ACC4-4CFE13783243',N'inciCLI',N'tipo',N'inciCLI',2,1,N'tipo',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'FECHA',N'Pedido',2,2,N'FECHA',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'LETRA',N'Pedido',2,0,N'LETRA',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'nCliente',N'Pedido',2,6,N'nCliente',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'nDireccion',N'Pedido',2,4,N'nDireccion',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'numero',N'Pedido',2,7,N'numero',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'nVendedor',N'Pedido',2,5,N'nVendedor',N'text',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'sqlFecha',N'Pedido',2,1,N'sqlFecha',N'date-range',1)
 ,(N'FFE29BE5-BCD5-46DB-ABB8-52F076910A36',N'Pedido',N'USUARIO',N'Pedido',2,3,N'USUARIO',N'text',1)
 ,(N'C54F3013-706E-4E75-B3CA-6303B5C11630',N'Merlos_Cliente_Articulo',N'Articulo',N'Merlos_Cliente_Articulo',2,0,N'Articulo',N'text',1)
 ,(N'C54F3013-706E-4E75-B3CA-6303B5C11630',N'Merlos_Cliente_Articulo',N'Descripcion',N'Merlos_Cliente_Articulo',2,1,N'Descripcion',N'text',1)
 ,(N'C54F3013-706E-4E75-B3CA-6303B5C11630',N'Merlos_Cliente_Articulo',N'IncluirExcluir',N'Merlos_Cliente_Articulo',2,2,N'IncluirExcluir',N'text',1)
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
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'cliente',N'ListadoLlamadaImprimir',2,0,N'Cliente',N'text',1)
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'fecha',N'ListadoLlamadaImprimir',2,4,N'Fecha',N'text',1)
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'gestor',N'ListadoLlamadaImprimir',2,2,N'Gestor',N'text',1)
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'horario',N'ListadoLlamadaImprimir',2,5,N'Horario',N'text',1)
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'nombre',N'ListadoLlamadaImprimir',2,1,N'Nombre cliente',N'text',1)
 ,(N'8BC5CC26-DF23-4DB5-8E4A-D38310EC1FC6',N'ListadoLlamadaImprimir',N'poblacion',N'ListadoLlamadaImprimir',2,3,N'Poblacion',N'text',1)
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





