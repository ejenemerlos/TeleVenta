
CREATE PROCEDURE [dbo].[pClientesBasic]	  @usuario varchar(50)=''
										, @rol varchar(50)=''
AS
BEGIN TRY
	declare @respuesta varchar(max) = ''

	if @rol='MI_User_RUTA' BEGIN
		set @respuesta = (
			select	CODIGO as codigo, ltrim(rtrim(replace(NOMBRE,'"',''))) as nombre
				,	ltrim(rtrim(replace(RCOMERCIAL,'"',''))) as nComercial
				,	ltrim(rtrim(CIF)) as CIF
				,	ltrim(rtrim(TELEFONO)) as TELEFONO
				, LTRIM(RTRIM(DIRECCION)) AS DIRECCION
				,	isnull((select ltrim(rtrim(isnull(TELEFONO,''))) as TELEFONO from vCliTelfs where CLIENTE=CODIGO and ISNULL(TELEFONO,'')<>'' for JSON AUTO, include_null_values),'[]') as TELEFONOS
			from vClientes 
			where RUTA=@usuario 
			order by NOMBRE asc 
			for JSON path,root('clientes') 
		)
	END
	ELSE BEGIN
		set @respuesta = (
			select	CODIGO as codigo, ltrim(rtrim(replace(NOMBRE,'"',''))) as nombre
				,	ltrim(rtrim(replace(RCOMERCIAL,'"',''))) as nComercial
				,	ltrim(rtrim(CIF)) as CIF
				,	ltrim(rtrim(TELEFONO)) as TELEFONO
				, LTRIM(RTRIM(DIRECCION)) AS DIRECCION
				,	isnull((select ltrim(rtrim(isnull(TELEFONO,''))) as TELEFONO from vCliTelfs where CLIENTE=CODIGO and ISNULL(TELEFONO,'')<>'' for JSON AUTO, include_null_values),'[]') as TELEFONOS
			from vClientes 
			order by NOMBRE asc 
			for JSON path,root('clientes')
		)
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
