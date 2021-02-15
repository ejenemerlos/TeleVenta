CREATE PROCEDURE [dbo].[pArticulos]	  @modo varchar(50)='lista'
									, @registros int
									, @varios varchar(50)=''
AS
BEGIN TRY	
	DECLARE   @desde int = @registros
			, @sentencia varchar(max) = ''

	set @sentencia = '
		select (
			select (select count(CODIGO) from vArticulos where CODIGO like ''%'+@varios+'%'' or NOMBRE like ''%'+@varios+'%'' ) as registros
			, * 
			from vArticulos 
			where CODIGO like ''%'+@varios+'%'' or NOMBRE like ''%'+@varios+'%'' 
			ORDER BY  NOMBRE  ASC 
			OFFSET '+cast(@desde as varchar(10))+' ROWS FETCH NEXT 100 ROWS ONLY  FOR JSON AUTO
		) as JAVASCRIPT
	'
	exec(@sentencia)
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH