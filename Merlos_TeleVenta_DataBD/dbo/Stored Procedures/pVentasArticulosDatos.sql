

-- ===========================================================
--	Author:			Elías Jené
--	Create date:	20/11/2019
--	Description:	Obtener Marcas de Ventas
-- ===========================================================

-- exec pVentasArticulosDatos 'Marcas', null, '01', 'Vendedor'
-- exec pVentasArticulosDatos 'Familias', null, '01', 'Vendedor'
-- exec pVentasArticulosDatos 'Articulos', null, '01', 'Vendedor'

CREATE PROCEDURE [dbo].[pVentasArticulosDatos] 
				  @modo varchar(50)=''
				, @padre varchar(50)=''
				, @cliente varchar(20)=''
				, @usuario varchar(20)=''
				, @rol varchar(50)=''
				, @empresa varchar(5)=''
AS
BEGIN TRY		
	declare		  @GESTION char(8) = '['+(select gestion from Configuracion_SQL)+']'
				, @sentencia varchar(max) = ''	
				, @elWhere varchar(500) = ''	
				, @w2 varchar(500) = ''	
				, @codigo varchar(50)
				, @nombre varchar(100)
									
	if @cliente<>'' begin set @elWhere='where vpd.CLIENTE='''+@cliente+'''' end	
	if @rol='VerTodosLosClientes' or @rol='Admins' begin set @elWhere='' end	
	if @rol='MI_User_Ruta' begin set @elWhere= 'where cli.RUTA='''+@usuario+'''' end	
	if @rol='Vendedor' begin 
		set @elWhere='where vpd.CLIENTE in (select cliente from vClientes where VENDEDOR='''+@usuario+''')' 
	end	

	if @modo='Marcas' begin
		if @rol='MI_User_RUTA' BEGIN
			set @sentencia='select CODIGO as codigo, NOMBRE as nombre 
							from vMarcas 
							where CODIGO Collate Modern_Spanish_CI_AI IN 
							(select MARCA from vArticulos where CODIGO Collate Modern_Spanish_CI_AI IN 
								(select ARTICULO from vVentasArticulos where EMPRESA='''+@empresa+''' and RUTA='''+@usuario+''')
							)
							order by NOMBRE ASC' 
		END ELSE BEGIN
			set @sentencia='select CODIGO as codigo, NOMBRE as nombre from vMarcas order by NOMBRE ASC' 
		END
	end

	if @modo='Familias' begin		
		if @rol='MapaMarca' begin 
			set @sentencia='
				select CODIGO as codigo, NOMBRE as nombre 
				from vFamilias 
				where CODIGO in (select familia from varticulos where MARCA='''+@usuario+''')
				order by NOMBRE ASC
			'
		end
		else if @rol='MI_User_RUTA' begin 
			set @sentencia='
				select CODIGO as codigo, NOMBRE as nombre 
				from vFamilias 
				where CODIGO Collate Modern_Spanish_CI_AI IN 
				(select FAMILIA from vArticulos where CODIGO Collate Modern_Spanish_CI_AI IN 
					(select ARTICULO from vVentasArticulos where EMPRESA='''+@empresa+''' and RUTA='''+@usuario+''')
				)
				order by NOMBRE ASC
			'
		end
		else begin set @sentencia='select CODIGO as codigo, NOMBRE as nombre from vFamilias order by NOMBRE ASC' end
	end

	if @modo='Articulos' begin
		if @rol='MapaMarca' begin 
			set @sentencia='
				select CODIGO as codigo, NOMBRE as nombre from vArticulos where MARCA='''+@usuario+''' order by NOMBRE ASC
			'
		end
		else if @rol='MI_User_RUTA' begin 
			set @sentencia='
				select CODIGO as codigo, NOMBRE as nombre from vArticulos 
				where CODIGO Collate Modern_Spanish_CI_AI IN (select ARTICULO from vVentasArticulos where EMPRESA='''+@empresa+''' and RUTA='''+@usuario+''')
				order by NOMBRE ASC
			'
		end
		else begin set @sentencia='select CODIGO as codigo, NOMBRE as nombre from vArticulos order by NOMBRE ASC' end		
	end
									
	-- print @sentencia return -1
	EXEC ('SELECT isnull(( ' + @sentencia + ' for JSON PATH, ROOT(''marcas'')	),''{"marcas":[]}'') AS JAVASCRIPT')
		
	RETURN -1
END TRY

BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
