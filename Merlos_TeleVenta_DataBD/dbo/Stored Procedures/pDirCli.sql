

-- ===========================================================
--	Author:			Elías Jené
--	Create date:	10/05/2019
--	Description:	Obtener Direcciones del Cliente
-- ===========================================================

--  exec [pDirCli] '43001310'

CREATE PROCEDURE [dbo].[pDirCli] @elCliente char(8)
AS
BEGIN TRY
	DECLARE   @ENV_CLI		int
			, @Direccion	varchar(80)
			, @respuesta	varchar(max) = ''

	DECLARE CURCLI CURSOR FOR 
		(select LINEA, DIRECCION from vDirecciones where CLIENTE=@elCliente)
	OPEN CURCLI
		FETCH NEXT FROM CURCLI INTO @ENV_CLI, @Direccion
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta + '{"Linea":"'+cast(@ENV_CLI as varchar)+'","Direccion":"'+@Direccion+'"}'
			FETCH NEXT FROM CURCLI INTO @ENV_CLI, @Direccion
		END	
	CLOSE CURCLI deallocate CURCLI

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT '{"direcciones":[' + replace(@respuesta,'}{','},{') + ']}' AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
