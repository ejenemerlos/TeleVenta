
CREATE PROCEDURE [dbo].[pClientesDirecciones] @parametros varchar(max)
AS
SET NOCOUNT ON
BEGIN TRY	
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@cliente varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
		
	declare @datos varchar(max) = ''
		,	@error varchar(max) = ''

	if @modo='dameDirecciones' BEGIN
		set @datos = ( select * from vDirecciones where CLIENTE=@cliente for JSON AUTO,INCLUDE_NULL_VALUES )
	END

	select (CONCAT('{"error":"',@error,'","datos":',@datos,'}')) as JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	select CONCAT('{"error":"SP: pClientesDirecciones - modo: '+@modo+'","datos":"',@CatchError,'"}') as JAVASCRIPT
	RAISERROR(@CatchError,12,1)
	RETURN -1
END CATCH
