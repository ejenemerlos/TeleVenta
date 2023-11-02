
CREATE
PROCEDURE [dbo].[pEstadisticas]	  @modo varchar(50) = 'estadisticas'
										, @fechaDesde varchar(10)=''
										, @fechaHasta varchar(10)=''
										, @vendedorDesde varchar(max)=''
										, @vendedorHasta varchar(max)=''
										, @clienteDesde varchar(max)=''
										, @clienteHasta varchar(max)=''
										, @serieDesde varchar(max)=''
										, @serieHasta varchar(max)=''
										, @marcaDesde varchar(max)=''
										, @marcaHasta varchar(max)=''
										, @familiaDesde varchar(max)=''
										, @familiaHasta varchar(max)=''
										, @subFamiliaDesde varchar(max)=''
										, @subFamiliaHasta varchar(max)=''
										, @articuloDesde varchar(max)=''
										, @articuloHasta varchar(max)=''
										, @agruparPorArticulo int=0
										, @usuario varchar(50)=''
										, @rol varchar(50)=''
AS
BEGIN TRY	
	declare   @respuesta varchar(max)   = ''
			, @sentencia varchar(max)   = ''
			, @elInnerJoin varchar(max) = ''
			, @elWhere varchar(max)     = ' where IdListVenta<>'''' '
			, @elGroupBy varchar(max)   = ' group by IdListVenta, EMPRESA, NUMERO, LETRA, FECHA, VENDEDOR, N_VENDEDOR, CLIENTE, N_CLIENTE, 
												  ARTICULO, DEFINICION, CAJAS, vListVentas.PESO, UNIDADES, IMPORTE '

	if @rol='Cliente' begin 
		set @clienteDesde=@usuario 
		set @clienteHasta=@usuario 
		set @vendedorDesde='' 
		set @vendedorHasta='' 
	end

	if @rol='Vendedor' begin 
		set @vendedorDesde=@usuario
		set @vendedorHasta=@usuario 
	end

	 
	if @fechaDesde is not null and @fechaDesde<>'' set @elWhere = @elWhere + ' and FECHA>='''+@fechaDesde+''' '
	if @fechaHasta is not null and @fechaHasta<>'' set @elWhere = @elWhere + ' and FECHA<='''+@fechaHasta+''' '

	declare @quitaVendedorHasta int
	if @vendedorDesde is not null and @vendedorDesde<>'' BEGIN
		if @vendedorDesde='MULTISELECCIÓN' BEGIN
			set @quitaVendedorHasta=1
			DECLARE @pos INT=0, @len INT=0, @value varchar(max)
			WHILE CHARINDEX(',', @vendedorHasta, @pos+1)>0
			BEGIN
				set @len = CHARINDEX(',', @vendedorHasta, @pos+1) - @pos
				set @value = SUBSTRING(@vendedorHasta, @pos, @len)
				if @quitaVendedorHasta=1 begin 
					set @quitaVendedorHasta=2
					set @elWhere = @elWhere + ' AND (VENDEDOR='''+@value+''' ' 
				end 
				else begin set @elWhere = @elWhere + ' or VENDEDOR='''+@value+''' ' end
				set @pos = CHARINDEX(',', @vendedorHasta, @pos+@len) +1
			END
			set @value = SUBSTRING(@vendedorHasta, @pos, @len)
			set @elWhere = @elWhere + ' or VENDEDOR='''+@value+''') '
		END
		ELSE BEGIN set @elWhere = @elWhere + ' and VENDEDOR>='''+@vendedorDesde+''' ' END
	END
	if @quitaVendedorHasta is null BEGIN
		if @vendedorHasta is not null and @vendedorHasta<>'' set @elWhere = @elWhere + ' and VENDEDOR<='''+@vendedorHasta+''' '
	END
	 
	declare @quitaClienteHasta int
	if @ClienteDesde is not null and @ClienteDesde<>'' BEGIN
		if @ClienteDesde='MULTISELECCIÓN' BEGIN
			set @quitaClienteHasta=1
			DECLARE @posCliente INT=0, @lenCliente INT=0, @valueCliente varchar(max)
			WHILE CHARINDEX(',', @ClienteHasta, @posCliente+1)>0
			BEGIN
				set @lenCliente = CHARINDEX(',', @ClienteHasta, @posCliente+1) - @posCliente
				set @valueCliente = SUBSTRING(@ClienteHasta, @posCliente, @lenCliente)
				if @quitaClienteHasta=1 begin 
					set @quitaClienteHasta=2
					set @elWhere = @elWhere + ' AND (Cliente='''+@valueCliente+''' ' 
				end 
				else begin set @elWhere = @elWhere + ' or Cliente='''+@valueCliente+''' ' end
				set @posCliente = CHARINDEX(',', @ClienteHasta, @posCliente+@lenCliente)+1
			END
			set @valueCliente = SUBSTRING(@ClienteHasta, @posCliente, @lenCliente)
			set @elWhere = @elWhere + ' or Cliente='''+@valueCliente+''') '
		END
		ELSE BEGIN set @elWhere = @elWhere + ' and Cliente>='''+@ClienteDesde+''' ' END
	END
	if @quitaClienteHasta is null BEGIN
		if @ClienteHasta is not null and @ClienteHasta<>'' set @elWhere = @elWhere + ' and Cliente<='''+@ClienteHasta+''' '
	END
	 
	declare @quitaSerieHasta int
	if @SerieDesde is not null and @SerieDesde<>'' BEGIN
		if @SerieDesde='MULTISELECCIÓN' BEGIN
			set @quitaSerieHasta=1
			DECLARE @posSerie INT=0, @lenSerie INT=0, @valueSerie varchar(max)
			WHILE CHARINDEX(',', @SerieHasta, @posSerie+1)>0
			BEGIN
				set @lenSerie = CHARINDEX(',', @SerieHasta, @posSerie+1) - @posSerie
				set @valueSerie = SUBSTRING(@SerieHasta, @posSerie, @lenSerie)
				if @quitaSerieHasta=1 begin 
					set @quitaSerieHasta=2
					set @elWhere = @elWhere + ' AND (LETRA='''+@valueSerie+''' ' 
				end 
				else begin set @elWhere = @elWhere + ' or LETRA='''+@valueSerie+''' ' end
				set @posSerie = CHARINDEX(',', @SerieHasta, @posSerie+@lenSerie)+1
			END
			set @valueSerie = SUBSTRING(@SerieHasta, @posSerie, @lenSerie)
			set @elWhere = @elWhere + ' or LETRA='''+@valueSerie+''') '
		END
		ELSE BEGIN set @elWhere = @elWhere + ' and LETRA>='''+@SerieDesde+''' ' END
	END
	if @quitaSerieHasta is null BEGIN
		if @SerieHasta is not null and @SerieHasta<>'' set @elWhere = @elWhere + ' and LETRA<='''+@SerieHasta+''' '
	END
	 
	declare @quitaMarcaHasta int
	if @MarcaDesde is not null and @MarcaDesde<>'' BEGIN
		if @MarcaDesde='MULTISELECCIÓN' BEGIN
			set @quitaMarcaHasta=1
			DECLARE @posMarca INT=0, @lenMarca INT=0, @valueMarca varchar(max)
			WHILE CHARINDEX(',', @MarcaHasta, @posMarca+1)>0
			BEGIN
				set @lenMarca = CHARINDEX(',', @MarcaHasta, @posMarca+1) - @posMarca
				set @valueMarca = SUBSTRING(@MarcaHasta, @posMarca, @lenMarca)
				if @quitaMarcaHasta=1 begin 
					set @quitaMarcaHasta=2
					set @elInnerJoin = @elInnerJoin + ' and vArticulos.MARCA collate Modern_Spanish_CI_AI>='''+@valueMarca+''' ' 
				end 
				else begin 
					set @elInnerJoin = @elInnerJoin + ' or vArticulos.MARCA collate Modern_Spanish_CI_AI>='''+@valueMarca+''' ' 
				end
				set @posMarca = CHARINDEX(',', @MarcaHasta, @posMarca+@lenMarca)+1
			END
			set @valueMarca = SUBSTRING(@MarcaHasta, @posMarca, @lenMarca)
			set @elInnerJoin = @elInnerJoin + ' or vArticulos.MARCA collate Modern_Spanish_CI_AI>='''+@valueMarca+''' '
		END
		ELSE BEGIN set @elInnerJoin = @elInnerJoin + ' and vArticulos.MARCA collate Modern_Spanish_CI_AI>='''+@marcaDesde+''' ' END
	END
	if @quitaMarcaHasta is null BEGIN
		if @MarcaHasta is not null and @MarcaHasta<>'' 
		set @elInnerJoin = @elInnerJoin + ' and vArticulos.MARCA collate Modern_Spanish_CI_AI<='''+@marcaHasta+''' '
	END
	 
	declare @quitaFamiliaHasta int
	if @FamiliaDesde is not null and @FamiliaDesde<>'' BEGIN
		if @FamiliaDesde='MULTISELECCIÓN' BEGIN
			set @quitaFamiliaHasta=1
			DECLARE @posFamilia INT=0, @lenFamilia INT=0, @valueFamilia varchar(max)
			WHILE CHARINDEX(',', @FamiliaHasta, @posFamilia+1)>0
			BEGIN
				set @lenFamilia = CHARINDEX(',', @FamiliaHasta, @posFamilia+1) - @posFamilia
				set @valueFamilia = SUBSTRING(@FamiliaHasta, @posFamilia, @lenFamilia)
				if @quitaFamiliaHasta=1 begin 
					set @quitaFamiliaHasta=2
					set @elInnerJoin = @elInnerJoin + ' and vArticulos.Familia collate Modern_Spanish_CI_AI>='''+@valueFamilia+''' ' 
				end 
				else begin 
					set @elInnerJoin = @elInnerJoin + ' or vArticulos.Familia collate Modern_Spanish_CI_AI>='''+@valueFamilia+''' ' 
				end
				set @posFamilia = CHARINDEX(',', @FamiliaHasta, @posFamilia+@lenFamilia)+1
			END
			set @valueFamilia = SUBSTRING(@FamiliaHasta, @posFamilia, @lenFamilia)
			set @elInnerJoin = @elInnerJoin + ' or vArticulos.Familia collate Modern_Spanish_CI_AI>='''+@valueFamilia+''' '
		END
		ELSE BEGIN set @elWhere = @elWhere + ' and vArticulos.Familia collate Modern_Spanish_CI_AI>='''+@FamiliaDesde+''' ' END
	END
	if @quitaFamiliaHasta is null BEGIN
		if @FamiliaHasta is not null and @FamiliaHasta<>'' 
		set @elInnerJoin = @elInnerJoin + ' and vArticulos.Familia collate Modern_Spanish_CI_AI<='''+@FamiliaHasta+''' '
	END
	 
	declare @quitaSubFamiliaHasta int
	if @SubFamiliaDesde is not null and @SubFamiliaDesde<>'' BEGIN
		if @SubFamiliaDesde='MULTISELECCIÓN' BEGIN
			set @quitaSubFamiliaHasta=1
			DECLARE @posSubFamilia INT=0, @lenSubFamilia INT=0, @valueSubFamilia varchar(max)
			WHILE CHARINDEX(',', @SubFamiliaHasta, @posSubFamilia+1)>0
			BEGIN
				set @lenSubFamilia = CHARINDEX(',', @SubFamiliaHasta, @posSubFamilia+1) - @posSubFamilia
				set @valueSubFamilia = SUBSTRING(@SubFamiliaHasta, @posSubFamilia, @lenSubFamilia)
				if @quitaSubFamiliaHasta=1 begin 
					set @quitaSubFamiliaHasta=2
					set @elInnerJoin = @elInnerJoin + ' and vArticulos.SubFamilia collate Modern_Spanish_CI_AI>='''+@valueSubFamilia+''' ' 
				end 
				else begin 
					set @elInnerJoin = @elInnerJoin + ' or vArticulos.SubFamilia collate Modern_Spanish_CI_AI>='''+@valueSubFamilia+''' ' 
				end
				set @posSubFamilia = CHARINDEX(',', @SubFamiliaHasta, @posSubFamilia+@lenSubFamilia)+1
			END
			set @valueSubFamilia = SUBSTRING(@SubFamiliaHasta, @posSubFamilia, @lenSubFamilia)
			set @elInnerJoin = @elInnerJoin + ' or vArticulos.SubFamilia collate Modern_Spanish_CI_AI>='''+@valueSubFamilia+''' '
		END
		ELSE BEGIN set @elInnerJoin = @elInnerJoin + ' and vArticulos.SubFamilia collate Modern_Spanish_CI_AI>='''+@SubFamiliaDesde+''' ' END
	END
	if @quitaSubFamiliaHasta is null BEGIN
		if @SubFamiliaHasta is not null and @SubFamiliaHasta<>'' 
		set @elInnerJoin = @elInnerJoin + ' and vArticulos.SubFamilia collate Modern_Spanish_CI_AI<='''+@SubFamiliaHasta+''' '
	END
	 
	declare @quitaArticuloHasta int
	if @ArticuloDesde is not null and @ArticuloDesde<>'' BEGIN
		if @ArticuloDesde='MULTISELECCIÓN' BEGIN
			set @quitaArticuloHasta=1
			DECLARE @posArticulo INT=0, @lenArticulo INT=0, @valueArticulo varchar(max)
			WHILE CHARINDEX(',', @ArticuloHasta, @posArticulo+1)>0
			BEGIN
				set @lenArticulo = CHARINDEX(',', @ArticuloHasta, @posArticulo+1) - @posArticulo
				set @valueArticulo = SUBSTRING(@ArticuloHasta, @posArticulo, @lenArticulo)
				if @quitaArticuloHasta=1 begin 
					set @quitaArticuloHasta=2
					set @elWhere = @elWhere + ' AND (Articulo='''+@valueArticulo+''' ' 
				end 
				else begin set @elWhere = @elWhere + ' or Articulo='''+@valueArticulo+''' ' end
				set @posArticulo = CHARINDEX(',', @ArticuloHasta, @posArticulo+@lenArticulo)+1
			END
			set @valueArticulo = SUBSTRING(@ArticuloHasta, @posArticulo, @lenArticulo)
			set @elWhere = @elWhere + ' or Articulo='''+@valueArticulo+''') '
		END
		ELSE BEGIN set @elWhere = @elWhere + ' and Articulo>='''+@ArticuloDesde+''' ' END
	END
	if @quitaArticuloHasta is null BEGIN
		if @ArticuloHasta is not null and @ArticuloHasta<>'' set @elWhere = @elWhere + ' and Articulo<='''+@ArticuloHasta+''' '
	END

	if @elInnerJoin<>'' set @elInnerJoin = 'inner join vArticulos on vArticulos.CODIGO collate Modern_Spanish_CI_AI=ARTICULO ' + @elInnerJoin
	 
	declare @laConsulta varchar(max) = 'create view vEstadisticas as 
						select IdListVenta, EMPRESA, NUMERO, LETRA, convert(varchar(10),FECHA,103) as FECHA, VENDEDOR, N_VENDEDOR, CLIENTE, N_CLIENTE, 
								 ARTICULO, DEFINICION, CAJAS, vListVentas.PESO, UNIDADES, IMPORTE, 0 as agruparArticulo
						  from vListVentas '

	if @agruparPorArticulo=1 begin
		set @laConsulta  = 'create view vEstadisticas as 
						select '''' as IdListVenta, ARTICULO, DEFINICION, sum(CAJAS) as CAJAS
						, SUM(vListVentas.PESO) as PESO, sum(UNIDADES) as UNIDADES, SUM(IMPORTE) as IMPORTE
						, '''' as EMPRESA, '''' as NUMERO, '''' as LETRA, '''' as FECHA, '''' as VENDEDOR
						, '''' as N_VENDEDOR, '''' as CLIENTE, '''' as N_CLIENTE, 1 as agruparArticulo
						from vListVentas '
		set @elGroupBy = ' group by ARTICULO, DEFINICION '
	end

	IF EXISTS(select * FROM sys.views where name = 'vEstadisticas') begin drop view vEstadisticas end
	set @sentencia =      @laConsulta
						+ @elInnerJoin
						+ @elWhere 
						+ @elGroupBy

	-- print @sentencia return -1 
	EXEC (@sentencia)
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
