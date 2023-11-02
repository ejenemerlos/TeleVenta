

CREATE PROCEDURE [dbo].[pListados] @parametros varchar(max)='[]'
AS
SET NOCOUNT ON
BEGIN TRY
	declare @modo varchar(50) = isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@id varchar(50) = isnull((select JSON_VALUE(@parametros,'$.id')),'')
	
	if @modo='cargarListados' BEGIN
		select isnull(
			(
				select distinct TL.id, TL.nombreListado, TL.gestor,  (select min(fecha) from TeleVentaListados where id=id) as fecha, TL.hasta, (select min(horario) from TeleVentaListados where id=id) as horario, (select concat(min(ltrim(rtrim(cliente))),'-',min(ltrim(rtrim(vcc.NOMBRE)))) from TeleVentaListados tll left join vClientes vcc on vcc.CODIGO collate database_default=tll.cliente where id=id) as cliente from TeleVentaListados TL
				--left join vClientes vc on vc.CODIGO=tl.cliente
				for JSON AUTO, INCLUDE_NULL_VALUES
			)
		,'[]') as JAVASCRIPT
	END

	if @modo='cargarListadoTV' BEGIN
		select isnull(
			(select id, usuario, fecha, nombre, isnull(clientes,'') as clientes, isnull(llamadas,'') as llamadas, isnull(pedidos,'') as pedidos, isnull(subtotal,0.00) as subtotal
			, isnull(importe,0.00) as importe, FechaInsertUpdate
			from [TeleVentaCab] order by FechaInsertUpdate desc for JSON AUTO, INCLUDE_NULL_VALUES)
		,'[]') as JAVASCRIPT
	END

	if @modo='exportarListado' BEGIN
		 select isnull(
			(select id, cliente, isnull(horario,'''') as horario, isnull(idpedido,'''') as idpedido, isnull(pedido,'''') as pedido, isnull(subtotal,0.00) as subtotal
			, isnull(importe,0.00) as importe, isnull(serie,'''') as serie
			, completado, FechaInsertUpdate, IdDoc 
			, vc.RCOMERCIAL as RCOMERCIAL
			, vc.TELEFONO as TELEFONO
			  from [TeleVentaDetalle] 
			  inner join vClientes vc on vc.CODIGO collate Modern_Spanish_CS_AI=[TeleVentaDetalle].cliente
			  where id=@id 
			  order by horario ASC
			  for JSON AUTO, INCLUDE_NULL_VALUES)
		  ,'[]') as JAVASCRIPT
	END

	if @modo='imprimirListado' BEGIN
		 select isnull(
			(
				select a.* , vc.NOMBRE as nombre, vc.POBLACION as poblacion
				from TeleVentaListados  a
				inner join vClientes vc on vc.CODIGO collate Modern_Spanish_CS_AI=a.cliente
				where a.id=@id
				order by a.fecha ASC, a.horario ASC
				for JSON AUTO, INCLUDE_NULL_VALUES
			) 
		  ,'[]') as JAVASCRIPT
	END


	return -1
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= concat(
		 'Error [pListados] !!!'
		, char(13), ERROR_MESSAGE()
		, char(13), ERROR_NUMBER()
		, char(13), ERROR_PROCEDURE()
		, char(13), @@PROCID
		, char(13), ERROR_LINE()
	)
	RAISERROR(@CatchError,12,1)

	declare @accion varchar(max) = CONCAT('ERROR SP: [pListados]', @modo)
	
	EXEC [pMerlos_LOG] @accion=@accion, @error=@CatchError

	RETURN 0
END CATCH