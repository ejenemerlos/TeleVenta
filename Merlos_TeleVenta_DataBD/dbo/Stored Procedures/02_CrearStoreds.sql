﻿

-- ===============================
--	Author:			Elías Jené 
--	Create date:	29/07/2019
--	Description:	Crear Storeds
-- ===============================
CREATE  PROCEDURE [dbo].[02_CrearStoreds]
AS
SET NOCOUNT ON
BEGIN TRY	
-- ============================
--	Variables de configuración
-- ============================
	declare @GESTION	varchar(20)	 set @GESTION = '['+(select top 1 GESTION from Configuracion_SQL)+']'
	declare @GESTIONAnt varchar(20)	 set @GESTIONAnt = '['+ cast(cast((select top 1 EJERCICIO from Configuracion_SQL) as int)-1 as varchar)+']'
	declare @CAMPOS		varchar(10)  set @CAMPOS = '['+(select top 1 isnull(CAMPOS,'xxxxxx') from Configuracion_SQL)+']'
	declare @COMUN		varchar(10)  set @COMUN = '['+(select top 1 COMUN from Configuracion_SQL)+']'
	declare @LETRA		char(4)		 set @LETRA = (select top 1 LETRA from Configuracion_SQL)
	declare @ANY		char(4)		 set @ANY = (select top 1 EJERCICIO from Configuracion_SQL)
	declare @ANYLETRA	char(6)		 set @ANYLETRA = (select top 1 EJERCICIO +''+ LETRA from Configuracion_SQL)
	declare @EMPRESA	char(2)		 set @EMPRESA   = (select top 1 EMPRESA from Configuracion_SQL)
	declare @Sentencia	varchar(MAX)
	declare @Sentencia1	varchar(MAX)
	declare @Sentencia2	varchar(MAX)
	declare @Sentencia3	varchar(MAX)
	declare @AlterCreate varchar(50) = 'CREATE '
-- ====================================================================================================================================

--	Procedimiento pPedidoEstado
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedidoEstado' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--		Author:			Elías Jené
--		Create date:	22/08/2019
--		Description:	Obtener Estado del Pedido
-- ===========================================================

