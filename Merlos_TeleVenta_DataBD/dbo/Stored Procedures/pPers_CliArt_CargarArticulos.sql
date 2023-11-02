CREATE PROCEDURE [dbo].[pPers_CliArt_CargarArticulos] @parametros varchar(max) 
AS
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Merlos Log
insert into Merlos_Log (accion) values (CONCAT('[pPers_CliArt_CargarArticulos] ''',@parametros,''''))
-- Parámetros de Configuración
declare @Ejercicio char(4), @Gestion char(6), @Letra char(2), @Comun char(8), @Lotes char(8), @Campos char(8), @Empresa char(2), @Anys int
select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Letra=LETRA, @Comun=COMUN, @Campos=CAMPOS, @Empresa=EMPRESA, @Anys=ANYS from [Configuracion_SQL]
--------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN TRY
	declare @ClienteCodigo varchar(50)			= isnull((select JSON_VALUE(@parametros,'$.ClienteCodigo')),'')
		
		, 	@currentUserId varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserId')),'')
		, 	@currentReference varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentReference')),'')
		, 	@currentUserLogin varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserLogin')),'')
		, 	@currentRole varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentRole')),'')
		,	@currentUserFullName varchar(255)	= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserFullName')),'')

		, 	@error varchar(max)
		, 	@respuesta varchar(max)

		set @respuesta = (select * from Clientes_Articulos where Cliente=@ClienteCodigo and IncluirExcluir not in (0,3) for JSON AUTO, include_null_values)

		select CONCAT('{"error":"',ISNULL(@error,''),'","respuesta":',ISNULL(@respuesta,'{}'),'}') as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(MAX)
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","accion":"',@parametros,'","mensaje":"',replace(ERROR_MESSAGE(),'"','-'),'"}')
	DECLARE @ErrorSeverity INT = 50001;  -- rango válido de 50000 a 2147483647
    THROW @ErrorSeverity, @ErrorMessage, 1;
	insert into Merlos_Log (accion, error, Usuario) values (concat(OBJECT_NAME(@@PROCID),' ',@parametros,''''), @ErrorMessage, @currentUserLogin)
	select @ErrorMessage as JAVASCRIPT
	RETURN 0
END CATCH