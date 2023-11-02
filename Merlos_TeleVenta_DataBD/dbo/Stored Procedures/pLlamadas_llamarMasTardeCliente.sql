

-- =========================================================================
-- Author:		Elías Jené
-- Create date: 06-07-2023
-- Description:	Insertar el nuevo horario para la acción "Llamar más tarde"
-- =========================================================================
-- Ejemplo de llamada: 
-- [pLlamadas_llamarMasTardeCliente] '{"IdTeleVenta":"321456789","cliente":"43156884","horario":"11:55"}'
-- ======================================================================================================

CREATE PROCEDURE [dbo].[pLlamadas_llamarMasTardeCliente] @parametros varchar(max) 
AS
BEGIN TRY
	declare   @cliente varchar(20)		= isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
			, @IdTeleVenta varchar(50)	= isnull((select JSON_VALUE(@parametros,'$.IdTeleVenta')),'')
			, @horario varchar(20)		= isnull((select JSON_VALUE(@parametros,'$.horario')),'')
			
			, @UserId varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserId')),'')
			, @currentUserLogin varchar(50)	= isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserLogin')),'')
			, @currentUserFullName varchar(50) = isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentUserFullName')),'')
			, @currentReference varchar(50)	= isnull((select JSON_VALUE(@parametros,'$.paramStd[0].currentReference')),'')

			, @error varchar(max)
			, @respuesta varchar(max)

		update TeleVentaDetalle set horario=@horario where id=@IdTeleVenta and cliente=@cliente

		select '{"error":"',ISNULL(@error,''),'","respuesta":"',ISNULL(@respuesta,''),'"}' as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(MAX)
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","mensaje":"',ERROR_MESSAGE(),'"}')
	DECLARE @ErrorSeverity INT = 50001;  -- rango válido de 50000 a 2147483647
    THROW @ErrorSeverity, @ErrorMessage, 1;
	insert into Merlos_Log (error, Usuario) values (@ErrorMessage, @currentUserLogin)
	select @ErrorMessage as JAVASCRIPT
	RETURN 0
END CATCH
