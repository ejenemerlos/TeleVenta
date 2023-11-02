
CREATE PROCEDURE [dbo].[pPers_ArtCliMasivo_Articulos] @parametros varchar(max) 
AS
BEGIN TRY
	declare	@articulo varchar(100) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		,	@error varchar(max)
		, 	@respuesta varchar(max)


	set @articulo=lower(@articulo)
	if @articulo='' set @articulo='todos'
	if @articulo='todos' set @articulo=''


	set @respuesta = (			
		select  ltrim(rtrim(a.CODIGO)) as CODIGO, ltrim(rtrim(a.NOMBRE)) as NOMBRE
			,	0 as IncluirExcluir
		from vArticulosBasic a
		where lower(ltrim(rtrim(a.CODIGO))) like '%'+@articulo+'%' or lower(ltrim(rtrim(a.NOMBRE))) like '%'+@articulo+'%'
		order by a.NOMBRE ASC 
		for JSON AUTO, include_null_values
	)


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