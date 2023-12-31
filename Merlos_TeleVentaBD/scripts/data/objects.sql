﻿

BEGIN TRY

MERGE INTO [Objects] AS Target
USING (VALUES
  (N'Cliente',0,NULL,N'vClientes',NULL,0,NULL,N'Clientes',N'client',NULL,0,200,N'Cliente',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Clientes',1,N'Cliente',N'vClientes',NULL,0,NULL,N'Clientes',N'clients',NULL,0,200,N'Clientes',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Contacto',0,NULL,N'vContactos',NULL,0,NULL,N'Contactos',N'contacts2',NULL,0,200,N'Contacto',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDCONTACTO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Contactos',1,N'Contacto',N'vContactos',NULL,0,NULL,N'Contactos',N'contacts2',NULL,0,200,N'Contactos',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDCONTACTO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ExportarListadosTV',1,N'ExportarListadoTV',N'vExportarListadoTV',NULL,0,NULL,N'Exportar Listados TV',N'document',NULL,0,200,N'Exportar Listados TV',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IdDoc',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ExportarListadoTV',0,NULL,N'vExportarListadoTV',NULL,0,NULL,N'Exportar Listados TV',N'document',NULL,0,200,N'Exportar Listado TV',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IdDoc',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'gestor',0,NULL,N'gestores',NULL,0,NULL,N'gestores',N'customer-service',NULL,0,200,N'gestor',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'gestores',1,N'gestor',N'gestores',NULL,0,NULL,N'gestores',N'customer-service',NULL,0,200,N'gestores',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'inciART',0,NULL,N'vIncidenciasArticulos',NULL,0,NULL,N'inciARTs',N'accepted-2',NULL,0,200,N'inciART',0,1,0,0,0,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id|gestor|tipo|incidencia|cliente|idpedido|articulo|observaciones',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'inciARTs',1,N'inciART',N'vIncidenciasArticulos',NULL,0,NULL,N'inciARTs',N'accepted-2',NULL,0,200,N'inciARTs',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id|gestor|tipo|incidencia|cliente|idpedido|articulo|observaciones',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'inciCLI',0,NULL,N'vIncidenciasClientes',NULL,0,NULL,N'inciCLIs',N'accepted-2',NULL,0,200,N'inciCLI',0,1,0,0,0,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id|gestor|tipo|incidencia|cliente|idpedido|articulo|observaciones',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'inciCLIs',1,N'inciCLI',N'vIncidenciasClientes',NULL,0,NULL,N'inciCLIs',N'accepted-2',NULL,0,200,N'inciCLIs',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id|gestor|tipo|incidencia|cliente|idpedido|articulo|observaciones',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasArtCli',0,NULL,N'inci_CliArt',NULL,0,NULL,N'Incidencias artículos clientes',N'accepted-2',NULL,0,200,N'Incidencias artículo cliente',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasArtClis',1,N'IncidenciasArtCli',N'inci_CliArt',NULL,0,NULL,N'Incidencias artículos clientes',N'accepted-2',NULL,0,200,N'Incidencias artículos clientes',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasArticulo',0,NULL,N'inci_art',NULL,0,NULL,N'Incidencias Articulos',N'accepted-2',NULL,0,200,N'Incidencias Articulo',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasArticulos',1,N'IncidenciasArticulo',N'inci_art',NULL,0,NULL,N'Incidencias Articulos',N'accepted-2',NULL,0,200,N'Incidencias Articulos',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasCliente',0,NULL,N'inci_cli',NULL,0,NULL,N'IncidenciasClientes',N'accepted-2',NULL,0,200,N'IncidenciasCliente',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'IncidenciasClientes',1,N'IncidenciasCliente',N'inci_cli',NULL,0,NULL,N'IncidenciasClientes',N'accepted-2',NULL,0,200,N'IncidenciasClientes',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadoLlamadaImprimir',0,NULL,N'vListadosLlamadasImprimir',NULL,0,NULL,N'Imprimir Listados Llamadas',N'printer-2',NULL,0,200,N'Imprimir Listado Llamada',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IdDoc',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadoLlamadas',0,NULL,N'vListadosLlamadas',NULL,0,NULL,N'Listados llamadas',N'fa-phone',NULL,0,200,N'Listado llamadas',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadosLlamadas',1,N'ListadoLlamadas',N'vListadosLlamadas',NULL,0,NULL,N'Listados llamadas',N'fa-phone',NULL,0,200,N'Listados llamadas',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadosLlamadasImprimir',1,N'ListadoLlamadaImprimir',N'vListadosLlamadasImprimir',NULL,0,NULL,N'Imprimir Listados Llamadas',N'printer-2',NULL,0,200,N'Imprimir Listados Llamadas',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IdDoc',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadosVentas',1,N'ListadoVenta',N'vListadoTV',NULL,0,NULL,N'Listados de ventas',N'fa-money',NULL,0,200,N'Listados de ventas',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'ListadoVenta',0,NULL,N'vListadoTV',NULL,0,NULL,N'Listados de ventas',N'fa-money',NULL,0,200,N'Listado de venta',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'id',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Merlos_Cliente_Articulo',0,NULL,N'Clientes_Articulos',NULL,0,NULL,N'Merlos_Cliente_Articulos',N'articles',NULL,0,200,N'Merlos_Cliente_Articulo',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Merlos_Cliente_Articulos',1,N'Merlos_Cliente_Articulo',N'Clientes_Articulos',NULL,0,NULL,N'Merlos_Cliente_Articulos',N'articles',NULL,0,200,N'Merlos_Cliente_Articulos',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,NULL,0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Offline_Cliente',0,NULL,N'vClientes',NULL,0,NULL,N'Clientes',N'client',NULL,0,200,N'Cliente',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Offline_Clientes',1,N'Offline_Cliente',N'vClientes',NULL,0,NULL,N'Clientes',N'clients',NULL,0,200,N'Clientes',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Pedido',0,NULL,N'vPedidos',NULL,0,NULL,N'Pedidos',N'document-3',NULL,0,200,N'Pedido',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDPEDIDO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Pedidos',1,N'Pedido',N'vPedidos',NULL,0,NULL,N'Pedidos',N'document-3',NULL,0,200,N'Pedidos',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDPEDIDO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'RecibosPendiente',0,NULL,N'vGiros',NULL,0,NULL,N'RecibosPendientes',N'bullet-list',NULL,0,200,N'RecibosPendiente',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDGIRO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'RecibosPendientes',1,N'RecibosPendiente',N'vGiros',NULL,0,NULL,N'RecibosPendientes',N'bullet-list',NULL,0,200,N'RecibosPendientes',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'IDGIRO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Vendedor',0,NULL,N'vVendedores',NULL,0,NULL,N'Vendedores',N'customer-service',NULL,0,200,N'Vendedor',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
 ,(N'Vendedores',1,N'Vendedor',N'vVendedores',NULL,0,NULL,N'Vendedores',N'customer-service-1',NULL,0,200,N'Vendedores',0,1,1,1,1,1,1,N'standard',N'standard',N'standard',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,1,N'CODIGO',0,N'DataConnectionString',1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1)
) AS Source ([ObjectName],[Iscollection],[ObjectChildName],[TableName],[WhereSentence],[ConfigDB],[OrderBy],[Descrip],[IconName],[UniqueIdentifierField],[ShowDefaultMenu],[DefaultPageSize],[ParsedDescrip],[Auditable],[Active],[CanInsert],[CanUpdate],[CanDelete],[CanView],[CanPrint],[InsertType],[UpdateType],[DeleteType],[InsertProcessName],[UpdateProcessName],[DeleteProcessName],[LoadProcessName],[InsertTriggerEvent],[UpdateTriggerEvent],[DeleteTriggerEvent],[HelpId],[OverrideObjectName],[OverrideObjectWhere],[NavigateNodeId],[Clonable],[ViewKeys],[IgnoreDBRequired],[ConnStringID],[TransactionOn],[InsertFlowText],[UpdateFlowText],[DeleteFlowText],[Offline],[BeforeUpdate],[BeforeInsert],[BeforeDelete],[AfterUpdate],[AfterInsert],[AfterDelete],[ConfirmOkText],[Reserved],[OriginId])
ON (Target.[ObjectName] = Source.[ObjectName])
WHEN MATCHED AND (
	NULLIF(Source.[Iscollection], Target.[Iscollection]) IS NOT NULL OR NULLIF(Target.[Iscollection], Source.[Iscollection]) IS NOT NULL OR 
	NULLIF(Source.[ObjectChildName], Target.[ObjectChildName]) IS NOT NULL OR NULLIF(Target.[ObjectChildName], Source.[ObjectChildName]) IS NOT NULL OR 
	NULLIF(Source.[TableName], Target.[TableName]) IS NOT NULL OR NULLIF(Target.[TableName], Source.[TableName]) IS NOT NULL OR 
	NULLIF(Source.[WhereSentence], Target.[WhereSentence]) IS NOT NULL OR NULLIF(Target.[WhereSentence], Source.[WhereSentence]) IS NOT NULL OR 
	NULLIF(Source.[ConfigDB], Target.[ConfigDB]) IS NOT NULL OR NULLIF(Target.[ConfigDB], Source.[ConfigDB]) IS NOT NULL OR 
	NULLIF(Source.[OrderBy], Target.[OrderBy]) IS NOT NULL OR NULLIF(Target.[OrderBy], Source.[OrderBy]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[UniqueIdentifierField], Target.[UniqueIdentifierField]) IS NOT NULL OR NULLIF(Target.[UniqueIdentifierField], Source.[UniqueIdentifierField]) IS NOT NULL OR 
	NULLIF(Source.[ShowDefaultMenu], Target.[ShowDefaultMenu]) IS NOT NULL OR NULLIF(Target.[ShowDefaultMenu], Source.[ShowDefaultMenu]) IS NOT NULL OR 
	NULLIF(Source.[DefaultPageSize], Target.[DefaultPageSize]) IS NOT NULL OR NULLIF(Target.[DefaultPageSize], Source.[DefaultPageSize]) IS NOT NULL OR 
	NULLIF(Source.[ParsedDescrip], Target.[ParsedDescrip]) IS NOT NULL OR NULLIF(Target.[ParsedDescrip], Source.[ParsedDescrip]) IS NOT NULL OR 
	NULLIF(Source.[Auditable], Target.[Auditable]) IS NOT NULL OR NULLIF(Target.[Auditable], Source.[Auditable]) IS NOT NULL OR 
	NULLIF(Source.[Active], Target.[Active]) IS NOT NULL OR NULLIF(Target.[Active], Source.[Active]) IS NOT NULL OR 
	NULLIF(Source.[CanInsert], Target.[CanInsert]) IS NOT NULL OR NULLIF(Target.[CanInsert], Source.[CanInsert]) IS NOT NULL OR 
	NULLIF(Source.[CanUpdate], Target.[CanUpdate]) IS NOT NULL OR NULLIF(Target.[CanUpdate], Source.[CanUpdate]) IS NOT NULL OR 
	NULLIF(Source.[CanDelete], Target.[CanDelete]) IS NOT NULL OR NULLIF(Target.[CanDelete], Source.[CanDelete]) IS NOT NULL OR 
	NULLIF(Source.[CanView], Target.[CanView]) IS NOT NULL OR NULLIF(Target.[CanView], Source.[CanView]) IS NOT NULL OR 
	NULLIF(Source.[CanPrint], Target.[CanPrint]) IS NOT NULL OR NULLIF(Target.[CanPrint], Source.[CanPrint]) IS NOT NULL OR 
	NULLIF(Source.[InsertType], Target.[InsertType]) IS NOT NULL OR NULLIF(Target.[InsertType], Source.[InsertType]) IS NOT NULL OR 
	NULLIF(Source.[UpdateType], Target.[UpdateType]) IS NOT NULL OR NULLIF(Target.[UpdateType], Source.[UpdateType]) IS NOT NULL OR 
	NULLIF(Source.[DeleteType], Target.[DeleteType]) IS NOT NULL OR NULLIF(Target.[DeleteType], Source.[DeleteType]) IS NOT NULL OR 
	NULLIF(Source.[InsertProcessName], Target.[InsertProcessName]) IS NOT NULL OR NULLIF(Target.[InsertProcessName], Source.[InsertProcessName]) IS NOT NULL OR 
	NULLIF(Source.[UpdateProcessName], Target.[UpdateProcessName]) IS NOT NULL OR NULLIF(Target.[UpdateProcessName], Source.[UpdateProcessName]) IS NOT NULL OR 
	NULLIF(Source.[DeleteProcessName], Target.[DeleteProcessName]) IS NOT NULL OR NULLIF(Target.[DeleteProcessName], Source.[DeleteProcessName]) IS NOT NULL OR 
	NULLIF(Source.[LoadProcessName], Target.[LoadProcessName]) IS NOT NULL OR NULLIF(Target.[LoadProcessName], Source.[LoadProcessName]) IS NOT NULL OR 
	NULLIF(Source.[InsertTriggerEvent], Target.[InsertTriggerEvent]) IS NOT NULL OR NULLIF(Target.[InsertTriggerEvent], Source.[InsertTriggerEvent]) IS NOT NULL OR 
	NULLIF(Source.[UpdateTriggerEvent], Target.[UpdateTriggerEvent]) IS NOT NULL OR NULLIF(Target.[UpdateTriggerEvent], Source.[UpdateTriggerEvent]) IS NOT NULL OR 
	NULLIF(Source.[DeleteTriggerEvent], Target.[DeleteTriggerEvent]) IS NOT NULL OR NULLIF(Target.[DeleteTriggerEvent], Source.[DeleteTriggerEvent]) IS NOT NULL OR 
	NULLIF(Source.[HelpId], Target.[HelpId]) IS NOT NULL OR NULLIF(Target.[HelpId], Source.[HelpId]) IS NOT NULL OR 
	NULLIF(Source.[OverrideObjectName], Target.[OverrideObjectName]) IS NOT NULL OR NULLIF(Target.[OverrideObjectName], Source.[OverrideObjectName]) IS NOT NULL OR 
	NULLIF(Source.[OverrideObjectWhere], Target.[OverrideObjectWhere]) IS NOT NULL OR NULLIF(Target.[OverrideObjectWhere], Source.[OverrideObjectWhere]) IS NOT NULL OR 
	NULLIF(Source.[NavigateNodeId], Target.[NavigateNodeId]) IS NOT NULL OR NULLIF(Target.[NavigateNodeId], Source.[NavigateNodeId]) IS NOT NULL OR 
	NULLIF(Source.[Clonable], Target.[Clonable]) IS NOT NULL OR NULLIF(Target.[Clonable], Source.[Clonable]) IS NOT NULL OR 
	NULLIF(Source.[ViewKeys], Target.[ViewKeys]) IS NOT NULL OR NULLIF(Target.[ViewKeys], Source.[ViewKeys]) IS NOT NULL OR 
	NULLIF(Source.[IgnoreDBRequired], Target.[IgnoreDBRequired]) IS NOT NULL OR NULLIF(Target.[IgnoreDBRequired], Source.[IgnoreDBRequired]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringID], Target.[ConnStringID]) IS NOT NULL OR NULLIF(Target.[ConnStringID], Source.[ConnStringID]) IS NOT NULL OR 
	NULLIF(Source.[TransactionOn], Target.[TransactionOn]) IS NOT NULL OR NULLIF(Target.[TransactionOn], Source.[TransactionOn]) IS NOT NULL OR 
	NULLIF(Source.[InsertFlowText], Target.[InsertFlowText]) IS NOT NULL OR NULLIF(Target.[InsertFlowText], Source.[InsertFlowText]) IS NOT NULL OR 
	NULLIF(Source.[UpdateFlowText], Target.[UpdateFlowText]) IS NOT NULL OR NULLIF(Target.[UpdateFlowText], Source.[UpdateFlowText]) IS NOT NULL OR 
	NULLIF(Source.[DeleteFlowText], Target.[DeleteFlowText]) IS NOT NULL OR NULLIF(Target.[DeleteFlowText], Source.[DeleteFlowText]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[BeforeUpdate], Target.[BeforeUpdate]) IS NOT NULL OR NULLIF(Target.[BeforeUpdate], Source.[BeforeUpdate]) IS NOT NULL OR 
	NULLIF(Source.[BeforeInsert], Target.[BeforeInsert]) IS NOT NULL OR NULLIF(Target.[BeforeInsert], Source.[BeforeInsert]) IS NOT NULL OR 
	NULLIF(Source.[BeforeDelete], Target.[BeforeDelete]) IS NOT NULL OR NULLIF(Target.[BeforeDelete], Source.[BeforeDelete]) IS NOT NULL OR 
	NULLIF(Source.[AfterUpdate], Target.[AfterUpdate]) IS NOT NULL OR NULLIF(Target.[AfterUpdate], Source.[AfterUpdate]) IS NOT NULL OR 
	NULLIF(Source.[AfterInsert], Target.[AfterInsert]) IS NOT NULL OR NULLIF(Target.[AfterInsert], Source.[AfterInsert]) IS NOT NULL OR 
	NULLIF(Source.[AfterDelete], Target.[AfterDelete]) IS NOT NULL OR NULLIF(Target.[AfterDelete], Source.[AfterDelete]) IS NOT NULL OR 
	NULLIF(Source.[ConfirmOkText], Target.[ConfirmOkText]) IS NOT NULL OR NULLIF(Target.[ConfirmOkText], Source.[ConfirmOkText]) IS NOT NULL OR 
	NULLIF(Source.[Reserved], Target.[Reserved]) IS NOT NULL OR NULLIF(Target.[Reserved], Source.[Reserved]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Iscollection] = Source.[Iscollection], 
  [ObjectChildName] = Source.[ObjectChildName], 
  [TableName] = Source.[TableName], 
  [WhereSentence] = Source.[WhereSentence], 
  [ConfigDB] = Source.[ConfigDB], 
  [OrderBy] = Source.[OrderBy], 
  [Descrip] = Source.[Descrip], 
  [IconName] = Source.[IconName], 
  [UniqueIdentifierField] = Source.[UniqueIdentifierField], 
  [ShowDefaultMenu] = Source.[ShowDefaultMenu], 
  [DefaultPageSize] = Source.[DefaultPageSize], 
  [ParsedDescrip] = Source.[ParsedDescrip], 
  [Auditable] = Source.[Auditable], 
  [Active] = Source.[Active], 
  [CanInsert] = Source.[CanInsert], 
  [CanUpdate] = Source.[CanUpdate], 
  [CanDelete] = Source.[CanDelete], 
  [CanView] = Source.[CanView], 
  [CanPrint] = Source.[CanPrint], 
  [InsertType] = Source.[InsertType], 
  [UpdateType] = Source.[UpdateType], 
  [DeleteType] = Source.[DeleteType], 
  [InsertProcessName] = Source.[InsertProcessName], 
  [UpdateProcessName] = Source.[UpdateProcessName], 
  [DeleteProcessName] = Source.[DeleteProcessName], 
  [LoadProcessName] = Source.[LoadProcessName], 
  [InsertTriggerEvent] = Source.[InsertTriggerEvent], 
  [UpdateTriggerEvent] = Source.[UpdateTriggerEvent], 
  [DeleteTriggerEvent] = Source.[DeleteTriggerEvent], 
  [HelpId] = Source.[HelpId], 
  [OverrideObjectName] = Source.[OverrideObjectName], 
  [OverrideObjectWhere] = Source.[OverrideObjectWhere], 
  [NavigateNodeId] = Source.[NavigateNodeId], 
  [Clonable] = Source.[Clonable], 
  [ViewKeys] = Source.[ViewKeys], 
  [IgnoreDBRequired] = Source.[IgnoreDBRequired], 
  [ConnStringID] = Source.[ConnStringID], 
  [TransactionOn] = Source.[TransactionOn], 
  [InsertFlowText] = Source.[InsertFlowText], 
  [UpdateFlowText] = Source.[UpdateFlowText], 
  [DeleteFlowText] = Source.[DeleteFlowText], 
  [Offline] = Source.[Offline], 
  [BeforeUpdate] = Source.[BeforeUpdate], 
  [BeforeInsert] = Source.[BeforeInsert], 
  [BeforeDelete] = Source.[BeforeDelete], 
  [AfterUpdate] = Source.[AfterUpdate], 
  [AfterInsert] = Source.[AfterInsert], 
  [AfterDelete] = Source.[AfterDelete], 
  [ConfirmOkText] = Source.[ConfirmOkText], 
  [Reserved] = Source.[Reserved], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ObjectName],[Iscollection],[ObjectChildName],[TableName],[WhereSentence],[ConfigDB],[OrderBy],[Descrip],[IconName],[UniqueIdentifierField],[ShowDefaultMenu],[DefaultPageSize],[ParsedDescrip],[Auditable],[Active],[CanInsert],[CanUpdate],[CanDelete],[CanView],[CanPrint],[InsertType],[UpdateType],[DeleteType],[InsertProcessName],[UpdateProcessName],[DeleteProcessName],[LoadProcessName],[InsertTriggerEvent],[UpdateTriggerEvent],[DeleteTriggerEvent],[HelpId],[OverrideObjectName],[OverrideObjectWhere],[NavigateNodeId],[Clonable],[ViewKeys],[IgnoreDBRequired],[ConnStringID],[TransactionOn],[InsertFlowText],[UpdateFlowText],[DeleteFlowText],[Offline],[BeforeUpdate],[BeforeInsert],[BeforeDelete],[AfterUpdate],[AfterInsert],[AfterDelete],[ConfirmOkText],[Reserved],[OriginId])
 VALUES(Source.[ObjectName],Source.[Iscollection],Source.[ObjectChildName],Source.[TableName],Source.[WhereSentence],Source.[ConfigDB],Source.[OrderBy],Source.[Descrip],Source.[IconName],Source.[UniqueIdentifierField],Source.[ShowDefaultMenu],Source.[DefaultPageSize],Source.[ParsedDescrip],Source.[Auditable],Source.[Active],Source.[CanInsert],Source.[CanUpdate],Source.[CanDelete],Source.[CanView],Source.[CanPrint],Source.[InsertType],Source.[UpdateType],Source.[DeleteType],Source.[InsertProcessName],Source.[UpdateProcessName],Source.[DeleteProcessName],Source.[LoadProcessName],Source.[InsertTriggerEvent],Source.[UpdateTriggerEvent],Source.[DeleteTriggerEvent],Source.[HelpId],Source.[OverrideObjectName],Source.[OverrideObjectWhere],Source.[NavigateNodeId],Source.[Clonable],Source.[ViewKeys],Source.[IgnoreDBRequired],Source.[ConnStringID],Source.[TransactionOn],Source.[InsertFlowText],Source.[UpdateFlowText],Source.[DeleteFlowText],Source.[Offline],Source.[BeforeUpdate],Source.[BeforeInsert],Source.[BeforeDelete],Source.[AfterUpdate],Source.[AfterInsert],Source.[AfterDelete],Source.[ConfirmOkText],Source.[Reserved],Source.[OriginId])
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





