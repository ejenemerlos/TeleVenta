
CREATE PROCEDURE [dbo].[pListadosGestores] @parametros varchar(max)='[]'
AS
SET NOCOUNT ON
BEGIN TRY
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@NombreListado varchar(100) = isnull((select JSON_VALUE(@parametros,'$.NombreListado')),'')
		,	@ListadosFDesde varchar(10) = isnull((select JSON_VALUE(@parametros,'$.ListadosFDesde')),'')
		,	@ListadosFHasta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.ListadosFHasta')),'')
	

	if @modo='dameGestores' BEGIN
		select isnull(
			(
				select * from vGestores
				for JSON AUTO, INCLUDE_NULL_VALUES
			)
		,'[]') as JAVASCRIPT
	END
	

	if @modo='dameListado' BEGIN   
		--	obtener llamadas según criterios
				declare   @nDia varchar(10)
						, @gestores varchar(max)
						, @rutas varchar(max)
						, @vendedores varchar(max)

		-- -- montar where gestores
		declare @losGestores varchar(8000)=''
		declare @elAnd char(5) = ''
		declare @cnt int = 0
		declare @valor varchar(1000)
		declare cur CURSOR for select [value] from openjson(@parametros,'$.losGestores')
		OPEN cur FETCH NEXT FROM cur into @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @losGestores = @losGestores + '('+JSON_VALUE(@valor,'$.codigo')+') '+JSON_VALUE(@valor,'$.nombre') + ' - '
				if @cnt>0 set @elAnd=' or '
				set @gestores = CONCAT(@gestores, @elAnd, ' a.cliente in (select cliente from cliente_gestor where gestor='''+JSON_VALUE(@valor,'$.codigo')+''') ')
				set @cnt = @cnt+1
			FETCH NEXT FROM cur INTO @valor END 
		CLOSE cur deallocate cur
		if @gestores is null set @gestores='' 
		ELSE set @gestores=' and ('+replace(@gestores,''' a.cliente in (select cliente from cliente_gestor where gestor='''+JSON_VALUE(@valor,'$.codigo')+''') ',''' OR a.cliente in (select cliente from cliente_gestor where gestor='''+@valor+''') ')+') '

		set @losGestores = SUBSTRING(@losGestores,0,LEN(@losGestores));

		declare @idListado varchar(50) = 
		replace(replace(replace(replace(replace(convert(varchar,getdate(),121),' ',''),'/',''),':',''),'.',''),'-','') 

		-- intervalo de fechas
		declare @fDesde bigint = cast(FORMAT(cast(@ListadosFDesde as smalldatetime),'yyyyMMdd') as bigint)
			,	@fHasta bigint = cast(FORMAT(cast(@ListadosFHasta as smalldatetime),'yyyyMMdd') as bigint)						
			,	@fecha varchar(10) = @ListadosFDesde
			,	@mismaFecha bit=0

		while cast(@fecha as smalldatetime)<=cast(@ListadosFHasta as smalldatetime) and @mismaFecha=0 BEGIN
			if @fDesde=@fHasta set @mismaFecha=1
			
			set @nDia = replace(replace( lower(DATENAME(dw,@fecha)),'á','a' ),'é','e' )
			declare @sql varchar(max) = '
				insert into [TeleVentaListados] (id, nombreListado, fecha, hasta, gestor, cliente, horario)
				select '''+@idListado+''' as id, '''+@NombreListado+''', '''+@fecha+''', '''+@ListadosFHasta+''', '''+@losGestores+''', a.cliente, isnull(a.hora_'+@nDia+','''') as horario
				from clientes_adi a
				inner join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=a.cliente
				where '+@nDia+'=1 '+@gestores+'
				and a.cliente not in (select cliente from TeleVentaListados where nombreListado='''+@NombreListado+''' and fecha='''+@fecha+''')
			'
			EXEC(@sql)

			-- Eliminar registros que no tocan (quincenales, mensuales a cada n días)																						
			declare @fechaBIG bigint = cast(FORMAT(cast(@fecha as smalldatetime),'yyyyMMdd') as bigint)	
			declare elCursor CURSOR for
				select a.cliente, b.tipo_llama
				from TeleVentaListados a
				inner join clientes_adi b on a.cliente collate SQL_Latin1_General_CP1_CI_AS=b.cliente and b.tipo_llama in (3,4,5)
				where a.id=@idListado

			declare @cli varchar(50), @tipo_llama int
			OPEN elCursor FETCH NEXT FROM elCursor INTO @cli, @tipo_llama
			WHILE (@@FETCH_STATUS=0) BEGIN				
				declare @UltimaLlamada varchar(10)				
				select top 1 @UltimaLlamada=convert(varchar(10),FechaInsertUpdate,105)
				from TeleVentaDetalle where cliente=@cli order by FechaInsertUpdate desc
			
				if (	-- quincenal
						(@tipo_llama=3 and (DATEPART(ISO_WEEK,@UltimaLlamada)=DATEPART(ISO_WEEK, @fecha) or DATEPART(ISO_WEEK,@UltimaLlamada)=DATEPART(ISO_WEEK, @fecha)-1))															
						-- mensual
						or (@tipo_llama=4 and MONTH(@UltimaLlamada)=MONTH(@fecha))
				
						-- cada n días
						or (
							@tipo_llama=5 and (cast(FORMAT(dateadd(day,-(select dias_period from clientes_adi where cliente=@cli),cast(@fecha as smalldatetime)),'yyyyMMdd') as bigint))
							= 
							(select top 1 cast(FORMAT(isnull(cast(FechaInsertUpdate as smalldatetime),'01-01-1900'),'yyyyMMdd') as bigint) 
							from TeleVentaDetalle where cliente=@cli order by FechaInsertUpdate desc)
						)
					) 
				BEGIN 
					delete TeleVentaListados where nombreListado=@NombreListado and cliente=@cli and fecha=@fecha
				END	
			
				FETCH NEXT FROM elCursor INTO @cli, @tipo_llama
			END	CLOSE elCursor deallocate elCursor

			-- comprobar [Llamar otro día] y añadir al televenta si coinciden las fechas
			set @sql = '
			insert into [TeleVentaListados] (id, nombreListado, fecha, hasta, gestor, cliente, horario)
				select '''+@idListado+''' as id
					, '''+@NombreListado+'''
					, '''+@fecha+'''
					, '''+@ListadosFHasta+'''
					, '''+@losGestores+'''
					, cliente
					, isnull(substring(cast(fechaHora as varchar),13,5)+'' - ''+substring(cast(fechaHora as varchar),13,5),'''') as horario
				from llamadasOD
				where convert(varchar(10),fechaHora,105)='''+@fecha+''' '+replace(@gestores,'a.','')+' and insertada=0 
			update llamadasOD set insertada=1 where convert(varchar(10),fechaHora,105)='''+@fecha+''' '+replace(@gestores,'a.','')+'
			'
			EXEC(@sql)
			set @fecha = FORMAT(cast(dateadd(day,1,cast(@fecha as smalldatetime)) as smalldatetime),'dd-MM-yyyy')				
		END

		select isnull(
			(
				select * from TeleVentaListados where id=@idListado
				for JSON AUTO, INCLUDE_NULL_VALUES
			)
		,'[]') as JAVASCRIPT
	END

	return -1
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= concat(
		 'Error [pListadosGestores] !!!'
		, char(13), ERROR_MESSAGE()
		, char(13), ERROR_NUMBER()
		, char(13), ERROR_PROCEDURE()
		, char(13), @@PROCID
		, char(13), ERROR_LINE()
	)
	RAISERROR(@CatchError,12,1)

	declare @accion varchar(max) = CONCAT('ERROR SP: [pListados]', @modo)
	
	EXEC [pMerlos_LOG] @accion=@accion, @error=@CatchError

	RETURN 0
END CATCH
