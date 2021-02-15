

BEGIN TRY

MERGE INTO [Objects_Views_Properties] AS Target
USING (VALUES
  (N'IncidenciasArticulo',N'IncidenciasArticuloDefaultList',N'IncidenciasArticulo',N'codigo',N'IncidenciasArticulo',0,N'codigo_1',1)
 ,(N'IncidenciasArticulo',N'IncidenciasArticuloDefaultList',N'IncidenciasArticulo',N'nombre',N'IncidenciasArticulo',1,N'nombre',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'Email',N'sysUser',5,N'Email',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'EmailConfirmed',N'sysUser',6,N'Email Confirmed',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'Name',N'sysUser',0,N'Name',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'PhoneNumber',N'sysUser',4,N'Phone Number',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'ProfileName',N'sysUser',3,N'Profile',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'RoleId',N'sysUser',2,N'Role',1)
 ,(N'sysUser',N'sysUserDefaultList',N'sysUser',N'SurName',N'sysUser',1,N'SurName',1)
) AS Source ([ObjectName],[ViewName],[ObjectPropertyName],[PropertyName],[ObjectPath],[Order],[Label],[OriginId])
ON (Target.[ObjectName] = Source.[ObjectName] AND Target.[ViewName] = Source.[ViewName] AND Target.[ObjectPropertyName] = Source.[ObjectPropertyName] AND Target.[PropertyName] = Source.[PropertyName])
WHEN MATCHED AND (
	NULLIF(Source.[ObjectPath], Target.[ObjectPath]) IS NOT NULL OR NULLIF(Target.[ObjectPath], Source.[ObjectPath]) IS NOT NULL OR 
	NULLIF(Source.[Order], Target.[Order]) IS NOT NULL OR NULLIF(Target.[Order], Source.[Order]) IS NOT NULL OR 
	NULLIF(Source.[Label], Target.[Label]) IS NOT NULL OR NULLIF(Target.[Label], Source.[Label]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [ObjectPath] = Source.[ObjectPath], 
  [Order] = Source.[Order], 
  [Label] = Source.[Label], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ObjectName],[ViewName],[ObjectPropertyName],[PropertyName],[ObjectPath],[Order],[Label],[OriginId])
 VALUES(Source.[ObjectName],Source.[ViewName],Source.[ObjectPropertyName],Source.[PropertyName],Source.[ObjectPath],Source.[Order],Source.[Label],Source.[OriginId])
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





