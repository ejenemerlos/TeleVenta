
CREATE PROCEDURE [dbo].[pEnUso] ( @parametros varchar(max) )
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		declare @clave varchar(100) = isnull((select JSON_VALUE(@parametros,'$.clave')),'')  
			,	@tipo varchar(100) = isnull((select JSON_VALUE(@parametros,'$.tipo')),'')  
			,	@objeto varchar(100) = isnull((select JSON_VALUE(@parametros,'$.objeto')),'')  
			,	@terminarReintento smallint = cast(isnull((select JSON_VALUE(@parametros,'$.terminarReintento')),'0') as smallint)
		
		if @terminarReintento>10 BEGIN
			delete EnUso where Objeto=@objeto
			declare @accion varchar(max) = 
			CONCAT('[pEnUso] - Reintenos fallidos! - @terminarReintento: ',@terminarReintento,' -- ejecutamos delete EnUso where Objeto=''',@objeto,'''')
			EXEC pMerlos_LOG @accion, @accion
		END
		ELSE BEGIN
		declare @spEnUso smallint=0
		if exists (select * from EnUso where Objeto=@objeto) begin set @spEnUso=1 END		
		select @spEnUso as JAVASCRIPT
		END 

		return -1
	END TRY
	BEGIN CATCH
		DECLARE @CatchError NVARCHAR(MAX)
		SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
		select CONCAT('{"error":"SP: [pEnUso] - ',@CatchError,'"}') as JAVASCRIPT
		RAISERROR(@CatchError,12,1)
		RETURN 0
	END CATCH
END
