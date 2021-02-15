CREATE PROCEDURE [dbo].[pConfiguracion]
(
	  @modo varchar(50) = 'lista'
	, @valor varchar(max) = ''
)
AS
BEGIN TRY	

	--	RECONFIGURAR - eliminamos datos de la aplicación
		if @modo='reconfigurar' BEGIN
			TRUNCATE TABLE Configuracion_SQL
			return -1
		END

	declare   @datos nvarchar(max)=''	
			, @respuesta varchar(max) = ''
			, @MesesConsumo int = 1
			, @TVSerie varchar(50)=''

	if @modo = 'MesesConsumo' begin
		update config_telev set consumo=@valor
		update Configuracion_SQL set MesesConsumo=@valor
	end

	if @modo = 'TVSerie' update Configuracion_SQL set TVSerie=@valor

	set @MesesConsumo = (select MesesConsumo from Configuracion_SQL)
	set @TVSerie = (select isnull(TVSerie,'') from Configuracion_SQL)

	set @respuesta = '{"ConfSQL":[{"MesesConsumo":"'+cast(@MesesConsumo as varchar(2))+'","TVSerie":"'+@TVSerie+'"}]}'

	select @respuesta as JAVASCRIPT
		
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1, 'pConfiguracion')
	RETURN 0
END CATCH