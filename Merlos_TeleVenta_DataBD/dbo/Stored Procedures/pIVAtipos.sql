

CREATE PROCEDURE [dbo].[pIVAtipos] @modo char(50)=''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @iva		 varchar(20)
			, @recargo	 VARCHAR(20)
			, @respuesta VARCHAR(max) = ''

	DECLARE CRSR CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
	(select CODIGO, NOMBRE, IVA, RECARG from vIVA_Tipos)
	OPEN CRSR
		FETCH NEXT FROM CRSR INTO @codigo, @nombre, @iva, @recargo
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + '{"codigo":"'+isnull(ltrim(rtrim(@codigo)),'')+'","nombre":"'+isnull(ltrim(rtrim(@nombre)),'')+'","iva":"'+isnull(ltrim(rtrim(@iva)),'')+'","recargo":"'+isnull(ltrim(rtrim(@recargo)),'')+'"}'
			FETCH NEXT FROM CRSR INTO @codigo, @nombre, @iva, @recargo
		END	
	CLOSE CRSR deallocate CRSR	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT '{"ivatipos":[' + replace(@respuesta,'}{','},{') +']}' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
