CREATE PROCEDURE [dbo].[pEstTV] @parametros nvarchar(max)=''
AS
BEGIN TRY
	declare  @IdTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.IdTeleVenta'))
			,@nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
			,@FechaTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.FechaTeleVenta'))
			,@usuario varchar(50) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))

	declare @clientes int
	declare @llamadas int
	declare @pedidos int
	declare @sumaPedidos numeric(20,2)

	select @clientes=clientes, @llamadas=llamadas, @pedidos=pedidos, @sumaPedidos=importe 
	from TeleVentaCab where id=@IdTeleVenta

	
	--  devolución de filtros
		declare @filtroGestor varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as gestor 
		from [TeleVentaFiltros] u
		inner join vGestores v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Gestor' for JSON AUTO)

		declare @filtroRuta varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as ruta 
		from [TeleVentaFiltros] u
		inner join vRutas v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Ruta' for JSON AUTO)

		declare @filtroVendedor varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as vendedor 
		from [TeleVentaFiltros] u
		inner join vVendedores v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Vendedor' for JSON AUTO)

		declare @filtroSerie varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as serie 
		from [TeleVentaFiltros] u
		inner join vSeries v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Serie' for JSON AUTO)

		declare @filtroMarca varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as marca 
		from [TeleVentaFiltros] u
		inner join vMarcas v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Marca' for JSON AUTO)

		declare @filtroFamilia varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as familia 
		from [TeleVentaFiltros] u
		inner join vFamilias v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Familia' for JSON AUTO)

		declare @filtroSubfam varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as Subfamilia 
		from [TeleVentaFiltros] u
		inner join vSubFamilias v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@IdTeleVenta and u.tipo='Subfamilia' for JSON AUTO)
		
		
	select CONCAT(
		'['
		,	'{'
		,		'"clientes":"',@clientes,'","llamadas":"',@llamadas,'","pedidos":"',@pedidos,'","importe":"',@sumaPedidos,'"'
		,		',"filtros":['
		,					'{'
		,						'"gestor":',isnull(@filtroGestor,'[]'),',"ruta":',isnull(@filtroRuta,'[]'),',"vendedor":',isnull(@filtroVendedor,'[]')
		,						',"serie":',isnull(@filtroSerie,'[]'),',"marca":',isnull(@filtroMarca,'[]')
		,						',"familia":',isnull(@filtroFamilia,'[]'),',"subfamilia":',isnull(@filtroSubfam,'[]')
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