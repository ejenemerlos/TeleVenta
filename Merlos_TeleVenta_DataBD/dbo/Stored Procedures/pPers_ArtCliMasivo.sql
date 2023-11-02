CREATE PROCEDURE [dbo].[pPers_ArtCliMasivo] @parametros varchar(max) 
AS
BEGIN TRY
	declare	@Articulos varchar(max) = isnull((select JSON_VALUE(@parametros,'$.Articulos')),'')
		,	@Clientes varchar(max) = isnull((select JSON_VALUE(@parametros,'$.Clientes')),'')
		,	@eliminacion smallint = isnull((select JSON_VALUE(@parametros,'$.eliminacion')),0)

		, 	@currentUserId varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserId')),'')
		, 	@currentReference varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentReference')),'')
		, 	@currentUserLogin varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserLogin')),'')
		, 	@currentRole varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentRole')),'')
		,	@currentUserFullName varchar(255)	= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserFullName')),'')

		,	@error varchar(max)
		, 	@respuesta varchar(max)

		,	@cliente varchar(50)
		,	@articulo varchar(50)
		,	@IncluirExcluir smallint


	MERGE INTO Clientes_Articulos AS Target
	USING (
		SELECT c.cliente, a.articulo, a.IncluirExcluir
		FROM 
		(
			SELECT cliente FROM OPENJSON (@parametros, N'$.Clientes') WITH (cliente VARCHAR(200) N'$.cliente')
		) c
		, 
		(
			SELECT articulo, case when @eliminacion=1 then 0 else IncluirExcluir END as IncluirExcluir
			FROM OPENJSON (@parametros, N'$.Articulos') WITH (articulo VARCHAR(200) N'$.articulo', IncluirExcluir smallint N'$.IncluirExcluir')
		) a

	) AS Source (cliente, articulo, IncluirExcluir)
	ON (Target.cliente = Source.cliente AND Target.articulo = Source.articulo)

	WHEN MATCHED THEN
		UPDATE SET Target.IncluirExcluir = case when Source.IncluirExcluir=3 then 0 else Source.IncluirExcluir end, Usuario=@currentUserLogin

	WHEN NOT MATCHED BY TARGET THEN
		INSERT (Cliente, Articulo, Descripcion, IncluirExcluir, Usuario)
		VALUES (Source.cliente, Source.articulo, (select lTRIM(RTRIM(NOMBRE)) from vArticulosBasic where CODIGO=Source.articulo), Source.IncluirExcluir, @currentUserLogin);

	

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
