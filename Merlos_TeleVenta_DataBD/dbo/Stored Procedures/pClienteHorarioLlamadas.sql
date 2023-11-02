
CREATE PROCEDURE [dbo].[pClienteHorarioLlamadas]
(
	  @cliente char(20)
	, @lunes bit
	, @hora_lunes char(15)
	, @martes bit
	, @hora_martes char(15)
	, @miercoles bit
	, @hora_miercoles char(15)
	, @jueves bit
	, @hora_jueves char(15)
	, @viernes bit
	, @hora_viernes char(15)
	, @sabado bit
	, @hora_sabado char(15)
	, @domingo bit
	, @hora_domingo char(15)
	, @tipo_llamada int
	, @dias_period int
)
AS
BEGIN TRY
	if exists (select cliente from clientes_adi where cliente=@cliente)
		update clientes_adi set lunes=@lunes, hora_lunes=@hora_lunes
							,   martes=@martes, hora_martes=@hora_martes
							,   miercoles=@miercoles, hora_miercoles=@hora_miercoles
							,   jueves=@jueves, hora_jueves=@hora_jueves
							,   viernes=@viernes, hora_viernes=@hora_viernes
							,   sabado=@sabado, hora_sabado=@hora_sabado
							,   domingo=@domingo, hora_domingo=@hora_domingo
							,   tipo_llama=@tipo_llamada
							,   dias_period=@dias_period
	else 
		insert into clientes_adi ([cliente],[lunes],[hora_lunes],[martes],[hora_martes],[miercoles],[hora_miercoles],[jueves],[hora_jueves]
				,[viernes], [hora_viernes],[sabado],[hora_sabado],[domingo],[hora_domingo],[tipo_llama],[dias_period]) 
		values (@cliente, @lunes, @hora_lunes, @martes, @hora_martes, @miercoles, @hora_miercoles
				, @jueves, @hora_jueves, @viernes, @hora_viernes, @sabado, @hora_sabado, @domingo, @hora_domingo
				, @tipo_llamada, @dias_period)
	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
