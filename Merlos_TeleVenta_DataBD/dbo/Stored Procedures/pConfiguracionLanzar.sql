CREATE PROCEDURE [dbo].[pConfiguracionLanzar] @comun varchar(10), @empresa varchar(10)
AS
BEGIN TRY	
	declare   @datos nvarchar(max)=''		
			, @mensaje nvarchar(max)=''
			, @gestion nvarchar(10)
			, @campos nvarchar(10)
			, @sql nvarchar(max)
			, @sql2 nvarchar(max)

	--	verificar si ya existe una configuración
		if exists (select * from Configuracion_SQL) begin
			set @mensaje = '{"mensaje":"EXISTE"}'
		end
		else begin
			--  obtener los datos de configuración
				--	GESTION
					DECLARE @cc1 TABLE (cc1 varchar(100))
					SET @sql = 'select ltrim(rtrim(RUTA)) from ['+@comun+'].dbo.ejercici where PREDET=1'
					INSERT @cc1 EXEC sp_executesql @sql				
					set @gestion = (SELECT * FROM @cc1)
				--	CAMPOS
					DECLARE @cc2 TABLE (cc2 varchar(100))
					SET @sql2 = 'select case when OBJECT_ID(''CAMPOS'+isnull(right(@gestion,2),'')+'.dbo.articuloew'') IS NOT NULL 
								then ''1'' else ''0'' end'	
					INSERT @cc2 EXEC sp_executesql @sql2				
					set @campos = (SELECT * FROM @cc2)
					if @campos='1' begin set @campos='CAMPOS'+isnull(right(@gestion,2),'') end
					else begin set @campos='' end
		end

		select '{'
					+'"mensaje":"'+isnull(@mensaje,'')+'",'
					+'"ejercicio":"'+isnull(left(@gestion,4),'')+'",'
					+'"gestion":"'+isnull(@gestion,'')+'",'
					+'"letra":"'+isnull(right(@gestion,2),'')+'",'
					+'"comun":"'+isnull(@comun,'')+'",'
					+'"campos":"'+isnull(@campos,'')+'"'
				+'}' 
		AS JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1, 'mysp_CreateCustomer')
	RETURN 0
END CATCH