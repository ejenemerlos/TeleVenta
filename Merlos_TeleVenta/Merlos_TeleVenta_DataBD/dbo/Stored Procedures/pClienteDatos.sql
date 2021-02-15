CREATE PROCEDURE [dbo].[pClienteDatos]  (@parametros varchar(max))  
AS
BEGIN TRY	
	declare @cliente varchar(50) = isnull((select JSON_VALUE(@parametros,'$.cliente')),'')
		  , @gestor varchar(50) = isnull((select JSON_VALUE(@parametros,'$.gestor')),'')
		  , @nGestor varchar(100) = isnull((select JSON_VALUE(@parametros,'$.nGestor')),'')
		  , @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		  , @FechaTeleVenta varchar(10) = isnull((select JSON_VALUE(@parametros,'$.FechaTeleVenta')),'')

	if @modo = 'verTodosLosTelfs' BEGIN
		select (select * from [dbo].[vCliTelfs] where CLIENTE=@cliente for JSON AUTO) as JAVASCRIPT
		RETURN -1
	END

	if @modo = 'asignarGestor' BEGIN
		if exists (select * from cliente_gestor where cliente=@cliente)
		update cliente_gestor set cliente=@cliente, gestor=@gestor, nombreGestor=@nGestor where cliente=@cliente
		else insert into cliente_gestor (cliente, gestor, nombreGestor) values (@cliente, @gestor, @nGestor)
	END

	if @modo = 'quitarGestor' BEGIN
		delete cliente_gestor where cliente=@cliente
	END
	
	if @modo = 'datos'
		select (select cli.CODIGO
		, (select count(cliente) from llamadas where cliente collate SQL_Latin1_General_CP1_CI_AS=cli.CODIGO) as numLlamadas
		, (select count(pedido)  from vPedidos where CLIENTE collate SQL_Latin1_General_CP1_CI_AS=cli.CODIGO) as numPedidos
		, (select sum(TOTALDOC)  from vPedidos where CLIENTE collate SQL_Latin1_General_CP1_CI_AS=cli.CODIGO) as ImportePedidos
		, replace(convert(varchar(10),dateadd(day,(select DIAS_ENTRE from vDatosEmpresa where CODIGO collate Modern_Spanish_CI_AI=(select EMPRESA from Configuracion_SQL)),cast(@FechaTeleVenta as smalldatetime)),103),'/','-') as FechaEntrega
		from vClientes cli
		where cli.CODIGO =@cliente for JSON AUTO) as JAVASCRIPT	

	ELSE select 
		(select *
		, replace(convert(varchar(10),dateadd(day,(select DIAS_ENTRE from vDatosEmpresa where CODIGO collate Modern_Spanish_CI_AI=(select EMPRESA from Configuracion_SQL)),cast(@FechaTeleVenta as smalldatetime)),103),'/','-') as FechaEntrega
		 from vClientes where CODIGO=@cliente for JSON AUTO) as JAVASCRIPT	

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pClienteDatos')
	RETURN 0
END CATCH