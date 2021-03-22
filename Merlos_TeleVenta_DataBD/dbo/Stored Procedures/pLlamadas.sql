﻿CREATE PROCEDURE [dbo].[pLlamadas] @parametros varchar(max) 
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
			, @nombreTV varchar(50)		  = isnull((select JSON_VALUE(@parametros,'$.nombreTV')),'')
			, @usuariosTV nvarchar(max)	  = ''
			, @FechaTeleVenta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.FechaTeleVenta')),'')
			, @horario varchar(20)		  = isnull((select JSON_VALUE(@parametros,'$.horario')),'')
			, @usuario varchar(20)		  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentReference')),'')
			, @rol varchar(50)			  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentRole')),'')

	if @modo='llamarMasTardeCliente' begin
		update TeleVentaDetalle set horario=@horario where id=@IdTeleVenta and cliente=@cliente
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
		if @pedido='undefined' begin set @pedido='INCIDENCIA' set @idpedido='' end

		if (@incidenciaCliente is not null and @incidenciaCliente<>'') or (@observaciones is not null and @observaciones<>'') begin
			insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,observaciones) 
			values (@IdTeleVenta,@usuario,'Cliente',@incidenciaCliente,@cliente,@idpedido,@observaciones)
		END
		
		if exists (select * from [TeleVentaDetalle] where id=@IdTeleVenta and cliente=@cliente and completado=1) BEGIN
			insert into [TeleVentaDetalle] (id,cliente,idpedido,pedido,serie,completado)
			values (@IdTeleVenta,@cliente,@idpedido,@pedido,@serie,1)
		END ELSE BEGIN
			update [TeleVentaDetalle] set idpedido=@idpedido, pedido=@pedido, serie=@serie, completado=1
			where id=@IdTeleVenta and cliente=@cliente
		END

		-- si hay incidencias de artículos
		if exists (select * from openjson(@parametros,'$.inciSinPed')) BEGIN
			declare @valor varchar(1000) 
			declare cur CURSOR for select [value] from openjson(@parametros,'$.inciSinPed')
			OPEN cur FETCH NEXT FROM cur INTO @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,articulo,observaciones) 
				values (@IdTeleVenta,@usuario,'Articulo',(select JSON_VALUE(@valor,'$.incidencia')),@cliente,@idpedido
						,(select JSON_VALUE(@valor,'$.articulo'))
						,(select JSON_VALUE(@valor,'$.observacion'))
				)
				FETCH NEXT FROM cur INTO @valor
			END CLOSE cur deallocate cur
		END
	END

	if @modo='listaGlobal' begin
		if @rol='Admins' or @rol='AdminPortal' or @rol='VerTodosLosClientes'
			select isnull((select distinct id, nombre as nombreTV, fecha, cast(fecha as date) as fechaDT, usuario
							from [TeleVentaCab]	order by cast(fecha as date) desc for JSON AUTO)
			,'[]') as JAVASCRIPT
		else 
			select isnull((select distinct id, nombre as nombreTV, fecha, cast(fecha as date) as fechaDT, usuario
							from [TeleVentaCab] where usuario=@usuario order by cast(fecha as date) desc for JSON AUTO)
			,'[]') as JAVASCRIPT
		RETURN -1
	END

	--	retornar llamadas
		select isnull((select td.*
		, cli.NOMBRE
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