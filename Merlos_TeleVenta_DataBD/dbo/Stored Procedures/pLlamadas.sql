CREATE PROCEDURE [dbo].[pLlamadas] @parametros varchar(max) 
AS
BEGIN TRY
	declare   @modo varchar(50) = (select JSON_VALUE(@parametros,'$.modo'))
			, @respuesta varchar(max) = ''
			, @cliente varchar(20) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
			, @incidenciaCliente varchar(20) = isnull((select JSON_VALUE(@parametros,'$.incidenciaCliente')),'')
			, @incidenciaClienteDescrip varchar(100) = isnull((select JSON_VALUE(@parametros,'$.incidenciaClienteDescrip')),'')
			, @observaciones varchar(1000) = isnull((select JSON_VALUE(@parametros,'$.observaciones')),'')
			, @fecha varchar(50)
			, @ruta varchar(10)
			, @vendedor varchar(10)
			, @pedido varchar(50) = ''
			, @elWhere varchar(1000) = ''
			, @IdTeleVenta varchar(50)	  = isnull((select JSON_VALUE(@parametros,'$.IdTeleVenta')),'')
			, @nuevaLlamada varchar(50)	  = isnull((select JSON_VALUE(@parametros,'$.nuevaLlamada')),'')
			, @nombreTV varchar(50)		  = isnull((select JSON_VALUE(@parametros,'$.nombreTV')),'')
			, @usuariosTV nvarchar(max)	  = ''
			, @FechaTeleVenta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.FechaTeleVenta')),'')
			, @horario varchar(20)		  = isnull((select JSON_VALUE(@parametros,'$.horario')),'')
			, @usuario varchar(20)		  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentReference')),'')
			, @rol varchar(50)			  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentRole')),'')

	declare @GESTION char(6) = (select GESTION from Configuracion_SQL)

	if @modo='llamarMasTardeCliente' begin
		update TeleVentaDetalle set horario=@horario where id=@IdTeleVenta and cliente=@cliente
		return -1
	END

	if @modo='llamarOtroDia' begin		
		insert into [llamadasOD] (IdTeleVentaOrigen,cliente,fechaHora)
		values (@IdTeleVenta,@cliente,@nuevaLlamada)
		return -1
	END

	if @modo='anyadirCliente' begin
		set @cliente = (select JSON_VALUE(@parametros,'$.cliente'))
		if exists (select * from TeleVentaDetalle where id=@IdTeleVenta	and cliente=@cliente) BEGIN 
			select 'clienteExiste!' as JAVASCRIPT 
		END ELSE begin
			insert into TeleVentaDetalle (id,cliente) values (@IdTeleVenta,@cliente)
		END
		return -1
	END

	if @modo='llamadasDelCliente' begin
		select isnull((
			select ll.*
			, ic.nombre as nIncidencia 
			, isnull(cast(vped.TOTALDOC as varchar),'') as importe
			from llamadas ll 
			left join inci_cli ic on ic.codigo=ll.incidencia	
			left join vPedidos vped on vped.IDPEDIDO collate Modern_Spanish_CI_AI=ll.idpedido						
			where ll.cliente=@cliente  
			order by cast(ll.fecha as datetime) desc, ll.hora desc 
			for JSON AUTO
		),'[]') as JAVASCRIPT
		return -1
	END

	if @modo='incidenciasDelCliente' begin
		declare @inciArt varchar(max) = (select isnull((
			select    i.* 
					, c.fecha
					, ia.nombre
					, va.NOMBRE as nArticulo
			from [TeleVentaIncidencias] i
			left join [TeleVentaCab] c on c.id=i.id
			left join inci_art ia on ia.codigo=i.incidencia
			left join vArticulos va on va.CODIGO collate Modern_Spanish_CI_AI=i.articulo
			where i.cliente=@cliente and articulo is not null and articulo<>''
			for JSON AUTO,INCLUDE_NULL_VALUES
		),'[]'))

		declare @inciPed varchar(max) = (select isnull((
			select    i.* 
					, c.fecha
					, ltrim(rtrim(ia.nombre)) as nombre
					, vp.LETRA + ' - ' + ltrim(rtrim(vp.numero)) as pedido
			from [TeleVentaIncidencias] i
			left join [TeleVentaCab] c on c.id=i.id
			left join inci_cli ia on ia.codigo=i.incidencia
			left join vPedidos vp on vp.IDPEDIDO collate Modern_Spanish_CI_AI=i.idpedido
			where i.cliente=@cliente and articulo is null
			for JSON AUTO,INCLUDE_NULL_VALUES
		),'[]'))
		
		select CONCAT('{"inciArt":',@inciArt,',"inciPed":',@inciPed,'}') as JAVASCRIPT
		return -1
	END

	if @modo='terminar' begin
		declare @inciSinPed varchar(max) = (select JSON_VALUE(@parametros,'$.inciSinPed'))
		declare @empresa char(2)= (select JSON_VALUE(@parametros,'$.empresa'))
		declare @serie char(2)= (select JSON_VALUE(@parametros,'$.serie'))
		set @cliente = (select JSON_VALUE(@parametros,'$.cliente'))
		set @pedido = (select JSON_VALUE(@parametros,'$.pedido'))		
		declare @idpedido varchar(50) = CONCAT((select top 1 EJERCICIO from Configuracion_SQL),@empresa,@serie,replicate('0',10-len(@pedido)),@pedido) collate Modern_Spanish_CI_AI 
		if @pedido='undefined' and (@incidenciaClienteDescrip is null or @incidenciaClienteDescrip='undefined' or @incidenciaClienteDescrip='')
		begin set @incidenciaClienteDescrip='Sin Pedido!' end
		if @pedido='undefined' begin set @pedido=@incidenciaClienteDescrip set @serie='' set @idpedido='' end

		if (@incidenciaCliente is not null and @incidenciaCliente<>'') or (@observaciones is not null and @observaciones<>'') begin
			insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,observaciones) 
			values (@IdTeleVenta,@usuario,'Cliente',@incidenciaCliente,@cliente,@idpedido,@observaciones)
		END
		
		-- Obtener importe del pedido
		EXEC('
				declare @totalped numeric(15,6), @totaldoc numeric(15,6)
				select @totalped=TOTALPED , @totaldoc=TOTALDOC 
				from ['+@GESTION+'].dbo.c_pedive 
				where concat(EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=concat('''+@empresa+''','''+@pedido+''','''+@serie+''')

				if exists (select * from [TeleVentaDetalle] where id='''+@IdTeleVenta+''' and cliente='''+@cliente+''' and completado=1) BEGIN
					insert into [TeleVentaDetalle] (id,cliente,idpedido,pedido,subtotal,importe,serie,completado)
					values ('''+@IdTeleVenta+''','''+@cliente+''','''+@idpedido+''','''+@pedido+''',@totalped,@totaldoc,'''+@serie+''',1)
				END ELSE BEGIN
					update [TeleVentaDetalle] 
					set idpedido='''+@idpedido+''', pedido='''+@pedido+''', subtotal=@totalped, importe=@totaldoc, serie='''+@serie+''', completado=1
					where id='''+@IdTeleVenta+''' and cliente='''+@cliente+'''
				END
		')

		-- si hay incidencias de artículos sin hacer pedido
		if exists (select * from openjson(@parametros,'$.inciSinPed')) BEGIN
			declare @valor varchar(1000) 
			declare cur CURSOR for select [value] from openjson(@parametros,'$.inciSinPed')
			OPEN cur FETCH NEXT FROM cur INTO @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				if not exists (
					select * from TeleVentaIncidencias 
					where id=@IdTeleVenta and gestor=@usuario
					and tipo='Articulo' and incidencia=(select JSON_VALUE(@valor,'$.incidencia'))
					and cliente=@cliente
					and articulo=(select JSON_VALUE(@valor,'$.articulo'))
				) BEGIN
					insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,articulo,observaciones) 
					values (
						 @IdTeleVenta,@usuario,'Articulo'
						,(select JSON_VALUE(@valor,'$.incidencia'))
						,@cliente
						,@idpedido
						,(select JSON_VALUE(@valor,'$.articulo'))
						,(select JSON_VALUE(@valor,'$.observacion'))
					)
				END ELSE BEGIN
					update TeleVentaIncidencias set idpedido=@idpedido, observaciones=(select JSON_VALUE(@valor,'$.observacion'))
				END
				FETCH NEXT FROM cur INTO @valor
			END CLOSE cur deallocate cur
		END

		-- actualizar tabla TeleVentaCab		
		EXEC('
				declare @clientes int = (select count(distinct cliente) from TeleVentaDetalle where id='''+@IdTeleVenta+''')
				declare @llamadas int = (select count(completado) from TeleVentaDetalle where id='''+@IdTeleVenta+''' and completado=1)
				declare @pedidos  int = (select count(idpedido) from TeleVentaDetalle 
										 where id='''+@IdTeleVenta+''' and idpedido is not null and idpedido<>'''')
				declare @totalped numeric(15,6), @totaldoc numeric(15,6)

				select @totalped=sum(a.TOTALPED), @totaldoc=sum(a.TOTALDOC)
				from ['+@GESTION+'].dbo.c_pedive a
				inner join TeleVentaDetalle b 
					on concat(ltrim(rtrim(b.pedido)),b.serie) collate SQL_Latin1_General_CP1_CI_AS=concat(ltrim(rtrim(a.NUMERO)),a.LETRA)
					and b.id='''+@IdTeleVenta+''' 
					and a.EMPRESA='''+@empresa+''' 

				update TeleVentaCab 
				set clientes=@clientes, llamadas=@llamadas, pedidos=@pedidos, subtotal=@totalped, importe=@totaldoc 
				where id='''+@IdTeleVenta+''' 
		')
	END

	if @modo='listaGlobal' begin
		if @rol='Admins' or @rol='AdminPortal' or @rol='VerTodosLosClientes'
			select isnull(
				 (select distinct t.id, t.nombre as nombreTV, t.fecha, cast(t.fecha as date) as fechaDT, t.usuario
					, clientes, llamadas, pedidos, t.importe
					from [TeleVentaCab] t
					inner join TeleVentaDetalle d on d.id=t.id
					left join vPedidos p on p.idpedido=d.idpedido collate database_default
					group by t.id, t.nombre, t.fecha, t.usuario, clientes, llamadas, pedidos, t.importe
					order by cast(t.fecha as date) desc 
				for JSON AUTO)
			,'[]') as JAVASCRIPT
		else 
			select isnull(
				 (select distinct t.id, t.nombre as nombreTV, t.fecha, cast(t.fecha as date) as fechaDT, t.usuario
					, clientes, llamadas, pedidos, t.importe
				from [TeleVentaCab] t
				inner join TeleVentaDetalle d on d.id=t.id
				left join vPedidos p on p.idpedido=d.idpedido collate database_default
				where t.usuario=@usuario 
				group by t.id, t.nombre, t.fecha, t.usuario, clientes, llamadas, pedidos, t.importe
				order by cast(t.fecha as date) desc 
				for JSON AUTO)
			,'[]') as JAVASCRIPT
		RETURN -1
	END

	-- registrar incidencia de artículos sin realizar pedidos
	if @modo='incidenciaArticulo' BEGIN
		if not exists (select * from TeleVentaIncidencias 
						where id=@IdTeleVenta and gestor=@usuario
						and tipo='Articulo' and incidencia=isnull((select JSON_VALUE(@parametros,'$.incidencia')),'')
						and cliente=@cliente
						and articulo=isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		) BEGIN
			insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,articulo,observaciones) 
			values (@IdTeleVenta,@usuario,'Articulo'
					,isnull((select JSON_VALUE(@parametros,'$.incidencia')),'')
					,@cliente
					,''
					,isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
					,isnull((select JSON_VALUE(@parametros,'$.observaciones')),'')
			)
		END
		ELSE BEGIN 
			update TeleVentaIncidencias set observaciones=isnull((select JSON_VALUE(@parametros,'$.observaciones')),'') 
			where id=@IdTeleVenta and gestor=@usuario
			and tipo='Articulo' and incidencia=isnull((select JSON_VALUE(@parametros,'$.incidencia')),'')
			and cliente=@cliente
			and articulo=isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		END
	END

	--	retornar llamadas (cargarLlamadas)
		select isnull((select td.*
		, cli.NOMBRE
		, (	select top 1 convert(char(10),FECHA,105) from [vPedidos_Cabecera] 
			where CLIENTE=CLI.CODIGO order by sqlFecha desc ) as ultimoPedido
		from TeleVentaDetalle td 
		left join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=td.cliente
		where td.id=@IdTeleVenta
		order by td.completado asc, td.horario asc for JSON AUTO, INCLUDE_NULL_VALUES),'[]') as JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pLlamadas')
	RETURN 0
END CATCH