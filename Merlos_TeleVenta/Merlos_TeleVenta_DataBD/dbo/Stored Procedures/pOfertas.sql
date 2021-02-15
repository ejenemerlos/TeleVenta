CREATE PROCEDURE [dbo].[pOfertas] (@parametros varchar(max))
AS
BEGIN TRY
	declare @articulo varchar(20) = (select JSON_VALUE(@parametros,'$.articulo'))
	declare @fecha    varchar(10) = (select JSON_VALUE(@parametros,'$.fecha'))

	select isnull((
			select PVP, DTO1 from vOfertas
			where ARTICULO=@articulo and FECHA_IN<=cast(@fecha as smalldatetime) and FECHA_FIN>=cast(@fecha as smalldatetime)
			for JSON AUTO
	),'[]') as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
