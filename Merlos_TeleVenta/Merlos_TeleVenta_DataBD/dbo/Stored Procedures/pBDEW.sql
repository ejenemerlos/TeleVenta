CREATE PROCEDURE [dbo].[pBDEW] @gestion varchar(50), @comun varchar(50)
AS
BEGIN TRY		
	DECLARE @existe int = 0	
	DECLARE @sql nvarchar(max)

	DECLARE @val1 TABLE (columnVal int);
	SET @sql = 'IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '''+@gestion+''') select 0 else select 1'
	INSERT @val1 EXEC sp_executesql @sql
	set @existe = (SELECT * FROM @val1)
	if @existe=0 BEGIN  select 'GESTION!' as JAVASCRIPT RETURN -1 END

	DECLARE @val2 TABLE (columnVal int);
	SET @sql = 'IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '''+@comun+''') select 0 else select 1'
	INSERT @val2 EXEC sp_executesql @sql
	set @existe = (SELECT * FROM @val2)
	if @existe=0 BEGIN select 'COMUN!'  as JAVASCRIPT RETURN -1 END
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError= ERROR_MESSAGE() + char(13) + ERROR_NUMBER() + char(13) + ERROR_PROCEDURE() + char(13) + @@PROCID + char(13) + ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH