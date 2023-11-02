/*
[pConfiguracion_Email] '{"modo":"mantenimiento","Nombre":"Disteco","Descripcion":"Envío email Pedidos","NombreMostrar":"Disteco-Pedidos","Cuenta":"enriquetomas@gadisteco.com","SMTP":"smtp.office365.com","Puerto":"587","SQLServer":1,"DLL":0,"SSL":1,"Usuario":"enriquetomas@gadisteco.com","Pswrd":"Exchange365","jsUser":{"currentUserId":"1","currentReference":"0","currentUserLogin":"admin","currentRole":"Admins","currentUserFullName":"Admin Admin"}}'
*/
CREATE PROCEDURE [dbo].[pConfiguracion_Email] @parametros varchar(max)
AS
BEGIN TRY	

	insert into Merlos_Log (accion) values (concat('[pConfiguracion_Email] ''',@parametros,''''))

	declare @modo varchar(50)			= isnull((select JSON_VALUE(@parametros,'$.modo')),'')
		,	@Nombre varchar(100)		= isnull((select JSON_VALUE(@parametros,'$."Nombre"')),'')
		,	@Descripcion varchar(1000)	= isnull((select JSON_VALUE(@parametros,'$.Descripcion')),'')
		,	@NombreMostrar varchar(100)	= isnull((select JSON_VALUE(@parametros,'$.NombreMostrar')),'')
		,	@Cuenta varchar(100)			= isnull((select JSON_VALUE(@parametros,'$.Cuenta')),'')
		,	@SMTP varchar(100)			= isnull((select JSON_VALUE(@parametros,'$.SMTP')),'')
		,	@Puerto varchar(10)			= isnull((select JSON_VALUE(@parametros,'$.Puerto')),'0')
		,	@SQLServer bit				= isnull((select JSON_VALUE(@parametros,'$.SQLServer')),'0')
		,	@DLL bit					= isnull((select JSON_VALUE(@parametros,'$.DLL')),'0')
		,	@SSL bit					= isnull((select JSON_VALUE(@parametros,'$.SSL')),'0')
		,	@Usuario varchar(100)		= isnull((select JSON_VALUE(@parametros,'$.Usuario')),'')
		,	@Pswrd varchar(100)			= isnull((select JSON_VALUE(@parametros,'$.Pswrd')),'')

		, 	@currentUserId varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserId')),'')
		, 	@currentReference varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentReference')),'')
		, 	@currentUserLogin varchar(50) 		= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserLogin')),'')
		, 	@currentRole varchar(50) 			= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentRole')),'')
		,	@currentUserFullName varchar(255)	= isnull((select JSON_VALUE(@parametros,'$.jsUser.currentUserFullName')),'')

		, 	@error varchar(max)
		,	@respuesta nvarchar(max)=''


	if @modo='mantenimiento' BEGIN TRY
		if exists (select * from [Configuracion_Email] where Nombre=@Nombre)
			update [Configuracion_Email]
			set   Descripcion=@Descripcion, NombreParaMostrar=@NombreMostrar, Cuenta=@Cuenta, ServidorSMTP=@SMTP, Puerto=@Puerto
				, SSL=@SSL, EnvioPorSQLServer=@SQLServer, EnvioPorDLL=@DLL, Usuario=@Usuario, Password=@Pswrd
			where Nombre=@Nombre
		ELSE BEGIN
			INSERT INTO [dbo].[Configuracion_Email] ([Nombre],[Descripcion],[NombreParaMostrar],[Cuenta],[ServidorSMTP],[Puerto],[SSL],[EnvioPorSQLServer],[EnvioPorDLL],[Usuario],[Password])
			VALUES (@Nombre, @Descripcion, @NombreMostrar, @Cuenta, @SMTP, @Puerto, @SSL, @SQLServer, @DLL, @Usuario, @Pswrd)

			-- Crear cuenta de email en SQL Server
			execute sp_configure 'show advanced options', 1
			RECONFIGURE  
			execute sp_configure 'Database Mail XPs', 1; 
			RECONFIGURE  
			/****** Crear Cuenta de correo en instancia SQL Server ******/
			EXECUTE msdb.dbo.sysmail_add_account_sp
			@account_name = @Nombre,
			@description = @Descripcion,
			@email_address = @Cuenta,
			@replyto_address = @Cuenta,
			@display_name = @NombreMostrar,
			@mailserver_name = @SMTP,
			@port = @Puerto,
			@enable_ssl = @SSL,
			@use_default_credentials= 0,
			@username = @Usuario,
			@password = @Pswrd;
			-- Create a Database Mail profile
			EXECUTE msdb.dbo.sysmail_add_profile_sp
			@profile_name = @Nombre,
			@description = @Descripcion;
			-- Add the account to the profile
			EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
			@profile_name = @Nombre,
			@account_name = @Nombre,
			@sequence_number =1 ;
			EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
			@principal_name = 'public',
			@profile_name = @Nombre,
			@is_default = 1 ;
		END
	END TRY BEGIN CATCH
		set @error=ERROR_MESSAGE()
		insert into Merlos_Log (error, Usuario) values (concat(OBJECT_NAME(@@PROCID),' ', ERROR_MESSAGE()), @currentUserLogin)
	END CATCH




	if @modo='SQLServer_dameConfiguracion' BEGIN
		set @respuesta = isnull(
			(select top 1 * from [Configuracion_Email] where EnvioPorSQLServer=1 for JSON AUTO, INCLUDE_NULL_VALUES)
		,'[]')
	END




	select concat('{"error":"',isnull(@error,''),'","respuesta":',isnull(@respuesta,'[]'),'}') as JAVASCRIPT
		
	RETURN -1
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(MAX)
	SET @ErrorMessage = CONCAT('{"error":"error en el procedimiento ',OBJECT_NAME(@@PROCID),'","accion":"',@parametros,'","mensaje":"',replace(ERROR_MESSAGE(),'"','-'),'"}')
	DECLARE @ErrorSeverity INT = 50001;  -- rango válido de 50000 a 2147483647
    THROW @ErrorSeverity, @ErrorMessage, 1;
	insert into Merlos_Log (accion, error, Usuario) values (concat(OBJECT_NAME(@@PROCID),' ',@parametros,''''), @ErrorMessage, @currentUserLogin)
	select @ErrorMessage as JAVASCRIPT
	RETURN 0
END CATCH
