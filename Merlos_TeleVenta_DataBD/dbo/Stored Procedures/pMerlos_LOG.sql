CREATE PROCEDURE [dbo].[pMerlos_LOG] ( @accion varchar(max)='', @error varchar(max)='' )
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  
		
		insert into [Merlos_Log] (accion,error) values (@accion, @error)

		-- eliminar registros anteriores a 3 meses
		delete [Merlos_Log] where FechaInsertUpdate<DATEADD(month,-3,cast(getdate() as datetime))

		return -1
	END TRY
	BEGIN CATCH
		DECLARE @CatchError NVARCHAR(MAX)
		SET @CatchError= concat(
			  char(13), ERROR_MESSAGE()
			, char(13), ERROR_NUMBER()
			, char(13), ERROR_PROCEDURE()
			, char(13), @@PROCID
			, char(13), ERROR_LINE()
		)
		RAISERROR(@CatchError,12,1)
		RETURN 0
	END CATCH
END