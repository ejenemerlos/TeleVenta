CREATE PROCEDURE [dbo].[pConfiguracion] ( @parametros varchar(max) = '' )
AS
BEGIN TRY	

	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@nombre varchar(50) = isnull((select JSON_VALUE(@parametros,'$.nombre')),'')
		,	@valor varchar(50) = isnull((select JSON_VALUE(@parametros,'$.valor')),'')

	declare @GESTION char(6), @COMUN char(8)
	select  @GESTION=GESTION, @COMUN=COMUN from Configuracion_SQL

	declare @respuesta varchar(max) = ''
		,	@datos nvarchar(max)=''	
		,	@MesesConsumo int = 1
		,	@TVSerie varchar(50)=''
		,	@TVTarifa varchar(50)=''

	if @modo='ComprobarEjercicio' and @GESTION<>'' BEGIN
		declare @laRuta char(6)
		declare @tbRuta table (RUTA char(6))
		insert  @tbRuta exec('select RUTA from ['+@COMUN+'].dbo.ejercici where PREDET=1')
		select  @laRuta=RUTA from @tbRuta 
		delete  @tbRuta
		if @GESTION<>@laRuta BEGIN
			update Configuracion_SQL set EJERCICIO=LEFT(@laRuta,4), GESTION=@laRuta
			EXEC [dbo].[01_CrearVistas]
			EXEC [dbo].[02_CrearStoreds]
			EXEC [dbo].[04_CrearFunciones]
			set @respuesta=@laRuta
		END
		select @respuesta as JAVASCRIPT
		return -1
	END


	--	RECONFIGURAR - eliminamos datos de la aplicación
		if @modo='reconfigurar' BEGIN
			TRUNCATE TABLE [dbo].[config_telev]
			TRUNCATE TABLE [dbo].[config_user]
			TRUNCATE TABLE [dbo].[Configuracion]
			TRUNCATE TABLE [dbo].[Configuracion_ADI]
			TRUNCATE TABLE [dbo].[Configuracion_SQL]
			TRUNCATE TABLE [dbo].[cliente_gestor]
			TRUNCATE TABLE [dbo].[config_telev]
			TRUNCATE TABLE [dbo].[familia_user]
			TRUNCATE TABLE [dbo].[gestor_user]
			TRUNCATE TABLE [dbo].[gestores]
			TRUNCATE TABLE [dbo].[inci_art]
			TRUNCATE TABLE [dbo].[inci_cli]
			TRUNCATE TABLE [dbo].[inci_CliArt]
			TRUNCATE TABLE [dbo].[inci_CliPed]
			TRUNCATE TABLE [dbo].[llamadas]
			TRUNCATE TABLE [dbo].[llamadas_user]
			TRUNCATE TABLE [dbo].[llamadasOD]
			TRUNCATE TABLE [dbo].[marca_user]
			TRUNCATE TABLE [dbo].[ObservacionesInternas]
			TRUNCATE TABLE [dbo].[Pedidos_Contactos]
			TRUNCATE TABLE [dbo].[Pedidos_Familias]
			TRUNCATE TABLE [dbo].[ruta_user]
			TRUNCATE TABLE [dbo].[serie_user]
			TRUNCATE TABLE [dbo].[subfam_user]
			TRUNCATE TABLE [dbo].[TeleVentaCab]
			TRUNCATE TABLE [dbo].[TeleVentaCliente]
			TRUNCATE TABLE [dbo].[TeleVentaDetalle]
			TRUNCATE TABLE [dbo].[TeleVentaFiltros]
			TRUNCATE TABLE [dbo].[TeleVentaIncidencias]
			TRUNCATE TABLE [dbo].[vend_user]
			TRUNCATE TABLE [dbo].[VendSubVend]
			return -1
		END


	

	if @modo = 'MesesConsumo' begin
		update config_telev set consumo=@valor
		update Configuracion_SQL set MesesConsumo=@valor
	end

	if @modo = 'TVSerie' update Configuracion_SQL set TVSerie=@valor

	if @modo = 'TVTarifa' update Configuracion_SQL set TarifaMinima=@valor

	if @modo='actualizar' BEGIN
		if not exists (select * from Configuracion where nombre=@nombre)
			insert into Configuracion (nombre,valor) values (@nombre,@valor)
		else update Configuracion set valor=@valor where nombre=@nombre
	END

	if @modo = 'configEmail' begin
		begin try
			update Configuracion_Email set
					Cuenta = isnull((select JSON_VALUE(@parametros,'$.configEmailCuenta')),'')
				, ServidorSMTP = isnull((select JSON_VALUE(@parametros,'$.configEmailSMTP')),'')
				, Puerto = isnull((select JSON_VALUE(@parametros,'$.configEmailPuerto')),'')
				, [SSL] = cast(isnull((select JSON_VALUE(@parametros,'$.configEmailSSL')),'0') as bit)
				, Usuario = isnull((select JSON_VALUE(@parametros,'$.configEmailUsuario')),'')
				, [Password] = isnull((select JSON_VALUE(@parametros,'$.configEmailPswrd')),'')
			select 'configEmail_OK' as JAVASCRIPT
		end try begin catch select 'configEmail_KO' as JAVASCRIPT return -1 END CATCH
	end


	-- devolver configuración
	set @MesesConsumo = (select MesesConsumo from Configuracion_SQL)
	set @TVSerie = (select isnull(TVSerie,'') from Configuracion_SQL)
	set @TVTarifa = (select isnull(TarifaMinima,'') from Configuracion_SQL)

	declare @IO varchar(max) = isnull((select nombre,valor from Configuracion for JSON AUTO,INCLUDE_NULL_VALUES),'[]')

	declare @ConfigEmail varchar(max) = isnull((select * from Configuracion_Email for JSON AUTO,INCLUDE_NULL_VALUES),'[]')

	set @respuesta = '{'
					+	'"ConfSQL":['
					+				'{'
					+					'"MesesConsumo":"'+cast(@MesesConsumo as varchar(2))+'"'
					+					',"TVSerie":"'+@TVSerie+'"'
					+					',"TVTarifa":"'+@TVTarifa+'"'
					+				'}'
					+			   ']'
					+	',"IO":' + @IO
					+	',"ConfigEmail":' + @ConfigEmail
					+'}'

	select @respuesta as JAVASCRIPT
		
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1, 'pConfiguracion')
	RETURN 0
END CATCH