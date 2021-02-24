CREATE PROCEDURE [dbo].[pArticulosCliente]  ( @parametros varchar(max) )
AS
BEGIN TRY
	declare   @MesesConsumo int 
			, @desde smalldatetime
			, @cliente varchar(20) = (select JSON_VALUE(@parametros,'$.cliente'))
			, @artCli varchar(max)
			, @modo varchar(50) = (select JSON_VALUE(@parametros,'$.modo'))
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

	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo='Marca') BEGIN
		DECLARE elCursor CURSOR FOR
			select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = @marcas + ' or MARCA='''+@registro+''' '
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
				set @familias = @familias + ' or FAMILIA='''+@registro+''' '
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
				set @subfams = @subfams + ' or SUBFAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@subfams)>0 set @subfams = ' AND (' + SUBSTRING(@subfams,4,LEN(@subfams))+ ')'
	END

	set @MesesConsumo = (select top 1 MesesConsumo from Configuracion_SQL)
	set @desde = replace(convert(varchar(10),dateadd(month, - @MesesConsumo,getdate()),103),'/','-')
		
	set @consulta = CONCAT('select (
	select isnull(
		(select dpv.articulo as CODIGO
			, dpv.DEFINICION as NOMBRE
			, articulo.UNICAJA
			, articulo.peso
			, dpv.CAJAS as CajasALB
			, dpv.UNIDADES as UnidadesALB
			, dpv.PESO as PesoALB
			-- datos de los últimos 5 albaranes
			, (select top 5  p.IDALBARAN , p.sqlfecha, p.fecha
							, d.ALBARAN, d.ARTICULO, d.cajas, d.UNIDADES, d.PESO, d.PRECIOIVA, d.IMPORTEf, d.DTO1
							from vAlbaranes p
							inner join vAlbaranes_Detalle d on d.IDALBARAN=p.IDALBARAN
							where p.cliente=''',@cliente,''' and d.ARTICULO=dpv.ARTICULO
							order by p.sqlFecha desc
							for JSON AUTO
				) as pedidos
			from vAlbaranes_Detalle dpv
			left join vAlbaranes cpv on cpv.IDALBARAN=dpv.IDALBARAN
			inner join vArticulos articulo on articulo.CODIGO collate Modern_Spanish_CI_AI=dpv.ARTICULO
			where cpv.CLIENTE=''',@cliente,''' and cpv.sqlFecha>=''',@desde,''' ' , @marcas , @familias , @subfams , '
			group by  dpv.articulo
			, dpv.DEFINICION
			, articulo.UNICAJA
			, articulo.peso
			, dpv.CAJAS
			, dpv.UNIDADES
			, dpv.PESO
		order by max(cpv.sqlFecha) desc, max(cpv.numero) desc
		for JSON AUTO
		),''[]'')
	) as JAVASCRIPT')

 	exec (@consulta)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH