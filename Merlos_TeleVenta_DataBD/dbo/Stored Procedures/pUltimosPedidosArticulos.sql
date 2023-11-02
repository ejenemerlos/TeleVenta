
CREATE PROCEDURE [dbo].[pUltimosPedidosArticulos] @cliente varchar(50)
AS
BEGIN TRY		
	declare @meses int = (select MesesConsumo from Configuracion_SQL)
	declare @f smalldatetime = dateadd(month,-@meses,getdate())
	declare @fecha varchar(10) = convert(varchar(10),@f,103)

	-- Parámetros de Configuración
	declare @Ejercicio char(4), @Gestion char(6), @Letra char(2), @Comun char(8), @Lotes char(8), @Campos char(8), @Empresa char(2), @Anys int
	select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Letra=LETRA, @Comun=COMUN, @Campos=CAMPOS, @Empresa=EMPRESA, @Anys=ANYS from [Configuracion_SQL]
	
	declare @sentencia varchar(max) = ''

	set @sentencia = '
		select (
			select dpv.ARTICULO
			, art.NOMBRE
			, MAX(cpv.FECHA) as FECHA
			, MAX(cpv.NUMERO) as NUMERO
			, SUM(dpv.IMPORTE) as IMPORTE
			from ['+@Gestion+'].dbo.d_albven dpv
			inner join ['+@Gestion+'].dbo.c_albven cpv on concat(cpv.EMPRESA,cpv.NUMERO,cpv.LETRA)=concat(dpv.EMPRESA,dpv.NUMERO,dpv.LETRA)
			left  join vArticulos art on art.CODIGO collate Modern_Spanish_CI_AI=dpv.ARTICULO		
			where dpv.Cliente='''+@cliente+''' and cpv.FECHA>='''+@fecha+'''
			group by dpv.ARTICULO, art.NOMBRE
			order by FECHA DESC, dpv.ARTICULO desc		
			for JSON AUTO
		) as JAVASCRIPT
	'
	EXEC(@sentencia)

	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
