Update [Objects_Search] set [SQLSentence]='( EXISTS (
 SELECT * FROM [dbo].[Plugins] FlxTblFilter 

 WHERE ( [Plugins].[Descrip]  LIKE {~@Param1|16|102|FindString~} 
)
 AND  [Plugins].[PluginId] = [FlxTblFilter].[PluginId] 

))
' where [SearchId]=N'8D852292-E508-4BC4-A73C-579D8F76262D'
