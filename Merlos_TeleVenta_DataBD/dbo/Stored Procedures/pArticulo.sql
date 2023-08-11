
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Propiedades del Artículo
-- ===========================================================

-- exec [pArticulo] 'AUTOF', 2

CREATE PROCEDURE [dbo].[pArticulo] @articulo char(15), @uds numeric(20,2), @CLIENTE VARCHAR(20)='', @TARIFA VARCHAR(2)=''
AS
BEGIN TRY
	DECLARE   @codigo	  char(15)
			, @nombre	  char(75)
			, @marca	  char(2),	@nMarca		 varchar(50)
			, @familia	  char(2),	@nFamilia	 varchar(100)
			, @subfamilia char(4),	@nSubfamilia varchar(50)
			, @peso		  char(12)
			, @litros	  char(12)
			, @unicaja	  numeric(15,6) = 0
			, @dto1		  numeric(20,2)
			, @dto2		  numeric(20,2)
			, @dto3		  numeric(20,2)
			, @coste	  numeric(15,6)
			, @iva		  numeric(20,2)
			, @recargo	  numeric(20,2)
			, @precio	  numeric(20,2)
			, @importe	  numeric(20,2)
			, @maxPed	  varchar(50)
			, @respuesta  varchar(max)

	IF not exists (select codigo from vArticulos where codigo=@articulo) BEGIN
		select N'{"articulo":[]}' as JAVASCRIPT
		return -1;
	END

	declare @GESTION char(6)
	select @GESTION=GESTION from Configuracion_SQL

	select  @nombre=nombre, @marca=marca, @familia=familia, @subfamilia=subfamilia
		,	@peso=isnull(peso,''), @litros=isnull(volumen,''), @unicaja=isnull(unicaja,0)
		,	@dto1=isnull(dto1,0), @dto2=isnull(dto2,0), @dto3=isnull(dto3,0)
	from vArticulos where codigo=@articulo

	select @nFamilia=nombre  from vFamilias where codigo=@familia
	select @nMarca=nombre  from vMarcas where codigo=@marca
	select @nSubfamilia=nombre from vSubFamilias where codigo=@subfamilia
	
	-- devolvemos el stock del artículo
	declare @stock varchar(10) = cast((select isnull(SUM(FINAL),0) from [2021YB].dbo.stocks2 where ARTICULO=@articulo) as varchar)
	if @stock='' set @stock='0'
	-- Stock Virtual
	declare @StockVirtual varchar(10) = cast((select isnull(StockVirtual,0) from vArticulos where CODIGO=@articulo) as varchar)


	-- detectar si trabaja con cajas
	declare @conCajas int = 0;	if (select Cajas from vConfigEW where EMPRESA='01')=1 BEGIN set @conCajas=1 END

	set @peso = isnull(@peso,'0.00')
	if @peso='' set @peso='0.00'
	
	-- precio, descuentos y total
	select @precio=isnull(PVP,0), @dto1=isnull(DTO1,0), @dto2=isnull(DTO2,0) from ftDonamPreu('01',@CLIENTE,@articulo,'',@uds,'')

	set @importe = @precio * @uds
	-- máx. uds por pedido
	declare @TablaTemporal TABLE (maxPed varchar(50))
	INSERT @TablaTemporal EXEC('select case when ISNULL(VALOR,''0'')=0 then ''0'' else ISNULL(VALOR,''0'') END from ['+@GESTION+'].dbo.multicam where CAMPO=''MPE'' and CODIGO='''+@articulo+'''')	
	SELECT @maxPed=maxPed FROM @TablaTemporal		
	delete @TablaTemporal

	set @respuesta = N'{"articulo":[{'
					+	'"codigo":"'		+@articulo+'",'
					+	'"nombre":"'		+@nombre+'",'
					+	'"marca":"'			+ISNULL(@nMarca,'')+'",'
					+	'"nMarca":"'		+ISNULL(@marca,'')+'",'
					+	'"familia":"'		+ISNULL(@familia,'')+'",'
					+	'"nFamilia":"'		+ISNULL(@nFamilia,'')+'",'
					+	'"subfamilia":"'	+ISNULL(@subfamilia,'')+'",'
					+	'"nSubFamilia":"'	+ISNULL(@nSubfamilia,'')+'",'
					+	'"peso":"'			+@peso+'",'
					+	'"litros":"'		+ISNULL(@litros,'')+'",'
					+	'"unicaja":"'		+cast(ISNULL(@unicaja,'')		as varchar)+'",'
					+	'"dto1":"'			+cast(ISNULL(@dto1,'')			as varchar)+'",'
					+	'"dto2":"'			+cast(ISNULL(@dto2,'')			as varchar)+'",'
					+	'"dto3":"'			+cast(ISNULL(@dto3,'')			as varchar)+'",'
					+	'"precio":"'		+cast(ISNULL(@precio,'')		as varchar)+'",'
					+	'"importe":"'		+cast(ISNULL(@importe,'')		as varchar)+'",'
					+	'"stock":"'			+cast(ISNULL(@stock,'')			as varchar)+'",'
					+	'"StockVirtual":"'	+cast(ISNULL(@StockVirtual,'')	as varchar)+'",'
					+	'"conCajas":"'		+cast(@conCajas					as varchar)+'",'
					+	'"maxPed":"'		+cast(@maxPed					as varchar)+'"'
					+'}]}'
	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
