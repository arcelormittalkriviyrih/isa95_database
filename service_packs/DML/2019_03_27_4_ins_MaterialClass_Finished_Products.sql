SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

-- insert (MERGE) MaterialClass

 		merge [dbo].[MaterialClass] as trg 
		using
		(SELECT  N'Готовая продукция' [Description] , NULL [ParentID] , N'Finished Products' [Code]) as t2
		on (trg.[Description]=t2.[Description] and trg.[Code]=t2.[Code])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [ParentID] ,[Code]) VALUES (t2.[Description], t2.[ParentID], t2.[Code]);

GO