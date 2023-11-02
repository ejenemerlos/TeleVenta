CREATE PROCEDURE [dbo].[pPedido_EnviarEmail] @parametros varchar(max)	
AS
BEGIN TRY                
	/**/ insert into Merlos_Log (accion) values (concat('[pPedido_EnviarEmail] ''', @parametros, ''''))                              

	declare @empresa varchar(2) = isnull((select JSON_VALUE(@parametros,'$.empresa')),'')  
		,	@numero varchar(50) = isnull((select JSON_VALUE(@parametros,'$.numero')),'')  
		,	@letra varchar(2) = isnull((select JSON_VALUE(@parametros,'$.letra')),'')  
		
		,	@UserLogin  varchar(50) = isnull((select JSON_VALUE(@parametros,'$.usuarioJS.UserLogin')),'')  
		,	@UserID	  varchar(50) = isnull((select JSON_VALUE(@parametros,'$.usuarioJS.UserID')),'')  
		,	@UserName	  varchar(50) = isnull((select JSON_VALUE(@parametros,'$.usuarioJS.UserName')),'')  
		,	@currentReference varchar(50) = isnull((select JSON_VALUE(@parametros,'$.usuarioJS.currentReference')),'')  

	-- Parámetros de Configuración
	declare @Ejercicio char(4), @Gestion char(6), @Comun char(8), @Lotes char(8), @Campos char(8), @Anys int
	select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Comun=COMUN, @Campos=CAMPOS, @Anys=ANYS from [Configuracion_SQL]

	declare @emailAsunto varchar(100) = 'Disteco - pedido {{emailPedido}} generado'
		,	@emailClienteNombre varchar(1000)
		,	@emailEntrega varchar(10)
		,	@emailCliente varchar(1000)		
		,	@emailCuerpo varchar(max) = '
				Estimado cliente
				<br><br>
				Se ha generado el pedido {{emailPedido}} con fecha {{emailFecha}}
				<br>
				Descripción a continuación:
				<br><br>
				Pedido a {{emailClienteNombre}}
				<br>Entrega: {{emailEntrega}}
				<br><br>
				<table style="border-collapse:collapse;">
					<tr>
						<th style="border:1px solid #ccc; padding:5px; text-align:left;">CÓDIGO</th>
						<th style="border:1px solid #ccc; padding:5px; text-align:left;">ARTÍCULO</th>
						<th style="border:1px solid #ccc; padding:5px; text-align:center;">UNIDADES</th>
						<th style="border:1px solid #ccc; padding:5px; text-align:center;">PESO</th>
						<th style="border:1px solid #ccc; padding:5px; text-align:center;">PRECIO</th>
						<th style="border:1px solid #ccc; padding:5px; text-align:right;">IMPORTE</th>
					</tr>
					{{emailPedidoLineas}}
				</table>
				<br><br>
				Para cualquier consulta no dude en ponerse en contacto con nosotros.
				<br><br>
				<table>
			'
		,	@emailPedidoLineas varchar(max)=''
		
	-- Obtener email del cliente
	declare @TablaTemporal TABLE (dato varchar(1000))
	declare @consulta varchar(max) = concat('
		select ltrim(rtrim(EMAIL_F)) as dato from vClientes where CODIGO=(select cliente from [',@Gestion,'].dbo.c_pedive 
		where CONCAT(EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT('''+@empresa+''','''+ltrim(rtrim(@numero))+''','''+@letra+'''))
	')
	INSERT @TablaTemporal EXEC(@consulta)	
	SELECT @emailCliente=dato FROM @TablaTemporal		
	delete @TablaTemporal
	
	if isnull(@emailCliente,'')<>'' BEGIN TRY
		-- Obtener datos del pedido para generar el cuerpo del mensaje
		declare @tbPedidoCabecera TABLE ( emailClienteNombre varchar(100), emailEntrega varchar(10) )
		set @consulta = concat('
			select concat(''('',a.CLIENTE, '')'', b.NOMBRE) as emailClienteNombre
				,  format(a.ENTREGA,''dd-MM-yyyy'') as emailEntrega
			FROM [',@Gestion,'].dbo.c_pedive a
			inner join [',@Gestion,'].dbo.clientes b on b.CODIGO=a.CLIENTE
			where CONCAT(a.EMPRESA,ltrim(rtrim(a.NUMERO)),a.LETRA)=CONCAT(''',@empresa,''',''',ltrim(rtrim(@numero)),''',''',@letra,''')
		')
		INSERT @tbPedidoCabecera EXEC(@consulta)	
		SELECT @emailClienteNombre=emailClienteNombre, @emailEntrega=emailEntrega FROM @tbPedidoCabecera	
		delete @tbPedidoCabecera
		
		-- detalle del pedido
		declare @tbPedidoDetalle TABLE 
		(emailArticulo varchar(50), emailDefinicion varchar(1000), emailUnidades numeric(15,2), emailPeso numeric(15,2), emailPrecio numeric(15,2), emailImporte numeric(15,2))
		set @consulta = CONCAT('
			select ARTICULO, DEFINICION, UNIDADES, PESO, PRECIOIVA, IMPORTEIVA from [',@Gestion,'].dbo.d_pedive 
			where CONCAT(EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT(''',@empresa,''',''',ltrim(rtrim(@numero)),''',''',@letra,''')
		')
		INSERT @tbPedidoDetalle EXEC(@consulta)

		declare @emailArticulo varchar(50), @emailDefinicion varchar(1000), @emailUnidades numeric(15,2), @emailPeso numeric(15,2), @emailPrecio numeric(15,2), @emailImporte numeric(15,2)
		DECLARE elCursor CURSOR FOR
		select emailArticulo, emailDefinicion, emailUnidades, emailPeso, emailPrecio, emailImporte from @tbPedidoDetalle
		OPEN elCursor
		FETCH NEXT FROM elCursor INTO @emailArticulo, @emailDefinicion, @emailUnidades, @emailPeso, @emailPrecio, @emailImporte
		WHILE (@@FETCH_STATUS=0) BEGIN
				set @emailPedidoLineas = concat(@emailPedidoLineas,'
					<tr>
						<td style="border:1px solid #ccc; padding:5px; text-align:left;">',@emailArticulo,'</td>
						<td style="border:1px solid #ccc; padding:5px; text-align:left;">',@emailDefinicion,'</td>
						<td style="border:1px solid #ccc; padding:5px; text-align:right;">',@emailUnidades,'</td>
						<td style="border:1px solid #ccc; padding:5px; text-align:right;">',@emailPeso,'</td>
						<td style="border:1px solid #ccc; padding:5px; text-align:right;">',@emailPrecio,'</td>
						<td style="border:1px solid #ccc; padding:5px; text-align:right;">',@emailImporte,'</td>
					</tr>
				')
			FETCH NEXT FROM elCursor INTO @emailArticulo, @emailDefinicion, @emailUnidades, @emailPeso, @emailPrecio, @emailImporte
		END	CLOSE elCursor deallocate elCursor
		delete @tbPedidoDetalle

		set @emailAsunto = replace(@emailAsunto, '{{emailPedido}}', concat(@letra,'-',ltrim(rtrim(@numero))))
		set @emailCuerpo = replace(@emailCuerpo, '{{emailPedido}}', concat(@letra,'-',ltrim(rtrim(@numero))))
		set @emailCuerpo = replace(@emailCuerpo, '{{emailFecha}}', FORMAT(getdate(),'dd-MM-yyyy'))
		set @emailCuerpo = replace(@emailCuerpo, '{{emailClienteNombre}}', @emailClienteNombre)
		set @emailCuerpo = replace(@emailCuerpo, '{{emailEntrega}}', @emailEntrega)
		set @emailCuerpo = replace(@emailCuerpo, '{{emailPedidoLineas}}', @emailPedidoLineas)

		-- Enviar correo
		declare @cuentaEmailSQLServer varchar(100) = isnull((select top 1 Nombre from [Configuracion_Email] where EnvioPorSQLServer=1),'')
		if @cuentaEmailSQLServer<>'' BEGIN
			--declare @destino varchar(1000) = concat(@emailCliente,';e.jene@merlos.net')
			declare @destino varchar(1000) = concat('e.jene@merlos.net',';e.jene@merlos.net')
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @cuentaEmailSQLServer,
			@recipients = @destino,
			@body = @emailCuerpo,
			@body_format = 'HTML',
			@subject = @emailAsunto
		END ELSE BEGIN insert into Merlos_Log (error) values (concat(OBJECT_NAME(@@PROCID),' - envío email - SIN CUENTA DE EMAIL SQLServer!')) END
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(MAX)
		SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","accion":"',@parametros,'","mensaje":"',replace(ERROR_MESSAGE(),'"','-'),'"}')
		DECLARE @ErrorSeverity INT = 50001;  -- rango válido de 50000 a 2147483647
		THROW @ErrorSeverity, @ErrorMessage, 1;
		insert into Merlos_Log (accion, error, Usuario) values (concat(OBJECT_NAME(@@PROCID),' ',@parametros,''''), @ErrorMessage, @UserLogin)
	END CATCH

	RETURN -1  
END TRY
BEGIN CATCH
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","accion":"',@parametros,'","mensaje":"',replace(ERROR_MESSAGE(),'"','-'),'"}')
	set @ErrorSeverity = 50001;  -- rango válido de 50000 a 2147483647
	THROW @ErrorSeverity, @ErrorMessage, 1;
	insert into Merlos_Log (accion, error, Usuario) values (concat(OBJECT_NAME(@@PROCID),' ',@parametros,''''), @ErrorMessage, @UserLogin)
	RETURN -1
END CATCH


