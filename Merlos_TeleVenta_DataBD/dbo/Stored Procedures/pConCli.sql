

CREATE PROCEDURE [dbo].[pConCli] @elCliente char(8)
AS
BEGIN TRY
	DECLARE   @IDCONTACTO	varchar(100)
			, @linia		int
			, @persona		char(30)
			, @cargo		char(30)
			, @email		char(60)
			, @telefono		char(15)
			, @contador     int = 0
			, @respuesta	varchar(max) = N'{"contactos":['

	DECLARE CURCLI CURSOR FOR 
		(select IDCONTACTO, LINEA, PERSONA, CARGO, EMAIL, TELEFONO from vContactos where CLIENTE=@elCliente)
	OPEN CURCLI
		FETCH NEXT FROM CURCLI INTO @IDCONTACTO, @linia, @persona, @cargo, @email, @telefono
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @contador = @contador +1 
			set @respuesta = @respuesta + '{"IDCONTACTO":"'+@IDCONTACTO+'"'
										+ ',"CLIENTE":"'+@elCliente+'"'
										+ ',"LINIA":"'+cast(@linia as varchar)+'"'
										+ ',"PERSONA":"'+@persona+'"'
										+ ',"CARGO":"'+@cargo+'"'
										+ ',"EMAIL":"'+@email+'"'
										+ ',"TELEFONO":"'+@telefono+'"},'
			FETCH NEXT FROM CURCLI INTO @IDCONTACTO, @linia, @persona, @cargo, @email, @telefono
		END	
	CLOSE CURCLI deallocate CURCLI

	if @contador>0 set @respuesta = SUBSTRING( @respuesta,0,LEN(@respuesta) )

	set @respuesta = @respuesta + ']}';

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
