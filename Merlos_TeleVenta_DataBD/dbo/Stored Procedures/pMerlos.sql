CREATE PROCEDURE [dbo].[pMerlos] @parametros varchar(max), @respuesta varchar(max)='' output	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		declare @sp varchar(50) = isnull((select JSON_VALUE(@parametros,'$.sp')),'')  
		, @sentencia varchar(max) = ''

		set @sentencia = 'declare @respuesta varchar(max)=''''  exec ' + @sp + ' '''+@parametros+''' '

		EXEC (@sentencia)
		return -1
	END TRY
	BEGIN CATCH
		DECLARE @CatchError NVARCHAR(MAX)
		SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
		select CONCAT('{"error":"SP: '+@sp+' - ',@CatchError,'"}') as JAVASCRIPT
		RAISERROR(@CatchError,12,1)
		RETURN 0
	END CATCH
END