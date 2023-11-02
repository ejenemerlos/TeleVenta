

-- ===========================================================
--	Author:			Elías Jené
--	Create date:	17/05/2019
--	Description:	Obtener Lineas del Pedido
-- ===========================================================

-- exec pPedidoLineas @modo='lista',@IDPEDIDO='201901000000190300'

CREATE PROCEDURE [dbo].[pPedidoLineas] @modo varchar(50),  @IDPEDIDO	varchar(8000)
AS
BEGIN TRY	
	-- Parámetros de Configuración
	declare @Ejercicio char(4), @Gestion char(6), @Letra char(2), @Comun char(8), @Lotes char(8), @Campos char(8), @empresa char(2), @Anys int
	select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Letra=LETRA, @Comun=COMUN, @Campos=CAMPOS, @Empresa=EMPRESA, @Anys=ANYS from [Configuracion_SQL]

	if @modo='lista' BEGIN
		DECLARE   @IDPEDIDOLIN	varchar(52)
				, @numero			varchar(20)
				, @articulo			char(15)
				, @definicion		char(75)
				, @unidades			numeric(15,6)
				, @precio			numeric(15,6)
				, @dto1				numeric(20,2)
				, @dto2				numeric(20,2)
				, @importe			numeric(15,6)
				, @tipo_iva			char(2)
				, @servidas			numeric(15,6)
				, @linia			int
				, @cliente			char(8)
				, @importeiva		numeric(15,6)
				, @unicaja			int
				, @unipeso			varchar(50)
				, @cajas			numeric(10,2)
				, @peso				numeric(20,4)
				, @contador			int = 0
				, @respuesta		varchar(max) = N'{"lineas":['

		declare @articuloLEN int

		declare @jsonTemp TABLE (js varchar(max))
		INSERT @jsonTemp 
		EXEC('select(
			Select CHARACTER_MAXIMUM_LENGTH from ['+@GESTION+'].[INFORMATION_SCHEMA].[COLUMNS] WHERE  TABLE_NAME=''articulo'' and COLUMN_NAME=''NOMBRE''
		) for JSON AUTO, INCLUDE_NULL_VALUES)')	
		SELECT @articuloLEN=JSON_VALUE((select js FROM @jsonTemp),'$[0].CHARACTER_MAXIMUM_LENGTH')		
		delete @jsonTemp

		set @numero = (select NUMERO from vPedidos where IDPEDIDO=@IDPEDIDO)

		DECLARE CURART CURSOR FOR 
			(select IDPEDIDO, IDPEDIDOLIN, empresa, numero, articulo, definicion, unidades
					, precio, dto1, dto2, importe, tipo_iva, servidas, linia, cliente
					, importeiva, cajas, servidas, peso, unicaja, unipeso
			from vPedidos_Detalle where IDPEDIDO=@IDPEDIDO)
		OPEN CURART
			FETCH NEXT FROM CURART INTO @IDPEDIDO, @IDPEDIDOLIN, @empresa, @numero, @articulo, @definicion, @unidades
										, @precio, @dto1, @dto2, @importe, @tipo_iva, @servidas, @linia, @cliente
										, @importeiva, @cajas, @servidas, @peso, @unicaja, @unipeso
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @respuesta = @respuesta + '{"IDPEDIDO":"'	+@IDPEDIDO+'"'
								+',"IDPEDIDOLIN":"'				+@IDPEDIDOLIN+'"'
								+',"empresa":"'					+@empresa+'"'
								+',"numero":"'					+@numero+'"'
								+',"articulo":"'				+@articulo+'"'
								+',"definicion":"'				+@definicion+'"'
								+',"unidades":"'				+cast(@unidades as varchar)+'"'
								+',"precio":"'					+cast(@precio as varchar)+'"'
								+',"dto1":"'					+cast(@dto1 as varchar)+'"'
								+',"dto2":"'					+cast(@dto2 as varchar)+'"'
								+',"importe":"'					+cast(@importe as varchar)+'"'
								+',"tipo_iva":"'				+@tipo_iva+'"'
								+',"servidas":"'				+cast(@servidas as varchar)+'"'
								+',"linia":"'					+cast(@linia as varchar)+'"'
								+',"cliente":"'					+@cliente+'"'
								+',"importeiva":"'				+cast(isnull(@importeiva,0) as varchar)+'"'
								+',"cajas":"'					+cast(isnull(@cajas,0) as varchar)+'"'
								+',"servidas":"'				+cast(@servidas as varchar)+'"'
								+',"peso":"'					+cast(@peso as varchar)+'"'
								+',"unicaja":"'					+cast(@unicaja as varchar)+'"'
								+',"unipeso":"'					+cast(@unipeso as varchar)+'"'
								+',"articuloMaxLen":"'	+cast(isnull(@articuloLEN,0) as varchar)+'"'
								+'},'
				FETCH NEXT FROM CURART INTO @IDPEDIDO, @IDPEDIDOLIN, @empresa, @numero, @articulo, @definicion, @unidades
										, @precio, @dto1, @dto2, @importe, @tipo_iva, @servidas, @linia, @cliente
										, @importeiva, @cajas, @servidas, @peso, @unicaja, @unipeso
			END	
		CLOSE CURART deallocate CURART

		if (select count(IDPEDIDO) from vPedidos_Detalle where IDPEDIDO=@IDPEDIDO) > 0		
			set @respuesta = SUBSTRING( @respuesta,0,LEN(@respuesta) ) + ']}';
		else set @respuesta = 'SIN_RESULTADOS'
	END

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
