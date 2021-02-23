
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
	declare @AlterCreate varchar(50) = 'CREATE '
-- ====================================================================================================================================



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
exec (@Sentencia) 
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
			, @UserLogin  varchar(50)
			, @UserID	  varchar(50)=''''
			, @UserName	  varchar(50)=''''
			, @currentReference varchar(50)=''''
			
			, @EJER VARCHAR(4)
			, @EMPRESA CHAR(2) = ''01''
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

	SET @UserLogin			= @ContextVars.value(''(/Row/Property[@Name=''''currentUserLogin'''']/@Value)[1]''	, ''varchar(50)'')
	SET @UserID				= @ContextVars.value(''(/Row/Property[@Name=''''currentUserId'''']/@Value)[1]''		, ''varchar(50)'')
	SET @UserName			= @ContextVars.value(''(/Row/Property[@Name=''''currentUserFullName'''']/@Value)[1]''	, ''varchar(50)'')
	SET @currentReference	= @ContextVars.value(''(/Row/Property[@Name=''''currentReference'''']/@Value)[1]''	, ''varchar(50)'')
	
	set @ENV_CLI = @CONTACTO
	if @ENV_CLI is null or @ENV_CLI='''' 
	set @ENV_CLI = isnull((select ISNULL(LINEA,0) from vContactos where CLIENTE=@CLIENTE and LINEA=0),0)

	-- en USO
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
	set @clave = concat(@clave_ejercicio_empresa,@clave_numero,@SERIE)

' set  @Sentencia = @Sentencia + '

	--Creamos las variables de trabajo
	DECLARE @nombreUsuario CHAR(25), @codigo varchar(20), @estado_aux BIT, @aux INT,
			 @letra CHAR(2), @moneda VARCHAR(3), @fpag VARCHAR(2), @ruta CHAR(2)
			 set @letra=@SERIE
	--Inicializamos las variables donde haremos las inserciones
	SET @EJER = (select [any] from '+@COMUN+'.[DBO].ejercici where predet=1)

	IF @ENTREGA IS NULL or @ENTREGA='''' set @ENTREGA=@FECHAmas1	

	IF @MODO=''editar'' BEGIN	
		begin try insert into '+@COMUN+'.dbo.en_uso (Tipo, Clave, Usuario, Terminal) values (@tipo, @clave, @UserLogin, ''WEB'') end try
		begin catch end catch
		declare @dvObservacio varchar(1000) = (select OBSERVACIO from '+@GESTION+'.dbo.c_pedive 
							 where CONCAT(@EJER,empresa,replace(LETRA,space(1),''0''),replace(LEFT(NUMERO,10),space(1),''0''))=@IDPEDIDO) 
		declare @dvVendedor varchar(10) = (select VENDEDOR from vPedidos where IDPEDIDO=@IDPEDIDO)
		select ''{"observacio":"''+@dvObservacio+''","vendedor":"''+@dvVendedor+''"}'' as JAVASCRIPT
		return -1 
	END

	IF @MODO=''verificarEnUso'' BEGIN		
		if exists (select USUARIO, TERMINAL from '+@COMUN+'.dbo.en_uso where TIPO=''PEDIVEN'' and CLAVE=@clave and USUARIO<>@UserLogin) BEGIN
			select 
				''EnUso;''+ (select USUARIO  from '+@COMUN+'.dbo.en_uso where TIPO=''PEDIVEN'' and CLAVE=@clave and USUARIO<>@UserLogin) +'';''
						+ (select TERMINAL from '+@COMUN+'.dbo.en_uso where TIPO=''PEDIVEN'' and CLAVE=@clave and USUARIO<>@UserLogin)
			as JAVASCRIPT 
		END
		else BEGIN select ''Liberado'' as JAVASCRIPT END
		return -1
	END

	IF @MODO=''desbloquear'' BEGIN		
		if exists (select USUARIO, TERMINAL from '+@COMUN+'.dbo.en_uso where TIPO=''PEDIVEN'' and CLAVE=@clave and USUARIO<>@UserLogin) BEGIN
			delete '+@COMUN+'.dbo.en_uso where Tipo=@tipo and Clave=@clave
			select ''desbloqueado'' as JAVASCRIPT 
		END
		else BEGIN select ''NoExiste'' as JAVASCRIPT END
		return -1
	END
' set  @Sentencia = @Sentencia + '

	IF @MODO=''actualizar'' BEGIN
		update '+@GESTION+'.dbo.c_pedive set ENV_CLI=@ENV_CLI, ENTREGA=@ENTREGA, OBSERVACIO=coalesce(@OBSERVACIO,'''')
		where CONCAT(@EJER,empresa,replace(LETRA,space(1),''0''),replace(LEFT(NUMERO,10),space(1),''0''))=@IDPEDIDO
		select @IDPEDIDO as JAVASCRIPT
		return -1
	END



	IF @MODO=''eliminar'' BEGIN
		delete from '+@GESTION+'.dbo.c_pedive where replace(@EJER + EMPRESA + LETRA + NUMERO,'' '',''0'')=@IDPEDIDO
		delete from '+@GESTION+'.dbo.d_pedive where replace(@EJER + EMPRESA + LETRA + NUMERO,'' '',''0'')=@IDPEDIDO
		if exists (select * from sys.databases where [name] = '''+@CAMPOS+''') BEGIN
			delete from '+@CAMPOS+'.dbo.c_presuvew where @EJER + EMPRESA + LETRA + NUMERO=@IDPEDIDO
		END
		delete '+@COMUN+'.dbo.en_uso where Tipo=@tipo and Clave=@clave
		select @IDPEDIDO as JAVASCRIPT
		return -1
	END


	IF @MODO=''finalizar'' BEGIN		
		delete '+@COMUN+'.dbo.en_uso where Tipo=@tipo and Clave=@clave
		return -1	
	END
		
	-- GENERAR PEDIDO
	SET @fpag	= (SELECT fpag FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE)
	SET @PRONTO = (SELECT PRONTO FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE)
	SET @ruta	= isnull((SELECT ruta FROM '+@GESTION+'.[dbo].clientes WHERE codigo=@CLIENTE),'''')
	SET @nVENDEDOR = (SELECT nombre FROM vVendedores WHERE codigo=(select isnull(VENDEDOR,''01'') from vClientes where CODIGO=@CLIENTE))
		
	SET @nombreUsuario = ''FLEXYGO##V_''+@UserLogin
	
	IF @OBSERVACIO IS NULL or @OBSERVACIO='''' SET @OBSERVACIO = (SELECT OBSERVACIO from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)
	IF @OBSERVACIO IS NULL SET @OBSERVACIO = ''''

	SET @SentenciaSQL = ''SELECT fpag, pronto, ruta INTO ##CLIENTE FROM '+@GESTION+'.[dbo].clientes WHERE codigo = ''+@CLIENTE
	EXEC(@SentenciaSQL)
	SET @fpag   = (SELECT fpag FROM ##CLIENTE)
	SET @PRONTO = (SELECT pronto FROM ##CLIENTE)
	SET @ruta   = (SELECT ruta FROM ##CLIENTE)
	DROP TABLE ##CLIENTE	
' set  @Sentencia = @Sentencia + '

	SET @almacen = (SELECT almacen FROM '+@GESTION+'.dbo.empresa WHERE codigo = @EMPRESA)

	SET @estado_aux = (SELECT estado FROM '+@COMUN+'.dbo.OPCEMP WHERE tipo_opc = 9003 AND empresa=@EMPRESA)

	-- Obtener número según los contadores de Eurowin
	IF (@estado_aux = 1) BEGIN
		SET @aux = (SELECT contador FROM '+@GESTION+'.[dbo].series WHERE tipodoc = 2 AND empresa=@EMPRESA AND serie=@letra)
		SET @codigo = REPLICATE('' '', (10 - LEN(@aux)))+CAST((@aux + 1) AS CHAR(10))
		UPDATE '+@GESTION+'.[dbo].series SET contador = contador+1 WHERE tipodoc = 2 AND empresa=@EMPRESA AND serie=@letra
	END
	ELSE BEGIN
		SET @aux = (SELECT pediven FROM '+@GESTION+'.[dbo].empresa WHERE codigo=@EMPRESA)
		SET @codigo = REPLICATE('' '', (10 - LEN(@aux)))+CAST((@aux + 1) AS CHAR(10))
		UPDATE '+@GESTION+'.[dbo].empresa SET pediven = pediven + 1 WHERE codigo=@EMPRESA 
	END
	
	IF @REFERCLI IS NULL BEGIN set  @REFERCLI = '''' END
	IF @PRONTO   IS NULL BEGIN set  @PRONTO   = 0  END

	declare @divisa char(3) = isnull((select isnull(MONEDA,'''') from '+@COMUN+'.dbo.paises where CODIGO=
								(select PAIS from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)),0)

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
		
	-- ==================================================================================================================================
	--	Guardamos el contacto en Pedidos_contactos
		insert into Pedidos_Contactos (IDPEDIDO, Cliente, Contacto)
		values (@IDPEDIDO, @CLIENTE, @CONTACTO)

	--	Incidencia Cliente-Pedido
		if @INCICLI is not null and @INCICLI<>''''
		insert into [inci_CliPed] ([empresa],[fecha],[hora],[nombreTV],[idpedido],[cliente],[incidencia]
									,[descripcion],[observaciones])
		values (@empresa,@FechaTV
				, cast(datepart(HOUR,getdate()) as char(2))+'':''+cast(datepart(MINUTE,getdate()) as char(2))
				, @nombreTV, @idpedido, @cliente, @INCICLI, @INCICLIDescrip, @OBSERVACIO)

	-- ==================================================================================================================================
	-- Insertamos las lineas del pedido	

		set @LINEAS = ''{"datos":[''+replace(replace(@LINEAS,''_openLL_'',''{''),''_closeLL_'',''}'')+'']}''
' set  @Sentencia = @Sentencia + '

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
			declare @jsCajas numeric(15,6) = case when  (select isnull(UNICAJA,0) from '+@GESTION+'.dbo.articulo where CODIGO=@jsArticulo)>0 
												then @jsUnidades / (select isnull(UNICAJA,0) from '+@GESTION+'.dbo.articulo where CODIGO=@jsArticulo)
												else 0.00 END
			EXEC [pPedido_Nuevo_Linea_I]	  @MODO = ''''
											, @Emp = @EMPRESA
											, @IDPEDIDO = @IDPEDIDO
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

			declare @hora varchar(2) = cast(datepart(HOUR,getdate()) as varchar(2))
			declare @minutos varchar(2) = cast(datepart(MINUTE,getdate()) as varchar(2))
			if len(@hora)=1 set @hora = ''0''+@hora
			if len(@minutos)=1 set @minutos = ''0''+@minutos
			declare @laHora varchar(5) = @hora+'':''+@minutos

			if @inciArt is not null and @inciArt<>''''	
			insert into inci_CliArt (empresa,fecha,hora, nombreTV, idpedido, cliente, articulo, incidencia, descripcion, observaciones)
				values (@empresa, @FechaTV
						, cast(datepart(HOUR,getdate()) as char(2))+'':''+cast(datepart(MINUTE,getdate()) as char(2))
						, @nombreTV, @idpedido, @cliente
						, @jsArticulo
						, @inciArt
						, @inciArtDescrip
						, @obsArt
				)
' set  @Sentencia = @Sentencia + '
					 
			insert into [inci_CliArt] ([empresa],[cliente],[fecha],[articulo],[incidencia],[descripcion],[hora])			
			values(@EMPRESA,@CLIENTE,getdate(),@jsArticulo,@inciArt,@obsArt,@laHora)

			FETCH NEXT FROM cur INTO @valor
		END CLOSE cur deallocate cur	

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
exec (@Sentencia) 
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
			,@CLIENTE		varchar(20)
			,@NUMERO		char(10)
			,@ENTREGA		varchar(10)
			,@TIPO_IVA		char(2)
			,@IVA			numeric(20,2)
			,@LETRA			char(2)
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
' set  @Sentencia =  @Sentencia + '
	declare @sentencia varchar(max) = ''''
	declare @GESTION   varchar(20)	= ''[''+(select GESTION from Configuracion_SQL)+'']''
	declare @CAMPOS	   varchar(10)  = ''[''+(select CAMPOS from Configuracion_SQL)+'']''
	declare @EJERCICIO char(4)		= (select EJERCICIO from Configuracion_SQL)

	if @DESCRIP is null set @DESCRIP=''''
	SET @EJER = (select [any] from '+@COMUN+'.[DBO].ejercici where predet=1)

	set @NUMERO   = (select NUMERO  FROM vPedidos where IDPEDIDO=@IDPEDIDO)
	set @ENTREGA  = (select ENTREGA from vPedidos where IDPEDIDO=@IDPEDIDO)
	set @letra    = (select letra   from vPedidos where IDPEDIDO=@IDPEDIDO)
	set @CLIENTE  = (select CLIENTE from vPedidos where IDPEDIDO=@IDPEDIDO)
	set @linia	  = (select isnull(max(LINIA),0)+1 from vPedidos_Detalle where IDPEDIDO=@IDPEDIDO)	
	set @coste	  = (select isnull(COST_ULT1,0) from vArticulos where codigo=@ARTICULO)
	set @familia  = (select familia   from vArticulos where codigo=@ARTICULO)

	declare @IVAcliente char(2) = 
			ISNULL((select CODIGO from '+@GESTION+'.dbo.tipo_iva where CODIGO=(select TIPO_IVA from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)),''0'')
	declare @IVAarticulo char(2) = 
			ISNULL((select CODIGO from '+@GESTION+'.dbo.tipo_iva where CODIGO=(select TIPO_IVA from '+@GESTION+'.dbo.articulo where CODIGO=@ARTICULO)),''0'')
	if @IVAcliente=0 set @TIPO_IVA=@IVAarticulo else set @TIPO_IVA=@IVAcliente

	set @precio_IVA = (@IMPORTE  * (select IVA from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)) / 100
	set @importeiva = ((@IMPORTE * (select IVA from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)) / 100) + @IMPORTE

	if (select RECARG from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)>0  
		and (select RECARGO from '+@GESTION+'.dbo.clientes where CODIGO=@CLIENTE)=1 BEGIN
		set @recargo=1
		set @recargoPC  = (select RECARG from '+@GESTION+'.dbo.tipo_iva where CODIGO=@TIPO_IVA)
		set @recargoIMP = (@IMPORTE * @recargoPC) / 100
	END ELSE set @recargo=0

	IF @peso is null set @peso=0
' set  @Sentencia =  @Sentencia + '
	--------------------------------------------------------------------------------------------------------------
	--	Insertar Registro	
		set @sentencia = 
		''INSERT INTO ''+@GESTION+''.[DBO].d_pedive (usuario, empresa, numero,  linia, articulo, definicion, unidades, precio, dto1, dto2
					, importe, tipo_iva, coste, cliente, precioiva, importeiva, cajas, familia, preciodiv, importediv, peso, letra
					, impdiviva, prediviva, RECARG)
			VALUES (''''''+@UserName
					+'''''', ''''''+@Emp
					+'''''', ''''''+@NUMERO
					+'''''', ''''''+cast(@linia as varchar)
					+'''''', ''''''+@ARTICULO
					+'''''', ''''''+@DESCRIP
					+'''''', ''''''+cast(@UNIDADES as varchar)
					+'''''', ''''''+cast(@PRECIO	as varchar)
					+'''''', ''''''+cast(@DTO1	as varchar)
					+'''''', ''''''+cast(@DTO2	as varchar)
					+'''''', ''''''+cast(@IMPORTE as varchar)
					+'''''', ''''''+@TIPO_IVA
					+'''''', ''''''+cast(@coste	as varchar)
					+'''''', ''''''+@CLIENTE
					+'''''', ''''''+cast(@precio_iva	as varchar)
					+'''''', ''''''+cast(@importeiva	as varchar)
					+'''''', ''''''+cast(@cajas		as varchar)
					+'''''', ''''''+@familia
					+'''''', ''''''+cast(@PRECIO	as varchar)
					+'''''', ''''''+cast(@IMPORTE as varchar)
					+'''''', ''''''+cast(@peso	as varchar)
					+'''''', ''''''+@letra
					+'''''', 0, 0, ''''''+cast(@recargo as varchar)+'''''')''
		EXEC (@sentencia)

	-- camposAD
	IF OBJECT_ID('''+@CAMPOS+'.dbo.D_PEDIVEEW'') IS NOT NULL BEGIN
		if not exists (select * from '+@CAMPOS+'.dbo.d_pediveew 
						where ejercicio=@EJER and empresa=@Emp and numero=@NUMERO and letra=@LETRA and linia=@linia)
		BEGIN
			insert into '+@CAMPOS+'.dbo.d_pediveew (ejercicio, empresa, numero, letra, linia)
			values (@EJER, @Emp, @NUMERO, @LETRA, @linia)
		END
	END
' set  @Sentencia =  @Sentencia + '	
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
exec (@Sentencia) 
select  'pPedidoLineas'




--	Procedimiento pPedidoTotal
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pPedidoTotal' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

set  @Sentencia = '
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Lineas del Pedido
-- ===========================================================

-- exec [pPedidoTotal] ''totales'' , ''201901      190308''

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
exec (@Sentencia) 
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
exec (@Sentencia) 
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
exec (@Sentencia) 
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
exec (@Sentencia) 
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
exec(@Sentencia)
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
exec(@Sentencia)
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
exec(@Sentencia)
select  'pPedido_ActualizarCabecera'





/*
--Procedimiento pActividades
IF EXISTS ( SELECT * FROM sysobjects WHERE name = N'pActividades' and type = 'P' ) set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
set @Sentencia = @AlterCreate + '

'
exec(@Sentencia)
select  'pActividades'
*/




	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH