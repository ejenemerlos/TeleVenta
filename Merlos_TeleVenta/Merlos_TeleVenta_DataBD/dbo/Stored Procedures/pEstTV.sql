CREATE PROCEDURE [dbo].[pEstTV] @parametros nvarchar(max)=''
AS
BEGIN TRY
	declare  @FechaTeleVenta varchar(50) = (select JSON_VALUE(@parametros,'$.FechaTeleVenta'))
			,@nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
			,@usuario varchar(50) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))

	declare @clientes int = (select count(distinct cliente) from llamadas_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV)
	declare @llamadas int = (select count(cliente) from llamadas where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV)
	declare @pedidos int = (select count(pedido) from llamadas_user where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV and pedido<>'')
	declare @sumaPedidos numeric(20,2) = (select SUM(TOTALDOC) from vPedidos where ltrim(rtrim(numero collate Modern_Spanish_CS_AI)) 
									  in (select pedido from llamadas where usuario=@usuario and fecha=@FechaTeleVenta and nombreTV=@nombreTV and pedido<>'' and pedido<>'NO') )
		
	select CONCAT('[{"clientes":"',@clientes,'","llamadas":"',@llamadas,'","pedidos":"',@pedidos,'","importe":"',@sumaPedidos,'"}]') as JAVASCRIPT
			
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH