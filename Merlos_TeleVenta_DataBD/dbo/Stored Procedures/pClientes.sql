-- ===========================================================
--	Author:			Elías Jené
--	Create date:	02/05/2019
--	Description:	Obtener Clientes del Vendedor
-- ===========================================================

-- exec pClientes '..'
-- exec pClientes '01','actividad:50'

CREATE  PROCEDURE [dbo].[pClientes] @elVendedor varchar(20)='', @modo varchar(100)='', @elUsuario varchar(50)='', @elRol varchar(50)=''
AS
BEGIN TRY
	
	-- Clientes NO geolocalizados
	if @modo='listaNoGeolocalizados' BEGIN
			declare @numClientesNoGeo int = (select count(codigo)  
			from vClientes where DIRECCION<>'' and ( LATITUD='' or LATITUD is null or LONGITUD='' or LONGITUD is null )
			)
			select cast(@numClientesNoGeo as varchar) as JAVASCRIPT
		return -1
	END

	-- Clientes NO geolocalizados - Geolocalizar
	if @modo='GeolocalizarCliente' BEGIN
		BEGIN TRY DROP TABLE #Temp END TRY BEGIN CATCH end CATCH
		select top 1 codigo  collate Modern_Spanish_CS_AI as codigo
					, NOMBRE  collate Modern_Spanish_CS_AI as NOMBRE
					, DIRECCION collate Modern_Spanish_CS_AI + ' ' + CP collate Modern_Spanish_CS_AI + ' ' + POBLACION collate Modern_Spanish_CS_AI as laDIRECCION 
		into #Temp from vClientes 
		where DIRECCION<>'' and ( LATITUD='' or LATITUD is null or LONGITUD='' or LONGITUD is null )		
		if (select count(NOMBRE) from #Temp)>0 BEGIN
			select CONCAT('{"clientes":[{'
						,'"codigo":"',(select isnull(codigo ,'') from #Temp),'"'
						,',"nombre":"',(select isnull(replace(NOMBRE,'"','-') ,'') from #Temp),'"'
						,',"direccion":"',(select isnull(ltrim(rtrim(replace(laDIRECCION,'"','-'))) ,'') from #Temp)+'"'
						,',"faltantes":"',(select count(codigo) from vClientes where DIRECCION<>'' 
											and ( LATITUD='' or LATITUD is null or LONGITUD='' or LONGITUD is null)),'"'
					,'}]}') as JAVASCRIPT
		END ELSE BEGIN
			select '{"clientes":[{"codigo":"0"}]}' AS JAVASCRIPT
		END
		BEGIN TRY DROP TABLE #Temp END TRY BEGIN CATCH end CATCH
		return -1
	END


	declare @elWhere varchar(max) = ' where (VENDEDOR=''' + @elVendedor+''' 
	or VENDEDOR in (select SubVendedor collate Modern_Spanish_CI_AI from VendSubVend where Vendedor='''+@elVendedor+'''))and BAJA=0 '	

	-- SPLIT de @modo
	DECLARE @modoPart NVARCHAR(255), @pos INT
	WHILE CHARINDEX(':', @modo) > 0 BEGIN
		set @pos = CHARINDEX(':', @modo)  
		set @modoPart = SUBSTRING(@modo, 1, @pos-1)	
		set @modo = SUBSTRING(@modo, @pos+1, LEN(@modo)-@pos)
	END	

	if @modoPart='actividad' and @modo<>'0' begin
		set @elWhere=@elWhere+' and CODIGO IN (select CLIENTE from vActividadesClientes where ACTIVIDAD='''+@modo+''') '
	end

	--if @elVendedor IS NULL and @elRol<>'VerTodosLosClientes' BEGIN print 'No se ha especificado el VENDEDOR !'; return 0; END 
	if @elVendedor='..' begin set @elWhere='' end
	if @elRol='MI_User_RUTA' begin set @elWhere= ' where RUTA=''' + @elVendedor+''' and BAJA=0 ' end
	else if @elRol='VerTodosLosClientes' or @elRol='Admins' or @elRol='AdminPortal' begin set @elWhere='' end

	declare @sentenciaSQL varchar(max) = ''
	set @sentenciaSQL='
		declare   @codigo varchar(50)
				, @nombre varchar(50)
				, @direccion varchar(50)
				, @cp varchar(50)
				, @poblacion varchar(50)
				, @provincia varchar(50)
				, @latitud varchar(50)
				, @longitud varchar(50)
				, @respuesta varchar(max)=''''

		set @respuesta = 
			(
				select CODIGO as codigo 
				, replace(replace(NOMBRE,''"'',''-''),'''''''',''&#39;'') as nombre 
				, replace(replace(replace(DIRECCION,''"'',''-''),'''''''',''-''),''&#34;'',''-'') as direccion
				, ltrim(rtrim(CP)) as cp
				, POBLACION as poblacion
				, PROVINCIA as provincia
				, ltrim(rtrim(LATITUD)) as latitud
				, ltrim(rtrim(LONGITUD)) as longitud
				from vClientes '
			
				set @sentenciaSQL=@sentenciaSQL+@elWhere+' order by NOMBRE 
				for JSON PATH,ROOT(''clientes'')
			)
		
			SELECT isnull(@respuesta,''{"clientes":[]}'') AS JAVASCRIPT
		'

	-- print @sentenciaSQL return -1 
	EXEC(@sentenciaSQL)
	
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH