CREATE PROCEDURE [dbo].[pConfigPrimeraBBDD]
	@modo varchar(50) = ''
AS
BEGIN TRY
	declare @gestion char(6)
	set @gestion = (select isnull(GESTION,'') from Configuracion_SQL)
	select isnull(@gestion,'') as JAVASCRIPT
	RETURN -1
END TRY
BEGIN CATCH
	RETURN 0
END CATCH