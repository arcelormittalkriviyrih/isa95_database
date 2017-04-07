SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO
/*add new class properties*/
insert into [dbo].[EquipmentClassProperty]
([Description],[Value],[EquipmentClassID])
values
(N'Грузоотправитель',N'CONSIGNER',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха')),
(N'Грузополучатель' ,N'CONSIGNEE',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха'))
GO