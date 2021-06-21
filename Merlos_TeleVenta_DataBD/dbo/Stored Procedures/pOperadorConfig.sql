CREATE PROCEDURE [dbo].[pOperadorConfig] @elJS nvarchar(max)=''
AS
BEGIN TRY
	declare   @modo varchar(50)		= (select JSON_VALUE(@elJS,'$.modo'))
			, @nombreTV varchar(100)= (select JSON_VALUE(@elJS,'$.nombreTV'))
			, @fecha varchar(10)	= (select JSON_VALUE(@elJS,'$.fecha'))
			, @rol varchar(20)		= (select JSON_VALUE(@elJS,'$.paramStd[0].currentRole'))
			, @usuario varchar(20)	= (select JSON_VALUE(@elJS,'$.paramStd[0].currentReference'))
	
	if @fecha is null or @fecha='' set @fecha='PENDIENTE'

	declare @idTV varchar(50) = 
	replace(replace(replace(replace(replace(convert(varchar,getdate(),121),' ',''),'/',''),':',''),'.',''),'-','') 

	if @modo='guardar' or @modo='recargar' BEGIN
		--	comprobar que no exista el nombreTV
			if @modo='guardar' and exists (select * from [TeleVentaCab] where usuario=@usuario and nombre=@nombreTV and fecha=@fecha) begin 
				select 'nombreTV_Existe!' as JAVASCRIPT return -1 
			end

		if @modo='guardar' insert into [TeleVentaCab] (id,usuario,fecha,nombre) values (@idTV,@usuario,@fecha,@nombreTV)
		
		if @modo='recargar'
		set @idTV = (select id from [TeleVentaCab] where usuario=@usuario and fecha=@fecha and nombre=@nombreTV)

		declare @i int, @valor varchar(1000) 
		
		if @modo='guardar' BEGIN
			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Gestor')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Gestor',(select JSON_VALUE(@valor,'$.Gestor')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur	

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Ruta')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Ruta',(select JSON_VALUE(@valor,'$.Ruta')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur	

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Vendedor')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Vendedor',(select JSON_VALUE(@valor,'$.Vendedor')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Serie')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Serie',(select JSON_VALUE(@valor,'$.Serie')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Marca')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Marca',(select JSON_VALUE(@valor,'$.Marca')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Familia')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Familia',(select JSON_VALUE(@valor,'$.Familia')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur

			declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.Subfamilia')
			OPEN cur FETCH NEXT FROM cur INTO @i, @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				insert into [TeleVentaFiltros] (id,tipo,valor) values (@idTV,'Subfamilia',(select JSON_VALUE(@valor,'$.Subfamilia')))
				FETCH NEXT FROM cur INTO @i, @valor
			END CLOSE cur deallocate cur
		END

		--	obtener llamadas según criterios
			declare   @nDia varchar(10)
					, @gestores varchar(max)
					, @rutas varchar(max)
					, @vendedores varchar(max)

		-- -- montar where gestores
		declare cur CURSOR for select valor from [TeleVentaFiltros] where id=@idTV and tipo='Gestor'
		OPEN cur FETCH NEXT FROM cur into @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @gestores = CONCAT(@gestores, ' a.cliente in (select cliente from cliente_gestor where gestor='''+@valor+''') ')
			FETCH NEXT FROM cur INTO @valor END 
		CLOSE cur deallocate cur
		if @gestores is null set @gestores='' 
		ELSE set @gestores=' and ('+replace(@gestores,''' a.cliente in (select cliente from cliente_gestor where gestor='''+@valor+''') ',''' OR a.cliente in (select cliente from cliente_gestor where gestor='''+@valor+''') ')+') '

		-- -- montar where rutas
		declare cur CURSOR for select valor from [TeleVentaFiltros] where id=@idTV and tipo='Ruta'
		OPEN cur FETCH NEXT FROM cur into @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @rutas = CONCAT(@rutas, ' cli.ruta='''+@valor+'''')
			FETCH NEXT FROM cur INTO @valor END 
		CLOSE cur deallocate cur
		if @rutas is null set @rutas='' 
		ELSE set @rutas=' and ('+replace(@rutas,''' cli.RUTA',''' OR cli.RUTA')+') '

		-- -- montar where vendedores
		declare cur CURSOR for select valor from [TeleVentaFiltros] where id=@idTV and tipo='vendedor'
		OPEN cur FETCH NEXT FROM cur into @valor
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @vendedores = CONCAT(@vendedores, ' cli.vendedor='''+@valor+'''')
			FETCH NEXT FROM cur INTO @valor END 
		CLOSE cur deallocate cur
		if @vendedores is null set @vendedores='' 
		ELSE set @vendedores=' and ('+replace(@vendedores,''' cli.VENDEDOR',''' OR cli.VENDEDOR')+') '

		set @nDia = replace(replace( lower(DATENAME(dw,@fecha)),'á','a' ),'é','e' )
	
		exec ('insert into [TeleVentaDetalle] (id,cliente,horario)
				select '''+@idTV+''' as id, a.cliente, a.hora_'+@nDia+' as horario
				from clientes_adi a
				left join vClientes cli on cli.CODIGO collate Modern_Spanish_CS_AI=a.cliente
				where '+@nDia+'=1 '+@gestores+' '+@rutas+' '+@vendedores+' 
				and a.cliente not in (select cliente from TeleVentaDetalle where id='''+@idTV+''')
		')

		-- comrpobar [Llamar otro día] y añadir al televenta si coinciden las fechas
		insert into [TeleVentaDetalle] (id,cliente,horario)
			select @idTV as id
				,  cliente
				,  substring(cast(fechaHora as varchar),13,5)+' - '+substring(cast(fechaHora as varchar),13,5) as horario
			from llamadasOD
			where convert(varchar(10),fechaHora,105)=@fecha and insertada=0
		update llamadasOD set insertada=1 where convert(varchar(10),fechaHora,105)=@fecha
	END

	set @idTV = (select id from [TeleVentaCab] where usuario=@usuario and fecha=@fecha and nombre=@nombreTV)

	--  devolución de filtros
		declare @gestor varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as gestor 
		from [TeleVentaFiltros] u
		inner join vGestores v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Gestor' for JSON AUTO)

		declare @ruta varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as ruta 
		from [TeleVentaFiltros] u
		inner join vRutas v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Ruta' for JSON AUTO)

		declare @vendedor varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as vendedor 
		from [TeleVentaFiltros] u
		inner join vVendedores v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Vendedor' for JSON AUTO)

		declare @serie varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as serie 
		from [TeleVentaFiltros] u
		inner join vSeries v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Serie' for JSON AUTO)

		declare @marca varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as marca 
		from [TeleVentaFiltros] u
		inner join vMarcas v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Marca' for JSON AUTO)

		declare @familia varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as familia 
		from [TeleVentaFiltros] u
		inner join vFamilias v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Familia' for JSON AUTO)

		declare @subfamilia varchar(max) = 
		(select ltrim(rtrim(u.valor))+' - '+ltrim(rtrim(v.NOMBRE)) collate Modern_Spanish_CS_AI as Subfamilia 
		from [TeleVentaFiltros] u
		inner join vSubFamilias v on v.CODIGO collate Modern_Spanish_CS_AI=u.valor
		where u.id=@idTV and u.tipo='Subfamilia' for JSON AUTO)

		if @gestor='' or @gestor is null set @gestor = '[]'
		if @ruta='' or @ruta is null set @ruta = '[]'
		if @vendedor='' or @vendedor is null set @vendedor = '[]'
		if @serie='' or @serie is null set @serie = '[]'
		if @marca='' or @marca is null set @marca = '[]'
		if @familia='' or @familia is null set @familia = '[]'
		if @subfamilia='' or @subfamilia is null set @subfamilia = '[]'

		declare @serieActiva char(2) = isnull(
				(select valor from TeleVentaFiltros where id=@idTV and tipo='Serie')
				,(select TVSerie from Configuracion_SQL))

		declare @llamUser int = (select count(id) from [TeleVentaDetalle] where id=@idTV)
		if @llamUser=0 begin 
			delete [TeleVentaCab] where id=@idTV 
			delete [TeleVentaFiltros] where id=@idTV 
		end

		select   '{"gestor":'+@gestor+',"ruta":'+@ruta+',"vendedor":'+@vendedor+',"serie":'+@serie+',"marca":'+@marca+',"familia":'+@familia
				+',"subfamilia":'+@subfamilia+',"fecha":"'+isnull(@fecha,'')+'","llamUserReg":"'+cast(@llamUser as varchar(10))+'"'
				+',"serieActiva":"'+@serieActiva+'"}' as JAVASCRIPT
				
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH