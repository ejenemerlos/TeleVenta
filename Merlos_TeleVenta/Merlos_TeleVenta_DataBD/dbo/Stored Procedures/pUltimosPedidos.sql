CREATE PROCEDURE [dbo].[pUltimosPedidos]  @parametros nvarchar(max)=''
AS
BEGIN TRY		
	declare @cliente varchar(20) = (select JSON_VALUE(@parametros,'$.cliente'))

	select (select * from vPedidos where Cliente=@cliente order by sqlFecha desc for JSON AUTO) as JAVASCRIPT
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pUltimosPedidos')
	RETURN 0
END CATCH