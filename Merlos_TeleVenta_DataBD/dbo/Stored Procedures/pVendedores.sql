

-- ===========================================================
--	Author:			Elías Jené
--	Create date:	27/05/2019
--	Description:	Obtener Listado de Vendedores
-- ===========================================================

-- exec [pVendedores] 'anyadir','01','22'

CREATE PROCEDURE [dbo].[pVendedores] @modo varchar(50)='lista', @cod varchar(50)='', @vnd varchar(50)='', @usuario varchar(10)='', @rol varchar(50)=''
AS
BEGIN TRY
	DECLARE   @codigo	char(20)
			, @nombre char(30)
			, @movil varchar(50)
			, @email varchar(50)
			, @respuesta varchar(max) = ''
	
	 IF @modo='lista' BEGIN
		if @rol='MI_User_RUTA' BEGIN
			DECLARE CURCLI CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
			select CODIGO as codigo, NOMBRE as nombre, TELEFON as movil, EMAIL as email 
			from vVendedores where CODIGO in (select VENDEDOR from vVentasArticulos where RUTA=@usuario)
		END ELSE BEGIN
			DECLARE CURCLI CURSOR READ_ONLY FAST_FORWARD FORWARD_ONLY FOR 
			select CODIGO as codigo, NOMBRE as nombre, TELEFON as movil, EMAIL as email from vVendedores
		END

		OPEN CURCLI
			FETCH NEXT FROM CURCLI INTO @codigo, @nombre, @movil, @email
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @respuesta = @respuesta + '{"codigo":"'+@codigo+'","nombre":"'+@nombre+'","movil":"'+@movil+'","email":"'+@email+'"}'
				FETCH NEXT FROM CURCLI INTO @codigo, @nombre, @movil, @email
			END	
		CLOSE CURCLI deallocate CURCLI
		SELECT '{"vendedores":[' + replace(isnull(@respuesta,''),'}{','},{') + ']}' AS JAVASCRIPT
	END

	else IF @modo='subvendedores' BEGIN
		SELECT isnull((
			select CODIGO as codigo,NOMBRE as  nombre from vVendedores 
			where CODIGO in (select SubVendedor collate Modern_Spanish_CI_AI from VendSubVend where Vendedor=@cod)
			for JSON PATH,ROOT('vendedores')
		),'{"vendedores":[]}') as JAVASCRIPT
	END

	else IF @modo='anyadir' BEGIN 
		if not exists (select * from [dbo].[VendSubVend] where Vendedor=@cod and SubVendedor=@vnd) BEGIN
			insert into [VendSubVend] (Vendedor, SubVendedor) values (@cod,@vnd)
		END
	END

	else IF @modo='anyadirTodos' BEGIN 
		delete from [VendSubVend] where Vendedor=@cod
		insert into [VendSubVend] (Vendedor, SubVendedor) select @cod, CODIGO from vVendedores where CODIGO<>@cod
	END

	else IF @modo='eliminar' BEGIN delete from [dbo].[VendSubVend] where Vendedor=@cod and SubVendedor=@vnd END

	else IF @modo='eliminarTodos' BEGIN delete from [VendSubVend] where Vendedor=@cod END
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
