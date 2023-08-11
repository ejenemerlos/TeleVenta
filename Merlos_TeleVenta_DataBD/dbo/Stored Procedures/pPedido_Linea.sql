CREATE PROCEDURE [dbo].[pPedido_Linea] @parametros varchar(max), @respuesta varchar(max)='' output	
AS
BEGIN TRY 
	/**/  Insert into Merlos_Log (accion) values (CONCAT('[pPedido_Linea] ''',@parametros,''''))

	declare @IdTransaccion varchar(50) = isnull((select JSON_VALUE(@parametros,'$.IdTransaccion')),'')  
		,	@modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')  
		,	@articulo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')  
		,	@jsId varchar(50) = isnull((select JSON_VALUE(@parametros,'$.jsId')),'')  
		,	@IdTeleVenta varchar(50) = isnull((select JSON_VALUE(@parametros,'$.IdTeleVenta')),'')  
		,	@UserLogin varchar(50) = isnull((select JSON_VALUE(@parametros,'$.currentUserLogin')),'')  
		,	@UserID varchar(50) = isnull((select JSON_VALUE(@parametros,'$.currentUserId')),'')  
		,	@UserName varchar(50) = isnull((select JSON_VALUE(@parametros,'$.currentUserFullName')),'')  
		,	@currentReference varchar(50) = isnull((select JSON_VALUE(@parametros,'$.currentReference')),'')  

	declare @GESTION char(6)
	select @GESTION=GESTION from Configuracion_SQL

	
	if @modo='eliminarLinea' BEGIN
		delete Temp_Pedido_Detalle where IdTransaccion=@IdTransaccion and jsId=@jsId
		-- eliminar cabecera temporal si no hay lineas
		if not exists (select * from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
		delete Temp_Pedido_Cabecera where IdTransaccion=@IdTransaccion
		return -1
	END	

	
	declare @EJER char(4), @EMPRESA char(2)
	select @EMPRESA=EMPRESA, @EJER=EJERCICIO from Configuracion_SQL

	declare @MerlosLog varchar(max) = ''
		, @vret_pMerlos_LOG int 
		, @ahora varchar(10) = FORMAT(GETDATE(),'dd-MM-yyyy')
		, @hora datetime = cast(GETDATE() as datetime)
	declare @consulta varchar(max)  = ''


	-- Insertar Cabecera si no existe
	if not exists (select * from [Temp_Pedido_Cabecera] where IdTransaccion=@IdTransaccion) BEGIN
		begin try
			declare @cab_CLIENTE varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_CLIENTE')),'')  
				,	@cab_ENV_CLI varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_ENV_CLI')),'')  
				,	@cab_SERIE varchar(2) = isnull((select JSON_VALUE(@parametros,'$.cab_SERIE')),'')  
				,	@cab_CONTACTO varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_CONTACTO')),'')  
				,	@cab_INCICLI varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_INCICLI')),'')  
				,	@cab_INCICLIDescrip varchar(1000) = isnull((select JSON_VALUE(@parametros,'$.cab_INCICLIDescrip')),'')  
				,	@cab_ENTREGA varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_ENTREGA')),'')  
				,	@cab_VENDEDOR varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cab_VENDEDOR')),'')  
				,	@cab_NoCobrarPortes varchar(1) = isnull((select JSON_VALUE(@parametros,'$.cab_NoCobrarPortes')),'')  
				,	@cab_VerificarPedido varchar(1) = isnull((select JSON_VALUE(@parametros,'$.cab_VerificarPedido')),'')  
				,	@cab_OBSERVACIO varchar(1000) = isnull((select JSON_VALUE(@parametros,'$.cab_OBSERVACIO')),'') 				
			
			INSERT INTO Temp_Pedido_Cabecera (IdTransaccion, IdPedido, usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
			, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS, noCobrarPortes, verificarPedido, [UserLogin], [UserId], [UserName], [UserReference]) 
			VALUES (@IdTransaccion, 'en curso...', @UserLogin, @EMPRESA, '', @ahora , @cab_CLIENTE, @cab_ENV_CLI, @cab_ENTREGA
			, @cab_VENDEDOR, '', 0, 0, '', 1, '', @cab_SERIE, @hora, '', @cab_OBSERVACIO, @cab_VerificarPedido, @cab_VerificarPedido, @cab_NoCobrarPortes
			, @cab_VerificarPedido, @UserLogin, @UserID, @UserName, @currentReference)
		end try begin catch 
			set @consulta = CONCAT('
				INSERT INTO Temp_Pedido_Cabecera (IdTransaccion, IdPedido, usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
			, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS, noCobrarPortes, verificarPedido, [UserLogin], [UserId], [UserName], [UserReference]) 
			VALUES (''',@IdTransaccion,''', ''en curso...'', ''',@UserLogin,''', ''',@EMPRESA,''', '''', ''',@ahora,''', ''',@cab_CLIENTE,''', ''',@cab_ENV_CLI,''', ''',@cab_ENTREGA,'''
			, ''',@cab_VENDEDOR,''', '''', 0, 0, '''', 1, '''', ''',@cab_SERIE,''', ''',@ahora,''', '''', ''',@cab_OBSERVACIO,''', ''',@cab_VerificarPedido,''', ''',@cab_VerificarPedido,''', ''',@cab_NoCobrarPortes,''', ''',@cab_VerificarPedido,''', ''',@UserLogin,''', ''',@UserID,''', ''',@UserName,''', ''',@currentReference,''')')
			
			/**/  Insert into Merlos_Log (error) values (CONCAT('[pPedido_Linea] -- Insertar Cabecera si no existe: ''',CHAR(13),@consulta,''''))
		end catch
	END

	declare @linea int=0
	declare @valor varchar(max)
	declare cur CURSOR for select [value] from openjson(@parametros,'$.lineas')
	OPEN cur FETCH NEXT FROM cur INTO @valor
	WHILE (@@FETCH_STATUS=0) BEGIN
		set @jsId = JSON_VALUE(@valor,'$.jsId')
		declare @jsArticulo varchar(50) = JSON_VALUE(@valor,'$.codigo')
		declare @jsDescrip varchar(100)
		declare @jsUnidades numeric(15,6) = cast( JSON_VALUE(isnull(@valor,'0'),'$.unidades') as numeric(15,6))			
		declare @jsPesoChar varchar(10) = JSON_VALUE(@valor,'$.peso')
		declare @jsPeso numeric(15,6) = cast( JSON_VALUE(isnull(@valor,'0.000'),'$.peso') as numeric(15,6))
		declare @jsPrecio numeric(15,6) = cast( JSON_VALUE(isnull(@valor,'0.00'),'$.precio') as numeric(15,6))
		declare @jsDto numeric(15,6) = cast(JSON_VALUE(isnull(@valor,'0'),'$.dto') as numeric(15,6))
		declare @jsImporte numeric(15,6) = cast(JSON_VALUE(isnull(@valor,'0'),'$.importe') as numeric(15,6))
		declare @inciArt char(2) = isnull(JSON_VALUE(@valor,'$.incidencia'),'')
		declare @inciArtDescrip char(100) = isnull(JSON_VALUE(@valor,'$.incidenciaDescrip'),'')
		declare @obsArt varchar(100) = isnull(replace(JSON_VALUE(@valor,'$.observacion'),'_MI_RETCARRO_MI_',' '),'')
		declare @jsCajas numeric(15,6)

		declare @tbDato TABLE (dato varchar(1000))
		INSERT @tbDato EXEC('select NOMBRE from ['+@GESTION+'].DBO.ARTICULO WHERE CODIGO='''+@jsArticulo+'''')	
		SELECT @jsDescrip=dato FROM @tbDato		
		delete @tbDato

		declare @tbDat TABLE (dato numeric(15,6))
		INSERT @tbDat EXEC('
			case when  (select isnull(UNICAJA,0) from ['+@GESTION+'].dbo.articulo 
			where CODIGO='''+@jsArticulo+''')>0 
			then '+@jsUnidades+' / (select isnull(UNICAJA,0) 
			from ['+@GESTION+'].dbo.articulo where CODIGO='''+@jsArticulo+''')
			else 0.00 END
		')	
		SELECT @jsCajas=dato FROM @tbDat		
		delete @tbDat
																						
		
		-- llenar tabla temporal Temp_Pedido_Detalle
		-- Temp_Pedido_Detalle   -estado:   0-inicial   1-procesado   ------------------------------------------------------------------------------------
		set @linea=(select ISNULL(max(linea),0)+1 from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
		INSERT INTO [dbo].[Temp_Pedido_Detalle]([jsId],[IdTransaccion],[Ejercicio],[IdTeleventa],[IdPedido],[empresa],[numero],[letra],[linea],[cliente],[articulo],[descrip]
						,[cajas],[unidades],[peso],[volumen],[dto1],[dto2],[dto3],[precio],[importeiva],[incidencia],[incidencia_descrip],[observacion]
						,[UserLogin],[UserId],[UserName],[UserReference])
			VALUES
			(@jsId, @IdTransaccion, @EJER, @IdTeleVenta, 'en curso...', @EMPRESA, '', '', @linea, '', @jsArticulo, @jsDescrip, @jsCajas, @jsUnidades
			, cast(@jsPesoChar as numeric(20,4)), ''
			, @jsDto, 0.00, 0.00, @jsPrecio, @jsImporte, @inciArt, @inciArtDescrip, @obsArt, @UserLogin, @UserID, @UserName, @currentReference) 

		---------------------------------------------------------------------------------------------------------------------------------------------------

		-- linea Observaciones del artículo
		if @obsArt is not null and @obsArt<>'' BEGIN
			declare @val varchar(1000)
			declare @observaciones varchar(8000) = isnull(replace(JSON_VALUE(@valor,'$.observacion'),'_MI_RETCARRO_MI_','#'),'')
			declare elCursor cursor for select ltrim(rtrim(value)) from string_split(@observaciones,'#')
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @val
			WHILE (@@FETCH_STATUS=0) BEGIN
				if LTRIM(rtrim(@val))<>'' BEGIN
					set @linea=(select ISNULL(max(linea),0)+1 from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
					INSERT INTO [dbo].[Temp_Pedido_Detalle]([jsId],[IdTransaccion],[Ejercicio],[IdTeleventa],[IdPedido],[empresa],[numero],[letra],[linea],[cliente],[articulo],[descrip]
								,[cajas],[unidades],[peso],[volumen],[dto1],[dto2],[dto3],[precio],[importeiva],[incidencia],[incidencia_descrip],[observacion]
								,[UserLogin],[UserId],[UserName],[UserReference])
					VALUES
					(@jsId, @IdTransaccion, @EJER, @IdTeleVenta, '', @EMPRESA, '', '', @linea, '', '', @val, 0, 0, 0, ''
					, 0.00, 0.00, 0.00, 0.00, 0.00, @inciArt, @inciArtDescrip, @val, @UserLogin, @UserID, @UserName, @currentReference) 
				END
				FETCH NEXT FROM elCursor INTO @val
			END	CLOSE elCursor deallocate elCursor

			
		end
		FETCH NEXT FROM cur INTO @valor
	END CLOSE cur deallocate cur

	RETURN -1  
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH