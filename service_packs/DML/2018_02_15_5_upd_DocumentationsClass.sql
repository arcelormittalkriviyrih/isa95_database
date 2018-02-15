SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/* Change name of some types of Weightsheets */
update DC
set [Description] = case DC.[Description] 
						when N'Загрузка' then N'Погрузка'
						when N'Отгрузка' then N'Разгрузка'
						else DC.[Description]
					end
from [dbo].[DocumentationsClass] DC
left join [dbo].[DocumentationsClass] DC1
on DC.[ParentID] = DC1.[ID]
where DC1.[Description] = N'Отвесная'

GO