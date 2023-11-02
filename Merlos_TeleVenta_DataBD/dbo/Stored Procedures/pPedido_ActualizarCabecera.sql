
CREATE PROCEDURE [dbo].[pPedido_ActualizarCabecera] @IDPEDIDO varchar(50)
AS
BEGIN TRY

	
    DECLARE @totalped as numeric(15,6)
	DECLARE @totaldoc numeric(15, 6)
	DECLARE @peso numeric(15, 6)

	declare @ejercicio char(4) = LEFT(@IDPEDIDO,4)
	declare @letra char(2) = (select LETRA from Configuracion_SQL)
	
	SET @totalped	= isnull((SELECT sum(cast(IMPORTE as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
	SET @peso		= isnull((SELECT sum(cast(peso as numeric(15,6)))    FROM vPedidos_Detalle where IDPEDIDO=@IDPEDIDO),0)

	SET @totaldoc	= isnull((SELECT sum(cast(IMPORTE as numeric(15,6)))+sum(cast(RECARGO as numeric(15,6)))+sum(cast(impPP as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
					/*+ isnull((SELECT sum(cast(RECARGO as numeric(15,6))) FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)
					+ isnull((SELECT sum(cast(impPP as numeric(15,6)))   FROM vPedidos_Pie where IDPEDIDO=@IDPEDIDO),0)*/
	
	declare @sql varchar(max) = concat('
		UPDATE [',@ejercicio,'',@letra,'].[DBO].c_pedive 
				SET TOTALPED=''',@totalped,''',
					IMPDIVISA=''',@totalped,''',
					TOTALDOC=''',@totaldoc,''', 
					PESO=''',@peso,'''
		WHERE CONCAT(''',@ejercicio,''',EMPRESA,replace(LETRA,space(1),''0''),replace(LEFT(NUMERO,10),space(1),''0''))  
				collate Modern_Spanish_CI_AI=''',@IDPEDIDO,''' ')

	exec(@sql)

	return -1

END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= concat(
		 'Error [pPedido_ActualizarCabecera] !!!'
		, char(13), ERROR_MESSAGE()
		, char(13), ERROR_NUMBER()
		, char(13), ERROR_PROCEDURE()
		, char(13), @@PROCID
		, char(13), ERROR_LINE()
	)
	RAISERROR(@CatchError,12,1)

	declare @accion varchar(max) = CONCAT( 'ERROR SP: pPedido_ActualizarCabecera - @IdPedido: ' , @IDPEDIDO )	
	EXEC [pMerlos_LOG] @accion=@accion, @error=@CatchError

	RETURN 0
END CATCH
