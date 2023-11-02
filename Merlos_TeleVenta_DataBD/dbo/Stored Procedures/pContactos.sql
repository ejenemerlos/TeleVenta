
CREATE PROCEDURE [dbo].[pContactos] @elJS nvarchar(max)=''
AS
BEGIN TRY
	declare   @modo varchar(50) = (select JSON_VALUE(@elJS,'$.modo'))

	-- Parámetros de Configuración
	declare @Ejercicio char(4), @Gestion char(6), @Letra char(2), @Comun char(8), @Lotes char(8), @Campos char(8), @Empresa char(2), @Anys int
	select @Ejercicio=EJERCICIO, @Gestion=GESTION, @Letra=LETRA, @Comun=COMUN, @Campos=CAMPOS, @Empresa=EMPRESA, @Anys=ANYS from [Configuracion_SQL]

	declare @sentencia varchar(max)=''
	declare @jsonTemp TABLE (js varchar(max))


	if @modo='guardar' BEGIN
		declare @cliente varchar(20)	=  (select JSON_VALUE(@elJS,'$.cliente'))
		declare @persona varchar(100)	=  (select JSON_VALUE(@elJS,'$.persona'))
		declare @cargo varchar(50)		=  (select JSON_VALUE(@elJS,'$.cargo'))
		declare @email varchar(100)		=  (select JSON_VALUE(@elJS,'$.email'))
		declare @telefono varchar(20)	=  (select JSON_VALUE(@elJS,'$.telefono'))
		declare @linea int

		INSERT @jsonTemp 
		EXEC('select( select MAX(isnull(LINEA,0))+1 as LIN from ['+@Gestion+'].dbo.cont_cli where CLIENTE='''+@cliente+'''  for JSON AUTO, INCLUDE_NULL_VALUES)')	
		SELECT @linea=JSON_VALUE((select js FROM @jsonTemp),'$[0].LIN')		
		delete @jsonTemp

		set @sentencia = CONCAT('
			insert into [',@Gestion,'].dbo.cont_cli (CLIENTE, PERSONA, CARGO, EMAIL, LINEA, ORDEN, VISTA, TELEFONO)
			values (''',@cliente,''', ''',@persona,''', ''',@cargo,''', ''',@email,''', ',@linea,', 0, 1, ''',@telefono,''')
		')
		EXEC(@sentencia)
	END

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
