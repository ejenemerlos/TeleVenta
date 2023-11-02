CREATE PROCEDURE [dbo].[pPreciosTabla]	 @parametros varchar(max)
AS
BEGIN TRY
	insert into Merlos_Log (accion) values (concat('[pPreciosTabla] ''',@parametros,''''))

	declare   @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
			, @empresa char(2) = isnull((select JSON_VALUE(@parametros,'$.empresa')),'')
			, @cliente varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
			, @articulo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
			, @unidades numeric(15,6) = cast(isnull((select JSON_VALUE(@parametros,'$.unidades')),'0') as numeric(15,6))
			, @cajasUdsPeso varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cajasUdsPeso')),'')
			, @FechaTeleVenta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.FechaTeleVenta')),'')
			, @articulosDatos varchar(max) = ''

	declare @unicaja int
	declare @peso numeric(20,5)

	declare @precioTarifa varchar(50)
	declare @elPrecio varchar(50)
	declare @elDto varchar(50)

	if @cajasUdsPeso='cajas' BEGIN
		set @unicaja = (select isnull(UNICAJA,0) from vArticulos where CODIGO=@articulo)
		if @unicaja>0 set @unidades = @unidades * @unicaja
	END

	if @cajasUdsPeso='peso' BEGIN
		set @peso = (select isnull(peso,0) from vArticulos where CODIGO=@articulo)
		if @peso>0 set @unidades = @unidades / @peso
	END


	if @modo='verArticuloTarifas' BEGIN
		select isnull((select * from vPvP where articulo=@articulo for JSON AUTO, INCLUDE_NULL_VALUES),'[]') AS JAVASCRIPT
		return -1
	END


	if @modo='verArticuloPrecio' BEGIN
		set @precioTarifa =  (select isnull(pvp,0.00) from vArticulos where CODIGO=@articulo)
		select @elPrecio=cast(isnull(PVP, 0) as varchar) , @elDto=cast(isnull(DTO1,0) as varchar) from ftDonamPreu(@empresa,@CLIENTE,@articulo,'',@unidades,@FechaTeleVenta)

		select 
			CONCAT('[{"articulo":"',@articulo,'","precioTarifa":"',@precioTarifa,'","precio":"',@elPrecio,'","dto":"',@elDto,'"}]') 
		as JAVASCRIPT
		return -1
	END
	   	 

	declare @valor varchar(1000) 
	declare cur CURSOR for select [value] from openjson(@parametros,'$.articulos')
	OPEN cur FETCH NEXT FROM cur INTO @valor
	WHILE (@@FETCH_STATUS=0) BEGIN
		declare @elArticulo varchar(50) = isnull((select JSON_VALUE(@valor,'$.articulo')),'')
		declare @laLinea varchar(10) = isnull((select JSON_VALUE(@valor,'$.linea')),'')

		set @precioTarifa	= (select isnull(pvp,0.00) from vArticulos where CODIGO=@elArticulo)
		set @elPrecio		= (select cast(isnull(PVP, 0) as varchar) 
								from ftDonamPreu (@empresa,@CLIENTE,@elArticulo,'',@unidades,@FechaTeleVenta))
		set @elDto			= (select cast(isnull(DTO1,0) as varchar) 
								from ftDonamPreu(@empresa,@CLIENTE,@elArticulo,'',@unidades,@FechaTeleVenta))

		set @articulosDatos = CONCAT(@articulosDatos 
		, '{"linea":"',@laLinea,'","articulo":"',@elArticulo,'","precioTarifa":"',@precioTarifa,'"'
		,',"precio":"',@elPrecio,'","dto":"',@elDto,'"}')

		FETCH NEXT FROM cur INTO @valor
	END CLOSE cur deallocate cur	

	select '['+replace(@articulosDatos,'}{','},{')+']' as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH