﻿CREATE PROCEDURE [dbo].[pCalculosPV] (@parametros varchar(max))
AS
SET NOCOUNT ON
BEGIN TRY	
	-- Parámetros JSON
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@NUMERO varchar(20) = isnull((select JSON_VALUE(@parametros,'$.numero')),'')
		,	@LINEA varchar(20) = isnull((select JSON_VALUE(@parametros,'$.linea')),'')
		,	@LETRA char(2) = isnull((select JSON_VALUE(@parametros,'$.letra')),'')
		,	@ARTICULO varchar(50) = isnull((select JSON_VALUE(@parametros,'$.articulo')),'')
		,	@UNIDADES numeric(15,6) = cast(isnull((select JSON_VALUE(@parametros,'$.uds')),'0.00') as numeric(15,6))
		,	@PRECIO numeric(15,6) = cast(isnull((select JSON_VALUE(@parametros,'$.precio')),'0.00') as numeric(15,6))
		,	@PESO varchar(20) = isnull((select JSON_VALUE(@parametros,'$.peso')),'0.00')
		,	@TARIFA varchar(10) = isnull((select JSON_VALUE(@parametros,'$.tarifa')),'')    

	-- variables
	declare @Sentencia varchar(max) = ''
		,	@TOTALDOC numeric(15,6)
		,	@PVERDECLI bit
		,	@GESTION varchar(10)
		,	@CLIENTE varchar(20)
		,	@empresa char(2)

	select @GESTION=Gestion, @empresa=Empresa from Configuracion_SQL
	select top 1 @CLIENTE=cliente from [2022YB].dbo.c_pedive where concat(empresa,numero,letra)=concat(@empresa,@NUMERO,@LETRA) 
	
	-- Calcular Precios líneales
	set @Sentencia = '
	declare @TOTALDOC numeric(15,6), @PVERDECLI bit

	UPDATE ['+@GESTION+'].DBO.d_pedive SET
		PRECIOIVA = CASE WHEN C.IVA_INC=0 
			THEN d.PRECIO+(d.PRECIO*((IVA.IVA/100)))+(case when cli.RECARGO = 1 then d.precio*(IVA.RECARG/100) else 0.00 end)
			ELSE PRECIO
		END,
		PRECIODIV = CASE WHEN C.IVA_INC=0 
			THEN PRECIO
			ELSE d.PRECIO+(d.PRECIO*((IVA.IVA/100)))+(case when cli.RECARGO = 1 then d.precio*(IVA.RECARG/100) else 0.00 end)
		END,
		PREDIVIVA = CASE WHEN C.IVA_INC=0 
			THEN d.PRECIO+(d.PRECIO*((IVA.IVA/100)))+(case when cli.RECARGO = 1 then d.precio*(IVA.RECARG/100) else 0.00 end)
			ELSE PRECIO
		END
		FROM ['+@GESTION+'].DBO.C_PEDIVE C 
		INNER JOIN ['+@GESTION+'].DBO.d_pedive D ON D.EMPRESA=C.EMPRESA AND D.NUMERO=C.NUMERO AND D.LETRA=C.LETRA
		INNER JOIN ['+@GESTION+'].DBO.CLIENTES CLI ON CLI.CODIGO=C.CLIENTE
		INNER JOIN ['+@GESTION+'].DBO.tipo_iva IVA ON IVA.CODIGO=D.TIPO_IVA
	WHERE C.EMPRESA='''+@empresa+''' AND C.NUMERO='''+@NUMERO+''' AND C.LETRA='''+@LETRA+'''

	-- Calcular Importes lineales					
	UPDATE ['+@GESTION+'].DBO.d_pedive SET
			IMPORTE=ROUND((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIO ELSE PESO*PRECIO END)
					-((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIO ELSE PESO*PRECIO END)*(DTO1/100))
					-(((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIO ELSE PESO*PRECIO END)
					-(CASE WHEN PESO=0.00 THEN UNIDADES*PRECIO ELSE PESO*PRECIO END)*(DTO1/100))*(DTO2/100)),2),

			IMPORTEIVA=ROUND((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIOIVA ELSE PESO*PRECIOIVA END)
					-((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIOIVA ELSE PESO*PRECIOIVA END)*(DTO1/100))
					-(((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIOIVA ELSE PESO*PRECIOIVA END)
					-(CASE WHEN PESO=0.00 THEN UNIDADES*PRECIOIVA ELSE PESO*PRECIOIVA END)*(DTO1/100))*(DTO2/100)),2),

			IMPORTEDIV=ROUND((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIODIV ELSE PESO*PRECIODIV END)
					-((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIODIV ELSE PESO*PRECIODIV END)*(DTO1/100))
					-(((CASE WHEN PESO=0.00 THEN UNIDADES*PRECIODIV ELSE PESO*PRECIODIV END)
					-(CASE WHEN PESO=0.00 THEN UNIDADES*PRECIODIV ELSE PESO*PRECIODIV END)*(DTO1/100))*(DTO2/100)),2),

			IMPDIVIVA=ROUND((CASE WHEN PESO=0.00 THEN UNIDADES*PREDIVIVA ELSE PESO*PREDIVIVA END)
					-((CASE WHEN PESO=0.00 THEN UNIDADES*PREDIVIVA ELSE PESO*PREDIVIVA END)*(DTO1/100))
					-(((CASE WHEN PESO=0.00 THEN UNIDADES*PREDIVIVA ELSE PESO*PREDIVIVA END)
					-(CASE WHEN PESO=0.00 THEN UNIDADES*PREDIVIVA ELSE PESO*PREDIVIVA END)*(DTO1/100))*(DTO2/100)),2)
	WHERE EMPRESA='''+@empresa+''' AND LTRIM(RTRIM(NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND LETRA='''+@LETRA+''' 
	
	-- ACTUALIZAR PVERDE
	select @pverdecli=PVERDE from ['+@GESTION+'].dbo.clientes WHERE CODIGO='''+@CLIENTE+'''
	IF @PVERDECLI=0
			UPDATE ['+@GESTION+'].DBO.D_PEDIVE SET PVERDE=ROUND(CASE WHEN D.PESO=0.00 THEN D.UNIDADES*A.P_IMPORTE ELSE D.PESO*A.P_IMPORTE END,2)
			FROM ['+@GESTION+'].DBO.D_PEDIVE D INNER JOIN ['+@GESTION+'].DBO.ARTICULO A ON A.CODIGO=D.ARTICULO AND A.PVERDE=1
			WHERE EMPRESA='''+@empresa+'''AND LTRIM(RTRIM(NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND LETRA='''+@LETRA+'''

	-- ACTUALIZAR IMPORTES C_PEDIVE
	UPDATE ['+@GESTION+'].DBO.C_PEDIVE SET TOTALPED=D.IMPORTE, IMPDIVISA=D.IMPDIVISA, PESO=D.PESO, LITROS=D.LITROS
	FROM ['+@GESTION+'].DBO.C_PEDIVE C
	INNER JOIN (SELECT MAX(D.EMPRESA) AS EMPRESA, MAX(D.NUMERO) AS NUMERO, MAX(D.LETRA) AS LETRA, SUM(D.IMPORTE)+SUM(D.PVERDE) AS IMPORTE,
	SUM(D.IMPORTEDIV)+SUM(D.PVERDE) AS IMPDIVISA, SUM(D.IMPORTEIVA) AS IMPORTEIVA, SUM(D.PVERDE) AS PVERDE,
	SUM(CASE WHEN D.PESO!=0.00 THEN D.UNIDADES*D.COSTE ELSE D.PESO*D.UNIDADES END) AS COSTE, SUM(D.PESO) AS PESO,
	SUM(D.UNIDADES*(CAST(CASE WHEN D.PESO=0.00 THEN CASE WHEN LTRIM(RTRIM(A.LITROS))='''' THEN ''0.00'' ELSE A.LITROS END ELSE ''0.00'' END AS DECIMAL(10,2)))) AS LITROS
	FROM ['+@GESTION+'].DBO.D_PEDIVE D INNER JOIN ['+@GESTION+'].DBO.ARTICULO A ON A.CODIGO=D.ARTICULO
	WHERE D.EMPRESA='''+@empresa+''' AND LTRIM(RTRIM(D.NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND D.LETRA='''+@LETRA+''') D ON D.EMPRESA+D.NUMERO+D.LETRA=C.EMPRESA+C.NUMERO+C.LETRA
	WHERE C.EMPRESA='''+@empresa+''' AND LTRIM(RTRIM(C.NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND C.LETRA='''+@LETRA+'''  

	-- Calcular TOTALDOC
	SELECT @TOTALDOC = coalesce(CONVERT(DECIMAL(16,2),sum(totimpiva)),0.00) from (SELECT sum( (D.IMPORTE+D.PVERDE)-((D.IMPORTE+D.PVERDE)*(C.PRONTO/100)) ) +
	round( sum(( (D.IMPORTE+D.PVERDE)-((D.IMPORTE+D.PVERDE)*(C.PRONTO/100)) )*(COALESCE(IVA.IVA,0.00)/100)),2) +
	round( sum(( (D.IMPORTE+D.PVERDE)-((D.IMPORTE+D.PVERDE)*(C.PRONTO/100)) )*(CASE WHEN CLI.RECARGO=1 THEN COALESCE(IVA.RECARG,0.00)/100 ELSE 0 END)),2) as totimpiva, IVA.iva
	FROM ['+@GESTION+'].DBO.D_PEDIVE D JOIN ['+@GESTION+'].DBO.C_PEDIVE C ON D.EMPRESA=C.EMPRESA AND D.LETRA=C.LETRA AND LTRIM(RTRIM(D.NUMERO))=LTRIM(RTRIM(C.NUMERO))
	LEFT JOIN ['+@GESTION+'].DBO.TIPO_IVA IVA ON IVA.CODIGO=D.TIPO_IVA LEFT JOIN ['+@GESTION+'].DBO.CLIENTES CLI ON CLI.CODIGO=C.CLIENTE
	WHERE D.EMPRESA='''+@empresa+''' AND LTRIM(RTRIM(D.NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND D.LETRA='''+@LETRA+'''  group by c.empresa, c.numero, c.letra, IVA.iva) a 

	UPDATE ['+@GESTION+'].DBO.C_PEDIVE SET TOTALDOC=@TOTALDOC 
	WHERE EMPRESA='''+@empresa+''' AND LTRIM(RTRIM(NUMERO))=LTRIM(RTRIM('''+@NUMERO+''')) AND LETRA='''+@LETRA+'''
	'

	/**/ -- print @Sentencia return -1
	exec (@Sentencia)
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	select CONCAT('{"error":"',@CatchError,'"}') as JAVASCRIPT
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH