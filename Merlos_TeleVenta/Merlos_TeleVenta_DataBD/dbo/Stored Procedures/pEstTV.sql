CREATE PROCEDURE [dbo].[pEstTV] @parametros nvarchar(max)=''
AS
BEGIN TRY
	declare  @FechaTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.FechaTeleVenta'))
			,@nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
			,@usuario varchar(50) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))

	declare @clientes int = (select count(distinct cliente) from llamadas_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV)
	declare @llamadas int = (select count(cliente) from llamadas where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV)
	declare @pedidos int = (select count(pedido) from llamadas_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV and pedido<>'')
	declare @sumaPedidos numeric(20,2) = (select SUM(TOTALDOC) from vPedidos 
										  where IdPedido in (select idpedido collate Modern_Spanish_CI_AI 
																from llamadas where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV 
																and pedido<>'' and pedido<>'NO!'
															) 
										)

	declare @filtroGestor varchar(1000) = 
	isnull((select gestor from gestor_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroRuta varchar(1000) = 
	isnull((select ruta from ruta_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroVendedor varchar(1000) = 
	isnull((select vendedor from vend_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroSerie varchar(1000) = 
	isnull((select serie from serie_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroMarca varchar(1000) = 
	isnull((select marca from marca_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroFamilia varchar(1000) = 
	isnull((select familia from familia_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
	declare @filtroSubfam varchar(1000) = 
	isnull((select subfamilia from subfam_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV for JSON AUTO),'[]')
		
	select CONCAT(
		'['
		,	'{'
		,		'"clientes":"',@clientes,'","llamadas":"',@llamadas,'","pedidos":"',@pedidos,'","importe":"',@sumaPedidos,'"'
		,		',"filtros":['
		,					'{'
		,						'"gestor":',@filtroGestor,',"ruta":',@filtroRuta,',"vendedor":',@filtroVendedor
		,						',"serie":',@filtroSerie,',"marca":',@filtroMarca
		,						',"familia":',@filtroFamilia,',"subfamilia":',@filtroSubfam
		,					'}'
		,		']'
		,	'}'
		,']'
	)as JAVASCRIPT
			
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH