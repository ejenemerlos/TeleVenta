CREATE FUNCTION [dbo].[funPrintError](@Message nvarchar(2048),@NumError int,@Procedure nvarchar(126),@IdProcCall int,@Line int) 

RETURNS NVARCHAR(MAX) AS
BEGIN
      DECLARE @CatchError NVARCHAR(MAX) 
      SET @CatchError=CASE WHEN @NumError=3609 OR @NumError=266 THEN '' ELSE  ISNULL(@Message,'') + NCHAR(13) END  +  CASE WHEN @Line<>0 THEN 
            '[Trace: ' + CASE WHEN ISNULL(@Procedure,'')= OBJECT_NAME(@IdProcCall) THEN '' ELSE OBJECT_NAME(@IdProcCall)+'.' END 
                                                           + ISNULL(@Procedure,'')  + '.' + ISNULL(CAST(@Line AS NVARCHAR(MAX)),'') + ']' 
                                                           ELSE '[' + OBJECT_NAME(@IdProcCall) +']'  END
      RETURN @CatchError

END  
