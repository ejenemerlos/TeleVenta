CREATE PROCEDURE [dbo].[pDameNumPedido] @serie char(2),  @codigo char(10)='' output
AS 
BEGIN TRY
	declare @GESTION char(6)
	declare @COMUN char(8)
	declare @empresa char(2)
	declare @estado bit
	
	select @GESTION=GESTION, @COMUN=COMUN, @empresa=EMPRESA from Configuracion_SQL 

	-- Obtener número según los contadores de Eurowin
	declare @tbDato TABLE (estado bit)
	INSERT @tbDato EXEC('SELECT estado FROM ['+@COMUN+'].dbo.OPCEMP WHERE tipo_opc = 9003 AND empresa='''+@empresa+'''')	
	select @estado=estado FROM @tbDato
	delete @tbDato

    IF @estado=1 BEGIN 
		declare @tbCodigoE1 TABLE (contador char(10))
		INSERT @tbCodigoE1 EXEC('SELECT CAST(isnull(contador,0)+1 as varchar) FROM ['+@GESTION+'].[dbo].series WHERE tipodoc = 2 AND empresa='''+@EMPRESA+''' AND serie='''+@serie+'''')	
		select @codigo=contador FROM @tbCodigoE1
		delete @tbCodigoE1
		
		set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))
		EXEC ('UPDATE ['+@GESTION+'].[dbo].series SET contador=cast('''+@codigo+''' as int) WHERE tipodoc=2 AND empresa='''+@EMPRESA+''' AND serie='''+@serie+''' ')
	END	ELSE BEGIN 
		declare @tbCodigo TABLE (contador char(10))
		INSERT @tbCodigo EXEC('SELECT cast(isnull(pediven,0)+1 as varchar) FROM ['+@GESTION+'].[dbo].empresa WHERE codigo='''+@EMPRESA+'''')	
		SELECT @codigo=contador FROM @tbCodigo		
		delete @tbCodigo
		set @codigo=space(10-len(ltrim(rtrim(@codigo))))+ltrim(rtrim(@codigo))
		EXEC('UPDATE ['+@GESTION+'].[dbo].empresa SET pediven=cast('''+@codigo+''' as int) WHERE codigo='''+@EMPRESA+''' ')
	END

	-- Verificar que el número obtenido no se encuentra en ninguna de las tablas.
	if exists (select NUMERO from [2023CT].dbo.c_pedive where EMPRESA=@empresa and NUMERO=@codigo and LETRA=@serie)
	or exists (select * from Temp_Pedido_Cabecera where empresa=@empresa and ltrim(rtrim(numero))=ltrim(rtrim(@codigo)) and letra=@serie)
	BEGIN set @codigo='' END

	RETURN -1
END TRY
BEGIN CATCH 
    RETURN 0
END CATCH