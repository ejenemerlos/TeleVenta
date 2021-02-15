CREATE PROCEDURE [dbo].[pPreciosTabla]	 @parametros varchar(max)
AS
BEGIN TRY
	declare   @empresa char(2) = (select JSON_VALUE(@parametros,'$.empresa'))
			, @cliente varchar(50) = (select JSON_VALUE(@parametros,'$.cliente'))
			, @articulo varchar(50) = (select JSON_VALUE(@parametros,'$.articulo'))
			, @unidades varchar(50) = (select JSON_VALUE(@parametros,'$.unidades'))
			, @FechaTeleVenta varchar(10) = (select JSON_VALUE(@parametros,'$.FechaTeleVenta'))

	declare @elPrecio varchar(50)
	declare @elDto varchar(50)

	set @elPrecio =  (select cast(isnull(PVP,0) as varchar) from ftDonamPreu(@empresa,@CLIENTE,@articulo,'',@unidades,@FechaTeleVenta))
	set @elDto =  (select cast(isnull(DTO1,0) as varchar) from ftDonamPreu(@empresa,@CLIENTE,@articulo,'',@unidades,@FechaTeleVenta))

	select CONCAT('[{"articulo":"',@articulo,'","precio":"',@elPrecio,'","dto":"',@elDto,'"}]') as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH