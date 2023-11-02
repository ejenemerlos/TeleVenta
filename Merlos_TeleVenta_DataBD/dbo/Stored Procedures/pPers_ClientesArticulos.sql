CREATE PROCEDURE [dbo].[pPers_ClientesArticulos] @parametros varchar(max) 
AS
BEGIN TRY
	declare	@ClienteCodigo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.ClienteCodigo')),'')
		,	@articulo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		,	@incluirValor smallint = isnull((select JSON_VALUE(@parametros,'$.incluirValor')),'0')
		,	@excluirValor smallint = isnull((select JSON_VALUE(@parametros,'$.excluirValor')),'0')

		, 	@currentUserId varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserId')),'')
		, 	@currentReference varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentReference')),'')
		, 	@currentUserLogin varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserLogin')),'')
		, 	@currentRole varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentRole')),'')
		,	@currentUserFullName varchar(255)	= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserFullName')),'')

		,	@IncluirExcluir smallint=0
		,	@error varchar(max)
		, 	@respuesta varchar(max)

		if @incluirValor=1 set @IncluirExcluir=1
		if @excluirValor=1 set @IncluirExcluir=2

		if exists (select * from Clientes_Articulos where Cliente=@ClienteCodigo and Articulo=@articulo) BEGIN
			if @IncluirExcluir=0 delete Clientes_Articulos where Cliente=@ClienteCodigo and Articulo=@articulo
			else update Clientes_Articulos set IncluirExcluir=@IncluirExcluir where Cliente=@ClienteCodigo and Articulo=@articulo
		END else 
			insert into Clientes_Articulos (Cliente, Articulo, Descripcion, IncluirExcluir, Usuario) 
			values (@ClienteCodigo, @articulo, (select NOMBRE from vArticulosBasic where CODIGO=@articulo), @IncluirExcluir, @currentUserLogin)

		select CONCAT('{"error":"',ISNULL(@error,''),'","respuesta":',ISNULL(@respuesta,'{}'),'}') as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(MAX)
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","accion":"',@parametros,'","mensaje":"',replace(ERROR_MESSAGE(),'"','-'),'"}')
	DECLARE @ErrorSeverity INT = 50001;  -- rango válido de 50000 a 2147483647
    THROW @ErrorSeverity, @ErrorMessage, 1;
	insert into Merlos_Log (accion, error) values (concat(OBJECT_NAME(@@PROCID),' ',@parametros,''''), @ErrorMessage)
	select @ErrorMessage as JAVASCRIPT
	RETURN 0
END CATCH