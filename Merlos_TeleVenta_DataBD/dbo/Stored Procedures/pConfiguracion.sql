CREATE PROCEDURE [dbo].[pConfiguracion] ( @parametros varchar(max) = '' )
AS
BEGIN TRY	

	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@nombre varchar(50) = isnull((select JSON_VALUE(@parametros,'$.nombre')),'')
		,	@valor varchar(50) = isnull((select JSON_VALUE(@parametros,'$.valor')),'')

	--	RECONFIGURAR - eliminamos datos de la aplicación
		if @modo='reconfigurar' BEGIN
			TRUNCATE TABLE Configuracion_SQL
			return -1
		END

	declare   @datos nvarchar(max)=''	
			, @respuesta varchar(max) = ''
			, @MesesConsumo int = 1
			, @TVSerie varchar(50)=''
			, @TVTarifa varchar(50)=''

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


	-- devolver configuración
	set @MesesConsumo = (select MesesConsumo from Configuracion_SQL)
	set @TVSerie = (select isnull(TVSerie,'') from Configuracion_SQL)
	set @TVTarifa = (select isnull(TarifaMinima,'') from Configuracion_SQL)

	declare @IO varchar(max) = isnull((select nombre,valor from Configuracion for JSON AUTO,INCLUDE_NULL_VALUES),'[]')

	set @respuesta = '{'
					+	'"ConfSQL":['
					+				'{'
					+					'"MesesConsumo":"'+cast(@MesesConsumo as varchar(2))+'"'
					+					',"TVSerie":"'+@TVSerie+'"'
					+					',"TVTarifa":"'+@TVTarifa+'"'
					+				'}'
					+			   ']'
					+	',"IO":' + @IO
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