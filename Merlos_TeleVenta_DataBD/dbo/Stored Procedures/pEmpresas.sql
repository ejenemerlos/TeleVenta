
CREATE PROCEDURE [dbo].[pEmpresas] @modo varchar(50)='lista', @comun varchar(10)
AS
BEGIN TRY	

	-- Obtener ejercicio
	DECLARE @sql nvarchar(max) = 'select RUTA from ['+@comun+'].dbo.ejercici where predet=1'	
	DECLARE @columnVal TABLE (columnVal nvarchar(255)) INSERT @columnVal EXEC sp_executesql @sql
	declare @ejercicio varchar(10) = ltrim(rtrim((select * from @columnVal)))	

	-- Obtener empresas
	set @sql = '
		DECLARE @respuesta varchar(max)=''''	
		DECLARE @codigo varchar(10) , @nombre varchar(100)
		DECLARE CURHORAS CURSOR FOR
		select CODIGO, NOMBRE from ['+@ejercicio+'].dbo.empresa where TIPO=''Normal''
		OPEN CURHORAS
		FETCH NEXT FROM CURHORAS INTO @codigo, @nombre
		WHILE (@@FETCH_STATUS=0) BEGIN
			set @respuesta = @respuesta +''{"codigo":"''+@codigo+''","nombre":"''+@nombre+''"}''
		FETCH NEXT FROM CURHORAS INTO @codigo, @nombre 
		END	CLOSE CURHORAS deallocate CURHORAS

		SELECT ''{"empresas":[''+isnull(replace(@respuesta,''}{'',''},{''),'''')+'']}'' AS JAVASCRIPT
	'
	EXEC (@sql)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
