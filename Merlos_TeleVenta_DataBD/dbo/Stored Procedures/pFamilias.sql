
CREATE PROCEDURE [dbo].[pFamilias] @modo char(50)=''
AS
BEGIN TRY
	DECLARE   @codigo    CHAR(8)
			, @nombre    VARCHAR(80)
			, @respuesta VARCHAR(max) = '{"familias":['

	if @modo='lista' BEGIN
		DECLARE CRSR CURSOR FOR 
		(select CODIGO, NOMBRE from vFamilias)
		OPEN CRSR
			FETCH NEXT FROM CRSR INTO @codigo, @nombre
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @respuesta = @respuesta + '{"codigo":"'+@codigo+'","nombre":"'+@nombre+'"},'
				FETCH NEXT FROM CRSR INTO @codigo, @nombre
			END	
		CLOSE CRSR deallocate CRSR	

		if (select count(CODIGO) from vFamilias)>0	set @respuesta = SUBSTRING( @respuesta,0,LEN(@respuesta) ) + ']}';
		ELSE set @respuesta = @respuesta + ']}'
	END
	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH