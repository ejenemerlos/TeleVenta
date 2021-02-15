CREATE PROCEDURE [dbo].[pSeries] @Series varchar(50)='Series'
AS
BEGIN TRY
	
	select (
		select codigo, ltrim(rtrim(nombre)) as nombre from vSeries for JSON AUTO
	) as JAVASCRIPT
	
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH