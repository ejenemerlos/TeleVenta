
-- ===========================================================
--	Author:			Elías Jené
--	Create date:	03/05/2019
--	Description:	Obtener Lineas del Pedido
-- ===========================================================

-- exec [pPedidoTotal] 'totales' , '201901      190308'

CREATE PROCEDURE [dbo].[pPedidoTotal]		@modo varchar(50),  @IDPEDIDO	varchar(8000)
AS
BEGIN TRY
	DECLARE   @sentencia varchar(max)
	
	set @sentencia = 'select  IMPORTE, 
							  case when IMPORTE>0 then 
								replace(replace(replace(convert(varchar,cast(IMPORTE as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' 
								else '''' end as BaseImpf
							, IVApc
							, IVAimp
							, case when IVAimp>0 then 
								replace(replace(replace(convert(varchar,cast(IVAimp as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' 
								else '''' end as IVAimpf
							, recargoPC
							, RECARGO
							, case when RECARGO>0 then 
								replace(replace(replace(convert(varchar,cast(RECARGO as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' 
								else '''' end as recargoIMPf
							, TOTALDOC
							, case when TOTALDOC>0 then 
								replace(replace(replace(convert(varchar,cast(TOTALDOC as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' 
								else '''' end as TOTALDOCf
							, PVERDEver  
						from vPedidos_Pie WHERE IDPEDIDO='''+@IDPEDIDO+''''
	
	exec ('select isnull(('+@sentencia+' for JSON PATH,ROOT(''totales'')),''{"totales":[]}'') AS JAVASCRIPT');

	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
