IF OBJECT_ID('Configuracion_SQL') IS NOT NULL BEGIN
	
	declare @GESTION char(8) = '['+(select GESTION from Configuracion_SQL)+']'
	declare @COMUN char(10) = '['+(select COMUN from Configuracion_SQL)+']'
	declare @EJERCICIO 	char(4)		 set @EJERCICIO = (select top 1 EJERCICIO from Configuracion_SQL)
	declare @EJERCICIOAnt	char(4)
	declare @Sentencia varchar(max)

	if (@GESTION is not null and @GESTION<>'') and (@COMUN is not null and @COMUN<>'') BEGIN		
		-- Vista vClientes
		IF EXISTS (select * FROM sys.views where name = 'vClientes')  set @Sentencia='ALTER' else set @Sentencia='CREATE' 
		set @Sentencia = @Sentencia + ' VIEW [dbo].[vClientes]
		AS
		SELECT C.CODIGO, 
		cast(C.CODIGO as varchar(50)) as ''Código Cliente'', 
		RTRIM(C.NOMBRE) collate database_default AS NOMBRE , C.NOMBRE2 AS RCOMERCIAL,
		C.CIF, cast(RTRIM(C.DIRECCION) as varchar(40))  collate Modern_Spanish_CI_AI  AS DIRECCION, C.CODPOST AS CP, 
		C.POBLACION  collate Modern_Spanish_CI_AI  AS POBLACION,
		C.PROVINCIA  collate Modern_Spanish_CI_AI  as provincia, ISNULL(PAIS.NOMBRE,'''') AS PAIS, 
		cast(C.EMAIL as varchar(255)) as EMAIL, 
		cast(C.EMAIL_F as varchar(255)) as EMAIL_F, 
		COALESCE(tc.TELEFONO, SPACE(15))
		AS TELEFONO, COALESCE(ct.PERSONA, SPACE(30)) AS CONTACTO, C.HTTP AS WEB, FP.NOMBRE AS N_PAG,
		C.DIAPAG AS DIA_PAG, CAST(ROUND(C.CREDITO,2) AS numeric(10,2)) AS CREDITO, COALESCE(B.BANCO,
		SPACE(30)) AS BANCO, COALESCE(B.IBAN, SPACE(4))+'' ''+COALESCE(B.CUENTAIBAN, SPACE(20)) AS IBAN,
		COALESCE(B.SWIFT, SPACE(10)) AS SWIFT, C.VENDEDOR AS VENDEDOR, v.NOMBRE as nVendedor,
		REPLACE(CONVERT(VARCHAR(MAX), 
		C.OBSERVACIO),CHAR(13),''<br/>'') AS OBSERVACIO, C.TARIFA AS TARIFA, ISNULL(FP.DIAS_RIESGO,0)AS DIAS_RIESGO, 
		C.DESCU1 AS DESCU1, C.DESCU2 AS DESCU2, C.OFERTA, C.BLOQ_CLI AS BLOQ_CLI, C.ENV_CLI,
		C.FECHA_BAJ, convert(varchar(10),C.FECHA_BAJ,103) as FechaBaja,
		case when C.FECHA_BAJ IS NULL or C.FECHA_BAJ=''1900-01-01 00:00:00'' THEN 0 ELSE 1 END AS BAJA, 
		tiva.CODIGO as tipoIVA, isnull(tiva.IVA,0) as IVA, c.AGENCIA,
		isnull(tiva.RECARG,0) as recargoIVA,
		C.RUTA, r.NOMBRE as nRuta,
		mLat.VALOR as LATITUD, mLon.VALOR as LONGITUD,
		case when 
			isnull(ca.lunes,0)=0 and isnull(ca.martes,0)=0 and isnull(ca.miercoles,0)=0 and isnull(ca.jueves,0)=0 and isnull(ca.viernes,0)=0 
			and isnull(ca.sabado,0)=0 and isnull(ca.domingo,0)=0 
		then 0 else 1 end as horarioAsignado,
' set @Sentencia = @Sentencia + '
		isnull((select * from cliente_gestor where cliente collate SQL_Latin1_General_CP1_CI_AS=C.codigo 
		for JSON AUTO,INCLUDE_NULL_VALUES),''[]'') as gestores

		, isnull(o.observaciones,'''') as ObservacionesInternas

		FROM '+@GESTION+'.DBO.CLIENTES C 
		LEFT JOIN '+@GESTION+'.dbo.telf_cli tc ON tc.CLIENTE = C.CODIGO AND tc.ORDEN = 1 
		LEFT JOIN '+@GESTION+'.dbo.CONTlf_CLI ct ON ct.CLIENTE = C.CODIGO AND ct.PREDET = 1 
		LEFT JOIN '+@GESTION+'.dbo.BANC_CLI B ON B.CLIENTE = C.CODIGO AND B.ORDEN = 1 
		LEFT JOIN '+@GESTION+'.dbo.FPAG FP    ON FP.CODIGO = C.FPAG 
		LEFT JOIN '+@GESTION+'.dbo.tipo_iva tiva ON tiva.CODIGO = C.TIPO_IVA 
		LEFT JOIN '+@COMUN+'.dbo.PAISES PAIS ON PAIS.CODIGO  = C.PAIS 
		left join '+@GESTION+'.dbo.rutas r on r.CODIGO=C.RUTA
		LEFT JOIN '+@GESTION+'.DBO.vendedor v on v.CODIGO=C.VENDEDOR
		LEFT JOIN '+@GESTION+'.DBO.multicam mLat ON mLat.CODIGO=C.CODIGO and mLat.FICHERO=''CLIENTES'' and mLat.CAMPO=''LAT''
		LEFT JOIN '+@GESTION+'.DBO.multicam mLon ON mLon.CODIGO=C.CODIGO and mLon.FICHERO=''CLIENTES'' and mLon.CAMPO=''LGT''
		LEFT JOIN clientes_adi ca on ca.cliente collate SQL_Latin1_General_CP1_CI_AS=C.CODIGO
		LEFT JOIN ObservacionesInternas o on o.cliente collate SQL_Latin1_General_CP1_CI_AS=C.CODIGO
		WHERE LEFT(C.CODIGO,3)=''430''
		'
		--exec(@Sentencia)
		



		-- Vista vArticulos 
		IF EXISTS (select * FROM sys.views where name = 'vArticulos')  set @Sentencia='ALTER' else set @Sentencia='CREATE' 
		set @Sentencia = @Sentencia+' VIEW [dbo].[vArticulos]
		as
		select replace(cast(art.CODIGO COLLATE Modern_Spanish_CI_AI as varchar(50)),space(1),'''') as CODIGO
				, replace(art.NOMBRE,''"'',''-'') COLLATE Modern_Spanish_CI_AI as NOMBRE
				, art.FAMILIA, art.MARCA, art.MINIMO
				, art.MAXIMO, art.AVISO, art.BAJA, art.INTERNET
				, art.TIPO_IVA, art.RETENCION, art.IVA_INC, art.COST_ULT1, art.PMCOM1
				, art.CARAC, art.UNICAJA, art.peso, art.litros as volumen, art.medidas, art.SUBFAMILIA, art.TIPO_PVP
				, art.COST_ESCAN,	art.TIPO_ESCAN, art.IVALOT,	art.DTO1, coalesce(pvp.pvp,0.00) as pvp
				, isnull(st.StockVirtual,0) as StockVirtual,ART.IMAGEN
		from '+@GESTION+'.[DBO].articulo art
		left join vStock st on st.ARTICULO=art.CODIGO
		left join '+@GESTION+'.dbo.pvp pvp on pvp.articulo=art.codigo 
		and pvp.tarifa collate Modern_Spanish_CS_AI=(select TarifaMinima from Configuracion_SQL)
		' 
		--exec(@Sentencia)




		-- Vista vGiros
		IF EXISTS (select * FROM sys.views where name = 'vGiros')  set @Sentencia='ALTER' else set @Sentencia='CREATE' 
		set @Sentencia = @Sentencia+' VIEW [dbo].[vGiros]
		AS
		SELECT 
			CAST(previ.PERIODO AS VARCHAR(4))+previ.empresa+CAST(previ.CLIENTE AS VARCHAR)+replace(previ.FACTURA,space(1),''0'')
			+replace(str(previ.ORDEN,4),space(1),''0'') 
			COLLATE Modern_Spanish_CI_AI as IDGIRO, 
			previ.vendedor as previVendedor,
			CAST(previ.PERIODO AS VARCHAR(4)) AS EJER, previ.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, previ.CLIENTE, 
			CAST(previ.PERIODO AS VARCHAR(4))+previ.EMPRESA+replace(CAST(previ.FACTURA AS VARCHAR(10)),
			space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, 
			previ.FACTURA AS NUMFRA, previ.ORDEN, previ.EMISION, previ.VENCIM, CAST(ROUND(previ.IMPORTE, 2) AS NUMERIC (18,2)) AS IMPORTE, 
			previ.BANCO, previ.COBRO, previ.IMPAGADO, 
			CAST(CASE WHEN previ.BANCO = '''' AND previ.COBRO IS NULL THEN 0 ELSE 1 END AS BIT) AS PAGADO,
			previ.FACTURA as ''Número'',
			convert(varchar(10), previ.EMISION, 103) as ''Fecha de emisión'',
			cast(previ.EMISION as smalldatetime) as FechaEmision,
			convert(varchar(10), previ.VENCIM, 103) as ''Fecha de vencimiento'',
			cast(previ.VENCIM as smalldatetime) as FechaVencimiento,
			previ.IMPORTE as ''Importe total'',
			case when previ.IMPORTE>0 then replace(replace(replace(convert(varchar,cast(previ.IMPORTE as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €''
			else '''' end AS ImporteTotalF, 
			vcli.NOMBRE COLLATE Modern_Spanish_CI_AI as nCliente,
			vcli.VENDEDOR,
			vcli.RUTA
		FROM '+@COMUN+'.dbo.PREVI_CL previ
		LEFT JOIN vClientes vcli on vcli.CODIGO=previ.CLIENTE
		WHERE CAST(CASE WHEN previ.BANCO = '''' AND previ.COBRO IS NULL THEN 0 ELSE 1 END AS BIT)=0  AND LEFT(previ.CLIENTE,3)=''430''
		'
		--exec(@Sentencia)




		-- Vista [vArticulosBasic]
		IF EXISTS (select * FROM sys.views where name = 'vArticulosBasic')  set @Sentencia='ALTER' else set @Sentencia='CREATE' 
		set @Sentencia = @Sentencia + ' VIEW [dbo].[vArticulosBasic]   as       
			select CODIGO, replace(NOMBRE,''"'',''-'') as NOMBRE, UNICAJA, PESO from '+@GESTION+'.[DBO].[articulo]
		'
		--exec(@Sentencia)

	

	END	
END
