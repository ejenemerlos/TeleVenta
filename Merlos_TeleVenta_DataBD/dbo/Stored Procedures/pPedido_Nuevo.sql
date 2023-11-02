CREATE PROCEDURE [dbo].[pPedido_Nuevo] @Values XML OUTPUT, @ContextVars as XML, @RetValues as XML OUTPUT
AS
	insert into Merlos_Log (accion) values (CONCAT('[pPedido_Nuevo] ''',cast(@ContextVars as varchar(max)),''' ', '''',cast(@RetValues as varchar(max)),''''))


-- =============================================
--	Author:			Elías Jené
--	Create date:	16/05/2019
--	Description:	Crear Pedido
-- =============================================
	DECLARE	  @MODO		  varchar(50)	
			, @IDPEDIDO	  varchar(50)		
			, @IdTransaccion varchar(50)		
			, @CLIENTE	  varchar(20)	
			, @ENV_CLI	  int
			, @SERIE	  char(2) = ''					
			, @ENTREGA	  varchar(10)
			, @CONTACTO	  varchar(50) = '0'
			, @INCICLI	  varchar(50) = ''
			, @INCICLIDescrip varchar(1000) = ''
			, @VENDEDOR  varchar(20) = '01'
			, @FAMILIA    char(4) = ''
			, @OBSERVACIO varchar(8000)
			, @NoCobrarPortes char(1)
			, @VerificarPedido char(1)
			, @UserLogin  varchar(50)
			, @UserID	  varchar(50)=''
			, @UserName	  varchar(50)=''
			, @currentReference varchar(50)=''
			
			, @EJER VARCHAR(4)
			, @EMPRESA CHAR(2) = '01'
			, @IdTeleVenta varchar(50)
			, @NombreTV varchar(100)
			, @FechaTV varchar(10)
			, @PEDIDO CHAR(12)
			, @FECHA varchar(10) = convert(varchar(10), getdate(), 103)
			, @FECHAmas1 varchar(10) = convert(varchar(10), dateadd(day,1,getdate()), 103)			
			, @REFERCLI CHAR(25)			
			, @ESTADO VARCHAR(9)
			, @TOTALDOC INT
			, @TOTALPED NUMERIC(18, 2)
			, @PRONTO NUMERIC(20, 2)			
			, @T_IMPORTEIVA NUMERIC(18, 2)
			, @TOTAL NUMERIC(18,2)
			, @nVendedor varchar(100)
			, @almacen varchar(10)
			, @sentenciaSQL varchar(max)		
			, @Agencia char(10)	

			, @GESTION char(6) = (select GESTION from Configuracion_SQL)
			, @COMUN char(8) = (select COMUN from Configuracion_SQL)
			, @CAMPOS char(8) = (select CAMPOS from Configuracion_SQL)

			, @QuitarEnProduccion smallint=0

	declare @vret_pMerlos_LOG smallint = 0
	
	/**/ -- Log Merlos
	/**/ declare @MerlosLog varchar(max)=''
	/**/ declare @IdControlLog varchar(50) = replace(replace(replace(replace(replace(convert(varchar,getdate(),121),' ',''),'/',''),':',''),'.',''),'-','') 
	/**/ set @MerlosLog = @IdControlLog+'========================================================================'
	/**/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@MerlosLog END
	/**/ set @vret_pMerlos_LOG=0 set @MerlosLog = CONCAT(@IdControlLog,' -001- ','[pPedido_Nuevo] - ',@IdControlLog)
	/**/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@MerlosLog END
	/**/ set @vret_pMerlos_LOG=0 set @MerlosLog = CONCAT(@IdControlLog,' -002- ','@Values: ',isnull(cast(@Values as varchar(max)),''))
	/**/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@MerlosLog END
	/**/ set @vret_pMerlos_LOG=0 set @MerlosLog = CONCAT(@IdControlLog,' -003- ','@ContextVars: ',isnull(cast(@ContextVars as varchar(max)),''))
	/**/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@MerlosLog END
	
	/**/ insert into Merlos_Log (accion) values (concat('[pPedido_Nuevo] @Values: ', cast(@Values as varchar(max))))
	/**/ insert into Merlos_Log (accion) values (concat('[pPedido_Nuevo] @ContextVars: ', cast(@ContextVars as varchar(max))))


	-- Obtener datos del XML ----------------------------------------------------------------------------------------------
	SET @MODO		= @Values.value('(/Row/Property[@Name=''MODO'']/@Value)[1]'		, 'varchar(50)')
	SET @EMPRESA	= @Values.value('(/Row/Property[@Name=''EMPRESA'']/@Value)[1]'	, 'varchar(2)')
	SET @IdTransaccion = isnull(@Values.value('(/Row/Property[@Name=''IdTransaccion'']/@Value)[1]', 'varchar(50)'),'')
	SET @IdTeleVenta= @Values.value('(/Row/Property[@Name=''IdTeleVenta'']/@Value)[1]', 'varchar(50)')
	SET @NombreTV	= @Values.value('(/Row/Property[@Name=''NombreTV'']/@Value)[1]'	, 'varchar(100)')
	SET @FechaTV	= @Values.value('(/Row/Property[@Name=''FechaTV'']/@Value)[1]'	, 'varchar(10)')
	SET @IDPEDIDO	= @Values.value('(/Row/Property[@Name=''IDPEDIDO'']/@Value)[1]'	, 'varchar(50)')
	SET @CLIENTE	= @Values.value('(/Row/Property[@Name=''CLIENTE'']/@Value)[1]'	, 'varchar(50)')
	SET @ENV_CLI	= @Values.value('(/Row/Property[@Name=''ENV_CLI'']/@Value)[1]'	, 'int')
	SET @SERIE		= @Values.value('(/Row/Property[@Name=''SERIE'']/@Value)[1]'	, 'varchar(50)')
	SET @ENTREGA	= @Values.value('(/Row/Property[@Name=''ENTREGA'']/@Value)[1]'	, 'varchar(50)')
	SET @CONTACTO	= @Values.value('(/Row/Property[@Name=''CONTACTO'']/@Value)[1]'	, 'varchar(50)')
	SET @INCICLI	= @Values.value('(/Row/Property[@Name=''INCICLI'']/@Value)[1]'	, 'varchar(50)')
	SET @VENDEDOR	= @Values.value('(/Row/Property[@Name=''VENDEDOR'']/@Value)[1]'	, 'varchar(20)')
	SET @FAMILIA	= @Values.value('(/Row/Property[@Name=''FAMILIA'']/@Value)[1]'	, 'varchar(50)')
	SET @OBSERVACIO	= @Values.value('(/Row/Property[@Name=''OBSERVACIO'']/@Value)[1]', 'varchar(8000)')
	SET @NoCobrarPortes	= @Values.value('(/Row/Property[@Name=''NoCobrarPortes'']/@Value)[1]'	, 'char(1)')
	SET @VerificarPedido = @Values.value('(/Row/Property[@Name=''VerificarPedido'']/@Value)[1]'	, 'char(1)')

	SET @UserLogin			= @ContextVars.value('(/Row/Property[@Name=''currentUserLogin'']/@Value)[1]'	, 'varchar(50)')
	SET @UserID				= @ContextVars.value('(/Row/Property[@Name=''currentUserId'']/@Value)[1]'		, 'varchar(50)')
	SET @UserName			= @ContextVars.value('(/Row/Property[@Name=''currentUserFullName'']/@Value)[1]'	, 'varchar(50)')
	SET @currentReference	= @ContextVars.value('(/Row/Property[@Name=''currentReference'']/@Value)[1]'	, 'varchar(50)')

	if @IdTransaccion='' set @IdTransaccion = replace(replace(replace(replace(replace(convert(varchar,getdate(),121),' ',''),'/',''),':',''),'.',''),'-','') 
	
	/**/ declare @la varchar(max) = ''

	if @ENV_CLI is null or @ENV_CLI='' 
	set @ENV_CLI = isnull((select ISNULL(LINEA,0) from vContactos where CLIENTE=@CLIENTE and LINEA=0),0)	

BEGIN TRANSACTION pedidoNuevo
BEGIN TRY
	-- poner EN USO
	declare @Clave varchar(100) = CONCAT('PEDIDO','-',@currentReference)
	insert into EnUso (Clave, Tipo, Objeto, Estado) values (@Clave,'Stored Procedure','pPedido_Nuevo',1)

	--Creamos las variables de trabajo
	DECLARE @nombreUsuario CHAR(25), @codigo char(10), @estado_aux BIT, @aux INT,
			 @letra CHAR(2), @moneda VARCHAR(3), @fpag VARCHAR(2), @ruta CHAR(2), @pais char(3)
			 set @letra=@SERIE

	--Inicializamos las variables donde haremos las inserciones
	SET @EJER = (select EJERCICIO from Configuracion_SQL)	

	IF @ENTREGA IS NULL or @ENTREGA='' set @ENTREGA=@FECHAmas1			

	declare @tbCliente TABLE (fpag varchar(2), PRONTO numeric(20,2), ruta char(2), OBSERVACIO varchar(8000), pais char(3))
	INSERT @tbCliente EXEC('SELECT fpag, PRONTO, ruta,  OBSERVACIO, pais FROM ['+@GESTION+'].DBO.clientes WHERE CODIGO='''+@CLIENTE+'''')	
	SELECT @fpag=fpag
		,  @PRONTO=PRONTO
		,  @ruta=ruta
		,  @OBSERVACIO=case when @OBSERVACIO IS NULL or @OBSERVACIO='' then OBSERVACIO else @OBSERVACIO end
		,  @pais=pais 
	FROM @tbCliente		
	delete @tbCliente

	declare @tbVendedor TABLE (nombre varchar(100))
	INSERT @tbVendedor EXEC('SELECT nombre FROM ['+@GESTION+'].DBO.vendedor WHERE CODIGO='''+@Vendedor+'''')	
	SELECT @nVENDEDOR=nombre FROM @tbVendedor		
	delete @tbVendedor
		
	SET @nombreUsuario = 'FLEXYGO##V_'+@UserLogin	

	-- 07-10-2022 - Elías Jené - dinamización
	declare @tbAlmacen TABLE (almacen varchar(10))
	INSERT @tbAlmacen EXEC('SELECT almacen FROM ['+@GESTION+'].DBO.empresa WHERE CODIGO='''+@EMPRESA+'''')	
	SELECT @nVENDEDOR=almacen FROM @tbAlmacen		
	delete @tbAlmacen

	if isnull(@almacen,'')='' set @almacen='00'

	-- Obtener número según los contadores de Eurowin
	declare @reintentos int = 0;
	set @codigo=''
	declare @vret_pDameNumPedido smallint
	while @codigo='' and @reintentos<10 BEGIN 
		set @reintentos = @reintentos + 1
		EXEC @vret_pDameNumPedido=[pDameNumPedido] @letra, @codigo output 
		if @vret_pDameNumPedido<>-1 begin 
			if @@TRANCOUNT>0 ROLLBACK TRANSACTION pedidoNuevo
			select 'Error-pPedidoNuevo-[pDameNumPedido]' as JAVASCRIPT
			return -1
		end	
	END	

	if @codigo='' BEGIN
		if @@TRANCOUNT>0 ROLLBACK TRANSACTION pedidoNuevo
		EXEC [pPedido_Nuevo] @Values, @ContextVars, @RetValues 
		select CONCAT('Error-pPedidoNuevo-[pDameNumPedido]-CodigoVacio-Reintentos:',@reintentos) as JAVASCRIPT
		return -1
	END
	
	/**/ -- Log Merlos
	/**/ set @la = CONCAT(@IdControlLog,' -004- ','Código obtenido: ',@codigo)		
	/**/ set @vret_pMerlos_LOG=0 /****/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@la END
	/**/ set @la = CONCAT(@IdControlLog,' -005- ','Reintentos: ',@reintentos)
	/**/ set @vret_pMerlos_LOG=0 /****/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@la END
	-- select * from Merlos_Log order by id desc
	
	IF @REFERCLI IS NULL BEGIN set  @REFERCLI = '' END
	IF @PRONTO   IS NULL BEGIN set  @PRONTO   = 0  END

	declare @divisa char(3)
	declare @tbPais TABLE (divisa char(3))
	INSERT @tbPais EXEC('SELECT isnull(MONEDA,'''') FROM ['+@COMUN+'].DBO.paises WHERE CODIGO='''+@pais+'''')	
	SELECT @divisa=isnull(divisa,'0') FROM @tbPais		
	delete @tbPais

	SET @codigo = SPACE(10-len(LTRIM(RTRIM(@CODIGO))))+LTRIM(RTRIM(@CODIGO))
	
	BEGIN try	
		declare @cSQL varchar(max) = CONCAT('
		INSERT INTO [',@GESTION,'].[DBO].c_pedive (usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
											, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS ) 
		VALUES ( ''',@UserLogin,''', ''',@EMPRESA,''', ''',@codigo,''', cast(''',@FECHA,''' as smalldatetime), ''',@CLIENTE,''', ',@env_cli,', ''',@ENTREGA,'''
				, ''',@Vendedor,''', ''',@ruta,''', ',@PRONTO,', 0, ''',@divisa,''', 1, ''',@fpag,''', ''',@letra,''', ''',getdate(),''', ''',@almacen,''', '''
				,replace(@OBSERVACIO,'''',''''''),''', ''',@VerificarPedido,''', ''',@VerificarPedido,''')
		')
		EXEC(@cSQL)	  
	end try
	BEGIN CATCH 
		if @@TRANCOUNT>0 ROLLBACK TRANSACTION pedidoNuevo
		/**/ set @la = CONCAT(@IdControlLog,' - Fallo de INSERT en [c_pedive] - se vuelve a llamar a [pPedido_Nuevo]')		
		/**/ set @vret_pMerlos_LOG=0 /****/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@la END
		select 'Error-pPedidoNuevo-insert en c_pedive:'+ERROR_MESSAGE() as JAVASCRIPT
		return -1
	END CATCH

	SET @IDPEDIDO = CONCAT(@EJER,@EMPRESA,@letra,@codigo)						
	declare @IDP varchar(50) 
	set @IDP = replace(@IDPEDIDO,space(1),'0')
	set @IDPEDIDO = LEFT(@IDP,18)

	-- llenar tabla temporal Temp_Pedido_Cabecera
	-- Temp_Pedido_Cabecera   -estado:   0-inicial   1-procesado   ------------------------------------------------------------------------------------------------------
	if not exists (select * from [Temp_Pedido_Cabecera] where IdTransaccion=@IdTransaccion)
		INSERT INTO Temp_Pedido_Cabecera (IdTransaccion, IdPedido, usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
				, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS, noCobrarPortes, verificarPedido, [UserLogin], [UserId], [UserName], [UserReference]) 
		VALUES (@IdTransaccion, @IDPEDIDO, @UserLogin, @EMPRESA, @codigo, cast(@FECHA as smalldatetime), @CLIENTE, @env_cli, @ENTREGA, @Vendedor, @ruta, @PRONTO, 0, @divisa, 1
				, @fpag, @letra, getdate(), @almacen, @OBSERVACIO, @VerificarPedido, @VerificarPedido, @NoCobrarPortes, @VerificarPedido, @UserLogin, @UserID, @UserName, @currentReference)
	ELSE update Temp_Pedido_Cabecera
		set IdPedido=@IDPEDIDO, usuario=@UserLogin, empresa=@EMPRESA, numero=@codigo, fecha=cast(@FECHA as smalldatetime), cliente=@CLIENTE, env_cli=@env_cli
		, entrega=@ENTREGA, vendedor=@Vendedor, ruta=@ruta, pronto=@PRONTO, iva_inc=0, divisa=@divisa, cambio=1, fpag=@fpag, letra=@letra, hora=getdate(), almacen=@almacen
		, observacio=@OBSERVACIO, IMPRESO=@VerificarPedido, COMMS=@VerificarPedido, noCobrarPortes=@NoCobrarPortes, verificarPedido=@VerificarPedido
		, [UserLogin]=@UserLogin, [UserId]=@UserID, [UserName]=@UserName, [UserReference]=@currentReference
	where IdTransaccion=@IdTransaccion

	insert into [dbo].[Pedidos_Familias](EJERCICIO, EMPRESA, NUMERO, LETRA, FAMILIA)
	values (@EJER, @EMPRESA, @codigo, @letra, @FAMILIA)

	--	Guardamos el contacto en Pedidos_contactos
		begin try
			if ISNUMERIC(@CONTACTO)=1 BEGIN
				insert into Pedidos_Contactos (IDPEDIDO, Cliente, Contacto)
				values (@IDPEDIDO, @CLIENTE, @CONTACTO)
			END
		end try begin catch end catch


	-- actualizar datos en tabla [Temp_Pedido_Detalle] la cual se ha ido llenando desde el portal línea a línea mediante [pPedido_Linea]
	update Temp_Pedido_Detalle set IdPedido=@IDPEDIDO, empresa=@EMPRESA, numero=@codigo, letra=@letra, cliente=@CLIENTE where IdTransaccion=@IdTransaccion

	declare @vRet1 int
	declare @p varchar(max) = '{"IdTransaccion":"'+@IdTransaccion+'","UserLogin":"'+@UserLogin+'","UserID":"'+@UserID+'","UserName":"'+@UserName+'","currentReference":"'+@currentReference+'"}'
	EXEC @vRet1=[pPedido_Nuevo_Lineas] @parametros=@p
	if @vRet1<>-1 BEGIN 
		set @la = '-Error [pPedido_Nuevo_Lineas] - @p: '+@p+' --- '+ERROR_MESSAGE() exec [pMerlos_LOG] @accion=@la 
		set @vret_pMerlos_LOG=0 /****/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@la END
	END

	-- Actualizar importes
	declare @vRet_pCalcularImp smallint
	exec @vRet_pCalcularImp = [pCalcularImp] @EMPRESA, @letra, @codigo, @CLIENTE, 2
	if @vRet_pCalcularImp<>-1 BEGIN
		set @la = 'Error-010-[pCalcularImp] ! '
		set @vret_pMerlos_LOG=0 /****/ while @vret_pMerlos_LOG<>-1 BEGIN exec @vret_pMerlos_LOG = [pMerlos_LOG] @accion=@la END
	END

	declare @_noCobrarPortes char(1), @_verificarPedido char(1)
	select @_noCobrarPortes=noCobrarPortes, @_verificarPedido=verificarPedido from Temp_Pedido_Cabecera where IdTransaccion=@IdTransaccion

	-- 07-10-2022 - Elías Jené - dinamización
	set @cSQL = CONCAT('
		insert into [',@CAMPOS,'].dbo.c_pediveew (EJERCICIO,EMPRESA,NUMERO,LETRA,EWNOPORT, EWVERIFI)
		values (''',@EJER,''',''',@EMPRESA,''',''',@codigo,''',''',@letra,''',''',@_noCobrarPortes,''', ''',@_verificarPedido,''')
	')
	EXEC(@cSQL)
	declare @respuesta varchar(max) = CONCAT(
		'{"IdPedido":"',isnull(@IDPEDIDO,'NULL'),'","Ejercicio":"',isnull(@EJER,'NULL'),'","Empresa":"',isnull(@EMPRESA,'NULL'),'","Letra":"',isnull(@letra,'NULL')
		,'","Codigo":"',ltrim(rtrim(isnull(@codigo,'NULL'))),'"}'
	)
	-- eliminar EN_USO
	delete EnUso where Clave=@Clave and Objeto='pPedido_Nuevo' and Estado=1	

	-- enviar email del pedido
	begin try
		declare @pmail varchar(1000) = concat('{"empresa":"',@EMPRESA,'","numero":"',@codigo,'","letra":"',@letra,'","usuarioJS":{"UserLogin":"',@UserLogin,'","UserID":"',@UserID,'","UserName":"',@UserName,'","currentReference":"',@currentReference,'"}}') 
		EXEC [pPedido_EnviarEmail] @pmail 
	END TRY
	begin catch insert into Merlos_Log (error, Usuario) values ( concat('Error SP: ', OBJECT_NAME(@@PROCID),' - [pPedido_EnviarEmail] ::: ERROR_MESSAGE(): ',ERROR_MESSAGE()), @UserLogin) end catch

	COMMIT TRANSACTION pedidoNuevo
END TRY
BEGIN CATCH
	if @@TRANCOUNT>0 ROLLBACK TRANSACTION pedidoNuevo
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= concat(
		 'Error pPedidoNuevo !!! - @IdControlLog: '
		, char(13), ERROR_MESSAGE()
		, char(13), ERROR_NUMBER()
		, char(13), ERROR_PROCEDURE()
		, char(13), @@PROCID
		, char(13), ERROR_LINE()
	)
	RAISERROR(@CatchError,12,1)
	
	insert into Merlos_Log (error, Usuario) values ( concat('Error SP: ', OBJECT_NAME(@@PROCID),' ::: ERROR_MESSAGE(): ',ERROR_MESSAGE()), @UserLogin)

	BEGIN TRY
		-- Enviar correo
		DECLARE @EMAILMENSAJE NVARCHAR(max), @EMAILASUNTO NVARCHAR(50)	
		SET @EMAILASUNTO = 'Disteco - TELEVENTA - Error [pPedido_Nuevo] !!!'
		SET @EMAILMENSAJE = concat('
			Disteco - TELEVENTA - Error [pPedido_Nuevo] !!!		
			',CAST(FORMAT(getdate(),'dd-MM-yyyy HH:mm') as varchar(50)),'

			-----------------------------------------------------------------
			@Values XML OUTPUT:
			',cast(@Values as nvarchar(max)),'
		
			-----------------------------------------------------------------
			@ContextVars as XML:
			',cast(@ContextVars as nvarchar(max)),'
		
			-----------------------------------------------------------------
			@RetValues as XML OUTPUT:
			',cast(@RetValues as nvarchar(max)),'

			-----------------------------------------------------------------
			@ERROR_MESSAGE():
			',ERROR_MESSAGE(),'
		')

		EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Disteco',
		@recipients = 'e.jene@merlos.net; a.rodriguez@merlos.net',
		@body = @EMAILMENSAJE,
		@subject = @EMAILASUNTO
	END TRY BEGIN CATCH END CATCH
	set @respuesta = @CatchError
END CATCH

-- Control de errores desde el portal
select @respuesta as JAVASCRIPT
RETURN -1  
