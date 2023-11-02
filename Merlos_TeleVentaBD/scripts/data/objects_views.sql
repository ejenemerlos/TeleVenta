

BEGIN TRY

MERGE INTO [Objects_Views] AS Target
USING (VALUES
  (N'Cliente',N'ClienteDefaultList',N'ClienteDefaultList',N'DataConnectionString',N'select * from vClientes',0,1,1,0,1,N'Nombre ASC',0,NULL,NULL,1)
 ,(N'Contacto',N'ContactoDefaultList',N'ContactoDefaultList',N'DataConnectionString',N'select * from vContactos',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'ExportarListadoTV',N'ExportarListadoTVDefaultList',N'ExportarListadoTVDefaultList',N'DataConnectionString',N'SELECT * FROM vExportarListadoTV',0,1,1,0,1,N'horario ASC',0,NULL,NULL,1)
 ,(N'gestor',N'gestorDefaultList',N'gestorDefaultList',N'DataConnectionString',N'select * from gestores',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'inciART',N'inciARTDefaultList',N'inciARTDefaultList',N'DataConnectionString',N'select * from vIncidenciasArticulos order by FechaInsertUpdate desc',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'inciART',N'InciArticulos',N'InciArticulos',N'DataConnectionString',N'select i.* 
		, i.FechaInsertUpdate as Fecha
		, format(i.FechaInsertUpdate,''dd-MM-yyyy'') as laFecha
		, g.nombre as nGestor
		, ia.nombre as nIncidencia
		, cli.nombre as nCliente
		, cpv.LETRA, ltrim(rtrim(cpv.NUMERO)) as pedido
		, art.NOMBRE as nArticulo
		from TeleVentaIncidencias i
		left join gestores g on g.codigo=i.gestor
		left join inci_art ia on ia.codigo=i.incidencia
		left join (select CODIGO, NOMBRE from vClientes) cli on cli.CODIGO  collate Modern_Spanish_CS_AI=i.cliente
		left join vPedidos_Basic cpv on cpv.IDPEDIDO collate Modern_Spanish_CS_AI=i.idpedido
		left join (select CODIGO, NOMBRE from vArticulos) art on art.CODIGO collate Modern_Spanish_CS_AI=i.articulo
		where i.tipo=''Articulo''',0,0,1,0,0,N'i.FechaInsertUpdate DESC',0,NULL,NULL,1)
 ,(N'inciCLI',N'inciCLIDefaultList',N'inciCLIDefaultList',N'DataConnectionString',N'select * from vIncidenciasClientes order by FechaInsertUpdate desc',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'inciCLI',N'incidenciasClientes',N'incidenciasClientes',N'DataConnectionString',N'select i.id, i.idpedido, i.tipo, i.articulo, i.observaciones,
		  i.FechaInsertUpdate
		, format(i.FechaInsertUpdate,''dd-MM-yyyy'') as laFecha
		, i.gestor
		, i.incidencia
		, i.cliente
		, cli.NOMBRE as nCliente
		, icli.nombre as nIncidencia
		, cpv.LETRA+''-''+ltrim(rtrim(cpv.NUMERO)) as pedido
	from TeleVentaIncidencias i
	left join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=i.cliente
	left join inci_cli icli on icli.codigo=i.incidencia
	left join vPedidos_Basic cpv on cpv.IDPEDIDO collate Modern_Spanish_CS_AI=i.idpedido
	where i.tipo=''Cliente''',0,0,1,0,0,N'i.FechaInsertUpdate DESC',0,NULL,NULL,1)
 ,(N'IncidenciasArtCli',N'IncidenciasArtCliDefaultList',N'IncidenciasArtCliDefaultList',N'DataConnectionString',N'select * from inci_CliArt',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'IncidenciasArticulo',N'IncidenciasArticuloDefaultList',N'IncidenciasArticuloDefaultList',N'DataConnectionString',N' SELECT [inci_art].[codigo], [inci_art].[codigo] as [codigo_1], [inci_art].[nombre] as [nombre] FROM [inci_art] 

',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'IncidenciasCliente',N'IncidenciasClienteDefaultList',N'IncidenciasClienteDefaultList',N'DataConnectionString',N'select * from inci_cli',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'ListadoLlamadaImprimir',N'ListadoLlamadaImprimirDefaultList',N'ListadoLlamadaImprimirDefaultList',N'DataConnectionString',N'SELECT * FROM vListadosLlamadasImprimir',0,1,1,0,1,N'fecha ASC, horario ASC',0,NULL,NULL,1)
 ,(N'ListadoLlamadas',N'ListadoLlamadasDefaultList',N'ListadoLlamadasDefaultList',N'DataConnectionString',N'SELECT * FROM vListadosLlamadas',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'ListadoVenta',N'ListadoVentaDefaultList',N'ListadoVentaDefaultList',N'DataConnectionString',N'SELECT * FROM vListadoTV',0,1,1,0,1,N'FechaInsertUpdate desc',0,NULL,NULL,1)
 ,(N'Merlos_Cliente_Articulo',N'Merlos_Cliente_ArticuloDefaultList',N'Merlos_Cliente_ArticuloDefaultList',N'DataConnectionString',N' SELECT [Clientes_Articulos].[Cliente], [Clientes_Articulos].[Articulo], [Clientes_Articulos].[Id] as [Id] FROM [Clientes_Articulos] 

',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'Pedido',N'PedidoDefaultList',N'PedidoDefaultList',N'DataConnectionString',N'select * from vPedidos',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'Pedido',N'vPedidosOrderBySQLFECHAdesc',N'Pedidos listado orden sqlFecha desc',N'DataConnectionString',N'select * from vPedidos',0,0,1,0,0,N'sqlFecha desc',0,NULL,NULL,1)
 ,(N'RecibosPendiente',N'RecibosPendienteDefaultList',N'RecibosPendienteDefaultList',N'DataConnectionString',N'select * from vGiros',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'Vendedor',N'VendedorDefaultList',N'VendedorDefaultList',N'DataConnectionString',N'select * from vVendedores',0,1,1,0,1,NULL,0,NULL,NULL,1)
 ,(N'Vendedor',N'vVendedoresCombo',N'Listado Vendedores',N'DataConnectionString',N'select CODIGO, NOMBRE from vVendedores',0,0,1,0,0,N'NOMBRE ASC',0,NULL,NULL,1)
) AS Source ([ObjectName],[ViewName],[Descrip],[ConnStringId],[SQLSentence],[NoFilter],[ShowAsGrid],[Active],[System],[IsDefault],[OrderBy],[Offline],[PrimaryKeys],[IndexFields],[OriginId])
ON (Target.[ObjectName] = Source.[ObjectName] AND Target.[ViewName] = Source.[ViewName])
WHEN MATCHED AND (
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringId], Target.[ConnStringId]) IS NOT NULL OR NULLIF(Target.[ConnStringId], Source.[ConnStringId]) IS NOT NULL OR 
	NULLIF(Source.[SQLSentence], Target.[SQLSentence]) IS NOT NULL OR NULLIF(Target.[SQLSentence], Source.[SQLSentence]) IS NOT NULL OR 
	NULLIF(Source.[NoFilter], Target.[NoFilter]) IS NOT NULL OR NULLIF(Target.[NoFilter], Source.[NoFilter]) IS NOT NULL OR 
	NULLIF(Source.[ShowAsGrid], Target.[ShowAsGrid]) IS NOT NULL OR NULLIF(Target.[ShowAsGrid], Source.[ShowAsGrid]) IS NOT NULL OR 
	NULLIF(Source.[Active], Target.[Active]) IS NOT NULL OR NULLIF(Target.[Active], Source.[Active]) IS NOT NULL OR 
	NULLIF(Source.[System], Target.[System]) IS NOT NULL OR NULLIF(Target.[System], Source.[System]) IS NOT NULL OR 
	NULLIF(Source.[IsDefault], Target.[IsDefault]) IS NOT NULL OR NULLIF(Target.[IsDefault], Source.[IsDefault]) IS NOT NULL OR 
	NULLIF(Source.[OrderBy], Target.[OrderBy]) IS NOT NULL OR NULLIF(Target.[OrderBy], Source.[OrderBy]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[PrimaryKeys], Target.[PrimaryKeys]) IS NOT NULL OR NULLIF(Target.[PrimaryKeys], Source.[PrimaryKeys]) IS NOT NULL OR 
	NULLIF(Source.[IndexFields], Target.[IndexFields]) IS NOT NULL OR NULLIF(Target.[IndexFields], Source.[IndexFields]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Descrip] = Source.[Descrip], 
  [ConnStringId] = Source.[ConnStringId], 
  [SQLSentence] = Source.[SQLSentence], 
  [NoFilter] = Source.[NoFilter], 
  [ShowAsGrid] = Source.[ShowAsGrid], 
  [Active] = Source.[Active], 
  [System] = Source.[System], 
  [IsDefault] = Source.[IsDefault], 
  [OrderBy] = Source.[OrderBy], 
  [Offline] = Source.[Offline], 
  [PrimaryKeys] = Source.[PrimaryKeys], 
  [IndexFields] = Source.[IndexFields], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ObjectName],[ViewName],[Descrip],[ConnStringId],[SQLSentence],[NoFilter],[ShowAsGrid],[Active],[System],[IsDefault],[OrderBy],[Offline],[PrimaryKeys],[IndexFields],[OriginId])
 VALUES(Source.[ObjectName],Source.[ViewName],Source.[Descrip],Source.[ConnStringId],Source.[SQLSentence],Source.[NoFilter],Source.[ShowAsGrid],Source.[Active],Source.[System],Source.[IsDefault],Source.[OrderBy],Source.[Offline],Source.[PrimaryKeys],Source.[IndexFields],Source.[OriginId])
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





