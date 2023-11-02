
CREATE PROCEDURE [dbo].[pIncidencias] @parametros varchar(max) 
AS
BEGIN TRY

	declare   @modo varchar(20) = (select JSON_VALUE(@parametros,'$.modo'))
			, @respuesta varchar(max) = '[]'
	
	if @modo='cliente'  begin set @respuesta = (select * from inci_cli for JSON AUTO) END
	if @modo='articulo' begin set @respuesta = (select * from inci_art for JSON AUTO) END

	select isnull(@respuesta,'[]') as JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pIncidencias')
	RETURN 0
END CATCH
