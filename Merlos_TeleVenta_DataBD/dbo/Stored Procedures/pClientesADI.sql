
CREATE PROCEDURE [dbo].[pClientesADI] @modo varchar(50), @elJS varchar(max)=''
AS
BEGIN TRY

	-- cargar tabla de llamadas
		if @modo='cargarTablasDeLlamadas' BEGIN
			select (select * from clientes_adi where cliente=@elJS for JSON auto) as JAVASCRIPT
		END

	-- CLIENTES editar
		if @modo='editar' BEGIN
			BEGIN TRAN
				delete clientes_adi where cliente=(select JSON_VALUE(@elJS,'$.cliente'))

				declare   @i int
						, @valor varchar(1000) 
						, @sentencia varchar(max)

				insert into clientes_adi (cliente, tipo_llama, dias_period) 
				values ((select JSON_VALUE(@elJS,'$.cliente')),(select JSON_VALUE(@elJS,'$.tipo')),(select JSON_VALUE(@elJS,'$.periodo')))

				declare cur CURSOR for select [key], [value] from openjson(@elJS,'$.dias')
				OPEN cur FETCH NEXT FROM cur INTO @i, @valor
				WHILE (@@FETCH_STATUS=0) BEGIN
					set @sentencia = 'update clientes_adi set '+(select JSON_VALUE(@valor,'$.dia'))+'='+(select JSON_VALUE(@valor,'$.activo'))
									+ ', hora_'+(select JSON_VALUE(@valor,'$.dia'))+'='''+(select JSON_VALUE(@valor,'$.horario'))+''''
									+ ' where cliente='''+(select JSON_VALUE(@elJS,'$.cliente'))+''''
					exec (@sentencia)
					FETCH NEXT FROM cur INTO @i, @valor
				END CLOSE cur deallocate cur	
			COMMIT TRAN
		END

	RETURN -1
END TRY
BEGIN CATCH	
	ROLLBACK TRAN
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1,'pClientesADI')
	select @CatchError as JAVASCRIPT
	RETURN 0
END CATCH
