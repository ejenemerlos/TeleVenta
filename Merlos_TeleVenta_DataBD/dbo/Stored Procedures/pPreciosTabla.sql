CREATE PROCEDURE [dbo].[pPreciosTabla]	 @parametros varchar(max)
AS
BEGIN TRY
	declare   @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
			, @empresa char(2) = (select JSON_VALUE(@parametros,'$.empresa'))
			, @cliente varchar(50) = (select JSON_VALUE(@parametros,'$.cliente'))
			, @articulo varchar(50) = (select JSON_VALUE(@parametros,'$.articulo'))
			, @unidades varchar(50) = (select JSON_VALUE(@parametros,'$.unidades'))
			, @FechaTeleVenta varchar(10) = (select JSON_VALUE(@parametros,'$.FechaTeleVenta'))

	if @modo='verArticuloTarifas' BEGIN
		select isnull((select * from vPvP where articulo=@articulo for JSON AUTO, INCLUDE_NULL_VALUES),'[]') AS JAVASCRIPT
		return -1
	END

	declare @precioTarifa varchar(50)
	declare @elPrecio varchar(50)
	declare @elDto varchar(50)

	set @precioTarifa =  (select isnull(pvp,0.00) from vArticulos where CODIGO=@articulo)
	set @elPrecio =  (select cast(isnull(PVP, 0) as varchar) from ftDonamPreu(@empresa,@CLIENTE,@articulo,'',@unidades,@FechaTeleVenta))
	set @elDto    =  (select cast(isnull(DTO1,0) as varchar) from ftDonamPreu(@empresa,@CLIENTE,@articulo,'',@unidades,@FechaTeleVenta))

	select 
		CONCAT('[{"articulo":"',@articulo,'","precioTarifa":"',@precioTarifa,'","precio":"',@elPrecio,'","dto":"',@elDto,'"}]') 
	as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH