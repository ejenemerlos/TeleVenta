

CREATE PROCEDURE [dbo].[pSubFamilias] @familia char(50)=''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @respuesta VARCHAR(max) = ''

	DECLARE CRSR CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
	(select CODIGO, NOMBRE from vSubFamilias where familia=@familia)
	OPEN CRSR
		FETCH NEXT FROM CRSR INTO @codigo, @nombre
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + '{"codigo":"'+isnull(@codigo,'')+'","nombre":"'+isnull(@nombre,'')+'"}'
			FETCH NEXT FROM CRSR INTO @codigo, @nombre
		END	
	CLOSE CRSR deallocate CRSR	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT '{"subfamilias":[' + replace(@respuesta,'}{','},{') +']}' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
