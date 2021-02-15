CREATE PROCEDURE [dbo].[pReconfigurarElPortal]   @modo varchar(50)='reconfigurar'
AS
BEGIN TRY	
	delete Configuracion_SQL	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH