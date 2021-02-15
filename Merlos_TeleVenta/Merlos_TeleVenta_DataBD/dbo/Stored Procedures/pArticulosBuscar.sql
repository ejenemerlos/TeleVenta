CREATE  PROCEDURE [dbo].[pArticulosBuscar]	@parametros nvarchar(max)='' 
AS
BEGIN TRY
	declare @registros int       = (select JSON_VALUE(@parametros,'$.registros'))
		  , @buscar varchar(100) = (select JSON_VALUE(@parametros,'$.buscar'))
		  , @fechaTV varchar(10) = (select JSON_VALUE(@parametros,'$.fechaTV'))
		  , @nombreTV varchar(100) = (select JSON_VALUE(@parametros,'$.nombreTV'))
		  , @usuario varchar(20) = (select JSON_VALUE(@parametros,'$.paramStd[0].currentReference'))
		  , @registro varchar(50) = ''
		  , @marcas varchar(max) = ''
		  , @familias varchar(max) = ''
		  , @subfams varchar(max) = ''
		  , @consulta varchar(max) = ''

	if exists (select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV) BEGIN
		DECLARE elCursor CURSOR FOR
			select marca from marca_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @marcas = @marcas + ' or MARCA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@marcas)>0 set @marcas = ' AND (' + SUBSTRING(@marcas,4,LEN(@marcas))+ ')'
	END

	set @registro = ''
	if exists (select familia from familia_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV) BEGIN
		DECLARE elCursor CURSOR FOR
			select familia from familia_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @familias = @familias + ' or FAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@familias)>0 set @familias = ' AND (' + SUBSTRING(@familias,4,LEN(@familias))+ ')'
	END

	set @registro = ''
	if exists (select subfamilia from subfam_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV) BEGIN
		DECLARE elCursor CURSOR FOR
			select subfamilia from subfam_user where usuario=@usuario and fecha=@fechaTV and nombreTV=@nombreTV
			OPEN elCursor
			FETCH NEXT FROM elCursor INTO @registro
			WHILE (@@FETCH_STATUS=0) BEGIN
				set @subfams = @subfams + ' or SUBFAMILIA='''+@registro+''' '
				FETCH NEXT FROM elCursor INTO @registro
			END		
		CLOSE elCursor deallocate elCursor
		if LEN(@subfams)>0 set @subfams = ' AND (' + SUBSTRING(@subfams,4,LEN(@subfams))+ ')'
	END

	set @consulta = '
		select (
			select
				(select count(CODIGO) from vArticulos 
				where (lower(CODIGO) like ''%''+lower('''+@buscar+''')+''%'' or lower(NOMBRE) like ''%''+lower('''+@buscar+''')+''%'') ' 
				+ @marcas + @familias + @subfams + ') as registros
				, * 
			from vArticulos 
			where (lower(CODIGO) like ''%''+lower('''+@buscar+''')+''%'' or lower(NOMBRE) like ''%''+lower('''+@buscar+''')+''%'' ) 
			' + @marcas + @familias + @subfams + ' for JSON AUTO
		) as JAVASCRIPT	
	'
	exec (@consulta)

	RETURN -1
END TRY
BEGIN CATCH	
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=ERROR_MESSAGE()+char(13)+ERROR_NUMBER()+char(13)+ERROR_PROCEDURE()+char(13)+@@PROCID+char(13)+ERROR_LINE()
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH