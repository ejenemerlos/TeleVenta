/*  Si existe una instalación */
declare @GESTION char(6) = (select GESTION from Configuracion_SQL)

if @GESTION is not null and @GESTION<>'' BEGIN
	-- Vista vClientes
	IF EXISTS (select * FROM sys.views where name = 'vClientes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vClientes]
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
	exec(@Sentencia)
	select  'vClientes'
END