CREATE PROCEDURE [dbo].[pConfigBBDD]   
(
	  @modo varchar(50)
	, @accion varchar(50)	 = ''
	, @ejercicio varchar(50) = ''
	, @gestion	 varchar(50) = ''
	, @letra	 varchar(50) = ''
	, @comun	 varchar(50) = ''									
	, @campos	 varchar(50) = ''
	, @empresa	 varchar(50) = ''
	, @nEmpresa	 varchar(99) = ''
	, @numEjer	 int = 0
	, @respuesta varchar(max)= ''
)
AS
BEGIN TRY
	if @modo='actualizar' or @modo='reconfigurar' BEGIN
		if @modo='actualizar' BEGIN
			if exists (select GESTION from Configuracion_SQL) BEGIN
				update Configuracion_SQL
						set   EJERCICIO=@ejercicio
							, GESTION=@gestion
							, LETRA=@letra
							, COMUN=@comun
							, CAMPOS=@campos
							, EMPRESA=@empresa
							, NOMBRE_EMPRESA=@nEmpresa
							, ANYS=@numEjer
				update config_telev set empresa=@empresa
			END
			else BEGIN 
				insert into Configuracion_SQL (EJERCICIO, GESTION, LETRA, COMUN, CAMPOS, EMPRESA, NOMBRE_EMPRESA, ANYS)
						values (@ejercicio, @gestion, @letra, @comun, @campos, @empresa, @nEmpresa, @numEjer)
				if exists (select empresa from config_telev)
					update config_telev set empresa=@empresa
				else insert into config_telev (empresa) values (@empresa)
			END
		END

		--  si el modo es 'reconfigurar' lanzamos la configuración con los datos existentes
		--  lanzamos la configuración del portal
			declare @result int

			--select 'Creando vistas...' as JAVASCRIPT
			if @accion='Vistas' or @accion='todo' BEGIN
				EXECUTE @result = [dbo].[01_CrearVistas]
				if @result<>-1 BEGIN
					print 'Error al generar las VISTAS SQL!' 
					return 0
				END
			END

			--select 'Creando funciones...' as JAVASCRIPT
			if @accion='Funciones'  or @accion='todo' BEGIN
				EXECUTE @result = [dbo].[01_CrearFunciones]
				if @result<>-1 BEGIN
					print 'Error al generar las FUNCIONES SQL!' 
					return 0
				END
			END

			--select 'Creando procedimientos...' as JAVASCRIPT
			if @accion='SP'  or @accion='todo' BEGIN
				EXECUTE @result = [dbo].[02_CrearStoreds]
				if @result<>-1 BEGIN
					print 'Error al generar los Procedimientos SQL!' 
					return 0
				END
			END

		RETURN -1
	END

	set @ejercicio = (select EJERCICIO from Configuracion_SQL)
	set @gestion   = (select GESTION from Configuracion_SQL)
	set @letra     = (select LETRA from Configuracion_SQL)
	set @comun     = (select COMUN   from Configuracion_SQL)
	set @campos    = (select CAMPOS  from Configuracion_SQL)
	set @empresa   = (select EMPRESA  from Configuracion_SQL)
	set @nEmpresa  = (select NOMBRE_EMPRESA  from Configuracion_SQL)
	set @numEjer   = (select ANYS  from Configuracion_SQL)
	

	set @respuesta = N'{"configBBDD":[{'
					+	'"ejercicio":"'+ISNULL(@ejercicio,'')+'",'
					+	'"gestion":"'+ISNULL(@gestion,'')+'",'
					+	'"letra":"'+ISNULL(@letra,'')+'",'
					+	'"comun":"'+ISNULL(@comun,'')+'",'
					+	'"campos":"'+ISNULL(@campos,'')+'",'
					+	'"empresa":"'+ISNULL(@empresa,'')+'",'
					+	'"nEmpresa":"'+ISNULL(@nEmpresa,'')+'",'
					+	'"numEjer":"'+cast(ISNULL(@numEjer,0) as varchar)+'"'
					+'}]}'
	

	-- ==================================================================================================================================
	--	Retorno a Flexygo		
		SELECT @respuesta AS JAVASCRIPT
	-- ==================================================================================================================================
	
	RETURN -1
END TRY
BEGIN CATCH
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	set @respuesta = ERROR_MESSAGE()
	RETURN 0
END CATCH