-- exec [pPedidoEstado] ''estado'' , ''201901      190447''
'+@AlterCreate+' PROCEDURE [dbo].[pPedidoEstado] @modo varchar(50),  @IDPEDIDO	varchar(8000)
AS
BEGIN TRY	
	DECLARE   @estado varchar(50)=''LIBRE''
			, @respuesta varchar(max)=''''

	IF @modo=''estado'' BEGIN
		if exists (
					select uso.CLAVE 
					from ' + @COMUN + '.dbo.en_uso uso
					inner join vPedidos cpv on cpv.IDPEDIDO=@IDPEDIDO
					where uso.TIPO=''PEDIVEN'' and uso.CLAVE=@IDPEDIDO and cpv.ESTADO=''PENDIENTE''
		) set @estado=''EN_USO''
	END

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT ''{"pedidoEstado":[{"estado":"''+@estado+''"}]}'' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pPedidoEstado'

--	Procedimiento pPedido_Linea
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedido_Linea' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- =============================================
-- Author:		Elías Jené
-- Create date: 13/05/2019
-- Description:	Eliminar Linea del pedido
-- =============================================
'+@AlterCreate+' PROCEDURE [dbo].[pPedido_Linea] @parametros varchar(max), @respuesta varchar(max)='''' output	
AS
BEGIN TRY 
	/**/  Insert into Merlos_Log (accion) values (CONCAT(''[pPedido_Linea] '''''',@parametros,''''''''))

	declare @IdTransaccion varchar(50) = isnull((select JSON_VALUE(@parametros,''$.IdTransaccion'')),'''')  
		,	@modo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.modo'')),'''')  
		,	@articulo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.articulo'')),'''')  
		,	@jsId varchar(50) = isnull((select JSON_VALUE(@parametros,''$.jsId'')),'''')  
		,	@IdTeleVenta varchar(50) = isnull((select JSON_VALUE(@parametros,''$.IdTeleVenta'')),'''')  
		,	@UserLogin varchar(50) = isnull((select JSON_VALUE(@parametros,''$.currentUserLogin'')),'''')  
		,	@UserID varchar(50) = isnull((select JSON_VALUE(@parametros,''$.currentUserId'')),'''')  
		,	@UserName varchar(50) = isnull((select JSON_VALUE(@parametros,''$.currentUserFullName'')),'''')  
		,	@currentReference varchar(50) = isnull((select JSON_VALUE(@parametros,''$.currentReference'')),'''')  

	
	if @modo=''eliminarLinea'' BEGIN
		delete Temp_Pedido_Detalle where IdTransaccion=@IdTransaccion and jsId=@jsId
		-- eliminar cabecera temporal si no hay lineas
		if not exists (select * from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
		delete Temp_Pedido_Cabecera where IdTransaccion=@IdTransaccion
		return -1
	END	

	
	declare @EJER char(4), @EMPRESA char(2)
	select @EJER=[any] from ' + @COMUN + '.[DBO].ejercici where predet=1
	select @EMPRESA=EMPRESA from Configuracion_SQL

	declare @MerlosLog varchar(max) = ''''
		, @vret_pMerlos_LOG int 
		, @ahora varchar(10) = FORMAT(GETDATE(),''dd-MM-yyyy'')
		, @hora datetime = cast(GETDATE() as datetime)
	declare @consulta varchar(max)  = ''''


	-- Insertar Cabecera si no existe
	if not exists (select * from [Temp_Pedido_Cabecera] where IdTransaccion=@IdTransaccion) BEGIN
		begin try
			declare @cab_CLIENTE varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_CLIENTE'')),'''')  
				,	@cab_ENV_CLI varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_ENV_CLI'')),'''')  
				,	@cab_SERIE varchar(2) = isnull((select JSON_VALUE(@parametros,''$.cab_SERIE'')),'''')  
				,	@cab_CONTACTO varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_CONTACTO'')),'''')  
				,	@cab_INCICLI varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_INCICLI'')),'''')  
				,	@cab_INCICLIDescrip varchar(1000) = isnull((select JSON_VALUE(@parametros,''$.cab_INCICLIDescrip'')),'''')  
				,	@cab_ENTREGA varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_ENTREGA'')),'''')  
				,	@cab_VENDEDOR varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cab_VENDEDOR'')),'''')  
				,	@cab_NoCobrarPortes varchar(1) = isnull((select JSON_VALUE(@parametros,''$.cab_NoCobrarPortes'')),'''')  
				,	@cab_VerificarPedido varchar(1) = isnull((select JSON_VALUE(@parametros,''$.cab_VerificarPedido'')),'''')  
				,	@cab_OBSERVACIO varchar(1000) = isnull((select JSON_VALUE(@parametros,''$.cab_OBSERVACIO'')),'''') 				
			
			INSERT INTO Temp_Pedido_Cabecera (IdTransaccion, IdPedido, usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
			, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS, noCobrarPortes, verificarPedido, [UserLogin], [UserId], [UserName], [UserReference]) 
			VALUES (@IdTransaccion, ''en curso...'', @UserLogin, @EMPRESA, '''', @ahora , @cab_CLIENTE, @cab_ENV_CLI, @cab_ENTREGA
			, @cab_VENDEDOR, '''', 0, 0, '''', 1, '''', @cab_SERIE, @hora, '''', @cab_OBSERVACIO, @cab_VerificarPedido, @cab_VerificarPedido, @cab_NoCobrarPortes
			, @cab_VerificarPedido, @UserLogin, @UserID, @UserName, @currentReference)
		end try begin catch 
			set @consulta = CONCAT(''
				INSERT INTO Temp_Pedido_Cabecera (IdTransaccion, IdPedido, usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
			, cambio, fpag, letra, hora, almacen,observacio, IMPRESO, COMMS, noCobrarPortes, verificarPedido, [UserLogin], [UserId], [UserName], [UserReference]) 
			VALUES ('''''',@IdTransaccion,'''''', ''''en curso...'''', '''''',@UserLogin,'''''', '''''',@EMPRESA,'''''', '''''''', '''''',@ahora,'''''', '''''',@cab_CLIENTE,'''''', '''''',@cab_ENV_CLI,'''''', '''''',@cab_ENTREGA,''''''
			, '''''',@cab_VENDEDOR,'''''', '''''''', 0, 0, '''''''', 1, '''''''', '''''',@cab_SERIE,'''''', '''''',@ahora,'''''', '''''''', '''''',@cab_OBSERVACIO,'''''', '''''',@cab_VerificarPedido,'''''', '''''',@cab_VerificarPedido,'''''', '''''',@cab_NoCobrarPortes,'''''', '''''',@cab_VerificarPedido,'''''', '''''',@UserLogin,'''''', '''''',@UserID,'''''', '''''',@UserName,'''''', '''''',@currentReference,'''''')'')
			
			/**/  Insert into Merlos_Log (error) values (CONCAT(''[pPedido_Linea] -- Insertar Cabecera si no existe: '''''',CHAR(13),@consulta,''''''''))
		end catch
	END
' set @Sentencia1='
	declare @linea int=0
	declare @valor varchar(max)
	declare cur CURSOR for select [value] from openjson(@parametros,''$.lineas'')
	OPEN cur FETCH NEXT FROM cur INTO @valor
	WHILE (@@FETCH_STATUS=0) BEGIN
		set @jsId = JSON_VALUE(@valor,''$.jsId'')
		declare @jsArticulo varchar(50) = JSON_VALUE(@valor,''$.codigo'')
		declare @jsDescrip varchar(100) = (select NOMBRE from ' + @GESTION + '.dbo.articulo where CODIGO=@jsArticulo)
		declare @jsUnidades numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0''),''$.unidades'') as numeric(15,6))			
		declare @jsPesoChar varchar(10) = JSON_VALUE(@valor,''$.peso'')
		declare @jsPeso numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0.000''),''$.peso'') as numeric(15,6))
		declare @jsPrecio numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0.00''),''$.precio'') as numeric(15,6))
		declare @jsDto numeric(15,6) = cast(JSON_VALUE(isnull(@valor,''0''),''$.dto'') as numeric(15,6))
		declare @jsImporte numeric(15,6) = cast(JSON_VALUE(isnull(@valor,''0''),''$.importe'') as numeric(15,6))
		declare @inciArt char(2) = isnull(JSON_VALUE(@valor,''$.incidencia''),'''')
		declare @inciArtDescrip char(100) = isnull(JSON_VALUE(@valor,''$.incidenciaDescrip''),'''')
		declare @obsArt varchar(100) = isnull(replace(JSON_VALUE(@valor,''$.observacion''),''_MI_RETCARRO_MI_'','' ''),'''')
		declare @jsCajas numeric(15,6) = case when  (select isnull(UNICAJA,0) from ' + @GESTION + '.dbo.articulo 
										where CODIGO=@jsArticulo)>0 
										then @jsUnidades / (select isnull(UNICAJA,0) 
										from ' + @GESTION + '.dbo.articulo where CODIGO=@jsArticulo)
										else 0.00 END
																						
		
		-- llenar tabla temporal Temp_Pedido_Detalle
		-- Temp_Pedido_Detalle   -estado:   0-inicial   1-procesado   ------------------------------------------------------------------------------------
		set @linea=(select ISNULL(max(linea),0)+1 from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
		INSERT INTO [dbo].[Temp_Pedido_Detalle]([jsId],[IdTransaccion],[Ejercicio],[IdTeleventa],[IdPedido],[empresa],[numero],[letra],[linea],[cliente],[articulo],[descrip]
						,[cajas],[unidades],[peso],[volumen],[dto1],[dto2],[dto3],[precio],[importeiva],[incidencia],[incidencia_descrip],[observacion]
						,[UserLogin],[UserId],[UserName],[UserReference])
			VALUES
			(@jsId, @IdTransaccion, @EJER, @IdTeleVenta, ''en curso...'', @EMPRESA, '''', '''', @linea, '''', @jsArticulo, @jsDescrip, @jsCajas, @jsUnidades
			, cast(@jsPesoChar as numeric(20,4)), ''''
			, @jsDto, 0.00, 0.00, @jsPrecio, @jsImporte, @inciArt, @inciArtDescrip, @obsArt, @UserLogin, @UserID, @UserName, @currentReference) 

		---------------------------------------------------------------------------------------------------------------------------------------------------

		-- linea Observaciones del artículo
		if @obsArt is not null and @obsArt<>'''' BEGIN
			declare @val varchar(1000)
			declare @observaciones varchar(8000) = isnull(replace(JSON_VALUE(@valor,''$.observacion''),''_MI_RETCARRO_MI_'',''#''),'''')
			declare elCursor cursor for select ltrim(rtrim(value)) from string_split(@observaciones,''#'')
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @val
			WHILE (@@FETCH_STATUS=0) BEGIN
				if LTRIM(rtrim(@val))<>'''' BEGIN
					set @linea=(select ISNULL(max(linea),0)+1 from [Temp_Pedido_Detalle] where IdTransaccion=@IdTransaccion)
					INSERT INTO [dbo].[Temp_Pedido_Detalle]([jsId],[IdTransaccion],[Ejercicio],[IdTeleventa],[IdPedido],[empresa],[numero],[letra],[linea],[cliente],[articulo],[descrip]
								,[cajas],[unidades],[peso],[volumen],[dto1],[dto2],[dto3],[precio],[importeiva],[incidencia],[incidencia_descrip],[observacion]
								,[UserLogin],[UserId],[UserName],[UserReference])
					VALUES
					(@jsId, @IdTransaccion, @EJER, @IdTeleVenta, '''', @EMPRESA, '''', '''', @linea, '''', '''', @val, 0, 0, 0, ''''
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
'
exec (@Sentencia+ @Sentencia1) 
select  'pPedido_Linea'
--	Procedimiento pPedido_Eliminar_Linea
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedido_Eliminar_Linea' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- =============================================
-- Author:		Elías Jené
-- Create date: 13/05/2019
-- Description:	Eliminar Linea del pedido
-- =============================================
'+@AlterCreate+' PROCEDURE [dbo].[pPedido_Eliminar_Linea]	    @IDPEDIDOLIN	varchar(50)										
													,@UserLogin		varchar(50)
													,@UserID		varchar(50)	
													,@UserName		varchar(50)
AS
BEGIN TRY
	declare @letra char(2)   = (select letra collate Modern_Spanish_CI_AI from vPedidos 
								where IDPEDIDO=(select IDPEDIDO collate Modern_Spanish_CI_AI from vPedidos_Detalle where IDPEDIDOLIN=@IDPEDIDOLIN))
	declare @numero char(10) = (select numero collate Modern_Spanish_CI_AI from vPedidos 
								where IDPEDIDO=(select IDPEDIDO collate Modern_Spanish_CI_AI from vPedidos_Detalle where IDPEDIDOLIN=@IDPEDIDOLIN))
	declare @linia varchar(5)= substring(@IDPEDIDOLIN,19,LEN(@IDPEDIDOLIN))

	delete from ' + @GESTION + '.dbo.d_pedive 
	where letra=@letra and numero=@numero and linia=@linia
		
	-- ==================================================================================================================================
	--	Respuesta Flexygo 
		select ''OK'' as JAVASCRIPT
	
	RETURN -1  
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pPedido_Eliminar_Linea'
--	Procedimiento pDirecciones
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pDirecciones' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	08/05/2019
--	Description:	Añadir dirección al cliente
-- ===========================================================

-- exec [pArticulo] ''AUTOF          '', 2
'+@AlterCreate+' PROCEDURE [dbo].[pDirecciones]  @Values as XML OUTPUT, @ContextVars as XML, @RetValues as XML OUTPUT 
AS
BEGIN TRY	
	DECLARE   @modo				varchar(50)
			, @IDDIRECCION		varchar(50)
			, @cliente			varchar(50)
			, @direccion		varchar(80)
			, @codpost			varchar(50)
			, @poblacion		varchar(50)
			, @provincia		varchar(50)
			, @linea			int

			, @UserLogin		varchar(50)
			, @UserID			varchar(50)
			, @UserName			varchar(50)
			, @currentReference	varchar(50)

			, @elSP varchar(50) = ''pDireccion_I''

	-- Obtener datos del XML ----------------------------------------------------------------------------------------------
	SET @modo		= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''MODO'''']/@Value)[1]''		, '' varchar(50)''), '''' )))
	SET @IDDIRECCION= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''IDDIRECCION'''']/@Value)[1]''	, '' varchar(50)''), '''' )))
	SET @cliente	= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''CLIENTE'''']/@Value)[1]''		, '' varchar(50)''), '''' )))
	SET @direccion	= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''DIRECCION'''']/@Value)[1]''	, '' varchar(50)''), '''' )))
	SET @codpost	= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''CODPOS'''']/@Value)[1]''		, '' varchar(50)''), '''' )))
	SET @poblacion	= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''POBLACION'''']/@Value)[1]''	, '' varchar(50)''), '''' )))
	SET @provincia	= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''PROVINCIA'''']/@Value)[1]''	, '' varchar(50)''), '''' )))
	SET @linea		= ltrim(rtrim(ISNULL(  @Values.value(''(/Row/Property[@Name=''''LINEA'''']/@Value)[1]''		, ''int'')		 , '''' )))

	SET @UserLogin			= ltrim(rtrim(ISNULL(  @ContextVars.value(''(/Row/Property[@Name=''''currentUserLogin'''']/@Value)[1]''	, ''varchar(50)'')	, '''' )))
	SET @UserID				= ltrim(rtrim(ISNULL(  @ContextVars.value(''(/Row/Property[@Name=''''currentUserId'''']/@Value)[1]''		, ''varchar(50)'')	, '''' )))
	SET @UserName			= ltrim(rtrim(ISNULL(  @ContextVars.value(''(/Row/Property[@Name=''''currentUserFullName'''']/@Value)[1]'', ''varchar(50)'')	, '''' )))
	SET @currentReference	= ltrim(rtrim(ISNULL(  @ContextVars.value(''(/Row/Property[@Name=''''currentReference'''']/@Value)[1]''	, ''varchar(50)'')	, '''' )))

	if @modo=''Nuevo'' BEGIN
		set @linea = (select isnull(max(linea),0)+1 from ' + @GESTION + '.[dbo].env_cli where cliente=@cliente)
		insert into ' + @GESTION + '.[dbo].env_cli (linea, cliente, direccion, codpos, poblacion, provincia, vista)
		values (ltrim(@linea), ltrim(@cliente), ltrim(@direccion), LTRIM(RTRIM(@codpost)), ltrim(@poblacion), ltrim(@provincia), 1)
	END
	ELSE IF @modo=''Actualizar'' BEGIN
		set @elSP = ''pDireccion_U''
		update ' + @GESTION + '.[dbo].env_cli
		set direccion=@direccion, codpos=LTRIM(RTRIM(@codpost)), poblacion=ltrim(@poblacion), provincia=ltrim(@provincia)
		where cliente=@cliente and linea=@linea
	END
	ELSE IF @modo=''Eliminar'' BEGIN
		set @elSP = ''pDireccion_D''
		delete from ' + @GESTION + '.[dbo].env_cli	where cliente=@cliente and linea=@linea
	END

	-- ==================================================================================================================================
	--	Retorno a Flexygo	
		if @modo=''Nuevo'' BEGIN
			SET @Values.modify(''insert attribute Value {sql:variable("@IDDIRECCION")} into (/Row/Property[@Name=''''IDDIRECCION'''' and empty(@Value)])[1]'')
		END
		SET @Values.modify(''replace value of (/Row/Property[@Name=''''IDDIRECCION'''']/@Value)[1] with sql:variable("@IDDIRECCION")'')
		SET @RetValues.modify(''replace value of (/Property/@Success)[1] with 1'')
	
		SELECT ''flexygo.nav.openPage(''''edit'''',''''MI_Direccion'''', ''''(IDDIRECCION=\'''''' + @IDDIRECCION + ''\'''')'''',null,''''current'''',false,'''');'' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pDirecciones'
--	Procedimiento pDameNumPedido
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pDameNumPedido' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Propiedades del Artículo
-- ===========================================================

-- exec [pArticulo] ''AUTOF          '', 2
'+@AlterCreate+' PROCEDURE [dbo].[pDameNumPedido] @serie char(2),  @codigo char(10)='''' output
AS 
BEGIN TRY
	declare @GESTION char(6)
	declare @CAMPOS char(8)
	declare @empresa char(2)
	declare @estado bit
	DECLARE @EJER CHAR(4)
	
	select @GESTION=GESTION,  @CAMPOS=CAMPOS, @empresa=EMPRESA,  @EJER = LEFT(GESTION,4) from Configuracion_SQL 

	-- Obtener número según los contadores de Eurowin
	SELECT @estado=estado FROM ' + @COMUN + '.dbo.OPCEMP WHERE tipo_opc = 9003 AND empresa=@EMPRESA

    IF @estado=1 
		BEGIN 
			declare @tbCodigoE1 TABLE (contador char(10))
			INSERT @tbCodigoE1 
			EXEC(''SELECT CAST(isnull(contador,0)+1 as varchar) as contador FROM [''+@GESTION+''].[dbo].series WHERE tipodoc = 2 AND empresa=''''''+@EMPRESA+'''''' AND serie=''''''+@serie+'''''''')	
			select @codigo=contador FROM @tbCodigoE1
			delete @tbCodigoE1
		
			set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))
			EXEC (''UPDATE [''+@GESTION+''].[dbo].series SET contador=cast(''''''+@codigo+'''''' as int) WHERE tipodoc=2 AND empresa=''''''+@EMPRESA+'''''' AND serie=''''''+@serie+'''''' '')
		END	
	ELSE 
		BEGIN 
			declare @tbCodigo TABLE (contador char(10))
			INSERT @tbCodigo EXEC(''SELECT cast(isnull(pediven,0)+1 as varchar) as contador FROM [''+@GESTION+''].[dbo].empresa WHERE codigo=''''''+@EMPRESA+'''''''')	
			SELECT @codigo=contador FROM @tbCodigo		
			delete @tbCodigo
			set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))
			EXEC(''UPDATE [''+@GESTION+''].[dbo].empresa SET pediven=cast(''''''+@codigo+'''''' as int) WHERE codigo=''''''+@EMPRESA+'''''' '')
		END

	-- Verificar que el número obtenido no se encuentra en ninguna de las tablas.
	declare @existeEnCPedive smallint, @existeEnDPedive smallint, @existeEnCPediveEW smallint, @existeEnDPediveEW smallint
	declare @TablaTemporal TABLE (existeEnCPedive smallint,	existeEnDPedive smallint, existeEnCPediveEW smallint, existeEnDPediveEW smallint)
	INSERT @TablaTemporal 
	EXEC(''SELECT 
			case when exists(select NUMERO from [''+@GESTION+''].dbo.c_pedive where EMPRESA=''''''+@EMPRESA+'''''' and NUMERO=''''''+@codigo+'''''' and LETRA=''''''+@serie+'''''') then 1 else 0 end as existeEnCPedive
		,	case when exists(select NUMERO from [''+@GESTION+''].dbo.d_pedive where EMPRESA=''''''+@EMPRESA+'''''' and NUMERO=''''''+@codigo+'''''' and LETRA=''''''+@serie+'''''') then 1 else 0 end as existeEnDPedive
		,	case when exists(select NUMERO from [''+@CAMPOS+''].dbo.c_pediveew where EJERCICIO=''''''+@EJER+'''''' AND EMPRESA=''''''+@EMPRESA+'''''' and NUMERO=''''''+@codigo+'''''' and LETRA=''''''+@serie+'''''') 
			then 1 else 0 end as existeEnCPediveEW
		,	case when exists(select NUMERO from [''+@CAMPOS+''].dbo.d_pediveew where EJERCICIO=''''''+@EJER+'''''' AND EMPRESA=''''''+@EMPRESA+'''''' and NUMERO=''''''+@codigo+'''''' and LETRA=''''''+@serie+'''''') 
			then 1 else 0 end as existeEnDPediveEW
	'')	
	SELECT @existeEnCPedive=existeEnCPedive, @existeEnDPedive=existeEnDPedive, @existeEnCPediveEW=existeEnCPediveEW, @existeEnDPediveEW=existeEnDPediveEW FROM @TablaTemporal		
	delete @TablaTemporal

	if @existeEnCPedive=1 or @existeEnDPedive=1 or @existeEnCPediveEW=1 or @existeEnDPediveEW=1
	or exists (select * from Temp_Pedido_Cabecera where empresa=@empresa and ltrim(rtrim(numero))=ltrim(rtrim(@codigo)) and letra=@serie)
	BEGIN 
		set @codigo='''' 
	END

	RETURN -1
END TRY
BEGIN CATCH 
    RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pDameNumPedido'

--	Procedimiento pArticulo
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pArticulo' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Propiedades del Artículo
-- ===========================================================

-- exec [pArticulo] ''AUTOF          '', 2
'+@AlterCreate+' PROCEDURE [dbo].[pArticulo] @articulo char(15), @uds numeric(20,2), @CLIENTE VARCHAR(20)='''', @TARIFA VARCHAR(2)=''''
AS
BEGIN TRY
	DECLARE   @codigo	  char(15)
			, @nombre	  char(75)
			, @marca	  char(2),	@nMarca		 varchar(50)
			, @familia	  char(2),	@nFamilia	 varchar(100)
			, @subfamilia char(4),	@nSubfamilia varchar(50)
			, @peso		  char(12)
			, @litros	  char(12)
			, @unicaja	  numeric(15,6) = 0
			, @dto1		  numeric(20,2)
			, @dto2		  numeric(20,2)
			, @dto3		  numeric(20,2)
			, @coste	  numeric(15,6)
			, @iva		  numeric(20,2)
			, @recargo	  numeric(20,2)
			, @precio	  numeric(20,2)
			, @importe	  numeric(20,2)
			, @maxPed	  varchar(50)
			, @respuesta  varchar(max)

	IF not exists (select codigo from vArticulos where codigo=@articulo) BEGIN
		select N''{"articulo":[]}'' as JAVASCRIPT
		return -1;
	END

	set @nombre  =(select nombre  from vArticulos where codigo=@articulo)
	set @marca   =(select marca   from vArticulos where codigo=@articulo)
	set @nMarca  =(select nombre  from vMarcas    where codigo=(select marca from vArticulos where codigo=@articulo))
	set @familia =(select familia from vArticulos where codigo=@articulo)
	set @nFamilia=(select nombre  from vFamilias  where codigo=(select familia from vArticulos where codigo=@articulo))
	set @subfamilia =(select subfamilia from vArticulos where codigo=@articulo)
	set @nSubfamilia=(select nombre from vSubFamilias where codigo=(select subfamilia from vArticulos where codigo=@articulo))
	set @peso	=(select isnull(peso,'''')		from vArticulos where codigo=@articulo) 
	set @litros	=(select isnull(volumen,'''')	from vArticulos where codigo=@articulo)
	set @unicaja=(select isnull(unicaja,0)	from vArticulos where codigo=@articulo)
	set @dto1	=(select isnull(dto1,0)		from vArticulos where codigo=@articulo)
	set @dto2	=(select isnull(dto2,0)		from vArticulos where codigo=@articulo)
	set @dto3	=(select isnull(dto3,0)		from vArticulos where codigo=@articulo)

	-- devolvemos el stock del artículo
	declare @stock varchar(10) = cast((select isnull(SUM(FINAL),0) from [2021YB].dbo.stocks2 where ARTICULO=@articulo) as varchar)
	if @stock='''' set @stock=''0''
	-- Stock Virtual
	declare @StockVirtual varchar(10) = cast((select isnull(StockVirtual,0) from vArticulos where CODIGO=@articulo) as varchar)


	-- detectar si trabaja con cajas
	declare @conCajas int = 0;	if (select Cajas from vConfigEW where EMPRESA=''01'')=1 BEGIN set @conCajas=1 END

	set @peso = isnull(@peso,''0.00'')
	if @peso='''' set @peso=''0.00''
	
	-- precio, descuentos y total
	set @precio =  isnull((select PVP  from ftDonamPreu(''01'',@CLIENTE,@articulo,'''',@uds,'''')),0)
	set @dto1   =  isnull((select DTO1 from ftDonamPreu(''01'',@CLIENTE,@articulo,'''',@uds,'''')),0)
	set @dto2   =  isnull((select DTO2 from ftDonamPreu(''01'',@CLIENTE,@articulo,'''',@uds,'''')),0)

	set @importe = @precio * @uds
	-- máx. uds por pedido
	set @maxPed = ISNULL((select case when ISNULL(VALOR,''0'')=0 then ''0'' else  ISNULL(VALOR,''0'') END from [2021YB].dbo.multicam where CAMPO=''MPE'' and CODIGO=@articulo),''0'')

	set @respuesta = N''{"articulo":[{''
					+	''"codigo":"''		+@articulo+''",''
					+	''"nombre":"''		+@nombre+''",''
					+	''"marca":"''			+ISNULL(@nMarca,'''')+''",''
					+	''"nMarca":"''		+ISNULL(@marca,'''')+''",''
					+	''"familia":"''		+ISNULL(@familia,'''')+''",''
					+	''"nFamilia":"''		+ISNULL(@nFamilia,'''')+''",''
					+	''"subfamilia":"''	+ISNULL(@subfamilia,'''')+''",''
					+	''"nSubFamilia":"''	+ISNULL(@nSubfamilia,'''')+''",''
					+	''"peso":"''			+@peso+''",''
					+	''"litros":"''		+ISNULL(@litros,'''')+''",''
					+	''"unicaja":"''		+cast(ISNULL(@unicaja,'''')		as varchar)+''",''
					+	''"dto1":"''			+cast(ISNULL(@dto1,'''')			as varchar)+''",''
					+	''"dto2":"''			+cast(ISNULL(@dto2,'''')			as varchar)+''",''
					+	''"dto3":"''			+cast(ISNULL(@dto3,'''')			as varchar)+''",''
					+	''"precio":"''		+cast(ISNULL(@precio,'''')		as varchar)+''",''
					+	''"importe":"''		+cast(ISNULL(@importe,'''')		as varchar)+''",''
					+	''"stock":"''			+cast(ISNULL(@stock,'''')			as varchar)+''",''
					+	''"StockVirtual":"''	+cast(ISNULL(@StockVirtual,'''')	as varchar)+''",''
					+	''"conCajas":"''		+cast(@conCajas					as varchar)+''",''
					+	''"maxPed":"''		+cast(@maxPed					as varchar)+''"''
					+''}]}''
	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pArticulo'
--	Procedimiento pArticuloDatos
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pArticuloDatos' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Propiedades del Artículo
-- ===========================================================

-- exec [pArticulo] ''AUTOF          '', 2
'+@AlterCreate+' PROCEDURE [dbo].[pArticuloDatos] @articulo varchar(50)
AS
BEGIN TRY
	DECLARE   @codigo	  varchar(50)
			, @nombre	  varchar(50)
			, @marca	  varchar(50),	@nMarca		 varchar(50)
			, @familia	  varchar(50),	@nFamilia	 varchar(50)
			, @subfamilia varchar(50),	@nSubfamilia varchar(50)
			, @peso		  varchar(50)
			, @litros	  varchar(50)
			, @unicaja	  varchar(50)
			, @dto1		  varchar(50)
			, @dto2		  varchar(50)
			, @dto3		  varchar(50)
			, @coste	  varchar(50)
			, @tipoIVA	  varchar(50)
			, @recargo	  varchar(50)
			, @precio	  varchar(50)
			, @importe	  varchar(50)
			, @maxPed	  varchar(50)
			, @baja		  char(1) = ''0''
			, @internet	  char(1) = ''0''
			, @imagen	  varchar(1000)
			, @respuesta  varchar(max)

	select @nombre  = nombre  from vArticulos where codigo=@articulo
	select @marca   = marca   from vArticulos where codigo=@articulo
	select @nMarca  = nombre  from vMarcas    where codigo=(select marca from vArticulos where codigo=@articulo)
	select @familia = familia from vArticulos where codigo=@articulo
	select @nFamilia= nombre  from vFamilias  where codigo=(select familia from vArticulos where codigo=@articulo)
	select @subfamilia = subfamilia from vArticulos where codigo=@articulo
	select @nSubfamilia= nombre from vSubFamilias where codigo=(select subfamilia from vArticulos where codigo=@articulo)
	select @peso	= isnull(peso,'''')		from vArticulos where codigo=@articulo 
	select @litros	= isnull(volumen,'''')	from vArticulos where codigo=@articulo
	select @unicaja = cast(isnull(unicaja,0) as varchar(50)) from vArticulos where codigo=@articulo
	select @dto1	= cast(isnull(dto1,0) as varchar(50)) from vArticulos where codigo=@articulo
	select @dto2	= cast(isnull(dto2,0) as varchar(50)) from vArticulos where codigo=@articulo
	select @dto3	= cast(isnull(dto3,0) as varchar(50)) from vArticulos where codigo=@articulo
	select @tipoIVA	= isnull(TIPO_IVA,'''') from vArticulos where codigo=@articulo
	select @precio	= isnull(COST_ULT1,0.00) from vArticulos where codigo=@articulo
	select @baja	= isnull(cast(BAJA as varchar(1)),''0'') from vArticulos where codigo=@articulo
	select @internet= isnull(cast(INTERNET as varchar(1)),''0'') from vArticulos where codigo=@articulo
	select @imagen	= isnull(cast(IMAGEN as varchar(1000)),''NOIMG.png'') from vArticulos where codigo=@articulo

	-- máx. uds por pedido
	set @maxPed = ISNULL((select case when ISNULL(VALOR,''0'')=0 then ''0'' else  ISNULL(VALOR,''0'') END from [2021YB].dbo.multicam where CAMPO=''MPE'' and CODIGO=@articulo),''0'')

	set @respuesta = N''{"articulo":[{''
					+	''"codigo":"''		+ISNULL(ltrim(rtrim(@articulo)),'''')+''",''
					+	''"nombre":"''		+ISNULL(ltrim(rtrim(@nombre)),'''')+''",''
					+	''"marca":"''		+ISNULL(ltrim(rtrim(@marca)),'''')+''",''
					+	''"nMarca":"''		+ISNULL(ltrim(rtrim(@nMarca)),'''')+''",''
					+	''"familia":"''		+ISNULL(ltrim(rtrim(@familia)),'''')+''",''
					+	''"nFamilia":"''	+ISNULL(ltrim(rtrim(@nFamilia)),'''')+''",''
					+	''"subfamilia":"''	+ISNULL(ltrim(rtrim(@subfamilia)),'''')+''",''
					+	''"nSubFamilia":"''	+ISNULL(ltrim(rtrim(@nSubfamilia)),'''')+''",''
					+	''"peso":"''		+isnull(ltrim(rtrim(@peso)),'''')+''",''
					+	''"litros":"''		+ISNULL(ltrim(rtrim(@litros)),'''')+''",''
					+	''"unicaja":"''		+ISNULL(ltrim(rtrim(@unicaja)),'''')+''",''
					+	''"dto1":"''		+ISNULL(ltrim(rtrim(@dto1)),'''')+''",''
					+	''"dto2":"''		+ISNULL(ltrim(rtrim(@dto2)),'''')+''",''
					+	''"dto3":"''		+ISNULL(ltrim(rtrim(@dto3)),'''')+''",''
					+	''"tipoiva":"''		+ISNULL(ltrim(rtrim(@tipoIVA)),'''')+''",''
					+	''"precio":"''		+ISNULL(ltrim(rtrim(@precio)),'''')+''",''
					+	''"importe":"''		+ISNULL(ltrim(rtrim(@importe)),'''')+''",''
					+	''"maxPed":"''		+ISNULL(ltrim(rtrim(@maxPed)),'''')+''",''
					+	''"baja":"''		+ISNULL(ltrim(rtrim(@baja)),'''')+''",''
					+	''"internet":"''	+ISNULL(ltrim(rtrim(@internet)),'''')+''",''
					+	''"imagen":"''		+ISNULL(ltrim(rtrim(@imagen)),'''')+''"''
					+''}]}''
	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec (@Sentencia) 
select  'pArticuloDatos'









-- Procedimiento pClientes
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pClientes' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	02/05/2019
--	Description:	Obtener Clientes del Vendedor
-- ===========================================================

-- exec pClientes ''..''
-- exec pClientes ''01'',''actividad:50''

'+@AlterCreate+'  PROCEDURE [dbo].[pClientes] @elVendedor varchar(20)='''', @modo varchar(100)='''', @elUsuario varchar(50)='''', @elRol varchar(50)=''''
AS
BEGIN TRY
	
	-- Clientes NO geolocalizados
	if @modo=''listaNoGeolocalizados'' BEGIN
			declare @numClientesNoGeo int = (select count(codigo)  
			from vClientes where DIRECCION<>'''' and ( LATITUD='''' or LATITUD is null or LONGITUD='''' or LONGITUD is null )
			)
			select cast(@numClientesNoGeo as varchar) as JAVASCRIPT
		return -1
	END

	-- Clientes NO geolocalizados - Geolocalizar
	if @modo=''GeolocalizarCliente'' BEGIN
		BEGIN TRY DROP TABLE #Temp END TRY BEGIN CATCH end CATCH
		select top 1 codigo  collate Modern_Spanish_CS_AI as codigo
					, NOMBRE  collate Modern_Spanish_CS_AI as NOMBRE
					, DIRECCION collate Modern_Spanish_CS_AI + '' '' + CP collate Modern_Spanish_CS_AI + '' '' + POBLACION collate Modern_Spanish_CS_AI as laDIRECCION 
		into #Temp from vClientes 
		where DIRECCION<>'''' and ( LATITUD='''' or LATITUD is null or LONGITUD='''' or LONGITUD is null )		
		if (select count(NOMBRE) from #Temp)>0 BEGIN
			select CONCAT(''{"clientes":[{''
						,''"codigo":"'',(select isnull(codigo ,'''') from #Temp),''"''
						,'',"nombre":"'',(select isnull(replace(NOMBRE,''"'',''-'') ,'''') from #Temp),''"''
						,'',"direccion":"'',(select isnull(ltrim(rtrim(replace(laDIRECCION,''"'',''-''))) ,'''') from #Temp)+''"''
						,'',"faltantes":"'',(select count(codigo) from vClientes where DIRECCION<>'''' 
											and ( LATITUD='''' or LATITUD is null or LONGITUD='''' or LONGITUD is null)),''"''
					,''}]}'') as JAVASCRIPT
		END ELSE BEGIN
			select ''{"clientes":[{"codigo":"0"}]}'' AS JAVASCRIPT
		END
		BEGIN TRY DROP TABLE #Temp END TRY BEGIN CATCH end CATCH
		return -1
	END

' set @Sentencia = @Sentencia + '

	declare @elWhere varchar(max) = '' where (VENDEDOR='''''' + @elVendedor+'''''' 
	or VENDEDOR in (select SubVendedor collate Modern_Spanish_CI_AI from VendSubVend where Vendedor=''''''+@elVendedor+''''''))and BAJA=0 ''	

	-- SPLIT de @modo
	DECLARE @modoPart NVARCHAR(255), @pos INT
	WHILE CHARINDEX('':'', @modo) > 0 BEGIN
		set @pos = CHARINDEX('':'', @modo)  
		set @modoPart = SUBSTRING(@modo, 1, @pos-1)	
		set @modo = SUBSTRING(@modo, @pos+1, LEN(@modo)-@pos)
	END	

	if @modoPart=''actividad'' and @modo<>''0'' begin
		set @elWhere=@elWhere+'' and CODIGO IN (select CLIENTE from vActividadesClientes where ACTIVIDAD=''''''+@modo+'''''') ''
	end

	--if @elVendedor IS NULL and @elRol<>''VerTodosLosClientes'' BEGIN print ''No se ha especificado el VENDEDOR !''; return 0; END 
	if @elVendedor=''..'' begin set @elWhere='''' end
	if @elRol=''MI_User_RUTA'' begin set @elWhere= '' where RUTA='''''' + @elVendedor+'''''' and BAJA=0 '' end
	else if @elRol=''VerTodosLosClientes'' or @elRol=''Admins'' or @elRol=''AdminPortal'' begin set @elWhere='''' end

	declare @sentenciaSQL varchar(max) = ''''
	set @sentenciaSQL=''
		declare   @codigo varchar(50)
				, @nombre varchar(50)
				, @direccion varchar(50)
				, @cp varchar(50)
				, @poblacion varchar(50)
				, @provincia varchar(50)
				, @latitud varchar(50)
				, @longitud varchar(50)
				, @respuesta varchar(max)=''''''''
' set @Sentencia = @Sentencia + '
		set @respuesta = 
			(
				select CODIGO as codigo 
				, replace(replace(NOMBRE,''''"'''',''''-''''),'''''''''''''''',''''&#39;'''') as nombre 
				, replace(replace(replace(DIRECCION,''''"'''',''''-''''),'''''''''''''''',''''-''''),''''&#34;'''',''''-'''') as direccion
				, ltrim(rtrim(CP)) as cp
				, POBLACION as poblacion
				, PROVINCIA as provincia
				, ltrim(rtrim(LATITUD)) as latitud
				, ltrim(rtrim(LONGITUD)) as longitud
				from vClientes ''
			
				set @sentenciaSQL=@sentenciaSQL+@elWhere+'' order by NOMBRE 
				for JSON PATH,ROOT(''''clientes'''')
			)
		
			SELECT isnull(@respuesta,''''{"clientes":[]}'''') AS JAVASCRIPT
		''

	-- print @sentenciaSQL return -1 
	EXEC(@sentenciaSQL)
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
exec(@Sentencia)
select  'pClientes'




--	Procedimiento pDamePrecio
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pDamePrecio' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- =============================================
-- Author:		Lluis Caballero
-- Create date: 30/08/27
-- Description:	Proceso para devolver el precio de forma estandard
-- =============================================
'+@AlterCreate+'  PROCEDURE [dbo].[pDamePrecio]
	(
		@ARTICULO VARCHAR(20),
		@CLIENTE VARCHAR(20)='''',
		@TARIFA VARCHAR(2)='''',
		@UNIDADES NUMERIC(18,4)=1,
		@FECHAPRECIO SMALLDATETIME=''''
	)
AS 
BEGIN TRY
    DECLARE @PREU NUMERIC(15,6), @DTO1 NUMERIC(15,2), @DTO2 NUMERIC(15,2), @RESPOSTA varchar(max), @RESPOSTA2 varchar(max), 
	@FECHA SMALLDATETIME, @EMP CHAR(2), @TIPOPVP CHAR(2), @Mensaje varchar(max), @MensajeError varchar(max)
	SET @PREU=0.000000
	SET @DTO1=0.00
	SET @DTO2=0.00
	SET @EMP=''01''
	IF COALESCE(@FECHAPRECIO,'''')='''' SET @FECHA=CAST(CONVERT(char(11), getdate(), 113) as datetime)
	ELSE SET @FECHA=@FECHAPRECIO
	SET @TIPOPVP=''''

	SELECT @PREU=PVP, @DTO1=DTO1, @DTO2=DTO2 FROM DBO.ftDonamPreu(@EMP,@CLIENTE,@ARTICULO,@TARIFA,@UNIDADES,@FECHA)
	--SELECT @TIPOPVP=TIPOPVP FROM vAHArticulos WHERE CODIGO=@ARTICULO

	SET @RESPOSTA2=''","PRECIO":"''+LTRIM(STR(@PREU,15,6))+''","DTO1":"''+LTRIM(STR(@DTO1,15,2))+''","DTO2":"''+LTRIM(STR(@DTO2,15,2))
	SELECT @RESPOSTA2 AS JAVASCRIPT
	--select (@RESPOSTA)
	RETURN -1
END TRY
BEGIN CATCH 
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  

    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
    -- Error
    SET @Mensaje=''ERROR de proceso''
	--select (@Mensaje)
	SELECT ''ALERT(''''''+@Mensaje+chAr(13)+''Missatge:''+@ErrorMessage+''''''); parent.cierraIframe();'' AS JAVASCRIPT
    RETURN 1
END CATCH
'
exec (@Sentencia) 
select  'pDamePrecio'







--	Procedimiento pFamilias
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pFamilias' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	05/07/2019
--	Description:	Obtener Familias de Artículos
-- ===========================================================

-- exec [pFamilias] ''lista''

'+@AlterCreate+'  PROCEDURE [dbo].[pFamilias] @modo char(50)=''''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @respuesta VARCHAR(max) = ''{"familias":[''

	if @modo=''lista'' BEGIN
		DECLARE CRSR CURSOR FOR 
		(select CODIGO, NOMBRE from vFamilias)
		OPEN CRSR
			FETCH NEXT FROM CRSR INTO @codigo, @nombre
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @respuesta = @respuesta + ''{"codigo":"''+@codigo+''","nombre":"''+@nombre+''"},''
				FETCH NEXT FROM CRSR INTO @codigo, @nombre
			END	
		CLOSE CRSR deallocate CRSR	

		if (select count(CODIGO) from vFamilias)>0	set @respuesta = SUBSTRING( @respuesta,0,LEN(@respuesta) ) + '']}'';
		ELSE set @respuesta = @respuesta + '']}''
	END
	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--exec (@Sentencia) 
select  'pFamilias'




--	Procedimiento pPedido_Nuevo
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedido_Nuevo' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- =============================================
--	Author:			Elías Jené
--	Create date:	16/05/2019
--	Description:	Crear Pedido
-- =============================================
'+@AlterCreate+'   PROCEDURE [dbo].[pPedido_Nuevo] @Values XML OUTPUT, @ContextVars as XML, @RetValues as XML OUTPUT
AS
BEGIN TRANSACTION pedidoNuevo
BEGIN TRY
	DECLARE	  @MODO		  varchar(50)	
			, @IDPEDIDO	  varchar(50)		
			, @CLIENTE	  varchar(20)	
			, @ENV_CLI	  int
			, @SERIE	  char(2) = ''''					
			, @ENTREGA	  varchar(10)
			, @CONTACTO	  varchar(50) = ''0''
			, @INCICLI	  varchar(50) = ''''
			, @INCICLIDescrip varchar(1000) = ''''
			, @VENDEDOR  varchar(20) = ''01''
			, @FAMILIA    char(4) = ''''
			, @OBSERVACIO varchar(8000)
			, @LINEAS varchar(max)
			, @NoCobrarPortes char(1)
			, @VerificarPedido char(1)
			, @UserLogin  varchar(50)
			, @UserID	  varchar(50)=''''
			, @UserName	  varchar(50)=''''
			, @currentReference varchar(50)=''''
			
			, @EJER VARCHAR(4)
			, @EMPRESA CHAR(2) = ''01''
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

			, @tipo	varchar(20) = ''PEDIVEN''
			, @clave_ejercicio_empresa	char(6)
			, @clave_numero				char(10)
			, @clave varchar(20)
' set  @Sentencia = @Sentencia + '

	-- Obtener datos del XML ----------------------------------------------------------------------------------------------
	SET @MODO		= @Values.value(''(/Row/Property[@Name=''''MODO'''']/@Value)[1]''		, ''varchar(50)'')
	SET @EMPRESA	= @Values.value(''(/Row/Property[@Name=''''EMPRESA'''']/@Value)[1]''	, ''varchar(2)'')
	SET @IdTeleVenta= @Values.value(''(/Row/Property[@Name=''''IdTeleVenta'''']/@Value)[1]'', ''varchar(50)'')
	SET @NombreTV	= @Values.value(''(/Row/Property[@Name=''''NombreTV'''']/@Value)[1]''	, ''varchar(100)'')
	SET @FechaTV	= @Values.value(''(/Row/Property[@Name=''''FechaTV'''']/@Value)[1]''	, ''varchar(10)'')
	SET @IDPEDIDO	= @Values.value(''(/Row/Property[@Name=''''IDPEDIDO'''']/@Value)[1]''	, ''varchar(50)'')
	SET @CLIENTE	= @Values.value(''(/Row/Property[@Name=''''CLIENTE'''']/@Value)[1]''	, ''varchar(50)'')
	SET @ENV_CLI	= @Values.value(''(/Row/Property[@Name=''''ENV_CLI'''']/@Value)[1]''	, ''int'')
	SET @SERIE		= @Values.value(''(/Row/Property[@Name=''''SERIE'''']/@Value)[1]''		, ''varchar(50)'')
	SET @ENTREGA	= @Values.value(''(/Row/Property[@Name=''''ENTREGA'''']/@Value)[1]''	, ''varchar(50)'')
	SET @CONTACTO	= @Values.value(''(/Row/Property[@Name=''''CONTACTO'''']/@Value)[1]''	, ''varchar(50)'')
	SET @INCICLI	= @Values.value(''(/Row/Property[@Name=''''INCICLI'''']/@Value)[1]''	, ''varchar(50)'')
	SET @VENDEDOR	= @Values.value(''(/Row/Property[@Name=''''VENDEDOR'''']/@Value)[1]''	, ''varchar(20)'')
	SET @FAMILIA	= @Values.value(''(/Row/Property[@Name=''''FAMILIA'''']/@Value)[1]''	, ''varchar(50)'')
	SET @OBSERVACIO	= @Values.value(''(/Row/Property[@Name=''''OBSERVACIO'''']/@Value)[1]''	, ''varchar(50)'')
	SET @LINEAS		= @Values.value(''(/Row/Property[@Name=''''LINEAS'''']/@Value)[1]''	, ''varchar(max)'')
	SET @NoCobrarPortes	= @Values.value(''(/Row/Property[@Name=''''NoCobrarPortes'''']/@Value)[1]''	, ''char(1)'')
	SET @VerificarPedido	= @Values.value(''(/Row/Property[@Name=''''VerificarPedido'''']/@Value)[1]''	, ''char(1)'')

	SET @UserLogin			= @ContextVars.value(''(/Row/Property[@Name=''''currentUserLogin'''']/@Value)[1]''	, ''varchar(50)'')
	SET @UserID				= @ContextVars.value(''(/Row/Property[@Name=''''currentUserId'''']/@Value)[1]''		, ''varchar(50)'')
	SET @UserName			= @ContextVars.value(''(/Row/Property[@Name=''''currentUserFullName'''']/@Value)[1]''	, ''varchar(50)'')
	SET @currentReference	= @ContextVars.value(''(/Row/Property[@Name=''''currentReference'''']/@Value)[1]''	, ''varchar(50)'')
	
	if @ENV_CLI is null or @ENV_CLI='''' 
	set @ENV_CLI = isnull((select ISNULL(LINEA,0) from vContactos where CLIENTE=@CLIENTE and LINEA=0),0)

	/*-- en USO
	set @clave_ejercicio_empresa = LEFT(@IDPEDIDO,6)
	set @clave_numero = RIGHT(@IDPEDIDO,10)
	declare @nuevoValor varchar(10) = '''', @pos int = 0, @noEsCero int = 0
	WHILE @pos<LEN(@clave_numero) BEGIN
		set @pos = @pos + 1
		declare @caracter char(1) = SUBSTRING(@clave_numero,@pos,1)
		if @caracter=''0'' and @noEsCero=0  set @caracter=space(1) else set @noEsCero=1 
		set @nuevoValor = @nuevoValor + @caracter
	END
	set @clave_numero = @nuevoValor
	set @clave = concat(@clave_ejercicio_empresa,@clave_numero,@SERIE)*/
' set  @Sentencia = @Sentencia + '

	--Creamos las variables de trabajo
	DECLARE @nombreUsuario CHAR(25), @codigo char(10), @estado_aux BIT, @aux INT,
			 @letra CHAR(2), @moneda VARCHAR(3), @fpag VARCHAR(2), @ruta CHAR(2)
			 set @letra=@SERIE

	--Inicializamos las variables donde haremos las inserciones
	SET @EJER = (select [any] from '+@COMUN+'.[DBO].ejercici where predet=1)

	IF @ENTREGA IS NULL or @ENTREGA='''' set @ENTREGA=@FECHAmas1	
		
	-- GENERAR PEDIDO
	SET @fpag	= (SELECT fpag FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE)
	SET @PRONTO = (SELECT PRONTO FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE)
	SET @ruta	= isnull((SELECT ruta FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE),'''')
	SET @nVENDEDOR = (SELECT nombre FROM '+@GESTION+'.[dbo].vendedor WHERE codigo=@Vendedor)
		
	SET @nombreUsuario = ''FLEXYGO##V_''+@UserLogin
	
	IF @OBSERVACIO IS NULL or @OBSERVACIO='''' 
		SET @OBSERVACIO = (SELECT OBSERVACIO from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)
	IF @OBSERVACIO IS NULL 
		SET @OBSERVACIO = ''''

	/*SET @SentenciaSQL = ''SELECT fpag, pronto, ruta INTO ##CLIENTE FROM '+@GESTION+'.[dbo].clientes WHERE codigo = ''+@CLIENTE
	EXEC(@SentenciaSQL)
	SET @fpag   = (SELECT fpag FROM ##CLIENTE)
	SET @PRONTO = (SELECT pronto FROM ##CLIENTE)
	SET @ruta   = (SELECT ruta FROM ##CLIENTE)
	DROP TABLE ##CLIENTE	*/
' set  @Sentencia = @Sentencia + '

	SELECT @fpag=fpag, @PRONTO=pronto, @ruta=ruta FROM '+@GESTION+'.[dbo].clientes WHERE codigo = @CLIENTE

	SET @almacen = (SELECT almacen FROM '+@GESTION+'.dbo.empresa WHERE codigo = @EMPRESA)

	SET @estado_aux = (SELECT estado FROM '+@COMUN+'.dbo.OPCEMP WHERE tipo_opc = 9003 AND empresa=@EMPRESA)

	-- Obtener número según los contadores de Eurowin
	IF (@estado_aux = 1) BEGIN
		SET @codigo = cast((SELECT isnull(contador,0)+1 FROM '+@GESTION+'.[dbo].series WHERE tipodoc = 2 AND empresa=@EMPRESA AND serie=@letra) as char(10))
		--while len(@codigo)<10 begin set @codigo=CONCAT(space(1),@codigo) end
		 set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))

		UPDATE '+@GESTION+'.[dbo].series SET contador=cast(@codigo as int) WHERE tipodoc = 2 AND empresa=@EMPRESA AND serie=@letra
	END
	ELSE BEGIN
		SET @codigo = cast((SELECT isnull(pediven,0)+1 FROM '+@GESTION+'.[dbo].empresa WHERE codigo=@EMPRESA) as char(10))
		--while len(@codigo)<10 begin set @codigo=CONCAT(space(1),@codigo) end
		set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))
		UPDATE '+@GESTION+'.[dbo].empresa SET pediven = cast(@codigo as int) WHERE codigo=@EMPRESA 
	END
	
	IF @REFERCLI IS NULL BEGIN set  @REFERCLI = '''' END
	IF @PRONTO   IS NULL BEGIN set  @PRONTO   = 0  END

	declare @pais char(3)
	set @pais= (select PAIS from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)
	declare @divisa char(3) = isnull((select isnull(MONEDA,'''') from '+@COMUN+'.dbo.paises where CODIGO=@pais),0)

	INSERT INTO '+@GESTION+'.[DBO].c_pedive ( usuario, empresa, numero, fecha, cliente, env_cli, entrega, vendedor, ruta, pronto, iva_inc, divisa
										, cambio, fpag, letra, hora, almacen,observacio ) 
	VALUES ( @UserLogin, @EMPRESA, @codigo, cast(@FECHA as smalldatetime), @CLIENTE, @env_cli, @ENTREGA, @Vendedor, @ruta, @PRONTO, 0, @divisa, 1
			, @fpag, @letra, getdate(), @almacen, @OBSERVACIO )
			
	SET @IDPEDIDO = CONCAT(@EJER,@EMPRESA,@letra,@codigo)
	declare @IDP varchar(50) 
	set @IDP = replace(@IDPEDIDO,space(1),''0'')
	set @IDPEDIDO = LEFT(@IDP,18)
' set  @Sentencia = @Sentencia + '

	insert into [dbo].[Pedidos_Familias](EJERCICIO, EMPRESA, NUMERO, LETRA, FAMILIA)
	values (@EJER, @EMPRESA, @codigo, @letra, @FAMILIA)
		
	--	Guardamos el contacto en Pedidos_contactos
		insert into Pedidos_Contactos (IDPEDIDO, Cliente, Contacto)
		values (@IDPEDIDO, @CLIENTE, @CONTACTO)

	-- ==================================================================================================================================
	-- Insertamos las lineas del pedido	

		set @LINEAS = ''{"datos":''+replace(replace(@LINEAS,''_openLL_'',''{''),''_closeLL_'',''}'')+''}''
		
		declare @valor varchar(max)
		declare cur CURSOR for select [value] from openjson(@LINEAS,''$.datos'')
		OPEN cur FETCH NEXT FROM cur INTO @valor
		WHILE (@@FETCH_STATUS=0) BEGIN
			declare @jsArticulo varchar(50) = JSON_VALUE(@valor,''$.codigo'')
			declare @jsDescrip varchar(100) = (select NOMBRE from '+@GESTION+'.dbo.articulo where CODIGO=@jsArticulo)
			declare @jsUnidades numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0''),''$.unidades'') as numeric(15,6))			
			declare @jsPesoChar varchar(10) = JSON_VALUE(@valor,''$.peso'')
			declare @jsPeso numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0.000''),''$.peso'') as numeric(15,6))
			declare @jsPrecio numeric(15,6) = cast( JSON_VALUE(isnull(@valor,''0.00''),''$.precio'') as numeric(15,6))
			declare @jsDto numeric(15,6) = cast(JSON_VALUE(isnull(@valor,''0''),''$.dto'') as numeric(15,6))
			declare @jsImporte numeric(15,6) = cast(JSON_VALUE(isnull(@valor,''0''),''$.importe'') as numeric(15,6))
			declare @inciArt char(2) = JSON_VALUE(@valor,''$.incidencia'') 
			declare @inciArtDescrip char(100) = JSON_VALUE(@valor,''$.incidenciaDescrip'') 
			declare @obsArt varchar(50) = JSON_VALUE(@valor,''$.observacion'')
			declare @jsCajas numeric(15,6) = case when  (select isnull(UNICAJA,0) from '+@GESTION+'.dbo.articulo 
											where CODIGO=@jsArticulo)>0 
											then @jsUnidades / (select isnull(UNICAJA,0) 
											from '+@GESTION+'.dbo.articulo where CODIGO=@jsArticulo)
											else 0.00 END
' set  @Sentencia = @Sentencia + '

			EXEC [pPedido_Nuevo_Linea_I]	  @MODO = ''''
											, @Emp = @EMPRESA
											, @IDPEDIDO = @IDPEDIDO
											, @NUMERO=@codigo
											, @LETRA=@letra
											, @CLIENTE=@CLIENTE
											, @ARTICULO = @jsArticulo
											, @DESCRIP = @jsDescrip
											, @cajas = @jsCajas
											, @UNIDADES = @jsUnidades
											, @peso = @jsPeso
											, @pesoChar	= @jsPesoChar
											, @volumenChar = ''''
											, @DTO1 = @jsDto
											, @DTO2 = 0.00	
											, @DTO3 = 0.00														
											, @PRECIO = @jsPrecio												
											, @importeiva = @jsImporte
											, @UserLogin = @UserLogin
											, @UserID = @UserID
											, @UserName = @UserName


			-- linea de observaciones
			if @obsArt is not null and @obsArt<>'''' BEGIN
				INSERT INTO '+@GESTION+'.[DBO].d_pedive (usuario, empresa, numero, linia, articulo, definicion, unidades, precio, dto1, dto2
					, importe, tipo_iva, coste, cliente, precioiva, importeiva, cajas, familia, preciodiv, importediv, peso, letra
					, impdiviva, prediviva, RECARG)
				VALUES (
						 @currentReference
						,@EMPRESA
						,@codigo
						,(select isnull(MAX(LINIA),0)+1 from '+@GESTION+'.dbo.d_pedive 
						 where CONCAT('''+@ANY+''',EMPRESA,replace(LETRA,space(1),''0''),replace(LEFT(NUMERO,10),space(1),''0''))  
						 collate Modern_Spanish_CI_AI=@IDPEDIDO)
						,'''',@obsArt,0,0,0,0,0,'''',0,@cliente,0,0,0,'''',0,0,0,@letra,0,0,0
						)
			END	
' set  @Sentencia = @Sentencia + '
			
			declare @hora varchar(2) = cast(datepart(HOUR,getdate()) as varchar(2))
			declare @minutos varchar(2) = cast(datepart(MINUTE,getdate()) as varchar(2))
			if len(@hora)=1 set @hora = ''0''+@hora
			if len(@minutos)=1 set @minutos = ''0''+@minutos
			declare @laHora varchar(5) = @hora+'':''+@minutos

			if (@inciArt is not null) or (@obsArt is not null and @obsArt<>'''')	
			insert into TeleVentaIncidencias (id,gestor,tipo,incidencia,cliente,idpedido,articulo,observaciones) 
				values (@IdTeleVenta,@currentReference,''Articulo'',@inciArt,@cliente,@idpedido,@jsArticulo,@obsArt)

			FETCH NEXT FROM cur INTO @valor
		END CLOSE cur deallocate cur	
		

		-- PORTES -- (DISTECO)
		insert into Configuracion_ADI (EJER,EMPRESA,NUMERO,LETRA,CAMPO,VALOR)
		values(@EJER,@EMPRESA,@codigo,@letra,''EWNOPORT'',@NoCobrarPortes)
		if exists(
			select * from '+@CAMPOS+'.dbo.c_pediveew
			where CONCAT(EJERCICIO,EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT(@EJER,@EMPRESA,ltrim(rtrim(@codigo)),@letra)
		)
			update '+@CAMPOS+'.dbo.c_pediveew set EWNOPORT=@NoCobrarPortes 
			where CONCAT(EJERCICIO,EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT(@EJER,@EMPRESA,ltrim(rtrim(@codigo)),@letra)
		else
			insert into '+@CAMPOS+'.dbo.c_pediveew (EJERCICIO,EMPRESA,NUMERO,LETRA,EWNOPORT)
			values (@EJER,@EMPRESA,@codigo,@letra,@NoCobrarPortes)
		

		-- VERIFICAR PEDIDO	 -- (DISTECO)		
		insert into Configuracion_ADI (EJER,EMPRESA,NUMERO,LETRA,CAMPO,VALOR)
		values(@EJER,@EMPRESA,@codigo,@letra,''EWVERIFI'',@VerificarPedido)
		if exists(
			select * from '+@CAMPOS+'.dbo.c_pediveew
			where CONCAT(EJERCICIO,EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT(@EJER,@EMPRESA,ltrim(rtrim(@codigo)),@letra)
		)
			update '+@CAMPOS+'.dbo.c_pediveew set EWVERIFI=@VerificarPedido
			where CONCAT(EJERCICIO,EMPRESA,ltrim(rtrim(NUMERO)),LETRA)=CONCAT(@EJER,@EMPRESA,ltrim(rtrim(@codigo)),@letra)
		else
			insert into '+@CAMPOS+'.dbo.c_pediveew (EJERCICIO,EMPRESA,NUMERO,LETRA,EWVERIFI)
			values (@EJER,@EMPRESA,@codigo,@letra,@VerificarPedido)

		-- actualizar cabecera del pedido
		EXEC [pPedido_ActualizarCabecera] @IDPEDIDO

	COMMIT TRANSACTION pedidoNuevo
	SELECT ''{"IdPedido":"''+@IDPEDIDO+''","Ejercicio":"''+@EJER+''","Empresa":"''+@EMPRESA+''","Letra":"''+@letra+''","Codigo":"''+ltrim(rtrim(@codigo))+''"}'' as JAVASCRIPT
	RETURN -1  
END TRY


BEGIN CATCH
	ROLLBACK TRANSACTION pedidoNuevo
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= concat(
		 ''Error pedidoNuevo !!!''
		, char(13), ERROR_MESSAGE()
		, char(13), ERROR_NUMBER()
		, char(13), ERROR_PROCEDURE()
		, char(13), @@PROCID
		, char(13), ERROR_LINE()
	)
	RAISERROR(@CatchError,12,1)

	RETURN 0
END CATCH
'
----EXEC (@Sentencia) 
select  'pPedido_Nuevo'




--	Procedimiento pPedido_Nuevo_Linea_I
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedido_Nuevo_Linea_I' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- =============================================
-- Author:		Elías Jené
-- Create date: 17/05/2019
-- Description:	Añadir Linea al Pedido
-- =============================================
'+@AlterCreate+'  PROCEDURE [dbo].[pPedido_Nuevo_Linea_I]		 @MODO			varchar(50)	
													,@Emp			char(2) = ''01''
													,@IDPEDIDO		varchar(50)
													,@NUMERO		varchar(50)
													,@LETRA			char(2)
													,@CLIENTE		varchar(50)
													,@ARTICULO		char(15)
													,@DESCRIP		char(75)
													,@cajas			numeric(10,2)
													,@UNIDADES		numeric(15,6)
													,@peso			numeric(20,4)
													,@pesoChar		char(12)
													,@volumenChar	char(12)
													,@DTO1			numeric(20,2)
													,@DTO2			numeric(20,2)		
													,@DTO3			numeric(20,2)														
													,@PRECIO		numeric(15,6)														
													,@importeiva	numeric(20,2)											
													,@UserLogin		varchar(50) = ''''
													,@UserID		varchar(50)	= ''''
													,@UserName		varchar(50) = ''''
AS
BEGIN TRY
	DECLARE	 @EJER			varchar(4)
			,@TIPO_IVA		char(2)
			,@IVA			numeric(20,2)
			,@linia			int
			,@precio_IVA	numeric(20,2)	
			,@recargoPC		numeric(20,2)
			,@recargoIMP	numeric(20,2)
			,@IMPORTE		numeric(20,2) = isnull(@importeiva,0)
			,@coste			numeric(20,2) = 0
			,@familia		char(10)		
			,@nombre_usuario varchar(50)
			,@IDPV			char(14)	
			,@Mensaje		varchar(max)
			,@MensajeError	VARCHAR(MAX)
			,@recargo		bit
' set  @Sentencia = @Sentencia + '
	declare @sentencia varchar(max) = ''''

	if @DESCRIP is null set @DESCRIP=''''
	SET @EJER = (select [any] from '+@COMUN+'.[DBO].ejercici where predet=1)

	set @linia	  = (select isnull(max(LINIA),0)+1 from '+@GESTION+'.dbo.d_pedive where empresa=@Emp and numero=@numero and letra=@letra)	

	select @familia=familia, @coste=COST_ULT1  from vArticulos where codigo=@ARTICULO

	declare @IVAcliente char(2) = ISNULL((select TIPO_IVA from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE),''00'')
	declare @IVAarticulo char(2) = ISNULL((select TIPO_IVA from '+@GESTION+'.dbo.articulo where CODIGO=@articulo),''00'')
			
	if @IVAcliente=0 
		set @TIPO_IVA=@IVAarticulo 
	else 
		set @TIPO_IVA=@IVAcliente

	set @precio_IVA = (@IMPORTE  * (select IVA from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)) / 100
	set @importeiva = ((@IMPORTE * (select IVA from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)) / 100) + @IMPORTE

	if (select RECARG from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)>0  
		and (select RECARGO from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)=1 BEGIN
		set @recargo=1
		set @recargoPC  = (select RECARG from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)
		set @recargoIMP = (@IMPORTE * @recargoPC) / 100
	END ELSE set @recargo=0

	IF @peso is null set @peso=0
' set  @Sentencia = @Sentencia + '
	
	-- Coste Residuo
	declare @CosteResiduo numeric(15,6)=0.00
		,	@PVERDE bit = 0
		,	@P_TAN  int = 0
		,	@P_IMPORTE DECIMAL(16,4)

	select @PVERDE=pVERDE, @P_TAN=P_TAN, @P_IMPORTE=P_IMPORTE from '+@GESTION+'.dbo.articulo where CODIGO=@ARTICULO

	if	@PVERDE=1 and @P_TAN=2 BEGIN
		if @peso>0 set @CosteResiduo = @peso * @P_IMPORTE
		else set @CosteResiduo = @UNIDADES * @P_IMPORTE
	END


	--------------------------------------------------------------------------------------------------------------
	--	Insertar Registro	

	INSERT INTO '+@GESTION+'.[DBO].d_pedive (usuario, empresa, numero,  linia, articulo, definicion, unidades, precio, dto1, dto2
				, importe, tipo_iva, coste, cliente, precioiva, importeiva, cajas, familia, preciodiv, importediv, peso, letra
				, impdiviva, prediviva, RECARG, PVERDE)
	VALUES (@UserName,@Emp,@NUMERO,@linia,@ARTICULO,@DESCRIP,@UNIDADES, @PRECIO, @DTO1,@DTO2,@IMPORTE
				,@TIPO_IVA,@coste,@CLIENTE,@precio_iva,@importeiva,@cajas,@familia,@PRECIO,@IMPORTE,@peso,@letra
				, 0, 0, @recargo, @CosteResiduo)
	--------------------------------------------------------------------------------------------------------------

	-- camposAD
	IF OBJECT_ID('''+@CAMPOS+'.dbo.D_PEDIVEEW'') IS NOT NULL BEGIN
		if not exists (select * from '+@CAMPOS+'.dbo.d_pediveew 
						where ejercicio=@EJER and empresa=@Emp and numero=@NUMERO and letra=@LETRA and linia=@linia)
		BEGIN
			insert into '+@CAMPOS+'.dbo.d_pediveew (ejercicio, empresa, numero, letra, linia)
			values (@EJER, @Emp, @NUMERO, @LETRA, @linia)
		END
	END
	
	RETURN -1  
END TRY

BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)

	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pPedido_Nuevo_Linea_I'




--	Procedimiento pPedidoLineas
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedidoLineas' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	17/05/2019
--	Description:	Obtener Lineas del Pedido
-- ===========================================================

-- exec pPedidoLineas @modo=''lista'',@IDPEDIDO=''201901000000190300''

'+@AlterCreate+'  PROCEDURE [dbo].[pPedidoLineas] @modo varchar(50),  @IDPEDIDO	varchar(8000)
AS
BEGIN TRY	
	if @modo=''lista'' BEGIN
		DECLARE   @IDPEDIDOLIN	varchar(52)
				, @empresa			char(2)
				, @numero			varchar(20)
				, @articulo			char(15)
				, @definicion		char(75)
				, @unidades			numeric(15,6)
				, @precio			numeric(15,6)
				, @dto1				numeric(20,2)
				, @dto2				numeric(20,2)
				, @importe			numeric(15,6)
				, @tipo_iva			char(2)
				, @servidas			numeric(15,6)
				, @linia			int
				, @cliente			char(8)
				, @importeiva		numeric(15,6)
				, @unicaja			int
				, @unipeso			varchar(50)
				, @cajas			numeric(10,2)
				, @peso				numeric(20,4)
				, @contador			int = 0
				, @respuesta		varchar(max) = N''{"lineas":[''

		declare @articuloLEN int = (Select CHARACTER_MAXIMUM_LENGTH from '+@GESTION+'.[INFORMATION_SCHEMA].[COLUMNS]
								WHERE  TABLE_NAME=''articulo'' and COLUMN_NAME=''NOMBRE'')

		set @numero = (select NUMERO from vPedidos where IDPEDIDO=@IDPEDIDO)

		DECLARE CURART CURSOR FOR 
			(select IDPEDIDO, IDPEDIDOLIN, empresa, numero, articulo, definicion, unidades
					, precio, dto1, dto2, importe, tipo_iva, servidas, linia, cliente
					, importeiva, cajas, servidas, peso, unicaja, unipeso
			from vPedidos_Detalle where IDPEDIDO=@IDPEDIDO)
		OPEN CURART
			FETCH NEXT FROM CURART INTO @IDPEDIDO, @IDPEDIDOLIN, @empresa, @numero, @articulo, @definicion, @unidades
										, @precio, @dto1, @dto2, @importe, @tipo_iva, @servidas, @linia, @cliente
										, @importeiva, @cajas, @servidas, @peso, @unicaja, @unipeso
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @respuesta = @respuesta + ''{"IDPEDIDO":"''	+@IDPEDIDO+''"''
								+'',"IDPEDIDOLIN":"''				+@IDPEDIDOLIN+''"''
								+'',"empresa":"''					+@empresa+''"''
								+'',"numero":"''					+@numero+''"''
								+'',"articulo":"''				+@articulo+''"''
								+'',"definicion":"''				+@definicion+''"''
								+'',"unidades":"''				+cast(@unidades as varchar)+''"''
								+'',"precio":"''					+cast(@precio as varchar)+''"''
								+'',"dto1":"''					+cast(@dto1 as varchar)+''"''
								+'',"dto2":"''					+cast(@dto2 as varchar)+''"''
								+'',"importe":"''					+cast(@importe as varchar)+''"''
								+'',"tipo_iva":"''				+@tipo_iva+''"''
								+'',"servidas":"''				+cast(@servidas as varchar)+''"''
								+'',"linia":"''					+cast(@linia as varchar)+''"''
								+'',"cliente":"''					+@cliente+''"''
								+'',"importeiva":"''				+cast(isnull(@importeiva,0) as varchar)+''"''
								+'',"cajas":"''					+cast(isnull(@cajas,0) as varchar)+''"''
								+'',"servidas":"''				+cast(@servidas as varchar)+''"''
								+'',"peso":"''					+cast(@peso as varchar)+''"''
								+'',"unicaja":"''					+cast(@unicaja as varchar)+''"''
								+'',"unipeso":"''					+cast(@unipeso as varchar)+''"''
								+'',"articuloMaxLen":"''	+cast(isnull(@articuloLEN,0) as varchar)+''"''
								+''},''
				FETCH NEXT FROM CURART INTO @IDPEDIDO, @IDPEDIDOLIN, @empresa, @numero, @articulo, @definicion, @unidades
										, @precio, @dto1, @dto2, @importe, @tipo_iva, @servidas, @linia, @cliente
										, @importeiva, @cajas, @servidas, @peso, @unicaja, @unipeso
			END	
		CLOSE CURART deallocate CURART

		if (select count(IDPEDIDO) from vPedidos_Detalle where IDPEDIDO=@IDPEDIDO) > 0		
			set @respuesta = SUBSTRING( @respuesta,0,LEN(@respuesta) ) + '']}'';
		else set @respuesta = ''SIN_RESULTADOS''
	END

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pPedidoLineas'




--	Procedimiento pPedidoTotal
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedidoTotal' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Lineas del Pedido
-- ===========================================================

-- --EXEC [pPedidoTotal] ''totales'' , ''201901      190308''

'+@AlterCreate+'  PROCEDURE [dbo].[pPedidoTotal]		@modo varchar(50),  @IDPEDIDO	varchar(8000)
AS
BEGIN TRY
	DECLARE   @sentencia varchar(max)
	
	set @sentencia = ''select  IMPORTE, 
							  case when IMPORTE>0 then 
								replace(replace(replace(convert(varchar,cast(IMPORTE as money),1),''''.'''',''''_''''),'''','''',''''.''''),''''_'''','''','''')+'''' €'''' 
								else '''''''' end as BaseImpf
							, IVApc
							, IVAimp
							, case when IVAimp>0 then 
								replace(replace(replace(convert(varchar,cast(IVAimp as money),1),''''.'''',''''_''''),'''','''',''''.''''),''''_'''','''','''')+'''' €'''' 
								else '''''''' end as IVAimpf
							, recargoPC
							, RECARGO
							, case when RECARGO>0 then 
								replace(replace(replace(convert(varchar,cast(RECARGO as money),1),''''.'''',''''_''''),'''','''',''''.''''),''''_'''','''','''')+'''' €'''' 
								else '''''''' end as recargoIMPf
							, TOTALDOC
							, case when TOTALDOC>0 then 
								replace(replace(replace(convert(varchar,cast(TOTALDOC as money),1),''''.'''',''''_''''),'''','''',''''.''''),''''_'''','''','''')+'''' €'''' 
								else '''''''' end as TOTALDOCf
							, PVERDEver  
						from vPedidos_Pie WHERE IDPEDIDO=''''''+@IDPEDIDO+''''''''
	
	exec (''select isnull((''+@sentencia+'' for JSON PATH,ROOT(''''totales'''')),''''{"totales":[]}'''') AS JAVASCRIPT'');

	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pPedidoTotal'




--	Procedimiento pMarcas
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pMarcas' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia ='
'+@AlterCreate+'  PROCEDURE [dbo].[pMarcas] @modo char(50)=''''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @respuesta VARCHAR(max) = ''''

	DECLARE CRSR CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
	(select CODIGO, NOMBRE from vMarcas)
	OPEN CRSR
		FETCH NEXT FROM CRSR INTO @codigo, @nombre
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + ''{"codigo":"''+isnull(@codigo,'''')+''","nombre":"''+isnull(@nombre,'''')+''"}''
			FETCH NEXT FROM CRSR INTO @codigo, @nombre
		END	
	CLOSE CRSR deallocate CRSR	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT ''{"marcas":['' + replace(@respuesta,''}{'',''},{'') +'']}'' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pMarcas'




--	Procedimiento pSubFamilias
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pSubFamilias' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia ='
'+@AlterCreate+'  PROCEDURE [dbo].[pSubFamilias] @familia char(50)=''''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @respuesta VARCHAR(max) = ''''

	DECLARE CRSR CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
	(select CODIGO, NOMBRE from vSubFamilias where familia=@familia)
	OPEN CRSR
		FETCH NEXT FROM CRSR INTO @codigo, @nombre
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + ''{"codigo":"''+isnull(@codigo,'''')+''","nombre":"''+isnull(@nombre,'''')+''"}''
			FETCH NEXT FROM CRSR INTO @codigo, @nombre
		END	
	CLOSE CRSR deallocate CRSR	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT ''{"subfamilias":['' + replace(@respuesta,''}{'',''},{'') +'']}'' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pIVAtipos'




--	Procedimiento pArticulosBasic
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pArticulosBasic' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia ='
'+@AlterCreate+'  PROCEDURE [dbo].[pArticulosBasic]   @usuario varchar(50)=''''
										, @rol varchar(50)=''''
										, @paginador int=0
										, @buscar varchar(100)=''''
AS
BEGIN TRY
	declare @codigo varchar(20), @nombre varchar(100), @respuesta varchar(max) = ''''
			, @elDeclare varchar(8000) = ''''
			, @elWhere varchar(1000) = '''' 

	if @buscar<>'''' BEGIN set @elWhere = '' WHERE CODIGO like ''''%''+@buscar+''%'''' or NOMBRE like ''''%''+@buscar+''%'''' '' END

	set @elDeclare = ''
		declare @codigo varchar(20), @nombre varchar(100), @respuesta varchar(max) = ''''''''
		declare elCursor CURSOR for
		Select  CODIGO, replace(NOMBRE,''''"'''','''''''') as NOMBRE
		from vArticulos '' + @elWhere + '' 		
		ORDER BY  NOMBRE  ASC  OFFSET ''+cast(@paginador as varchar(10))+'' ROWS 
		FETCH NEXT ''+cast(@paginador+50 as varchar(10))+'' ROWS ONLY		
		OPEN elCursor
		FETCH NEXT FROM elCursor INTO @codigo, @nombre
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + ''''{"codigo":"''''+@codigo+''''","nombre":"''''+@nombre+''''"}''''
		FETCH NEXT FROM elCursor INTO @codigo, @nombre END CLOSE elCursor deallocate elCursor
	
		select ''''{"articulos":[''''+isnull(replace(@respuesta,''''}{'''',''''},{''''),'''''''')+'''']}'''' AS JAVASCRIPT
		''
	--print @elDeclare return -1 
	exec (@elDeclare)
	

	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC (@Sentencia) 
select  'pArticulosBasic'




--Procedimiento pUltimosPedidosArticulos
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pUltimosPedidosArticulos' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pUltimosPedidosArticulos] @cliente varchar(50)
AS
BEGIN TRY		
	declare @meses int = (select MesesConsumo from Configuracion_SQL)
	declare @f smalldatetime = dateadd(month,-@meses,getdate())
	declare @fecha varchar(10) = convert(varchar(10),@f,103)
	
	select (
		select dpv.ARTICULO
		, art.NOMBRE
		, MAX(cpv.FECHA) as FECHA
		, MAX(cpv.NUMERO) as NUMERO
		, SUM(dpv.IMPORTE) as IMPORTE
		from '+@GESTION+'.dbo.d_pedive dpv
		inner join '+@GESTION+'.dbo.c_pedive cpv on concat(cpv.EMPRESA,cpv.NUMERO,cpv.LETRA)=concat(dpv.EMPRESA,dpv.NUMERO,dpv.LETRA)
		left  join vArticulos art on art.CODIGO collate Modern_Spanish_CI_AI=dpv.ARTICULO		
		where dpv.Cliente=@cliente and cpv.FECHA>=@fecha
		group by  dpv.ARTICULO, art.NOMBRE
		order by FECHA DESC, dpv.ARTICULO desc		
		for JSON AUTO
	) as JAVASCRIPT
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC(@Sentencia)
select  'pUltimosPedidosArticulos'




--Procedimiento pContactos
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pContactos' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pContactos] @elJS nvarchar(max)=''''
AS
BEGIN TRY
	declare   @modo varchar(50) = (select JSON_VALUE(@elJS,''$.modo''))

	if @modo=''guardar'' BEGIN
		declare @cliente varchar(20)	=  (select JSON_VALUE(@elJS,''$.cliente''))
		declare @persona varchar(100)	=  (select JSON_VALUE(@elJS,''$.persona''))
		declare @cargo varchar(50)		=  (select JSON_VALUE(@elJS,''$.cargo''))
		declare @email varchar(100)		=  (select JSON_VALUE(@elJS,''$.email''))
		declare @telefono varchar(20)	=  (select JSON_VALUE(@elJS,''$.telefono''))
		declare @linea int = (select isnull(MAX(LINEA)+1,0) from '+@GESTION+'.dbo.cont_cli where CLIENTE=@cliente)

		insert into '+@GESTION+'.dbo.cont_cli (CLIENTE, PERSONA, CARGO, EMAIL, LINEA, ORDEN, VISTA, TELEFONO)
		values (@cliente, @persona, @cargo, @email, @linea, 0, 1, @telefono)
	END

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC(@Sentencia)
select  'pContactos'




--Procedimiento pPedido_ActualizarCabecera
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedido_ActualizarCabecera' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pPedido_ActualizarCabecera] @IDPEDIDO varchar(50)
AS
BEGIN	
    DECLARE @totalped as numeric(15,6)
	DECLARE @totaldoc numeric(15, 6)
	DECLARE @peso numeric(15, 6)

	declare @ejercicio char(4) = LEFT(@IDPEDIDO,4)
	declare @letra char(2) = (select LETRA from Configuracion_SQL)
	
	SET @totalped	= isnull((SELECT sum(cast(IMPORTE as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
	SET @peso		= isnull((SELECT sum(cast(peso as numeric(15,6)))    FROM vPedidos_Detalle where IDPEDIDO=@IDPEDIDO),0)

	SET @totaldoc	= isnull((SELECT sum(cast(IMPORTE as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
					+ isnull((SELECT sum(cast(RECARGO as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
					+ isnull((SELECT sum(cast(impPP as numeric(15,6)))   FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
	
	declare @sql varchar(max) = concat(''
		UPDATE ['',@ejercicio,'''',@letra,''].[DBO].c_pedive 
				SET TOTALPED='''''',@totalped,'''''',
					IMPDIVISA='''''',@totalped,'''''',
					TOTALDOC='''''',@totaldoc,'''''', 
					PESO='''''',@peso,''''''
		WHERE CONCAT('''''',@ejercicio,'''''',EMPRESA,replace(LETRA,space(1),''''0''''),replace(LEFT(NUMERO,10),space(1),''''0''''))  
				collate Modern_Spanish_CI_AI='''''',@IDPEDIDO,'''''' '')

	exec(@sql)

END
'
--EXEC(@Sentencia)
select  'pPedido_ActualizarCabecera'




--Procedimiento pArticulosCliente
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pArticulosCliente' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pArticulosCliente]  ( @parametros varchar(max) )
AS
BEGIN TRY
	
	declare   @MesesConsumo int 
			, @desde smalldatetime
			, @cliente varchar(20) = (select JSON_VALUE(@parametros,''$.cliente''))
			, @artCli varchar(max)
			, @modo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.modo'')),'''')
			, @articulo varchar(50) = (select JSON_VALUE(@parametros,''$.articulo''))
			, @IdTeleVenta varchar(50) = (select JSON_VALUE(@parametros,''$.IdTeleVenta''))
			, @fechaTV varchar(10) = (select JSON_VALUE(@parametros,''$.fechaTV''))
			, @nombreTV varchar(100) = (select JSON_VALUE(@parametros,''$.nombreTV''))
			, @usuario varchar(20) = (select JSON_VALUE(@parametros,''$.paramStd[0].currentReference''))
			, @registro varchar(50) = ''''
			, @marcas varchar(max) = ''''
			, @familias varchar(max) = ''''
			, @subfams varchar(max) = ''''
			, @consulta varchar(max) = ''''
			
	declare   @gestion char(6) = (select GESTION from Configuracion_SQL)
			, @letra char(2) = (select LETRA from Configuracion_SQL)
			, @gestionAnt char(6)
			, @ejercicio char(4) = (select EJERCICIO from Configuracion_SQL)
			, @ejercicioAnt char(4)
			
			set @ejercicioAnt = isnull(cast(@ejercicio as int)-1,'''')
			set @gestionAnt = isnull(concat(@ejercicioAnt,@letra), '''')

	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo=''Marca'') BEGIN
		DECLARE elCursor CURSOR FOR
			select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = @marcas + '' or ART.MARCA=''''''+@registro+'''''' ''
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@marcas)>0 set @marcas = '' AND ('' + SUBSTRING(@marcas,4,LEN(@marcas))+ '')''
	END
' set @Sentencia = @Sentencia + '
	set @registro = ''''
	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo=''Familia'') BEGIN
		DECLARE elCursor CURSOR FOR
			select familia from familia_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @familias = @familias + '' or ART.FAMILIA=''''''+@registro+'''''' ''
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@familias)>0 set @familias = '' AND ('' + SUBSTRING(@familias,4,LEN(@familias))+ '')''
	END

	set @registro = ''''
	if exists (select valor from TeleVentaFiltros where id=@IdTeleVenta and tipo=''Subfamilia'') BEGIN
		DECLARE elCursor CURSOR FOR
			select subfamilia from subfam_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @subfams = @subfams + '' or ART.SUBFAMILIA=''''''+@registro+'''''' ''
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@subfams)>0 set @subfams = '' AND ('' + SUBSTRING(@subfams,4,LEN(@subfams))+ '')''
	END

	set @MesesConsumo = (select top 1 MesesConsumo from Configuracion_SQL)
	set @desde = replace(convert(varchar(10),dateadd(month, - @MesesConsumo,getdate()),103),''/'',''-'')
	
' set @Sentencia = @Sentencia + '

	-- -------------------------------------------------------------------
	--      Últimas ventas del artículo (al pasar sobre el artículo)
	-- -------------------------------------------------------------------
	/*
	pArticulosCliente
	''{"modo":"UltimasVentasArticulo","registros":0,"buscar":"","cliente":"4300200043","IdTeleVenta":"20210625094058393"
	,"fechaTV":"30-06-2021","nombreTV":"30-06/2021","paramStd":[{"currentRole":"Admins","currentReference":"909"}]}''
	*/
	if @modo=''UltimasVentasArticulo'' BEGIN
		set @consulta = ''
		WITH VENTAS (FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE)
		AS
		(
			SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, DAV.DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, dav.precio, dav.dto1, dav.importe FROM '+@GESTION+'.DBO.C_ALBVEN CAV 
			INNER JOIN [''+@gestion+''].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
			INNER JOIN [''+@gestion+''].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
			INNER JOIN [''+@gestion+''].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO
			INNER JOIN Configuracion_SQL CON ON 1=1
			WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
			AND DAV.ARTICULO=''''''+@articulo+'''''' 
			AND CLI.CODIGO=''''''+@cliente+'''''' ''+@marcas+'' '' +@familias+ '' '' +@subfams+ ''

			UNION ALL

			SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, DAV.DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, dav.precio
			, dav.dto1, dav.importe 
			FROM [''+@gestionAnt+''].DBO.C_ALBVEN CAV 
			INNER JOIN [''+@gestionAnt+''].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
			INNER JOIN [''+@gestion+''].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
			INNER JOIN [''+@gestion+''].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO
			INNER JOIN Configuracion_SQL CON ON 1=1
			WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
			AND DAV.ARTICULO=''''''+@articulo+'''''' 
			AND CLI.CODIGO=''''''+@cliente+'''''' ''+@marcas+'' '' +@familias+ '' '' +@subfams+ ''
		)
' set @Sentencia = @Sentencia + '

		SELECT ISNULL(
			(
			SELECT top 10 convert(varchar(10),FECHA,105) as FECHA
			, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE
			FROM VENTAS  
			group by FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, PRECIO, DTO1, IMPORTE 
			ORDER BY cast(FECHA as smalldatetime) DESC
			for JSON AUTO, INCLUDE_NULL_VALUES
			)
		,''''[]'''') AS JAVASCRIPT
		''
		exec(@consulta)
		return -1
	END


' set @Sentencia = @Sentencia + '

	-- -------------------------------------------------------------------
	-- Última venta del Cliente (Listado general al hacer clic en PEDIDO)
	-- -------------------------------------------------------------------
	/*
	pArticulosCliente
	''{"registros":0,"buscar":"","cliente":"4300200043","IdTeleVenta":"20210625094058393","fechaTV":"30-06-2021"
	,"nombreTV":"30-06/2021","paramStd":[{"currentRole":"Admins","currentReference":"909"}]}''
	*/
	set @consulta = ''
	WITH VENTAS (FECHA, CLIENTE, ARTICULO, DEFINICION, CAJAS, UDS, PESO, /*PVP,*/ UNICAJA, PesoArticulo)
	AS
	(
		SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, DAV.DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO,/*PVP.PVP
		,*/ ART.UNICAJA, ART.PESO as PesoArticulo
		FROM [''+@gestion+''].DBO.C_ALBVEN CAV 
		INNER JOIN [''+@gestion+''].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
		INNER JOIN [''+@gestion+''].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
		INNER JOIN [''+@gestion+''].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO
		INNER JOIN [Configuracion_SQL] CON ON 1=1
		/*INNER JOIN [''+@gestion+''].DBO.PVP PVP ON PVP.ARTICULO=DAV.ARTICULO */
		WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
		AND CLI.CODIGO=''''''+@cliente+'''''' ''+@marcas+'' '' +@familias+ '' '' +@subfams+ ''

		UNION ALL

		SELECT CAV.FECHA, CAV.CLIENTE, DAV.ARTICULO, DAV.DEFINICION, DAV.CAJAS, DAV.UNIDADES, DAV.PESO, /*PVP.PVP 
		,*/ ART.UNICAJA, ART.PESO as PesoArticulo
		FROM [''+@gestionAnt+''].DBO.C_ALBVEN CAV 
		INNER JOIN [''+@gestionAnt+''].DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
		INNER JOIN [''+@gestionAnt+''].DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE
		INNER JOIN [''+@gestionAnt+''].DBO.ARTICULO ART ON ART.CODIGO=DAV.ARTICULO
		INNER JOIN [Configuracion_SQL] CON ON 1=1
		/*INNER JOIN [''+@gestionAnt+''].DBO.PVP PVP ON PVP.ARTICULO=DAV.ARTICULO */
		WHERE CLI.FECHA_BAJ IS NULL AND ART.BAJA=0 AND CAV.FECHA>=GETDATE()-(30*CON.MesesConsumo) AND CAV.TRASPASADO=0
		AND CLI.CODIGO=''''''+@cliente+'''''' ''+@marcas+'' '' +@familias+ '' '' +@subfams+ ''
	)

	select isnull(
	( 
		SELECT V1.CLIENTE, V1.ARTICULO as CODIGO, replace(V1.DEFINICION,''''"'''',''''-'''') as NOMBRE
		, V1.CAJAS, V1.UDS, V1.PESO, /*V1.PVP,*/ V1.UNICAJA, V1.PesoArticulo
		, SUM(STC.StockVirtual) AS StockVirtual
		FROM VENTAS V1 
		INNER JOIN 
		(SELECT MAX(FECHA) AS FECHA, CLIENTE, ARTICULO FROM VENTAS GROUP BY CLIENTE, ARTICULO ) V2 
		ON V2.FECHA=V1.FECHA AND V2.CLIENTE=V1.CLIENTE AND V2.ARTICULO=V1.ARTICULO
		LEFT JOIN vStock STC ON STC.ARTICULO=V1.ARTICULO 
		GROUP BY  V1.FECHA, V1.CLIENTE, V1.ARTICULO, V1.DEFINICION, V1.CAJAS, V1.UDS, V1.PESO, /*V1.PVP,*/ V1.UNICAJA, V1.PesoArticulo
		ORDER BY V1.CLIENTE, V1.ARTICULO
		FOR JSON AUTO, INCLUDE_NULL_VALUES
	),''''[]'''')  as JAVASCRIPT 	
	''
	-- print @consulta  return -1
	exec(@consulta)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH

'
--EXEC(@Sentencia)
select  'pArticulosCliente'




--Procedimiento pOfertas
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pOfertas' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pOfertas] (@parametros varchar(max))
AS
BEGIN TRY
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.modo'')),'''')
	declare @cliente varchar(50) = isnull((select JSON_VALUE(@parametros,''$.cliente'')),'''')
	declare @articulo varchar(20) = (select JSON_VALUE(@parametros,''$.articulo''))
	declare @fecha    smalldatetime = cast((select JSON_VALUE(@parametros,''$.fecha'')) as smalldatetime)

	if @modo=''ofertasDelCliente'' BEGIN
		select isnull((
			SELECT * FROM 
				(
				SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
				, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
				, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
				, OFE.DESDE AS UNI_INI
				, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
				,  OFE.MONEDA, OFE.TARIFA 
				FROM '+@GESTION+'.DBO.CLIENTES CLI 
				INNER JOIN '+@GESTION+'.DBO.OFERTAS OFE ON 1=1 
				INNER JOIN '+@GESTION+'.dbo.articulo art on OFE.ARTICULO=art.CODIGO
				WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=@cliente
				UNION ALL
				SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
				, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
				, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
				, OFE.DESDE AS UNI_INI
				, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
				,  OFE.MONEDA, OFE.TARIFA 
				FROM '+@GESTION+'.DBO.CLIENTES CLI 
				INNER JOIN '+@GESTION+'.DBO.OFERTAS OFE ON OFE.TARIFA=CLI.TARIFA 
				INNER JOIN '+@GESTION+'.dbo.articulo art on OFE.ARTICULO=art.CODIGO
				WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=@cliente
				) A
			for JSON AUTO, INCLUDE_NULL_VALUES
		),''[]'') as JAVASCRIPT
		return -1
	END

	select isnull((
			select PVP, DTO1 from vOfertas		--	select * from vOfertas
			where ARTICULO=@articulo and FECHA_IN<=cast(@fecha as smalldatetime) and FECHA_FIN>=cast(@fecha as smalldatetime)
				  and (CLIENTE=@cliente or TARIFA='''')
			for JSON AUTO, INCLUDE_NULL_VALUES
	),''[]'') as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC(@Sentencia)
select  'pOfertas'




--Procedimiento pArticulos
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pArticulos' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + ' PROCEDURE [dbo].[pArticulos]	@parametros varchar(max)
AS
BEGIN TRY	
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.modo'')),'''')
		,	@articulo varchar(50) = isnull((select JSON_VALUE(@parametros,''$.articulo'')),'''')
		,	@desde varchar(5) = isnull((select JSON_VALUE(@parametros,''$.desde'')),''0'')

	declare @sentencia varchar(max) = ''''
	declare @respuesta varchar(max) = ''''

	if @modo=''buscar'' BEGIN
		set @sentencia = CONCAT(''
			select (
				select (select count(CODIGO) from vArticulos where CODIGO like ''''%'',@articulo,''%'''' 
																or NOMBRE like ''''%'',@articulo,''%'''' ) as registros
				, * 
				from vArticulos 
				where CODIGO like ''''%'',@articulo,''%'''' or NOMBRE like ''''%'',@articulo,''%'''' 
				ORDER BY  NOMBRE  ASC 
				OFFSET '',@desde,'' ROWS FETCH NEXT 100 ROWS ONLY  FOR JSON AUTO
			) as JAVASCRIPT
		'')
		exec(@sentencia)
	END

	if @modo=''residuo'' BEGIN
		set @respuesta = (select codigo, PVERDE, P_TAN, P_IMPORTE
							from '+@GESTION+'.dbo.articulo  
							where CODIGO=@articulo
							for JSON AUTO, INCLUDE_NULL_VALUES)
		
		select isnull(@respuesta,''[]'') as JAVASCRIPT
	END

	if @modo=''bebidasAzucaradas'' BEGIN
		set @respuesta = (select ltrim(rtrim(esc.COMPONENTE)) as COMPONENTE, esc.PVP, esc.UNIDADES 
							,art.codigo, art.PVERDE, art.P_TAN, art.P_IMPORTE
							from '+@GESTION+'.dbo.articulo art 
							left join '+@GESTION+'.dbo.escandal esc on art.CODIGO=esc.ARTICULO
							where art.CODIGO=@articulo and art.DESGLOSE<>0
							for JSON AUTO, INCLUDE_NULL_VALUES)
		
		select isnull(@respuesta,''[]'') as JAVASCRIPT
	END
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
'
--EXEC(@Sentencia)
select  'pArticulos'



	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH