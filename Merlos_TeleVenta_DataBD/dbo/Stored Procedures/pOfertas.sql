
CREATE PROCEDURE [dbo].[pOfertas] (@parametros varchar(max))
AS
BEGIN TRY
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
	declare @cliente varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
	declare @articulo varchar(20) = (select JSON_VALUE(@parametros,'$.articulo'))
	declare @fecha    smalldatetime = cast((select JSON_VALUE(@parametros,'$.fecha')) as smalldatetime)

	-- Parámetros de Configuración
	declare @Ejercicio char(4), @Gestion char(6), @GestionAnt char(6), @Letra char(2), @Comun char(8), @Lotes char(8), @Campos char(8), @Empresa char(2), @Anys int
	select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Letra=LETRA, @Comun=COMUN, @Campos=CAMPOS, @Empresa=EMPRESA, @Anys=ANYS from [Configuracion_SQL]
	set @GestionAnt=CONCAT(CAST(@Ejercicio as int)-1,@Letra)
	declare @sentencia varchar(max)=''

	if @modo='ofertasDelCliente' BEGIN
		set @sentencia=CONCAT('
			select isnull((
				SELECT * FROM 
					(
					SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
					, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
					, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
					, OFE.DESDE AS UNI_INI
					, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
					,  OFE.MONEDA, OFE.TARIFA 
					FROM [',@GestionAnt,'].DBO.CLIENTES CLI 
					INNER JOIN [',@GestionAnt,'].DBO.OFERTAS OFE ON 1=1 
					INNER JOIN [',@GestionAnt,'].dbo.articulo art on OFE.ARTICULO=art.CODIGO
					WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=''',@cliente,'''
					UNION ALL
					SELECT CLI.CODIGO AS CLIENTE, OFE.ARTICULO
					, convert(varchar(10),OFE.FECHA_IN,105) as FECHA_IN
					, convert(varchar(10),OFE.FECHA_FIN,105) as FECHA_FIN
					, OFE.DESDE AS UNI_INI
					, (CASE WHEN OFE.HASTA=0 THEN 999999.99 ELSE OFE.HASTA END) AS UNI_FIN, OFE.PVP, OFE.DESCUENTO AS DTO1
					,  OFE.MONEDA, OFE.TARIFA 
					FROM [',@Gestion,'].DBO.CLIENTES CLI 
					INNER JOIN [',@Gestion,'].DBO.OFERTAS OFE ON OFE.TARIFA=CLI.TARIFA 
					INNER JOIN [',@Gestion,'].dbo.articulo art on OFE.ARTICULO=art.CODIGO
					WHERE art.BAJA=0 and CLI.OFERTA=1 AND OFE.TARIFA='''' AND CLI.CODIGO=''',@cliente,'''
					) A
				for JSON AUTO, INCLUDE_NULL_VALUES
			),''[]'') as JAVASCRIPT
		')
		EXEC(@sentencia)
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
