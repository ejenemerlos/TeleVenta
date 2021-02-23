CREATE PROCEDURE [dbo].[pOperadorConfig] @elJS nvarchar(max)=''
AS
BEGIN TRY
	declare   @modo varchar(50)		= (select JSON_VALUE(@elJS,'$.modo'))
			, @nombreTV varchar(100)= (select JSON_VALUE(@elJS,'$.nombreTV'))
			, @fecha varchar(10)	= (select JSON_VALUE(@elJS,'$.fecha'))
			, @rol varchar(20)		= (select JSON_VALUE(@elJS,'$.paramStd[0].currentRole'))
			, @usuario varchar(20)	= (select JSON_VALUE(@elJS,'$.paramStd[0].currentReference'))
	
	if @fecha is null or @fecha='' set @fecha='PENDIENTE'	

	if @modo='guardar' BEGIN
		--	comprobar que no exista el nombreTV
		if exists (select * from llamadas_user where usuario=@usuario and nombreTV=@nombreTV and fecha=@fecha) begin select 'nombreTV_Existe!' as JAVASCRIPT return -1 end

		declare @i int, @valor varchar(1000) 
		
		delete gestor_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Gestor')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into gestor_user (usuario,gestor,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Gestor')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur	

		delete ruta_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Ruta')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into ruta_user (usuario,ruta,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Ruta')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur	

		delete vend_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Vendedor')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into vend_user (usuario,vendedor,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Vendedor')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur	

		delete serie_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Serie')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into serie_user (usuario,serie,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Serie')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur
		
		delete marca_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Marca')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into marca_user (usuario,marca,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Marca')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur
		
		delete familia_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Familia')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into familia_user (usuario,familia,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Familia')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur
		
		delete subfam_user where usuario=@usuario and nombreTV=@nombreTV and (fecha='' or fecha='PENDIENTE' or fecha=@fecha)
		declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Subfamilia')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			insert into subfam_user (usuario,subfamilia,fecha,nombreTV) values (@usuario, (select JSON_VALUE(@valor,'$.Subfamilia')), @fecha, @nombreTV)
			FETCH NEXT FROM cur INTO @i, @valor
		END CLOSE cur deallocate cur	
	END

	--	Obtener Gestor, Ruta, Vendedor, Serie, Marca, Familia y Subfamilia
		declare @gestor varchar(max) = 
		(select ltrim(rtrim(u.gestor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as gestor 
		from gestor_user u
		inner join vGestores v on v.CODIGO collate Modern_Spanish_CS_AI=u.gestor
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @ruta varchar(max) = 
		(select ltrim(rtrim(u.ruta))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as ruta 
		from ruta_user u
		inner join vRutas v on v.CODIGO collate Modern_Spanish_CS_AI=u.ruta
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @vendedor varchar(max) = 
		(select ltrim(rtrim(u.vendedor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as vendedor 
		from vend_user u
		inner join vVendedores v on v.CODIGO collate Modern_Spanish_CS_AI=u.vendedor
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @serie varchar(max) = 
		(select ltrim(rtrim(u.serie))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as serie 
		from serie_user u
		inner join vSeries v on v.codigo collate Modern_Spanish_CS_AI=u.serie
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @marca varchar(max) = 
		(select ltrim(rtrim(u.marca))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as marca 
		from marca_user u
		inner join vMarcas v on v.codigo collate Modern_Spanish_CS_AI=u.marca
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @familia varchar(max) = 
		(select ltrim(rtrim(u.familia))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as familia 
		from familia_user u
		inner join vFamilias v on v.codigo collate Modern_Spanish_CS_AI=u.familia
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		declare @subfamilia varchar(max) = 
		(select ltrim(rtrim(u.subfamilia))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as subfamilia 
		from subfam_user u
		inner join vSubFamilias v on v.codigo collate Modern_Spanish_CS_AI=u.subfamilia
		where u.usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV for JSON AUTO)

		--	guardar registros en llamadas_user
		declare   @nDia varchar(10)
				, @gestores varchar(max)
				, @rutas varchar(max)
				, @vendedores varchar(max)
				, @series varchar(max)
				, @marcas varchar(max)
				, @familias varchar(max)
				, @subfamilias varchar(max)

		set @nDia = replace(replace( lower(DATENAME(dw,@fecha)),'á','a' ),'é','e' )

		-- montar where gestores
		declare @jsGestores varchar(max) = (select gestor from gestor_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('gestores'))
		set @i=0 set @valor='' 
		declare cur CURSOR for select [key], [value] from openjson(@jsGestores,'$.gestores')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @gestores = CONCAT(@gestores, ' cli.gestor='''+(select JSON_VALUE(@valor,'$.gestor'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @gestores is null set @gestores='' 
		ELSE set @gestores=' and ('+replace(@gestores,''' cli.gestor',''' OR cli.gestor')+') '

		-- montar where rutas
		declare @jsRutas varchar(max) = (select ruta from ruta_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('rutas'))
		set @i=0 set @valor='' 
		declare cur CURSOR for select [key], [value] from openjson(@jsRutas,'$.rutas')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @rutas = CONCAT(@rutas, ' cli.ruta='''+(select JSON_VALUE(@valor,'$.ruta'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @rutas is null set @rutas='' 
		ELSE set @rutas=' and ('+replace(@rutas,''' cli.RUTA',''' OR cli.RUTA')+') '

		-- montar where vendedores
		declare @jsVendedores varchar(max) = (select vendedor from vend_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('vendedores'))
		set @i=0 set @valor='' 
		declare cur CURSOR for select [key], [value] from openjson(@jsVendedores,'$.vendedores')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @vendedores = CONCAT(@vendedores, ' cli.VENDEDOR='''+(select JSON_VALUE(@valor,'$.vendedor'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @vendedores is null set @vendedores='' 
		ELSE set @vendedores=' and ('+replace(@vendedores,''' cli.VENDEDOR',''' OR cli.VENDEDOR')+') '

		-- montar where series
		declare @jsSeries varchar(max) = (select serie from serie_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('series'))
		set @i=0 set @valor=''
		declare cur CURSOR for select [key], [value] from openjson(@jsSeries,'$.series')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @series = CONCAT(@series, ' cpv.letra='''+(select JSON_VALUE(@valor,'$.serie'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @series is null set @series='' 
		ELSE set @series=' and ('+replace(@series,''' cpv.letra',''' OR cpv.letra')+') '

		-- montar where marcas
		declare @jsMarcas varchar(max) = (select marca from marca_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('marcas'))
		set @i=0 set @valor=''
		declare cur CURSOR for select [key], [value] from openjson(@jsMarcas,'$.marcas')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = CONCAT(@marcas, ' art.MARCA='''+(select JSON_VALUE(@valor,'$.marca'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @marcas is null set @marcas='' 
		ELSE set @marcas=' and ('+replace(@marcas,''' art.MARCA',''' OR art.MARCA')+') '

		-- montar where familias
		declare @jsFamilias varchar(max) = (select familia from familia_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('familias'))
		set @i=0 set @valor=''
		declare cur CURSOR for select [key], [value] from openjson(@jsFamilias,'$.familias')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @familias = CONCAT(@familias, ' art.FAMILIA='''+(select JSON_VALUE(@valor,'$.familia'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @familias is null set @familias='' 
		ELSE set @familias=' and ('+replace(@familias,''' art.FAMILIA',''' OR art.FAMILIA')+') '

		-- montar where subfamilias
		declare @jsSubFamilias varchar(max) = (select subfamilia from subfam_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV 
		for JSON PATH,ROOT('subfamilias'))
		set @i=0 set @valor=''
		declare cur CURSOR for select [key], [value] from openjson(@jsSubFamilias,'$.subfamilias')
		OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @subfamilias = CONCAT(@subfamilias, ' art.SUBFAMILIA='''+(select JSON_VALUE(@valor,'$.subfamilia'))+'''')
			FETCH NEXT FROM cur INTO @i, @valor END 
		CLOSE cur deallocate cur
		if @subfamilias is null set @subfamilias='' 
		ELSE set @subfamilias=' and ('+replace(@subfamilias,''' art.SUBFAMILIA',''' OR art.SUBFAMILIA')+') '

		set @serie=''

		declare @consulta varchar(max)
		set @consulta = '
			select distinct cast('''+@nombreTV+''' as varchar(100)) as nombreTV, '''+@usuario+''' as usuario, '''+@fecha+''' as fecha
			, ll.[cliente],ll.[lunes],ll.[hora_lunes],ll.[martes],ll.[hora_martes],ll.[miercoles],ll.[hora_miercoles]
			, ll.[jueves],ll.[hora_jueves],ll.[viernes],ll.[hora_viernes],ll.[sabado],ll.[hora_sabado],ll.[domingo],ll.[hora_domingo]
			, ll.[tipo_llama],ll.[dias_period]

			, case when exists (select pedido from llamadas where fecha='''+@fecha+''' and cliente=ll.cliente and usuario='''+@usuario+''' and nombreTV='''+@nombreTV+''') then 1 else 0 end as completado
			, case when exists (select pedido from llamadas where fecha='''+@fecha+''' and cliente=ll.cliente and usuario='''+@usuario+''' and nombreTV='''+@nombreTV+''') then ''COMPLETADO'' else ''PENDIENTE'' end as nCompletado
			, case when exists (select idpedido from llamadas where fecha='''+@fecha+''' and cliente=ll.cliente and usuario='''+@usuario+''' and nombreTV='''+@nombreTV+''') then isnull(ll.idpedido,'''''''') else '''' end as idpedido
			, case when exists (select pedido from llamadas where fecha='''+@fecha+''' and cliente=ll.cliente and usuario='''+@usuario+''' and nombreTV='''+@nombreTV+''') then isnull(ll.pedido,'''''''') else '''' end as pedido

			, ll.NOMBRE
			, cli.VENDEDOR
			, hora_'+@nDia+' as horario
			from vLlamadas ll
			left join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=ll.cliente
			where ll.'+@nDia+'=1 '+@gestores+' '+@rutas+' '+@vendedores+' '+'
			order by horario ASC
		'  
		-- print @consulta return -1
		declare @llamUser1 int = (select count(usuario) from llamadas_user)
		delete from llamadas_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV and tipo_llama<>0
		exec ('insert into llamadas_user '+@consulta)
		declare @llamUser2 int = (select count(usuario) from llamadas_user)
		declare @llamUser int = @llamUser1 - @llamUser2 -- diferencia de registros antes y después del insert

		if @gestor='' or @gestor is null set @gestor = '[]'
		if @ruta='' or @ruta is null set @ruta = '[]'
		if @vendedor='' or @vendedor is null set @vendedor = '[]'
		if @serie='' or @serie is null set @serie = '[]'
		if @marca='' or @marca is null set @marca = '[]'
		if @familia='' or @familia is null set @familia = '[]'
		if @subfamilia='' or @subfamilia is null set @subfamilia = '[]'

		declare @serieActiva char(2) = isnull(
										(select serie from serie_user where usuario=@usuario and fecha=@fecha and nombreTV=@nombreTV)
										,(select TVSerie from Configuracion_SQL))

		select   '{"gestor":'+@gestor+',"ruta":'+@ruta+',"vendedor":'+@vendedor+',"serie":'+@serie+',"marca":'+@marca+',"familia":'+@familia
				+',"subfamilia":'+@subfamilia+',"fecha":"'+isnull(@fecha,'')+'","llamUserReg":"'+cast(@llamUser as varchar(10))+'"'
				+',"serieActiva":"'+@serieActiva+'"}' as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH