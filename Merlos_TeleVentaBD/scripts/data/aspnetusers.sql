

BEGIN TRY

MERGE INTO [AspNetUsers] AS Target
USING (VALUES
  (N'1',N'admins',N'default',N'e.jene@merlos.net',1,N'ALBaGB8NK2kVq0eotHJ7v0G9KbYVR8WfRmipGjFUAOXD9jw4nUsStY+yn/eee/FSeQ==',N'f44e0667-8c6a-4c6d-9456-910d2df7e59f',NULL,0,0,NULL,1,0,N'admin',NULL,N'0',N'0',N'~/img/Avatars/avatar_blank.png',N'Admin',N'Admin',N'Admin',N'es-ES',NULL,NULL,0,0,50,0,60,1)
 ,(N'dc21cdac-5595-43c2-b4cd-1eb663f59ac9',N'TeleVenta',N'default',N'soporteapps@merlos.net',0,N'AAV8hh8z3HzFCazXR3WbMpctoAv+fC0VPkykoAmw3xB9d32JW6AV5yv6aBx8gJwIRA==',N'20c222fd-c52d-4c36-b70f-7f349ec414e4',N'',0,0,NULL,1,0,N'test',NULL,N'T1',N'',N'~/img/Avatars/avatar_blank.png',N'test',N'test',N'',N'es-es',NULL,NULL,0,0,50,0,60,1)
) AS Source ([Id],[RoleId],[ProfileName],[Email],[EmailConfirmed],[PasswordHash],[SecurityStamp],[PhoneNumber],[PhoneNumberConfirmed],[TwoFactorEnabled],[LockoutEndDateUtc],[LockoutEnabled],[AccessFailedCount],[UserName],[IPGroup],[Reference],[SubReference],[Avatar],[Name],[SurName],[NickName],[CultureId],[MailAccountId],[Mode],[MustChangePassword],[BackLocation],[LocationRadius],[Locked],[Inaccuracy],[OriginId])
ON (Target.[Id] = Source.[Id])
WHEN MATCHED AND (
	NULLIF(Source.[RoleId], Target.[RoleId]) IS NOT NULL OR NULLIF(Target.[RoleId], Source.[RoleId]) IS NOT NULL OR 
	NULLIF(Source.[ProfileName], Target.[ProfileName]) IS NOT NULL OR NULLIF(Target.[ProfileName], Source.[ProfileName]) IS NOT NULL OR 
	NULLIF(Source.[Email], Target.[Email]) IS NOT NULL OR NULLIF(Target.[Email], Source.[Email]) IS NOT NULL OR 
	NULLIF(Source.[EmailConfirmed], Target.[EmailConfirmed]) IS NOT NULL OR NULLIF(Target.[EmailConfirmed], Source.[EmailConfirmed]) IS NOT NULL OR 
	NULLIF(Source.[PasswordHash], Target.[PasswordHash]) IS NOT NULL OR NULLIF(Target.[PasswordHash], Source.[PasswordHash]) IS NOT NULL OR 
	NULLIF(Source.[SecurityStamp], Target.[SecurityStamp]) IS NOT NULL OR NULLIF(Target.[SecurityStamp], Source.[SecurityStamp]) IS NOT NULL OR 
	NULLIF(Source.[PhoneNumber], Target.[PhoneNumber]) IS NOT NULL OR NULLIF(Target.[PhoneNumber], Source.[PhoneNumber]) IS NOT NULL OR 
	NULLIF(Source.[PhoneNumberConfirmed], Target.[PhoneNumberConfirmed]) IS NOT NULL OR NULLIF(Target.[PhoneNumberConfirmed], Source.[PhoneNumberConfirmed]) IS NOT NULL OR 
	NULLIF(Source.[TwoFactorEnabled], Target.[TwoFactorEnabled]) IS NOT NULL OR NULLIF(Target.[TwoFactorEnabled], Source.[TwoFactorEnabled]) IS NOT NULL OR 
	NULLIF(Source.[LockoutEndDateUtc], Target.[LockoutEndDateUtc]) IS NOT NULL OR NULLIF(Target.[LockoutEndDateUtc], Source.[LockoutEndDateUtc]) IS NOT NULL OR 
	NULLIF(Source.[LockoutEnabled], Target.[LockoutEnabled]) IS NOT NULL OR NULLIF(Target.[LockoutEnabled], Source.[LockoutEnabled]) IS NOT NULL OR 
	NULLIF(Source.[AccessFailedCount], Target.[AccessFailedCount]) IS NOT NULL OR NULLIF(Target.[AccessFailedCount], Source.[AccessFailedCount]) IS NOT NULL OR 
	NULLIF(Source.[UserName], Target.[UserName]) IS NOT NULL OR NULLIF(Target.[UserName], Source.[UserName]) IS NOT NULL OR 
	NULLIF(Source.[IPGroup], Target.[IPGroup]) IS NOT NULL OR NULLIF(Target.[IPGroup], Source.[IPGroup]) IS NOT NULL OR 
	NULLIF(Source.[Reference], Target.[Reference]) IS NOT NULL OR NULLIF(Target.[Reference], Source.[Reference]) IS NOT NULL OR 
	NULLIF(Source.[SubReference], Target.[SubReference]) IS NOT NULL OR NULLIF(Target.[SubReference], Source.[SubReference]) IS NOT NULL OR 
	NULLIF(Source.[Avatar], Target.[Avatar]) IS NOT NULL OR NULLIF(Target.[Avatar], Source.[Avatar]) IS NOT NULL OR 
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL OR 
	NULLIF(Source.[SurName], Target.[SurName]) IS NOT NULL OR NULLIF(Target.[SurName], Source.[SurName]) IS NOT NULL OR 
	NULLIF(Source.[NickName], Target.[NickName]) IS NOT NULL OR NULLIF(Target.[NickName], Source.[NickName]) IS NOT NULL OR 
	NULLIF(Source.[CultureId], Target.[CultureId]) IS NOT NULL OR NULLIF(Target.[CultureId], Source.[CultureId]) IS NOT NULL OR 
	NULLIF(Source.[MailAccountId], Target.[MailAccountId]) IS NOT NULL OR NULLIF(Target.[MailAccountId], Source.[MailAccountId]) IS NOT NULL OR 
	NULLIF(Source.[Mode], Target.[Mode]) IS NOT NULL OR NULLIF(Target.[Mode], Source.[Mode]) IS NOT NULL OR 
	NULLIF(Source.[MustChangePassword], Target.[MustChangePassword]) IS NOT NULL OR NULLIF(Target.[MustChangePassword], Source.[MustChangePassword]) IS NOT NULL OR 
	NULLIF(Source.[BackLocation], Target.[BackLocation]) IS NOT NULL OR NULLIF(Target.[BackLocation], Source.[BackLocation]) IS NOT NULL OR 
	NULLIF(Source.[LocationRadius], Target.[LocationRadius]) IS NOT NULL OR NULLIF(Target.[LocationRadius], Source.[LocationRadius]) IS NOT NULL OR 
	NULLIF(Source.[Locked], Target.[Locked]) IS NOT NULL OR NULLIF(Target.[Locked], Source.[Locked]) IS NOT NULL OR 
	NULLIF(Source.[Inaccuracy], Target.[Inaccuracy]) IS NOT NULL OR NULLIF(Target.[Inaccuracy], Source.[Inaccuracy]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [RoleId] = Source.[RoleId], 
  [ProfileName] = Source.[ProfileName], 
  [Email] = Source.[Email], 
  [EmailConfirmed] = Source.[EmailConfirmed], 
  [PasswordHash] = Source.[PasswordHash], 
  [SecurityStamp] = Source.[SecurityStamp], 
  [PhoneNumber] = Source.[PhoneNumber], 
  [PhoneNumberConfirmed] = Source.[PhoneNumberConfirmed], 
  [TwoFactorEnabled] = Source.[TwoFactorEnabled], 
  [LockoutEndDateUtc] = Source.[LockoutEndDateUtc], 
  [LockoutEnabled] = Source.[LockoutEnabled], 
  [AccessFailedCount] = Source.[AccessFailedCount], 
  [UserName] = Source.[UserName], 
  [IPGroup] = Source.[IPGroup], 
  [Reference] = Source.[Reference], 
  [SubReference] = Source.[SubReference], 
  [Avatar] = Source.[Avatar], 
  [Name] = Source.[Name], 
  [SurName] = Source.[SurName], 
  [NickName] = Source.[NickName], 
  [CultureId] = Source.[CultureId], 
  [MailAccountId] = Source.[MailAccountId], 
  [Mode] = Source.[Mode], 
  [MustChangePassword] = Source.[MustChangePassword], 
  [BackLocation] = Source.[BackLocation], 
  [LocationRadius] = Source.[LocationRadius], 
  [Locked] = Source.[Locked], 
  [Inaccuracy] = Source.[Inaccuracy], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([Id],[RoleId],[ProfileName],[Email],[EmailConfirmed],[PasswordHash],[SecurityStamp],[PhoneNumber],[PhoneNumberConfirmed],[TwoFactorEnabled],[LockoutEndDateUtc],[LockoutEnabled],[AccessFailedCount],[UserName],[IPGroup],[Reference],[SubReference],[Avatar],[Name],[SurName],[NickName],[CultureId],[MailAccountId],[Mode],[MustChangePassword],[BackLocation],[LocationRadius],[Locked],[Inaccuracy],[OriginId])
 VALUES(Source.[Id],Source.[RoleId],Source.[ProfileName],Source.[Email],Source.[EmailConfirmed],Source.[PasswordHash],Source.[SecurityStamp],Source.[PhoneNumber],Source.[PhoneNumberConfirmed],Source.[TwoFactorEnabled],Source.[LockoutEndDateUtc],Source.[LockoutEnabled],Source.[AccessFailedCount],Source.[UserName],Source.[IPGroup],Source.[Reference],Source.[SubReference],Source.[Avatar],Source.[Name],Source.[SurName],Source.[NickName],Source.[CultureId],Source.[MailAccountId],Source.[Mode],Source.[MustChangePassword],Source.[BackLocation],Source.[LocationRadius],Source.[Locked],Source.[Inaccuracy],Source.[OriginId])
WHEN NOT MATCHED BY SOURCE AND TARGET.OriginId = 1 THEN 
 DELETE
;
END TRY
BEGIN CATCH
    DECLARE @ERRORNUMBER	INT,@ERRORMSG		VARCHAR(MAX),@ERRORSTATE		INT
    SELECT @ERRORNUMBER = 50000 + ERROR_NUMBER(),@ERRORMSG = ERROR_MESSAGE(), @ERRORSTATE = ERROR_STATE();
    THROW @ERRORNUMBER, @ERRORMSG, @ERRORSTATE
END CATCH
GO





