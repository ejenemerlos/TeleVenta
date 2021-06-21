

BEGIN TRY

MERGE INTO [Processes_Params] AS Target
USING (VALUES
  (N'pArticulos',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pArticulos',N'registros',0,N'integer',NULL,NULL,NULL,N'registros',N'IO',0,1,4,1,N'number',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pArticulos',N'varios',0,N'string',NULL,NULL,NULL,N'varios',N'IO',0,2,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pArticulosBuscar',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,2,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pArticulosCliente',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pClienteDatos',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pClientesADI',N'elJS',0,N'string',NULL,NULL,NULL,N'elJS',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pClientesADI',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pClientesBasic',N'rol',0,N'string',NULL,NULL,NULL,N'rol',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pClientesBasic',N'usuario',0,N'string',NULL,NULL,NULL,N'usuario',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pComunes',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'accion',0,N'string',NULL,NULL,NULL,N'accion',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'campos',0,N'string',NULL,NULL,NULL,N'campos',N'IO',0,6,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'comun',0,N'string',NULL,NULL,NULL,N'comun',N'IO',0,5,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'ejercicio',0,N'string',NULL,NULL,NULL,N'ejercicio',N'IO',0,2,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'empresa',0,N'string',NULL,NULL,NULL,N'empresa',N'IO',0,7,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'gestion',0,N'string',NULL,NULL,NULL,N'gestion',N'IO',0,3,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'letra',0,N'string',NULL,NULL,NULL,N'letra',N'IO',0,4,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'nEmpresa',0,N'string',NULL,NULL,NULL,N'nEmpresa',N'IO',0,8,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'numEjer',0,N'integer',NULL,NULL,NULL,N'numEjer',N'IO',0,9,4,1,N'number',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigBBDD',N'respuesta',0,N'string',NULL,NULL,NULL,N'respuesta',N'IO',0,10,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfigPrimeraBBDD',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfiguracion',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfiguracionLanzar',N'comun',0,N'string',NULL,NULL,NULL,N'comun',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pConfiguracionLanzar',N'empresa',0,N'string',NULL,NULL,NULL,N'empresa',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pContactos',N'elJS',0,N'string',NULL,NULL,NULL,N'elJS',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pEmpresas',N'comun',0,N'string',NULL,NULL,NULL,N'comun',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pEmpresas',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pEstTV',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pIncidencias',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pInpDatos',N'elJS',0,N'string',NULL,NULL,NULL,N'elJS',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pLlamadas',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pObjetoDatos',N'elJS',0,N'string',NULL,NULL,NULL,N'elJS',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pOfertas',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pOperadorConfig',N'elJS',0,N'string',NULL,NULL,NULL,N'elJS',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pPedido_Nuevo',N'ContextVars',0,N'string',NULL,NULL,NULL,N'ContextVars',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pPedido_Nuevo',N'RetValues',0,N'string',NULL,NULL,NULL,N'RetValues',N'IO',0,2,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pPedido_Nuevo',N'Values',0,N'string',NULL,NULL,NULL,N'Values',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pPedidoDetalle',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pPreciosTabla',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pReconfigurarElPortal',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pSeries',N'Series',0,N'string',NULL,NULL,NULL,N'Series',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pUltimosPedidos',N'parametros',0,N'string',NULL,NULL,NULL,N'parametros',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pUltimosPedidosArticulos',N'cliente',0,N'string',NULL,NULL,NULL,N'cliente',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pVersiones',N'comun',0,N'string',NULL,NULL,NULL,N'comun',N'IO',0,1,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
 ,(N'pVersiones',N'modo',0,N'string',NULL,NULL,NULL,N'modo',N'IO',0,0,4,1,N'text',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'DataConnectionString',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'|',0,N'RelativePath',NULL,NULL,NULL,0,1)
) AS Source ([ProcessName],[ParamName],[Hide],[ParamTypeId],[TableName],[ObjectName],[DefaultValue],[Label],[IOTypeId],[PositionX],[PositionY],[Width],[Height],[TypeId],[Locked],[CustomPropName],[Mask],[SQlSentence],[SQLFilter],[SQLValueField],[SQLDisplayField],[SQLObjectName],[SQLViewName],[SQLOfflineSentence],[SQLOfflineOrderBy],[WhereSentence],[DetachedFromProcess],[SearchFunction],[SearchCollection],[SearchWhere],[SearchReturnFields],[SecurityObject],[AllowNew],[AllowNewFunction],[AllowNewReturnFields],[AllowNewDefaults],[ObjNameLink],[ObjWhereLink],[TargetIdLink],[Style],[CSSClass],[LabelStyle],[LabelCSSClass],[DecimalPlaces],[RootPath],[FormatString],[DirectTemplate],[Tag],[HelpId],[ConnStringId],[IsRequired],[IsRequiredMessage],[minValue],[minValueMessage],[maxValue],[maxValueMessage],[RegExp],[RegExpText],[SQLValidator],[ValidatorMessage],[OnChangeJsFunction],[OnChangeProcessName],[PlaceHolder],[IconName],[ToolbarName],[Separator],[CascadeDependencies],[RootPathType],[ImageCompressionType],[ImageMaxWidth],[ImageMaxHeight],[Offline],[OriginId])
ON (Target.[ProcessName] = Source.[ProcessName] AND Target.[ParamName] = Source.[ParamName])
WHEN MATCHED AND (
	NULLIF(Source.[Hide], Target.[Hide]) IS NOT NULL OR NULLIF(Target.[Hide], Source.[Hide]) IS NOT NULL OR 
	NULLIF(Source.[ParamTypeId], Target.[ParamTypeId]) IS NOT NULL OR NULLIF(Target.[ParamTypeId], Source.[ParamTypeId]) IS NOT NULL OR 
	NULLIF(Source.[TableName], Target.[TableName]) IS NOT NULL OR NULLIF(Target.[TableName], Source.[TableName]) IS NOT NULL OR 
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[DefaultValue], Target.[DefaultValue]) IS NOT NULL OR NULLIF(Target.[DefaultValue], Source.[DefaultValue]) IS NOT NULL OR 
	NULLIF(Source.[Label], Target.[Label]) IS NOT NULL OR NULLIF(Target.[Label], Source.[Label]) IS NOT NULL OR 
	NULLIF(Source.[IOTypeId], Target.[IOTypeId]) IS NOT NULL OR NULLIF(Target.[IOTypeId], Source.[IOTypeId]) IS NOT NULL OR 
	NULLIF(Source.[PositionX], Target.[PositionX]) IS NOT NULL OR NULLIF(Target.[PositionX], Source.[PositionX]) IS NOT NULL OR 
	NULLIF(Source.[PositionY], Target.[PositionY]) IS NOT NULL OR NULLIF(Target.[PositionY], Source.[PositionY]) IS NOT NULL OR 
	NULLIF(Source.[Width], Target.[Width]) IS NOT NULL OR NULLIF(Target.[Width], Source.[Width]) IS NOT NULL OR 
	NULLIF(Source.[Height], Target.[Height]) IS NOT NULL OR NULLIF(Target.[Height], Source.[Height]) IS NOT NULL OR 
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[Locked], Target.[Locked]) IS NOT NULL OR NULLIF(Target.[Locked], Source.[Locked]) IS NOT NULL OR 
	NULLIF(Source.[CustomPropName], Target.[CustomPropName]) IS NOT NULL OR NULLIF(Target.[CustomPropName], Source.[CustomPropName]) IS NOT NULL OR 
	NULLIF(Source.[Mask], Target.[Mask]) IS NOT NULL OR NULLIF(Target.[Mask], Source.[Mask]) IS NOT NULL OR 
	NULLIF(Source.[SQlSentence], Target.[SQlSentence]) IS NOT NULL OR NULLIF(Target.[SQlSentence], Source.[SQlSentence]) IS NOT NULL OR 
	NULLIF(Source.[SQLFilter], Target.[SQLFilter]) IS NOT NULL OR NULLIF(Target.[SQLFilter], Source.[SQLFilter]) IS NOT NULL OR 
	NULLIF(Source.[SQLValueField], Target.[SQLValueField]) IS NOT NULL OR NULLIF(Target.[SQLValueField], Source.[SQLValueField]) IS NOT NULL OR 
	NULLIF(Source.[SQLDisplayField], Target.[SQLDisplayField]) IS NOT NULL OR NULLIF(Target.[SQLDisplayField], Source.[SQLDisplayField]) IS NOT NULL OR 
	NULLIF(Source.[SQLObjectName], Target.[SQLObjectName]) IS NOT NULL OR NULLIF(Target.[SQLObjectName], Source.[SQLObjectName]) IS NOT NULL OR 
	NULLIF(Source.[SQLViewName], Target.[SQLViewName]) IS NOT NULL OR NULLIF(Target.[SQLViewName], Source.[SQLViewName]) IS NOT NULL OR 
	NULLIF(Source.[SQLOfflineSentence], Target.[SQLOfflineSentence]) IS NOT NULL OR NULLIF(Target.[SQLOfflineSentence], Source.[SQLOfflineSentence]) IS NOT NULL OR 
	NULLIF(Source.[SQLOfflineOrderBy], Target.[SQLOfflineOrderBy]) IS NOT NULL OR NULLIF(Target.[SQLOfflineOrderBy], Source.[SQLOfflineOrderBy]) IS NOT NULL OR 
	NULLIF(Source.[WhereSentence], Target.[WhereSentence]) IS NOT NULL OR NULLIF(Target.[WhereSentence], Source.[WhereSentence]) IS NOT NULL OR 
	NULLIF(Source.[DetachedFromProcess], Target.[DetachedFromProcess]) IS NOT NULL OR NULLIF(Target.[DetachedFromProcess], Source.[DetachedFromProcess]) IS NOT NULL OR 
	NULLIF(Source.[SearchFunction], Target.[SearchFunction]) IS NOT NULL OR NULLIF(Target.[SearchFunction], Source.[SearchFunction]) IS NOT NULL OR 
	NULLIF(Source.[SearchCollection], Target.[SearchCollection]) IS NOT NULL OR NULLIF(Target.[SearchCollection], Source.[SearchCollection]) IS NOT NULL OR 
	NULLIF(Source.[SearchWhere], Target.[SearchWhere]) IS NOT NULL OR NULLIF(Target.[SearchWhere], Source.[SearchWhere]) IS NOT NULL OR 
	NULLIF(Source.[SearchReturnFields], Target.[SearchReturnFields]) IS NOT NULL OR NULLIF(Target.[SearchReturnFields], Source.[SearchReturnFields]) IS NOT NULL OR 
	NULLIF(Source.[SecurityObject], Target.[SecurityObject]) IS NOT NULL OR NULLIF(Target.[SecurityObject], Source.[SecurityObject]) IS NOT NULL OR 
	NULLIF(Source.[AllowNew], Target.[AllowNew]) IS NOT NULL OR NULLIF(Target.[AllowNew], Source.[AllowNew]) IS NOT NULL OR 
	NULLIF(Source.[AllowNewFunction], Target.[AllowNewFunction]) IS NOT NULL OR NULLIF(Target.[AllowNewFunction], Source.[AllowNewFunction]) IS NOT NULL OR 
	NULLIF(Source.[AllowNewReturnFields], Target.[AllowNewReturnFields]) IS NOT NULL OR NULLIF(Target.[AllowNewReturnFields], Source.[AllowNewReturnFields]) IS NOT NULL OR 
	NULLIF(Source.[AllowNewDefaults], Target.[AllowNewDefaults]) IS NOT NULL OR NULLIF(Target.[AllowNewDefaults], Source.[AllowNewDefaults]) IS NOT NULL OR 
	NULLIF(Source.[ObjNameLink], Target.[ObjNameLink]) IS NOT NULL OR NULLIF(Target.[ObjNameLink], Source.[ObjNameLink]) IS NOT NULL OR 
	NULLIF(Source.[ObjWhereLink], Target.[ObjWhereLink]) IS NOT NULL OR NULLIF(Target.[ObjWhereLink], Source.[ObjWhereLink]) IS NOT NULL OR 
	NULLIF(Source.[TargetIdLink], Target.[TargetIdLink]) IS NOT NULL OR NULLIF(Target.[TargetIdLink], Source.[TargetIdLink]) IS NOT NULL OR 
	NULLIF(Source.[Style], Target.[Style]) IS NOT NULL OR NULLIF(Target.[Style], Source.[Style]) IS NOT NULL OR 
	NULLIF(Source.[CSSClass], Target.[CSSClass]) IS NOT NULL OR NULLIF(Target.[CSSClass], Source.[CSSClass]) IS NOT NULL OR 
	NULLIF(Source.[LabelStyle], Target.[LabelStyle]) IS NOT NULL OR NULLIF(Target.[LabelStyle], Source.[LabelStyle]) IS NOT NULL OR 
	NULLIF(Source.[LabelCSSClass], Target.[LabelCSSClass]) IS NOT NULL OR NULLIF(Target.[LabelCSSClass], Source.[LabelCSSClass]) IS NOT NULL OR 
	NULLIF(Source.[DecimalPlaces], Target.[DecimalPlaces]) IS NOT NULL OR NULLIF(Target.[DecimalPlaces], Source.[DecimalPlaces]) IS NOT NULL OR 
	NULLIF(Source.[RootPath], Target.[RootPath]) IS NOT NULL OR NULLIF(Target.[RootPath], Source.[RootPath]) IS NOT NULL OR 
	NULLIF(Source.[FormatString], Target.[FormatString]) IS NOT NULL OR NULLIF(Target.[FormatString], Source.[FormatString]) IS NOT NULL OR 
	NULLIF(Source.[DirectTemplate], Target.[DirectTemplate]) IS NOT NULL OR NULLIF(Target.[DirectTemplate], Source.[DirectTemplate]) IS NOT NULL OR 
	NULLIF(Source.[Tag], Target.[Tag]) IS NOT NULL OR NULLIF(Target.[Tag], Source.[Tag]) IS NOT NULL OR 
	NULLIF(Source.[HelpId], Target.[HelpId]) IS NOT NULL OR NULLIF(Target.[HelpId], Source.[HelpId]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringId], Target.[ConnStringId]) IS NOT NULL OR NULLIF(Target.[ConnStringId], Source.[ConnStringId]) IS NOT NULL OR 
	NULLIF(Source.[IsRequired], Target.[IsRequired]) IS NOT NULL OR NULLIF(Target.[IsRequired], Source.[IsRequired]) IS NOT NULL OR 
	NULLIF(Source.[IsRequiredMessage], Target.[IsRequiredMessage]) IS NOT NULL OR NULLIF(Target.[IsRequiredMessage], Source.[IsRequiredMessage]) IS NOT NULL OR 
	NULLIF(Source.[minValue], Target.[minValue]) IS NOT NULL OR NULLIF(Target.[minValue], Source.[minValue]) IS NOT NULL OR 
	NULLIF(Source.[minValueMessage], Target.[minValueMessage]) IS NOT NULL OR NULLIF(Target.[minValueMessage], Source.[minValueMessage]) IS NOT NULL OR 
	NULLIF(Source.[maxValue], Target.[maxValue]) IS NOT NULL OR NULLIF(Target.[maxValue], Source.[maxValue]) IS NOT NULL OR 
	NULLIF(Source.[maxValueMessage], Target.[maxValueMessage]) IS NOT NULL OR NULLIF(Target.[maxValueMessage], Source.[maxValueMessage]) IS NOT NULL OR 
	NULLIF(Source.[RegExp], Target.[RegExp]) IS NOT NULL OR NULLIF(Target.[RegExp], Source.[RegExp]) IS NOT NULL OR 
	NULLIF(Source.[RegExpText], Target.[RegExpText]) IS NOT NULL OR NULLIF(Target.[RegExpText], Source.[RegExpText]) IS NOT NULL OR 
	NULLIF(Source.[SQLValidator], Target.[SQLValidator]) IS NOT NULL OR NULLIF(Target.[SQLValidator], Source.[SQLValidator]) IS NOT NULL OR 
	NULLIF(Source.[ValidatorMessage], Target.[ValidatorMessage]) IS NOT NULL OR NULLIF(Target.[ValidatorMessage], Source.[ValidatorMessage]) IS NOT NULL OR 
	NULLIF(Source.[OnChangeJsFunction], Target.[OnChangeJsFunction]) IS NOT NULL OR NULLIF(Target.[OnChangeJsFunction], Source.[OnChangeJsFunction]) IS NOT NULL OR 
	NULLIF(Source.[OnChangeProcessName], Target.[OnChangeProcessName]) IS NOT NULL OR NULLIF(Target.[OnChangeProcessName], Source.[OnChangeProcessName]) IS NOT NULL OR 
	NULLIF(Source.[PlaceHolder], Target.[PlaceHolder]) IS NOT NULL OR NULLIF(Target.[PlaceHolder], Source.[PlaceHolder]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[ToolbarName], Target.[ToolbarName]) IS NOT NULL OR NULLIF(Target.[ToolbarName], Source.[ToolbarName]) IS NOT NULL OR 
	NULLIF(Source.[Separator], Target.[Separator]) IS NOT NULL OR NULLIF(Target.[Separator], Source.[Separator]) IS NOT NULL OR 
	NULLIF(Source.[CascadeDependencies], Target.[CascadeDependencies]) IS NOT NULL OR NULLIF(Target.[CascadeDependencies], Source.[CascadeDependencies]) IS NOT NULL OR 
	NULLIF(Source.[RootPathType], Target.[RootPathType]) IS NOT NULL OR NULLIF(Target.[RootPathType], Source.[RootPathType]) IS NOT NULL OR 
	NULLIF(Source.[ImageCompressionType], Target.[ImageCompressionType]) IS NOT NULL OR NULLIF(Target.[ImageCompressionType], Source.[ImageCompressionType]) IS NOT NULL OR 
	NULLIF(Source.[ImageMaxWidth], Target.[ImageMaxWidth]) IS NOT NULL OR NULLIF(Target.[ImageMaxWidth], Source.[ImageMaxWidth]) IS NOT NULL OR 
	NULLIF(Source.[ImageMaxHeight], Target.[ImageMaxHeight]) IS NOT NULL OR NULLIF(Target.[ImageMaxHeight], Source.[ImageMaxHeight]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [Hide] = Source.[Hide], 
  [ParamTypeId] = Source.[ParamTypeId], 
  [TableName] = Source.[TableName], 
  [ObjectName] = Source.[ObjectName], 
  [DefaultValue] = Source.[DefaultValue], 
  [Label] = Source.[Label], 
  [IOTypeId] = Source.[IOTypeId], 
  [PositionX] = Source.[PositionX], 
  [PositionY] = Source.[PositionY], 
  [Width] = Source.[Width], 
  [Height] = Source.[Height], 
  [TypeId] = Source.[TypeId], 
  [Locked] = Source.[Locked], 
  [CustomPropName] = Source.[CustomPropName], 
  [Mask] = Source.[Mask], 
  [SQlSentence] = Source.[SQlSentence], 
  [SQLFilter] = Source.[SQLFilter], 
  [SQLValueField] = Source.[SQLValueField], 
  [SQLDisplayField] = Source.[SQLDisplayField], 
  [SQLObjectName] = Source.[SQLObjectName], 
  [SQLViewName] = Source.[SQLViewName], 
  [SQLOfflineSentence] = Source.[SQLOfflineSentence], 
  [SQLOfflineOrderBy] = Source.[SQLOfflineOrderBy], 
  [WhereSentence] = Source.[WhereSentence], 
  [DetachedFromProcess] = Source.[DetachedFromProcess], 
  [SearchFunction] = Source.[SearchFunction], 
  [SearchCollection] = Source.[SearchCollection], 
  [SearchWhere] = Source.[SearchWhere], 
  [SearchReturnFields] = Source.[SearchReturnFields], 
  [SecurityObject] = Source.[SecurityObject], 
  [AllowNew] = Source.[AllowNew], 
  [AllowNewFunction] = Source.[AllowNewFunction], 
  [AllowNewReturnFields] = Source.[AllowNewReturnFields], 
  [AllowNewDefaults] = Source.[AllowNewDefaults], 
  [ObjNameLink] = Source.[ObjNameLink], 
  [ObjWhereLink] = Source.[ObjWhereLink], 
  [TargetIdLink] = Source.[TargetIdLink], 
  [Style] = Source.[Style], 
  [CSSClass] = Source.[CSSClass], 
  [LabelStyle] = Source.[LabelStyle], 
  [LabelCSSClass] = Source.[LabelCSSClass], 
  [DecimalPlaces] = Source.[DecimalPlaces], 
  [RootPath] = Source.[RootPath], 
  [FormatString] = Source.[FormatString], 
  [DirectTemplate] = Source.[DirectTemplate], 
  [Tag] = Source.[Tag], 
  [HelpId] = Source.[HelpId], 
  [ConnStringId] = Source.[ConnStringId], 
  [IsRequired] = Source.[IsRequired], 
  [IsRequiredMessage] = Source.[IsRequiredMessage], 
  [minValue] = Source.[minValue], 
  [minValueMessage] = Source.[minValueMessage], 
  [maxValue] = Source.[maxValue], 
  [maxValueMessage] = Source.[maxValueMessage], 
  [RegExp] = Source.[RegExp], 
  [RegExpText] = Source.[RegExpText], 
  [SQLValidator] = Source.[SQLValidator], 
  [ValidatorMessage] = Source.[ValidatorMessage], 
  [OnChangeJsFunction] = Source.[OnChangeJsFunction], 
  [OnChangeProcessName] = Source.[OnChangeProcessName], 
  [PlaceHolder] = Source.[PlaceHolder], 
  [IconName] = Source.[IconName], 
  [ToolbarName] = Source.[ToolbarName], 
  [Separator] = Source.[Separator], 
  [CascadeDependencies] = Source.[CascadeDependencies], 
  [RootPathType] = Source.[RootPathType], 
  [ImageCompressionType] = Source.[ImageCompressionType], 
  [ImageMaxWidth] = Source.[ImageMaxWidth], 
  [ImageMaxHeight] = Source.[ImageMaxHeight], 
  [Offline] = Source.[Offline], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ProcessName],[ParamName],[Hide],[ParamTypeId],[TableName],[ObjectName],[DefaultValue],[Label],[IOTypeId],[PositionX],[PositionY],[Width],[Height],[TypeId],[Locked],[CustomPropName],[Mask],[SQlSentence],[SQLFilter],[SQLValueField],[SQLDisplayField],[SQLObjectName],[SQLViewName],[SQLOfflineSentence],[SQLOfflineOrderBy],[WhereSentence],[DetachedFromProcess],[SearchFunction],[SearchCollection],[SearchWhere],[SearchReturnFields],[SecurityObject],[AllowNew],[AllowNewFunction],[AllowNewReturnFields],[AllowNewDefaults],[ObjNameLink],[ObjWhereLink],[TargetIdLink],[Style],[CSSClass],[LabelStyle],[LabelCSSClass],[DecimalPlaces],[RootPath],[FormatString],[DirectTemplate],[Tag],[HelpId],[ConnStringId],[IsRequired],[IsRequiredMessage],[minValue],[minValueMessage],[maxValue],[maxValueMessage],[RegExp],[RegExpText],[SQLValidator],[ValidatorMessage],[OnChangeJsFunction],[OnChangeProcessName],[PlaceHolder],[IconName],[ToolbarName],[Separator],[CascadeDependencies],[RootPathType],[ImageCompressionType],[ImageMaxWidth],[ImageMaxHeight],[Offline],[OriginId])
 VALUES(Source.[ProcessName],Source.[ParamName],Source.[Hide],Source.[ParamTypeId],Source.[TableName],Source.[ObjectName],Source.[DefaultValue],Source.[Label],Source.[IOTypeId],Source.[PositionX],Source.[PositionY],Source.[Width],Source.[Height],Source.[TypeId],Source.[Locked],Source.[CustomPropName],Source.[Mask],Source.[SQlSentence],Source.[SQLFilter],Source.[SQLValueField],Source.[SQLDisplayField],Source.[SQLObjectName],Source.[SQLViewName],Source.[SQLOfflineSentence],Source.[SQLOfflineOrderBy],Source.[WhereSentence],Source.[DetachedFromProcess],Source.[SearchFunction],Source.[SearchCollection],Source.[SearchWhere],Source.[SearchReturnFields],Source.[SecurityObject],Source.[AllowNew],Source.[AllowNewFunction],Source.[AllowNewReturnFields],Source.[AllowNewDefaults],Source.[ObjNameLink],Source.[ObjWhereLink],Source.[TargetIdLink],Source.[Style],Source.[CSSClass],Source.[LabelStyle],Source.[LabelCSSClass],Source.[DecimalPlaces],Source.[RootPath],Source.[FormatString],Source.[DirectTemplate],Source.[Tag],Source.[HelpId],Source.[ConnStringId],Source.[IsRequired],Source.[IsRequiredMessage],Source.[minValue],Source.[minValueMessage],Source.[maxValue],Source.[maxValueMessage],Source.[RegExp],Source.[RegExpText],Source.[SQLValidator],Source.[ValidatorMessage],Source.[OnChangeJsFunction],Source.[OnChangeProcessName],Source.[PlaceHolder],Source.[IconName],Source.[ToolbarName],Source.[Separator],Source.[CascadeDependencies],Source.[RootPathType],Source.[ImageCompressionType],Source.[ImageMaxWidth],Source.[ImageMaxHeight],Source.[Offline],Source.[OriginId])
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





