CREATE PROCEDURE [dbo].[pLlamadas_CambiarEstado] @parametros varchar(max) 
AS
BEGIN TRY
	declare  @cliente varchar(20) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')			
			, @IdTeleVenta varchar(50)	  = isnull((select JSON_VALUE(@parametros,'$.IdTeleVenta')),'')
			, @IdDoc varchar(50)	  = isnull((select JSON_VALUE(@parametros,'$.IdDoc')),'')		

		IF EXISTS(SELECT * FROM TeleVentaDetalle WHERE id=@IdTeleVenta AND IdDoc=@IdDoc AND completado=1 )
			UPDATE TeleVentaDetalle SET completado=0 WHERE id=@IdTeleVenta AND IdDoc=@IdDoc
		
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pLlamadas')
	RETURN 0
END CATCH