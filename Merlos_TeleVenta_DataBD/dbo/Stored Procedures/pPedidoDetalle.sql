CREATE PROCEDURE [dbo].[pPedidoDetalle] (@parametros varchar(max))
AS
BEGIN TRY
	declare @idpedido varchar(20) = (select JSON_VALUE(@parametros,'$.idpedido'))

	select isnull((select * from vPedidos_Detalle where IDPEDIDO=@idpedido for JSON AUTO),'[]') as JAVASCRIPT
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH