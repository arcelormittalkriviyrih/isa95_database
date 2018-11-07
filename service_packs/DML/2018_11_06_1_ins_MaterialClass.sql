SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

-- insert MaterialClass
insert into [dbo].[MaterialClass] ([Description], [ParentID], [Code])
values
 (N'Готовая продукция', null, N'Finished Products')
,(N'Сырье', null, N'Raw Material')


GO