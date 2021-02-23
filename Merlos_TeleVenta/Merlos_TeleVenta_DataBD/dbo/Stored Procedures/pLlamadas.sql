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
			, @nombreTV varchar(50)		  = isnull((select JSON_VALUE(@parametros,'$.nombreTV')),'')
			, @usuariosTV nvarchar(max)	  = ''
			, @FechaTeleVenta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.FechaTeleVenta')),'')
			, @usuario varchar(20)		  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentReference')),'')
			, @rol varchar(50)			  = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentRole')),'')

	if @modo='anyadirCliente' begin
		set @cliente = (select JSON_VALUE(@parametros,'$.cliente'))
		if exists (select * from llamadas_user where nombreTV=@nombreTV and usuario=@usuario and fecha=@FechaTeleVenta 
					and cliente=@cliente) BEGIN select 'clienteExiste!' as JAVASCRIPT return -1 END
		declare @nombre varchar(100) = (select NOMBRE from vClientes where CODIGO=@cliente)
		set @vendedor = (select VENDEDOR from vClientes where CODIGO=@cliente)
		insert into llamadas_user (nombreTV, usuario, fecha, cliente, completado, nCompletado, idpedido, pedido, NOMBRE, VENDEDOR)
		values (@nombreTV, @usuario, @FechaTeleVenta, @cliente, 0, 'PENDIENTE', '', '', @nombre, @vendedor)
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
		declare @inciArt varchar(max) = (select isnull((select * from inci_CliArt where cliente=@cliente for JSON AUTO,INCLUDE_NULL_VALUES),'[]'))
		declare @inciPed varchar(max) = (select isnull((select * from inci_CliPed where cliente=@cliente for JSON AUTO,INCLUDE_NULL_VALUES),'[]'))
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
		if @pedido='undefined' begin set @pedido='NO!' set @idpedido='' end
		insert into llamadas ([usuario],[fecha],[cliente],[hora],[nombreTV],[llamada],[incidencia],[descripcion],[observa],[idpedido],[pedido],[completado]) 
		values (@usuario, @FechaTeleVenta, @cliente, CONVERT (time, SYSDATETIME()), @nombreTV, 1, @incidenciaCliente
		, (select nombre from inci_cli where codigo=@incidenciaCliente)
		, @observaciones, @idpedido, @pedido, 1)
		
		-- actualizar llamas_user	
		begin try
			if exists (select * from llamadas_user where usuario=@usuario and nombreTV=@nombreTV and fecha=@FechaTeleVenta and cliente=@cliente)	    
			update llamadas_user set completado=1, nCompletado='COMPLETADO', idpedido=@idpedido, pedido=@pedido where usuario=@usuario and nombreTV=@nombreTV  and fecha=@FechaTeleVenta and cliente=@cliente
			else
			INSERT INTO [dbo].[llamadas_user] (nombreTV,[usuario],[fecha],[cliente],[tipo_llama],[completado],[nCompletado],[idpedido],[pedido],[NOMBRE],[VENDEDOR])
				 VALUES (@nombreTV,@usuario, @FechaTeleVenta, @cliente, 0, 1, 'COMPLETADO', @idpedido, @pedido
					   ,(select NOMBRE from vClientes where CODIGO=@cliente)
					   ,(select VENDEDOR from vClientes where CODIGO=@cliente))
		end try begin catch end catch

		-- si hay incidencias sin haber hecho un pedido
		if exists (select * from openjson(@parametros,'$.inciSinPed')) BEGIN
			declare @valor varchar(1000) 
			declare cur CURSOR for select [value] from openjson(@parametros,'$.inciSinPed')
			OPEN cur FETCH NEXT FROM cur INTO @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into inci_CliArt (empresa,fecha,hora, nombreTV, idpedido, cliente, articulo, incidencia, descripcion, observaciones)
				values (@empresa, @FechaTeleVenta
						, cast(datepart(HOUR,getdate()) as char(2))+':'+cast(datepart(MINUTE,getdate()) as char(2))
						, @nombreTV, @idpedido, @cliente
						, (select JSON_VALUE(@valor,'$.articulo'))
						, (select JSON_VALUE(@valor,'$.incidencia'))
						, (select JSON_VALUE(@valor,'$.descrip'))
						, (select JSON_VALUE(@valor,'$.observacion'))
				)
				FETCH NEXT FROM cur INTO @valor
			END CLOSE cur deallocate cur
		END
		if @idpedido='' insert into [inci_CliPed] ([empresa],[fecha],[hora],[nombreTV],[idpedido],[cliente],[incidencia]
													,[descripcion],[observaciones])
						values (@empresa,@FechaTeleVenta
								, cast(datepart(HOUR,getdate()) as char(2))+':'+cast(datepart(MINUTE,getdate()) as char(2))
								, @nombreTV, @idpedido, @cliente, @incidenciaCliente, @incidenciaClienteDescrip, @observaciones)
	END

	if @modo='listaGlobal' begin
		if @rol='Admins' or @rol='AdminPortal' or @rol='VerTodosLosClientes'
			select isnull((select distinct ll.nombreTV, ll.fecha, cast(fecha as datetime) as fechaDT, ll.usuario
			, concat(t.Nombre,' ',t.SurName) as nUsuario
			from llamadas_user ll
			left join (select * from openJSON(@parametros,'$.usuariosTV')
						with (
							  RoleId varchar(50) '$.RoleId', Email varchar(100) '$.Email', UserName varchar(100) '$.UserName'
							, Reference varchar(50) '$.Reference', Nombre varchar(100) '$.Name', SurName varchar(100) '$.SurName'
						)) t on t.Reference=ll.usuario
			order by cast(ll.fecha as datetime) desc for JSON AUTO),'[]') as JAVASCRIPT
		else
			select isnull((select distinct nombreTV, fecha, cast(fecha as datetime) as fechaDT from llamadas_user where usuario=@usuario 
			order by cast(fecha as datetime) desc for JSON AUTO),'[]') as JAVASCRIPT
		RETURN -1
	END

	-- retornar llamadas
	if @rol='Admins' or @rol='AdminPortal' or @rol='VerTodosLosClientes'
		select isnull((select * , isnull(right(left(idpedido,8),2),'') as serie 
		from llamadas_user where nombreTV=@nombreTV and fecha=@FechaTeleVenta 
		order by completado asc, horario asc for JSON AUTO),'[]') as JAVASCRIPT
	ELSE
		select isnull((select * , isnull(right(left(idpedido,8),2),'') as serie 
		from llamadas_user where usuario=@usuario and nombreTV=@nombreTV and fecha=@FechaTeleVenta 
		order by completado asc, horario asc for JSON AUTO),'[]') as JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pLlamadas')
	RETURN 0
END CATCH