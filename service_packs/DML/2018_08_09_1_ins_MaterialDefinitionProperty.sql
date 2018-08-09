
/*fix types of Scrap [MaterialDefinitionProperty] */

update [dbo].[MaterialDefinitionProperty]
set [Value] = N'140000'+[Value] 
where [Description] = N'Вид лома' and [Value] not like N'140000%'

GO
