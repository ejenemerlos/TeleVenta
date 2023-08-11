CREATE PROCEDURE [dbo].[pArticulosCliente]  ( @parametros varchar(max) )
AS
BEGIN TRY
	
	declare   @MesesConsumo int 
			, @desde smalldatetime
			, @cliente varchar(20) = (select JSON_VALUE(@parametros,'$.cliente'))
			, @artCli varchar(max)
			, @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
			, @articulo varchar(50) = (select JSON_VALUE(@parametros,'$.articulo'))
			, @IdTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.IdTeleVenta'))
			, @fechaTV varchar(10) = (select JSON_VALUE(@parametros,'$.fechaTV'))
			, @nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
			, @usuario varchar(20) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))
			, @registro varchar(50) = ''
			, @marcas varchar(max) = ''
			, @familias varchar(max) = ''
			, @subfams varchar(max) = ''
			, @consulta varchar(max) = ''
			
	declare   @gestion char(6)
			, @letra char(2)
			, @gestionAnt char(6)
			, @ejercicio char(4)
			, @ejercicioAnt char(4)

	select @gestion=GESTION, @letra=LETRA, @ejercicio=EJERCICIO from Configuracion_SQL
			
	set @ejercicioAnt = isnull(cast(@ejercicio as int)-1,'')
	set @gestionAnt = isnull(concat(@ejercicioAnt,@letra), '')


	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo='Marca') BEGIN
		DECLARE elCursor CURSOR FOR
			select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = @marcas + ' or ART.MARCA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@marcas)>0 set @marcas = ' AND (' + SUBSTRING(@marcas,4,LEN(@marcas))+ ')'
	END

	set @registro = ''
	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo='Familia') BEGIN
		DECLARE elCursor CURSOR FOR
			select familia from familia_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @familias = @familias + ' or ART.FAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@familias)>0 set @familias = ' AND (' + SUBSTRING(@familias,4,LEN(@familias))+ ')'
	END

	set @registro = ''
	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo='Subfamilia') BEGIN
		DECLARE elCursor CURSOR FOR
			select subfamilia from subfam_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @subfams = @subfams + ' or ART.SUBFAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@subfams)>0 set @subfams = ' AND (' + SUBSTRING(@subfams,4,LEN(@subfams))+ ')'
	END

	set @MesesConsumo = (select top 1 MesesConsumo from Configuracion_SQL)
	set @desde = replace(convert(varchar(10),dateadd(month, - @MesesConsumo,getdate()),103),'/','-')
	


	-- -------------------------------------------------------------------
	--      Últimas ventas del artículo (al pasar sobre el artículo)
	-- -------------------------------------------------------------------
	/*
	pArticulosCliente
	'{"modo":"UltimasVentasArticulo","registros":0,"buscar":"","cliente":"4300200043","IdTeleVenta":"20210625094058393"
	,"fechaTV":"30-06-2021","nombreTV":"30-06/2021","paramStd":[{"currentRole":"Admins","currentReference":"909"}]}'
	*/
	if @modo='UltimasVentasArticulo' BEGIN
		set @consulta = '
		WITH VENTAS (FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE)
		AS
		(
			SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, ART.NOMBRE AS DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, dav.precio, dav.dto1, dav.importe 
			FROM ['+@gestion+'].DBO.C_ALBVEN CAV 
			INNER JOIN ['+@gestion+'].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
			INNER JOIN ['+@gestion+'].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
			INNER JOIN ['+@gestion+'].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO AND ART.BAJA=0
			INNER JOIN Configuracion_SQL CON ON 1=1
			WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
			AND DAV.ARTICULO='''+@articulo+''' 
			AND CLI.CODIGO='''+@cliente+''' '+@marcas+' ' +@familias+ ' ' +@subfams+ '

			UNION ALL

			SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, ART.NOMBRE AS DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, dav.precio
			, dav.dto1, dav.importe 
			FROM ['+@gestionAnt+'].DBO.C_ALBVEN CAV 
			INNER JOIN ['+@gestionAnt+'].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
			INNER JOIN ['+@gestion+'].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
			INNER JOIN ['+@gestion+'].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO AND ART.BAJA=0
			INNER JOIN Configuracion_SQL CON ON 1=1
			WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
			AND DAV.ARTICULO='''+@articulo+''' 
			AND CLI.CODIGO='''+@cliente+''' '+@marcas+' ' +@familias+ ' ' +@subfams+ '
		)


		SELECT ISNULL(
			(
			SELECT top 10 convert(varchar(10),FECHA,105) as FECHA
			, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE
			FROM VENTAS  
			group by FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE 
			ORDER BY cast(FECHA as smalldatetime) DESC
			for JSON AUTO, INCLUDE_NULL_VALUES
			)
		,''[]'') AS JAVASCRIPT
		'
		exec(@consulta)
		return -1
	END




	-- -------------------------------------------------------------------
	-- Última venta del Cliente (Listado general al hacer clic en PEDIDO)
	-- -------------------------------------------------------------------
	/*
	pArticulosCliente
	'{"registros":0,"buscar":"","cliente":"4300230033","IdTeleVenta":"20221019085146110","fechaTV":"19-10-2022","nombreTV":"AGENDA MIÉRCOLES 19/10 Gestor+Serie","paramStd":[{"currentRole":"Admins","currentReference":"T1"}]}'
	*/
	set @consulta = '
	WITH VENTAS (FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, /*PVP,*/ UNICAJA, PesoArticulo)
	AS
	(
		SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, ART.NOMBRE AS DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO,/*PVP.PVP
		,*/ ART.UNICAJA, ART.PESO as PesoArticulo
		FROM ['+@gestion+'].DBO.C_ALBVEN CAV 
		INNER JOIN ['+@gestion+'].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
		INNER JOIN ['+@gestion+'].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
		INNER JOIN ['+@gestion+'].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO AND ART.BAJA=0
		INNER JOIN [Configuracion_SQL] CON ON 1=1
		/*INNER JOIN ['+@gestion+'].DBO.PVP PVP ON PVP.ARTICULO=DAV.ARTICULO */
		WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
		AND CLI.CODIGO='''+@cliente+''' '+@marcas+' ' +@familias+ ' ' +@subfams+ '

		UNION ALL

		SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, ART.NOMBRE AS DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, /*PVP.PVP 
		,*/ ART.UNICAJA, ART.PESO as PesoArticulo
		FROM ['+@gestionAnt+'].DBO.C_ALBVEN CAV 
		INNER JOIN ['+@gestionAnt+'].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
		INNER JOIN ['+@gestionAnt+'].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
		INNER JOIN ['+@gestionAnt+'].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO AND ART.BAJA=0
		INNER JOIN [Configuracion_SQL] CON ON 1=1
		/*INNER JOIN ['+@gestionAnt+'].DBO.PVP PVP ON PVP.ARTICULO=DAV.ARTICULO */
		WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
		AND CLI.CODIGO='''+@cliente+''' '+@marcas+' ' +@familias+ ' ' +@subfams+ '
	)

	select isnull(
	( 
		SELECT V1.CLIENTE, V1.ARTICULO as CODIGO, replace(V1.DEFINICION,''"'',''-'') as NOMBRE
		, V1.CAJAS, V1.UDS, V1.PESO, /*V1.PVP,*/ V1.UNICAJA, V1.PesoArticulo
		, SUM(STC.StockVirtual) AS StockVirtual    
		, SUM(STC.StockReal) AS StockReal 
		FROM VENTAS V1 
		INNER JOIN 
		(SELECT MAX(FECHA) AS FECHA, CLIENTE, ARTICULO FROM VENTAS GROUP BY CLIENTE, ARTICULO ) V2 
		ON V2.FECHA=V1.FECHA AND V2.CLIENTE=V1.CLIENTE AND V2.ARTICULO=V1.ARTICULO
		LEFT JOIN vStock STC ON STC.ARTICULO=V1.ARTICULO 
		GROUP BY  V1.FECHA, V1.CLIENTE, V1.ARTICULO, V1.DEFINICION, V1.CAJAS, V1.UDS, V1.PESO, /*V1.PVP,*/ V1.UNICAJA, V1.PesoArticulo
		ORDER BY V1.CLIENTE, V1.ARTICULO
		FOR JSON AUTO, INCLUDE_NULL_VALUES
	),''[]'')  as JAVASCRIPT 	
	'
	-- select @consulta  
	exec(@consulta)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH

