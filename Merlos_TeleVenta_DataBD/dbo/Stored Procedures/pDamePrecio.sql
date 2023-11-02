

-- =============================================
-- Author:		Lluis Caballero
-- Create date: 30/08/27
-- Description:	Proceso para devolver el precio de forma estandard
-- =============================================
CREATE PROCEDURE [dbo].[pDamePrecio]
	(
		@ARTICULO VARCHAR(20),
		@CLIENTE VARCHAR(20)='',
		@TARIFA VARCHAR(2)='',
		@UNIDADES NUMERIC(18,4)=1,
		@FECHAPRECIO SMALLDATETIME=''
	)
AS 
BEGIN TRY
    DECLARE @PREU NUMERIC(15,6), @DTO1 NUMERIC(15,2), @DTO2 NUMERIC(15,2), @RESPOSTA varchar(max), @RESPOSTA2 varchar(max), 
	@FECHA SMALLDATETIME, @EMP CHAR(2), @TIPOPVP CHAR(2), @Mensaje varchar(max), @MensajeError varchar(max)
	SET @PREU=0.000000
	SET @DTO1=0.00
	SET @DTO2=0.00
	SET @EMP='01'
	IF COALESCE(@FECHAPRECIO,'')='' SET @FECHA=CAST(CONVERT(char(11), getdate(), 113) as datetime)
	ELSE SET @FECHA=@FECHAPRECIO
	SET @TIPOPVP=''

	SELECT @PREU=PVP, @DTO1=DTO1, @DTO2=DTO2 FROM DBO.ftDonamPreu(@EMP,@CLIENTE,@ARTICULO,@TARIFA,@UNIDADES,@FECHA)
	--SELECT @TIPOPVP=TIPOPVP FROM vAHArticulos WHERE CODIGO=@ARTICULO

	SET @RESPOSTA2='","PRECIO":"'+LTRIM(STR(@PREU,15,6))+'","DTO1":"'+LTRIM(STR(@DTO1,15,2))+'","DTO2":"'+LTRIM(STR(@DTO2,15,2))
	SELECT @RESPOSTA2 AS JAVASCRIPT
	--select (@RESPOSTA)
	RETURN -1
END TRY
BEGIN CATCH 
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  

    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
    -- Error
    SET @Mensaje='ERROR de proceso'
	--select (@Mensaje)
	SELECT 'ALERT('''+@Mensaje+chAr(13)+'Missatge:'+@ErrorMessage+'''); parent.cierraIframe();' AS JAVASCRIPT
    RETURN 1
END CATCH
