SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

update [dbo].[Equipment]
set [Description] = N'Керамет-Украина Копр.№4'
where [Description] = N'Керамет Копр.№4'

GO