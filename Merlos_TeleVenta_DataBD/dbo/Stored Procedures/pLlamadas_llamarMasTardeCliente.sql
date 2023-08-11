
-- =========================================================================
-- Author:		Elías Jené
-- Create date: 06-07-2023
-- Description:	Insertar el nuevo horario para la acción "Llamar más tarde"
-- =========================================================================
-- Ejemplo de llamada: 
-- [pLlamadas_llamarMasTardeCliente] '{"IdTeleVenta":"321456789","cliente":"43156884","horario":"11:55"}'
-- =========================================================================

CREATE PROCEDURE [dbo].[pLlamadas_llamarMasTardeCliente] @parametros varchar(max) 
AS
BEGIN TRY
	declare   @cliente varchar(20)		= isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
			, @IdTeleVenta varchar(50)	= isnull((select JSON_VALUE(@parametros,'$.IdTeleVenta')),'')
			, @horario varchar(20)		= isnull((select JSON_VALUE(@parametros,'$.horario')),'')

			, @error varchar(max)
			, @respuesta varchar(max)

		update TeleVentaDetalle set horario=@horario where id=@IdTeleVenta and cliente=@cliente

		select '{"error":"',ISNULL(@error,''),'","respuesta":"',ISNULL(@respuesta,''),'"}' as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH	
    -- @ErrorSeverity: Especifica el nivel de gravedad del error. Puede ser un valor de 0 a 25, 
	-- donde los niveles de gravedad de 0 a 10 se consideran información, de 11 a 16 como advertencia y de 17 a 25 como error.
    -- @ErrorMessage: Especifica el mensaje de error personalizado que se mostrará al generar el error.
    -- 1: Especifica el número de estado asociado con el error. Puedes utilizar este número de estado para proporcionar información adicional sobre el error.
	DECLARE @ErrorMessage NVARCHAR(MAX)
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","mensaje":"',ERROR_MESSAGE(),'"}')
	DECLARE @ErrorSeverity INT = 17;
    THROW @ErrorSeverity, @ErrorMessage, 1;
	select @ErrorMessage as JAVASCRIPT
	RETURN 0
END CATCH
