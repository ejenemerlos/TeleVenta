
CREATE PROCEDURE [dbo].[pObjetoDatos] @elJS nvarchar(max)=''
AS
BEGIN TRY
	declare   @objeto varchar(50) = (select JSON_VALUE(@elJS,'$.objeto'))
			, @cliente varchar(50) = (select JSON_VALUE(@elJS,'$.cliente'))
			, @respuesta nvarchar(max)

	if @objeto='contactos' BEGIN
		set @respuesta = (select * from vContactos where CLIENTE=@cliente for JSON AUTO) 
	END

	if @objeto='inciCli' BEGIN
		set @respuesta = (select * from inci_cli for JSON AUTO) 
	END

	if @objeto='inciArt' BEGIN
		set @respuesta = (select * from inci_art for JSON AUTO) 
	END

	if @objeto='Tarifas' BEGIN
		set @respuesta = (select CODIGO, NOMBRE from vTarifas for JSON AUTO) 
	END

	select isnull(@respuesta,'') as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
