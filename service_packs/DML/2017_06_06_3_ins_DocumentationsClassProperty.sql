SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/* add new properties for weightsheets*/
insert into [dbo].[DocumentationsClassProperty]
	([Description]
	,[Value]
	,[DocumentationsClassProperty]
	,[DocumentationsClassID])
select
	 T1.[Description]
	,null
	,null
	,DC.ID
from (values
(N'Номер отвесной'),
(N'Весовщик'),
(N'Весы')
) as T1 ([Description])
join [dbo].[DocumentationsClass] DC
on DC.ParentID = (select top 1 ID from [dbo].[DocumentationsClass] where Description = N'Отвесная')

union all

select
	 T1.[Description]
	,null
	,null
	,DC.ID
from (values
(N'Цех отправления'),
(N'Цех получения')
) as T1 ([Description])
join [dbo].[DocumentationsClass] DC
on DC.ParentID = (select top 1 ID from [dbo].[DocumentationsClass] where Description = N'Отвесная') and DC.[Description] not in (N'Тарирование')


GO