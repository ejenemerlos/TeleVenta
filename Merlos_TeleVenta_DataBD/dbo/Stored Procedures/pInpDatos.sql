
CREATE PROCEDURE [dbo].[pInpDatos] @elJS nvarchar(max)=''
AS
BEGIN TRY
	declare   @modo varchar(50) = (select JSON_VALUE(@elJS,'$.modo'))
			, @vista varchar(50)
			, @respuesta nvarchar(max)

	if @modo='gestor' or @modo='gestor0' set @vista = 'gestores'
	if @modo='ruta' set @vista = 'vRutas'
	if @modo='vendedor' set @vista = 'vVendedores'
	if @modo='serie' set @vista = 'vSeries'
	if @modo='marca' set @vista = 'vMarcas'
	if @modo='familia' set @vista = 'vFamilias'
	if @modo='subfamilia' set @vista = 'vSubFamilias'
	
	exec ('select isnull((select CODIGO as codigo, NOMBRE as nombre from '+ @vista +' for JSON AUTO),''[]'') as JAVASCRIPT')
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
