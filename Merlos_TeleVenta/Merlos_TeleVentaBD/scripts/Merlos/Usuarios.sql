update AspNetUsers 
set   Email='e.jene@merlos.net'
	, PasswordHash='ALBaGB8NK2kVq0eotHJ7v0G9KbYVR8WfRmipGjFUAOXD9jw4nUsStY+yn/eee/FSeQ=='
	, SecurityStamp='f44e0667-8c6a-4c6d-9456-910d2df7e59f'
	, ProfileName='default'
	, RoleId='admins'
	, CultureId='es-ES'
	, OriginId=1
where Name='Admin'
GO



if not exists (select * from [ContextVars] where VarName='usuariosTV') BEGIN
    INSERT INTO [dbo].[ContextVars]
           ([VarName]
           ,[VarSQL]
           ,[Order]
           ,[ConnStringId]
           ,[OriginId])
     VALUES
           ('usuariosTV'
           ,'select RoleId, Email, UserName, Reference, Name, SurName from AspNetUsers for JSON AUTO'
           ,0
           ,'ConfConnectionString'
           ,1)
END
GO
