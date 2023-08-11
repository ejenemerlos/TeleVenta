CREATE PROCEDURE [dbo].[pPedidoControl] @parametros varchar(max)
AS
BEGIN TRY	
	/**/  Insert into Merlos_Log (accion) values (CONCAT('[pPedidoControl] ''',@parametros,''''))

	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@IdTransaccion varchar(50) = isnull((select JSON_VALUE(@parametros,'$.IdTransaccion')),'')
		,	@currentUserLogin varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserLogin')),'')
		,	@currentRole varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentRole')),'')
		,	@currentRoleId varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentRoleId')),'')
		,	@currentReference varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentReference')),'')
		,	@currentSubreference varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentSubreference')),'')
		,	@currentUserId varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserId')),'')
		,	@currentUserFullName varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserFullName')),'')
		,	@respuesta varchar(max)='[]'



	if @modo='verificarPedidosError' BEGIN
		set @respuesta = (
			select * from (
				select a.IdTransaccion, a.fecha, a.cliente, a.usuario, a.estado, a.letra, b.NOMBRE as nombre
				from [Temp_Pedido_Cabecera] a
				inner join vClientes b on b.CODIGO collate Modern_Spanish_CS_AI=a.cliente
			) pedidos
			where usuario=@currentUserLogin and estado=0 
			for JSON AUTO, INCLUDE_NULL_VALUES
		)
	END



	if @modo='eliminarPedidosError' BEGIN
		delete [Temp_Pedido_Cabecera] where IdTransaccion=@IdTransaccion
		delete [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion
	END



	if @modo='reenviarPedido' BEGIN
		declare @_Cliente varchar(50), @_Env_Cli smallint, @_Letra varchar(2), @_Entrega smalldatetime, @_Vendedor varchar(50)
			,	@_NoCobrarPortes char(1), @_VerificarPedido char(1), @_Observacio varchar(1000)

		select  @_Cliente=cliente, @_Env_Cli=env_cli, @_Letra=letra, @_Entrega=entrega, @_Vendedor=Vendedor
			,	@_NoCobrarPortes=noCobrarPortes, @_VerificarPedido=verificarPedido, @_Observacio=observacio
		from [Temp_Pedido_Cabecera] where IdTransaccion=@IdTransaccion

		declare @values varchar(max) = CONCAT('<Row rowId="elRowDelObjetoPedido" ObjectName="Pedido">'
					+	'<Property Name="MODO" Value="Pedido"/>'
					+	'<Property Name="IdTransaccion" Value="',@IdTransaccion,'"/>'
					+	'<Property Name="IdTeleVenta" Value=""/>'
					+	'<Property Name="FechaTV" Value=""/>'
					+	'<Property Name="NombreTV" Value=""/>'
					+	'<Property Name="IDPEDIDO" Value=""/>'
					+	'<Property Name="EMPRESA" Value="01"/>'
					+	'<Property Name="CLIENTE" Value="',@_Cliente,'"/>'
					+	'<Property Name="ENV_CLI" Value="',@_Env_Cli,'"/>'
					+	'<Property Name="SERIE" Value="',@_Letra,'"/>'
					+	'<Property Name="CONTACTO" Value=""/>'
					+	'<Property Name="INCICLI" Value=""/>'
					+	'<Property Name="INCICLIDescrip" Value=""/>'
					+	'<Property Name="ENTREGA" Value="',format(@_Entrega,'dd-MM-yyyy'),'"/>'
					+	'<Property Name="VENDEDOR" Value="',@_Vendedor,'"/>'
					+	'<Property Name="NoCobrarPortes" Value="',@_NoCobrarPortes,'"/>'
					+	'<Property Name="VerificarPedido" Value="',@_VerificarPedido,'"/>'
					+	'<Property Name="OBSERVACIO" Value="',@_Observacio,'"/>'
					+'</Row>');	

		declare @ContextVars varchar(max) = '<Row>'
		+'<Property Name="currentReference" Value="'+@currentReference+'"/>'
		+'<Property Name="currentSubreference" Value="'+@currentSubreference+'"/>'
		+'<Property Name="currentRole" Value="'+@currentRole+'"/>'
		+'<Property Name="currentRoleId" Value="'+@currentRoleId+'"/>'
		+'<Property Name="currentUserLogin" Value="'+@currentUserLogin+'"/>'
		+'<Property Name="currentUserId" Value="'+@currentUserId+'"/>'
		+'<Property Name="currentUserFullName" Value="'+@currentUserFullName+'"/>'
		+'</Row>';	

		declare @RetValues varchar(max) = '<Property Success="False" SuccessMessage="" WarningMessage="" JSCode="" JSFile="" CloseParamWindow="False" refresh="False"/>';

		declare @vRet smallint
		EXEC @vRet=[pPedido_Nuevo] @Values, @ContextVars, @RetValues
		if @vRet<>-1 BEGIN
			declare @errorT varchar(max)='IdTransaccion: '+@IdTransaccion
			EXEC [pMerlos_LOG] @accion='ERROR reenviar Pedido!', @error=@errorT
		END
	END


	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT isnull(@respuesta,'[]') AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
