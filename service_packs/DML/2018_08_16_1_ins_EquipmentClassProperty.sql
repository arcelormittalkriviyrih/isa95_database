/*insert new properties for Printers and WeightBridges into [EquipmentClassProperty]*/
insert into [dbo].[EquipmentClassProperty]
([Description]
,[Value]
,[EquipmentClassID])
select
	 T.[Description]
	,T.[Value]
	,(select top 1 [ID] from [dbo].[EquipmentClass] where [Description] = N'Принтеры') as [EquipmentClassID]
from (
values 
(N'Ориентация бумаги: альбом', N'PAPER_ORIENTATION_LANDSCAPE'),
(N'Размер бумаги', N'PAPER_SIZE'),
(N'Количество копий', N'COPIES')
) as T([Description], [Value])

union all

select
	 T.[Description]
	,T.[Value]
	,(select top 1 [ID] from [dbo].[EquipmentClass] where [Description] = N'Весы') as [EquipmentClassID]
from (
values 
(N'Настройки принтера', N'PRINTER_SETTINGS')
) as T([Description], [Value])
