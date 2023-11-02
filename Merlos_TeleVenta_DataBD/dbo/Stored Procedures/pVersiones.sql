
CREATE PROCEDURE [dbo].[pVersiones]	  @modo varchar(50)='EW'
									, @comun varchar(8)=''
AS
BEGIN TRY	
	DECLARE   @sentencia varchar(max) = ''
			, @respuesta varchar(max) = ''
			, @version varchar(50)
			
	--	Versión CLISELLER
		if @modo='CLISELLER' BEGIN
			declare @vAnt varchar(50) = (select top 1 VersionAnterior from MI_Version)
			declare @vAct varchar(50) = (select top 1 [Version] from MI_Version)
			if @vAnt<>@vAct or @vAnt is null BEGIN 
				update MI_Version set VersionAnterior=@vAct
				select 'NuevaVersion' as JAVASCRIPT
			END
			else select 'VersionOK' as JAVASCRIPT
			RETURN -1
		END

	--	Versión de Sage Eurowin
		if @modo='EW' BEGIN
			DECLARE @columnVal TABLE (columnVal nvarchar(255));
			DECLARE @sql nvarchar(max)
			SET @sql = 'select VERSION from ['+@comun+'].dbo.codcom'
			INSERT @columnVal EXEC sp_executesql @sql
			set @version = (SELECT * FROM @columnVal)
			select @version as JAVASCRIPT
			RETURN -1
		END
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
