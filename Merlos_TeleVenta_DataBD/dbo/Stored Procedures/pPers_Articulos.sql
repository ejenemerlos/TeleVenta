CREATE PROCEDURE [dbo].[pPers_Articulos] @parametros varchar(max) 
AS
BEGIN TRY
	declare	@ClienteCodigo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.ClienteCodigo')),'')
		,	@buscar varchar(100) = isnull((select JSON_VALUE(@parametros,'$.buscar')),'')
		,	@error varchar(max)
		, 	@respuesta varchar(max)


	set @buscar=lower(@buscar)
	if @buscar='todos' set @buscar=''
	if @ClienteCodigo='todos' set @ClienteCodigo=''

	set @respuesta = (
		select  ltrim(rtrim(a.CODIGO)) as CODIGO, ltrim(rtrim(a.NOMBRE)) as NOMBRE
			,	isnull(b.IncluirExcluir,0) as IncluirExcluir
		from vArticulosBasic a
		left join Clientes_Articulos b on b.Articulo COLLATE DATABASE_DEFAULT=a.CODIGO and b.Cliente=@ClienteCodigo
		where lower(a.CODIGO) like '%'+@buscar+'%' or lower(a.NOMBRE) like '%'+@buscar+'%'
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