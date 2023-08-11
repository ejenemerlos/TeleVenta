CREATE PROCEDURE [dbo].[pComunes] @modo varchar(50)='lista'
AS
BEGIN TRY	
	Declare   @nombre varchar(10)
			, @comunes varchar(max)=''

	Declare elCursor CURSOR for
	SELECT name FROM sys.databases WHERE left(name,4) = 'COMU'
	OPEN elCursor FETCH NEXT FROM elCursor INTO @nombre
	WHILE (@@FETCH_STATUS=0)BEGIN
		set @comunes = @comunes + '{"nombre":"'+@nombre+'"}'

		declare @exec1 varchar(1000) = '
			declare @comunes varchar(max)=''''
			if (select left(PRODUCTNAME,4) from ['+@nombre+'].dbo.codcom)=''SAGE''
			set @comunes = @comunes + ''{"nombre":"'+isnull(@nombre,'')+'"}''
		'
		begin try exec (@exec1) end try begin catch end catch

	FETCH NEXT FROM elCursor INTO @nombre END Close elCursor Deallocate elCursor
	
	select '{"comunes":['+replace(isnull(@comunes,''),'}{','},{')+']}' as JAVASCRIPT

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH