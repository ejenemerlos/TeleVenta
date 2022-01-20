CREATE PROCEDURE [dbo].[01_CrearVistas]
AS
SET NOCOUNT ON; 
BEGIN TRY

	-- ===========================================================
	--	Variables de configuración
		declare @LETRA	char(2)	 set @LETRA = (select top 1 LETRA from Configuracion_SQL)
		declare @GESTION	varchar(8)	 set @GESTION = '['+(select top 1 GESTION from Configuracion_SQL)+']'
		declare @CAMPOS		varchar(10)  set @CAMPOS = '['+(select top 1 isnull(CAMPOS,'xxxxxx') from Configuracion_SQL)+']'
		declare @COMUN		varchar(10)  set @COMUN = '['+(select top 1 COMUN from Configuracion_SQL)+']'
		declare @EJERCICIO 	char(4)		 set @EJERCICIO = (select top 1 EJERCICIO from Configuracion_SQL)
		declare @EMPRESA	char(2)		 set @EMPRESA   = (select top 1 EMPRESA from Configuracion_SQL)
		declare @BDENVCLI	varchar(10)	 set @BDENVCLI = 'EUROLOEE'
		declare @AlterCreate varchar(50) = 'CREATE'
		declare @NumEjer	int		 set @NumEjer   = (select top 1 ANYS from Configuracion_SQL)
		declare @controlAnys int=0
		declare @elEJER int = cast(@EJERCICIO as int)
		declare @GESTIONAnt varchar(8)
		declare @EJERCICIOAnt	char(4)
		declare @Sentencia	varchar(MAX)

	-- harold, esto es para ciertas empresas poder cambiar la creación de una vista por algo exclusivo
	-- Tomo por defecto SI EXISTE LA BASE DE DATOS EUROLOEE
		declare @NOMEMP		varchar(50)
		EXEC('select nombre into ##emp from '+@GESTION+'.[dbo].empresa where codigo='''+@EMPRESA+''' ')
		set @NOMEMP=(select nombre from ##emp)
		drop table ##emp
		select  'Empresa vistas: '+ @NOMEMP
		IF ISNULL(DB_ID(@BDENVCLI),'')=''
		begin
			set @BDENVCLI = ''
		end

	-- ======================================================================================================================
	--	Variables TOTALDOC
		--declare @totalDoc varchar(max)
		declare @tdoc int
		--24/10/2019 harold
		--esto no sirve, lo dejo para que se note una instrucción fallida que no aporta la solución real contra una que sí.
		--EXEC ('select case when exists (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = ''TOTALDOC''
		--							AND TABLE_NAME ='''+@GESTION+'.[dbo].c_presuv'')
		--							then 1 else 0 end as TOTALDOC into ##totaldoc')
		EXEC('select case when COL_LENGTH('''+@GESTION+'.dbo.c_presuv'', ''totaldoc'') is null then 0 else 1 end as totaldoc into ##totaldoc')
		set @tdoc = (select TOTALDOC from ##totaldoc)
		drop table ##totaldoc

		----23/10/2019 HAROLD, ESTO NUNCA VA A OCURRIR PORQUE LA BD ACTIVA ES LA DEL PORTAL Y INFORMATION_SCHEMA.COLUMNS TIRA DE ALLI
		--SET @tdoc=1
	-- ======================================================================================================================

	

	-- Vista vBarras
	IF EXISTS (select * FROM sys.views where name = 'vBarras')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vBarras]   as       
       select row_number() over(partition by articulo order by articulo) as linia, articulo, barras, unidades from '+@GESTION+'.[DBO].barras
	'
	exec(@Sentencia)
	select  'vBarras'




	-- Vista [vArticulosBasic]
	IF EXISTS (select * FROM sys.views where name = 'vArticulosBasic')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vArticulosBasic]   as       
		select CODIGO, replace(NOMBRE,''"'',''-'') as NOMBRE, UNICAJA, PESO from '+@GESTION+'.[DBO].articulo where BAJA=0
	'
	exec(@Sentencia)
	select 'vArticulosBasic'




	-- Vista vClientes  --  también en Script.PreDeployment1.sql
	IF EXISTS (select * FROM sys.views where name = 'vClientes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vClientes]
	AS
	SELECT C.CODIGO, 
	cast(C.CODIGO as varchar(50)) as ''Código Cliente'', 
	RTRIM(replace(C.NOMBRE,''"'',''-'')) collate database_default AS NOMBRE 
	, replace(C.NOMBRE2,''"'',''-'') AS RCOMERCIAL,
	C.CIF, cast(RTRIM(replace(C.DIRECCION,''"'',''-'')) as varchar(40))  collate Modern_Spanish_CI_AI  AS DIRECCION, C.CODPOST AS CP, 
	replace(C.POBLACION,''"'',''-'')  collate Modern_Spanish_CI_AI  AS POBLACION,
	replace(C.PROVINCIA,''"'',''-'')  collate Modern_Spanish_CI_AI  as provincia, replace(ISNULL(PAIS.NOMBRE,''''),''"'',''-'') AS PAIS, 
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
' set @Sentencia = @Sentencia + '
	case when 
		isnull(ca.lunes,0)=0 and isnull(ca.martes,0)=0 and isnull(ca.miercoles,0)=0 and isnull(ca.jueves,0)=0 and isnull(ca.viernes,0)=0 
		and isnull(ca.sabado,0)=0 and isnull(ca.domingo,0)=0 
	then 0 else 1 end as horarioAsignado,

	isnull(
		(
			select a.cliente, a.gestor, b.nombre + '' '' + isnull(b.apellidos,'''') as nombreGestor
			from cliente_gestor a 
			left join gestores b on b.codigo=a.gestor
			where a.cliente collate SQL_Latin1_General_CP1_CI_AS=C.codigo 
			for JSON AUTO,INCLUDE_NULL_VALUES
		)
	,''[]'') as gestores

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
	WHERE LEFT(C.CODIGO,2)=''43'' and C.FECHA_BAJ is null
	'
	exec(@Sentencia)
	select  'vClientes'




	-- Vista vSeries
	IF EXISTS (select * FROM sys.views where name = 'vSeries')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW vSeries
	AS
	select codigo, nombre from '+@COMUN+'.dbo.Letras
	' 
	exec(@Sentencia)
	select  'vSeries'





	-- Vista vPedidos_Pie
	IF EXISTS (select * FROM sys.views where name = 'vPedidos_Pie')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia ='
	'+@AlterCreate+' VIEW [dbo].[vPedidos_Pie] 
	AS
	SELECT 
	'''+@EJERCICIO+''' as EJER,
	('''+@EJERCICIO+'''+CAV.empresa+replace(CAV.LETRA,space(1),''0'')+replace(LEFT(CAV.NUMERO,10),space(1),''0'')) collate Modern_Spanish_CI_AI as IDPEDIDO,
	CAV.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, CAV.NUMERO, CAV.LETRA, CAV.CLIENTE, IVA.IVA as IVApc, 
	case when cli.recargo=1 then IVA.RECARG else 0 end as recargoPC, 
	ISNULL(CAV.ENTREGA,0.00) as ENTREGA,

	dav.tipo_iva, iva.IVA as porcen_iva, iva.iva,
	CASE WHEN CLI.RECARGO=1 THEN IVA.RECARG ELSE 0.00 END AS TIPO_RE, SUM(DAV.PVERDE) AS PVERDE,

	SUM(CASE WHEN DAV.IVA_INC=1 THEN DAV.IMPORTE*(1-(IVA.IVA/100)) 
		ELSE CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE 
			ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE) AS IMPORTE,

	ROUND(SUM((CASE WHEN DAV.IVA_INC=1 THEN DAV.IMPORTE*(1-(IVA.IVA/100)) 
		ELSE CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE
			ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE)*(IVA.IVA/100)),2) AS IVAimp,

	coalesce(CASE WHEN CLI.RECARGO=1 THEN round(SUM((CASE WHEN DAV.IVA_INC=1 THEN DAV.IMPORTE*(1-(IVA.RECARG/100)) 
			ELSE CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE 
				ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE)*(IVA.RECARG/100)),2) END, 0.00) AS RECARGO,

	(CAV.TOTALPED * CAV.PRONTO) / 100 as impPP,
	isnull(ent.IMPORTE,0.00) as entIMP,

	-- TOTALDOC (lo calculamos por si hay más de un IVA en el documento)
	SUM(CASE WHEN DAV.IVA_INC=1 THEN DAV.IMPORTE*(1-(IVA.IVA/100)) 
		ELSE CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE 
			ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE)+ROUND(SUM((CASE WHEN DAV.IVA_INC=1 THEN DAV.IMPORTE*(1-(IVA.IVA/100)) 
		ELSE CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE
			ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE)*(IVA.IVA/100)),2)+coalesce(CASE WHEN CLI.RECARGO=1 THEN round(SUM((CASE WHEN DAV.IVA_INC=1			THEN CASE WHEN DAV.INC_PP=0 THEN DAV.IMPORTE 
				ELSE (DAV.IMPORTE)*(1-((CAV.PRONTO/100))) END END + DAV.PVERDE)*(IVA.RECARG/100)),2) END, 0.00) as TOTALDOC,

	CAV.TOTALPED,
	isnull(CAV.PRONTO,0.00) as PRONTO,

	isnull((select max(isnull(cast(PVERDE as int),0)) from '+@GESTION+'.dbo.articulo where CODIGO in
		(select ARTICULO from '+@GESTION+'.DBO.D_PEDIVE where EMPRESA+NUMERO+LETRA=CAV.EMPRESA+CAV.NUMERO+CAV.LETRA and PVERDE>0)
	),0) as PVERDEver

	FROM '+@GESTION+'.DBO.C_PEDIVE CAV 
	INNER JOIN 
	(select EMPRESA, NUMERO, LETRA, ARTICULO, IMPORTE, TIPO_iva, 1 AS INC_PP, 0 AS IVA_INC, PVERDE 
	from '+@GESTION+'.dbo.D_PEDIVE where TIPO_IVA<>'''') 
	DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.NUMERO=CAV.NUMERO AND DAV.LETRA=CAV.LETRA 
	LEFT JOIN '+@GESTION+'.dbo.tipo_iva IVA ON IVA.CODIGO=DAV.TIPO_IVA
	INNER JOIN '+@GESTION+'.dbo.clientes CLI ON CLI.CODIGO=CAV.CLIENTE
	left join '+@GESTION+'.dbo.entre_pv ent on ent.NUMERO=CAV.NUMERO and ent.EMPRESA=CAV.EMPRESA and ent.LETRA=CAV.letra
	GROUP BY CAV.EMPRESA, CAV.NUMERO, CAV.LETRA, CAV.CLIENTE, CLI.RECARGO, IVA.IVA, IVA.RECARG, CAV.ENTREGA, ent.IMPORTE
			,CAV.TOTALDOC,CAV.PRONTO,CAV.TOTALPED,DAV.TIPO_IVA
	'
	exec (@Sentencia)
	select  'vPedidos_Pie'





	-- Vista vPedidos
	IF EXISTS (select * FROM sys.views where name = 'vPedidos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 	

	set @Sentencia = @AlterCreate+' VIEW [dbo].[vPedidos]
	AS '

	set @controlAnys = 0
	if @NumEjer>0 BEGIN
		while @controlAnys<@NumEjer BEGIN
			set @controlAnys = @controlAnys + 1
			set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
			set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
			if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
				set @Sentencia = @Sentencia +'
				SELECT   cast('''' as varchar(50)) as MODO
					, CONCAT('''+@EJERCICIOAnt+''',CAV.empresa,replace(CAV.LETRA,space(1),''0''),replace(LEFT(CAV.NUMERO,10),space(1),''0''))  collate Modern_Spanish_CI_AI as  IDPEDIDO	
					, '''+@EJERCICIOAnt+''' as EJER , CAV.EMPRESA  collate Modern_Spanish_CI_AI as EMPRESA, convert(varchar(10), CAV.ENTREGA, 103) as ENTREGA
					, CAV.LETRA + CAV.NUMERO as PEDIDO , CAV.NUMERO as numero, CAV.LETRA, CAV.FECHA as sqlFecha
					, convert(varchar(10), CAV.FECHA, 103) as FECHA
					, CAV.CLIENTE, CAV.REFERCLI, CAV.ENV_CLI as DIRECCION, CAV.CLIENTE as codCliente 			
					, CAV.USUARIO, CAV.pronto, CAV.VENDEDOR
					, ISNULL(CAST(CAV.OBSERVACIO AS VARCHAR(max)),'''') AS OBSERVACIO
					, env.DIRECCION as nDireccion, ven.nombre as nVendedor
					, replace(cli.nombre,''"'',''-'') collate Modern_Spanish_CI_AI as nCliente
					, cast(replace(cli.nombre,''"'',''-'') as varchar(100)) collate Modern_Spanish_CI_AI as NombreCliente
					, cli.RUTA
					, env.CODPOS+'' ''+env.POBLACION as Ciudad, env.PROVINCIA as Provincia
					, DAV.PRESUP as presupuesto, '''+@EJERCICIOAnt+''' + CAV.empresa + CAV.letra + DAV.PRESUP as idpresuven
					, case when TRASPASADO=1 then ''TRASPASADO''
							when FINALIZADO=1 then ''FINALIZADO''
							when CANCELADO =1 then ''CANCELADO'' 
							else ''PENDIENTE'' END 
							as ESTADO			  
					, PCN.Contacto as contacto, CON.Persona  as nContacto
					, ser.nombre as laSerie		
					, CPA.FAMILIA as EWFAMILIA, FAM.NOMBRE as FAMILIA
					, sum(isnull(cav.TOTALPED,0.00)) as TOTALPED
					, case when sum(cav.TOTALPED)>0 then 
						replace(replace(replace(convert(varchar, cast(sum(isnull(cav.TOTALPED,0)) as money),1),''.'',''_''),'','',''.''),''_'','','') +'' €''
						else '''' end as TOTALPEDformato
					, sum(isnull(cav.TOTALDOC,0.00)) as TOTALDOC
					, case when sum(cav.TOTALDOC)>0 then 
						replace(replace(replace(convert(varchar, cast(sum(isnull(cav.TOTALDOC,0)) as money),1),''.'',''_''),'','',''.''),''_'','','') +'' €''
						else '''' end as TOTALDOCformato

				FROM '+@GESTIONAnt+'.dbo.c_pedive CAV
				INNER JOIN '+@GESTIONAnt+'.dbo.clientes CLI ON CLI.CODIGO=CAV.CLIENTE
				left join  '+@GESTIONAnt+'.dbo.entre_pv ent on ent.NUMERO=CAV.NUMERO and ent.EMPRESA=CAV.EMPRESA and ent.LETRA=CAV.letra
				left join  '+@GESTIONAnt+'.dbo.env_cli env on env.cliente=cav.cliente and env.linea=cav.env_cli
				left join  '+@GESTIONAnt+'.dbo.vendedor ven on ven.codigo=cav.vendedor
				LEFT JOIN (SELECT EMPRESA, NUMERO, LETRA, LEFT(MAX(DOC_NUM),10) AS PRESUP 
							FROM '+@GESTIONAnt+'.DBO.D_PEDIVE 
							GROUP BY EMPRESA, NUMERO, LETRA) DAV 
							ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
				LEFT JOIN Pedidos_Contactos PCN ON PCN.IDPEDIDO COLLATE Modern_Spanish_CI_AI='''+@EJERCICIOAnt+'''+CAV.LETRA+CAV.NUMERO
				LEFT JOIN '+@GESTIONAnt+'.DBO.CONT_CLI CON ON CON.CLIENTE=CAV.CLIENTE AND CON.LINEA=PCN.CONTACTO
				LEFT JOIN Pedidos_Familias CPA ON CPA.EJERCICIO='''+@EJERCICIOAnt+''' COLLATE Modern_Spanish_CI_AI
							AND CPA.NUMERO COLLATE Modern_Spanish_CI_AI=CAV.NUMERO AND CPA.LETRA COLLATE Modern_Spanish_CI_AI=CAV.LETRA
				LEFT JOIN '+@GESTIONAnt+'.DBO.FAMILIAS FAM ON FAM.CODIGO=CPA.FAMILIA COLLATE Modern_Spanish_CI_AI
				LEFT JOIN vSeries ser on ser.codigo=CAV.LETRA
	
				GROUP BY  CAV.empresa, CAV.LETRA, CAV.NUMERO, CAV.EMPRESA, CAV.ENTREGA, CAV.FECHA
						, CAV.CLIENTE, CAV.REFERCLI, CAV.ENV_CLI, CAV.CLIENTE	
						, CAV.USUARIO, CAV.pronto, CAV.VENDEDOR
						, env.DIRECCION, ven.nombre, CAST(CAV.OBSERVACIO AS VARCHAR(max))
						, cli.NOMBRE
						, cli.RUTA, env.CODPOS, env.POBLACION, env.PROVINCIA, DAV.PRESUP, TRASPASADO, FINALIZADO, CANCELADO, PCN.Contacto
						, CON.Persona, ser.nombre, CPA.FAMILIA, FAM.NOMBRE
				
				UNION

				'
			end
		end
	end

	set @Sentencia = @Sentencia +'
	SELECT   cast('''' as varchar(50)) as MODO
			, CONCAT('''+@EJERCICIO+''',CAV.empresa,replace(CAV.LETRA,space(1),''0''),replace(LEFT(CAV.NUMERO,10),space(1),''0''))  collate Modern_Spanish_CI_AI as  IDPEDIDO	
			, '''+@EJERCICIO+''' as EJER , CAV.EMPRESA  collate Modern_Spanish_CI_AI as EMPRESA, convert(varchar(10), CAV.ENTREGA, 103) as ENTREGA
			, CAV.LETRA + CAV.NUMERO as PEDIDO , CAV.NUMERO as numero, CAV.LETRA, CAV.FECHA as sqlFecha
			, convert(varchar(10), CAV.FECHA, 103) as FECHA
			, CAV.CLIENTE, CAV.REFERCLI, CAV.ENV_CLI as DIRECCION, CAV.CLIENTE as codCliente 			
			, CAV.USUARIO, CAV.pronto, CAV.VENDEDOR
			, ISNULL(CAST(CAV.OBSERVACIO AS VARCHAR(max)),'''') AS OBSERVACIO
			, env.DIRECCION as nDireccion, ven.nombre as nVendedor
			, replace(cli.nombre,''"'',''-'') collate Modern_Spanish_CI_AI as nCliente
			, cast(replace(cli.nombre,''"'',''-'') as varchar(100)) collate Modern_Spanish_CI_AI as NombreCliente
			, cli.RUTA
			, env.CODPOS+'' ''+env.POBLACION as Ciudad, env.PROVINCIA as Provincia
			, DAV.PRESUP as presupuesto, '''+@EJERCICIO+''' + CAV.empresa + CAV.letra + DAV.PRESUP as idpresuven
			, case when TRASPASADO=1 then ''TRASPASADO''
				   when FINALIZADO=1 then ''FINALIZADO''
				   when CANCELADO =1 then ''CANCELADO'' 
				   else ''PENDIENTE'' END 
				   as ESTADO			  
			, PCN.Contacto as contacto, CON.Persona  as nContacto
			, ser.nombre as laSerie		
			, CPA.FAMILIA as EWFAMILIA, FAM.NOMBRE as FAMILIA
			, sum(isnull(cav.TOTALPED,0.00)) as TOTALPED
			, case when sum(cav.TOTALPED)>0 then 
				replace(replace(replace(convert(varchar, cast(sum(isnull(cav.TOTALPED,0)) as money),1),''.'',''_''),'','',''.''),''_'','','') +'' €''
				else '''' end as TOTALPEDformato
			, sum(isnull(cav.TOTALDOC,0.00)) as TOTALDOC
			, case when sum(cav.TOTALDOC)>0 then 
				replace(replace(replace(convert(varchar, cast(sum(isnull(cav.TOTALDOC,0)) as money),1),''.'',''_''),'','',''.''),''_'','','') +'' €''
				else '''' end as TOTALDOCformato

	FROM '+@GESTION+'.dbo.c_pedive CAV
	INNER JOIN '+@GESTION+'.dbo.clientes CLI ON CLI.CODIGO=CAV.CLIENTE
	left join  '+@GESTION+'.dbo.entre_pv ent on ent.NUMERO=CAV.NUMERO and ent.EMPRESA=CAV.EMPRESA and ent.LETRA=CAV.letra
	left join  '+@GESTION+'.dbo.env_cli env on env.cliente=cav.cliente and env.linea=cav.env_cli
	left join  '+@GESTION+'.dbo.vendedor ven on ven.codigo=cav.vendedor
	LEFT JOIN (SELECT EMPRESA, NUMERO, LETRA, LEFT(MAX(DOC_NUM),10) AS PRESUP 
				FROM '+@GESTION+'.DBO.D_PEDIVE 
				GROUP BY EMPRESA, NUMERO, LETRA) DAV 
				ON DAV.EMPRESA=CAV.EMPRESA AND DAV.LETRA=CAV.LETRA AND DAV.NUMERO=CAV.NUMERO
	LEFT JOIN Pedidos_Contactos PCN ON PCN.IDPEDIDO COLLATE Modern_Spanish_CI_AI='''+@EJERCICIO+'''+CAV.LETRA+CAV.NUMERO
	LEFT JOIN '+@GESTION+'.DBO.CONT_CLI CON ON CON.CLIENTE=CAV.CLIENTE AND CON.LINEA=PCN.CONTACTO
	LEFT JOIN Pedidos_Familias CPA ON CPA.EJERCICIO='''+@EJERCICIO+''' COLLATE Modern_Spanish_CI_AI
				AND CPA.NUMERO COLLATE Modern_Spanish_CI_AI=CAV.NUMERO AND CPA.LETRA COLLATE Modern_Spanish_CI_AI=CAV.LETRA
	LEFT JOIN '+@GESTION+'.DBO.FAMILIAS FAM ON FAM.CODIGO=CPA.FAMILIA COLLATE Modern_Spanish_CI_AI
	LEFT JOIN vSeries ser on ser.codigo=CAV.LETRA
	
	GROUP BY  CAV.empresa, CAV.LETRA, CAV.NUMERO, CAV.EMPRESA, CAV.ENTREGA, CAV.FECHA
			, CAV.CLIENTE, CAV.REFERCLI, CAV.ENV_CLI, CAV.CLIENTE	
			, CAV.USUARIO, CAV.pronto, CAV.VENDEDOR
			, env.DIRECCION, ven.nombre, CAST(CAV.OBSERVACIO AS VARCHAR(max))
			, cli.NOMBRE
			, cli.RUTA, env.CODPOS, env.POBLACION, env.PROVINCIA, DAV.PRESUP, TRASPASADO, FINALIZADO, CANCELADO, PCN.Contacto
			, CON.Persona, ser.nombre, CPA.FAMILIA, FAM.NOMBRE
	'
	exec(@Sentencia)
	select  'vPedidos'




	-- Vista vPedidos_Cabecera
	IF EXISTS (select * FROM sys.views where name = 'vPedidos_Cabecera')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 	
	set @Sentencia = @AlterCreate+'  VIEW [dbo].[vPedidos_Cabecera]
	AS 
	SELECT   cast('''' as varchar(50)) as MODO
			, CONCAT('''+@EJERCICIOAnt+''',CAV.empresa,replace(CAV.LETRA,space(1),''0''),replace(LEFT(CAV.NUMERO,10),space(1),''0''))  collate Modern_Spanish_CI_AI as  IDPEDIDO	
			, CAV.LETRA + CAV.NUMERO as PEDIDO , CAV.NUMERO as numero, CAV.LETRA, CAV.FECHA, CAV.FECHA as sqlFecha
			, CAV.CLIENTE

	FROM '+@GESTIONAnt+'.dbo.c_pedive CAV
	
	union
	
	SELECT   cast('''' as varchar(50)) as MODO
			, CONCAT('''+@EJERCICIO+''',CAV.empresa,replace(CAV.LETRA,space(1),''0''),replace(LEFT(CAV.NUMERO,10),space(1),''0''))  collate Modern_Spanish_CI_AI as  IDPEDIDO	
			, CAV.LETRA + CAV.NUMERO as PEDIDO , CAV.NUMERO as numero, CAV.LETRA, CAV.FECHA, CAV.FECHA as sqlFecha
			, CAV.CLIENTE

	FROM '+@GESTION+'.dbo.c_pedive CAV
	'
	exec(@Sentencia)
	select  'vPedidos'


	



	-- Vista vAHFpag
	IF EXISTS (select * FROM sys.views where name = 'vAHFpag')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vAHFpag]
	AS
	SELECT CODIGO, NOMBRE FROM '+@GESTION+'.DBO.fpag 
	'
	exec(@Sentencia)
	select  'vAHFpag'




	-- Vista vAHPortes
	IF EXISTS (select * FROM sys.views where name = 'vAHPortes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia=''+@AlterCreate+' VIEW vAHPortes AS '
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
			while @controlAnys<@NumEjer BEGIN
					set @controlAnys = @controlAnys + 1
					set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
					set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
					if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
						--26/03/2020 harold si existe el año anterior iniciamos consulta desde allí
						set @Sentencia = @Sentencia + 'SELECT '''+@EJERCICIOAnt+'''+P.empresa+P.letra+replace(P.albaran,space(1),''0'') COLLATE Modern_Spanish_CI_AI as IDPORTES, 
						'''+@EJERCICIOAnt+''' AS EJER, P.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, P.LETRA+P.ALBARAN AS ALBV, P.CLIENTE, CAST(ROUND(P.IMPORTE,2) AS NUMERIC(18,2)) AS PORTES, 
						P.TIPO_PORTE, P.INC_PP, P.IVA_INC, P.INC_FRA, P.TIPO_IVA, '''+@EJERCICIOAnt+'''+P.EMPRESA+replace(CAST(CA.FACTURA AS VARCHAR(10)),
						space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, CA.FACTURA AS NUMFRA, CA.PRONTO, 0.00 AS PVERDE
						FROM '+@GESTIONAnt+'.DBO.PORTES P
						LEFT JOIN '+@GESTIONAnt+'.DBO.C_ALBVEN CA ON CA.EMPRESA = P.EMPRESA AND CA.NUMERO = P.ALBARAN AND CA.LETRA = P.LETRA 
						WHERE CA.TRASPASADO = 0 AND LEFT(P.CLIENTE,3)=''430''
		
						UNION

						'
						end
				end
	end
	set @Sentencia = @Sentencia + '
	SELECT '''+@EJERCICIO+'''+P.empresa+P.letra+replace(P.albaran,space(1),''0'') COLLATE Modern_Spanish_CI_AI as IDPORTES, 
	'''+@EJERCICIO+''' AS EJER, P.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, P.LETRA+P.ALBARAN AS ALBV, P.CLIENTE, CAST(ROUND(P.IMPORTE,2) AS NUMERIC(18,2)) AS PORTES, 
	P.TIPO_PORTE, P.INC_PP, P.IVA_INC, P.INC_FRA, P.TIPO_IVA, '''+@EJERCICIO+'''+P.EMPRESA+replace(CAST(CA.FACTURA AS VARCHAR(10)),
	space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, CA.FACTURA AS NUMFRA, CA.PRONTO, 0.00 AS PVERDE
	FROM '+@GESTION+'.DBO.PORTES P
	LEFT JOIN '+@GESTION+'.DBO.C_ALBVEN CA ON CA.EMPRESA = P.EMPRESA AND CA.NUMERO = P.ALBARAN AND CA.LETRA = P.LETRA 
	WHERE CA.TRASPASADO = 0 AND LEFT(P.CLIENTE,3)=''430''
	'
	exec(@Sentencia)
	select  'vAHPortes'





	-- Vista vAlmacenes
	IF EXISTS (select * FROM sys.views where name = 'vAlmacenes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW vAlmacenes 
	AS
	SELECT CODIGO, NOMBRE FROM '+@GESTION+'.DBO.Almacen
	'
	exec(@Sentencia)
	select  'vAlmacenes'




	-- Vista vStock
	IF EXISTS (select * FROM sys.views where name = 'vStock')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vStock]
	as
	SELECT S.ALMACEN+S.ARTICULO+S.COLOR+S.EMPRESA+S.TALLA as IDALMACEN
			, S.ALMACEN,S.ARTICULO,S.EMPRESA
			, S.FINAL-COALESCE(PV.UNIDADES,0.00) AS FINAL
			, alm.nombre as nAlmacen
			, art.nombre as nArticulo
			, case 
				when (select sum(isnull(FINAL,0)) from '+@GESTION+'.DBO.stocks2 where ARTICULO=art.CODIGO) > 0 then ''EN STOCK'' 
				when (select sum(isnull(FINAL,0)) from '+@GESTION+'.DBO.stocks2 where ARTICULO=art.CODIGO) = 0 then ''SIN STOCK'' 
				when (select sum(isnull(FINAL,0)) from '+@GESTION+'.DBO.stocks2 where ARTICULO=art.CODIGO) < 0 then ''STOCK PEDIDO'' 
			END as elStock

			, (select
				(((art.COST_ULT1) * (iva.IVA) / 100) + (art.COST_ULT1))								-- precio con iva	
				+ (((((art.COST_ULT1)	* (iva.IVA) / 100)+ (art.COST_ULT1)) * (iva.RECARG)) / 100)	-- recargo IVA
				+ (((art.COST_ULT1) * (iva.IVA) / 100) + (art.COST_ULT1))							-- precio + IVA + RECARGO 
			) as elPrecio, 

			(select ISNULL(SUM(FINAL),0) from '+@GESTION+'.dbo.stocks2 where ARTICULO=art.CODIGO) as cantStock ,

			(select ISNULL(SUM(dpv.UNIDADES),0) FROM '+@GESTION+'.[DBO].c_pedico cpv inner join '+@GESTION+'.[DBO].d_pedico dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)
			-(select ISNULL(SUM(dpv.SERVIDAS),0) FROM '+@GESTION+'.[DBO].c_pedico cpv inner join '+@GESTION+'.[DBO].d_pedico dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)         
			as PteEntrar,

			(select ISNULL(SUM(dpv.UNIDADES),0) FROM '+@GESTION+'.[DBO].c_pedive cpv inner join '+@GESTION+'.[DBO].d_pedive dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero and dpv.letra=cpv.letra where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)
			-(select ISNULL(SUM(dpv.SERVIDAS),0) FROM '+@GESTION+'.[DBO].c_pedive cpv inner join '+@GESTION+'.[DBO].d_pedive dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero and dpv.letra=cpv.letra where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)          
			as PteSalir, 

			((select ISNULL(SUM(FINAL),0)     from '+@GESTION+'.dbo.stocks2        where ARTICULO=art.CODIGO and ALMACEN=alm.CODIGO)
			-((select ISNULL(SUM(dpv.UNIDADES),0) FROM '+@GESTION+'.[DBO].c_pedive cpv inner join '+@GESTION+'.[DBO].d_pedive dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero and dpv.letra=cpv.letra where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)
			-(select ISNULL(SUM(dpv.SERVIDAS),0)  FROM '+@GESTION+'.[DBO].c_pedive cpv inner join '+@GESTION+'.[DBO].d_pedive dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero and dpv.letra=cpv.letra where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)))
			+((select ISNULL(SUM(dpv.UNIDADES),0) FROM '+@GESTION+'.[DBO].c_pedico cpv inner join '+@GESTION+'.[DBO].d_pedico dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0)
			-(select ISNULL(SUM(dpv.SERVIDAS),0)  FROM '+@GESTION+'.[DBO].c_pedico cpv inner join '+@GESTION+'.[DBO].d_pedico dpv on dpv.empresa=cpv.empresa and dpv.numero=cpv.numero where dpv.ARTICULO=art.CODIGO and cpv.TRASPASado=0 and cpv.cancelado=0))
			as StockVirtual

	FROM '+@GESTION+'.[dbo].[stocks2] S 

	LEFT  JOIN (
					SELECT DPV.ARTICULO, SUM(DPV.UNIDADES-DPV.SERVIDAS) AS UNIDADES 
					FROM '+@GESTION+'.[dbo].C_PEDIVE CPV 			
					INNER JOIN '+@GESTION+'.[dbo].D_PEDIVE DPV ON DPV.EMPRESA=CPV.EMPRESA AND DPV.NUMERO=CPV.NUMERO AND DPV.LETRA=CPV.LETRA 
					WHERE CPV.CANCELADO=0 AND CPV.TRASPASADO=0 AND DPV.ESTADO=''RESERVADO'' 
					GROUP BY DPV.ARTICULO
				) PV ON PV.ARTICULO=S.ARTICULO

	LEFT  JOIN '+@GESTION+'.[dbo].Almacen  alm on alm.codigo=S.almacen
	LEFT  JOIN '+@GESTION+'.[dbo].Articulo art on art.codigo=S.articulo
	left  join '+@GESTION+'.[DBO].tipo_iva iva  on  iva.CODIGO=art.tipo_iva
	'
	exec(@Sentencia)
	select  'vStock'




	-- Vista vArticulos  --  también en Script.PreDeployment1.sql
	IF EXISTS (select * FROM sys.views where name = 'vArticulos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vArticulos]
	as
	select replace(cast(art.CODIGO COLLATE Modern_Spanish_CI_AI as varchar(50)),space(1),'''') as CODIGO
			, replace(art.NOMBRE,''"'',''-'') COLLATE Modern_Spanish_CI_AI as NOMBRE
			, art.FAMILIA, art.MARCA, art.MINIMO
			, art.MAXIMO, art.AVISO, art.BAJA, art.INTERNET
			, art.TIPO_IVA, art.RETENCION, art.IVA_INC, art.COST_ULT1, art.PMCOM1
			, art.CARAC, art.UNICAJA, art.peso, art.litros as volumen, art.medidas, art.SUBFAMILIA, art.TIPO_PVP
			, art.COST_ESCAN,	art.TIPO_ESCAN, art.IVALOT,	art.DTO1, coalesce(pvp.pvp,0.00) as pvp
			, isnull(SUM(st.StockVirtual),0) as StockVirtual
	from '+@GESTION+'.[DBO].articulo art
	left join vStock st on st.ARTICULO=art.CODIGO
	left join '+@GESTION+'.dbo.pvp pvp on pvp.articulo=art.codigo 
	and pvp.tarifa collate Modern_Spanish_CS_AI=(select TarifaMinima from Configuracion_SQL)
	where art.BAJA=0
	group by art.CODIGO, art.NOMBRE
			, art.FAMILIA, art.MARCA, art.MINIMO
			, art.MAXIMO, art.AVISO, art.BAJA, art.INTERNET
			, art.TIPO_IVA, art.RETENCION, art.IVA_INC, art.COST_ULT1, art.PMCOM1
			, art.CARAC, art.UNICAJA, art.peso, art.litros, art.medidas, art.SUBFAMILIA, art.TIPO_PVP
			, art.COST_ESCAN,	art.TIPO_ESCAN, art.IVALOT,	art.DTO1,pvp.pvp
	' 
	exec(@Sentencia)
	select  'vArticulos'




	-- Vista vArticulosCompradores
	IF EXISTS (select * FROM sys.views where name = 'vArticulosCompradores')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vArticulosCompradores]
	as
	select	a.ARTICULO, a.COMPRADOR, b.CODIGO, replace(b.NOMBRE,''"'',''-'') as NOMBRE 
	from '+@GESTION+'.[DBO].art_comp a
	inner join '+@GESTION+'.[DBO].comprado b on b.CODIGO=a.COMPRADOR
	'
	exec (@Sentencia)
	select  'vArticulosCompradores'


	-- Vista vConfigEW
	IF EXISTS (select * FROM sys.views where name = 'vConfigEW')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vConfigEW]
	as
	select e.codigo as EMPRESA, coalesce(o1.estado,0) as series , coalesce(o1.estado,0) as TallCol, 
	coalesce(fa1.cajas,0) as cajas, coalesce(fl.peso,0) as peso, coalesce(fa2.valbdtos,0) as dtos 
	from '+@GESTION+' .dbo.empresa e 
	left join '+@COMUN+'.[DBO].opcemp o1 on o1.empresa=e.codigo and o1.TIPO_OPC=''9003''
	left join '+@COMUN+'.[DBO].opcemp o2 on o2.empresa=e.codigo and o2.TIPO_OPC=''9004''
	left join '+@GESTION+'.[DBO].factucnf fa1 on fa1.empresa=e.codigo
	left join '+@GESTION+'.[DBO].flags fl on fl.empresa=e.codigo
	left join '+@GESTION+'.[DBO].factucnf fa2 on fa2.empresa=e.codigo
	'
	exec(@Sentencia)	
	select  'vConfigEW'


	-- Vista vContactos
	IF EXISTS (select * FROM sys.views where name = 'vContactos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vContactos]
	AS
	SELECT CAST(CC.CLIENTE AS VARCHAR)+Replace(str(CAST(CC.LINEA AS VARCHAR),4),space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDCONTACTO, 
	CC.CLIENTE, COALESCE(replace(CLI.NOMBRE,''"'',''-''), SPACE(80)) AS N_CLIENTE, CC.LINEA, CC.PERSONA, CC.CARGO, CC.EMAIL, CC.TELEFONO, CC.ORDEN
	FROM '+@GESTION+'.DBO.CONT_CLI CC
	LEFT JOIN '+@GESTION+'.dbo.CLIENTES CLI ON CLI.CODIGO = CC.CLIENTE
	WHERE (CC.PERSONA <>'''' OR CC.EMAIL <> '''') AND LEFT(CC.CLIENTE,3)=''430''
	'
	exec(@Sentencia)
	select  'vContactos'


	-- Vista vCuotas
	IF EXISTS (select * FROM sys.views where name = 'vCuotas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vCuotas]
	AS
	SELECT 
	CU.empresa+CAST(CU.CLIENTE AS VARCHAR)+replace(str(CU.linea,4),space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDCUOTA, 
	CU.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, CU.CLIENTE, CU.LINEA, CU.CONCEPTO, CU.DESCRIPCIO, 
	CAST(ROUND(CU.IMPORTE,2) AS NUMERIC(18,2)) AS IMPORTE, 
	case when CAST(ROUND(CU.IMPORTE,2) AS NUMERIC(18,2))>0 then replace(replace(replace(convert(varchar,cast(CAST(ROUND(CU.IMPORTE,2) AS NUMERIC(18,2)) as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €''
		else '''' end AS Importe_F, 
	CU.FECHA_INI, 
	CU.FECHA_FIN, 
	CONVERT(VARCHAR(10) , CU.FECHA_INI , 103) AS F_INI, 	
	CONVERT(VARCHAR(10), COALESCE(CAST(CU.FECHA_FIN AS SMALLDATETIME),''31-12-2029''), 103) AS F_FIN, 
	CU.TIPO, (CASE CU.TIPO WHEN 1 THEN ''MENSUAL'' WHEN 2 THEN ''BIMENSUAL'' WHEN 3 THEN ''TRIMESTRAL'' WHEN 4 THEN ''SEMESTRAL'' ELSE ''OTROS'' END) AS N_TIPO, 
	CAST(COALESCE(ENE/ENE,0) AS BIT) AS ENERO, CAST(COALESCE(FEB/FEB,0) AS BIT) AS FEBRERO, CAST(COALESCE(MAR/MAR,0) AS BIT) AS MARZO, 
	CAST(COALESCE(ABR/ABR,0) AS BIT) AS ABRIL, CAST(COALESCE(MAY/MAY,0) AS BIT) AS MAYO, CAST(COALESCE(JUN/JUN,0) AS BIT) AS JUNIO, 
	CAST(COALESCE(JUL/JUL,0) AS BIT) AS JULIO, CAST(COALESCE(AGO/AGO,0) AS BIT) AS AGOSTO, CAST(COALESCE(SEP/SEP,0) AS BIT) AS SEPTIEMBRE, 
	CAST(COALESCE(OCT/OCT,0) AS BIT) AS OCTUBRE, CAST(COALESCE(NOV/NOV,0) AS BIT) AS NOVIEMBRE, CAST(COALESCE(DIC/DIC,0) AS BIT) AS DICIEMBRE,
	vcli.NOMBRE as nCliente,
	vcli.VENDEDOR,
	vcli.RUTA
	FROM '+@COMUN+'.dbo.CUOTAS CU
	LEFT JOIN (SELECT EMPRESA, CLIENTE, LINEA, ENE, FEB, MAR, ABR, MAY, JUN, JUL, AGO, SEP, OCT, NOV, DIC
		FROM
		(SELECT EMPRESA, CLIENTE, LINEA, MES, SUBSTRING(''ENE FEB MAR ABR MAY JUN JUL AGO SEP OCT NOV DIC'', (MES * 4) - 3, 3) AS N_MES
			FROM '+@COMUN+'.dbo.CUO_MES
	) AS C PIVOT  (MAX(MES) FOR [N_MES] IN ([ENE], [FEB], [MAR], [ABR], [MAY], [JUN], [JUL], [AGO], [SEP], [OCT], [NOV], [DIC])) AS PVT
	) AS M ON M.EMPRESA=CU.EMPRESA AND M.CLIENTE=CU.CLIENTE AND M.LINEA=CU.LINEA
	LEFT JOIN vClientes vcli on vcli.CODIGO=CU.CLIENTE
	WHERE COALESCE(CU.FECHA_FIN,'' 31-12-2029 '')>GETDATE() AND CU.FECHA_INI<GETDATE()
	'
	exec(@Sentencia)
	select  'vCuotas'


	-- Vista vDatosEmpresa
	IF EXISTS (select * FROM sys.views where name = 'vDatosEmpresa')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vDatosEmpresa]
	AS
	SELECT E.CODIGO collate Modern_Spanish_CI_AI as CODIGO, 
	RTRIM(LTRIM(E.NOMBRE)) collate Modern_Spanish_CI_AI as NOMBRE, RTRIM(LTRIM(E.NOMBRE2)) AS NOMBRE2, RTRIM(LTRIM(E.CIF)) AS CIF, 
	RTRIM(LTRIM(E.DIRECCION)) AS DIRECCION, RTRIM(LTRIM(E.CODPOS)) AS CODPOS, RTRIM(LTRIM(E.POBLACION)) AS POBLACION, 
	RTRIM(LTRIM(E.PROVINCIA)) AS PROVINCIA, RTRIM(LTRIM(E.TELEFONO)) AS TELEFONO, RTRIM(LTRIM(E.FAX)) AS FAX, 
	RTRIM(LTRIM(E.MOBIL)) AS MOBIL, RTRIM(LTRIM(E.EMAIL)) AS EMAIL, RTRIM(LTRIM(E.[HTTP])) AS WEB, 
	RTRIM(LTRIM(E.TXTFACTU1)) AS TXTFACTU1, RTRIM(LTRIM(E.TXTFACTU2)) AS TXTFACTU2, e.logo, e.almacen, f.tarifapret, f.DIAS_ENTRE, E.LETRA
	FROM '+@GESTION+'.DBO.EMPRESA E  
	LEFT JOIN '+@GESTION+'.DBO.FACTUCNF F ON F.EMPRESA=E.CODIGO
	'
	exec(@Sentencia)
	select  'vDatosEmpresa'


	-- Vista vDirecciones
	IF EXISTS (select * FROM sys.views where name = 'vDirecciones')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vDirecciones]
	as
	SELECT CAST(EC.CLIENTE AS VARCHAR)+Replace(str(CAST(EC.LINEA AS VARCHAR),4),space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDDIRECCION, 
	cast('''' as varchar(50)) as MODO,
	EC.CLIENTE, EC.LINEA, EC.NOMBRE, RTRIM(EC.DIRECCION) COLLATE Modern_Spanish_CI_AI AS DIRECCION, EC.CODPOS, EC.POBLACION, EC.PROVINCIA, 
	EC.TELEFONO, EC.FAX, EC.HORARIO, EC.TIPO, 
	(CASE WHEN CLI.ENV_CLI = EC.LINEA THEN ''FISCAL'' WHEN EC.TIPO = 2 THEN ''FACTURACION'' WHEN EC.TIPO = 3 THEN ''ENVIOS'' WHEN EC.TIPO = 4 THEN ''REMESA'' WHEN EC.TIPO = 5 THEN ''COMUNICADOS'' ELSE ''OTROS'' END) AS N_TIPO
	FROM '+@GESTION+'.DBO.ENV_CLI EC
	LEFT JOIN '+@GESTION+'.DBO.CLIENTES CLI ON  EC.CLIENTE = CLI.CODIGO
	WHERE EC.CLIENTE <> '''' AND (EC.DIRECCION <>'''' OR EC.CODPOS <> '''' OR EC.POBLACION <> '''') AND LEFT(EC.cliente,3)=''430''
	'
	exec(@Sentencia)
	select  'vDirecciones'



	-- Vista vFacturas_Datos
	IF EXISTS (select * FROM sys.views where name = 'vFacturas_Datos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia=''+@AlterCreate+' VIEW [dbo].[vFacturas_Datos] AS '
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
		while @controlAnys<@NumEjer BEGIN
			set @controlAnys = @controlAnys + 1
			set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
			set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
			if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
				--26/03/2020 harold si existe el año anterior iniciamos consulta desde allí
				set @Sentencia = @Sentencia + 'SELECT CAST(previ.PERIODO AS VARCHAR(4))+previ.empresa+CAST(previ.CLIENTE AS VARCHAR)+replace(previ.FACTURA,space(1),''0'')
					+replace(str(previ.ORDEN,4),space(1),''0'') COLLATE Modern_Spanish_CI_AI as IDGIRO, CAST(previ.PERIODO AS VARCHAR(4)) AS EJER, 
					previ.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, previ.CLIENTE, CAST(previ.PERIODO AS VARCHAR(4))+previ.EMPRESA+replace(CAST(previ.FACTURA AS VARCHAR(10)),
					space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, previ.FACTURA AS NUMFRA, previ.ORDEN, previ.EMISION, previ.VENCIM, 
					CAST(ROUND(previ.IMPORTE, 2) AS NUMERIC (18,2)) AS IMPORTE, previ.BANCO, previ.COBRO, previ.IMPAGADO, 
					CAST(CASE WHEN previ.BANCO = '''' AND previ.COBRO IS NULL THEN 0 ELSE 1 END AS BIT) AS PAGADO,
					previ.FACTURA as ''Número'',
					convert(varchar(10), previ.EMISION, 103) as ''Fecha de emisión'',
					convert(varchar(10), previ.VENCIM, 103) as ''Fecha de vencimiento'',
					previ.IMPORTE as ''Importe total'',
					vcli.NOMBRE as nCliente,
					ca.bultos
				FROM '+@COMUN+'.dbo.PREVI_CL previ
				LEFT JOIN vClientes vcli on vcli.CODIGO=previ.CLIENTE
				left join (select ca.empresa, ca.factura, sum(convert(numeric(10,5),ee.bultos)) as bultos 
				from '+@GESTIONAnt+'.dbo.c_albven ca 
				inner join '+@GESTIONAnt+'.dbo.envioeti ee on ee.empresa=ca.empresa and ee.numero=ca.numero and ee.letra=ca.letra 
				where ca.factura!='''' group by ca.empresa, ca.factura) ca on ca.empresa=previ.empresa and ca.factura=previ.factura
				WHERE LEFT(previ.CLIENTE,3)=''430''
						
				UNION

				'
			end
		end
	end 


	set @Sentencia = @Sentencia + '
		SELECT CAST(previ.PERIODO AS VARCHAR(4))+previ.empresa+CAST(previ.CLIENTE AS VARCHAR)+replace(previ.FACTURA,space(1),''0'')
			+replace(str(previ.ORDEN,4),space(1),''0'') COLLATE Modern_Spanish_CI_AI as IDGIRO, CAST(previ.PERIODO AS VARCHAR(4)) AS EJER, 
			previ.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, previ.CLIENTE, CAST(previ.PERIODO AS VARCHAR(4))+previ.EMPRESA+replace(CAST(previ.FACTURA AS VARCHAR(10)),
			space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, previ.FACTURA AS NUMFRA, previ.ORDEN, previ.EMISION, previ.VENCIM, 
			CAST(ROUND(previ.IMPORTE, 2) AS NUMERIC (18,2)) AS IMPORTE, previ.BANCO, previ.COBRO, previ.IMPAGADO, 
			CAST(CASE WHEN previ.BANCO = '''' AND previ.COBRO IS NULL THEN 0 ELSE 1 END AS BIT) AS PAGADO,
			previ.FACTURA as ''Número'',
			convert(varchar(10), previ.EMISION, 103) as ''Fecha de emisión'',
			convert(varchar(10), previ.VENCIM, 103) as ''Fecha de vencimiento'',
			previ.IMPORTE as ''Importe total'',
			vcli.NOMBRE as nCliente,
			ca.bultos
		FROM '+@COMUN+'.dbo.PREVI_CL previ
		LEFT JOIN vClientes vcli on vcli.CODIGO=previ.CLIENTE
		left join (select ca.empresa, ca.factura, sum(convert(numeric(10,5),ee.bultos)) as bultos from 
		'+@GESTION+'.dbo.c_albven ca 
		inner join '+@GESTION+'.dbo.envioeti ee on ee.empresa=ca.empresa and ee.numero=ca.numero and ee.letra=ca.letra 
		where ca.factura!='''' group by ca.empresa, ca.factura) ca on ca.empresa=previ.empresa and ca.factura=previ.factura
		WHERE LEFT(previ.CLIENTE,3)=''430''	'
	exec (@Sentencia)
	select  'vFacturas_Datos'




	-- Vista vIVA
	IF EXISTS (select * FROM sys.views where name = 'vIVA')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia=''+@AlterCreate+' VIEW [dbo].[vIVA] AS '
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
			while @controlAnys<@NumEjer BEGIN
					set @controlAnys = @controlAnys + 1
					set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
					set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
					if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
						--26/03/2020 harold si existe el año anterior iniciamos consulta desde allí
						set @Sentencia = @Sentencia + 'SELECT '''+@EJERCICIOAnt+'''+empresa+CAST(CUENTA AS VARCHAR)+replace(NUMFRA,space(1),''0'') AS IDIVA, 
						'''+@EJERCICIOAnt+''' AS EJER, EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, CUENTA, FECHA,
						'''+@EJERCICIOAnt+'''+EMPRESA+replace(CAST(NUMFRA AS VARCHAR(10)),space(1), ''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, 
						NUMFRA AS NUMFRA, SUM(BIMPO) AS BASE, PORCEN_IVA, SUM(IVA) AS IMP_IVA, PORCEN_REC,  SUM(RECARGO) AS IMP_RECARGO,
						SUM(BIMPO)+SUM(IVA)+SUM(RECARGO) AS TOTAL
						FROM '+@GESTIONAnt+'.DBO.IVAREPER
						WHERE LEFT(CUENTA,3)=''430''
						group by EMPRESA, CUENTA, FECHA, NUMFRA, PORCEN_IVA, PORCEN_REC
						
						UNION
						
						'
						end
				end
	end 

	set @Sentencia = @Sentencia + '
	SELECT '''+@EJERCICIO+'''+empresa+CAST(CUENTA AS VARCHAR)+replace(NUMFRA,space(1),''0'') AS IDIVA, 
	'''+@EJERCICIO+''' AS EJER, EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, CUENTA, FECHA,
	'''+@EJERCICIO+'''+EMPRESA+replace(CAST(NUMFRA AS VARCHAR(10)),space(1), ''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, 
	NUMFRA AS NUMFRA, SUM(BIMPO) AS BASE, PORCEN_IVA, SUM(IVA) AS IMP_IVA, PORCEN_REC,  SUM(RECARGO) AS IMP_RECARGO,
	SUM(BIMPO)+SUM(IVA)+SUM(RECARGO) AS TOTAL
	FROM '+@GESTION+'.DBO.IVAREPER
	WHERE LEFT(CUENTA,3)=''430''
	group by EMPRESA, CUENTA, FECHA, NUMFRA, PORCEN_IVA, PORCEN_REC
	'
	exec(@Sentencia)
	select  'vIVA'




	-- Vista vFacturas
	IF EXISTS (select * FROM sys.views where name = 'vFacturas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia=''+@AlterCreate+' VIEW [dbo].[vFacturas] AS '
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
			while @controlAnys<@NumEjer BEGIN
					set @controlAnys = @controlAnys + 1
					set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
					set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
					if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
						--26/03/2020 harold si existe el año anterior iniciamos consulta desde allí
						set @Sentencia = @Sentencia + '
						select '''+@EJERCICIOAnt+'''+ca.EMPRESA+replace(CAST(ca.FACTURA AS VARCHAR(10)), space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, 
						ca.empresa collate Modern_Spanish_CI_AI as empresa, 
						case when max(ca.clifinal)='''' then max(ca.cliente) else max(ca.clifinal) end as cliente, '''+@EJERCICIOAnt+''' as ejer, ca.factura as numfra, cast(max(ca.fecha_fac) as smalldatetime) AS sqlFecha, cONVERT(VARCHAR(10),max(ca.fecha_fac),103) AS FECHA,
						case when sum(ca.TOTALDOC)>0 then replace(replace(replace(convert(varchar,cast(sum(ca.TOTALDOC) as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €'' else '''' end AS TOTALf, 
						convert(bit,min(convert(int, pr.pagado))) as pagado,
						max(replace(cl.nombre,''"'',''-'')) as nCliente, max(ca.VENDEDOR) as vendedor, max(cl.RUTA) as ruta, max(cl.DIRECCION) as Direccion, max(cl.CODPOST)  COLLATE Modern_Spanish_CI_AI + '' '' + max(cl.POBLACION) COLLATE Modern_Spanish_CI_AI as Ciudad, max(cl.PROVINCIA) as Provincia, '''' as TXTPAGADO,
						sum(ca.TOTALDOC) AS IMPORTE
						from '+@GESTIONAnt+'.dbo.c_albven ca
						inner join '+@GESTIONAnt+'.dbo.clientes cl on cl.codigo=ca.cliente
						left join (select pr.empresa, pr.factura, pr.periodo, CAST(MIN(CASE WHEN pr.BANCO = '''' AND pr.COBRO IS NULL THEN 0 ELSE 1 END) AS BIT) AS PAGADO
						FROM '+@COMUN+'.dbo.PREVI_CL pr WHERE PR.PERIODO='''+@EJERCICIOAnt+''' GROUP BY PR.EMPRESA, PR.FACTURA, PR.PERIODO) pr on pr.empresa=ca.empresa and pr.factura=ca.factura and pr.periodo='''+@EJERCICIOAnt+'''
						where ca.factura!='''' group by ca.empresa, ca.factura

						UNION

						'
						end
				end
	end 

	set @Sentencia = @Sentencia + '
		select '''+@EJERCICIO+'''+ca.EMPRESA+replace(CAST(ca.FACTURA AS VARCHAR(10)), space(1),''0'') COLLATE Modern_Spanish_CI_AI AS IDFACTURA, 
		ca.empresa collate Modern_Spanish_CI_AI as empresa, 
		case when max(ca.clifinal)='''' then max(ca.cliente) else max(ca.clifinal) end as cliente, '''+@EJERCICIO+''' as ejer, ca.factura as numfra, cast(max(ca.fecha_fac) as smalldatetime) AS sqlFecha, cONVERT(VARCHAR(10),max(ca.fecha_fac),103) AS FECHA,
		case when sum(ca.TOTALDOC)>0 then replace(replace(replace(convert(varchar,cast(sum(ca.TOTALDOC) as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €'' else '''' end AS TOTALf, 
		convert(bit,min(convert(int, pr.pagado))) as pagado,
		max(cl.nombre) as nCliente, max(ca.VENDEDOR) as vendedor, max(cl.RUTA) as ruta, max(cl.DIRECCION) as Direccion, max(cl.CODPOST)  COLLATE Modern_Spanish_CI_AI + '' '' + max(cl.POBLACION) COLLATE Modern_Spanish_CI_AI as Ciudad, max(cl.PROVINCIA) as Provincia, '''' as TXTPAGADO,
		sum(ca.TOTALDOC) AS IMPORTE
		from '+@GESTION+'.dbo.c_albven ca
		inner join '+@GESTION+'.dbo.clientes cl on cl.codigo=ca.cliente
		left join (select pr.empresa, pr.factura, pr.periodo, CAST(MIN(CASE WHEN pr.BANCO = '''' AND pr.COBRO IS NULL THEN 0 ELSE 1 END) AS BIT) AS PAGADO
		FROM '+@COMUN+'.dbo.PREVI_CL pr WHERE PR.PERIODO='''+@EJERCICIO+''' GROUP BY PR.EMPRESA, PR.FACTURA, PR.PERIODO) pr on pr.empresa=ca.empresa and pr.factura=ca.factura and pr.periodo='''+@EJERCICIO+'''
		where ca.factura!='''' group by ca.empresa, ca.factura
	'
	exec(@Sentencia)
	select  'vFacturas'




	-- Vista vFamilias
	IF EXISTS (select * FROM sys.views where name = 'vFamilias')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vFamilias]
	as
	select codigo, nombre from '+@GESTION+'.[dbo].[familias]
	'
	exec(@Sentencia)
	select  'vFamilias'




	-- Vista vGiros  --  también en Script.PreDeployment1.sql
	IF EXISTS (select * FROM sys.views where name = 'vGiros')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vGiros]
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
	exec(@Sentencia)
	select  'vGiros'



	-- Vista vMarcas
	IF EXISTS (select * FROM sys.views where name = 'vMarcas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vMarcas]
	as
	SELECT CODIGO, replace(NOMBRE,''"'',''-'') as NOMBRE, DESCUEN, TCP, MARGEN, FOTO from '+@GESTION+'.[dbo].marcas
	' 
	exec(@Sentencia)
	select  'vMarcas'




	-- Vista vMedidas 
	IF EXISTS (select * FROM sys.views where name = 'vMedidas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vMedidas]
	as
	select codigo, replace(nombre,''"'',''-'') as nombre from '+@GESTION+'.[dbo].medidas
	' 
	exec(@Sentencia)
	select  'vMedidas'




	-- Vista vOfertas
	IF EXISTS (select * FROM sys.views where name = 'vOfertas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vOfertas]
	AS
	SELECT REPLACE(TIPO+CLIENTE+ARTICULO+color+TALLA+FAMILIA+SUBFAMILIA+STR(LINEA,5),SPACE(1),'''') AS IDOFERTA,TIPO, CLIENTE, ARTICULO, color, TALLA, FAMILIA, SUBFAMILIA, MARCA, LINDES, LINEA, FECHA_IN, FECHA_FIN, UNI_INI, UNI_FIN, PVP, DTO1, DTO2, MONEDA, TARIFA
	FROM (
	SELECT ''CLIENTE'' AS TIPO, CLIENTE, ARTICULO, color, TALLA, FAMILIA, SUBFAMILIA, MARCA, '''' AS LINDES, LINIA AS LINEA, FECHA_IN, FECHA_FIN, UNI_MIN AS UNI_INI, (CASE WHEN UNI_MAX=0 THEN 999999.99 ELSE UNI_MAX END) AS UNI_FIN, PVP, DTO1, DTO2, MONEDA, '''' AS TARIFA FROM '+@GESTION+'.DBO.DESCUEN
	UNION 
	SELECT ''ARTICULO'' AS TIPO, '''' AS CLIENTE, ARTICULO, color, talla, '''' AS FAMILIA, '''' AS SUBFAMILIA, '''' AS MARCA, '''' AS  LINDES, LINEA, FECHA_IN, FECHA_FIN , DESDE AS UNI_INI, (CASE WHEN HASTA=0 THEN 999999.99 ELSE HASTA END) AS UD_FIN, PVP, DESCUENTO AS DTO1, 0 AS DTO2, MONEDA, TARIFA FROM '+@GESTION+'.DBO.OFERTAS
	UNION 
	SELECT ''LINDESC'' AS TIPO, C.CODIGO AS CLIENTE, D.ARTICULO, SPACE(6) AS COLOR, SPACE(8) AS TALLA, D.FAMILIA, D.SUBFAMILIA, D.MARCA, D.CODIGO AS LINDES, D.LINEA, D.FECHA_IN, D.FECHA_FIN, D.UNI_INI, D.UNI_FIN, D.PVP, D.DTO1, D.DTO2, D.MONEDA, '''' AS TARIFA FROM '+@GESTION+'.DBO.CLIENTES C INNER JOIN '+@GESTION+'.DBO.LIN_DESC D ON D.CODIGO=C.LIN_DES
	) O 
	'
	exec(@Sentencia)
	select  'vOfertas'




	-- Vista vPaises
	IF EXISTS (select * FROM sys.views where name = 'vPaises')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vPaises
	AS
	select * from '+@COMUN+'.dbo.paises
	'
	exec(@Sentencia)
	select  'vPaises'





	-- Vista vVendedores
	IF EXISTS (select * FROM sys.views where name = 'vVendedores')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vVendedores
	AS
	SELECT	v.CODIGO, v.NOMBRE, v.MOBIL, v.TELEFON, v.EMPRESA AS EMAIL
	FROM '+@GESTION+'.DBO.vendedor v

	'
	exec(@Sentencia)
	select  'vVendedores'




	-- Vista vPedidos_Detalle
	IF EXISTS (select * FROM sys.views where name = 'vPedidos_Detalle')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = '
	'+@AlterCreate+' VIEW [dbo].[vPedidos_Detalle]
	AS
	SELECT '''+@EJERCICIO+''' + D.empresa + cast(D.letra as char(2)) + D.numero + CAST(D.linia as varchar) AS IDPEDIDOLIN, 
	CONCAT('''+@EJERCICIO+''',D.empresa,replace(D.LETRA,space(1),''0''),replace(LEFT(D.NUMERO,10),space(1),''0''))  collate Modern_Spanish_CI_AI AS IDPEDIDO, 
	'''+@EJERCICIO+''' AS EJER, cast(D.letra as char(2))+d.numero as PEDIDO, D.CLIENTE, D.ARTICULO, D.DEFINICION, D.UNIDADES, D.cajas, 
	isnull(D.PRECIO,0.00) as PRECIO,  
	case when D.PRECIO>0 then 
		replace(replace(replace(convert(varchar, cast(D.PRECIO as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' else '''' end as PRECIOf, 
	isnull(D.importe,0.00) as IMPORTE, 
	case when D.importe>0 then 
		replace(replace(replace(convert(varchar, cast(D.importe as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' else '''' end as IMPORTEf,  
	D.TIPO_IVA, COALESCE(iva.iva, 0) AS TPCIVA,  
	CAST(ROUND(D.IMPORTE*COALESCE(iva.iva, 0)*0.01,2) AS NUMERIC(18,2)) AS IVA, D.SERVIDAS, D.LINIA, D.DTO1, D.DTO2
	, D.EMPRESA collate Modern_Spanish_CI_AI as EMPRESA, 
	D.importeiva AS IMPORTEIVA, 
	isnull(D.PESO,0.00) as PESO, 
	case when D.PESO>0 then 
		replace(replace(replace(convert(varchar, cast(D.PESO as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' else '''' end as PESOf,
	D.NUMERO, cast(D.letra as char(2)) as LETRA,
	art.UNICAJA, art.peso as unipeso, D.PVERDE,
	case when D.PVERDE>0 then 
		replace(replace(replace(convert(varchar, cast(D.PVERDE as money),1),''.'',''_''),'','',''.''),''_'','','')+'' €'' else '''' end as PVERDEf,
	isnull(cast(art.PVERDE as int),0) as PVERDEver
	FROM '+@GESTION+'.DBO.D_PEDIVE D
	LEFT JOIN '+@GESTION+'.dbo.tipo_iva iva ON D.tipo_iva=iva.codigo
	LEFT JOIN '+@GESTION+'.dbo.articulo art ON art.CODIGO=D.ARTICULO
	WHERE LEFT(D.CLIENTE,3)=''430''
	'
	exec(@Sentencia) 
	select  'vPedidos_Detalle'




	-- Vista vPvP
	IF EXISTS (select * FROM sys.views where name = 'vPvP')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = @AlterCreate +' VIEW vPvP
	as
	SELECT tarifa+articulo as idpvp, articulo, tarifa, pvp, pvpiva
	FROM '+@GESTION+'.dbo.pvp
	'
	exec(@Sentencia)
	select  'vPvP'	




	-- Vista vSubFamilias
	IF EXISTS (select * FROM sys.views where name = 'vSubFamilias')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vSubFamilias
	AS
	select codigo, nombre, familia from '+@GESTION+'.[dbo].subfam
	'
	exec(@Sentencia)
	select  'vSubFamilias'




	-- Vista vTarifas
	IF EXISTS (select * FROM sys.views where name = 'vTarifas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vTarifas
	AS
	select CODIGO, NOMBRE from '+@GESTION+'.[DBO].tarifas
	'
	exec(@Sentencia)
	select  'vTarifas'




	-- Vista vTipoIVA
	IF EXISTS (select * FROM sys.views where name = 'vTipoIVA')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vTipoIVA
	AS
	select CODIGO, NOMBRE from '+@GESTION+'.[DBO].tipo_iva
	'
	exec(@Sentencia)
	select  'vTipoIVA'
	



	-- Vista [vAgencias]
	IF EXISTS (select * FROM sys.views where name = 'vAgencias')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia ='
	'+@AlterCreate+' VIEW [dbo].[vAgencias] AS
	select CODIGO, NOMBRE from '+@GESTION+'.dbo.agencia
	'
	exec (@Sentencia)
	select  'vAgencias'




	-- Vista vEnUso
	IF EXISTS (select * FROM sys.views where name = 'vEnUso')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW vEnUso
	AS
	select Tipo, Clave, Ts, Usuario, Terminal from '+@COMUN+'.dbo.en_uso
	'
	exec(@Sentencia)
	select  'vEnUso'




	-- Vista vIVA_Tipos
	IF EXISTS (select * FROM sys.views where name = 'vIVA_Tipos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	set @Sentencia = ''+@AlterCreate+' VIEW [dbo].[vIVA_Tipos] as
		select CODIGO, NOMBRE,IVA, RECARG from '+@GESTION+'.DBO.tipo_iva
	'
	exec(@Sentencia)
	select  'vIVA_Tipos'	


	-- Vista vListVentas
	IF EXISTS (select * FROM sys.views where name = 'vListVentas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vListVentas] as 	
		SELECT 
		replace(
				CONCAT(CAV.EMPRESA collate Modern_Spanish_CI_AI 
				, CAV.NUMERO collate Modern_Spanish_CI_AI 
				, CAV.LETRA collate Modern_Spanish_CI_AI 
				, CAV.VENDEDOR collate Modern_Spanish_CI_AI 
				, CAV.CLIENTE collate Modern_Spanish_CI_AI 
				, DAV.ARTICULO collate Modern_Spanish_CI_AI 
		),space(1),'''') as IdListVenta,
		CAV.EMPRESA, CAV.NUMERO, CAV.LETRA, CAV.FECHA, CAV.VENDEDOR, VEN.NOMBRE AS N_VENDEDOR, CAV.CLIENTE, CLI.NOMBRE AS N_CLIENTE, 
		DAV.ARTICULO, DAV.DEFINICION, DAV.CAJAS, DAV.PESO, DAV.UNIDADES, isnull(DAV.IMPORTE,0) as IMPORTE 
		FROM '+@GESTION+'.DBO.C_ALBVEN CAV 
		INNER JOIN '+@GESTION+'.DBO.D_ALBVEN DAV ON DAV.EMPRESA=CAV.EMPRESA AND DAV.NUMERO=CAV.NUMERO AND DAV.LETRA=CAV.LETRA 
		LEFT  JOIN '+@GESTION+'.DBO.VENDEDOR VEN ON VEN.CODIGO=CAV.VENDEDOR 
		LEFT  JOIN'+@GESTION+'.DBO.CLIENTES CLI ON CLI.CODIGO=CAV.CLIENTE WHERE DAV.ARTICULO!=''''
	'
	exec(@Sentencia)
	select  'vListVentas'




-- Vista vLlamadas
	IF EXISTS (select * FROM sys.views where name = 'vLlamadas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = ''+@AlterCreate+' VIEW [dbo].[vLlamadas] as 	
	select 
		 adi.[cliente],adi.[lunes],adi.[hora_lunes],adi.[martes],adi.[hora_martes],adi.[miercoles],adi.[hora_miercoles]
		,adi.[jueves],adi.[hora_jueves],adi.[viernes],adi.[hora_viernes],adi.[sabado],adi.[hora_sabado],adi.[domingo],adi.[hora_domingo]
		,adi.[tipo_llama],adi.[dias_period]

		,a.[usuario],a.[fecha],a.[cliente] as aCliente,a.[hora],a.[llamada],a.[incidencia],a.[observa],a.[idpedido],a.[pedido]
		, isnull(a.[completado],0) as completado
		, case when a.completado=1 then ''COMPLETADO'' else ''PENDIENTE'' end as nCompletado 

		, replace(cli.NOMBRE,''"'',''-'') as NOMBRE

	from clientes_adi adi
	left join llamadas a on adi.cliente=a.cliente and a.fecha=cast(getdate() as date)
	inner join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=adi.cliente
	'
	exec(@Sentencia)
	select 'vLlamadas'	




	-- Vista vAlbaranes
	IF EXISTS (select * FROM sys.views where name = 'vAlbaranes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia=''+@AlterCreate+' VIEW [dbo].[vAlbaranes]	as '
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
		while @controlAnys<@NumEjer BEGIN
				set @controlAnys = @controlAnys + 1
				set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
				set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
				if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
					set @Sentencia = @Sentencia + '
					SELECT '''+@EJERCICIOAnt+'''+CA.EMPRESA+REPLACE(CA.letra,SPACE(1),''0'')+REPLACE(CA.NUMERO, SPACE(1), ''0'') COLLATE Modern_Spanish_CI_AI AS IDALBARAN
					, CA.CLIENTE
					, CA.FECHA as sqlFecha
					, convert(varchar(10),CA.FECHA,103) as FECHA, ltrim(rtrim(CA.NUMERO)) as NUMERO
					FROM '+@GESTIONAnt+'.DBO.C_ALBVEN CA 
					WHERE CA.TRASPASADO = 0 AND LEFT(CA.CLIENTE,3)=''430''
		
					UNION 

					'
					end
			end
	end

	set @Sentencia = @Sentencia + '
	SELECT '''+@EJERCICIO+'''+CA.EMPRESA+REPLACE(CA.letra,SPACE(1),''0'')+REPLACE(CA.NUMERO, SPACE(1), ''0'') COLLATE Modern_Spanish_CI_AI AS IDALBARAN
		, CA.CLIENTE
		, CA.FECHA as sqlFecha
		, convert(varchar(10),CA.FECHA,103) as FECHA, ltrim(rtrim(CA.NUMERO)) as NUMERO
		FROM '+@GESTION+'.DBO.C_ALBVEN CA 
		WHERE CA.TRASPASADO = 0 AND LEFT(CA.CLIENTE,3)=''430''
	'
	exec (@Sentencia)
	select  'vAlbaranes'


	-- Vista vAlbaranes_Detalle
	IF EXISTS (select * FROM sys.views where name = 'vAlbaranes_Detalle')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 

	--SV 202002257 Harold agregar el periodo anterior
	set @Sentencia = ''+@AlterCreate+' VIEW [dbo].[vAlbaranes_Detalle] AS'
	-- 09/07/2020 - Elías Jené: añadir según número de años seleccionados
	set @controlAnys = 0
	if @NumEjer>0 BEGIN
			while @controlAnys<@NumEjer BEGIN
					set @controlAnys = @controlAnys + 1
					set @GESTIONAnt = CONCAT('[',@elEJER-@controlAnys,@LETRA,']')   
					set @EJERCICIOAnt =  CAST(@elEJER-@controlAnys  as varchar(4))
					if DB_ID(replace(replace(@GESTIONAnt,'[',''),']','')) is not null BEGIN
						set @Sentencia = @Sentencia + '
						SELECT 
						'''+@EJERCICIOAnt+'''+D.empresa+replace(D.letra,space(1),''0'')+replace(D.numero, space(1), ''0'') COLLATE Modern_Spanish_CI_AI as IDALBARAN, 
						C.LETRA+D.NUMERO AS ALBARAN, C.FECHA, D.ARTICULO, 
						D.DEFINICION, D.UNIDADES, D.CAJAS, D.PESO, D.DTO1,
						case when D.IMPORTE<>0 then replace(replace(replace(convert(varchar,cast(D.IMPORTE as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €'' 
						else '''' end  AS IMPORTEf, d.PRECIOIVA 
						FROM '+@GESTIONAnt+'.DBO.D_ALBVEN D
						INNER JOIN '+@GESTIONAnt+'.dbo.C_ALBVEN C ON D.EMPRESA = C.EMPRESA AND D.LETRA = C.LETRA AND D.NUMERO = C.NUMERO
						WHERE C.TRASPASADO = 0 AND LEFT(D.CLIENTE,3)=''430''
						
						UNION 

						'
						end
				end
	end

	set @Sentencia = @Sentencia + '
	SELECT 
	'''+@EJERCICIO+'''+D.empresa+replace(D.letra,space(1),''0'')+replace(D.numero, space(1), ''0'') COLLATE Modern_Spanish_CI_AI as IDALBARAN, 
	C.LETRA+D.NUMERO AS ALBARAN, C.FECHA, D.ARTICULO, 
	D.DEFINICION, D.UNIDADES, D.CAJAS, D.PESO, D.DTO1,
	case when D.IMPORTE<>0 then replace(replace(replace(convert(varchar,cast(D.IMPORTE as money),1), ''.'', ''_''), '','', ''.''),''_'','','')+'' €'' 
	else '''' end  AS IMPORTEf, d.PRECIOIVA 
	FROM '+@GESTION+'.DBO.D_ALBVEN D
	INNER JOIN '+@GESTION+'.dbo.C_ALBVEN C ON D.EMPRESA = C.EMPRESA AND D.LETRA = C.LETRA AND D.NUMERO = C.NUMERO
	WHERE C.TRASPASADO = 0 AND LEFT(D.CLIENTE,3)=''430''
	'
	exec(@Sentencia)
	select  'vAlbaranes_Detalle'




	-- Vista vRutas
	IF EXISTS (select * FROM sys.views where name = 'vRutas')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vRutas] as 
	select CODIGO, NOMBRE from '+@GESTION+'.dbo.rutas
	'
	exec(@Sentencia)
	select  'vRutas'




	-- Vista vGestores
	IF EXISTS (select * FROM sys.views where name = 'vGestores')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vGestores] as 	
	  select distinct gestor as CODIGO, nombreGestor as NOMBRE from cliente_gestor
	'
	exec(@Sentencia)
	select  'vGestores'




	-- Vista vCliTelfs
	IF EXISTS (select * FROM sys.views where name = 'vCliTelfs')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vCliTelfs] as 	
		select CLIENTE, PERSONA, CARGO, TELEFONO from '+@GESTION+'.dbo.cont_cli
		UNION
		select CLIENTE, '''' as PERSONA, '''' as CARGO, TELEFONO from '+@GESTION+'.dbo.telf_cli
	'
	exec(@Sentencia)
	select  'vCliTelfs'




	-- Vista vIncidenciasArticulos
	IF EXISTS (select * FROM sys.views where name = 'vIncidenciasArticulos')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vIncidenciasArticulos] as 	
		select i.* 
		, i.FechaInsertUpdate as Fecha
		, convert(varchar(10),i.FechaInsertUpdate,103) as laFecha
		, g.nombre as nGestor
		, ia.nombre as nIncidencia
		, cli.nombre as nCliente
		, cpv.LETRA+''-''+ltrim(rtrim(cpv.NUMERO)) as pedido
		, art.NOMBRE as nArticulo
		from TeleVentaIncidencias i
		left join gestores g on g.codigo=i.gestor
		left join inci_art ia on ia.codigo=i.incidencia
		left join vClientes cli on cli.CODIGO  collate Modern_Spanish_CS_AI=i.cliente
		left join vPedidos cpv on cpv.IDPEDIDO collate Modern_Spanish_CS_AI=i.idpedido
		left join vArticulos art on art.CODIGO collate Modern_Spanish_CS_AI=i.articulo
		where i.tipo=''Articulo''
	'
	exec(@Sentencia)
	select  'NombreVista'




	-- Vista vIncidenciasClientes
	IF EXISTS (select * FROM sys.views where name = 'vIncidenciasClientes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	set @Sentencia = @AlterCreate+' VIEW [dbo].[vIncidenciasClientes] as 	
	select i.* 
			, i.FechaInsertUpdate as Fecha
			, convert(varchar(10),i.FechaInsertUpdate,103) as laFecha
			, g.NOMBRE as nGestor
			, cli.NOMBRE as nCliente
			, icli.nombre as nIncidencia
			, cpv.LETRA+''-''+ltrim(rtrim(cpv.NUMERO)) as pedido
	from TeleVentaIncidencias i
	left join vGestores g on g.CODIGO=i.gestor
	left join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=i.cliente
	left join inci_cli icli on icli.codigo=i.incidencia
	left join vPedidos cpv on cpv.IDPEDIDO collate Modern_Spanish_CS_AI=i.idpedido
	where i.tipo=''Cliente''
	'
	exec(@Sentencia)
	select  'NombreVista'


	
	
	-- Vista vVacacionesClientes
	IF EXISTS (select * FROM sys.views where name = 'vVacacionesClientes')  set @AlterCreate='ALTER' else set @AlterCreate='CREATE' 
	EXEC( @AlterCreate+' view vVacacionesClientes
	as
	select * from '+@GESTION+'.dbo.vaca_cli
	')
	select  'vVacacionesClientes'



	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH