
CREATE PROCEDURE [dbo].[pArticulosBuscar]	@parametros nvarchar(max)='' 
AS
BEGIN TRY
	declare @registros int       = (select JSON_VALUE(@parametros,'$.registros'))
		  , @buscar varchar(100) = (select JSON_VALUE(@parametros,'$.buscar'))
		  , @IdTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.IdTeleVenta'))
		  , @fechaTV varchar(10) = (select JSON_VALUE(@parametros,'$.fechaTV'))
		  , @nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
		  , @usuario varchar(20) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))
		  , @registro varchar(50) = ''
		  , @marcas varchar(max) = ''
		  , @familias varchar(max) = ''
		  , @subfams varchar(max) = ''
		  , @consulta varchar(max) = ''

	declare @GESTION char(6) = (select top 1 GESTION from Configuracion_SQL)
	declare @elInnerJoin varchar(500) = ''

	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo='Marca') BEGIN
		DECLARE elCursor CURSOR FOR
			select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = @marcas + ' or vArticulos.MARCA='''+@registro+''' '
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
				set @familias = @familias + ' or vArticulos.FAMILIA='''+@registro+''' '
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
				set @subfams = @subfams + ' or vArticulos.SUBFAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@subfams)>0 set @subfams = ' AND (' + SUBSTRING(@subfams,4,LEN(@subfams))+ ')'
	END

	--	configuración Articulos IGES
		DECLARE @WhereIGES varchar(1000) = ''
		if (select ISNULL(valor,'') from Configuracion where nombre='ArticluosIGEST')='1' BEGIN 
			set @elInnerJoin='LEFT join ['+@GESTION+'].DBO.MULTICAM mc on mc.CODIGO collate Modern_Spanish_CS_AI=vArticulos.CODIGO and mc.VALOR collate Modern_Spanish_CS_AI=''.T.'' '
			set @WhereIGES = ' and (mc.VALOR in (NULL,'''',''.T.'')) '
		END

	set @consulta = '
		select (
			select distinct
				(select count(vArticulos.CODIGO) from vArticulos ' + @elInnerJoin + ' 
				where (lower(vArticulos.CODIGO) like ''%''+lower('''+@buscar+''')+''%'' or lower(vArticulos.NOMBRE) like ''%''+lower('''+@buscar+''')+''%'') ' 
				+ @marcas + @familias + @subfams + ') as registros
				, vArticulos.* 
			from vArticulos 
			' + @elInnerJoin + ' 
			where (lower(vArticulos.CODIGO) like ''%''+lower('''+@buscar+''')+''%'' or lower(vArticulos.NOMBRE) like ''%''+lower('''+@buscar+''')+''%'' ) 
			' + @marcas + @familias + @subfams + ' 			
			for JSON AUTO
		) as JAVASCRIPT	
	'
	--select @consulta
	EXEC (@consulta)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
