CREATE PROCEDURE [dbo].[pOfertas] (@parametros varchar(max))
AS
BEGIN TRY
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@cliente varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
		,	@articulo varchar(20) = (select JSON_VALUE(@parametros,'$.articulo'))
		,	@fecha    smalldatetime = cast((select JSON_VALUE(@parametros,'$.fecha')) as smalldatetime)

	declare @GESTION char(6)
	declare @sql varchar(max) = ''

	select @GESTION=GESTION from Configuracion_SQL

	if @modo='ofertasDelCliente' BEGIN
		set @sql = CONCAT('
			select isnull((
				SELECT * FROM 
					(
					SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
					, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
					, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
					, OFE.DESDE AS UNI_INI
					, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
					,  OFE.MONEDA, OFE.TARIFA 
					FROM [',@GESTION,'].DBO.CLIENTES CLI 
					INNER JOIN [',@GESTION,'].DBO.OFERTAS OFE ON 1=1 
					INNER JOIN [',@GESTION,'].dbo.articulo art on OFE.ARTICULO=art.CODIGO
					WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=@cliente
					UNION ALL
					SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
					, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
					, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
					, OFE.DESDE AS UNI_INI
					, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
					,  OFE.MONEDA, OFE.TARIFA 
					FROM [',@GESTION,'].DBO.CLIENTES CLI 
					INNER JOIN [',@GESTION,'].DBO.OFERTAS OFE ON OFE.TARIFA=CLI.TARIFA 
					INNER JOIN [',@GESTION,'].dbo.articulo art on OFE.ARTICULO=art.CODIGO
					WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=@cliente
					) A
				for JSON AUTO, INCLUDE_NULL_VALUES
			),''[]'') as JAVASCRIPT
		')
		return -1
	END

	select isnull((
			select PVP, DTO1 from vOfertas		--	select * from vOfertas
			where ARTICULO=@articulo and FECHA_IN<=cast(@fecha as smalldatetime) and FECHA_FIN>=cast(@fecha as smalldatetime)
				  and (CLIENTE=@cliente or TARIFA='')
			for JSON AUTO, INCLUDE_NULL_VALUES
	),'[]') as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH