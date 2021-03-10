CREATE PROCEDURE [dbo].[pClientesBasic]	  @usuario varchar(50)=''
										, @rol varchar(50)=''
AS
BEGIN TRY
	declare @respuesta varchar(max) = ''

	if @rol='MI_User_RUTA' BEGIN
		set @respuesta = (
		select CODIGO as codigo, replace(NOMBRE,'"','') as nombre from vClientes 
		where RUTA=@usuario order by NOMBRE asc for JSON path,root('clientes') )
	END
	ELSE BEGIN
		set @respuesta = (select CODIGO as codigo, replace(NOMBRE,'"','') as nombre 
		from vClientes order by NOMBRE asc for JSON path,root('clientes'))
	END
	
	select isnull(@respuesta,'[]') AS JAVASCRIPT

	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH