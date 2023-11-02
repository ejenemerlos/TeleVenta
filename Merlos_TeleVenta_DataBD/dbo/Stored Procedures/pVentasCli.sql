

-- ===========================================================
--	Author:			Elías Jené
--	Create date:	20/09/2019
--	Description:	Obtener Listado de Agencias
-- ===========================================================

-- exec [pVentasCli] 'lista'

CREATE PROCEDURE [dbo].[pVentasCli]	  @modo varchar(50)='lista'
									, @usuario varchar(50)
									, @empresa varchar(10)='01'
									, @rol varchar(50)
									, @cliente varchar(20)=''
									, @articulo char(15)=''
									, @fINI varchar(10)=''
									, @fFIN varchar(10)=''
									, @esVendedor int = 0
AS
BEGIN TRY	
	DECLARE   @respuesta varchar(max) = ''
			, @elWhere varchar(max) = ' where CODIGO<>'''' '

			, @fecha smalldatetime
			, @codigo char(12)
			, @nCliente varchar(80)			
			, @nArticulo varchar(50)
			, @unidades numeric(15,6)
			, @importe numeric(15,6)

	if @cliente<>'' and @cliente is not null  begin set @elWhere = @elWhere + ' and CODIGO='''+@cliente+'''' end
	
	if @rol='Cliente' begin set @elWhere = @elWhere + ' and CODIGO='''+@usuario+'''' end
	if @rol='Vendedor' and (@cliente='' or @cliente is null) begin set @elWhere =  @elWhere + ' and VENDEDOR='''+@usuario+'''' end
	if @rol='MI_User_ruta' and (@cliente='' or @cliente is null) begin set @elWhere = @elWhere + 'and CODIGO in (select CODIGO from vClientes where RUTA='''+@usuario+''')' end
	if (@rol='VerTodosLosClientes' or @rol='Admins') and (@cliente='' or @cliente is null) begin set @elWhere = ' where CODIGO<>'''' ' end

	if @articulo<>'' and @articulo is not null begin set @elWhere = @elWhere + ' and ARTICULO='''+@articulo+'''' end
	if @fINI<>'' and @fINI is not null begin set @elWhere = @elWhere + ' and cast(FECHA as smalldatetime)>='''+@fINI+'''' end
	if @fFIN<>'' and @ffin is not null begin set @elWhere = @elWhere + ' and cast(FECHA as smalldatetime)<='''+@fFIN+'''' end
	
	declare @sentencia varchar(max) = '
										select FECHA as fecha
										, CODIGO as cliente, NOMBRE_CLIENTE as nCliente, ARTICULO as articulo, NOMBRE_ART as nArticulo
										, UNIDADES as unidades, CAJAS as cajas, PESO as peso, IMPORTE as importe
										from vVentasCli '+@elWhere+' and EMPRESA='''+@empresa+''' order by IMPORTE DESC
										'

	if @rol='MapaMarca' begin
		set @sentencia = 'select v.FECHA as fecha
		, v.CODIGO as cliente, v.NOMBRE_CLIENTE as nCliente, v.ARTICULO as articulo, v.NOMBRE_ART as nArticulo
		, v.UNIDADES as unidades, v.IMPORTE as importe, v.CAJAS as cajas, v.PESO as peso
		from vVentasCli v
		inner join vArticulos art on art.codigo collate Modern_Spanish_CI_AI=v.ARTICULO and art.marca='''+@usuario+'''
		where cast(v.FECHA as smalldatetime)>='''+@fINI+''' and cast(v.FECHA as smalldatetime)<='''+@fFIN+''' and v.EMPRESA='''+@empresa+'''
		order by cast(v.FECHA as smalldatetime) DESC'
	END

	EXEC ('SELECT isnull(( ' + @sentencia + ' for JSON PATH, ROOT(''ventas'')	),''{"ventas":[]}'') AS JAVASCRIPT')
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
