

BEGIN TRY

MERGE INTO [Pages] AS Target
USING (VALUES
  (N'8462DB46-6433-4DED-854E-E390DC933587',N'list',N'Cliente',NULL,N'default',N'list Cliente',N'noicon',N'{{ObjectDescrip}}',NULL,NULL,0,NULL,0,1,0,NULL,0,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'view',N'Cliente',NULL,N'default',N'view Cliente',N'noicon',N'{{ObjectDescrip}}',NULL,N'
comprobarModuloClientePedidos();
comprobarModuloRecibosPendientes();


function comprobarModuloClientePedidos(){ 
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos'']").is(":visible")){
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos''] .icon-minus").click();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos''] div.cntBodyHeader, flx-module[modulename=''Cliente_Pedidos''] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloClientePedidos(); },100); }
}

function comprobarModuloRecibosPendientes(){ 
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes'']").is(":visible")){
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes''] .icon-minus").click();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes''] div.cntBodyHeader, flx-module[modulename=''TV_Recibos_Pendientes''] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloRecibosPendientes(); },100); }
}
',1,NULL,0,1,0,NULL,0,1)
 ,(N'C408D692-F571-40FF-8C6F-79C80314E7C2',N'list',N'inciCLI',NULL,N'default',N'list inciCLI',N'noicon',N'{{ObjectDescrip}}',NULL,NULL,0,NULL,0,1,0,NULL,0,1)
 ,(N'Merlos_ClientesArticulos',N'generic',NULL,NULL,N'default',N'Merlos_ClientesArticulos',N'articles',N'Merlos_ClientesArticulos',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'Merlos_Version',N'generic',NULL,NULL,N'default',N'Versioning',N'noicon',N'Versioning',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'Ruta',N'generic',NULL,N'webdefault',N'default',N'Ruta',N'noicon',N'Ruta',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'Supervisor',N'generic',NULL,N'webdefault',N'default',N'Supervisor',N'noicon',N'Supervisor',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'TeleVenta',N'generic',N'Cliente',NULL,N'MI_1_2_1',N'TeleVenta',N'noicon',N'Pantalla de Tele Venta',NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").hide();

// Comprobar Ejercicio en Curso ----------------------------------------------------------------------------------------------------------------------------
var parametros = ''{"sp":"pConfiguracion","modo":"ComprobarEjercicio"}'';
flexygo.nav.execProcess(''pMerlos'', '''', null, null, [{ ''Key'': ''parametros'', ''Value'': limpiarCadena(parametros) }], ''current'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret) {
    if (ret) {
        if (ret.JSCode !== "") { console.log("Se ha actualizado el portal al ejercicio " + ret.JSCode); }
    } else { alert(''Error S.P. pConfiguracion - ComprobarEjercicio!!!\n'' + JSON.stringify(ret)); }
}, false);
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


if ((flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults) !== null && (flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults) !== undefined) {
    var elJSON = JSON.parse(flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults);
    try { ClienteCodigo = elJSON.CODIGO; } catch { ClienteCodigo = ""; }
}

setTimeout(function() {
    if (ClienteCodigo !== "") {
        cargarTeleVentaCliente(ClienteCodigo);
        cargarTeleVentaLlamadas("llamadasDelCliente");
        cargarTeleVentaUltimosPedidos(ClienteCodigo);
    } else { cargarTeleVentaLlamadas("listaGlobal"); }
}, 1000);

/*  TV_Pedido  **************************************************************************************************************** */
cargarIncidencias("art");
cargarIncidencias("cli");',1,NULL,0,0,0,NULL,0,1)
 ,(N'TV_Listados',N'generic',NULL,NULL,N'default',N'TV_Listados',N'noicon',N'TV_Listados',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'Vendedor',N'generic',NULL,N'webdefault',N'default',N'Vendedor',N'noicon',N'Vendedor',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
) AS Source ([PageName],[TypeId],[ObjectName],[InterfaceName],[LayoutName],[Name],[IconName],[Descrip],[UrlRewrite],[Script],[ScriptActive],[Style],[RefreshInterval],[Sytem],[Generic],[BodyCssClass],[Offline],[OriginId])
ON (Target.[PageName] = Source.[PageName])
WHEN MATCHED AND (
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[InterfaceName], Target.[InterfaceName]) IS NOT NULL OR NULLIF(Target.[InterfaceName], Source.[InterfaceName]) IS NOT NULL OR 
	NULLIF(Source.[LayoutName], Target.[LayoutName]) IS NOT NULL OR NULLIF(Target.[LayoutName], Source.[LayoutName]) IS NOT NULL OR 
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[UrlRewrite], Target.[UrlRewrite]) IS NOT NULL OR NULLIF(Target.[UrlRewrite], Source.[UrlRewrite]) IS NOT NULL OR 
	NULLIF(Source.[Script], Target.[Script]) IS NOT NULL OR NULLIF(Target.[Script], Source.[Script]) IS NOT NULL OR 
	NULLIF(Source.[ScriptActive], Target.[ScriptActive]) IS NOT NULL OR NULLIF(Target.[ScriptActive], Source.[ScriptActive]) IS NOT NULL OR 
	NULLIF(Source.[Style], Target.[Style]) IS NOT NULL OR NULLIF(Target.[Style], Source.[Style]) IS NOT NULL OR 
	NULLIF(Source.[RefreshInterval], Target.[RefreshInterval]) IS NOT NULL OR NULLIF(Target.[RefreshInterval], Source.[RefreshInterval]) IS NOT NULL OR 
	NULLIF(Source.[Sytem], Target.[Sytem]) IS NOT NULL OR NULLIF(Target.[Sytem], Source.[Sytem]) IS NOT NULL OR 
	NULLIF(Source.[Generic], Target.[Generic]) IS NOT NULL OR NULLIF(Target.[Generic], Source.[Generic]) IS NOT NULL OR 
	NULLIF(Source.[BodyCssClass], Target.[BodyCssClass]) IS NOT NULL OR NULLIF(Target.[BodyCssClass], Source.[BodyCssClass]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [TypeId] = Source.[TypeId], 
  [ObjectName] = Source.[ObjectName], 
  [InterfaceName] = Source.[InterfaceName], 
  [LayoutName] = Source.[LayoutName], 
  [Name] = Source.[Name], 
  [IconName] = Source.[IconName], 
  [Descrip] = Source.[Descrip], 
  [UrlRewrite] = Source.[UrlRewrite], 
  [Script] = Source.[Script], 
  [ScriptActive] = Source.[ScriptActive], 
  [Style] = Source.[Style], 
  [RefreshInterval] = Source.[RefreshInterval], 
  [Sytem] = Source.[Sytem], 
  [Generic] = Source.[Generic], 
  [BodyCssClass] = Source.[BodyCssClass], 
  [Offline] = Source.[Offline], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PageName],[TypeId],[ObjectName],[InterfaceName],[LayoutName],[Name],[IconName],[Descrip],[UrlRewrite],[Script],[ScriptActive],[Style],[RefreshInterval],[Sytem],[Generic],[BodyCssClass],[Offline],[OriginId])
 VALUES(Source.[PageName],Source.[TypeId],Source.[ObjectName],Source.[InterfaceName],Source.[LayoutName],Source.[Name],Source.[IconName],Source.[Descrip],Source.[UrlRewrite],Source.[Script],Source.[ScriptActive],Source.[Style],Source.[RefreshInterval],Source.[Sytem],Source.[Generic],Source.[BodyCssClass],Source.[Offline],Source.[OriginId])
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





