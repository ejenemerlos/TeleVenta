CREATE PROCEDURE [dbo].[pArticulos]	@parametros varchar(max)
AS
BEGIN TRY	
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@articulo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		,	@desde varchar(5) = isnull((select JSON_VALUE(@parametros,'$.desde')),'0')

	declare @GESTION char(6) = (select top 1 GESTION from Configuracion_SQL)

	declare @sentencia varchar(max) = ''
	declare @respuesta varchar(max) = ''
	declare @elInnerJoin varchar(500) = ''

	if @modo='buscar' BEGIN
		--	configuración ArticulosIGEST
			if (select ISNULL(valor,'') from Configuracion where nombre='ArticluosIGEST')='1' BEGIN 
				set @elInnerJoin='inner join ['+@GESTION+'].DBO.MULTICAM mc on mc.CODIGO collate Modern_Spanish_CS_AI=vArticulos.CODIGO and mc.VALOR collate Modern_Spanish_CS_AI=''.T.'' '
			END

		set @sentencia = CONCAT('
			select (
				select distinct (select count(vArticulos.CODIGO) from vArticulos '+@elInnerJoin+' where vArticulos.CODIGO like ''%',@articulo,'%'' or vArticulos.NOMBRE like ''%',@articulo,'%'' ) as registros
				, vArticulos.* 
				from vArticulos '+@elInnerJoin+'
				where vArticulos.CODIGO like ''%',@articulo,'%'' or vArticulos.NOMBRE like ''%',@articulo,'%'' 
				
				ORDER BY  vArticulos.NOMBRE  ASC 
				OFFSET ',@desde,' ROWS FETCH NEXT 100 ROWS ONLY  FOR JSON AUTO
			) as JAVASCRIPT
		')
		exec(@sentencia)
	END

	if @modo='residuo' BEGIN
		EXEC('
			select isnull(
				(select isnull(
					(select codigo, PVERDE, P_TAN, P_IMPORTE
									from ['+@GESTION+'].dbo.articulo  
									where CODIGO=@articulo
									for JSON AUTO, INCLUDE_NULL_VALUES)
				,''[{"codigo":"''+@articulo+''","PVERDE":false,"P_TAN":1,"P_IMPORTE":0.000000}]''))
			,''[]'') as JAVASCRIPT
		')
	END

	if @modo='bebidasAzucaradas' BEGIN
		set @sentencia = '
			select ltrim(rtrim(esc.COMPONENTE)) as COMPONENTE, esc.PVP, esc.UNIDADES 
			,art.codigo, art.PVERDE, art.P_TAN, art.P_IMPORTE
			from ['+@GESTION+'].dbo.articulo art 
			left join ['+@GESTION+'].dbo.escandal esc on art.CODIGO=esc.ARTICULO
			where art.CODIGO='''+@articulo+''' and art.DESGLOSE<>0
		'
		declare @TablaTemporal TABLE (COMPONENTE varchar(50), PVP numeric(15,6), UNIDADES numeric(15,6), codigo varchar(50), PVERDE bit, P_TAN int, P_IMPORTE numeric(15,6))
		INSERT @TablaTemporal EXEC(@sentencia)	
		set @respuesta = (select * from @TablaTemporal for JSON AUTO, INCLUDE_NULL_VALUES)
		delete @TablaTemporal
		
		select isnull(@respuesta,'[]') as JAVASCRIPT
	END
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH